#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_addadsdomain.pl,v 1.13 2008/05/09 05:32:37 liq Exp $"
#    Function: add ads domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            exportGroup      ----- fullpath of export group

#            groupNo          ----- "0" | "1"
#            ntDomain
#            netbios
#
#            dns_domain
#            kdc_server
#            join_username
#            join_passwd      ----- from <STDIN>
#
#    Return value:
#           0 , if succeed
#           1 , ims_domain command failed
#           7 , join domain failed.
use strict;
use NS::USERDBCommon;
use NS::USERDBConst;
use NS::MAPDCommon;
use NS::SystemFileCVS;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
my $ssComm = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!= 10){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    print "Usage: ",__FILE__," <isFriend>"," <exportgroup>"," <group no>"," <NT domain>", " <netbios>", " <DNS domain>"," <kdc_server>"," <user name>", " <dc>", " <is Join>";

    exit(1);
}

my ($isFriend,     $export_group,  $group_no,    $ntdomain,
    $netbios,      $dns_domain,    $kdc_server,  $join_username, $dc, $isJoin ) = @ARGV;

$ntdomain = uc($ntdomain);
$netbios  = uc($netbios);
if ($dc eq ""){
    $dc = "*";   
}

if($kdc_server eq ""){ $kdc_server = $dns_domain;}
$dns_domain = uc($dns_domain);

my      $join_passwd = <STDIN>;
chomp($join_passwd);

my $udb_common  = new NS::USERDBCommon();
my $udb_const = new NS::USERDBConst();
my $cifsCommon = new NS::CIFSCommon;

my      $GLOBAL_DIR = "/etc/group${group_no}/nas_cifs/DEFAULT";
my      $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my      $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntdomain};
my      $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my      $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";

my      $IMSCONF_FILE="/etc/group${group_no}/ims.conf";

# get available interface
my $interface = "";
if(${isFriend} eq "false"){
    my @toe = $cifsCommon->getUnusedInterfaces($group_no);
    if(scalar(@toe)>0){
        $interface = $toe[0];
    }else{
        print STDERR "There are not any interfaces which can be used. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 8;
    }
}
my $path = $DOMAIN_DIR."/";
my $MC = new NS::MAPDCommon;
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $KRB5_CONF_FILE = "/etc/krb5.conf";

my $filelist = $MC->getADSSMBFiles($path);

chomp(@$filelist);
push(@$filelist,$KRB5_CONF_FILE);
if(! -f $KRB5_CONF_FILE){
    system("touch $KRB5_CONF_FILE");
}
foreach my $file_out (@$filelist){
    $cvs->checkout($file_out);
}

#update krb5.conf and other ads smb.conf.<netbios>
if(system("/home/nsadmin/bin/mapd_setadsconf.pl","$DOMAIN_DIR/",$dns_domain,$kdc_server,$dc))
{
    foreach my $file_back (@$filelist){
        $cvs->rollback($file_back);
    }

    print STDERR "Update ADS Conf failed. Exit in :",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};

