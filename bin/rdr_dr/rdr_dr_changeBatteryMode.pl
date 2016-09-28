#!/usr/bin/perl -w
#
#       Copyright (c) 2004-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: rdr_dr_changeBatteryMode.pl,v 1.2 2005/11/18 08:27:06 jiangfx Exp $"
## Function:
##     change battery's mode
##
## Parameters:
##     $nextMode -- battery's mode when machine reboot
##                  on : normal mode after rebooting
##                  off: RDR/DR mode after rebooting
##  
## Output:
##     STDOUT
##         none
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

## check parameter num
if(scalar(@ARGV) != 1){
    $rdr_drConst->printErrMsg($rdr_drConst->ERR_PARAM_NUM);
    exit 1;
}

my $nextMode = shift;
## check parameter's validity
if (($nextMode ne "on") && ($nextMode ne "off")) {
    $rdr_drConst->printErrMsg($rdr_drConst->ERR_PARAM_INVALID);
    exit 1;
}

my $cmd_reboot = $rdr_drConst->CMD_REBOOT; 
my $retValue = $rdr_drCommon->shiftToInit2();
## failed to shift to update mode(runlevel 2)
if ($retValue =~ /^0x131000/) {
	## write log, print error message and error code
	$rdr_drCommon->writeSyslog($retValue);
	system("sudo ${cmd_reboot} 2>/dev/null");
    exit 1;
}

## change mode to the given mode
my $btrymode_sh = $rdr_drConst->CMD_BTRYMODE_SH;
`sudo ${btrymode_sh} ${nextMode} 2>/dev/null`;
if ($? != 0) {
	
	## write log, print error message and error code
    $retValue = $rdr_drCommon->getErrorCode($?);
    $rdr_drCommon->writeSyslog($retValue);
    
    system("sudo ${cmd_reboot} 2>/dev/null");
    exit 1;
}

system("sudo ${cmd_reboot} 2>/dev/null");
exit 0;