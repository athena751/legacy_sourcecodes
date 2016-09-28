#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getHttpLogFiles.pl,v 1.1 2004/11/21 08:13:44 baiwq Exp $"

#Function: 
    #get all the http log  that exist and not empty
#Arguments: 
    #none
#exit code:
    #0: success
    #1: parameter number error
#output:
    #the full path of the http log file that exist and not empty

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;

#check the parameter's number = 0
if(scalar(@ARGV)!=0){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
	exit 1;
}

if(-f $const->CONST_HTTP_ACCESS_LOG){
    print $const->CONST_HTTP_ACCESS_LOG."\n";
}else{
    print "\n";
}
if(-f $const->CONST_HTTP_ERROR_LOG){
    print $const->CONST_HTTP_ERROR_LOG."\n";
}else{
    print "\n";
}

my $aLogPath = $const->CONST_HTTP_ACCESS_LOG_PATH;
&printLogFile($aLogPath);
my $eLogPath = $const->CONST_HTTP_ERROR_LOG_PATH;
&printLogFile($eLogPath);

sub printLogFile{
    my $path = shift;
    my @logList = `ls ${path} 2>/dev/null`;
    foreach(@logList){
        chomp;
        print "$_\n";
    }
}

exit 0;