#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_checkPairStatus4extend.pl,v 1.1 2008/05/04 04:37:16 yangxj Exp $"

## Function:
##     
##
## Parameters:
##	   
##	   mvName rvNames
##         Comment:
##             "rvNames" is like ****#**** if multi-rv.
##             "mvSize" is mv's total size(vgSize + extendSize), and unit is GB.
##  
## Output:
##     STDOUT
##         success:
##         		ok
##	       failed:
##	        	ng
##         
##         error message and error code
##
## Returns:
##     0 -- normal
##     1 2 -- error

use strict;
use NS::DdrConst;
use NS::DdrCommon;
use NS::VolumeConst;

my $ddrConst  = new NS::DdrConst;
my $ddrCommon = new NS::DdrCommon;
my $volumeConst = new NS::VolumeConst;

if(scalar(@ARGV) < 2){
    $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_WRONG_PARAMETER, __FILE__, __LINE__ + 1);
    exit 1;
}

my $mvName = shift;
my @rvName = @ARGV;

## check Sync Status
foreach (@rvName) {
    my ($ldPairListOfVolPair, $err_code ) = $ddrCommon->getLdPairListOfVolPair( $mvName, $_ );
    if ( !defined($err_code)) {
        my $currentSyncState = $ddrCommon->getSyncState($ldPairListOfVolPair);
        if($currentSyncState ne $ddrConst->SYNCSTATE_SEPARATED){
            print $ddrConst->ERR_EXTEND_SYNCSTATE_INVALID;
            exit 1;
        }
    }else{
        print $err_code;
        exit 1;
    }
}

exit 0;

