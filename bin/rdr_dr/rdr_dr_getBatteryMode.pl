#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: rdr_dr_getBatteryMode.pl,v 1.2 2009/01/13 11:07:50 jiangfx Exp $"
## Function:
##     get battery's current mode
##
## Parameters:
##     none
##  
## Output:
##     STDOUT
##         on|off
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- error
use strict;
use NS::Rdr_drConst;
use NS::Rdr_drCommon;

my $rdr_drConst  = new NS::Rdr_drConst;
my $rdr_drCommon = new NS::Rdr_drCommon;

## get battery's current mode and next mode
my $btrymode_sh = $rdr_drConst->CMD_BTRYMODE_SH;
my @modeInfo = `sudo ${btrymode_sh} 2>/dev/null`;

## print error message and error code
if ($? != 0) {
	$rdr_drConst->printErrMsg($rdr_drConst->ERR_GET_CURRENT_MODE);
	exit 1;
}

## output
foreach (@modeInfo) {
    if ($_ =~ /^\s*Current mode:\s*(\w+)\s*$/) {
        print $1."\n";
        exit 0;
    }
}

$rdr_drConst->printErrMsg($rdr_drConst->ERR_GET_CURRENT_MODE);
exit 1;