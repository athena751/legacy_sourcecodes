#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: usermapping_changeNetbios.pl,v 1.3 2008/05/29 04:56:27 fengmh Exp $"
#
#Function:
#    change netbios name(Only windows PWD domain type has been completed).
#    !!! Attention : Access status is NOT checked !!!
#    Please check Access status before calling this script !!!
#Arguments:
#    $groupNumber
#    $domainName
#    $newComputerName
#    $oldComputerName
#    $isFriend
###       "true" or "false".
###       when it is friend node, do not need to edit virtual_servers, 
###       smb.conf.<NETBIOS>,and do not need to restart nascifsstart.
#Exit code:
#    0 : change successful
#    1 : executed failed
#Output:
#    null
#

use strict;
use NS::NsguiCommon;
use NS::SystemFileCVS;
use NS::UsermappingCommon;
use NS::UsermappingConst;
use NS::CIFSCommon;

my $comm = new NS::NsguiCommon;
my $cvs  = new NS::SystemFileCVS;
my $umComm = new NS::UsermappingCommon;
my $umCon  = new NS::UsermappingConst;
my $cifsCom = new NS::CIFSCommon;

# parameters for rollback.
my @fileName;
my @operation;
my @needDo;

# when failed to delete old computer's client user database, virtual_servers and 
# smb.conf.NETBIOS need to rollback.
# do NOT delete new computer's client user database.
# if has changed name rule, rollback name rule too.
#
# parameters for rollback virtual_servers and smb.conf.NETBIOS when failed to 
# delete old computer's client user database.
my @fileNameForDelErrRollback;
my @operationForDelErrRollback;
my @needDoForDelErrRollback;

if(scalar(@ARGV) != 5){
    $comm->writeErrMsg("Parameter number error!");
    exit 1;
}

my ($groupNo, $domainName, $newComputerName, $oldComputerName, $isFriend) = @ARGV;
my $new_domPlusCom = $domainName."+".$newComputerName;
my $old_domPlusCom = $domainName."+".$oldComputerName;

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_m = $cvs->COMMAND_NSGUI_SYNCWRITE_M;
my $cmd_syncwrite_a = $cvs->COMMAND_NSGUI_SYNCWRITE_A;

# check if new computer has been set native or not.
my $hasSetNative = $umComm->hasSetNative($groupNo, $new_domPlusCom, "win");
if($hasSetNative eq "true") {
    &printError_exit($umCon->ERROR_CODE_NATIVEEXIST, $umCon->ERROR_MSG_NATIVEEXIST, __LINE__);
}

# get old computer's native info.
my $nativeInfoAddr = $umComm->getNative($groupNo, $old_domPlusCom, "win");
if(!defined($nativeInfoAddr) || $nativeInfoAddr eq "") {
    &printError_exit($umCon->ERROR_CODE_GETNATIVEINFOFAILED, $umCon->ERROR_MSG_GETNATIVEINFOFAILED, __LINE__);
}
my @nativeInfo = @$nativeInfoAddr;
my $domainType = $nativeInfo[0];
my $region = $nativeInfo[1];
#$nativeInfo[2] is domainName+computeName.
my $passwdPath = "";
my $groupPath  = "";
my $ludbName = "";
if($domainType eq "PWDDomain4Win") {
    $passwdPath = $nativeInfo[3];
    $groupPath  = $nativeInfo[4];
    my @dList = split("/", $passwdPath);
    $ludbName = $dList[scalar(@dList) - 2];
}

# edit virtual_servers. del $oldComputerName
# do NOT need to edit on friend node.
my $vsPath = $umComm->getVSPath($groupNo);
my @virtual_servers_conf;
my @virtual_servers_delOld = ();
if($isFriend eq "false") {
    if(! -f $vsPath) {
        &printError_exit($umCon->ERROR_CODE_EDIT_VIRTUAL_SERVERS_FAILED, $umCon->ERROR_MSG_VIRTUAL_SERVERS_NOTEXIST, __LINE__);
    }
    @virtual_servers_conf = `/bin/cat $vsPath 2>/dev/null`;
    foreach(@virtual_servers_conf) {
        if(/^\s*(\S+)\s+${domainName}\s+${oldComputerName}\s*$/) {
            $_ = $1." ".${domainName}." ".${newComputerName}."\n";
        } else {
            push(@virtual_servers_delOld, $_);
        }
    }

    if($cvs->checkout($vsPath)!=0){
        &printError_exit($umCon->ERROR_CODE_EDIT_VIRTUAL_SERVERS_FAILED, $umCon->ERROR_MSG_CHECKOUT_VIRTUAL_SERVERS, __LINE__);
    }
    push(@fileName, $vsPath);
    push(@operation, "rollback");
    push(@needDo, ($isFriend eq "false")?"true":"false");
    if(!open(WRITE,"|${cmd_syncwrite_o} ${vsPath}")) {
        &rollback(\@fileName, \@operation, \@needDo);
        &printError_exit($umCon->ERROR_CODE_EDIT_VIRTUAL_SERVERS_FAILED, $umCon->ERROR_MSG_OPEN_VIRTUAL_SERVERS, __LINE__);
    }
    print WRITE @virtual_servers_delOld;
    if(!close(WRITE)) {
        &rollback(\@fileName, \@operation, \@needDo);
        &printError_exit($umCon->ERROR_CODE_EDIT_VIRTUAL_SERVERS_FAILED, $umCon->ERROR_MSG_CLOSE_VIRTUAL_SERVERS, __LINE__);
    }
}