#create smb.conf.<netbios> file at node 0
if(${isFriend} eq "false"){
    (-d ${DOMAIN_DIR})      || system("mkdir -p ${DOMAIN_DIR}");
    (-f ${SMBPASSWD_FILE})  || system("touch ${SMBPASSWD_FILE}");
    (-f ${VIRTUAL_FILE})    || system("touch ${VIRTUAL_FILE}");

    #get code page for global section in file virtual_servers
    my $CodePage = $udb_common->getExpgrpCodePage(${group_no},${export_group});

    my $hostname = "";
    my @myFriend = `/home/nsadmin/bin/getMyFriend.sh`;
    my $friend_ip = $myFriend[0];
    if(($? == 0) and defined($friend_ip)){
        $hostname = `/bin/hostname -s`;
        chomp($hostname);
        $hostname = uc($hostname);
    }
    my $checkDirectHosting = $udb_common->checkDirectHostingForConsistency($group_no);
    
    my $cmd_lic_nvavs = "/usr/sbin/licchk";
    my $nvavs = "nvavs";
    my $checkNvavsLicense="";
	my $exitCode = system("$cmd_lic_nvavs $nvavs >&/dev/null");
    $exitCode = $exitCode >> 8;
    if ($exitCode > 0) {
        $checkNvavsLicense="yes";
    }
    # generate the global section content for cifs
    my @global_content = (
        "[global]\n",
        "unix charset = ${CodePage}\n",
        "encrypt passwords = yes\n",
        "log file = %L-%m.log\n",
        "log level = 0\n",
        "winbind enum groups = yes\n",
        "winbind separator = +\n",
        "template shell = /bin/bash\n",
        "winbind gid = 10000-110000\n",
        "winbind uid = 10000-110000\n" ,
        "server string = \"\"\n",
        "deadtime = 15\n"
        );
    
    push(@global_content,$udb_const->ALWAYS_CAP_W2K_SMBS);

    if($interface ne ""){
        push(@global_content,"interfaces = ${interface}\n");
        push(@global_content,"bind interfaces only = yes\n");
    }
    if($hostname ne ""){ push(@global_content,"netbios name = $hostname\n");}
    push(@global_content,"workgroup = ${ntdomain}\n");
    push(@global_content,"smb passwd file = %r/%D/smbpasswd\n");
    push(@global_content,"nt acl support = yes\n");

    push(@global_content,"password server = $dc\n");
    push(@global_content,"security = ads\n");
    push(@global_content,"realm = $dns_domain\n");

    #Set direct hosting when the direct hosting is set in friend node.
    if($checkDirectHosting eq "yes"){
        push(@global_content,$udb_const->SMB_PORTS);
    }
    #Set virus scan mode when it has the license of nvavs.
    if($checkNvavsLicense eq "yes"){
        push(@global_content,"virus scan mode = yes\n");
    }

    #write smb.conf.<netbios>
    open(FILE,"| ${cmd_syncwrite_o} ${SMB_CONF_FILE}");
    print FILE @global_content;
    if(!close(FILE)){
        print STDERR " Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };


#/usr/bin/nascifsjoin -t ads -j  <domain> -G </etc/groupN/nas_cifs >  -U <user%passwd> -s /etc/groupN/nas_cifs/DEFAULT/domain/smb.conf.netbios
    if ($isJoin eq "true"){
        my @domain_join_cmd = ("/usr/bin/nascifsjoin","-t","ads","-j","$ntdomain",
                                "-G","/etc/group$group_no/nas_cifs",
                                "-U",${join_username}."%".${join_passwd},
                                "-s",$SMB_CONF_FILE);
        if(system(@domain_join_cmd)){
    
            foreach my $file_back (@$filelist){
                $cvs->rollback($file_back);
            }
            system("rm -f $SMB_CONF_FILE");
            print STDERR "Join Domain failed. Exit in :",__FILE__," line:",__LINE__+1,".\n";
            exit 7;
        }
    }

}


#get export group short name /export/public -> public
my $export_short = (split("/",$export_group))[2];

#add ads domain defination for auth and native
#/usr/bin/ims_domain -A <eg-name> ads -o zone=DEFAILT -o workgroup=<ntdomain> -o separator=+ -f -c <imspath>
#/usr/bin/ims_domain -A .<N> ads      -o zone=DEFAULT -o workgroup=<ntdomain> -o separator=+ -f -c  <imspath>

my @cmd_adddomain =("/usr/bin/ims_domain","-A",${export_short},"ads");
my @cmd_options = ("-o","zone=DEFAULT",
                   "-o","workgroup=$ntdomain",
                   "-o","separator=+",
                   "-f","-c",$IMSCONF_FILE);

push(@cmd_adddomain,@cmd_options);



#add domain for auth and get the region of the added domain ,only in node 0

if($isFriend eq "false"){
    my $stdout = "";
    my $region = "";

    $stdout = `@cmd_adddomain`;
    chomp(${stdout});
    # command ims_domain -A is failed.
    if($? > 0){
        system("rm -f ${SMB_CONF_FILE}");
        foreach my $file_back (@$filelist){
            $cvs->rollback($file_back);
        }

        print STDERR "ims_domain -A failed. Exit in :",__FILE__," line:",__LINE__+1,".\n";
       exit 1;
    }

    #region will be used when set auth to mount point
    $region = (split(/\s+/,${stdout}))[0];

    # add auth to direct mount point under export group directory at node 0
    #/usr/bin/ims_auth -A <region> -d <mp> -f -c <imspath>
    $udb_common->addExportGroupAuthByType($export_group,$group_no,"sxfsfw",$region);
}

#write line for export group into virtual_servers in node 0
if(${isFriend} eq "false"){
    #my @virtual_servers_content = `cat ${VIRTUAL_FILE} 2>/dev/null | awk -F \" \" '{if(\$1 != \"${export_group}\") print \$0}'`;
    #modify for the changing of the VS file's format at 2008/05/06
    
    my @virtual_servers_content = `cat ${VIRTUAL_FILE} 2>/dev/null`;
    my $ssVSContent = $ssComm->getVSContent4ScheduleScan(\@virtual_servers_content);
    @virtual_servers_content = `/home/nsadmin/bin/nsgui_getVSContent.pl $group_no | awk -F \" \" '{if(\$1 != \"${export_group}\") print \$0}'`;
    push (@virtual_servers_content,"${export_group} ${ntdomain} ${netbios}\n");
    push (@virtual_servers_content,@$ssVSContent);
    
    open(VF,"| ${cmd_syncwrite_o} ${VIRTUAL_FILE}");
    print VF @virtual_servers_content;
    if(!close(VF)){
       print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
       exit 1;
	
    };
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
    system("/usr/lib/rcli/rcli_cifs wb-restart");
}
foreach my $file_in(@$filelist){
    $cvs->checkin($file_in);
}


#check if ads native with the same domain name has been existed

if( $udb_common->isNativeExist($group_no,$ntdomain,"win","ads") == 0){
    #Add native domain, no rollback
    my @nativedomain_add_cmd = ("/usr/bin/ims_domain","-A",".${group_no}","ads");
    push(@nativedomain_add_cmd,@cmd_options);
    my $native_stdout=`@nativedomain_add_cmd`;

    if($? == 0){#native domain succeed
        my $native_region = (split(/\s+/,${native_stdout}))[0];
        system("/usr/bin/ims_native","-A",${native_region},"-n.","-r",${ntdomain},"-f","-c", ${IMSCONF_FILE});
    }
}
exit 0;
