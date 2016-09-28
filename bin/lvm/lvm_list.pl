#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_list.pl,v 1.8 2007/06/11 02:31:26 xingyh Exp $"

## Function:
##     list all lv's information. in both node;
##
## Parameters:
##     $refer	    -- whether for reference user.
##            1 for nsview 
##            0 for nsadmin
##  
## Output:
##     STDOUT
##         lvName=NV_LVM_001
##         size=100
##         mountPoint=/export/abc/abcd
##         deviceNo=58:6
##         storage=200000004c51781a,200000004c51781a
##         lun=16,17
##         ldList=/dev/ld16,/dev/ld17
##         striping=true
##         errorFlag=1
##         accessMode=--
##
##         lvName=NV_LVM_001
##         size=100
##         ... 
##         -------------------------------------------
##         ... 
##         -------------------------------------------
##         ...
##   
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::SystemFileCVS;
use NS::FilesystemConst;

my $nsguiCommon = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $fileCommon = new NS::SystemFileCVS;
my $filesystemConst = new NS::FilesystemConst;

if(scalar(@ARGV) != 1 ){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}
my $refer = shift;
my $retVal = 0;
my $cmd_cat = $volumeConst->CMD_CAT;
my @cfstabContent = ();
my @vgassignContent = ();
my $partnerCfstabContent = [];
my $partnerVgassignContent = [];
my $nodeNo = $nsguiCommon->getMyNodeNo();
my $cfstab = ($nodeNo eq "0") ? $volumeConst->FILE_CFSTAB_NODE0 : $volumeConst->FILE_CFSTAB_NODE1;
my $vgassign = ($nodeNo eq "0") ? $volumeConst->FILE_ASSIGN_NODE0 : $volumeConst->FILE_ASSIGN_NODE1;
my ($partnerCfstab, $partnerVgassign);  

### check in partner node
my $friendIP = $nsguiCommon->getFriendIP();
if(defined($friendIP)){
    my $exitVal = $nsguiCommon->isActive($friendIP);
    if($exitVal != 0 ){
        $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
        exit 1;
    }
}
if(-f $cfstab){
    @cfstabContent = `$cmd_cat $cfstab 2>/dev/null`;
    if($? != 0){
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_CAT);
        exit 1;
    }
}###cat error only when file not exist

if(-f $vgassign){
    @vgassignContent = `$cmd_cat $vgassign 2>/dev/null`;
    if($? != 0){
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_CAT);
        exit 1;
    }
}###cat error only when file not exist

if(defined($friendIP)){
    $partnerCfstab = ($nodeNo eq "1") ? $volumeConst->FILE_CFSTAB_NODE0 : $volumeConst->FILE_CFSTAB_NODE1;
    $partnerVgassign = ($nodeNo eq "1") ? $volumeConst->FILE_ASSIGN_NODE0 : $volumeConst->FILE_ASSIGN_NODE1;
    
    ($retVal, $partnerCfstabContent) = $nsguiCommon->rshCmdWithSTDOUT("sudo ${cmd_cat} ${partnerCfstab}", $friendIP);
    if (!defined($retVal)) { ## failed to execute rsh command
        $volumeConst->printErrMsg($volumeConst->ERR_GETINFO_PARTNER);    
        exit 1;
    }###cat error only when file not exist, so needn't to check $retVal
    
    ($retVal, $partnerVgassignContent) = $nsguiCommon->rshCmdWithSTDOUT("sudo ${cmd_cat} ${partnerVgassign}", $friendIP);
    if (!defined($retVal)) { ## failed to execute rsh command
        $volumeConst->printErrMsg($volumeConst->ERR_GETINFO_PARTNER);    
        exit 1;
    }###cat error only when file not exist, so needn't to check $retVal
}

my $lvMPHash = &getLVMPHash(\@cfstabContent);
my $lvMPHash_partner = &getLVMPHash($partnerCfstabContent);
my $lvAccessModehash = &getLVAccessModeHash_cfstab(\@cfstabContent);
my $lvAccessModehash_partner = &getLVAccessModeHash_cfstab($partnerCfstabContent);

