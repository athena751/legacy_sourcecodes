#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_adddmcdomain.pl,v 1.11 2008/05/09 05:33:10 liq Exp $"

#    Function: add dmc domain to the specified export group
#              add auth to direct volumns under the export group
#              add native domain
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            groupN           ----- "0" | "1"
#            exportGroup      ----- fullpath of export group  eg--"/export/liq"
#            user             ----- User Name
#            ntDomain         ----- ntDomain name
#            netbios          ----- ntbios name
#
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
if(scalar(@ARGV)!=6)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 5 parameters.\n";
    exit(1);
}

my ($isFriend, $groupN, $exportGroup,$user, $ntDomain, $netbios) = @ARGV;
my $pwd = <STDIN>;
chomp($pwd);

my $user_pwd =$user."%".$pwd;

$ntDomain = uc($ntDomain);
$netbios  = uc($netbios);

my $COM = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $COM->COMMAND_NSGUI_SYNCWRITE_O;

my $UDB = new NS::USERDBCommon;
my $udb_const = new NS::USERDBConst();
my $cifsCommon = new NS::CIFSCommon;

my $GLOBAL_DIR = "/etc/group${groupN}/nas_cifs/DEFAULT";
my $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntDomain};
my $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";
my $IMS_CONF_FILE = "/etc/group${groupN}/ims.conf";

#get export group short name /export/public -> public
my @eg = split("/",$exportGroup);
my $export_short = @eg[2];

#Step1
#creat smbpasswd file(selfnode only)
if ($isFriend eq "false" ){
	# get available interface
	my $interface = "";
	my @toe = $cifsCommon->getUnusedInterfaces($groupN);
    if(scalar(@toe)>0){
        $interface = $toe[0];
    }else{
        print STDERR "There are not any interfaces which can be used. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 8;
    }

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
        "winbind enum groups = yes\n",
        "winbind separator = +\n",
        "template shell = /bin/bash\n",
        "winbind uid = 10000-110000\n",
        "winbind gid = 10000-110000\n",
        "server string = \"\"\n",
        "deadtime = 15\n",
        "security = domain\n",
        "password server = \*\n",
        "workgroup = ${ntDomain}\n",
        "smb passwd file = %r/%D/smbpasswd\n"
    );
    
    push(@global_content,$udb_const->ALWAYS_CAP_W2K_SMBS);
    
    if($interface ne ""){
        push(@global_content,"interfaces = ${interface}\n");
        push(@global_content,"bind interfaces only = yes\n");
    }
    push(@global_content,"nt acl support = yes\n");

    my $hostname = "";
    my @myFriend = `/home/nsadmin/bin/getMyFriend.sh`;
    my $friend_ip = $myFriend[0];
    if(($? == 0) and defined($friend_ip)){
        $hostname = `/bin/hostname -s`;
        chomp($hostname);
        $hostname = uc($hostname);
    }
    if ($hostname ne ""){
        push(@global_content,"netbios name = ${hostname}\n");
    }
    #Set direct hosting when the direct hosting is set in friend node.
    if($checkDirectHosting eq "yes"){
        push(@global_content,$udb_const->SMB_PORTS);
    }
    #write smb.conf.<netbios>
    open(FILE,"| ${cmd_syncwrite_o} ${SMB_CONF_FILE}");
    print FILE @global_content;
    if(!close(FILE)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

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
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
#end Step1

#Step2
#execute nascifsjion (selfnode only)
if ($isFriend eq "false" ){
   my @domain_join_cmd = ("/usr/bin/nascifsjoin","-t","rpc","-j","$ntDomain",
                            "-G","/etc/group$groupN/nas_cifs",
                            "-U","${user_pwd}",
                            "-s",$SMB_CONF_FILE);
   my $ret=system(@domain_join_cmd);
    if ($ret){
        $COM->rollback($VIRTUAL_FILE);
        system("rm -f ${SMB_CONF_FILE}");
        print STDERR "Join Domain failed. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 7;
    }
}
#end Step2


#Step3
#add DMC domain defination (selfnode only)
my @cmd_options =("-o","zone=DEFAULT","-o","workgroup=${ntDomain}","-o","separator=+");

my $region="";
if ($isFriend eq "false" ){
    my @cmd_adddomain = ("/usr/bin/ims_domain","-A","${export_short}","dmc");
    push(@cmd_adddomain,@cmd_options);
    push(@cmd_adddomain,("-f", "-c", $IMS_CONF_FILE));
    my $stdout = `@cmd_adddomain`;
    if($?){# command ims_domain -A is failed.
        $COM->rollback($VIRTUAL_FILE);
        system("rm -f ${SMB_CONF_FILE}");
        print STDERR "ims_domain -A  failed. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    chomp(${stdout});
    my @tmp_array = split(/\s+/,${stdout});
    $region = @tmp_array[0];
}

#end Step3

#Step4
#run /home/nsadmin/bin/ns_nascifsstart.sh to make it useful.
#(selfnode only)
if ($isFriend eq "false"){
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
}
#end Step4

#Step5
#execute ims_auth -A for Dmount under this export.(only selfnode)
if ($isFriend eq "false" && $region ne ""){
    my $domainType = "sxfsfw";
    my @dMount=`/home/nsadmin/bin/userdb_getdmountlist.pl $export_short $groupN $domainType`;
    foreach(@dMount){
        chomp($_);
            my @tmp=split(",",$_);
            system ("ims_auth -A ${region} -d ${tmp[0]} -f -c ${IMS_CONF_FILE}");
    }
}
#end Step5

#Step6
#execute ims_domain -A(for ClientUDB) and ims_native -A
my $exist_this_native = $UDB->isNativeExist($groupN, $ntDomain, "win", "dmc");
if ($exist_this_native == 0){
    my @cmd_adddomain = ("/usr/bin/ims_domain","-A",".${groupN}","dmc");
    push(@cmd_adddomain,@cmd_options);
    push(@cmd_adddomain,("-f", "-c", $IMS_CONF_FILE));

    my $stout2 = `@cmd_adddomain`;
    if(!$?){# command ims_domain -A succeed
        chomp(${stout2});
        my @tmp_array = split(/\s+/,${stout2});
        my $region2 = @tmp_array[0];
        my $ret=system("/usr/bin/ims_native","-A","${region2}","-n.","-r","${ntDomain}","-o","dmc","-f","-c",${IMS_CONF_FILE});
        if ($ret){
            system("/usr/bin/ims_domain","-D","${region2}","-af","-c",${IMS_CONF_FILE});
        }
    }
}
#end Step6

if ($isFriend eq "false"){
    $COM->checkin($VIRTUAL_FILE);
}
exit 0;

