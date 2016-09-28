#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_hasldapsam.pl,v 1.1 2004/08/24 14:35:03 liq Exp $"

#    Function: add nis domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:
#            g_num            ----- "0" | "1"             
#
#    Return value:
#            true , has ldapsam
#            false , no ldapsam 


use strict;
use NS::MAPDCommon;

if ((scalar(@ARGV) != 1)){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $g_num = shift;
my $userCom = new NS::MAPDCommon;
my $filePath = "/etc/group${g_num}/nas_cifs/DEFAULT/*/smb.conf.*";
my @all_smb_files;
@all_smb_files = `ls -1 $filePath`;
my $hasLdapSam = "false";
foreach (@all_smb_files){
    chomp($_);
    if($userCom->isLdapSamConf($_) eq "yes"){
        $hasLdapSam = "true";
        last;
    }
}

print "$hasLdapSam\n";
exit 0;