#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_modify.pl,v 1.16 2008/07/29 03:32:26 chenb Exp $"

## Function: modify volume, operation include modify, mount, umount
##
## Parameters:
##     operation   -- command, value is modify, mount or umount
##     mountpoint  -- the mount point of specified volume 
##     mountoption -- option for modify
##     accessmode  -- access mode, value is ro or rw
##     repli       -- assign value when setting replication
##     quota       -- assign value when setting quota
##     noatime     -- assign value when setting access time update
##     norecovery  -- assign value when setting no recovery
##     snapshot    -- assign value when access mode is rw, its value is specified by snapshot area
##     dmapi       -- assign value when setting hsm
##     usegfs     -- assign value when setting gfs, true or false
##
## Output:
##     STDOUT: 
##          Usage:
##              volume_modify.pl mount  --mountpoint|--mp <mountpoint>
##              volume_modify.pl umount --mountpoint|--mp <mountpoint>
##              volume_modify.pl modify --mountpoint|--mp <mountpoint>
##                                      --mountoption|--mo 
##                                      access=[ro|rw][,repli=on][,quota=on][,noatime=on][,dmapi=on][,norecovery=on][,snapshot=<snapshot_limit>][,usegfs=<true|false>][,wpperiod=[--|-1|1~10950]]
##
##     STDERR: error message and error code
##
## Returns:
##     0 -- success
##     1 -- failed


use strict;
use Getopt::Long;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::SystemFileCVS;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $fileCommon   = new NS::SystemFileCVS;

## get the first parameter
my $operation = lc(shift) ;
if (($operation ne "modify") && ($operation ne "umount") && ($operation ne "mount")){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
    exit 1;
}

## define global 
my $retVal ;
my $success = $volumeConst->SUCCESS_CODE;
my $errFlag = $volumeConst->ERR_FLAG;
my ($moStr, $mp);

## check validity of parameter
$retVal = &processARGV();
if ($retVal ne $success){
    &showHelp();
    $volumeConst->printErrMsg($retVal);
    exit 1;
}

if (!defined($mp) || (($operation eq "modify") && (!defined($moStr)))){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}