my $lvLDHash = &getLVLDHash(\@vgassignContent);
my $lvLDHash_partner = &getLVLDHash($partnerVgassignContent);
my %lvInfo = ();
my %lvInfo_partner = ();
my %lvInfo_others = ();

my $ldhardlnHash = $volumeCommon->getLdhardlnStorage();
if (defined($$ldhardlnHash{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$ldhardlnHash{$volumeConst->ERR_FLAG});
    exit 1;
}

my $cmd_vgdisplay = $volumeConst->CMD_VGDISPLAY;
my @result = `$cmd_vgdisplay -Dv 2>/dev/null`;
if($? != 0 ){
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_VGDISPLAY);    
    exit 1;
}
my $lvLDHash_vgdisplay = &getVGs(\@result);

my @tmp;
my $line = "";
my $lvName;
my $vgName;
my $mountPoint;
my $lvSize;
my $flag = -1;
my $majorAndMinor="-:-";
my $isErr = 0;
my $lvNum = 0;
my $PESize = 0;
my $PENum = 0;
my $PEUnit = "GB";
my $striped = "false";
my $accessMode = "--";

for(my $i=0; $i<scalar(@result); $i++) {
    $flag = -1;
    $isErr = 0;
    $mountPoint = "--";
    $striped = "false";
    $majorAndMinor="-:-";
    $accessMode = "--";
    
    if($result[$i]=~/--- Volume group ---/){
        if($result[$i+9] =~ /^\s*Cur\s+LV\s+(\d+)\s*$/){ # Cur LV                1
            $lvNum = $1;
        }
        ## delete match PE size and PE unit codes :by xingyh 
        $i = $i + 19;
        next;
    }

    if($result[$i]=~/--- Logical volume ---/) {
        if($result[$i+1] =~ /^\s*LV\s+Name\s+\/dev\/\S+\/(\S+)\s*$/){ #  LV Name  /dev/NV_LVM_lyq_000/NV_LVM_lyq_000
            $lvName = $1; 
        }
        if($result[$i+2] =~ /^\s*VG\s+Name\s+(\S+)\s*$/){ #  VG Name     NV_LVM_lyq_000
            $vgName = $1; 
        }
        
        if($lvNum > 1) {
            $isErr = 1;
        }

        if($lvName=~/[^a-zA-Z0-9_-]/){
            $isErr = 2;
        }        
        
        my $ldList = $$lvLDHash_vgdisplay{$vgName};
        
        if(($lvName eq $vgName)&& $isErr == 0) {
            my $ldList_file = "--";
            $flag = 2;
            if(scalar(grep(/^$lvName$/, keys(%$lvLDHash))) == 1){
                $ldList_file = $$lvLDHash{$lvName};
                $mountPoint = $$lvMPHash{"/dev/$lvName/$lvName"};
                $accessMode = $$lvAccessModehash{"/dev/$lvName/$lvName"};
                if(!defined($mountPoint)){$mountPoint = "--";}
                $flag = 0;
            } elsif(defined($friendIP) && scalar(grep(/^$lvName$/, keys(%$lvLDHash_partner)))==1) {
                $ldList_file = $$lvLDHash_partner{$lvName};
                $mountPoint = $$lvMPHash_partner{"/dev/$lvName/$lvName"};
                $accessMode = $$lvAccessModehash_partner{"/dev/$lvName/$lvName"};
                if(!defined($mountPoint)){$mountPoint = "--";}
                $flag = 1;
            }
            if($ldList ne $ldList_file){
                $flag = 2;
            }
                
            if($flag == 2){
                $mountPoint = "--";
                $majorAndMinor = "-:-";
            }
        } else {
            if($isErr == 0) {
                $isErr = 1; ### lv name is different from vg name
            }
            $majorAndMinor = "-:-";
            $flag = 2;            
        }
        #  Current LE             30
        my $curLE = 0;
        
        ### Get LV Device :add by xingyh
        ### When LV is "NOT available" the output is different from LV available 
        if($result[$i+5] =~ /^\s*LV\s+Status\s+available\s*$/){
       		$i=$i+1;
        }
    	if($result[$i+7] =~ /^\s*Current\s+LE\s+(\d+)\s*$/){
            $curLE = $1;
        }

        my $major="-";
	    my $minor="-";
        if($result[$i+11] =~ /^\s*Persistent\s+major\s+(\S+)\s*$/){
            $major = $1;
        }                          
        if($result[$i+12] =~ /^\s*Persistent\s+minor\s+(\S+)\s*$/){
            $minor = $1;
        }
        $majorAndMinor = $major.":".$minor;

        $i=$i+12;
        ##$lvSize = $curLE * $PESize; delete lvSize compute :by xingyh
        if(!defined($mountPoint)){
            $mountPoint = "--";
        }
        if(!defined($accessMode)){
            $accessMode = "--";
        }
        my ($storage, $lun) = $volumeCommon->getStorage($ldList, $ldhardlnHash);
        my %tmpHash = ();
        $tmpHash{"lvName"}=$lvName;
        #$tmpHash{"size"}=sprintf("%.1f", $lvSize); 
        $tmpHash{"mountPoint"}=$mountPoint;
        $tmpHash{"deviceNo"}=$majorAndMinor;
        $tmpHash{"storage"}=$storage;
        $tmpHash{"lun"}=$lun;
        $tmpHash{"ldList"}=$ldList;
        $tmpHash{"striping"}=$striped;
        $tmpHash{"errorFlag"}=$isErr;
        $tmpHash{"accessMode"}=$accessMode;
        if($flag == 0) {
            $lvInfo{$lvName} =  \%tmpHash;
        }elsif(defined($friendIP) && $flag == 1) {
            $lvInfo_partner{$lvName} =  \%tmpHash;
        }else{
            $lvInfo_others{$lvName} =  \%tmpHash;
            $$lvLDHash{$lvName} = undef;
            $$lvLDHash_partner{$lvName} = undef; 
       }
    }
}

