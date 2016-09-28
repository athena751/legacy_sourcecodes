#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_addpwddomain.pl,v 1.11 2008/05/09 05:36:18 liq Exp $"

#    Function: add pwd domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            groupN           ----- "0" | "1"
#            exportGroup      ----- fullpath of export group  eg--"/export/liq"
#            domainType       ----- "sxfs" | "sxfsfw"
#            ludbName         ----- luba name
#            ntDomain         ----- ntDomain name
#            netbios          ----- ntbios name
#
#    Return value:
#           0 , if succeed
#           1 , if failed

use strict;
use NS::SystemFileCVS;
use NS::USERDBCommon;
use NS::USERDBConst;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
my $ssComm = new NS::ScheduleScanCommon;
if(scalar(@ARGV)!=7)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 7 parameters.\n";
    print "Usage:",__FILE__," isFriend  groupN exportGroup, domainType, ludbName, ntDomain, netbios\n";
    exit(1);
}

my ($isFriend, $groupN, $exportGroup, $domainType, $ludbName, $ntDomain, $netbios) = @ARGV;

$ntDomain = uc($ntDomain);
$netbios  = uc($netbios);

my $COM = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $COM->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_a = $COM->COMMAND_NSGUI_SYNCWRITE_A;

my $UDB = new NS::USERDBCommon;
my $udb_const = new NS::USERDBConst();
my $cifsCommon = new NS::CIFSCommon;

my $GLOBAL_DIR = "/etc/group${groupN}/nas_cifs/DEFAULT";
my $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntDomain};
my $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";
my $LUDB_CONF_FILE = "/etc/group${groupN}/ludb.info";
my $IMS_CONF_FILE = "/etc/group${groupN}/ims.conf";

# get available interface
my $interface = "";
if ($isFriend eq "false" && $domainType eq "sxfsfw"){
    my @toe = $cifsCommon->getUnusedInterfaces($groupN);
    if(scalar(@toe)>0){
        $interface = $toe[0];
    }else{
        print STDERR "There are not any interfaces which can be used. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 8;
    }
}

#first get the ludbroot
my $cmd = "/usr/bin/ludb_admin root";
my $ludbroot="/etc/group${groupN}/ludb_region";
my @ludbcontent = `$cmd 2>/dev/null`;
chomp(@ludbcontent);
if($?){
    print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}else{
    if ($ludbcontent[0] ne ""){
        $ludbroot= $ludbcontent[0];
    }
}


#get export group short name /export/public -> public

my $export_short = (split("/",$exportGroup))[2];

my $sid="";