if(($mp !~ /^\//)){
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
    exit 1;
}elsif($mp =~ /^(.+[^\/]+)\/*$/){## delete the / in the end of $mp
    $mp = $1;
}

my $moHash;
my $option;
my ($lvPath, $ftype, $access, $repli, $quota, $noatime , $norecovery , $dmapi);

## process mount, umount and modify
if ($operation eq "mount") { #mount volume
    
    ## check status of $mp
    $retVal = $volumeCommon->hasMounted($mp);
    ## execute command error
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ## $mp is mount
    if ($retVal == 0) {
        exit 0;
    }
    
    
    my $isChild = $volumeCommon->isChild($mp);
    ## check status of $mp's parent if $mp isn child mount point
    if ($isChild == 0) {
        my ($parentFsType, $parentAccess , $errCode) = $volumeCommon->getTypeAccessOfParent($mp);
        ## execute command error or $mp's parent is unmount
        if (defined($errCode)) {
            $volumeConst->printErrMsg($errCode);
            exit 1;
        }    
    }
    
    ## get mount option of mount point
    $moHash = $volumeCommon->getMountOptionsFromCfstab();
    if (defined($$moHash{$errFlag})) {
        $volumeConst->printErrMsg($$moHash{$errFlag});
        exit 1;     
    }
    if (!defined($$moHash{$mp})) {
        $volumeConst->printErrMsg($volumeConst->ERR_FS_NOT_EXIST_IN_CFSTAB);  
        exit 1;   
    }
    
    $option = $$moHash{$mp};
    $ftype   = $$option{"ftype"};
    $access  = $$option{"access"};
    
    ###create mount point when the mp does not exist
    my $acldir;
    if(!(-d $mp)){
        $acldir = $volumeCommon->getFirstNotExistParent($mp); ### get dir for setting acl 
        my $cmd_mkdir = $volumeConst->CMD_MKDIR;
        $retVal = system($cmd_mkdir , "-p" , $mp);
        if($retVal != 0){
            $volumeConst->printErrMsg($volumeConst->ERR_CREATE_DIR);
            exit 1;
        } 
        
        ###set acl for sub mount point
        my $cmd_defacl = $volumeConst->CMD_DEFACL;
        if(defined($acldir) && ($ftype eq "sxfsfw")){### need not set acl when exist and sxfsfw  
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
    
    ## execute /usr/lib/rcli/vol mount 
    my $cmd_vol  = $volumeConst->CMD_VOL;
    $retVal = system("$cmd_vol mount ${mp}");
    if ($retVal != 0 ) {
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL);
        exit 1;
    }
    
    ## chmod 777 $mp if access is rw
    if ($access eq "rw") {
        my $cmd_chmod = $volumeConst->CMD_CHMOD;
        if($acldir eq $mp){
            my $cmd_chmod_run = $cmd_chmod."  777 ".$acldir." 2>/dev/null";    
            system($cmd_chmod_run);
        }else{
            $volumeCommon->changeNewDirstoFullRightsMode($acldir,$mp);
        }
    }

    ### login psid when no psid logined for Ver2.1
    if($ftype eq "sxfsfw"){
        my $ims_conf = $volumeCommon->getImsConfFile();
        my $checkPsid = $volumeCommon->checkPSID($ims_conf , $mp);
        if($checkPsid =~ /^0x108000/){
            $volumeConst->printErrMsg($checkPsid);
            exit 1;
        }
        if($checkPsid == 0){
            my $cmd_ims_domain = $volumeConst->CMD_IMS_DOMAIN;
            $retVal = system($cmd_ims_domain ,"-A" , $mp , "-f" , "-c" , $ims_conf);##login ##PSID
            if($retVal != 0){
                $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_IMS_DOMAIN);
                exit 1;
            }   
        }
    }
    ## set auth
    $retVal = $volumeCommon->setAuth($mp, $ftype);
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ##set rv info for volume license
    $retVal = $volumeCommon->execDfrvAdd($mp);
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ## succeed to execute "/usr/lib/rcli/vol mount"
    ## execute /usr/lib/rcli/vol activate $mp
    $retVal = system("$cmd_vol activate $mp >&/dev/null");
    if ($retVal != 0 ) {
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL_ACTIVATE);
        exit 1;
    }
 
    exit 0;
    
} elsif ($operation eq "umount") { #umount volume
    
    ## check status of $mp
    $retVal = $volumeCommon->hasMounted($mp);
    ## execute command error
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ## $mp is unmount
    if ($retVal == 1) {
        exit 0;
    }
    
    ## check if $mp has mounted child 
    $retVal = $volumeCommon->hasChildInMount($mp);
    ## execute command error
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ## $mp has mounted child
    if ($retVal == 1) {
        $volumeConst->printErrMsg($volumeConst->ERR_FS_HAS_CHILD);
        exit 1;
    }   
    
    ## check if $mp is used
    $retVal = $volumeCommon->isUsedMP($mp);
    ## execute command error or $mp is used
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    
    ## del auth
    $retVal = $volumeCommon->delAuth($mp);
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    
    ## execute /usr/lib/rcli/vol umount $mp
    my $cmd_vol  = $volumeConst->CMD_VOL;
    $retVal = system("$cmd_vol umount $mp");
    if ($retVal != 0 ) {
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL);
        exit 1;
    }
    
    ## succeed to execute "/usr/lib/rcli/vol umount"  
    exit 0;
    
} elsif ($operation eq "modify") { #modify volume
    ## check if access and paramerte snapshot has been assigned 
    my $optionHash = $volumeCommon->parseOption($moStr);
    my $canNorecovery = ($$optionHash{"access"} eq "ro") && (!defined($$optionHash{"repli"}));
    
    if ((!defined($optionHash)) || (!defined($$optionHash{"access"}))
         || (($$optionHash{"access"} eq "rw")&&(!defined($$optionHash{"snapshot"})))
         || (!$canNorecovery && defined($$optionHash{"norecovery"}))) {
        &showHelp();
        $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
        exit 1;
    }
    
    ## check status of $mp
    $retVal = $volumeCommon->hasMounted($mp);
    ## execute command error
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ## $mp is unmount
    if ($retVal == 1) {
        $volumeConst->printErrMsg($volumeConst->ERR_FS_UMOUNTED);
        exit 1;
    }
    
    ## check if $mp has child
    $retVal = $volumeCommon->hasChild($mp);
    ## execute command error
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    ## $mp has child
    if ($retVal == 0) {
        $volumeConst->printErrMsg($volumeConst->ERR_FS_HAS_CHILD);
        exit 1;
    }
    
    ## check if $mp is used
    $retVal = $volumeCommon->isUsedMP($mp);
    ## execute command error or $mp is used
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    
    ## get mount option of mount point
    $moHash = $volumeCommon->getMountOptionsFromCfstab();
    if (!defined($$moHash{$mp})) {
        $volumeConst->printErrMsg($volumeConst->ERR_FS_NOT_EXIST_IN_CFSTAB);
        exit 1;    
    }
    if (defined($$moHash{$errFlag})) {
        $volumeConst->printErrMsg($$moHash{$errFlag});
        exit 1;     
    }
    
    $option = $$moHash{$mp};
    $lvPath  = $$option{"lvpath"};
    $ftype   = $$option{"ftype"};
    $access  = $$optionHash{"access"};
    $repli   = $$optionHash{"repli"};
    $quota   = $$optionHash{"quota"};
    $noatime = $$optionHash{"noatime"};
    $norecovery = $$optionHash{"norecovery"};
    $dmapi   = $$optionHash{"dmapi"};
    
    ## reset $repli according $repli and $access
    if (defined($repli)) {
        if ($access eq "ro") {
            $repli = "replic";
        }elsif ($access eq "rw") {
            $repli = "original";
        }
    }
    
    ## organize the necessary parameters of mount command and cfstab file
    my ($mountStr, $volMountStr, $cfstabStr) = $volumeCommon->generateMountAndCfstabStr($lvPath, $mp, $ftype, $access,
                                                                          $repli, $quota, $noatime , $norecovery ,$dmapi);  
    
    ## get cfstab file path
    my $cfstabPath = $volumeCommon->getCfstabFile();
    
    ## checkout cfstab file
    if($fileCommon->checkout($cfstabPath) != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_EDIT_CFSTAB);
        exit 1;
    }
    ## get cfstab file content
    $retVal = $volumeCommon->modifyFile("modify", $cfstabPath, $lvPath, 0, $cfstabStr);
    if($retVal != 0){
        $fileCommon->rollback($cfstabPath);
        $volumeConst->printErrMsg($volumeConst->ERR_EDIT_CFSTAB);
        exit 1;
    }

    ## del auth
    $retVal = $volumeCommon->delAuth($mp);
    if ($retVal =~ /^0x108000/) {
        $fileCommon->rollback($cfstabPath);
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }    

    ## execute /usr/lib/rcli/vol umount $mp
    my $cmd_vol  = $volumeConst->CMD_VOL;
    $retVal = system("$cmd_vol umount $mp");
    if ($retVal != 0 ) {
        $fileCommon->rollback($cfstabPath);
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL);
        exit 1;
    }
    
    ## execute /usr/lib/rcli/vol mount 
    $retVal = system("$cmd_vol mount $mp");
    if ($retVal != 0 ) {
        $fileCommon->rollback($cfstabPath);
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VOL);
        exit 1;
    }
    
    ## check in cfstab file
    $fileCommon->checkin($cfstabPath);

    ## change $mp's authority and set snapshot if access is rw
    if ($access eq "rw") {
        ## change authority
        my $cmd_chmod = $volumeConst->CMD_CHMOD;
        system($cmd_chmod , "777" , $mp);
        
        ### set psid when the first time replic to original or no replication.or to say the first time ro to rw
        if(($ftype eq "sxfsfw") && (!(-d "$mp\/\.psid_lt"))){
            my $cmd_ims_ntvol = $volumeConst->CMD_IMS_NTVOL;
            $retVal = system($cmd_ims_ntvol ,"-I" ,$mp);##init PSID
            if($retVal != 0){
                $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_IMS_NTVOL);
                exit 1;
            }        
        }
        if(!defined($dmapi)){
            my $snapshot = $$optionHash{"snapshot"};
            ## check if $mp has set snapshot
            my $cmd_sxfs_snapshot = $volumeConst->CMD_SXFS_SNAPSHOT; 
            my $cmd_sxfs_fileset  = $volumeConst->CMD_SXFS_FILESET;
            my @result = `$cmd_sxfs_fileset \'$mp\'`;
            if((split(/\s+/, $result[0]))[1] !~ /\bSNAPSHOT\b/){
                ## init snapshot
                $retVal = system($cmd_sxfs_snapshot , "-s" , $mp);
                if($retVal != 0){
                    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_SXFS_SNAPSHOT);
                    exit 1; 
                }
            }
        
            ## set snapshot
            $retVal = system("$cmd_sxfs_snapshot -p $snapshot $mp");
            if ($retVal != 0) {
                $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_SXFS_SNAPSHOT);
                exit 1;    
            }
        }
    }
    
    ### login psid when no psid logined for Ver2.1
    if($ftype eq "sxfsfw"){
        my $ims_conf = $volumeCommon->getImsConfFile();
        my $checkPsid = $volumeCommon->checkPSID($ims_conf , $mp);
        if($checkPsid =~ /^0x108000/){
            $volumeConst->printErrMsg($checkPsid);
            exit 1;
        }
        if($checkPsid == 0){
            my $cmd_ims_domain = $volumeConst->CMD_IMS_DOMAIN;
            $retVal = system($cmd_ims_domain ,"-A" , $mp , "-f" , "-c" , $ims_conf);##login ##PSID
            if($retVal != 0){
                $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_IMS_DOMAIN);
                exit 1;
            }   
        }
    }
    
    ## set auth
    $retVal = $volumeCommon->setAuth($mp, $ftype);
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    } 
      
    my $lvName = (split("/" , $lvPath))[3];
    my $usegfs = $$optionHash{"usegfs"};
    if(defined($usegfs) && ($usegfs eq "true")){
        $retVal = $volumeCommon->addGfs($lvName);
    }else{
        $retVal = $volumeCommon->delGfs($lvName);
    }
    if ($retVal =~ /^0x108000/) {
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    
    ##settings for [Write Protected]
    my $wpPeriod = $$optionHash{"wpperiod"};
    if(defined($wpPeriod)){
        $retVal = "0";
        if($wpPeriod eq "-1"){
            #release [Write Protected]
            $retVal = $volumeCommon->releaseWriteProtected($mp);
        }elsif(($wpPeriod =~ /^[\d]+$/) && ($wpPeriod >= 1) && ($wpPeriod <= $volumeConst->MAX_WRITE_PROTECTED_PERIOD)){
            #the period is between 1 and 10950
            #set [Write Protected]
            $retVal = $volumeCommon->setWriteProtected($wpPeriod, $mp);
        }
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
}

#########  sub function define begin     #######

## Function: parse the argument
##
## Parameters:
##     none
## 
## Returns:
##     succeed -- SUCCESS_CODE
##     error   -- error code 
sub processARGV(){
    Getopt::Long::Configure("noauto_abbrev");
    Getopt::Long::Configure("getopt_compat");
    my $result = GetOptions ("mountoption|mo=s" => \$moStr,
                             "mountpoint|mp=s"  => \$mp);
    if(!$result){
        return $volumeConst->ERR_PARAM_WRONG_NUM;
    }
    return $volumeConst->SUCCESS_CODE;
}    

## Function: output usage
##
## Parameters:
##     none
##
## Returns:
##     none
##     
## Output
##     STDOUT: 
##          Usage:
##              volume_modify.pl mount  --mountpoint|--mp <mountpoint>
##              volume_modify.pl umount --mountpoint|--mp <mountpoint>
##              volume_modify.pl modify --mountpoint|--mp <mountpoint>
##                                      --mountoption|--mo 
##                                      access=[ro|rw][,repli=on][,quota=on][,noatime=on][,dmapi=on][,norecovery=on][,snapshot=<snapshot_limit>][,usegfs=<true|false>][,wpperiod=[--|-1|1~10950]]
sub showHelp(){
    print (<<_EOF_);
Usage:
    volume_modify.pl mount  --mountpoint|--mp <mountpoint>
    volume_modify.pl umount --mountpoint|--mp <mountpoint>
    volume_modify.pl modify --mountpoint|--mp <mountpoint> 
                            --mountoption|--mo 
                            access=[ro|rw][,repli=on][,quota=on][,noatime=on][,dmapi=on][,norecovery=on][,snapshot=<snapshot_limit>][,usegfs=<true|false>][,wpperiod=[--|-1|1~10950]]
_EOF_
}
#########  sub function define end     #######


