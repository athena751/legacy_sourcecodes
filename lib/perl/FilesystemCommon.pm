#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: FilesystemCommon.pm,v 1.11 2007/10/18 01:17:49 wanghb Exp $"

package NS::FilesystemCommon;
use strict;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::SystemFileCVS;
use NS::NASCollector;

my $filesystemConst = new NS::FilesystemConst;
my $volumeCommon    = new NS::VolumeCommon;
my $volumeConst     = new NS::VolumeConst;
my $nsguiCommon		= new NS::NsguiCommon;
my $fileCommon 		= new NS::SystemFileCVS;
my $nasCollector    = new NS::NASCollector;

my $cmd_checkout = $filesystemConst->CMD_CHECKOUT;
my $cmd_checkin = $filesystemConst->CMD_CHECKIN;
my $cmd_rollback = $filesystemConst->CMD_ROLLBACK;
my $cmd_vgchange_an = $volumeConst->CMD_VGCHANGE_AN;
my $cmd_vgchange_ay = $volumeConst->CMD_VGCHANGE_AY;
my $cmd_cat = $volumeConst->CMD_CAT;

my $cmd_syncwrite_o = $fileCommon->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_a = $fileCommon->COMMAND_NSGUI_SYNCWRITE_A;

sub new(){
	my $this = {};     #create an anonymous hash, and #self points to is
	bless $this;       #connect the hash to the package update
	return $this;      #return the reference to the hash
}

## Function
##     get ready status LD info from "/proc/hmd/devtable" file
##
## Parameters
##     none   
##
## Return
##     \%nvLdHash
##         success: key is $ldPath, value is [$ldNo, $ldSize]
##         error:   key is "ERROR" value is $errorCode
sub getNVReadyLd() {
	my $self = shift;
	my %nvLdHash = ();
	
	## get file name of devtable 
	my $devFile = $filesystemConst->FILE_NV_DEVTABLE;
	if (!(-f $devFile)) {
		return \%nvLdHash;
	}
	
	## get content of devtable file
	my @devFileContent = `${cmd_cat} ${devFile} 2>/dev/null`;
	if ($? != 0) {
		$nvLdHash{$volumeConst->ERR_FLAG} = $volumeConst->ERR_EXECUTE_CAT;
		return \%nvLdHash;  
	}
	
	## get ldPath, $ldNo and $ldSize 
	my $cmd_sfdisk = $volumeConst->CMD_SFDISK;
	foreach (@devFileContent) {
		my @ldInfo = split(/\s+/, $_);
		if (($_ =~ /\s*READY\s*$/i) && ($_ !~ /\s*NOT\s*READY\s*$/i)) {
			my $ldPath = $ldInfo[0];
			my @tmp    = split("/", $ldPath);
			my $ldNo   = pop(@tmp);
			
			# get size of $ldPath
			my $ldSize = `${cmd_sfdisk} -s ${ldPath} 2>/dev/null`;
			if ($? != 0) {
				next;
			}
			chomp($ldSize);
			$nvLdHash{$ldPath} = [$ldNo, $ldSize];
		}
	}
	
	return \%nvLdHash;
}

## Function
##     convert codepage from GUI display to perl process   
##
## Parameters
##     $codePage -- export group's encoding for GUI display 
##
## Return
##     $codePage -- export group's encoding for perl process
sub codepagePage2Perl() {
	my ($self, $codePage) = @_;
	
	if (lc($codePage) eq $filesystemConst->CODEPAGE_LOWERCASE_GUI_ENGLISH) {
		return $filesystemConst->CODEPAGE_LOWERCASE_ISO8859_1;
	}
	if (lc($codePage) eq $filesystemConst->CODEPAGE_LOWERCASE_GUI_UTF_8) {
		return $filesystemConst->CODEPAGE_LOWERCASE_UTF8;
	}
	
	return lc($codePage);
} 

