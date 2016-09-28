#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_delpwddomain.pl,v 1.4 2005/11/02 08:03:13 liq Exp $"

#    Function: delete pwd domain to the specified export group
#              delete auth to direct volumns under the export group
#              if the domain type is sxfsfw, delete native domain
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            groupN           ----- "0" | "1"
#            exportGroup      ----- fullpath of export group  eg--"/export/liq"
#            ludbName         ----- luba name
#            domainType       ----- "sxfs" | "sxfsfw"
#            ntDomain         ----- ntDomain name
#            netbios          ----- ntbios name
#
#    Return value:
#           0 , if succeed
#           1 , if failed

use strict;
use NS::SystemFileCVS;
use NS::USERDBCommon;

if(scalar(@ARGV)!=7)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 7 parameters.\n";
    exit(1);
}

my ($isFriend, $groupN, $exportGroup, $ludbName, $domainType,$ntDomain, $netbios) = @ARGV;

$ntDomain = uc($ntDomain);
$netbios  = uc($netbios);

my $COM = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $COM->COMMAND_NSGUI_SYNCWRITE_O;

my $UDB = new NS::USERDBCommon;

my $GLOBAL_DIR = "/etc/group${groupN}/nas_cifs/DEFAULT";
my $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntDomain};
my $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";
my $LUDB_CONF_FILE = "/etc/group${groupN}/ludb.info";
my $IMS_CONF_FILE = "/etc/group${groupN}/ims.conf";

#first get the ludbroot
my $cmd = "/usr/bin/ludb_admin root";
my @ludbcontent = `$cmd 2>/dev/null`;
if($?){
    print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $ludbroot= $ludbcontent[0];
chomp($ludbroot);
if ($ludbroot eq ""){
    $ludbroot="/etc/group${groupN}/ludb_region";
}

#get export group short name /export/public -> public
my @eg = split("/",$exportGroup);
my $export_short = @eg[2];


#Step1
#delete a line from "/etc/group${groupN}/ludb.info" for auth
#selfnode only
#delete by liq [nsgui-necas-sv4:11136] 2005/11/1
#delete [delete info from /etc/groupN/ludb.info]
#end Step1

#Step2
#if "$ludbroot/.expgrp/$export_short/$domainType/$ludbName" exist delete it.
#delete by liq [nsgui-necas-sv4:11136] 2005/11/1
#delete [delete link]
#end Step2


#Step3
#execute ims_auth -D for Dmount under this export and ims_domain -D.(only selfnode)
if ($isFriend eq "false"){
    $UDB->delExportGroupAuthByType($exportGroup,$groupN,$domainType);
    my $region=$UDB->getEGDomainRegion($export_short, $IMS_CONF_FILE, $domainType);
    if ($region ne ""){
        system ("ims_domain -D ${region} -af -c ${IMS_CONF_FILE}");
    }
}
#end Step3

#Step4
#delete a line from "/etc/group${groupN}/ludb.info" for native
#sxfsfw only
if ($domainType eq "sxfsfw"){
    if($COM->checkout($LUDB_CONF_FILE)!=0){
        print STDERR "Failed to checkout \"$LUDB_CONF_FILE\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    my @con =  `cat $LUDB_CONF_FILE`;
    my @newcon =();
    for(my $i=0; $i<scalar(@con);$i++){
        if ($con[$i]!~/^\s*$ludbName\s+\Q${ludbroot}\E\/\.nas_cifs\/DEFAULT\/${ntDomain}\/smbpasswd\.${netbios}\s*$/){
            push(@newcon,$con[$i]);
        }
    }
    open(FILE,"| ${cmd_syncwrite_o} ${LUDB_CONF_FILE}") ;
    print FILE @newcon;
    if(!close(FILE)){
        print STDERR " Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

}
#end Step4



#Step5
#execute ims_native -D/ ims_domain -D (for ClientUDB)(only sxfsfw)
if ($domainType eq "sxfsfw"){
    my $tmp_nt_netbios = $ntDomain."+".$netbios;
    my $region2 =$UDB->getNativeRegion($groupN, $tmp_nt_netbios, $domainType, "pwd");
    if ($region2 ne ""){
        system("/usr/bin/ims_native","-D","-n.","-r","$tmp_nt_netbios","-f","-c", ${IMS_CONF_FILE});

        system("/usr/bin/ims_domain","-D","${region2}","-af","-c", ${IMS_CONF_FILE});
    }
}
#end Step5




#Step6
#if "$ludbroot/.nas_cifs/DEFAULT/$ntDomain/$domainType/smbpasswd.$netbios" exist delete it.
#(only sxfsfw)
if ($domainType eq "sxfsfw"){
    my $LINK_FILE2 = "${ludbroot}/.nas_cifs/DEFAULT/${ntDomain}/smbpasswd.${netbios}";
    system("rm -f ${LINK_FILE2}");
}

#end Step6
if ($domainType eq "sxfsfw"){
    $COM->checkin($LUDB_CONF_FILE);
}

#Step7
#delete smbpasswd file
#only selfnode and sxfsfw
if (($domainType eq "sxfsfw") && ($isFriend eq "false")){
    $UDB->delDomainDir($groupN, $exportGroup,$ntDomain, $netbios);
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
}
#end Step7

exit 0;