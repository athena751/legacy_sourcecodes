#!/usr/bin/perl
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ndmp_setNDMPInfo.pl,v 1.7 2007/05/16 01:32:52 wanghui Exp $"

#Function:
#    set NDMP config info to ndmpd.conf.
#Arguments:
#    groupNo                            0 | 1
#    defaultVersion                     3 | 4 | 2
#    ctrlConnectionIP                   xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx
#    dataConnectionIP                   xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx
#    changePassword                     yes | no
#    authorizedDMAIPs                   xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx(can be null)
#    dataConnectionIPV2                 xxx.xxx.xxx.xxx
#    backupSoftware                     NetWorker | NetBackup
#exit code:
#    0     successful
#    1     failed


use NS::NDMPCommonV4;
use NS::NDMPConst;
use NS::SystemFileCVS;
use NS::NsguiCommon;

my $ndmpCommon = new NS::NDMPCommonV4;
my $ndmpConst = new NS::NDMPConst;
my $cvs = new NS::SystemFileCVS;
my $nsguiCommon = new NS::NsguiCommon;
my $ndmpVersionFile = "/opt/nec/ndmp/ndmp_version.info";
if (scalar(@ARGV) != 8){
    $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNo, $defaultVersion, $ctrlConnectionIP, $dataConnectionIP, $changePassword, $authorizedDMAIPs,$dataConnectionIPV2,$backupSoftware) = @ARGV;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
