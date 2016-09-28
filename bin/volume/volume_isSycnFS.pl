#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_isSycnFS.pl,v 1.2 2008/02/29 11:21:12 liy Exp $"

###Function: get file system type for the specified mount point
###Parameter:
###         mp --- the specified mount point path
###Return:
###         0  --- normal execute
###         1  --- error occurs when  execute
###Output:
###     "yes" --- the specified mount point's file system type is syncfs
###     "no" --- the specified mount point's file system type is not syncfs

use strict;
use NS::VolumeConst;

my $volumeConst = new NS::VolumeConst;

if(scalar(@ARGV) !=  1){
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}
my $mp = shift;
## get Volume's File System Type
my $cmd_chksyncfs = $volumeConst->CMD_CHKSYNCFS;
my $retVal = system("$cmd_chksyncfs $mp >&/dev/null");
if($retVal == 0){
    print "yes\n";
}else{
	print "no\n";
}
exit 0;
