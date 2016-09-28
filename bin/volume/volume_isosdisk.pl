#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: volume_isosdisk.pl,v 1.1 2005/12/22 03:05:21 liuyq Exp $"

###Function : get all the mount point path in system from mount command and cfstab file
###Parameter: 
###     aid 
###Return:
###     0 : success
###     1 : error occurs
###Output:
###     1.stdout
###       true:  os disk array
###       false: not disk array
###     2.stderr
###       error message

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

if(scalar(@ARGV) != 1){
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}
my $aid = shift;

my $isOsDisk = $volumeCommon->isOsDiskArray($aid);
if($isOsDisk =~ /\s*0x108/){
    $volumeConst->printErrMsg($isOsDisk);
    exit 1;
}
if($isOsDisk == 0){
    print "false\n";
}else{
    print "true\n";
}
exit 0;