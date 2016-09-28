#!/usr/bin/perl

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_mpcheck.pl,v 1.1 2004/08/30 10:09:08 caoyh Exp $"

use strict;

use NS::VolumeCommon;
use NS::VolumeConst;

if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $mountPoint = shift;
my $fsType = shift;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

my $checkResult = $volumeCommon->validateMPForUse($mountPoint , $fsType);

if($checkResult eq $volumeConst->ERR_FS_HAS_CHILD) {
    print "5\n";
    exit 0;
} elsif($checkResult eq $volumeConst->ERR_FS_PARENT_READ_ONLY) {
    print "3\n";
    exit 0;
} elsif($checkResult eq $volumeConst->ERR_FS_DIFF_TYPE) {
    print "1\n";
    exit 0;
} elsif($checkResult eq $volumeConst->ERR_REPLI_PARENT) {
    print "4\n";
    exit 0; 
} elsif($checkResult eq $volumeConst->ERR_FS_PARENT_UMOUNTED) {
    print "2\n";
    exit 0;  
} elsif($checkResult eq $volumeConst->SUCCESS_CODE) {
    print "0\n";
    exit 0;
} else {
    $volumeConst->printErrMsg(${checkResult});
    exit 1;    
}