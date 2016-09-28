#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# @(#) $Id: serverprotect_addScanTargetInfo.pl,v 1.1 2007/03/23 05:23:31 qim Exp $"
#Function: 
    #add scan target from server protect config file.
#Arguments: 
    #$tmpFile       : the path of the tmp file.
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
my $share_path = $SPConst->SP_CONF_SHARE_PATH;
my $read_check = $SPConst->SP_CONF_SHARE_READ_CHECK;
my $write_check = $SPConst->SP_CONF_SHARE_WRITE_CHECK;

if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $tmpFile = shift;

my $cmdGetTmpFile = "/bin/cat ".$tmpFile;
my $cmdDelTmpFile = "/bin/rm -f ".$tmpFile;
if(!(-f $tmpFile) || !(-s $tmpFile)){
    print STDERR "GET:$tmpFile ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    system("$cmdDelTmpFile 2>/dev/null 1>&2");
    exit 1;
}
my ($nodeNum,$computerName,$scanTargetInfo,$optionCheck) = `$cmdGetTmpFile 2>/dev/null`;
system("$cmdDelTmpFile 2>/dev/null 1>&2");
chomp($nodeNum);
chomp($computerName);
chomp($scanTargetInfo);
chomp($optionCheck);

my $SPConfFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
if(!(-f $SPConfFile)){
    print STDERR "GET:$SPConfFile ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $cmdGetConfigFile = "/bin/cat ".$SPConfFile;
my @fileContent = `$cmdGetConfigFile 2>/dev/null`;

#add specified scan target.

my @scanTargetInfos = split(";",$scanTargetInfo);
my @optionChecks = split(",",$optionCheck);
foreach(@scanTargetInfos){
    my @scanTarget = split(",",$_);
    my @scanTargetInfoToSet;
    push(@scanTargetInfoToSet,"[${share}]\n");
    push(@scanTargetInfoToSet,"${share_name} = \"$scanTarget[0]\"\n");
    push(@scanTargetInfoToSet,"${share_path} = \"$scanTarget[1]\"\n");
    push(@scanTargetInfoToSet,"${read_check} = $optionChecks[0]\n");
    push(@scanTargetInfoToSet,"${write_check} = $optionChecks[1]\n");
    push(@fileContent,@scanTargetInfoToSet);
}

#end modify specified scan target.

#add the fileContent to temporary file
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