#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_writeFile.pl,v 1.6 2007/06/28 01:32:20 wanghui Exp $"

#Function: 
    #save the content into temp file and update configuration 
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
    #$tempFile          : the temp file path
#exit code:
    #0:succeed 
    #1:failed

use strict;
use NS::NsguiCommon;
use NS::CIFSCommon;
use NS::ServerProtectConst;
use NS::ServerProtectCommon;
use NS::CodeConvert;

my $nsguiCommon  = new NS::NsguiCommon;
my $const = new NS::ServerProtectConst;
my $comm = new NS::ServerProtectCommon;
my $cifsCommon = new NS::CIFSCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=4){
	  $nsguiCommon->writeErrMsg($const->ERR_PARAMER_NUM,__FILE__,__LINE__+1);
    exit 1;
}
my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $tempFile = shift;

my $nsguiIconv = $const->COMMAND_NVAVS_CODECONVERT;
my $rrdfile_reserve = $const->COMMAND_NVAVS_RRDFILE_RESERVE;
my $cmd_cat = $const->CMD_CAT;
my $cmd_rm = $const->CMD_RM;

##get encoding
my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    system("${cmd_rm} -f ${tempFile} 2>/dev/null 1>&2");
    $nsguiCommon->writeErrMsg($const->ERR_EXPORTGROUP_GET,__FILE__,__LINE__+1);
    exit 1;
}
## get the content of temporary file and change encoding
if (! -f $tempFile) {
    $nsguiCommon->writeErrMsg($const->ERR_FILE_OPEN,__FILE__,__LINE__+1);
    exit 1;  	
}
my @content;
my $needConvert = $codeConvert->needChange($expGroupEncoding);
if(!defined($needConvert)){
    $nsguiCommon->writeErrMsg($const->ERR_GET_MACHINE_TYPE,__FILE__,__LINE__+1);
    exit 1;
}elsif($needConvert eq "y"){
    @content = `${cmd_cat} ${tempFile} | $nsguiIconv -f UTF-8 -t UTF8-NEC-JP`;
    if(($?>>8) != 0){
        system("${cmd_rm} -f ${tempFile} 2>/dev/null 1>&2");
        $nsguiCommon->writeErrMsg($const->ERR_ENCODING_CHANGE,__FILE__,__LINE__+1);
        exit 1;
    }
    
    ##save the fileContent to tempFile
    if(!open(TEMPFILE,">$tempFile")){
        system("${cmd_rm} -f ${tempFile} 2>/dev/null 1>&2");
        $nsguiCommon->writeErrMsg($const->ERR_FILE_OPEN,__FILE__,__LINE__+1);
        exit 1;
    }
    print TEMPFILE @content;
    if(!close(TEMPFILE)){
        system("${cmd_rm} -f ${tempFile} 2>/dev/null 1>&2");
        $nsguiCommon->writeErrMsg($const->ERR_FILE_WRITE,__FILE__,__LINE__+1);
        exit 1;
    }
}elsif($needConvert eq "n") {
    @content =`${cmd_cat} $tempFile`;
}
##update configuration by command "nvavs_config"
my $ret = $comm->setConfFile($groupNumber,$computerName,$tempFile);
if($ret==1){
	$nsguiCommon->writeErrMsg($const->ERR_EXEC_NVAVS_CONFIG,__FILE__,__LINE__+1);
    exit 1;
}elsif($ret==0){
##get array of scan_server's hostname,delete ddr files for statistic by hostnames
    my @servers = $comm->getScanServerList(\@content);
    system("${rrdfile_reserve} $computerName @servers");
}
exit 0;