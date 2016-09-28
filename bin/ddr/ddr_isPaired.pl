#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_isPaired.pl,v 1.1 2008/04/19 10:00:11 liuyq Exp $"

###Function: 
###         check whether the specified volume has disk backup settings
###Parameter:
###         $volName --- the specified volume name 
###Return:
###         0  --- the specified volume has no pair settings
###         1  --- the specified volume has pair settings
###         2  --- error occurs when  execute
###Output:
###     none
###Stderr:
###     0x12400095 : error occurs when failed to execute command /sbin/vgpaircheck
###     0x12400094 : the specified volume has pair settings

use strict;
use NS::ReplicationCommon;
use NS::ReplicationConst;

my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;

if(scalar(@ARGV) !=  1){
    &printHelp();
    exit 1;
}
my $volName = shift;
my $retVgpaircheck = $repliCommon->vgpaircheck($volName);
if($retVgpaircheck == 0 ){
    $repliConst->printErrMsg($repliConst->ERR_IS_PAIRED, __FILE__, __LINE__);
	exit 1;
}elsif($retVgpaircheck != 1 ){
    $repliConst->printErrMsg($repliConst->ERR_EXECUTE_VGPAIRCHECK, __FILE__, __LINE__);
	exit 2;
}
exit 0;

#### sub function defination start ####
### Function: show help message;
### Paremeters:
###     none;
### Return:
###     none
### Output:
###     Usage:
###         disk_getpairedlds.pl <DiskArrayName>
sub printHelp(){
    print (<<_EOF_);
Usage:
    ddr_isPaired.pl <Volume Name>
        
_EOF_
}
#### sub function defination End ####