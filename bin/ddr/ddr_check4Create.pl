#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_check4Create.pl,v 1.1 2008/04/30 08:50:41 xingyh Exp $"

## Function:
##      Check pool capacity if can create pair
##
## Parameters:
##      $mv         name of mv   
##      $subcmd     --'always'|'generation'|'d2d2t'
##      $mp         when 'd2dt2' have this mount point  
##      $rv0        <POOL>#<master-vol>#<WWNN>#<replica-vol>
##      $rv1        ...
##      $rv2        ...
## Output:
##
##     STDERR
##         error message and error code
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use Getopt::Long;
use NS::DdrCommon;
use NS::DdrConst;

my $ddrCommon = new NS::DdrCommon;
my $ddrConst  = new NS::DdrConst;
my $success = $ddrConst->SUCCESS_CODE;

## Get and check parameter 
my ($mv,$rv0Info,$rv1Info,$rv2Info);
my $result = eval{
                    $SIG{__WARN__} = sub { die $_[0]; };
                    GetOptions( "mv=s"	        => \$mv,
                                "rv0=s"         => \$rv0Info,
                                "rv1=s"         => \$rv1Info,
                                "rv2=s"         => \$rv2Info);
            };
if(!$result){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}
if(!defined($mv)){
   $ddrConst->printErrMsg($ddrConst->ERR_PARAM_UNKNOWN);     
   exit 1;
}

my $retVal = $ddrCommon->checkPoolCapacity($mv,$rv0Info,$rv1Info,$rv2Info);
if($retVal ne $success ){
    $ddrConst->printErrMsg($ddrConst->ERR_CHECK_RV_CAPACITY);
    exit 1;
}
exit 0;