## Function
##     get level of specified directory or mountpoint 
##
## Parameters
##     $dir -- mountpoint or directory
##
## return 
##     $level -- level of specified directory or mountpoint 
sub getDirLevel() {
	my ($self, $dir) = @_;
	
	my @tmp = split(/\/+/, $dir);
	my $level = scalar(@tmp) - 1;

	return $level;
}   
## Function
##     get parent directory of specified directory or mountpoint
##
## Parameters
## 	   $dir -- mountpoint or directory
##
## Return
##     $parentDir -- parent directory of specified directory or mountpoint
sub getParentDir() {
	my ($self, $dir) = @_;
	
	## get the index of the most right [/]
	my $rightIndex = rindex($dir, "/");  
	
	## get substring of the $dir from start position, length is $rightIndex
	my $parentDir =substr($dir, 0, $rightIndex);
	
	return $parentDir;
}

## Function
##     check export group's codepage whether is equal to the specified codepage or not
##
## Parameters
## 	   $exportGroupDir -- export group directory
##     $codepage       -- specified codepage
##
## Return
##     success:  0 -- codepage is equal
##               1 -- codepage is not equal
##     error:    errorcode
sub checkExpgrpDir() {
	my ($self, $exportGroupDir, $codepage) = @_;
	
	## get codepage of specified export group directory
	my $expgrpCodepage = $volumeCommon->getCodepageForMP($exportGroupDir);
	if ($expgrpCodepage =~ /^0x108000/) {
		return $expgrpCodepage;
	}
	
	## convert codepage from GUI display to perl process  
	$codepage = &codepagePage2Perl($self, $codepage);
	
	## match codepage
	if (lc($expgrpCodepage) ne lc($codepage)) {
		return 1;
	}
	
	## codepage is equal 
	return 0;
}

## Function
##     check direct directory  whether is accord with the specified request
##
## Parameters
## 	   $directory -- directory be checked
##     $fsType    -- specified filesystem type
##     $mountMP   -- reference of hash table, $$mountMP{$mp} = "" 
##     $cfstabMP  -- reference of hash table, $$cfstabMP{$mp} = \%optHash 
##	   $exportsMP -- reference of hash table, $$exportsMP{$mp} = "" 
##     $importsMP -- reference of hash table, $$importsMP{$mp} = "" 
##
## Return
##     success:  0 -- directory is a mountpoint, and it's fsType is equal to specified $fsType, and hasn't replication
##               1 -- directory is a unmounted mountpoint, or not valid directory,
##                    or it's fsType isn't equal to specified $fsType, or has replication
##				 2 -- directory is only a directory, not a mountpoint
sub checkDirectory() {
	my ($self, $directory, $fsType, $mountMP, $cfstabMP, $exportsMP, $importsMP) = @_;
	
	## check whether $subDir is a directory
	if ((!defined($$cfstabMP{$directory})) && (!defined($$mountMP{$directory}))) {
		return 2; 
	}
	
	## check whether mount point is mount
	if ((defined($$cfstabMP{$directory})) && (!defined($$mountMP{$directory}))) {
		return 1; 
	}
	
	## mountpoint has not mounted
	if ((!defined($$cfstabMP{$directory})) && (defined($$mountMP{$directory}))) {
		return 1; 
	}
	
	## check filesystem type
	my $mpOption        = $$cfstabMP{$directory};
	my $directoryFSType = $$mpOption{"ftype"};
	if (lc($directoryFSType) ne lc($fsType)) {
		return 1;
	}
	
	## check whether $directDir has replication
	if ((defined($$exportsMP{$directory})) || (defined($$importsMP{$directory}))) {
		return 1;
	}
		
	return 0;
}

##############################zhangjx code##############################

