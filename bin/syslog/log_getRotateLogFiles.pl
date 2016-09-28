#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getRotateLogFiles.pl,v 1.5 2008/05/16 04:49:50 hetao Exp $"

#Function: 
    #get all the rotate files' info(fileName,ctime) according to the target file.
#Arguments: 
    #$logFile : the specified log files
#exit code:
    #0: success
    #1: error
#output:
    # the specified file 's rotate files and the files' 
    #    ctime(time of last modification of file status information)

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;

if(scalar(@ARGV)!=2){
    print STDERR "The parameter number is not correct.\n";
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
	exit 1;
}

my $logFile = shift;
my $logType = shift;
my $getFileSize = '/opt/nec/nsadmin/bin/log_getFileSizeList.pl';
$logFile = "$logFile.";
my @result = `ls -lt  '--time-style=+%a %b %d %H:%M:%S %G' \Q${logFile}\E*`;

foreach (@result) {    
    if (/^\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+\s+\S+)\s+(\S+)\s+(\S+)\s(.+)$/) {
        my $fileName = $4;
        my $dateString = "$3 $1";
        my $timeString = $2;
        if($fileName =~ /^\Q${logFile}\E\d+$/){
            my $size = `echo \Q${fileName}\E | ${getFileSize} ${logType}`;
            $size = '' if ($?!=0);
            chomp($size);
            print "fileName=$fileName\n";  
            print "dateString=$dateString\n";
            print "timeString=$timeString\n";
            print "fileSize=${size}\n";
        }
    }
}

exit 0;