#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_cansetdmapi.pl,v 1.5 2004/11/22 12:18:57 liuyq Exp $"

###Function: check whether can set dmapi for the specified mount point
###          by checking whether the mount point has sets about snapshot
###Parameter:
###         mp --- the specified mount point path
###Return:
###         0  --- normal execute
###         1  --- error occurs when  execute
###Output:
###     yes --- the specified mount point can set dmapi item
###     no  --- the specified mount point can not set dmapi item
###     error code && error message 
###         --- error occurs when executing 

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

if(scalar(@ARGV) !=  1){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}
my $retVal = $volumeCommon->hasSnapshotSet(shift);
if($retVal =~ /^0x/){
   $volumeConst->printErrMsg($retVal);
    exit 1;
}
if($retVal){
    print "no\n";
}else{
    print "yes\n";
}

exit 0;


## Function: output usage
## Parameters:
##     none
## Returns:
##     none
## Output
##     Usage:
##           volume_cansetdmapi.pl <mountpoint>
sub showHelp(){
print (<<_EOF_);
    Usage:
          volume_cansetdmapi.pl <mountpoint>
_EOF_
}