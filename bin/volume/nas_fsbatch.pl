#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nas_fsbatch.pl,v 1.15 2008/05/24 12:09:03 liuyq Exp $"


##Function: option of create , delete , extend file system
##Parameter:
##      command: specify option to act:help , create , extend , delete
##      diskoption:
##          nashead  lunlist -- lun list. As wwnn(lun),wwnn(lun).
##          nv case  poolno  -- pool number list. As 0000(0001h)#0001(0001h)
##                   volsz   -- LD's size
##                   ldtype  -- LD's type
##                   bltime  -- build time
##      fsoption:
##                   ftype   -- file system type
##                   codepage-- file system code page
##                   journal -- jornal set
##                   repli   -- replication set
##      mountoption:
##                   snapshot-- snapshot filed
##                   quota   -- quota set
##                   noatime -- noatime set
##                   dmapi   -- hsm option set
##                   useGfs  -- use GFS
##                   wpPeriod-- write-protect. As -1|1~10950
##      lvoption:
##                   name    -- LV Name
##                   striped -- stripe lv
##      mountpoint:
##                   mount point
##      sourcemp:
##                   source mount point when change fs
##      destmp:
##                   dest mount point when change fs
##Output:
##      STDOUT:successfull message
##      STDERR: error message and error code

use strict;
use Getopt::Long;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::SystemFileCVS;
use NS::DdrCommon;
use NS::ReplicationCommon;
use NS::ReplicationConst;
Getopt::Long::Configure("bundling" , "ignore_case_always");

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;
my $ddrCommon   = new NS::DdrCommon;
my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;

my $cmd = shift;
if(!defined($cmd)){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}
$cmd = lc($cmd);

my ($fsoption , $diskoption , $mountoption , $mp, $lvoption);
my %fsHash = ();### all the saved params of file system may be:ftype,codepage,journal,repli
my %doHash = ();### all the saved params of disk option may be:poolno , volsz , ldtype , bltime , lunlist
my %moHash = ();### all the saved params of mount option may be:snapshot , quota , noatime , dmapi , usegfs
my %lvHash = ();### all the saved params of mount option may be:name , striped
my @lds = ();
my $ldPath ;
my $retVal ;
my $success = $volumeConst->SUCCESS_CODE;
my $errFlag = $volumeConst->ERR_FLAG;

