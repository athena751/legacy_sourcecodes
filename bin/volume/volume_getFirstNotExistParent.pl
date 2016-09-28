#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_getFirstNotExistParent.pl,v 1.2 2007/02/28 07:31:06 xingyh Exp $"
## Function:
##     To replace chmod command for rsh problem
##     change directorys's mode form shot dir to long dir
##     
## Parameters:
##     $Path	 
## 
## exit:
##     0 -- success 
##     1 -- failed
##     2 -- parent not exist
use strict;
use NS::VolumeConst;
use NS::VolumeCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;

if(scalar(@ARGV) != 1){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}
my ($path) = @ARGV;
my $retval = $volumeCommon->getFirstNotExistParent($path);
if (!defined($retval)){
    exit 2;
}
print("${retval}\n");
exit 0;