if($defaultVersion == 2){
	
    my $ndmpv2ConfigFilePath = $ndmpConst->NDMPV2_CONFIG_FILE_PATH;
    system("/home/nsadmin/bin/ndmp_ndmpdManagement.pl stop 2>/dev/null 1>&2");
    if($cvs->checkout($ndmpVersionFile)!= 0){
        $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
        exit 1;
    }
    if($cvs->checkout($ndmpv2ConfigFilePath)!= 0){
    	$cvs->rollback($ndmpVersionFile);
    	$nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
        exit 1;
    }
    open(FILE,"$ndmpv2ConfigFilePath");
    my @fileContent = <FILE>;
    close(FILE);
    $ndmpCommon->setKeyValue2("IPADDR", $dataConnectionIPV2, \@fileContent);
    $ndmpCommon->setKeyValue2("FHINFO", $backupSoftware, \@fileContent);
    open(WRITE,"|${cmd_syncwrite_o} ${ndmpv2ConfigFilePath}");
    print WRITE @fileContent;
    if(!close(WRITE)) {
        $cvs->rollback($ndmpv2ConfigFilePath);
        print STDERR "The $ndmpv2ConfigFilePath can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    	exit 1;
    }
    open(WRITE,"|${cmd_syncwrite_o} ${ndmpVersionFile}");
    $defaultVersion=$defaultVersion."\n";
    print WRITE $defaultVersion;
    if(!close(WRITE)) {
         $cvs->rollback($ndmpv2ConfigFilePath);
         $cvs->rollback($ndmpVersionFile);
         print STDERR "The ndmp_version.info can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
         exit 1;
    }
    if($cvs->checkin($ndmpv2ConfigFilePath)!=0){
    	$cvs->rollback($ndmpv2ConfigFilePath);
        $cvs->rollback($ndmpVersionFile);
        $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
        exit 1;
    }
    if($cvs->checkin($ndmpVersionFile)!= 0){
        $cvs->rollback($ndmpVersionFile);
        $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
        exit 1;
        
    }
    system("/home/nsadmin/bin/ndmp_ndmpdManagement.pl start 2>/dev/null 1>&2");
    exit 0;
}else{

	my $ndmpConfigFilePath = $ndmpCommon->getNDMPConfFilePath($groupNo);
	#if(! -e $ndmpConfigFilePath) {
	#    system("mkdir -p $etcPath$groupNo/$ndmpPath 2>/dev/null");
	#    system("touch $ndmpConfigFilePath 2>/dev/null 1>&2");
	#    system("chmod 644 $ndmpConfigFilePath 2>/dev/null 1>&2");
	#}
	system("/home/nsadmin/bin/ndmp_ndmpdManagement.pl stop 2>/dev/null 1>&2");
	if($cvs->checkout($ndmpVersionFile)!= 0){
	    $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
	if($cvs->checkout($ndmpConfigFilePath)!= 0){
	    $cvs->rollback($ndmpVersionFile);
	    $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
	my $passwd = <STDIN>;
	chomp($passwd);
	
	if($changePassword eq "yes" && $passwd ne "") {
	    my @opts=();
	    push(@opts, "-l", $ndmpConfigFilePath, $passwd);
	    system("/opt/nec/ndmp/setNdmpPasswd", @opts);
	    if($? != 0) {
	        $cvs->rollback($ndmpConfigFilePath);
	        print STDERR "Setting password error! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	        exit 1;
	    }
	}
	
	open(FILE,"$ndmpConfigFilePath");
	my @fileContent = <FILE>;
	close(FILE);
	
	#&addDefaultParameter();
	
	$ndmpCommon->setKeyValue("DEFAULT_PROTOCOL_VERSION", $defaultVersion, \@fileContent);
	$ndmpCommon->setKeyValue("NDMP_IP_ADDRS", $ctrlConnectionIP, \@fileContent);
	$ndmpCommon->setKeyValue("DATA_TX_TIER_1_IP_ADDRS", $dataConnectionIP, \@fileContent);
	$ndmpCommon->setKeyValue("AUTHORIZED_NDMP_CLIENTS", $authorizedDMAIPs, \@fileContent);
	
	
	if($changePassword eq "yes" && $passwd eq "") {
	    $ndmpCommon->setKeyValue("ENCRYPTED_PASSWORD", "", \@fileContent);
	}
	
	open(WRITE,"|${cmd_syncwrite_o} ${ndmpConfigFilePath}");
	print WRITE @fileContent;
	if(!close(WRITE)) {
	    $cvs->rollback($ndmpConfigFilePath);
	    print STDERR "The $ndmpConfigFilePath can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	    exit 1;
	}
	
	open(WRITE,"|${cmd_syncwrite_o} ${ndmpVersionFile}");
	$defaultVersion=$defaultVersion."\n";
	print WRITE $defaultVersion;
	if(!close(WRITE)) {
	    $cvs->rollback($ndmpConfigFilePath);
	    $cvs->rollback($ndmpVersionFile);
	    print STDERR "The ndmp_version.info can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	    exit 1;
	}
	if($cvs->checkin($ndmpConfigFilePath)!=0){
	    $cvs->rollback($ndmpConfigFilePath);
	    $cvs->rollback($ndmpVersionFile);
	    $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
	if($cvs->checkin($ndmpVersionFile)!= 0){
	    $cvs->rollback($ndmpVersionFile);
	    $nsguiCommon->writeErrMsg($ndmpConst->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
	    exit 1;
	}
	system("/home/nsadmin/bin/ndmp_ndmpdManagement.pl start 2>/dev/null 1>&2");
    exit 0;
}

sub addDefaultParameter() {
    if($ndmpCommon->hasKey($ndmpConst->KEY_WORKING_DIRECTORY, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->WORKING_DIRECTORY."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_NDMP_PORT, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->NDMP_PORT."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_LOG_FILE_PATH, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->LOG_FILE_PATH."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_MAX_LOG_FILE_SIZE, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->MAX_LOG_FILE_SIZE."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_LOG_DEBUG_FILTER_FILE, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->LOG_DEBUG_FILTER_FILE."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_NDMP_SUPPRESS_LOCAL_ADDR_TYPE, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->NDMP_SUPPRESS_LOCAL_ADDR_TYPE."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_NDMP_SUPPRESS_LOCAL_HOST, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->NDMP_SUPPRESS_LOCAL_HOST."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_TAPE_BLOCK_SIZE, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->TAPE_BLOCK_SIZE."\n");
    }
   if($ndmpCommon->hasKey($ndmpConst->KEY_ADMIN_DATA, \@fileContent) == 0) {
        my $ndmpSessionDataPath = "$ndmpSession";
        push(@fileContent, $ndmpConst->KEY_ADMIN_DATA." = ".$ndmpSessionDataPath."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_NDMP_USER_NAME, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->NDMP_USER_NAME."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_LOG_ERROR_SYSLOG_THRESHOLD, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->LOG_ERROR_SYSLOG_THRESHOLD."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_ENABLE_NEW_SESSIONS, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->ENABLE_NEW_SESSIONS."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_MAX_NDMP_SESSIONS, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->MAX_NDMP_SESSIONS."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_SESSION_UPDATE_INTERVAL, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->SESSION_UPDATE_INTERVAL."\n");
    }
    if($ndmpCommon->hasKey($ndmpConst->KEY_NDMP_TCP_WND_SZ, \@fileContent) == 0) {
        push(@fileContent, $ndmpConst->NDMP_TCP_WND_SZ."\n");
    }
}
