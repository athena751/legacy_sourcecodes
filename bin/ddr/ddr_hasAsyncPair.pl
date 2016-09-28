#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: ddr_hasAsyncPair.pl,v 1.1 2008/04/19 10:00:11 liuyq Exp $"
#
#Function:
#       Check whether has async operation or not.
#Arguments:
#       null
#exit code:
#       0:succeeded
#       1:failed
#output:
#       @$asyncPair
use strict;
use NS::DdrCommon;
use NS::DdrConst;

my $ddrCommon = new NS::DdrCommon;
my $ddrConst = new NS::DdrConst;

if(scalar(@ARGV) != 0){
    $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_WRONG_PARAMETER , __FILE__, __LINE__ + 1);
    exit 1;
}

my $asyncPair = $ddrCommon->hasAsyncPair();
print @$asyncPair;
exit 0;
