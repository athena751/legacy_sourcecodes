#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_changeNewDirstoFullRightsMode.pl,v 1.2 2007/02/28 07:28:09 xingyh Exp $"
## Function:
##     To replace chmod command for rsh problem
##     change directorys's mode form shot dir to long dir
##     
## Parameters:
##     $shortPath	 
##     $longPath
##  
## exit:
##     0 -- success 
##     1 -- failed

use strict;
use NS::VolumeConst;
use NS::VolumeCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
if(scalar(@ARGV) != 2){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}
my ($shortPath , $longPath) = @ARGV;
my $retval = $volumeCommon->changeNewDirstoFullRightsMode($shortPath,$longPath);
if($retval != 0){
    exit 1;
}
exit 0 ;