#change smb.conf.netbios name. smb.conf.$oldComputerName -> $newComputerName
#do NOT need to edit on friend node.
my $smbFilePath_old = $cifsCom->getSmbFileName($groupNo, $domainName, $oldComputerName);
my $smbFilePath_new = $cifsCom->getSmbFileName($groupNo, $domainName, $newComputerName);
my $flag_changed_smbFileName = 0;
if($isFriend eq "false") {
    if(-f $smbFilePath_old) {
        system("/bin/rm -f $smbFilePath_new 2>/dev/null");
        if($cvs->checkout($smbFilePath_old)!=0){
            &rollback(\@fileName, \@operation, \@needDo);
            &printError_exit($umCon->ERROR_CODE_CHANGE_SMB_FILE_NAME_FAILED, $umCon->ERROR_MSG_CHECKOUT_SMB_FILE, __LINE__);
        }
        $flag_changed_smbFileName = 1;
        unshift(@fileName, $smbFilePath_old);
        unshift(@operation, "rollback");
        unshift(@needDo, ($isFriend eq "false" && $flag_changed_smbFileName == 1)?"true":"false");
        unshift(@fileName, $smbFilePath_new);
        unshift(@operation, "del");
        unshift(@needDo, ($isFriend eq "false" && $flag_changed_smbFileName == 1)?"true":"false");
        system("${cmd_syncwrite_m} ${smbFilePath_old} ${smbFilePath_new}");
        if($? != 0) {
            &rollback(\@fileName, \@operation, \@needDo);
            &printError_exit($umCon->ERROR_CODE_CHANGE_SMB_FILE_NAME_FAILED, $umCon->ERROR_MSG_CHANGE_SMB_FILE_NAME, __LINE__);
        }
    }
}

# edit virtual_servers. add $newComputerName
# do NOT need to edit on friend node.
if($isFriend eq "false") {
    if(!open(WRITE,"|${cmd_syncwrite_o} ${vsPath}")) {
        &rollback(\@fileName, \@operation, \@needDo);
        &printError_exit($umCon->ERROR_CODE_EDIT_VIRTUAL_SERVERS_FAILED, $umCon->ERROR_MSG_OPEN_VIRTUAL_SERVERS, __LINE__);
    }
    unshift(@fileName, $vsPath);
    unshift(@operation, "write");
    unshift(@needDo, ($isFriend eq "false" && $flag_changed_smbFileName == 1)?"true":"false");
    @fileNameForDelErrRollback = @fileName;
    @operationForDelErrRollback = @operation;
    @needDoForDelErrRollback = @needDo;
    print WRITE @virtual_servers_conf;
    if(!close(WRITE)) {
        &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
        &printError_exit($umCon->ERROR_CODE_EDIT_VIRTUAL_SERVERS_FAILED, $umCon->ERROR_MSG_CLOSE_VIRTUAL_SERVERS, __LINE__);
    }
}

# edit /etc/group[0|1]/ludb.info. add $newComputerName's infomation.
my $ludb_info_path = $umComm->getLudbInfoPath($groupNo);
if(! -f $ludb_info_path) {
    &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
    &printError_exit($umCon->ERROR_CODE_EDIT_LUDB_INFO_FAILED, $umCon->ERROR_MSG_LUDB_INFO_NOTEXIST, __LINE__);
}

my @ludbInfoConf = `cat $ludb_info_path 2>/dev/null`;
my $ludbRoot = $umComm->getLudbRoot();
my $link_path_new = $ludbRoot."/".$umCon->CONST_LUDB_DEFAULTPATH.$domainName."/smbpasswd.".$newComputerName;
my $addLudbInfoLine = "$ludbName $link_path_new\n";
my $flag_isLudbInfoExist = 0;

