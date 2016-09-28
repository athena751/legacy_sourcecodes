#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_setSslStatus.pl,v 1.1 2005/09/15 05:29:22 liyb Exp $"
## Function:
##     set whether use SSL to communicate or not
##
## Parameters:
##     on | off
##  
## Output:
##     STDOUT
##		    none
##     STDERR
##          error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed
use strict;
use NS::ReplicationConst;

my $repliConst = new NS::ReplicationConst;

if (scalar(@ARGV) != 1) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
	exit 1;
}

## check whether param is valid or not
my $sslStatus = shift;
if (($sslStatus ne "on") && ($sslStatus ne "off")) {
	$repliConst->printErrMsg($repliConst->ERR_PARAMETER_CONTENT, __FILE__, __LINE__ + 1);
	exit 1;
}

## stop sync manager
my $cmd_syncconf_stop = $repliConst->CMD_SYNCCONF_STOP;
if (system("${cmd_syncconf_stop} 2>/dev/null") != 0) {
	$repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCONF_STOP, __FILE__, __LINE__ + 1);
	exit 1;
}

my $cmd_syncconf_start = $repliConst->CMD_SYNCCONF_START;
## set SSL status
my $cmd_ssl = $repliConst->CMD_SYNCCONF_SECURITY_SSL;
if (system("${cmd_ssl} ${sslStatus} 2>/dev/null") != 0) {
	# rollback when failed to set SSL (start sync manager)
	system("${cmd_syncconf_start} 2>/dev/null");
	
	$repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCONF_SECURITY_SSL, __FILE__, __LINE__ + 1);
	exit 1;
}

#start sync manager
if (system("${cmd_syncconf_start} 2>/dev/null") != 0) {
	$repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCONF_START, __FILE__, __LINE__ + 1);
	exit 1;
}

exit 0;