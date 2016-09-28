#!/usr/bin/perl
#
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# @(#) $Id: serverprotect_setScanServerInfo.pl,v 1.4 2008/12/18 08:01:06 wanghui Exp $"
#Function: 
    #set server protect scan server info.
#Arguments: 
    #$tmpFile      : the path of the tmp file.
    #                the arguments saved in the tmp file.
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::ConfCommon;
use NS::ServerProtectCommon;
use NS::ServerProtectConst;
use NS::CIFSCommon;
use NS::SystemFileCVS;
my $SPCommon  = new NS::ServerProtectCommon;
my $ConfCommon = new NS::ConfCommon;
my $SPConst = new NS::ServerProtectConst;
my $cifsCommon = new NS::CIFSCommon;
my $cvs = new NS::SystemFileCVS;

my $export = $SPConst->SP_CONF_EXPORT;
my $export_path = $SPConst->SP_CONF_EXPORT_PATH;
my $encoding = $SPConst->SP_CONF_EXPORT_ENCODING;
my $extension = $SPConst->SP_CONF_EXPORT_EXTENSION;
my $share = $SPConst->SP_CONF_SHARE;
my $share_name = $SPConst->SP_CONF_SHARE_NAME;
my $share_path = $SPConst->SP_CONF_SHARE_PATH;
my $write_check = $SPConst->SP_CONF_SHARE_WRITE_CHECK;
my $read_check = $SPConst->SP_CONF_SHARE_READ_CHECK;
my $server = $SPConst->SP_CONF_SERVER;
my $scan_server = $SPConst->SP_CONF_SERVER_SCAN_SERVER;
my $interface = $SPConst->SP_CONF_SERVER_INTERFACE;
#my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
if(scalar(@ARGV)!=9){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my ($nodeNum,$exportPath,$domainName,$computerName,
    $fileExtension,$ludbUsers,$scanServerInfo,$ludbChange,$scanServerChange) = @ARGV;

my $SPConfFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
my @fileContent=();
#my $ret;
if(!(-f $SPConfFile)){
    my $SPEncoding = $SPCommon->getEncoding($nodeNum,$exportPath);
    if(!defined($SPEncoding)) {
        print STDERR "GET EXPORT GROUP ENCODING ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    push(@fileContent,"[${export}]\n");
    push(@fileContent,"${export_path} = \"$exportPath\"\n");
    push(@fileContent,"${encoding} = $SPEncoding\n");
}else{
    open(FILE,"$SPConfFile");
    @fileContent = <FILE>;
    close(FILE);
}
if($fileExtension eq ""){
    $ConfCommon->deleteKey(${extension},${export},\@fileContent);
}else{
    $ConfCommon->setKeyValueAddQuotation(${extension},$fileExtension,${export},\@fileContent);
}

my $ludbUser4cifsSmb = "";
if($ludbChange eq "yes"){
	$ConfCommon->deleteKey("ludb_user",${export},\@fileContent);
	if($ludbUsers ne "") {
        my @ludbUser=split(":",$ludbUsers);
        foreach(@ludbUser){
            if($_ =~ /\s+/){
                $ludbUser4cifsSmb = $ludbUser4cifsSmb."\"$domainName+$_\""." ";
            }else{
                $ludbUser4cifsSmb = $ludbUser4cifsSmb.$domainName."+".$_." ";
            }
        }
        $ludbUser4cifsSmb =~ s/\s+$//;        
        my ($startIndex,$endIndex) = $SPCommon->getSectionInfo(${export},1,\@fileContent);
    
        my @ludbUserArray = ();
        foreach(@ludbUser){
	        push(@ludbUserArray,"ludb_user = \"$_\"\n");
        }
        splice(@fileContent,$endIndex,0,@ludbUserArray);
    }
}
#setting scan server information according to $scanServerInfo.
my %scanServerInfo = ();
my @tmpContent;
my $lastEndIndex = 0;
my $tmpHostName;
while(1){
my ($startIndex,$endIndex) = $SPCommon->getSectionInfo(${server},1+$lastEndIndex,\@fileContent);
if(!defined($startIndex)){
    last;
}
@tmpContent = @fileContent[($startIndex-1)..($endIndex-1)];
$tmpHostName = $ConfCommon->getKeyValueTrimQuotation(${scan_server},${server},\@tmpContent);
if(!defined($tmpHostName)){
    $lastEndIndex = $endIndex;
	
}
$scanServerInfo{$tmpHostName} = "$startIndex,$endIndex";
$lastEndIndex = $endIndex;
}

my @scanServerInfoArray = split(";",$scanServerInfo);
my @scanServerInfoToSet = ();
my @scanServerList4DelRRD = ();
my $scanServer4Cifs = "";
foreach(@scanServerInfoArray){
    my @scanServerElem=split(",",$_);
    if($scanServerChange eq "yes"){
        push(@scanServerList4DelRRD,$scanServerElem[0]);
        $scanServer4Cifs = $scanServer4Cifs.$scanServerElem[0]." ";
    }
    if(defined($scanServerInfo{$scanServerElem[0]})){
        my ($startIndex,$endIndex) = split(",",$scanServerInfo{$scanServerElem[0]});
        @tmpContent = @fileContent[($startIndex-1)..($endIndex-1)];
        $ConfCommon->setKeyValueAddQuotation(${interface},$scanServerElem[1],${server},\@tmpContent); 
        push(@scanServerInfoToSet,@tmpContent);
    }else{
        push(@scanServerInfoToSet,"[${server}]\n");
        push(@scanServerInfoToSet,"${scan_server} = \"$scanServerElem[0]\"\n");
        push(@scanServerInfoToSet,"${interface} = \"$scanServerElem[1]\"\n");
    }
}
$scanServer4Cifs =~ s/\s+$//;
$ConfCommon->deleteSection(${server},\@fileContent);
my ($startIndex,$endIndex) = $SPCommon->getSectionInfo(${export},1,\@fileContent);
splice(@fileContent,$endIndex,0,@scanServerInfoToSet);
#end setting scan server info.

my $tmpSettingFile = "/tmp/nvavs.conf.$$";
my $delTmpFileCmd = "/bin/rm -f $tmpSettingFile";
system("$delTmpFileCmd 2>/dev/null 1>&2");
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
open(WRITE,"|${cmd_syncwrite_o} ${tmpSettingFile}");
print WRITE @fileContent;
if(!close(WRITE)){
    print STDERR "The $tmpSettingFile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    system("$delTmpFileCmd 2>/dev/null 1>&2");
    exit 1;
}
my $ret = $SPCommon->setConfFile($nodeNum,$computerName,$tmpSettingFile);
if($ret != 0){
    print STDERR "SETTING ERROR ! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    system("$delTmpFileCmd 2>/dev/null 1>&2");
    exit 1;
}
system("$delTmpFileCmd 2>/dev/null 1>&2");
if($scanServerChange eq "yes"){
    my $delRRDFileCmd = "/opt/nec/nsadmin/bin/statis_reserveNvavsRRDFile.pl";
    system("$delRRDFileCmd $computerName @scanServerList4DelRRD 2>/dev/null 1>&2");
}

#setting cifs smb conf.
my $cifsConfFile = $cifsCommon->getSmbFileName($nodeNum,$domainName,$computerName);
if(!(-f $cifsConfFile)){
    exit 0;
}
open(FILE, $cifsConfFile);
my @cifsContent = <FILE>;
close(FILE);
if(($ludbChange eq "yes")||($scanServerChange eq "yes")){
	
    my ($shareNameRef, $shareSectionIndexRef) = $cifsCommon->getAllShareInfo(\@cifsContent);
    push(@$shareSectionIndexRef,scalar(@cifsContent));
    my $shareNumbers = scalar(@$shareNameRef);
    if($shareNumbers > 0){
        my $fsTypeInfo = {};
        if($ludbChange eq "yes"){
            $fsTypeInfo = $cifsCommon->getFstypeOfAllMP($nodeNum);
        }
        for(my $tmpIndex = $shareNumbers-1; $tmpIndex >=0; $tmpIndex--){
            my $shareType;
            my $shareName = @$shareNameRef[$tmpIndex];
            my $endIndex = @$shareSectionIndexRef[$tmpIndex + 1] - 1;
            my $startIndex = @$shareSectionIndexRef[$tmpIndex];
            my @tmpSection = @cifsContent[@$shareSectionIndexRef[$tmpIndex]..$endIndex];
            $shareType = $cifsCommon->getShareType($shareName,\@tmpSection);
            if($shareType ne "realtime_scan"){
                next;
            }
            if($ludbChange eq "yes"){
                if($ludbUsers eq ""){
            	      $ConfCommon->deleteKey("valid users",$shareName,\@tmpSection);
            	  }else{
                    my $path = $ConfCommon->getKeyValue('path', $shareName, \@tmpSection);
            	      if(defined($path) && $path ne ''){
            	          my $currentType = $$fsTypeInfo{$cifsCommon->getDirectMP($path)};
            	          if(lc($currentType) eq "sxfsfw"){
            	              $ConfCommon->setKeyValue("valid users",$ludbUser4cifsSmb,$shareName,\@tmpSection);
            	          }else {
            	              $ConfCommon->deleteKey("valid users",$shareName,\@tmpSection);
            	          }
            	      }
                }
            }
            if($scanServerChange eq "yes"){
            	$ConfCommon->setKeyValue("hosts allow",$scanServer4Cifs,$shareName,\@tmpSection);
            }
            
            splice(@cifsContent,$startIndex,$endIndex-$startIndex+1,@tmpSection);
            
        }
    }
    

    if($cvs->checkout($cifsConfFile)!= 0){
        exit 0;
    }
    open(WRITE,"|${cmd_syncwrite_o} ${cifsConfFile}");
    print WRITE @cifsContent;
    if(!close(WRITE)) {
        $cvs->rollback($cifsConfFile);
        exit 0;
    }
    if($cvs->checkin($cifsConfFile)!= 0){
        $cvs->rollback($cifsConfFile);
        exit 0;
    }
    system("/home/nsadmin/bin/ns_nascifsstart.sh 2>/dev/null 1>&2");
}
exit 0;