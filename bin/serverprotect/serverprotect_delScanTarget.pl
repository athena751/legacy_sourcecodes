#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# @(#) $Id: serverprotect_delScanTarget.pl,v 1.1 2007/03/23 05:23:31 qim Exp $"
#Function: 
    #delete scan target from server protect config file.
#Arguments: 
    #$nodeNum       : the node number 0 or 1
    #$computerName  : the computer Name
    #$shareName     : the scan target name
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::NsguiCommon;
use NS::ConfCommon;
use NS::ServerProtectCommon;
use NS::ServerProtectConst;
use NS::SystemFileCVS;

my $SPCommon  = new NS::ServerProtectCommon;
my $ConfCommon = new NS::ConfCommon;
my $SPConst = new NS::ServerProtectConst;
my $cvs = new NS::SystemFileCVS;
my $nsguiCommon  = new NS::NsguiCommon;

my $export = $SPConst->SP_CONF_EXPORT;
my $export_path = $SPConst->SP_CONF_EXPORT_PATH;
my $share = $SPConst->SP_CONF_SHARE;
my $share_name = $SPConst->SP_CONF_SHARE_NAME;

if(scalar(@ARGV)!=3){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $nodeNum = shift;
my $computerName = shift;
my $shareName = shift;

my $SPConfFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
if(!(-f $SPConfFile)){
    print STDERR "GET:$SPConfFile ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $cmdGetConfigFile = "/bin/cat ".$SPConfFile;
my @fileContent = `$cmdGetConfigFile 2>/dev/null`;
my $tmpShareName;
my @tmpContent;
my $lastEndIndex = 0;

#delete specified scan target.
while(1){
    my ($startIndex,$endIndex) = $SPCommon->getSectionInfo(${share},1+$lastEndIndex,\@fileContent);
    defined($startIndex) or last;
    @tmpContent = @fileContent[($startIndex-1)..($endIndex-1)];
    $tmpShareName = $ConfCommon->getKeyValueTrimQuotation(${share_name},${share},\@tmpContent);
    if($tmpShareName eq $shareName){
        splice (@fileContent, $startIndex - 1, $endIndex - $startIndex + 1);
        last;
    }
    $lastEndIndex = $endIndex;
}
#end delete specified scan target.

#save the fileContent to temporary file
my $tmpSettingFile = "/tmp/\Q${computerName}\E.nvavs.conf.$$.tmp2";
my $delTmpFileCmd = "/bin/rm -f $tmpSettingFile";
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
open(WRITE,"|${cmd_syncwrite_o} ${tmpSettingFile}");
print WRITE @fileContent;
if(!close(WRITE)) {
    print STDERR "The $tmpSettingFile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    system("$delTmpFileCmd 2>/dev/null 1>&2");
    exit 1;
}

#apply modification
my $ret = $SPCommon->setConfFile($nodeNum,$computerName,$tmpSettingFile);
if($ret==1){
    $nsguiCommon->writeErrMsg($SPConst->ERR_EXEC_NVAVS_CONFIG,__FILE__,__LINE__+1);
    exit 1;
}

exit 0;