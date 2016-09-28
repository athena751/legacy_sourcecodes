#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_mount.pl,v 1.6 2008/07/29 03:31:58 chenb Exp $"
## Function:
##     mount the specified filesystem
##
## Parameters:
##     $mp -- mountpoint will be mount
##     $accessMode -- access mode, value is ro or rw
##     $repli -- just has this param if replication has set, value is on 
##     $quota -- just has this param if quota has set, value is on 
##     $noatime -- just has this param if update access time has not set, value is on 
##     $dmapi -- just has this param if DMAPI has set, value is on 
##     $norecovery -- just has this param if recovery has set, value is on
##     $usegfs  -- specify whether use GFS or not, value is true or false or hasnot this option
##
## Output:
##     STDOUT
##         none
##     STDERR
##         error code and error message
##
## Returns:
##     0 -- success
##     1 -- failed

use strict;
use Getopt::Long;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::SystemFileCVS;

my $filesystemConst  = new NS::FilesystemConst;
my $volumeCommon     = new NS::VolumeCommon;
my $volumeConst      = new NS::VolumeConst;
my $systemFileCommon = new NS::SystemFileCVS;
## check parameter num
if (scalar(@ARGV) != 4) {
   $filesystemConst->printErrMsg($filesystemConst->ERR_PARAM_NUM);
   exit 1;
}

## define global variable
my ($moStr, $mp);
my $cmd_syncwrite_o = $systemFileCommon->COMMAND_NSGUI_SYNCWRITE_O;
my $retVal ;

## get $moStr and $mp
$retVal = &processARGV();
if ($retVal =~ /^0x132000/) {
    $filesystemConst->printErrMsg($retVal);
    exit 1;
}

if ((!defined($moStr)) || (!defined($mp))) {
	$filesystemConst->printErrMsg($filesystemConst->ERR_PARAM_NUM);
    exit 1;
}

## get options from GUI 
my $optionHash = $volumeCommon->parseOption($moStr);

## get options from cfstab
my $cfstabMPHash = $volumeCommon->getMountOptionsFromCfstab();
if (defined($$cfstabMPHash{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$cfstabMPHash{$volumeConst->ERR_FLAG});
    exit 1;
}
if (!defined($$cfstabMPHash{$mp})) {
    $volumeConst->printErrMsg($volumeConst->ERR_FS_NOT_EXIST_IN_CFSTAB);
    exit 1;
}

## get parameters: $lvPath, $fsType, $accessMode, $replication, $quota, $updateAccessTime, $norecovery and $dmapi
my $cfstabMPOptionHash = $$cfstabMPHash{$mp};
my ($lvPath, $fsType, $accessMode, $replication, $quota, $updateAccessTime, $norecovery, $dmapi);

$lvPath           = $$cfstabMPOptionHash{"lvpath"};
$fsType           = $$cfstabMPOptionHash{"ftype"};
$accessMode       = $$optionHash{"access"};
$replication      = $$optionHash{"repli"};
$quota            = $$optionHash{"quota"};
$updateAccessTime = $$optionHash{"noatime"};
$norecovery       = $$optionHash{"norecovery"};
$dmapi            = $$optionHash{"dmapi"};

## reset replication according $replication and $accessMode
if (defined($replication)) {
    if ($accessMode eq "rw") {
        $replication = "original";
    } else {
        $replication = "replic";
    }
}

## get the parameters string need by mount command and write cfstab file
my ($mountStr, $volMountStr, $cfstabStr) = $volumeCommon->generateMountAndCfstabStr($lvPath, $mp, $fsType, $accessMode,
                                                      $replication, $quota, $updateAccessTime , $norecovery ,$dmapi);  

my $acldir;
if(!(-d $mp)){
    $acldir = $volumeCommon->getFirstNotExistParent($mp); 
    my $cmd_mkdir = $volumeConst->CMD_MKDIR;
    $retVal = system($cmd_mkdir , "-p" , $mp);
    if($retVal != 0){
        $volumeConst->printErrMsg($volumeConst->ERR_CREATE_DIR);
        exit 1;
    } 
            
    ###set acl for sub mount point
    my $cmd_defacl = $volumeConst->CMD_DEFACL;
    if(defined($acldir) && ($fsType eq "sxfsfw")){ 
        $retVal = system("$cmd_defacl -r $acldir >&/dev/null");
        if($retVal != 0){
            $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_DEFACL);
            exit 1;
        }
    }   
}
if(!defined($acldir)){
    $acldir = $mp;
}

## checkout cfstab file
my $cfstabFile = $volumeCommon->getCfstabFile();
if ($systemFileCommon->checkout($cfstabFile) != 0) {
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_CFSTAB);
    exit 1;
}

