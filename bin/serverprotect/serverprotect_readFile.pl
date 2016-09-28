#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_readFile.pl,v 1.5 2007/06/28 01:31:21 wanghui Exp $"

#Function: 
    #get the content of configure file
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
use NS::CIFSCommon;
use NS::ServerProtectConst;
use NS::ServerProtectCommon;
use NS::CodeConvert;

my $nsguiCommon  = new NS::NsguiCommon;
my $cifsCommon  = new NS::CIFSCommon;
my $const = new NS::ServerProtectConst;
my $comm = new NS::ServerProtectCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=3){
    $nsguiCommon->writeErrMsg($const->ERR_PARAMER_NUM,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;

my $nsguiIconv = $const->COMMAND_NVAVS_CODECONVERT;
my $path = $comm->getConfFilePath($groupNumber,$computerName);
my $cmd_cat = $const->CMD_CAT;

## get the content of temporary file and convert the encoding,if file does not exist output default content 
if (! -f $path) {
     exit 0;  	
}
##get encoding
my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    $nsguiCommon->writeErrMsg($const->ERR_EXPORTGROUP_GET,__FILE__,__LINE__+1);
    exit 1;
}

my $needConvert = $codeConvert->needChange($expGroupEncoding);
if(!defined($needConvert) || $needConvert eq "n"){
   system("${cmd_cat} $path");
}
else {
   system("${cmd_cat} ${path} | ${nsguiIconv} -f UTF8-NEC-JP -t UTF-8");
}

exit 0;