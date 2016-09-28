#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getFtpLogFiles.pl,v 1.1 2004/11/21 08:13:44 baiwq Exp $"

#Function: 
    #output the ftp log file's full path
#Arguments: 
    #none
#exit code:
    #0: success
    #1: parameter's number is error
#output:
    #the ftp log file's path

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

my $ftpLog = $const->CONST_FTP_LOG;
if( -f $ftpLog ){
    print "${ftpLog}\n";
}

exit 0;