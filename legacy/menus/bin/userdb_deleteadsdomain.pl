#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_deleteadsdomain.pl,v 1.2 2004/08/25 07:31:39 xingh Exp $"
#    Function: add ads domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:

#            exportGroup      ----- fullpath of export group

#            groupNo          ----- "0" | "1"
#            ntDomain
#            netbios
#
#    Return value:
#           0 , if succeed
#           1 , if failed

use strict;
use NS::USERDBCommon;

if(scalar(@ARGV)!= 4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    print STDERR "Usage: sudo ", __FILE__,"  <export group> <group number> <NT domain> <netbios>\n";
    exit(1);
}

my ($export_group,$group_no,$ntdomain, $netbios) = @ARGV;

$ntdomain = uc($ntdomain);
$netbios  = uc($netbios);

my $udb_common  = new NS::USERDBCommon();


my      $GLOBAL_DIR = "/etc/group${group_no}/nas_cifs/DEFAULT";
my      $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntdomain};
my      $IMSCONF_FILE="/etc/group${group_no}/ims.conf";

my $export_short = (split(/\/+/, $export_group))[2];

$udb_common->delExportGroupAuthByType($export_group,$group_no,"sxfsfw");

my $domain_region ="";

#if there are garbage domain defination then delete them, before v2.1 ?
while(($domain_region = $udb_common->getEGDomainRegion($export_group,$IMSCONF_FILE,"sxfsfw")) ne ""){
    system("/usr/bin/ims_domain -D $domain_region -af -c $IMSCONF_FILE >&/dev/null");
}

$udb_common->delDomainDir($group_no,$export_group,$ntdomain,$netbios);

exit 0;