## Function
##     validate whether specified mount point is available for create or change or not
##
## Parameters
##     $mp	   -- mount point
##     $fsType -- filesystem type used by create
##
## Return
##     succeed: 0x00000000
##     error  : $errCode
sub validateMP4Use() {
    my ($self, $mp, $fsType) = @_;
    
    ## check mount point in local node
    ## (1)check in mount command
    my $cmd_mount = $volumeConst->CMD_MOUNT;
    my @mountResult = `${cmd_mount} 2>/dev/null`;
    if($? != 0){
        return $volumeConst->ERR_EXECUTE_MOUNT;
    }
    foreach(@mountResult){
        if($_ =~ /^\s*\S+\s+on\s+\Q${mp}\E\s+/){
            return $volumeConst->ERR_FS_MP_EXIST;
        }
        
        if($_ =~ /^\s*\S+\s+on\s+\Q${mp}\E\//){
            return $volumeConst->ERR_FS_HAS_CHILD;
        }
    }
    
    ## (2)check in cfstab file
    my $cfstabPath = $volumeCommon->getCfstabFile();
    if(-e $cfstabPath){
        my @cfstabContent = `${cmd_cat} ${cfstabPath} 2>/dev/null`;
        if($? != 0){
            return $volumeConst->ERR_EXECUTE_CAT;
        }
        foreach(@cfstabContent){
            if($_ =~ /^\s*\S+\s+\Q${mp}\E\s+/){
                return $volumeConst->ERR_FS_MP_EXIST;
            }
            
            if($_ =~ /^\s*\S+\s+\Q${mp}\E\//){
                return $volumeConst->ERR_FS_HAS_CHILD;
            }
        } ## end of foreach(@cfstabContent)
    } ## end of if(-e $cfstabPath)

    ## $mp is direct mount : check mount point in friend node  
    my @mpPartArr = split(/\/+/, $mp);
    if (scalar(@mpPartArr) == 4){

        my $friendIP = $nsguiCommon->getFriendIP();
        
        ## no friend node or friend node isn't active
        if(!defined($friendIP)) {
            return $volumeConst->SUCCESS_CODE; 
        }
        
        ## friend node is exist
                    
        ## (1) check in mount command
        my ($exitCode, $mountResult) = $nsguiCommon->rshCmdWithSTDOUT(${cmd_mount} , $friendIP);
        if (!defined($exitCode)) { ## failed to execute rsh command
            return $nsguiCommon->ERRCODE_RSH_COMMAND_FAILED;    
        }
        if ($exitCode != 0) { ## failed to execute mount command 
            return $volumeConst->ERR_EXECUTE_MOUNT_FRIEND;   
        } 
        foreach(@$mountResult){
            if($_ =~ /^\s*\S+\s+on\s+\Q${mp}\E\s+/){
                return $volumeConst->ERR_FS_IN_FRIEND_NODE;
            }
            
            if($_ =~ /^\s*\S+\s+on\s+\Q${mp}\E\//){
                return $volumeConst->ERR_FS_HAS_CHILD;
            }
        }
            
        ## (2) check in cfstab file
        ## get cfstab file path of friend node
        my $friendCfstabPath;
        if($cfstabPath eq $volumeConst->FILE_CFSTAB_NODE1){
            $friendCfstabPath = $volumeConst->FILE_CFSTAB_NODE0;
        } else {
            $friendCfstabPath = $volumeConst->FILE_CFSTAB_NODE1;
        }
            
        ## get cfstab file content of friend node
        my $cfstabContent; 
        ($exitCode, $cfstabContent) = $nsguiCommon->rshCmdWithSTDOUT("sudo ${cmd_cat} ${friendCfstabPath}", $friendIP);
       
        if (!defined($exitCode)) { ## failed to execute rsh command
            return $nsguiCommon->ERRCODE_RSH_COMMAND_FAILED;    
        }
            
        ## check in cfstab file of friend node
        foreach(@$cfstabContent){
            if($_ =~ /^\s*\S+\s+\Q${mp}\E\s+/){
                return $volumeConst->ERR_FS_IN_FRIEND_NODE;
            }
            
            if($_ =~ /^\s*\S+\s+\Q${mp}\E\//){
                return $volumeConst->ERR_FS_HAS_CHILD;
            }
        }
        
        ## $mp is'nt in friend node    
        return $volumeConst->SUCCESS_CODE;
    }
    
    ## $mp is child mount: check parent type 
    
    ##get direct mount point, check if it is a mount point in cfstab 
    my $directMp;
    $mp =~ /^\/(\S+)\/(S+)\/(S+)\/\S+/;
    $mp=~/^\s*(\/export\/[^\/]+\/[^\/]+)/;
    $directMp = $1;
    my @cfstabContent = `${cmd_cat} ${cfstabPath} 2>/dev/null`;
    if($? != 0){
        return $volumeConst->ERR_EXECUTE_CAT;
    }
    my $isMp = "no";
    foreach(@cfstabContent){
        if($_ =~ /^\s*\S+\s+\Q${directMp}\E\s+/){
            $isMp = "yes";
            last;
        }           
    } ## end of foreach(@cfstabContent)
    if ($isMp eq "no"){
        return $filesystemConst->ERR_DIRECTMP_UMOUNTED;
    }
    ## (1)get parent's filesystem type and access
    my ($parentFsType, $parentAccess , $errCode) = $volumeCommon->getTypeAccessOfParent($mp);
    if(defined($errCode)){
        return $errCode;
    }
    ## parent's access mode is read only and $mp doesn't exist
    if($parentAccess eq "ro" && !(-d $mp)){
        return $volumeConst->ERR_FS_PARENT_READ_ONLY;
    }
     
    ## $mp's filesystem type is different from its parent 
    if(lc($fsType) ne lc($parentFsType)){
        return $volumeConst->ERR_FS_DIFF_TYPE;
    }
    
    ## (2)check if parent is replication
    my $parentIsRepli = $volumeCommon->hasRepliParent($mp);
    ## failed to call hasRepliParent()
    if ($parentIsRepli =~ /^0x108000/) {
        return $parentIsRepli;
    } 
    ## parent is replication
    if ($parentIsRepli == 1) {
        return $volumeConst->ERR_REPLI_PARENT;
    }
    
    return $volumeConst->SUCCESS_CODE;
}

