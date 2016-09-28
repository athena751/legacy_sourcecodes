#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setShareOption.pl,v 1.20 2008/12/18 07:35:57 chenbc Exp $"

#Function: 
    #save the content in the temp file into smb.conf.%L and exec [/bin/nascifsstart] 
#Arguments: 
    #$groupNumber
    #$domainName
    #$computerName
    #$operation
    #$shareName
    #$connection
    #$directory
    #$comment
    #$readOnly
    #$writeList
    #$settingPassword
    #$validUser_Group
    #$invalidUser_Group
    #$hostsAllow
    #$hostsDeny
    #$serverProtect
    #$userName
    #$passwordChanged
    #$shadowCopy 2004/12/01
    #$dirAclValid 
    #$sharePurpose
    #$antiVirusForShare
    #$browseable
    #$pseudoABE

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

my $comm  = new NS::NsguiCommon;
my $cvs = new NS::SystemFileCVS;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;
my $ssCommon    = new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=24){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber,$domainName,$computerName,$operation,$shareName,$connection,
    $directory,$comment,$readOnly,$writeList,$settingPassword,$validUser_Group,
    $invalidUser_Group,$hostsAllow,$hostsDeny,$serverProtect,$userName,
    $passwordChanged,$shadowCopy,$dirAclValid,$sharePurpose,$antiVirusForShare,
    $browseable,$pseudoABE) = @ARGV;

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
$shareName = $codeConvert->changeUTF8Encoding($shareName, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
$directory = $codeConvert->changeUTF8Encoding($directory, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
$comment = $codeConvert->changeUTF8Encoding($comment, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($shareName) || !defined($directory) || !defined($comment)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}
#added for 0805 cifs limit
if(length($directory) > 1000){
    $comm->writeErrMsg($const->ERRCODE_STRING_TOOLONG_BY_EXPORTENCODING,__FILE__,__LINE__+1);
    exit 1;
}
#

my $smbContent = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);
my $issxfsMp = $cifsCommon->isSXFS_MP($directory, $groupNumber);
my $oldShadowCopy = $confCommon->getKeyValue("sxfs shadow copy",  $shareName,$smbContent);
my $oldFileTimes = "";
if(defined($issxfsMp) && $issxfsMp == 0) {
    $oldFileTimes = $confCommon->getKeyValue("sxfsfw filetimes", $shareName, $smbContent);
} elsif (defined($issxfsMp) && $issxfsMp != 0) {
    $oldFileTimes = $confCommon->getKeyValue("dos filetimes", $shareName, $smbContent);
}
defined($oldShadowCopy)        or $oldShadowCopy        = "";
defined($oldFileTimes)         or $oldFileTimes         = "";
$oldShadowCopy = $cifsCommon->convertBoolean($oldShadowCopy, "no");
$oldFileTimes = $cifsCommon->convertBoolean($oldFileTimes, "no");

my $passwd = <STDIN>;
chomp($passwd);

if($operation eq "add"){
    if($cifsCommon->isShareNameUsed($groupNumber, $domainName, $computerName, $shareName) eq "true"){
        $comm->writeErrMsg($const->ERRCODE_SHARE_NAME_EXIST,__FILE__,__LINE__+1);
        exit 1;
    }
    if($sharePurpose eq "backup" && $issxfsMp == 1) {
        $comm->writeErrMsg($const->ERRCODE_BACKUPSHARECANNOTUSESXFS,__FILE__,__LINE__+1);
        exit 1;
    }
}

my $mountPointInfo = $cifsCommon->getMpInfo($groupNumber, $directory);

if($cifsCommon->isMpPath($directory, $mountPointInfo) eq "false"){
    $comm->writeErrMsg($const->ERRCODE_PATH_NOT_START_WITH_MP,__FILE__,__LINE__+1);
    exit 1;
}

if($shadowCopy eq "yes"){
    # check that whether the dmapi is used 
    my $dmapi = $cifsCommon->chkDMAPI($groupNumber,$directory);
    if(defined($dmapi) && ($dmapi eq "true")){
        $comm->writeErrMsg($const->ERRCODE_DMAPI_WAS_USED,__FILE__,__LINE__+1);
        exit 1;
    }
}

# if use dir access control ,mount point type can not be "sxfsfw"
if ($dirAclValid eq "yes") {
    my $fstype = &getFSType($directory,$mountPointInfo);
    if($fstype eq "sxfsfw") {
        $comm->writeErrMsg($const->ERRCODE_USE_ACCESS_CONTROL_FOR_SXFSFW,__FILE__, __LINE__+1);
        exit 1;
    }  
}

my $setAuthResult = $cifsCommon->setUserDB_forPath($directory, $mountPointInfo);
if($setAuthResult eq "no_region_for_set"){
    $comm->writeErrMsg($const->ERRCODE_NO_UNIX_DOMAIN_TO_ADD_AUTH,__FILE__,__LINE__+1);
    exit 1;
}elsif($setAuthResult eq "set_failed"){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_ADD_AUTH,__FILE__,__LINE__+1);
    exit 1;
}

