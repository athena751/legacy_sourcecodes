#!/usr/bin/perl -w
#
#       copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_delAsyncFile.pl,v 1.1 2008/04/19 10:00:11 liuyq Exp $"

# function:
#       remove the asynchronous information.
# Parameters:
#       volumeName
# output:
#       none
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::DdrCommon;
use NS::DdrConst;

my $ddrCommon = new NS::DdrCommon;
my $ddrConst = new NS::DdrConst;

if(scalar(@ARGV) != 1){
    $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_WRONG_PARAMETER , __FILE__, __LINE__ + 1);
    exit 1;
}
my $volumeName = shift;
my $retVal = $ddrCommon->deleteAsyncPairInfo($volumeName);
if($retVal ne $ddrConst->SUCCESS_CODE){
    $ddrConst->printErrMsg($ddrConst->ERR_EDIT_DDR_ASYNCFILE , __FILE__, __LINE__ + 1);
    exit 1;
}
exit 0;