###Function : umount file system , and remove mount point , delete PSID , edit cfstab
###Parameter:
###         $mp    : the mount point path of the specified file system 
###         $force : "force" or undef
###Return :
##      "0x00000000" -- successful 
##      others errcode -- some errors occured; 
sub umountFS(){
    my ($self , $mp , $force) = @_ ;
    my $retVal ;
    
    ##edit cfstab
    my $cfstab = $volumeCommon->getCfstabFile();
    if($fileCommon->checkout($cfstab) != 0 ){
        return  $volumeConst->ERR_EDIT_CFSTAB;
    }

    if(!open(FILE , $cfstab)){
        $fileCommon->rollback($cfstab);
        return  $volumeConst->ERR_EDIT_CFSTAB;
    }
    my @content = <FILE>;
    close FILE;

    if(!open(FILE , "| ${cmd_syncwrite_o} ${cfstab}")){
        $fileCommon->rollback($cfstab);
        return  $volumeConst->ERR_EDIT_CFSTAB;
    }
    foreach(@content){
        if(/^\s*#.*/){
            print FILE $_;
        }elsif($_=~/.+\s+\Q${mp}\E\s+.*/){
            next;
        }else{
            print FILE $_ ;
        }
    }
    if(!close(FILE)) {
        $fileCommon->rollback($cfstab);
        return  $volumeConst->ERR_EDIT_CFSTAB;        
    }
    
    ### check if the file system is mounted, and get file system type and lv path
    my ($isMounted , $lvpath , $type , $access ,$quota , $repli , $noatime , $dmapi , $errCode) = $volumeCommon->getFSMountOption($mp);
    if(defined($errCode)){
        $fileCommon->rollback($cfstab);
        return $errCode;
    }
    if($isMounted == 0){
        $fileCommon->rollback($cfstab);
        return $volumeConst->ERR_FS_UMOUNTED;
    }

    ## check if the specified file system has sub mount point
    $retVal = $volumeCommon->hasChild($mp);
    if($retVal =~ /^0x108000/){
        $fileCommon->rollback($cfstab);
        return $retVal;
    }elsif($retVal == 0){
        $fileCommon->rollback($cfstab);
        return $volumeConst->ERR_FS_HAS_CHILD;
    }

    ### delete PSID when file system type is sxfsfw case
    my $cmd_ims_domain = $volumeConst->CMD_IMS_DOMAIN;
    my $ims_conf = $volumeCommon->getImsConfFile();
    my $checkPsid;
    if($type eq "sxfsfw"){
        $checkPsid = $volumeCommon->checkPSID($ims_conf , $mp);
        if($checkPsid =~ /^0x108000/){
        	$fileCommon->rollback($cfstab);
            return $checkPsid ;
        }
        if($checkPsid == 1){
            $retVal = system($cmd_ims_domain ,"-D" , $mp , "-af" , "-c" ,$ims_conf) ;
            if($retVal != 0){
                $fileCommon->rollback($cfstab);
                return $volumeConst->ERR_EXECUTE_IMS_DOMAIN;
            }
        }
    }

    ### delete auth
    my $hasSetAuth = $volumeCommon->hasSetAuth($mp);
    if($hasSetAuth =~ /^0x108000/){
        $fileCommon->rollback($cfstab);
        if(($type eq "sxfsfw") && ($checkPsid == 1)){
            system($cmd_ims_domain , "-A" , $mp , "-f" , "-c" , $ims_conf); ##login psid
        }
        return $hasSetAuth;
    }
    if($hasSetAuth){
        my $cmd_auth = $volumeConst->CMD_IMS_AUTH;
        my $exitCode = system("${cmd_auth} -D -d ${mp} -f -c ${ims_conf}");
        if ($exitCode != 0) {
            $fileCommon->rollback($cfstab);
            if(($type eq "sxfsfw") && ($checkPsid == 1)){
                system($cmd_ims_domain , "-A" , $mp , "-f" , "-c" , $ims_conf); ##login psid
            }
            return $volumeConst->ERR_DELETE_AUTH;
        }
    }
    
    ## force to umount file system
    my $cmd_ims_ntvol = $volumeConst->CMD_IMS_NTVOL;
    my $cmd_vol_umount = $volumeConst->CMD_VOL;
    if (defined($force) && $force eq "force"){
    	$retVal = system($cmd_vol_umount , "umount" , $mp , "really-force");
    }else{
    	$retVal = system($cmd_vol_umount , "umount" , $mp);	
    }
    if($retVal != 0 ){
        $fileCommon->rollback($cfstab);
        if(($type eq "sxfsfw") && ($checkPsid == 1)){
            system($cmd_ims_domain , "-A" , $mp , "-f" , "-c" , $ims_conf); ##login psid
        }
        if($hasSetAuth){
            $volumeCommon->setAuth($mp , $type);
        }
        return $volumeConst->ERR_EXECUTE_VOL;
    }

    ##checkin cfstab 
    $fileCommon->checkin($cfstab);
    
    ##rm mount point
    my @tmp =split(/\/+/ , $mp);
    my $cmd_rmdir = $volumeConst->CMD_RMDIR;
    my $level = scalar(@tmp);
	if($level == 4) {
	    $retVal = system("$cmd_rmdir $mp");
	} else {  
		my $cmd_ls = $volumeConst->CMD_LS;
	    my $tmpLs = `$cmd_ls -ld $mp`;
	    my @option = split(/\s+/, $tmpLs);
	    if($option[2] eq "root" && $option[3] eq "root") {
	        $retVal = system("$cmd_rmdir $mp");
	    }
	}

    ### get friend ip
    my $friendIP = $nsguiCommon->getFriendIP();
    if(defined($friendIP)){
        if($nsguiCommon->isActive($friendIP) != 0){
            return $volumeConst->ERR_FRIEND_NODE_DEACTIVE;
        }
    }
    ### rm mount point when cluster and direct mount case
    my $cmd_rsh_pl = $volumeConst->HOME_DIR.$volumeConst->CMD_CLUSTER_RSH_PL;
    if((scalar(@tmp) == 4) && (defined($friendIP) )){
        
        $retVal = system($cmd_rsh_pl , "sudo" , $cmd_rmdir , $mp , $friendIP);
    }

    my $lvName = (split("/" , $lvpath))[3];
    $retVal = $volumeCommon->delGfs($lvName);
    if($retVal =~ /^\s*0x108000/ ){
        return $retVal;
    }
    
    return $volumeConst->SUCCESS_CODE;
}