if($cmd eq "create" || $cmd eq "delete" || $cmd eq "extend" ){
    my $result = eval {
                        $SIG{__WARN__} = sub { die $_[0]; };
                        GetOptions("fsoption|fs=s"        => \$fsoption,
	    				           "diskoption|do=s"      => \$diskoption,
		    			           "mountoption|mo=s"     => \$mountoption,
			    		           "mountpoint|mp=s"      => \$mp,
				    	           "lvoption|lo=s"          => \$lvoption);
				       };
    if(!$result){
        $volumeConst->printErrMsg($volumeConst->ERR_PARAM_UNKNOWN);
        exit 1;
    }
    if(!defined($mp)){
        $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
        exit 1;
    }elsif(($mp !~ /^\//)){
        $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
        exit 1;
    }elsif($mp =~ /^(.+[^\/]+)\/*$/){## delete the / in the end of $mp
        $mp = $1;
    }
}elsif($cmd eq "-h" || $cmd eq "--help"){
    $cmd = "help";
    &showHelp();
    exit 0;
}else{
    ## remain an interface
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_UNKNOWN);
    exit 1;
}

my $isNashead = $nsguiCommon->isNashead();
my $diskArraysHash;

if(!$isNashead){
    $diskArraysHash = $volumeCommon->getArrayInfo("0");
    if(defined($$diskArraysHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$diskArraysHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
}

my $friendIP = $nsguiCommon->getFriendIP();
if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }
}

if($cmd eq "create"){
    $retVal = &checkCreateParam($diskoption , $fsoption , $mountoption , $lvoption);
    if($retVal ne $success){
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    $retVal = &createFS();
    if($retVal ne $success){
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }

    exit 0;
}elsif($cmd eq "extend"){
    $retVal = &checkExtendParam($diskoption, $lvoption);
    if($retVal ne $success){
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    $retVal = &extendFS();
    if($retVal ne $success){
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    exit 0;
 }elsif($cmd eq "delete"){
    $retVal = &deleteFS();
    if($retVal ne $success){
        $volumeConst->printErrMsg($retVal);
        exit 1;
    }
    exit 0;
}
exit 0;

##################sub defination################
### Function : create file system on $mp with lv $lvName;
###Parameter:
###         none
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub createFS(){
    my $retVal;
    my $succMsg;
    my @args = ();

    ### process when nv case
    if(!$isNashead){
        push(@args , $doHash{"tosetlds"}, $doHash{"ldtype"} , $doHash{"bltime"}, $friendIP);
        $retVal = $volumeCommon->createLdsInPools(@args);##value is set in checkDiskOption()
        if($retVal =~ /^\s*0x/){
            return $retVal;
        }
        push(@lds , split(",", $retVal));

        $succMsg = sprintf($volumeConst->MSG_LD_CREATE_1 , $retVal);
        print STDOUT $succMsg."\n";
    }

    ### create lv
    my $lvName = $lvHash{"name"};
    my $ldPathList = join("," , @lds);
    $retVal = $volumeCommon->createLV($ldPathList , $lvName , $lvHash{"striped"});
    if($retVal ne $success){
        return $retVal;
    }
    $succMsg = sprintf($volumeConst->MSG_LVM_CREATE_1 , "/dev/${lvName}/${lvName}");
    print STDOUT $succMsg."\n";

    ### make file system
    @args = ($fsHash{"ftype"} , $fsHash{"codepage"} , $fsHash{"repli"});
    push(@args , $fsHash{"journal"} , "/dev/${lvName}/${lvName}");
    $retVal = $volumeCommon->createFS(@args);
    if($retVal ne $success){
        return $retVal;
    }
    $succMsg = sprintf($volumeConst->MSG_FS_CREATE_1 , "/dev/${lvName}/${lvName}");
    print STDOUT $succMsg."\n";

    ### mount file system
    @args = ($fsHash{"ftype"} , $fsHash{"repli"});
    push(@args , $moHash{"snapshot"} , $moHash{"quota"} , $moHash{"noatime"} , undef, $moHash{"dmapi"});
    push(@args , "/dev/${lvName}/${lvName}" , $mp);
    push(@args , 0);## first time mount after file system has been created.
    push(@args , undef , $moHash{"usegfs"}, $moHash{"wpperiod"});
    $retVal = $volumeCommon->mountFS(@args);
    if($retVal ne $success){
        return $retVal;
    }
    $succMsg = sprintf($volumeConst->MSG_FS_MOUNT_1 , $mp);
    print STDOUT $succMsg."\n";

    ### set auth for mount point 
    $retVal = $volumeCommon->setAuth($mp , $fsHash{"ftype"});
    if(($retVal ne $volumeConst->AUTH_SET_SUCCESS) && ($retVal ne $volumeConst->REGION_NOT_EXIST)){
        return $retVal;
    }

    return $success;
}

###Function : check all the param for create fs
###Parameter:
###         $diskoption_sub : the string of disk option supplied by command line
###         $fsoption_sub : the string of file system  option supplied by command line
###         $mountoption_sub : the string of mount option supplied by command line
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkCreateParam(){
    my $diskoption_sub = shift;
    my $fsoption_sub = shift;
    my $mountoption_sub = shift;
    my $lvoption_sub = shift;
    
    ###check disk option
    my $retVal = &checkDiskOption($diskoption_sub);
    if($retVal ne $success){
        return $retVal;
    }
    ###check fsoption
    $retVal = &checkFsOption($fsoption_sub);
    if($retVal ne $success){
        return $retVal;
    }
    ###check mountoption
    $retVal = &checkMountOption($mountoption_sub , $fsHash{"repli"});
    if($retVal ne $success){
        return $retVal;
    }
    
    $retVal = &checkPairedLdsAndSyncfs($isNashead, \@lds, $fsHash{"repli"});
    if($retVal ne $success){
        return $retVal;
    }
    ###check mountoption
    $retVal = &checkLVOption($lvoption_sub, "0");
    if($retVal ne $success){
        return $retVal;
    }
    
    ### check lv count
    my $vgCount = $volumeCommon->getVgCountOfAll();
    if($vgCount =~ /^0x108000/){
        return $vgCount;
    }elsif($vgCount > 255){
        return $volumeConst->ERR_LVM_COUNT256;
    }
    
    my $lvName = $lvHash{"name"};
    ### check lv name
    if(!defined($lvName)){
        ##createLvName($lds[0]);
        return $volumeConst->ERR_PARAM_WRONG_NUM;
    }else{
        my $lvNameList = $volumeCommon->getAllLvName();
        if(defined($$lvNameList{$errFlag})){
            return $$lvNameList{$errFlag};
        }elsif(defined($$lvNameList{$lvName})){
            return $volumeConst->ERR_LVM_USED_LVNAME;
        }
    }
    
    ### check mount point
    ###check exist when direct mount
    ###check parent ftype , access mode , mounted , replication when sub mount
    $retVal = $volumeCommon->validateMPForUse($mp , $fsHash{"ftype"});  
    if($retVal ne $success){
        return $retVal;
    }
    return $success;
}

###Function : check disk option ,and set the detail param to %doHash();
###Parameter:
###         $diskoption: string supplied by command line
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkDiskOption(){
    my $diskOption_sub = shift;
    if(!defined($diskOption_sub)){
        return $volumeConst->ERR_PARAM_WRONG_NUM;
    }
    ### process of nv case
    if(!$isNashead){
        #parase disk option;
        my @tmpOpts = split(/,+/ , $diskOption_sub);
        foreach(@tmpOpts){
            if($_ =~ /^\s*(\w+)\s*=\s*(\S+)\s*$/){
                $doHash{lc($1)} = $2;
            }
        }

        if(!defined($doHash{"poolno"}) || !defined($doHash{"volsz"})){
            return $volumeConst->ERR_PARAM_WRONG_NUM;
        }

        my $poolInfoHash = $volumeCommon->getAllPoolInfo();
        if(defined($$poolInfoHash{$volumeConst->ERR_FLAG})) {
            return $$poolInfoHash{$volumeConst->ERR_FLAG};
        }
        my $maxsz = 0;
        ##compute the max free size of all pool with $poolInfoHash
        my @poolArray = split("#", $doHash{"poolno"});
        for(my $i= 0;  $i< scalar(@poolArray); $i++){
            my $poolHash = $$poolInfoHash{$poolArray[$i]};
            if(!defined($poolHash)){
                next;
            }
            my $poolMaxFreeCap = $$poolHash{"maxfreecap"};
            if($poolMaxFreeCap < 1.0){
                $$poolInfoHash{$poolArray[$i]} = undef;
                next;
            }
            $maxsz = $poolMaxFreeCap + $maxsz;
        }
        
        if($doHash{"volsz"} > $maxsz){
            return $volumeConst->ERR_LD_NO_VALID_SIZE;
        }
        ## assign lds in pools
        my $errCode;
        ($doHash{"tosetlds"}, $errCode) = $volumeCommon->assignLd($doHash{"poolno"}, 
                                                      $doHash{"volsz"}, 
                                                      $poolInfoHash, 
                                                      $diskArraysHash);

        if(defined($errCode)) {
            return $errCode;
        }
        
        ## ld type
        if(defined($doHash{"ldtype"})){
            ##check ld type
            ##$ldType eq "LX" || $ldType eq "A4" || $ldType eq "A2" ||
            ##$ldType eq "NX" || $ldType eq "WN" || $ldType eq "CX" ||
            ##$ldType eq "AX"
        }else{
            $doHash{"ldtype"} = "LX"
        }

        ## about bltime
        if(defined($doHash{"bltime"})){
            ##check bltime;
            ##$bltime >10 && $bltime <100
        }else{
            $doHash{"bltime"} = "0";
        }

    }else{### process of nashead case
        
        my $ld ;
        my $lunListStr ;
        
        ## get all linked lun
        my $luns = $volumeCommon->getAllLunInfo();
        if(defined($$luns{$volumeConst->ERR_FLAG})){
            return $$luns{$volumeConst->ERR_FLAG};
        }
        
        ## get all used ld by lv
        my $allUsedLds =  $volumeCommon->getAllUsedLd();
        if(defined($$allUsedLds{$volumeConst->ERR_FLAG})){
            return $$allUsedLds{$volumeConst->ERR_FLAG};
        }

        ## parse disk option
        if($diskOption_sub =~ /^\s*(\S+)\s*=\s*(\S+)\s*$/){
            if(lc($1) eq "lunlist"){
                $lunListStr = $2;
            }else{
                return $volumeConst->ERR_PARAM_INVALID;
            }
        }else{
            return $volumeConst->ERR_PARAM_INVALID;
        }

        my @tmpOpts = split(/,+/ , $lunListStr);
        foreach(@tmpOpts){
            if($_ =~ /^\s*(\w+)\s*\(\s*(\d+)\s*\)\s*$/){
                my $ldAndSize = $$luns{"$1,$2"}   ;
                if(!defined($ldAndSize)){
                    return $volumeConst->ERR_LUN_NOT_LINKED;
                }
                ##check connected
                ##check linked
                ##check used
                $ld = $$ldAndSize[0];
                if(defined($$allUsedLds{$ld})){
                    return $volumeConst->ERR_LUN_LVM_USED;
                }

                push(@lds , $$ldAndSize[0]);
            }else{
                return $volumeConst->ERR_PARAM_INVALID;
            }
        }
        if(scalar(@lds) == 0){
            return $volumeConst->ERR_PARAM_INVALID;
        }
    }
    return $success;
}

###Function : check file syste option ,and set the detail param to %fsHash();
###Parameter:
###         $fsoption_sub: string supplied by command line
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkFsOption(){
    my $fsoption_sub = shift;
    if(!defined($fsoption_sub)){
        return $volumeConst->ERR_PARAM_WRONG_NUM;
    }
    #parase$fsoption_sub;
    my @tmpOpts = split(/,+/ , $fsoption_sub);
    foreach(@tmpOpts){
        if($_ =~ /^\s*(\w+)\s*=\s*(\S+)\s*$/){
            $fsHash{lc($1)} = $2;
        }
    }

    ## set about fstype
    if(!defined($fsHash{"ftype"})){
        return $volumeConst->ERR_PARAM_WRONG_NUM;
    }else{
        ##check fstype
        my $fstype = $fsHash{"ftype"};
        $fsHash{"ftype"} = lc($fstype);
    }

    ## set about codepage
    if(!defined($fsHash{"codepage"})){
        if($fsHash{"ftype"} eq "sxfsfw"){
            my $codepage = $volumeCommon->getCodepageForMP($mp);
            if($codepage =~ /^0x108000/){
                return $codepage;
            }
            $fsHash{"codepage"} = $codepage;
        }
    }else{
        ##check code page;
        my $codepage = $fsHash{"codepage"};
        $fsHash{"codepage"} = lc($codepage);
    }

    ## set about replic
    if(defined($fsHash{"repli"})){
        ##check replication: original and replic
        my $repli = $fsHash{"repli"};
        $fsHash{"repli"} = lc($repli);
    }

    if(defined($fsHash{"journal"}) && !(lc($fsHash{"journal"}) eq "expand")){
        return $volumeConst->ERR_PARAM_INVALID;
    }
    return $success;
}

###Function : check mount option ,and set the detail param to %moHash();
###Parameter:
###         $mountOption_sub: string supplied by command line
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkMountOption(){
    my $mountOption_sub = shift;
    my $repli = shift;

    if(!defined($mountOption_sub)){
        if(defined($repli) && $repli eq "replic" ){
            return $success;
        }else{
            return $volumeConst->ERR_PARAM_WRONG_NUM;
        }
    }

    #parase $mountOption_sub;
    my @tmpOpts = split(/,+/ , $mountOption_sub);
    foreach(@tmpOpts){
        if($_ =~ /^\s*(\w+)\s*=\s*(\S+)\s*$/){
            $moHash{lc($1)} = $2;
        }
    }
    ###set about snapshot
    if(!defined($moHash{"snapshot"})){
        if(!defined($repli) || $repli eq "original" ){
            return $volumeConst->ERR_PARAM_WRONG_NUM;
        }
    }else{
        ##check snapshot 10-100
    }
    ###set about quota
    ##if(defined($) && !($quato eq "on")){
    ##    return $volumeConst->ERR_PARAM_WRONG_NUM;
    ##}
    ###set about noatime
    ##if(defined($noatime) && !($noatime eq "on")){
    ##    return $volumeConst->ERR_PARAM_WRONG_NUM;
    ##}
    return $success;
}
###Function : check lv option ,and set the detail param to %lvHash();
###Parameter:
###         $lvOption_sub: string supplied by command line
###         $forExtend: 0 for create; 1 for extend
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkLVOption(){
    my $lvOption_sub = shift;  
    my $forExtend = shift;  
    
    if(!defined($lvOption_sub) && ($forExtend eq "0")){
        return $volumeConst->ERR_PARAM_WRONG_NUM;
    }
    if(defined($lvOption_sub)){
	    #parase $lvOption_sub;
        my @tmpOpts = split(/,+/ , $lvOption_sub);
        foreach(@tmpOpts){
            if($_ =~ /^\s*(\w+)\s*=\s*(\S+)\s*$/){
                $lvHash{lc($1)} = $2;
            }
        }
        ###check name
        if(!defined($lvHash{"name"}) && ($forExtend eq "0")){
            return $volumeConst->ERR_PARAM_WRONG_NUM;
        }
    }
    
    return $success;
}

###Function : extend the file system on $mp with the supplied ld
###Parameter:
###         none
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub extendFS(){
    ### process for nv case
    my $succMsg;
    if(!$isNashead){
        my @args = ();
        push(@args , $doHash{"tosetlds"}, $doHash{"ldtype"} , $doHash{"bltime"}, $friendIP);
        $retVal = $volumeCommon->createLdsInPools(@args);##value is set in checkDiskOption()
        if($retVal =~ /^\s*0x/){
            return $retVal;
        }
        push(@lds , split(",", $retVal));
        
        $succMsg = sprintf($volumeConst->MSG_LD_CREATE_1 , $retVal);
        print STDOUT $succMsg."\n";
    }

    ### get lv path
    my $lvPath = $volumeCommon->getLVPath($mp);
    if($lvPath =~ /^0x108000/){
        return $lvPath;
    }

    ### extend lv
    my $ldPathList = join("," , @lds);
    $retVal = $volumeCommon->extendLV($ldPathList , $lvPath, $lvHash{"striped"});
    if($retVal ne $success){
        return $retVal;
    }
    $succMsg = sprintf($volumeConst->MSG_LVM_EXTEND_1 , $lvPath);
    print STDOUT $succMsg."\n";

    ### extend file system
    my $cmd_xfs_growfs = $volumeConst->CMD_XFS_GROWFS;
    $retVal =system($cmd_xfs_growfs , $mp);
    if($retVal != 0){
        return $volumeConst->ERR_EXECUTE_XFS_GROWFS;
    }

    $succMsg = sprintf($volumeConst->MSG_FS_EXTEND_1 , $mp);
    print STDOUT $succMsg."\n";

    return $success;
}

### Function : check parameters for extend specified file system.
### Parameter:
###         $diskoption_sub: string supplied by command line
###         $lvoption_sub: string supplied by command line
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkExtendParam(){
    my $diskoption_sub = shift;
    my $lvoption_sub = shift;
    
    ###check disk option
    my $retVal = &checkDiskOption($diskoption_sub);
    if($retVal ne $success){
        return $retVal;
    }

    ###check disk option
    $retVal = &checkLVOption($lvoption_sub, "1");
    if($retVal ne $success){
        return $retVal;
    }
    
    $retVal = $volumeCommon->hasMounted($mp);
    if($retVal =~ /^0x108000/){
        return $retVal;
    }elsif($retVal == 1){
        return $volumeConst->ERR_FS_UMOUNTED;
    }
    return $success;

}

###Function : delete the specified file system
###Parameter:
###         none
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub deleteFS(){
    my $succMsg;
    my $retVal;
    
    ### get lv path of the specified mount point
    my $lvpath = $volumeCommon->getLVPath($mp);
    if($lvpath =~ /^0x108000/){## some error occur
        return $lvpath;
    }
    
    ### check if pair is set on VG
    $retVal = $repliCommon->vgpaircheck($mp);
	if ($retVal == 0) {
		return $repliConst->ERR_IS_PAIRED;
	} elsif ($retVal != 1) {
		return $repliConst->ERR_EXECUTE_VGPAIRCHECK;
	}
	
    $retVal = $volumeCommon->isUsedMP($mp);
    if($retVal =~ /^0x108000/ && $retVal ne $volumeConst->ERR_FTP_USED){## some error occur
        return $retVal;
    }
    
    ### umountFS ,include check whether has child
    $retVal = $volumeCommon->umountFS($mp);
    if($retVal =~ /^0x108000/){## some error occur
        return $retVal;
    }    
    ### delete in /var/spool/cron/snapshot
    $retVal = $volumeCommon->modifyCron($mp , $lvpath , $friendIP , "delete");
    if($retVal ne $success){
        return $retVal;
    }
    $succMsg = sprintf($volumeConst->MSG_FS_UMOUNT_1 , $mp);
    print STDOUT $succMsg."\n";
    
    ###get ld path list; this can also be done by cat vg_assign ,it may be fast
    my @ldPathList = ();
    my $cmd_vgdisplay = $volumeConst->CMD_VGDISPLAY;
    my $lvname = (split(/\/+/ , $lvpath))[2];
    my @content = `${cmd_vgdisplay} -Dv ${lvname} 2>/dev/null`;
    if($? != 0){
        return $volumeConst->ERR_EXECUTE_VGDISPLAY;
    }
    foreach(@content){
        if($_ =~ /^\s*PV\s+Name\s+(\S+)\s*$/){
            push(@ldPathList , $1);
        }
    }
    ### delete lv
    $retVal = $volumeCommon->deleteLV($lvpath);
    if(!($retVal eq $success)){
        return $retVal;
    }
    $succMsg = sprintf($volumeConst->MSG_LVM_DELETE_1 , $lvpath);
    print STDOUT $succMsg."\n";
    
    ### delete ld path when nv case
    if(!$isNashead){
        my $ldPaths = join("," , @ldPathList);
        $retVal = $volumeCommon->deleteLdInPool($ldPaths);
        if(!($retVal eq $success)){
            return $retVal;
        }
        $succMsg = sprintf($volumeConst->MSG_LD_DELETE_1 , $ldPaths);
        print STDOUT $succMsg."\n";
    }

    return $success;
}


###Function : check if use paired lds to create or extend syncfs volume
###Parameter:
###         none
###Return:
###         0x00000000 : all param is valid
###         other error code: some param is invalid
sub checkPairedLdsAndSyncfs(){
    my ($local_isNashead, $useLds, $repli)= @_;

    if($local_isNashead && defined($repli)){
        my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds();
        my $pairLds = {%$mvLdHash, %$rvLdHash};
        my $ldPathList = join("," , @$useLds);
        my $vgPairFlag = $repliCommon->ldpaircheck($ldPathList, $pairLds);
        if($vgPairFlag == 0) {
            return  $volumeConst->ERR_LDPAIR_SYNCFS;
        }
    }
    return $success;
}
###Function : show help message
###Parameter:
###     none
###Return :
###     none
###Output:
###     see below
sub showHelp(){
    print (<<_EOF_);
Usage:
    nas_fsbatch.pl create
            --diskoption|--do
                {poolno=<aid(poolno)[#aid(poolno)]>,volsz=<vol_size>
                [,ldtype=<LX|A4|A2|NX|WN|CX|AX>][,bltime=<build_time>]
                |lunlist=<wwnn(lun)[,wwnn(lun)]>}
            --fsoption|--fs
                {ftype=<sxfsfw|sxfs>[,codepage=<euc-jp|sjis|utf8|iso8859-1>]
                 [,repli=<original|replic>][,journal=expand]}
            --mountoption|--mo [snapshot=<snapshot_limit>][,quota=on][,noatime=on][,dmapi=on][,useGfs=true]
            --lvoption|--lo name=<lvname>[,striped=<true|false>]
            --mountpoint|--mp <mount_point>

    nas_fsbatch.pl extend
            --diskoption|--do
                {poolno=<aid(poolno)[#aid(poolno)]>,volsz=<vol_size>
                [,ldtype=<LX|A4|A2|NX|WN|CX|AX >][,bltime=<build_time>]
                |lunlist=<wwnn(lun)[,wwnn(lun)]>}
            --lvoption|--lo striped=<true|false>
            --mountpoint|--mp <mount_point>

    nas_fsbatch.pl delete --mountpoint|--mp <mount_point>
    
    nas_fsbatch.pl -h | --help

_EOF_

}
################################################