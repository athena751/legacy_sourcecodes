#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_readDirAccessConf.pl,v 1.4 2007/06/28 01:43:22 fengmh Exp $"

#Function: 
    #get the Dir Access Conf file content;
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
#exit code:
    #0:succeed 
    #1:failed
#output:
    #content of configure file
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::CodeConvert;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $codeConvert = new NS::CodeConvert;
my $nsguiIconv = "/home/nsadmin/bin/nsgui_iconv.pl";

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}

my $dirAccessFile = $cifsCommon->getDirAccessConfFileName($groupNumber, $domainName, $computerName);

if($dirAccessFile eq ""){
   $dirAccessFile = $cifsCommon->getDefaultDirAccessConfFileName($groupNumber, $domainName, $computerName);
}

if(-f $dirAccessFile){
    my $needChangeCode = $codeConvert->needChange($expGroupEncoding);
	if(defined($needChangeCode) && $needChangeCode eq "y") {
        system("cat  ${dirAccessFile} | $nsguiIconv -f UTF8-NEC-JP -t UTF-8");
    } else {
        system("cat", $dirAccessFile);
    }
}
exit 0;