###Function : check whether the specified fs type is same to the mp's previous fs type
###Parameter:
###         $mp    : the mount point path of the specified file system 
###			$fsType: the specified fstype
###			$lvName: lv path
###			$codePage: exportGroup's codePage
###Return :
##      "0x00000000" -- successful 
##      others errcode -- some errors occured; 
sub checkFS(){
	my ($self, $mp, $fsType, $lvName, $codePage, $repli, $access, $quota, $noatime, $norecovery, $dmapi) = @_;
	my $cmd_mount = $volumeConst->CMD_MOUNT;
	my ($args , $volMountArgs , $line) = 
        $volumeCommon->generateMountAndCfstabStr($lvName , $mp , $fsType , $access , $repli , $quota , $noatime , $norecovery , $dmapi);	
	my $cmd_mkdir = $volumeConst->CMD_MKDIR;
	my $cmd_rm = $volumeConst->CMD_RM;
	
    my $mpExist = 1;
    my $acldir = undef;
    if(!(-d $mp)){
        $acldir = $volumeCommon->getFirstNotExistParent($mp);
        system($cmd_mkdir,"-p",$mp);
        $mpExist = 0;
    }
	if(system($cmd_mount, @$args)!=0) {
        if($mpExist != 1) {
            system($cmd_rm , "-fr" , $mp);
            if(defined($acldir)){
                system($cmd_rm , "-fr" , $acldir);
            }
        }
		return 	$filesystemConst->ERR_DIFF_FSTYPE;
	}elsif($fsType eq "sxfsfw"){
		my $cmd_xfs_info = $filesystemConst->CMD_XFS_INFO;
		my @contents = `$cmd_xfs_info $mp 2>/dev/null`;
		if ($? != 0) {
		    &umountVol4CheckFS($self, $mp, $mpExist, $acldir);
		    return $filesystemConst->ERR_CMD_XFS_INFO;			
		}
		foreach(@contents) {
        	if($_ =~ /codepage\s*=\s*(\S+)\s*$/) {
                if($1 !~/^$codePage$/i){
                    &umountVol4CheckFS($self, $mp, $mpExist, $acldir);
                    return $filesystemConst->getErrorCode($1);
                }  
            }
    	}   
	}
   
	&umountVol4CheckFS($self, $mp, $mpExist, $acldir);

	return $volumeConst->SUCCESS_CODE;
}

