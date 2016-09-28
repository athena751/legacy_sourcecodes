#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setGlobalInfo.pl,v 1.10 2008/05/09 02:48:15 chenbc Exp $"

#Function: 
    #save the content in the temp file into smb.conf.%L and exec [/bin/nascifsstart] 
#Arguments: 
    #$groupNumber
    #$domainName
    #$computerName
    #$encryptPasswords
    #$interfaces
    #$serverString
    #$deadtime
    #$validUsers
    #$invalidUsers
    #$hostsAllow
    #$hostsDeny
    #$alogFileName
    #$canRead
    #$successLoggingItems
    #$errorLoggingItems
    #$dirAclValid
    #$antiVirusForGlobal

#exit code:
    #0:succeed 
    #1:failed

use strict;
use NS::SystemFileCVS;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::NsguiCommon;
use NS::ConfCommon;
use NS::CodeConvert;
use NS::ScheduleScanCommon;

my $comm       = new NS::NsguiCommon;
my $cvs        = new NS::SystemFileCVS;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;
my $ssCommon    = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=17){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber,$domainName,$computerName,$encryptPasswords,$interfaces,
    $serverString,$deadtime,$validUsers,$invalidUsers,$hostsAllow,$hostsDeny,
    $alogFileName,$canRead,$successLoggingItems,$errorLoggingItems,$dirAclValid,
    $antiVirusForGlobal) = @ARGV;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
