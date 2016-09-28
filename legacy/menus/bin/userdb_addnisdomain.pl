#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_addnisdomain.pl,v 1.9 2008/05/09 05:35:40 liq Exp $"

#    Function: add nis domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:
#            fstype           ----- "sxfs"|"sxfsfw"
#            eg               ----- fullpath of export group  eg:"/export/zhangjx"
#            g_num            ----- "0" | "1"
#            nisdomain        ----- nisdomain name
#            nisserver        ----- nisserver name or IP
#            ntdomain         ----- domain name
#            netbios          ----- computer name
#            isFriend         ----- "true"|"false"
#
#    Return value:
#            0 , if succeed
#            1 , if failed
#            6 , iptables failed
#            255,parameter failed

use strict;
use NS::SystemFileCVS;
use NS::USERDBCommon;
use NS::USERDBConst;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
my $ssComm = new NS::ScheduleScanCommon;
if(scalar(@ARGV)!=8)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 8 parameters.\n";
    print "Usage: \n",__FILE__," <sxfs|sxfsfw> <export group> <groupNo> <NIS domain> <NIS server> <NT Domain> <NetBIOS> <isFriend=true|false>\n";
    exit(255);
}

my ($fstype, $eg, $g_num, $nisdomain, $nisserver, $ntdomain, $netbios, $isFriend) = @ARGV;

$ntdomain = uc($ntdomain);
$netbios  = uc($netbios);

my $COM = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $COM->COMMAND_NSGUI_SYNCWRITE_O;

my $udb_comm = new NS::USERDBCommon;
my $udb_const = new NS::USERDBConst();
my $cifsCommon = new NS::CIFSCommon;
my $GLOBAL_DIR = "/etc/group${g_num}/nas_cifs/DEFAULT";
my $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntdomain};
my $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";
my $YPCONF_FILE = "/etc/yp.conf";
my $IMS_CONF_FILE = "/etc/group${g_num}/ims.conf";
my $cmd = "";