sub umountVol4CheckFS() {
	my ($self, $mp, $mpExist, $acldir) = @_;
	my $cmd_umount = $volumeConst->CMD_VOL;
	my $cmd_rm     = $volumeConst->CMD_RM;
	
	system("$cmd_umount umount $mp really-force 2>/dev/null");	
    if($mpExist != 1) {
        if(defined($acldir)){
            system($cmd_rm , "-fr" , $acldir);
        } else {
            system($cmd_rm , "-fr" , $mp);
        }
    }
}

################################################################
## Function
##     get the mountpoint and its submount from cfstab
##
## Parameters
##     $mountpoint
##
## Return
##     an array such as: [[lv1, mp1],[lv2, mp2],[lv3, mp3]]
sub getSubMountList() {
    my $self = shift;
    my $mp = shift;
    my $cfstabFile = $volumeCommon->getCfstabFile();
    my @result = ();
    
    my @cfstabContent = `$cmd_cat $cfstabFile 2>/dev/null`;
    if($? != 0 ) {
    	return $volumeConst->ERR_EXECUTE_CAT;
    }
    foreach(@cfstabContent) {
        if(/^\s*(\S+)\s+(\Q$mp\E|\Q$mp\E\/\S+)\s+/) {
            push(@result, [$1, $2]);
        }
    }
	return \@result;
}

