#!/usr/bin/perl -w

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: mapdcommon_getHasLdapSam.pl,v 1.2 2004/08/24 14:22:22 liq Exp $"

use strict;
use NS::MAPDCommon;

if ((scalar(@ARGV) != 3)){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $smb_confPath = shift;
$smb_confPath =~ s/\/$//g;#delete the last "/" if there is.

my $localdomain = shift;
my $netbios = shift;
my $mapdCommon = new NS::MAPDCommon();
my $hasLdapSam = "false";
my @all_smb_files;
@all_smb_files = `ls -1 $smb_confPath/*/smb.conf.*`;

foreach (@all_smb_files){
    chomp($_);
    if($_ eq "$smb_confPath/${localdomain}/smb.conf.$netbios"){
        #need not check the LDAPSAM
        next;
    }
    if($mapdCommon->isLdapSamConf($_) eq "yes"){
        $hasLdapSam = "true";
        last;
    }
}

print "$hasLdapSam\n";
exit 0;