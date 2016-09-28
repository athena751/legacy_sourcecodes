#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getGlobalInfo.pl,v 1.6 2007/08/23 02:48:03 fengmh Exp $"

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
    #   key=value
    #
    #key:
    #securityMode,encryptPasswords,ldapAnonymous,allInterfaces,allInterfacesLabel,interfaces,serverString,
    #deadtime,validUsers,invalidUsers,hostsAllow,hostsDeny,alogFileName,canReadLog,successLoggingItems
    #,errorLoggingItems,dirAccessControlAvailable,logFileInRightArea,antiVirusForGlobal,reasonForNoInterface
    

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::CodeConvert;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName) = @ARGV;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}

my $smbContent = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);
my ($allInterfaces, $allInterfacesLabel) = $cifsCommon->getAllInterfaces();

my $ldapAnonymous = $cifsCommon->getLdapAnonymous();

my $encryptPasswords = $confCommon->getKeyValue("encrypt passwords", "global", $smbContent);
my $interfaces       = $confCommon->getKeyValue("interfaces",       "global", $smbContent);
my $serverString     = $confCommon->getKeyValue("server string",    "global", $smbContent);
my $deadtime         = $confCommon->getKeyValue("deadtime",         "global", $smbContent);
my $validUsers       = $confCommon->getKeyValue("valid users",      "global", $smbContent);
my $invalidUsers     = $confCommon->getKeyValue("invalid users",    "global", $smbContent);
my $hostsAllow       = $confCommon->getKeyValue("hosts allow",      "global", $smbContent);
my $hostsDeny        = $confCommon->getKeyValue("hosts deny",       "global", $smbContent);
my $alogFileName     = $confCommon->getKeyValue("alog file",        "global", $smbContent);
my $dirAclValid      = $confCommon->getKeyValue("dir access list file","global", $smbContent);
my $antiVirusForGlobal = $confCommon->getKeyValue("virus scan mode", "global", $smbContent);


defined($encryptPasswords) or $encryptPasswords = "";
defined($interfaces)       or $interfaces       = "";
defined($serverString)     or $serverString     = "";
defined($deadtime)         or $deadtime         = "";
defined($validUsers)       or $validUsers       = "";
defined($invalidUsers)     or $invalidUsers     = "";
defined($hostsAllow)       or $hostsAllow       = "";
defined($hostsDeny)        or $hostsDeny        = "";
defined($alogFileName)     or $alogFileName     = "";
defined($antiVirusForGlobal) or $antiVirusForGlobal = "no";


# added by chenbc
#
my $reasonForNoInterface = "";
if($allInterfaces eq ""){
    $reasonForNoInterface = $const->CONST_NO_SERVICE_NETWORK;
}else{
	my ($unusedInterfaces, $unusedInterfacesLabel) = 
	    $cifsCommon->getUnusedInterfaces($groupNumber, $allInterfaces, $allInterfacesLabel, $interfaces);
	if($unusedInterfaces eq ""){
	    $reasonForNoInterface = $const->CONST_NO_REMAINING_INTERFACE;
	}
	($allInterfaces, $allInterfacesLabel) = ($unusedInterfaces, $unusedInterfacesLabel);
}


$encryptPasswords = $cifsCommon->convertBoolean($encryptPasswords, "no");
$serverString=~s/^\"|\"$//g;

my $canReadLog = "no";
if ($alogFileName ne ""){
    my $logdirname = substr($alogFileName,0,rindex($alogFileName,"/")+1);
    $canReadLog = $cifsCommon->checkUserRead($logdirname);
}
defined($canReadLog) or $canReadLog = "no";

if (defined($dirAclValid)&&($dirAclValid ne "")&&(($dirAclValid ne "\"\""))) {
    $dirAclValid  = "yes";
}else{
    $dirAclValid = "no";
}

my $successLoggingItems = "";
my $errorLoggingItems = "";

my $smbsuccesscmds = $confCommon->getKeyValue("alog logging success without tid", "global", $smbContent);
my $smberrorcmds   = $confCommon->getKeyValue("alog logging error without tid",   "global", $smbContent);

if (defined($smbsuccesscmds) && ($smbsuccesscmds ne "")){
    $successLoggingItems = $cifsCommon->getLoggingItems($smbsuccesscmds,"global");
}
if (defined($smberrorcmds) && ($smberrorcmds ne "")){
    $errorLoggingItems   = $cifsCommon->getLoggingItems($smberrorcmds,  "global");
}

my $serverStringForPrint = $codeConvert->changeUTF8Encoding($serverString, $expGroupEncoding, $codeConvert->ENCODING_UTF_8);
$serverString = defined($serverStringForPrint) ? $serverStringForPrint : $serverString;

print "encryptPasswords=$encryptPasswords\n";
print "ldapAnonymous=$ldapAnonymous\n";
print "allInterfaces=$allInterfaces\n";
print "allInterfacesLabel=$allInterfacesLabel\n";
print "interfaces=$interfaces\n";
print "serverString=$serverString\n";
print "deadtime=$deadtime\n";
print "validUsers=$validUsers\n";
print "invalidUsers=$invalidUsers\n";
print "hostsAllow=$hostsAllow\n";
print "hostsDeny=$hostsDeny\n";
print "alogFile=$alogFileName\n";
print "canReadLog=$canReadLog\n";
print "successLoggingItems=$successLoggingItems\n";
print "errorLoggingItems=$errorLoggingItems\n";
print "dirAccessControlAvailable=$dirAclValid\n";

my $logFileInRightArea = "yes";
if($alogFileName ne ""){
    if($cifsCommon->logFileInRightArea($alogFileName, $groupNumber) == 0){
        $logFileInRightArea = "no";
    }
}
print "logFileInRightArea=$logFileInRightArea\n";
$antiVirusForGlobal = $cifsCommon->equalsIgnoreCase($antiVirusForGlobal, "yes");
print "antiVirusForGlobal=$antiVirusForGlobal\n";

print "reasonForNoInterface=$reasonForNoInterface\n";

exit 0;