################################################################
## Function
##     get the mountpoint and its submount from cfstab
##
## Parameters
##     $lvName       -- the lv to move between node
##     $friendIp     -- the partner node's ip
##
## Return
##     0: success
##     1: failed
sub lvmMove() {
    my $self = shift;
    my $lvName = shift;
    my $friendIp = shift;
    $lvName = (split("/",$lvName))[2];
   
    my $src_vg_assign = $volumeCommon->getVg_assignFile();
    my $nodeNo = $nsguiCommon->getMyNodeNo();
    my $des_vg_assign = ($nodeNo == 0)? $volumeConst->FILE_ASSIGN_NODE1 : $volumeConst->FILE_ASSIGN_NODE0;
    
    ## modify file "/etc/group[0|1]/vg_assign" and "/etc/group[0|1]/lvm_nickname" 
    if ($fileCommon->checkout($src_vg_assign)!= 0 
       || $nsguiCommon->rshCmd("sudo $cmd_checkout $des_vg_assign", $friendIp)!=0
       || $nsguiCommon->syncFileFromOther($des_vg_assign, $friendIp)!=0
       || &lineMove($self, $lvName, $src_vg_assign, $des_vg_assign)!=0) {
        &lvmMoveRollback($self, $lvName, $friendIp, 1);
        return 1;
    } 

    my $cmd_vgscan2 = $volumeConst->CMD_VGSCAN2;
    system("$cmd_vgscan2 >&/dev/null");
    ## inactive the lv in this node and active it in partner node
    if(system("$cmd_vgchange_an $lvName 2>/dev/null")!=0) {
        &lvmMoveRollback($self, $lvName, $friendIp, 1);
        return 1;    
    }

    my $volName = $lvName;
    $volName =~ s/^\s*NV_LVM_//;  
    $nasCollector->tuneRRDFile("NAS_LV_IO", $volName);
    
    if($nsguiCommon->rshCmd("sudo $cmd_vgchange_ay $lvName", $friendIp) !=0 ) {
        &lvmMoveRollback($self, $lvName, $friendIp, 2);
        return 1;    
    }

    if ($nsguiCommon->syncFileToOther($des_vg_assign, $friendIp)!=0
       || $fileCommon->checkin($src_vg_assign)!= 0 
       || $nsguiCommon->rshCmd("sudo $cmd_checkin $des_vg_assign", $friendIp)!=0) {
        &lvmMoveRollback($self, $lvName, $friendIp, 3);
        return 1;
    }

    my $cmd_rm = $volumeConst->CMD_RM;    
    system("$cmd_rm -f $des_vg_assign >&/dev/null");
    return 0;        
}

################################################################
## Function
##     When failed in lvmMove, rollback the steps.
##
## Parameters
##     $lvName       -- the lv to move between node
##     $friendIp     -- the partner node's ip
##     $step         -- the flag to sign which step should be rollback.
##
## Return
##     none
sub lvmMoveRollback() {
    my ($self, $lvName, $friendIp, $step) = @_;

    my $src_vg_assign = $volumeCommon->getVg_assignFile();
    my $nodeNo = $nsguiCommon->getMyNodeNo();
    my $des_vg_assign = ($nodeNo == 0)? $volumeConst->FILE_ASSIGN_NODE1 : $volumeConst->FILE_ASSIGN_NODE0;

    if($step > 2) {
        $nsguiCommon->rshCmd("sudo $cmd_vgchange_an $lvName", $friendIp);
    }

    if($step > 1) {
        system("$cmd_vgchange_ay $lvName 2>/dev/null");
    }    

    if($step > 0) {
        $fileCommon->rollback($src_vg_assign);
        $nsguiCommon->rshCmd("sudo $cmd_rollback $des_vg_assign", $friendIp);
    }
    
    my $cmd_rm = $volumeConst->CMD_RM;
    system("$cmd_rm -f $des_vg_assign >&/dev/null");
}

################################################################
## Function
##     move a file from srcFile to desFile
##
## Parameters
##     $lvName  -- the line include this lvName
##     $srcFile -- the source file
##     $desFile -- the destination file
##
## Return
##     0: success
##     1: failed
sub lineMove() {
    my ($self, $lvName, $srcFile, $desFile) = @_;
    my @srcContent = `$cmd_cat $srcFile 2>/dev/null`;
    if(!open(SRC_FILE, "| ${cmd_syncwrite_o} $srcFile")
      ||!open(DES_FILE, "| ${cmd_syncwrite_a} $desFile")){
        return 1;
    }
    
    foreach(@srcContent) {
        if(/^\s*$lvName\s+/) {
            print DES_FILE $_;
        } else {
            print SRC_FILE $_;
        }
    }
    if(!close(SRC_FILE)
      ||!close(DES_FILE)) {
        return 1;    
    }
    return 0;
}

