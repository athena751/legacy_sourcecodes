#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_readSmbConf.pl,v 1.3 2007/06/28 01:43:22 fengmh Exp $"

#Function: 
    #get the smb.conf.%L file content;
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

my $smb_conf_File = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
if(!-f $smb_conf_File){
    system("touch ${smb_conf_File}");
}
my $needChangeCode = $codeConvert->needChange($expGroupEncoding);
if(defined($needChangeCode) && $needChangeCode eq "y") {
    system("cat  ${smb_conf_File} | $nsguiIconv -f UTF8-NEC-JP -t UTF-8");
} else {
    system("cat ${smb_conf_File}");
}
exit $?>>8;