## get cfstab content
if (!open(INFILE, $cfstabFile)) {
    $systemFileCommon->rollback($cfstabFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_CFSTAB);
    exit 1;
}

my @cfstabContent = <INFILE>;
close(INFILE);

## modify cfstab content
if (!open(OUTFILE, "| ${cmd_syncwrite_o} $cfstabFile")) {
    $systemFileCommon->rollback($cfstabFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_CFSTAB);
    exit 1;
}
 
foreach (@cfstabContent) {
    if ($_ =~ /^\s*#.*/) {
        print OUTFILE $_;
    } elsif ($_ =~ /^\s*(\/dev\/\S+)\s+\Q${mp}\E\s+(\S+)\s+(\S+)\s+0\s+0\s*$/) {
        print OUTFILE $cfstabStr;
    } else {
        print OUTFILE $_;
    }
} 

if(!close(OUTFILE)) {
    $systemFileCommon->rollback($cfstabFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EDIT_CFSTAB);
    exit 1;
}

## execute /usr/lib/rcli/vol mount 
my $cmd_vol  = $volumeConst->CMD_VOL;
$retVal = system("$cmd_vol mount ${mp}");
if ($retVal != 0 ) {
    $systemFileCommon->rollback($cfstabFile);
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL);
    exit 1;
}
##  chmod 777 $mp whether the accessMode is "rw" or "ro"
##  The reason is very complex,please go to the FT doucment
##  If the mode is "ro",the command will fail,but no influnce to system.--xingyh
my $cmd_chmod = $volumeConst->CMD_CHMOD;
if($acldir eq $mp){
    my $cmd_chmod_run = $cmd_chmod."  777 ".$mp." 2>/dev/null";    
    system($cmd_chmod_run);
}else{
    $volumeCommon->changeNewDirstoFullRightsMode($acldir,$mp);
}

## process PSID
if ($fsType eq "sxfsfw") {
    
    ## init PSID if PSID not exist
    if (($accessMode eq "rw") && (!(-d "$mp\/\.psid_lt"))) {
        my $cmd_ims_ntvol = $volumeConst->CMD_IMS_NTVOL;
        if (system($cmd_ims_ntvol, "-I", $mp) != 0) {
            $systemFileCommon->rollback($cfstabFile);
            system($cmd_vol, "umount", $mp, "really-force");
            $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_IMS_NTVOL);
            exit 1; 
        }
    }
    
    ## check whether PSID has login
    my $ims_conf_file = $volumeCommon->getImsConfFile();
    my $checkPSID = $volumeCommon->checkPSID($ims_conf_file, $mp);
    if($checkPSID =~ /^0x108000/){
        $systemFileCommon->rollback($cfstabFile);
        system($cmd_vol, "umount", $mp, "really-force");
        $volumeConst->printErrMsg($checkPSID);
        exit 1;
    }
    
    ## login PSID if PSID not login
    if($checkPSID == 0){
        my $cmd_ims_domain = $volumeConst->CMD_IMS_DOMAIN;
        if(system($cmd_ims_domain, "-A", $mp, "-f", "-c", $ims_conf_file) != 0){
            $systemFileCommon->rollback($cfstabFile);
            system($cmd_vol, "umount", $mp, "really-force");
            $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_IMS_DOMAIN);
            exit 1;
        }   
    }
}

## checkin cfstab
$systemFileCommon->checkin($cfstabFile);


## add or delete GFS setting
my $lvName = (split(/\/+/, $lvPath))[2];

if (defined($$optionHash{"usegfs"}) && ($$optionHash{"usegfs"} eq "true")) {
    $retVal = $volumeCommon->addGfs($lvName);
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;                    
    }
} else {
    $retVal = $volumeCommon->delGfs($lvName);
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;                    
    }
}

##set rv info for volume license
$retVal = $volumeCommon->execDfrvAdd($mp);
if ($retVal =~ /^0x108000/) {
    $volumeConst->printErrMsg($retVal);
    exit 1;
}

##execute /usr/lib/rcli/vol activate $mp
$retVal = system("$cmd_vol activate $mp >&/dev/null");
if ($retVal != 0 ) {
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL_ACTIVATE);
    exit 1;
}

exit 0;


######### sub function begin ##########

## Function: parse the argument
##
## Parameters:
##     none
## 
## Returns:
##     succeed -- 0
##     error   -- error code 
sub processARGV(){
    Getopt::Long::Configure("noauto_abbrev");
    Getopt::Long::Configure("getopt_compat");
    my $result = GetOptions("mountoption|mo=s" => \$moStr,
                             "mountpoint|mp=s" => \$mp);
    if(!$result){
        return $filesystemConst->ERR_PARAM_NUM;
    }
    return 0;
}  
######### sub function end ########### 