my $securityMode = $cifsCommon->getSecurityMode($groupNumber, $domainName, $computerName);

#get the share user name for writing the file
if($securityMode eq $const->CONST_SECURITY_MODE_SHARE){
    if(($settingPassword eq "yes") && ($userName eq "")){
        $userName = $cifsCommon->getDefaultShareUser($groupNumber, $domainName);
        if($userName eq "1"){
            #failed to get the user name
            $comm->writeErrMsg($const->ERRCODE_FAILED_TO_GET_USER_NAME_FOR_SHARE_MODE,__FILE__,__LINE__+1);
            exit 1;
        }
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

if($operation eq "add"){
    push(@fileContent, "[$shareName]\n");
    $confCommon->setKeyValue("sxfs quota", "yes", $shareName, \@fileContent);
    $confCommon->setKeyValue("csc policy", "disable", $shareName, \@fileContent);
    $confCommon->setKeyValue("veto oplock files", "/desktop.ini/", $shareName, \@fileContent);
    #the default value of "writeback" is yes
    $confCommon->setKeyValue("writeback", "yes", $shareName, \@fileContent);
    if(defined($issxfsMp) && $issxfsMp == 0) {
        $confCommon->setKeyValue("sxfsfw filetimes", "yes", $shareName, \@fileContent);
    } elsif (defined($issxfsMp) && $issxfsMp != 0) {
        $confCommon->setKeyValue("dos filetimes", "yes", $shareName, \@fileContent);
    }

    if($sharePurpose eq "realtime_scan") {
        $confCommon->setKeyValue("virus scan exclusive share", "yes", $shareName, \@fileContent);
    } elsif($sharePurpose eq "backup") {
        $confCommon->setKeyValue("backup exclusive share", "yes", $shareName, \@fileContent);
    }
}
my $oldDirAclValid = $confCommon->getKeyValue("dir access control", $shareName, \@fileContent);
&editShareSection();
&editShadowOption();

if(($dirAclValid eq "yes")
&&((!defined($oldDirAclValid))
	 ||($oldDirAclValid eq "no")
     ||($oldDirAclValid eq "")
     ||($oldDirAclValid eq "\"\"")
     )){
    my $dirAccessConfFile = $confCommon->getKeyValue("dir access list file", "global", \@fileContent);
    if(!defined($dirAccessConfFile) 
    	|| ($dirAccessConfFile eq "")
    	||($dirAccessConfFile eq "\"\"")
      ){
        #set [dir access list file = %r/%D/diraccesslist.%L] in global section
        $confCommon->setKeyValue("dir access list file", "%r/%D/diraccesslist.%L", "global", \@fileContent);
    }
}

open(WRITE,"|${cmd_syncwrite_o} ${smb_conf_File}");
print WRITE @fileContent;

my $smbFileName4ScheduleScan = undef;
my $smbConfContent4ScheduleScan = undef;
if($operation eq "modify" && $sharePurpose eq "realtime_scan"){
    ($smbFileName4ScheduleScan, $smbConfContent4ScheduleScan) = $ssCommon->getFileContent($groupNumber, $domainName, $computerName);
}
if(defined($smbConfContent4ScheduleScan)){
    if($cvs->checkout($smbFileName4ScheduleScan)!=0){
	    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
    $cifsCommon->updateScheduleShareSection($shareName, \@fileContent, $smbConfContent4ScheduleScan);
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

if($securityMode eq $const->CONST_SECURITY_MODE_SHARE){
    if(($settingPassword eq "yes") && ($passwordChanged eq "true")){
    #set the password for the share
    my @opts = ();
    push(@opts, "-a", $userName, ${passwd}, "-g", "DEFAULT", "-l", $domainName,
             "-L", $computerName, "-G", $cifsCommon->getCifsPath($groupNumber));
    system("/usr/bin/smbpasswd", @opts);
    }
}

$cifsCommon->writeGUILogInfo($groupNumber, $domainName, $computerName);
if(($dirAclValid eq "yes")
        &&((!defined($oldDirAclValid))
    		||($oldDirAclValid eq "no")
     		||($oldDirAclValid eq "")
     		||($oldDirAclValid eq "\"\"")
     	)){
         $comm->writeErrMsg($const->ERRCODE_SET_GLOBALOPTION,__FILE__,__LINE__+1);
     exit 1;
}

exit 0;

sub editShareSection(){

    $confCommon->setKeyValue("available", $connection, $shareName, \@fileContent);

#    if($serverProtect eq "yes"){
#        $confCommon->setKeyValue("writeback", "no", $shareName, \@fileContent);
#    }else{
#        $confCommon->setKeyValue("writeback", "yes", $shareName, \@fileContent);
#    }

    if($sharePurpose eq "realtime_scan" || $sharePurpose eq "backup" || 
       $securityMode eq $const->CONST_SECURITY_MODE_SHARE) {
        $confCommon->deleteKey("pseudo abe", $shareName, \@fileContent);
    }else{
        $confCommon->setKeyValue("pseudo abe", $pseudoABE, $shareName, \@fileContent);
    }
    
    $confCommon->setKeyValue("read only", $readOnly, $shareName, \@fileContent);
    if($securityMode ne $const->CONST_SECURITY_MODE_SHARE){
        if(($readOnly eq "yes") && ($writeList ne "")){
            $confCommon->setKeyValue("write list", $writeList, $shareName, \@fileContent);
        }else{
            $confCommon->deleteKey("write list", $shareName, \@fileContent);
        }
    }
    if($comment ne ""){
        $confCommon->setKeyValue("comment", "\"$comment\"", $shareName, \@fileContent);
    }else{
        $confCommon->setKeyValue("comment", "\"\"", $shareName, \@fileContent);
    }

    $confCommon->setKeyValue("path", $directory, $shareName, \@fileContent);
    
    if($securityMode eq $const->CONST_SECURITY_MODE_SHARE){
        if($settingPassword eq "yes"){
            $confCommon->setKeyValue("username", $userName, $shareName, \@fileContent);
            $confCommon->deleteKey("public", $shareName, \@fileContent);
        }else{
            $confCommon->setKeyValue("public", "yes", $shareName, \@fileContent);
            $confCommon->deleteKey("username", $shareName, \@fileContent);
        }
    }
    
    if($validUser_Group ne ""){
        $confCommon->setKeyValue("valid users", $validUser_Group, $shareName, \@fileContent);
        
    }else{
        $confCommon->deleteKey("valid users", $shareName, \@fileContent);
    }
    if($hostsAllow ne ""){
        $confCommon->setKeyValue("hosts allow", $hostsAllow, $shareName, \@fileContent);
    }else{
        $confCommon->deleteKey("hosts allow", $shareName, \@fileContent);
    }
    
    if($operation eq "modify"){
        $confCommon->deleteKey("guest ok", $shareName, \@fileContent);
        $confCommon->deleteKey("writeable", $shareName, \@fileContent);
    }
    
    if($sharePurpose eq "realtime_scan" || $sharePurpose eq "backup") {
        $confCommon->setKeyValue("browseable", $browseable, $shareName, \@fileContent);
    } else {
        if ($dirAclValid eq "yes") {
            $confCommon->setKeyValue("dir access control","yes", $shareName, \@fileContent);
        }else{    
            if (defined($oldDirAclValid)) {
                $confCommon->setKeyValue("dir access control","no",$shareName, \@fileContent);
            }
        }
        if($invalidUser_Group ne ""){
            $confCommon->setKeyValue("invalid users", $invalidUser_Group, $shareName, \@fileContent);
        }else{
            $confCommon->deleteKey("invalid users", $shareName, \@fileContent);
        }
        if($hostsDeny ne ""){
            $confCommon->setKeyValue("hosts deny", $hostsDeny, $shareName, \@fileContent);
        }else{
            $confCommon->deleteKey("hosts deny", $shareName, \@fileContent);
        }
        if($antiVirusForShare eq "yes"){
            $confCommon->deleteKey("no scan", $shareName, \@fileContent);
        }else{
            $confCommon->setKeyValue("no scan", "yes", $shareName, \@fileContent);
            if(!$confCommon->hasKey("virus scan mode", "global", \@fileContent)){
                $confCommon->setKeyValue("virus scan mode", "no", "global", \@fileContent);
            }
        }
    }
}

sub editShadowOption(){

    if ($shadowCopy eq "yes") {
        $confCommon->setKeyValue("sxfs shadow copy ", $shadowCopy, $shareName, \@fileContent);
        if($oldShadowCopy eq "no" && $oldFileTimes eq "no") {
            if(defined($issxfsMp) && $issxfsMp == 0) {
			    $confCommon->setKeyValue("sxfsfw filetimes", "yes", $shareName, \@fileContent);
			} elsif(defined($issxfsMp) && $issxfsMp != 0) {
			    $confCommon->setKeyValue("dos filetimes", "yes", $shareName, \@fileContent);
			}
        }
    }else{
        #get the old shadow option
        my $oldShadowCopy = $confCommon->getKeyValue("sxfs shadow copy",$shareName, \@fileContent);

        if(defined($oldShadowCopy)) {
            #need to set the options for shadow copy
            $confCommon->setKeyValue("sxfs shadow copy", $shadowCopy, $shareName, \@fileContent);
        }
    
    }
}

sub getFSType(){
    my ($path,$mplist) = @_;
    my $directMP = $cifsCommon->getDirectMP($path);
    my $type ="";
    foreach(@$mplist){
        if(/^([^,]+),([^,]+),/){
           if($directMP eq $1){
               $type = $2;  
               return $type;
           }
        }
    }
}