foreach(@ludbInfoConf) {
    if(/^\s*\Q$addLudbInfoLine\E\s*$/) {
        $flag_isLudbInfoExist = 1;
        last;
    }
}
if($flag_isLudbInfoExist == 0) {
    if($cvs->checkout($ludb_info_path)!=0){
        &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
        &printError_exit($umCon->ERROR_CODE_EDIT_LUDB_INFO_FAILED, $umCon->ERROR_MSG_CHECKOUT_LUDB_INFO, __LINE__);
    }
    push(@fileName, $ludb_info_path);
    push(@operation, "rollback");
    push(@needDo, ($flag_isLudbInfoExist == 0)?"true":"false");
    if(!open(WRITE,"| ${cmd_syncwrite_a} $ludb_info_path")) {
        &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
        &printError_exit($umCon->ERROR_CODE_EDIT_LUDB_INFO_FAILED, $umCon->ERROR_MSG_OPEN_LUDB_INFO, __LINE__);
    }
    print WRITE $addLudbInfoLine;
    if(!close(WRITE)) {
        &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
        &printError_exit($umCon->ERROR_CODE_EDIT_LUDB_INFO_FAILED, $umCon->ERROR_MSG_CLOSE_LUDB_INFO, __LINE__);
    }
}

# create smbpasswd link point to ludb.
my $smbpasswdSrcFile = "../../../.ludb/${ludbName}/smbpasswd";
my $ludbSmbPasswdPath = $ludbRoot."/".$umCon->CONST_LUDB_DEFAULTPATH.$domainName;
system("/bin/rm -f ${link_path_new} 2>/dev/null");
system("/bin/mkdir -p ${ludbSmbPasswdPath} 2>/dev/null");
system("/bin/ln -s ${smbpasswdSrcFile} ${link_path_new} 2>/dev/null");
if(($? >> 8) != 0) {
    &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
    &printError_exit($umCon->ERROR_CODE_CREATE_LUDB_PASSWDLINK_FAILED, $umCon->ERROR_MSG_CREATE_LUDB_PASSWDLINK, __LINE__);
}
push(@fileName, $link_path_new);
push(@operation, "del");
push(@needDo, "true");

# change Conversion Rule's computer name. $oldComputerName -> $newComputerName
my $resultOfChangeNameRule = $umComm->changeNameRule($groupNo, $domainName, $oldComputerName, $newComputerName);
if(defined($resultOfChangeNameRule) && $resultOfChangeNameRule eq "error") {
    &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
    &printError_exit($umCon->ERROR_CODE_CHANGENAMERULE_FAILED, $umCon->ERROR_MSG_CHANGENAMERULE, __LINE__);
}

# add native.
my $region_new;
if($hasSetNative ne "true") {
    if($domainType eq "PWDDomain4Win") {
        $region_new = $umComm->setPWDNativeDomain($groupNo, $passwdPath, $groupPath);
        if(!defined($region_new) || $region_new eq "") {
            &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
            $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
            &printError_exit($umCon->ERROR_CODE_ADDNEWNATIVE_FAILED, $umCon->ERROR_MSG_ADDNEWNATIVEDOMAIN, __LINE__);
        }
        my $resultOfAddNative = $umComm->setPWD4WNative($groupNo, $new_domPlusCom, $region_new);
        if(!defined($resultOfAddNative) || $resultOfAddNative eq "error") {
            &rollback(\@fileName, \@operation, \@needDo, \@virtual_servers_delOld);
            $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
            $umComm->delPWD4WDomain($groupNo, $region_new);
            &printError_exit($umCon->ERROR_CODE_ADDNEWNATIVE_FAILED, $umCon->ERROR_MSG_ADDNEWNATIVE, __LINE__);
        }
    }
}

if($flag_isLudbInfoExist == 0) {
    $cvs->checkin($ludb_info_path);
}
# --> end of adding new native.