$serverString = $codeConvert->changeUTF8Encoding($serverString, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($serverString)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
if($alogFileName ne ""){
    
    if($cifsCommon->logFileInRightArea($alogFileName, $groupNumber) == 0){
        $comm->writeErrMsg($const->ERRCODE_FILE_IS_ON_WRONG_AREA,__FILE__,__LINE__+1);
        exit 1;
    }
    if($alogFileName =~ /\/export\//){
        #need check the FS Type
        if($cifsCommon->isSXFS_MP($alogFileName, $groupNumber) == 0){
            $comm->writeErrMsg($const->ERRCODE_FILE_IS_NOT_ON_SXFS,__FILE__,__LINE__+1);
            exit 1;
        }
    }
    my $result = $cifsCommon->makeLogFileDir($alogFileName, $canRead);
    if($result == 1){
        $comm->writeErrMsg($const->ERRCODE_FILE_NAME_IS_DIRECTORY,__FILE__,__LINE__+1);
        exit 1;
    }elsif($result == 2){
        $comm->writeErrMsg($const->ERRCODE_PATH_NAME_IS_NOT_DIRECTORY,__FILE__,__LINE__+1);
        exit 1;
    }
}

my $smb_conf_File = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
if($cvs->checkout($smb_conf_File)!=0){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;
}
open(FILE,"$smb_conf_File");
my @fileContent = <FILE>;
close(FILE);

&editGlobalSection();

my $securityMode = $cifsCommon->getSecurityMode($groupNumber, $domainName, $computerName);
if($securityMode eq $const->CONST_SECURITY_MODE_LDAP){
    #set parameters for LDAP or LDAPSAM
    $cifsCommon->setLdapInfo($groupNumber, $domainName, $computerName, $encryptPasswords, \@fileContent);
}

open(WRITE,"|${cmd_syncwrite_o} ${smb_conf_File}");
print WRITE @fileContent;

my ($smbFileName4ScheduleScan, $smbConfContent4ScheduleScan) = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
if(defined($smbConfContent4ScheduleScan)){
    if($cvs->checkout($smbFileName4ScheduleScan)!=0){
		$comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
		exit 1;
    }
    $cifsCommon->updateScheduleGlobal(\@fileContent, $smbConfContent4ScheduleScan);
    open(WRITE4SCHED,"|${cmd_syncwrite_o} ${smbFileName4ScheduleScan}");
    print WRITE4SCHED @$smbConfContent4ScheduleScan;
    if(!close(WRITE) || !close(WRITE4SCHED)){
        $cvs->rollback($smb_conf_File);
        $cvs->rollback($smbFileName4ScheduleScan);
        print STDERR "The $smb_conf_File can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    if($cvs->checkin($smb_conf_File)!=0 || $cvs->checkin($smbFileName4ScheduleScan)!=0){
        $cvs->rollback($smb_conf_File);
        $cvs->rollback($smbFileName4ScheduleScan);
        $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
        exit 1;
    }
}else{
	if(!close(WRITE)) {
	     $cvs->rollback($smb_conf_File);
	     print STDERR "The $smb_conf_File can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	     exit 1;
	}
	
	if($cvs->checkin($smb_conf_File)!=0){
	    $cvs->rollback($smb_conf_File);
	    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
}

$cifsCommon->touchDirAccessConf($groupNumber, $domainName, $computerName);
system("/home/nsadmin/bin/ns_nascifsstart.sh");

if(($securityMode eq $const->CONST_SECURITY_MODE_LDAP) && ($encryptPasswords eq "yes")){
    #set passwd for LDAPSAM
    
    my @ldapSamInfo = $cifsCommon->getLdapSamParaInfo();
    my $ldapPassword = pop(@ldapSamInfo);
    my @opts = ();
    push(@opts, "-g", "DEFAULT", "-l", $domainName, "-L", $computerName, 
            "-G", $cifsCommon->getCifsPath($groupNumber), "-w", $ldapPassword);
            
    system("/usr/bin/smbpasswd", @opts);
}

$cifsCommon->writeGUILogInfo($groupNumber, $domainName, $computerName);

exit 0;

sub editGlobalSection(){

    $confCommon->setKeyValue("encrypt passwords", $encryptPasswords, "global", \@fileContent);
    
    if($interfaces ne ""){
        $confCommon->setKeyValue("interfaces", $interfaces, "global", \@fileContent);
        $confCommon->setKeyValue("bind interfaces only", "yes", "global", \@fileContent);
    }else{
        $confCommon->deleteKey("interfaces", "global", \@fileContent);
        $confCommon->deleteKey("bind interfaces only", "global", \@fileContent);
    }
    
    $confCommon->setKeyValue("server string", "\"$serverString\"", "global", \@fileContent);
    
    $confCommon->setKeyValue("deadtime", $deadtime, "global", \@fileContent);
    
    if($validUsers ne ""){
        $confCommon->setKeyValue("valid users", $validUsers, "global", \@fileContent);
    }else{
        $confCommon->deleteKey("valid users", "global", \@fileContent);
    }
    
    if($invalidUsers ne ""){
        $confCommon->setKeyValue("invalid users", $invalidUsers, "global", \@fileContent);
    }else{
        $confCommon->deleteKey("invalid users", "global", \@fileContent);
    }
    
    if($hostsAllow ne ""){
        $confCommon->setKeyValue("hosts allow", $hostsAllow, "global", \@fileContent);
    }else{
        $confCommon->deleteKey("hosts allow", "global", \@fileContent);
    }
    
    if($hostsDeny ne ""){
        $confCommon->setKeyValue("hosts deny", $hostsDeny, "global", \@fileContent);
    }else{
        $confCommon->deleteKey("hosts deny", "global", \@fileContent);
    }
    
    if($alogFileName ne ""){
        $confCommon->setKeyValue("alog file", $alogFileName, "global", \@fileContent);
        my $interval  = $confCommon->getKeyValue("alog check rotate interval", "global", \@fileContent);
        my $maxRotate = $confCommon->getKeyValue("alog max rotate",            "global", \@fileContent);
        my $maxSize   = $confCommon->getKeyValue("alog max size per file",     "global", \@fileContent);
        (defined($interval)  && $interval  ne "") or $confCommon->setKeyValue("alog check rotate interval", "1", "global", \@fileContent);
        (defined($maxRotate) && $maxRotate ne "") or $confCommon->setKeyValue("alog max rotate",            "3", "global", \@fileContent);
        (defined($maxSize)   && $maxSize   ne "") or $confCommon->setKeyValue("alog max size per file",     "5", "global", \@fileContent);
    }else{
        $confCommon->deleteKey("alog file", "global", \@fileContent);
        $confCommon->deleteKey("alog check rotate interval", "global", \@fileContent);
        $confCommon->deleteKey("alog max rotate", "global", \@fileContent);
        $confCommon->deleteKey("alog max size per file", "global", \@fileContent);
    }
    
    if($successLoggingItems ne ""){
        my $smbsuccesscmds = $cifsCommon->getSMBCmd($successLoggingItems, "global");
        $confCommon->setKeyValue("alog logging success without tid", $smbsuccesscmds, "global", \@fileContent);
    }else{
        $confCommon->deleteKey("alog logging success without tid", "global", \@fileContent);
    }
    
    if($errorLoggingItems ne ""){
        my $smberrorcmds = $cifsCommon->getSMBCmd($errorLoggingItems, "global");
        $confCommon->setKeyValue("alog logging error without tid", $smberrorcmds, "global", \@fileContent);
    }else{
        $confCommon->deleteKey("alog logging error without tid", "global", \@fileContent);
    }
    
    my $old = $confCommon->getKeyValue("dir access list file", "global", \@fileContent);
    
    if ($dirAclValid eq "yes") {        
        if(!defined($old) || ($old eq "")||($old eq "\"\"")){
            $confCommon->setKeyValue("dir access list file","%r/%D/diraccesslist.%L", "global", \@fileContent);
        }    
    }else{
        if (defined($old)) {
            $confCommon->setKeyValue("dir access list file","","global", \@fileContent);
        }
    }
    if($antiVirusForGlobal ne "") {
        $confCommon->setKeyValue("virus scan mode",$antiVirusForGlobal,"global", \@fileContent); #added by chenbc
    }
}