#Step1
#creat smbpasswd file(when sxfsfw && selfnode)
if ($isFriend eq "false" && $domainType eq "sxfsfw"){
    (-d $DOMAIN_DIR)      || system("mkdir -p ${DOMAIN_DIR}");
    (-f $SMBPASSWD_FILE ) || system("touch ${SMBPASSWD_FILE}");
    (-f $VIRTUAL_FILE )   || system("touch ${VIRTUAL_FILE}");

    #get code page for global section in file smb.conf.netbios.
    my $CodePage = $UDB->getExpgrpCodePage(${groupN},${exportGroup});

    my $checkDirectHosting = $UDB->checkDirectHostingForConsistency($groupN);
    # generate the global section content for cifs
    my @global_content = (
        "[global]\n",
        "unix charset = ${CodePage}\n",
        "encrypt passwords = yes\n",
        "log file = %L-%m.log\n",
        "log level = 0\n",
        "server string = \"\"\n",
        "deadtime = 15\n"
    );
    
    push(@global_content,$udb_const->ALWAYS_CAP_W2K_SMBS);
    
    if($interface ne ""){
        push(@global_content,"interfaces = ${interface}\n");
        push(@global_content,"bind interfaces only = yes\n");
    }
    push(@global_content,"security = user\n");
    push(@global_content,"workgroup = ${ntDomain}\n");
    push(@global_content,"smb passwd file = ${ludbroot}/.nas_cifs/%r/%D/smbpasswd.%L\n");
    push(@global_content,"nt acl support = yes\n");
    #Set direct hosting when the direct hosting is set in friend node.
    if($checkDirectHosting eq "yes"){
        push(@global_content,$udb_const->SMB_PORTS);
    }
    #write smb.conf.<netbios>
    open(FILE,"| ${cmd_syncwrite_o} ${SMB_CONF_FILE}");
    print FILE @global_content;
    if(!close(FILE)){
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

    #write "sid machine prefix" line
    if(system("/usr/bin/smbpasswd -S -g DEFAULT -l ${ntDomain} -L ${netbios} -G /etc/group${groupN}/nas_cifs >/dev/null")){
        system("rm -f ${SMB_CONF_FILE}");
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }

    #get sid from smb.conf.<netbios>
    $sid = `cat ${SMB_CONF_FILE} | awk -F \"=\" '{if(\$1 ~ /sid machine prefix/) print \$2}'`;
    chomp(${sid});
    $sid =~ s/\s+//g;

    #write ntDomain and netbios into virtual_servers
    if($COM->checkout($VIRTUAL_FILE)!=0){
        system("rm -f ${SMB_CONF_FILE}");
        print STDERR "Failed to checkout \"$VIRTUAL_FILE\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    #my @virtual_servers_content = `cat ${VIRTUAL_FILE} | awk -F \" \" '{if(\$1 != \"${exportGroup}\") print \$0}'`;
    #modify for the changing of the VS file's format at 2008/05/06
    my @virtual_servers_content = `cat ${VIRTUAL_FILE} 2>/dev/null`;
    my $ssVSContent = $ssComm->getVSContent4ScheduleScan(\@virtual_servers_content);
    @virtual_servers_content = `/home/nsadmin/bin/nsgui_getVSContent.pl $groupN | awk -F \" \" '{if(\$1 != \"${exportGroup}\") print \$0}'`;
    push (@virtual_servers_content,"${exportGroup} ${ntDomain} ${netbios}\n");
    push (@virtual_servers_content,@$ssVSContent);    
    
    open(VF,"| ${cmd_syncwrite_o} ${VIRTUAL_FILE}");
    print VF @virtual_servers_content;
    if(!close(VF)){
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

}
#end Step1

#Step2
#add link
#delete by liq [nsgui-necas-sv4:11136] 2005/11/1
#delete [link for userdatabase domain]
#end Step2

#Step3
#write ludbname into ludb.info (selfnode only)
#delete by liq [nsgui-necas-sv4:11136] 2005/11/1
#delete [add userdatabase's dir in ludb.info]

#end Step3

#Step4
#add PWD domain defination (selfnode only for userdb)
my $region="";

my $AUTH_PATH_DIR = "${ludbroot}/.ludb/${ludbName}";
my $AUTH_PASSWD_PATH = "${AUTH_PATH_DIR}/passwd";
my $AUTH_GROUP_PATH = "${AUTH_PATH_DIR}/group";


if ($isFriend eq "false"){
    my @cmd_adddomain = ("/usr/bin/ims_domain","-A","${export_short}","pwd");
    my @cmd_options =("-o","passwd=\Q${AUTH_PASSWD_PATH}\E" ,
                  "-o","group=\Q${AUTH_GROUP_PATH}\E");

    if ($sid ne ""){
        push(@cmd_options,("-o","\Qsidprefix=${sid}\E"));
    }
    push(@cmd_adddomain,@cmd_options);
    push(@cmd_adddomain,("-f", "-c", $IMS_CONF_FILE));

    my $stdout = `@cmd_adddomain`;

    if($?){# command ims_domain -A is failed.
        if ($domainType eq "sxfsfw"){
            $COM->rollback($VIRTUAL_FILE);
            system("rm -f ${SMB_CONF_FILE}");
        }
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    chomp(${stdout});
    my @tmp_array = split(/\s+/,${stdout});
    $region = @tmp_array[0];
}
#end Step4

#Step5
#run /home/nsadmin/bin/ns_nascifsstart.sh to make it useful.
#(sxfsfw and selfnode)
if ($isFriend eq "false" && $domainType eq "sxfsfw"){
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
}
#end Step5


#Step6
#and checkin /etc/groupN/ludb.info
#delete by liq [nsgui-necas-sv4:11136] 2005/11/1
#delete [checkin /etc/groupN/ludb.info]
#end Step6

#Step7
#execute ims_auth -A for Dmount under this export.(only selfnode)
if ($isFriend eq "false" && $region ne ""){
    $UDB->addExportGroupAuthByType($exportGroup,$groupN,$domainType,$region);

}
#end Step7

if ($isFriend eq "false" && $domainType eq "sxfsfw"){
    $COM->checkin($VIRTUAL_FILE);
}


#Step8
#another link (sxfsfw only, for clientudb)
if ($domainType eq "sxfsfw"){
    my $LINK_TARGET2 = "${ludbroot}/.ludb/${ludbName}/smbpasswd";
    (-f $LINK_TARGET2)  || system("touch  ${LINK_TARGET2}");

    my $LINK_FILE2_DIR = "${ludbroot}/.nas_cifs/DEFAULT/${ntDomain}";
    (-d $LINK_FILE2_DIR)  || system("mkdir -p ${LINK_FILE2_DIR}");

    my $LINK_FILE2 = "$LINK_FILE2_DIR/smbpasswd.${netbios}";
    system("rm -f $LINK_FILE2");
    
    system("/bin/ln -s $LINK_TARGET2 $LINK_FILE2");
}
#end Step8


#Step9
#write ludbname into ludb.info (bothnode)
if ($domainType eq "sxfsfw"){
    (-f $LUDB_CONF_FILE ) || system("touch ${LUDB_CONF_FILE}");
    if($COM->checkout($LUDB_CONF_FILE)!=0){
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 0; #ignore native failure
    }

    open(WCONF,"| ${cmd_syncwrite_a} $LUDB_CONF_FILE");
    print WCONF ("$ludbName ${ludbroot}/.nas_cifs/DEFAULT/${ntDomain}/smbpasswd.${netbios}\n");
    if(!close(WCONF)){
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };
}
#end Step9



#Step10
#execute ims_domain -A(for ClientUDB) and ims_native -A
my $NATIVE_PATH_DIR = "${ludbroot}/.ludb/${ludbName}";
my $NATIVE_PASSWD_PATH = "${NATIVE_PATH_DIR}/passwd";
my $NATIVE_GROUP_PATH = "${NATIVE_PATH_DIR}/group";

my $ntdomain_netbios = $ntDomain."+".$netbios;
my $exist_this_native = $UDB->isNativeExist($groupN, $ntdomain_netbios, "win", "pwd");
if ($domainType eq "sxfsfw" && $exist_this_native == 0){
    my @cmd2 = ("/usr/bin/ims_domain","-A",".${groupN}","pwd"
                ,"-o"
                ,"passwd=\Q${NATIVE_PASSWD_PATH}\E"
                ,"-o"
                ,"group=\Q${NATIVE_GROUP_PATH}\E"
                ,"-f"
                ,"-c"
                ,"${IMS_CONF_FILE}");
    my $stout2=`@cmd2`;

    if(!$?){# command ims_domain -A succeed
        chomp(${stout2});
        my @tmp_array = split(/\s+/,${stout2});
        my $region2 = @tmp_array[0];
        my $ret=system("/usr/bin/ims_native","-A","${region2}","-n.","-r","${ntdomain_netbios}","-f","-c","${IMS_CONF_FILE}");
        if ($ret){
            system("/usr/bin/ims_domain","-D","${region2}","-af","-c",${IMS_CONF_FILE});
            $COM->rollback($LUDB_CONF_FILE);
            exit 0;
        }
    }
}
#end Step10
if ($domainType eq "sxfsfw"){
    $COM->checkin($LUDB_CONF_FILE);
}
exit 0;