################################################################
## Function
##     Delete the mountpoint directory to move
##     and create the mountpoint directory where move to.
##
## Parameters
##     $srcmp  -- the mountpoint to move
##     $desmp -- the mountpoint where move to
##     $friendIp -- the destination node's ip
##
## Return
##     0: success
##     1: failed
sub syncDir() {
    my ($self, $srcmp, $desmp, $friendIp) = @_;
    my $cmd_rmdir = $volumeConst->CMD_RMDIR;
    my $cmd_mkdir = $volumeConst->CMD_MKDIR;
    my $cmd_ls = $volumeConst->CMD_LS;
    my $ret;
    if($volumeCommon->isChild($srcmp)) {
        if(system("$cmd_rmdir $srcmp 2>/dev/null")!=0 
          || system("$cmd_mkdir -p $desmp 2>/dev/null")!=0
          || $nsguiCommon->rshCmd("sudo $cmd_rmdir $srcmp", $friendIp)!=0
          || $nsguiCommon->rshCmd("sudo $cmd_mkdir -p $desmp", $friendIp)!=0 ) {
            return 1;
        }
    } else {
        my $tmp = `$cmd_ls -ld $srcmp 2>/dev/null`;
        my @option = split(/\s+/, $tmp);
        if($option[2] eq "root" && $option[3] eq "root") {
            system("$cmd_rmdir $srcmp 2>/dev/null");
        }
        if($nsguiCommon->rshCmd("sudo $cmd_mkdir -p $desmp", $friendIp)!=0) {
            return 1;
        }        
    }
    return 0;
}

################################################################
## Function
##     Delete the mountpoint to move from source node's cfstab
##     and add it in destination node's cfstab
##
## Parameters
##     $srcmp  -- the mountpoint to move
##     $desmp -- the mountpoint where move to
##
## Return
##     0: success
##     1: failed
sub cfstabMove() {
    my ($self, $srcmp, $desmp) = @_;
    my $src_cfstab = $volumeCommon->getCfstabFile();
    my $nodeNo = $nsguiCommon->getMyNodeNo();
    my $des_cfstab = ($nodeNo == 0)? $volumeConst->FILE_CFSTAB_NODE1 : $volumeConst->FILE_CFSTAB_NODE0;
    
    my @srcContent = `$cmd_cat $src_cfstab 2>/dev/null`;
    my @desContent = `$cmd_cat $des_cfstab 2>/dev/null`;

    if(!open(SRC_FILE , "| ${cmd_syncwrite_o} $src_cfstab")
      ||!open(DES_FILE , "| ${cmd_syncwrite_a} $des_cfstab")){
        return 1;
    }
    
    foreach(@srcContent) {
        my $thisLine = $_;
        if(/^\s*\S+\s+\Q$srcmp\E\s+/) {
            $thisLine =~ s/\s+\Q$srcmp\E\s+/ $desmp /;
            print  DES_FILE $thisLine;
        } elsif (/^\s*\S+\s+\Q$srcmp\E\/\S+\s+/) {
            $thisLine =~ s/\s+\Q$srcmp\E\// $desmp\//;
            print  DES_FILE $thisLine;
        } else {
            print SRC_FILE $_;
        }
    }        
    if(!close(SRC_FILE)
      ||!close(DES_FILE)) {
        return 1;
    }
    return 0;
}

## Function
##     get the path of lvm_nickname file
##
## Parameters
##     none
##
## Return
##     /etc/group[0|1]/lvm_nickname
sub getLVMNickNameFile() {
    my $nodeNo = $nsguiCommon->getMyNodeNo();  ##don't need check the result 
    
    if ($nodeNo == 1) {
        return $filesystemConst->FILE_LVM_NICKNAME_NODE1;
    }   	
    
    return $filesystemConst->FILE_LVM_NICKNAME_NODE0;
}

sub getRRDFileName() {
	my ($self, $lvName) = @_;
	my $cmd_hostname = $filesystemConst->CMD_HOSTNAME;
	my $hostname = `$cmd_hostname -s`;
	chomp($hostname);
	$lvName =~ s/\//#/g;
    my $rrd_filename = join("", $filesystemConst->RRDFILE_PATH, $hostname, 
                            $filesystemConst->RRDFILE_PREFIX, $lvName, $filesystemConst->RRDFILE_SUFFIX);
    return $rrd_filename;
}

1;                