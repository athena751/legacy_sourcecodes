#!/usr/bin/perl
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_cleanTmpFile.pl,v 1.7 2008/05/15 02:45:39 hetao Exp $"

#Function: delete the temp log file when use log out 
#Parameters:
    #none
#exit code:
    #0 ---- success
    #1 ---- failure
use strict;

if(scalar(@ARGV != 1) && scalar(@ARGV != 2)){
    print STDERR "The parameters' number is error.\n";
    exit 1;
}
my $sessionID = shift;
my $logType = shift;
my $TEMP_FILE_DIR = "/var/crash/.nsguiwork/logview/$sessionID";
if(defined($logType)){
	$TEMP_FILE_DIR .= "/${logType}*";
}

`/bin/rm -rf $TEMP_FILE_DIR`;

exit 0;
