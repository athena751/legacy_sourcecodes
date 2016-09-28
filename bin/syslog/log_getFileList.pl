#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getFileList.pl,v 1.9 2008/05/14 09:32:32 hetao Exp $"

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;

#check the parameter's number = 0
if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
	exit 1;
}

my $logType = shift;
my $fileName = shift;
my $rev = shift;

if($rev eq "/usr/bin/tac"){
    $rev = "";
}else{
    $rev = "r"
}

my $fileNameForPrint = "";
my $isGetFileList = "true";
if($logType eq "cifsLog" || $logType eq "nfsLog"){
    my $isShare = `/opt/nec/nsadmin/bin/log_isInSharePartition.pl \Q$fileName\E 2>/dev/null`;
    chomp $isShare;
    if($isShare eq "true" or $fileName eq "/var/opt/nec/nfsperform/perform"){
        # return only one file
        $isGetFileList = "false";
        $fileNameForPrint = $fileName."\x00";
    }
}
if($isGetFileList eq "true"){
    my @fileList = `/bin/ls -1${rev}t \Q$fileName\E* 2>/dev/null`;
    foreach(@fileList){
        chomp($_);
        if(-f $_){
            if(/^\Q$fileName\E([.][0-9]+){0,1}([.]gz){0,1}$/){
                $fileNameForPrint = $fileNameForPrint."$_\x00";
            }
        }
    }
}

if($fileNameForPrint eq "") {
    exit 1;
}
print $fileNameForPrint;
exit 0;