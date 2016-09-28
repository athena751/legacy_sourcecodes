#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_delshrdomain.pl,v 1.1 2004/08/24 14:35:03 liq Exp $"

#    Function: delete shr domain to the specified export group
#              delete auth to direct volumns under the export group
#
#    Parameter:
#            groupN           ----- "0" | "1"
#            exportGroup      ----- fullpath of export group  eg--"/export/liq"
#            ntDomain         ----- ntDomain name
#            netbios          ----- ntbios name
#
#    Return value:
#           0 , if succeed
#           1 , if failed

use strict;
use NS::SystemFileCVS;
use NS::USERDBCommon;

if(scalar(@ARGV)!=4)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 4 parameters.\n";
    exit(1);
}

my ($groupN, $exportGroup, $ntDomain, $netbios) = @ARGV;

$ntDomain = uc($ntDomain);
$netbios  = uc($netbios);

my $COM = new NS::SystemFileCVS;
my $UDB = new NS::USERDBCommon;

my $GLOBAL_DIR = "/etc/group${groupN}/nas_cifs/DEFAULT";
my $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntDomain};
my $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my $SMB_FILE = ${DOMAIN_DIR}."/smbpasswd.${netbios}";
my $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";
my $IMS_CONF_FILE = "/etc/group${groupN}/ims.conf";

#get export group short name /export/public -> public
my @eg = split("/",$exportGroup);
my $export_short = @eg[2];

#Step1
#execute ims_auth -D for Dmount under this export and ims_domain -D.(only selfnode)
if (-e $IMS_CONF_FILE){
    my $domainType = "sxfsfw";
    $UDB->delExportGroupAuthByType($exportGroup,$groupN,$domainType);
    my $region=$UDB->getEGDomainRegion($export_short, $IMS_CONF_FILE, $domainType);
    if ($region ne ""){
        my $ret=system ("ims_domain -D ${region} -af -c ${IMS_CONF_FILE}");
    }
}
#end Step1

#Step2
#delete smbpasswd file
    $UDB->delDomainDir($groupN, $exportGroup,$ntDomain, $netbios);

    system("rm -f ${SMB_FILE}");
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
#end Step2