if($refer ne "1"){
    ###umount unmanaged lv
    my $cmd_vgchange_an = $volumeConst->CMD_VGCHANGE_AN;
    my $cmd_vgchange_ay = $volumeConst->CMD_VGCHANGE_AY;
    my $cmd_umount = $volumeConst->CMD_UMOUNT;
    my $cmd_mount = $volumeConst->CMD_MOUNT;
    my $retVal = 0;
   
    my @mountResult = `$cmd_mount 2>/dev/null`;
    if($? != 0){
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_MOUNT);    
        exit 1;
    }
    my $mountResult_partner = [];
    if(defined($friendIP)){
        ($retVal, $mountResult_partner) = $nsguiCommon->rshCmdWithSTDOUT("sudo $cmd_mount 2>/dev/null", $friendIP);
        if (!defined($retVal) || $retVal ne "0") { 
            return $nsguiCommon->ERR_GETINFO_PARTNER;    
        }
    }
    
    my $mount = &getLVMPHash_mount(\@mountResult);
    my $mount_partner = &getLVMPHash_mount($mountResult_partner);
    my $cfstabGuard = &getCfstabGuard($lvMPHash, $lvMPHash_partner , $mount, $mount_partner);
    my $vgtoChangeList = "";
    foreach(keys %lvInfo_others){
        my $lvPath = "/dev/$_/$_";
        my $tmpHash = $lvInfo_others{$_};
        if (defined($$cfstabGuard{$lvPath})){
            $$tmpHash{"errorFlag"} = 2;
            next;
        }elsif(defined($$mount{$lvPath}) && ($$mount{$lvPath} =~ /^\/export\//)){
            if(system("$cmd_umount $$mount{$lvPath} >&/dev/null") != 0){
                $$tmpHash{"errorFlag"} = 1;
                next;
            }
        }elsif(defined($$mount_partner{$lvPath}) && ($$mount_partner{$lvPath} =~ /^\/export\//)){
            if($nsguiCommon->rshCmd("sudo $cmd_umount $$mount_partner{$lvPath}", $friendIP) != 0){
                $$tmpHash{"errorFlag"} = 1;
                next;
            }
        }
        $vgtoChangeList = $vgtoChangeList." ".$_;
    }
    if($vgtoChangeList !~ /^\s*$/){ ## when the lvInfo_others are existing modify by xingyh 
        if($nodeNo eq "0"){
            system("$cmd_vgchange_ay $vgtoChangeList >&/dev/null"); 
            if(defined($friendIP)){
                $nsguiCommon->rshCmd("sudo $cmd_vgchange_an $vgtoChangeList", $friendIP);           
            }
        }else{ ##friendIp must exist
            system("$cmd_vgchange_an $vgtoChangeList >&/dev/null"); 
            $nsguiCommon->rshCmd("sudo $cmd_vgchange_ay $vgtoChangeList", $friendIP);
        }
    }

    ### edit file
    ## delete by xingyh 2006-12-8
    
    my $script_umount = $volumeConst->SCRIPT_LVM_UMOUNT;
    system("$script_umount >&/dev/null");
    if(defined($friendIP)){
        $nsguiCommon->rshCmd("sudo $script_umount 2>/dev/null", $friendIP);             
    }
}
my $lvsResultHash = $volumeCommon->executeLvsCmd();
if(defined($$lvsResultHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$lvsResultHash{$volumeConst->ERR_FLAG});
    exit 1;
}
my $lvsInfoHash = $volumeCommon->getStripedfromLvsResult($lvsResultHash);
my $nameSizeHash = $volumeCommon->getSizefromLvsResult($lvsResultHash);

## print info 
my $separateLine = "----------------------------------------------------";
my @lvinfos = (\%lvInfo, \%lvInfo_partner, \%lvInfo_others);
if($nodeNo eq "1"){
    @lvinfos = (\%lvInfo_partner, \%lvInfo, \%lvInfo_others);
}
for my $infoHash (@lvinfos){
    foreach my $lvName(sort (keys %$infoHash)){
        my $tmpHash = $$infoHash{$lvName};
        ## put in lv size 
        my $lvSize = $$nameSizeHash{$lvName};
        if(!defined($lvSize)){
            $lvSize = "--";
        }
        $$tmpHash{"size"} = $lvSize;
        if($$tmpHash{"errorFlag"} ne "0"){ ##managed lv must be 0;
            $$tmpHash{"deviceNo"} = "-:-";
            $$tmpHash{"storage"} = "--";
            $$tmpHash{"lun"} = "--";
            $$tmpHash{"ldList"} = "--";
        }
        if(defined($$lvsInfoHash{$lvName})){
            $$tmpHash{"striping"} = "true";
        }
        foreach(sort keys(%$tmpHash)){
            print "$_=$$tmpHash{$_}\n";
        }
        print "\n";
    }
    print "$separateLine\n";
}

exit(0);

###############################################################################
###############################################################################
### Function 
###       get lv both in cfstab and mount
### Parameter
###       $lvMPHash_sub : lv-mp pair hash reference of cfstab file content
###       $lvMPHash_partner_sub : lv-mp pair hash reference of partner cfstab file content
###       $mount_sub : lv-mp pair hash reference of mount comand
###       $mount_partner_sub : lv-mp pair hash reference of partner mount command
### Return
###       \%lvMPHash_sub : hash reference 
###            key -- lv path
###            value -- mount point path
###############################################################################
sub getCfstabGuard(){
    my ($lvMPHash_sub, $lvMPHash_partner_sub , $mount_sub, $mount_partner_sub) = @_;
    my %guardHash = ();
    foreach(sort keys (%$lvMPHash_sub)){
        if(defined($$mount_sub{$_})){
            $guardHash{$_} = "";
        }
    }
    foreach(sort keys (%$lvMPHash_partner_sub)){
        if(defined($$mount_partner_sub{$_})){
            $guardHash{$_} = "";
        }
    }
    return \%guardHash;
}

###############################################################################
### Function 
###       get lv-mp pair form cfstab file
### Parameter
###       $cfstabContent_sub : array reference of cfstab file content
### Return
###       \%lvMPHash_sub : hash reference 
###            key -- lv path
###            value -- mount point path
###############################################################################
sub getLVMPHash(){
    my ($cfstabContent_sub) = @_;
    my %lvMPHash_sub = ();
    foreach(@$cfstabContent_sub){
        if($_ =~ /^\s*(\/dev\/\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+0\s+0\s*$/){
            $lvMPHash_sub{$1} = $2;
        }
    }
    return \%lvMPHash_sub;
}

###############################################################################
### Function 
###       get lv-access mode pair form cfstab file
### Parameter
###       $cfstabContent_sub : array reference of cfstab file content
### Return
###       \%lvAccessModeHash_sub : hash reference 
###            key -- lv path
###            value -- access mode:rw,ro,syncro,syncrw
###            			
###############################################################################
sub getLVAccessModeHash_cfstab(){
    my ($cfstabContent_sub) = @_;
    my %lvAccessModeHash_sub = ();
    foreach(@$cfstabContent_sub){
        if($_ =~ /^\s*(\/dev\/\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+0\s+0\s*$/){
           my $lvPath_sub = $1;
           my $accessMode = "";  
           if(lc($3) eq "syncfs"){
               $accessMode = "sync";
           }

           if($4 =~ /\bro\b/i){
               $accessMode = $accessMode."ro";
           }else{
               $accessMode = $accessMode."rw";
           }
           
           $lvAccessModeHash_sub{$lvPath_sub} = $accessMode;
        }
    }
    return \%lvAccessModeHash_sub;
}

###############################################################################
### Function 
###       get lv-mp pair form cfstab file
### Parameter
###       $mountResult_sub : array reference of cfstab file content
### Return
###       \%lvMPHash_sub : hash reference 
###            key -- lv path
###            value -- mount point path
###############################################################################
sub getLVMPHash_mount(){
    my ($mountResult_sub) = @_;
    my %lvMPHash_sub = ();
    foreach(@$mountResult_sub){
        if($_ =~ /^\s*(\/dev\/\S+)\s+on\s+(\S+)\s+/){
            $lvMPHash_sub{$1} = $2;
        }
    }
    return \%lvMPHash_sub;
}



###############################################################################
### Function 
###       get lv-lds pair form cfstab file
### Parameter
###       $vgassignContent_sub : array reference of vgassign file content
### Return
###       \%lvLDHash_sub : hash reference 
###            key -- lv path
###            value -- ld list
###############################################################################
sub getLVLDHash(){
    my ($vgassignContent_sub) = @_;
    my %lvLDHash_sub = ();
    foreach(@$vgassignContent_sub){
        if($_=~/^\s*$/ or $_=~/^\s*#/) {
            next;
        }
        my $line = $_;
        $line =~ s/^\s*|\s*$//;
        @tmp = split(/\s+/, $line);
        my $lvName = $tmp[0];
        shift @tmp;
        $lvLDHash_sub{$lvName} = join(",", sort byLdNo (@tmp));
    }
    return \%lvLDHash_sub;
}

###############################################################################
### Function 
###       get lv-lds pair form vgdisplay result
### Parameter
###       $p : array reference of vgdisplay result
### Return
###       \%lvLDHash_sub : hash reference 
###            key -- lv path
###            value -- ld list
###############################################################################
sub getVGs() {
    my $p=shift;
    my @retArr=@$p;
    my $vgName = "";
    my $vgSize = 0;
    my @ldPath = ();
    my %vgInfo = ();
    foreach (@retArr) {
        ## match VG Name
        if ($_ =~ /^\s*VG\s+Name\s+(\S+)\s*/) { 
            if (($vgName ne "") && (scalar(@ldPath) != 0)) {
                ## matched VG Name and its VG Size, PV Name, put them into %vgInfo 
                my $ldPathList = join(",", sort byLdNo (@ldPath));
                $vgInfo{${vgName}} = $ldPathList;                
                
                $vgName = $1;
                $vgSize = 0;
                @ldPath = (); 
                
                next;
            } else {
                $vgName = $1;  ## match VG Name for the first time
            }                
        } ## end of  if ($_ =~ /^\s*VG\s+Name\s+(S+)\s*/)
        ## match PV Name 
        if ($_ =~ /^\s*PV\s+Name\s+(\S+)\s*$/) {
            push(@ldPath, $1);
        }    
    } ## end of foreach (@retArr)
    
    ## put the last set of VG Name of its VG Size, PV Name into %vgInfo
    if (($vgName ne "") && (scalar(@ldPath) != 0)) {
        my $ldPathList = join(",", sort byLdNo (@ldPath));
        $vgInfo{${vgName}} = $ldPathList; 
    }
    
    return \%vgInfo;   
}


### Function : sort storage and lun  with byStorageAndLun method
### Parameters:
###     $storageList -- "storage1,storage2"
###     $lunList     -- "16,27"
### Return :
###     ($storageList , $lunList) -- has sorted
sub sortLunStorage(){
    my ($storageList , $lunList)= @_;
    if($storageList eq "--" || $lunList eq "--"){
        return ($storageList , $lunList);
    }
    my @storageAry = split("," , $storageList);
    my @lunAry =  split("," , $lunList);
    my @lunStorageAry = ();
    for(my $i = 0; $i < scalar(@lunAry); $i++){
        push(@lunStorageAry, $storageAry[$i]." ".$lunAry[$i]);
    }
    @lunStorageAry = sort byStorageAndLun @lunStorageAry;
    @storageAry = ();
    @lunAry = ();
    foreach(@lunStorageAry){
        my ($storage , $lun) = split(/\s+/ , $_); 
        push(@storageAry, $storage);
        push(@lunAry, $lun);
    }
    return (join(",", @storageAry), join(",", @lunAry));
}

### Function : sort array by ldNo
### Parameters:
###     @array -- the array to sort
###                 element in the array is like "/dev/ld24,/dev/ld56";
### Return :
###     0 -- equal
###     1 -- greater
###     -1 -- less
sub byLdNo(){
    my $aStr;
    my $bStr;
    if($a =~ /^\/dev\/ld(\d+)\s*$/){
        $aStr = $1;
    }else{
        return -1;
    }
    if($b =~ /^\/dev\/ld(\d+)\s*$/){
        $bStr = $1;
    }else{
        return 1;
    }
    return $aStr <=> $bStr;
}
### Function : sort array by storage and lun field
### Parameters:
###     @array -- the array to sort
###                 element in the array is like "storage wwnn lun ldpath size";
### Return :
###     0 -- equal
###     1 -- greater
###     -1 -- less
sub byStorageAndLun(){
    my ($aStorage , $aLun) = split(/\s+/ , $a);
    my ($bStorage , $bLun) = split(/\s+/ , $b);
    
    if($aStorage lt $bStorage){
        return -1;
    }
    if($aStorage gt $bStorage){
        return 1;
    }
    if($aLun < $bLun){
        return -1;
    }
    if($aLun > $bLun){
        return 1;
    }
    return 0;
}

sub getLunLd(){
    my ($ldList , $lun) = @_;
    
    my @lunAry = split("," , $lun);
    my @ldAry = split("," , $ldList);
    my @lunLdAry = ();
    if($lunAry[0] eq "--" || $ldAry[0] eq "--" ){
        return "--";
    }
    for(my $i = 0; $i <scalar(@ldAry); $i++){
        my $hexLun = sprintf("%04x" , $lunAry[$i])."h";
        my $ld = $ldAry[$i];
        push(@lunLdAry, "$hexLun($ld)");
    }
    return join(",", sort(@lunLdAry));
}