#if it's sxfsfw, make domain dir and smb.conf file on self node
if ($isFriend eq "false" && $fstype eq "sxfsfw"){
    my $interface = "";
    my @toe = $cifsCommon->getUnusedInterfaces($g_num);
    if(scalar(@toe)>0){
        $interface = $toe[0];
    }else{
        print STDERR "There are not any interfaces which can be used. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 8;
    }

    (-d $DOMAIN_DIR)     || system("mkdir -p ${DOMAIN_DIR}");
    (-f $SMBPASSWD_FILE) || system("touch ${SMBPASSWD_FILE}");
    (-f $VIRTUAL_FILE)   || system("touch ${VIRTUAL_FILE}");

    my $codePage = $udb_comm->getExpgrpCodePage($g_num,$eg);

    my $checkDirectHosting = $udb_comm->checkDirectHostingForConsistency($g_num);
    my @global_content = (
            "[global]\n",
            "unix charset = ${codePage}\n",
            "encrypt passwords = no\n",
            "log file = %L-%m.log\n",
            "log level = 0\n",
            "server string = \"\"\n",
            "deadtime = 15\n",
            "security = user\n",
            "workgroup = ${ntdomain}\n",
            "smb passwd file = %r%D/smbpasswd.%L\n");
            
    push(@global_content,$udb_const->ALWAYS_CAP_W2K_SMBS);
            
    if ($interface ne ""){
        push(@global_content,"interfaces = $interface\n");
        push(@global_content,"bind interfaces only = yes\n");
    }
    push(@global_content,"pam service name = xsmbd_ims\n");
    push(@global_content,"nt acl support = yes\n");
    #Set direct hosting when the direct hosting is set in friend node.
    if($checkDirectHosting eq "yes"){
        push(@global_content,$udb_const->SMB_PORTS);
    }
    #write smb.conf.<netbios>
    open(FILE,"| ${cmd_syncwrite_o} ${SMB_CONF_FILE}");
    print FILE @global_content;
    if(!close(FILE)){
	
        print STDERR  " Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

    #write "sid machine prefix" line into smb.conf.<netbios>
    if (system("/usr/bin/smbpasswd -S -g DEFAULT -l ${ntdomain} -L ${netbios} -G /etc/group${g_num}/nas_cifs >&/dev/null")){
        system("rm -f ${SMB_CONF_FILE}");
        print STDERR  "Failed to build sid machine prefix. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

#write nisdomain nisserver into yp.conf on both node
$COM->checkout($YPCONF_FILE);
my @replace_cmd = ("/home/nsadmin/bin/mapd_replace.pl","/home/nsadmin/bin/nsgui_iptables.sh",$YPCONF_FILE,$nisdomain,"\Q$nisserver\E");
my @result = `@replace_cmd`;
chomp(@result);
if ($? > 0){
    if ($isFriend eq "false" && $fstype eq "sxfsfw"){
        system("rm -f ${SMB_CONF_FILE}");

	}
    $COM->rollback($YPCONF_FILE);
    print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if ($result[0] ne "0"){
    $udb_comm->rollbackIPtable(\@result);
    if ($isFriend eq "false" && $fstype eq "sxfsfw"){
        system("rm -f ${SMB_CONF_FILE}");

    }
    $COM->rollback($YPCONF_FILE);
    if ($result[0] eq "2"){
        exit 6;
    } else{
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}


#ypbind restart.If it is failed, rollback
if(system("/etc/rc.d/init.d/ypbind restart")){
    $udb_comm->rollbackIPtable(\@result);
    if ($isFriend eq "false" && $fstype eq "sxfsfw"){
        system("rm -f ${SMB_CONF_FILE}");

    }
    $COM->rollback($YPCONF_FILE);
    print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}





if ($isFriend eq "false"){
#add nis domain defination for auth on self node
    #get export group short name /export/zhangjx -> zhangjx
    my @export = split("/",$eg);
    my $eg_short = $export[2];
    my $stdout = "";
    my $region = "";

    if ($fstype eq "sxfsfw"){
       my $sid = `cat ${SMB_CONF_FILE} | awk -F \"=\" '{if(\$1 ~ /sid machine prefix/) print \$2}'`;
       chomp(${sid});
       $sid =~ s/\s+//g;#trim sid
       $cmd = "/usr/bin/ims_domain -A ${eg_short} nis -o domain=${nisdomain} -o sidprefix=${sid} -f -c ${IMS_CONF_FILE}";
    } else{
       $cmd = "/usr/bin/ims_domain -A ${eg_short} nis -o domain=${nisdomain} -f -c ${IMS_CONF_FILE}";
    }

    $stdout = `$cmd`;
    chomp(${stdout});
    if ($? > 0){
        if ($fstype eq "sxfsfw"){
            system("rm -f ${SMB_CONF_FILE}");
        };

        $COM->rollback($YPCONF_FILE);
        $udb_comm->rollbackIPtable(\@result);
        system("/etc/rc.d/init.d/ypbind restart");
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    #region will be used when set auth to mount point
    $region = (split(/\s+/,${stdout}))[0];

#add auth domain for all direct mount piont with the same type
#in the specified export
    $udb_comm->addExportGroupAuthByType($eg,$g_num,$fstype,$region);
}

$COM->checkin($YPCONF_FILE);
if ($fstype eq "sxfsfw"){
    #write export ntDomain and netbios into virtual_servers
    if ($isFriend eq "false"){
        #my @virtual_servers_content = `cat ${VIRTUAL_FILE} | awk -F \" \" '{if(\$1 != \"${eg}\") print \$0}'`;
        #modify for the changing of the VS file's format at 2008/05/06
    
        my @virtual_servers_content = `cat ${VIRTUAL_FILE} 2>/dev/null`;
        my $ssVSContent = $ssComm->getVSContent4ScheduleScan(\@virtual_servers_content);
        @virtual_servers_content = `/home/nsadmin/bin/nsgui_getVSContent.pl ${g_num} |awk -F \" \" '{if(\$1 != \"${eg}\") print \$0}'`;
        open(VSFILE,"| ${cmd_syncwrite_o} ${VIRTUAL_FILE}");
        push(@virtual_servers_content,"$eg $ntdomain $netbios\n");
        push (@virtual_servers_content,@$ssVSContent);
        print VSFILE @virtual_servers_content;
        if(!close(VSFILE)){
		print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
		exit(1);
		
	};
        system("/home/nsadmin/bin/ns_nascifsstart.sh");
    }

    #check whether the specified native is exist
    if($udb_comm->isNativeExist($g_num,$ntdomain."+".$netbios,"win","nis") == 0){
       #Add nis domain for native on both node, no rollback
        my $native_stdout=`/usr/bin/ims_domain -A .${g_num} nis -o domain=${nisdomain} -f -c ${IMS_CONF_FILE}`;
        if($? == 0){#native domain succeed
            my $native_region = (split(/\s+/,${native_stdout}))[0];
            system("/usr/bin/ims_native","-A",${native_region},"-n.","-r",$ntdomain."+".$netbios,"-f","-c", ${IMS_CONF_FILE});
        }
    }
}
system("/home/nsadmin/bin/nsgui_iptables_save.sh");
exit 0;