# >> delete old native.
# step 1 : edit /etc/group[0|1]/ludb.info. delete $oldComputerName's infomation.
@ludbInfoConf = `cat $ludb_info_path 2>/dev/null`;
my $link_path_old = $ludbRoot."/".$umCon->CONST_LUDB_DEFAULTPATH.$domainName."/smbpasswd.".$oldComputerName;
my @deletedConf;
foreach(@ludbInfoConf) {
    if($_ !~ /^\s*\Q${ludbName}\E\s+\Q${link_path_old}\E\s*$/) {
        push(@deletedConf, $_);
    }
}
if($cvs->checkout($ludb_info_path)!=0){
    &rollback(\@fileNameForDelErrRollback, \@operationForDelErrRollback, \@needDoForDelErrRollback, \@virtual_servers_delOld);
    $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
    &printError_exit($umCon->ERROR_CODE_DELOLDCOM_NATIVE_FAILED, $umCon->ERROR_MSG_CHECKOUT_LUDB_INFO, __LINE__);
}
if(!open(WRITE,"| ${cmd_syncwrite_o} ${ludb_info_path}")) {
    &rollback(\@fileNameForDelErrRollback, \@operationForDelErrRollback, \@needDoForDelErrRollback, \@virtual_servers_delOld);
    $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
    $cvs->rollback($ludb_info_path);
    &printError_exit($umCon->ERROR_CODE_DELOLDCOM_NATIVE_FAILED, $umCon->ERROR_MSG_OPEN_LUDB_INFO, __LINE__);
}
print WRITE @deletedConf;
if(!close(WRITE)) {
    &rollback(\@fileNameForDelErrRollback, \@operationForDelErrRollback, \@needDoForDelErrRollback, \@virtual_servers_delOld);
    $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
    $cvs->rollback($ludb_info_path);
    &printError_exit($umCon->ERROR_CODE_DELOLDCOM_NATIVE_FAILED, $umCon->ERROR_MSG_CLOSE_LUDB_INFO, __LINE__);
}
# step 2 : delete smbpasswd link point to ludb.
system("/bin/rm -f ${link_path_old} 2>/dev/null");
if(($? >> 8) != 0) {
    &rollback(\@fileNameForDelErrRollback, \@operationForDelErrRollback, \@needDoForDelErrRollback, \@virtual_servers_delOld);
    $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
    $cvs->rollback($ludb_info_path);
    &printError_exit($umCon->ERROR_CODE_DELOLDCOM_NATIVE_FAILED, $umCon->ERROR_MSG_DEL_LUDB_PASSWDLINK, __LINE__);
}

# step 3 : delete native.
my $resultOfDelNative = $umComm->delPWD4WNative($groupNo, $old_domPlusCom);
if(!defined($resultOfDelNative) || $resultOfDelNative eq "error") {
    &rollback(\@fileNameForDelErrRollback, \@operationForDelErrRollback, \@needDoForDelErrRollback, \@virtual_servers_delOld);
    $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
    $cvs->rollback($ludb_info_path);
    system("/bin/ln -s ${smbpasswdSrcFile} ${link_path_old} 2>/dev/null");
    &printError_exit($umCon->ERROR_CODE_DELOLDCOM_NATIVE_FAILED, $umCon->ERROR_MSG_DEL_NATIVE, __LINE__);
}

# step 4 : delete domain.
my $resultOfDelDomain = $umComm->delPWD4WDomain($groupNo, $region);
if(!defined($resultOfDelDomain) || $resultOfDelDomain eq "error") {
    &rollback(\@fileNameForDelErrRollback, \@operationForDelErrRollback, \@needDoForDelErrRollback, \@virtual_servers_delOld);
    $umComm->changeNameRule($groupNo, $domainName, $newComputerName, $oldComputerName);
    $cvs->rollback($ludb_info_path);
    system("/bin/ln -s ${smbpasswdSrcFile} ${link_path_old} 2>/dev/null");
    $umComm->setPWD4WNative($groupNo, $old_domPlusCom, $region);
    &printError_exit($umCon->ERROR_CODE_DELOLDCOM_NATIVE_FAILED, $umCon->ERROR_MSG_DEL_NATIVEDOMAIN, __LINE__);
}
$cvs->checkin($ludb_info_path);
# --> end of delete old computer's native.

# check in virtual_servers and smb.conf.netbios
if($isFriend eq "false") {
    $cvs->checkin($vsPath);
    if($flag_changed_smbFileName == 1) {
        $cvs->checkin($smbFilePath_old);
    }
}

# restart samba service.
if($flag_changed_smbFileName == 1) {
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
}
exit 0;


sub printError_exit() {
    my($errorCode, $errorMsg, $lineNumber) = @_;
    print STDERR $errorMsg."\n";
    $comm->writeErrMsg($errorCode, __FILE__, $lineNumber);
    exit 1;
}

sub rollback() {
    my ($fileNameAddr, $operationAddr, $needExecAddr, $writeFile) = @_;
    my @fileNames = @$fileNameAddr;
    my @operations = @$operationAddr;
    my @needExec = @$needExecAddr;
    my @writeFileConf;
    if(defined($writeFile)) {
        @writeFileConf = @$writeFile;
    }
    for(my $i = 0; $i < scalar(@fileNames); $i ++) {
        if($operations[$i] eq "rollback") {
            if($needExec[$i] eq "true") {
                $cvs->rollback($fileNames[$i]);
            }
        }elsif($operations[$i] eq "del"){
            if($needExec[$i] eq "true") {
                system("/bin/rm -f $fileNames[$i] 2>/dev/null");
            }
        }elsif($operations[$i] eq "write") {
            if($needExec[$i] eq "true" && defined($writeFile)) {
                open(FILE,"|${cmd_syncwrite_o} $fileNames[$i]");
                print FILE @writeFileConf;
                if(!close(FILE)){
                    return 1;
                }
            }
        }
    }
    return 0;
}
