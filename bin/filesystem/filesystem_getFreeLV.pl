#!/usr/bin/perl -w
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_getFreeLV.pl,v 1.4 2008/05/24 12:07:37 liuyq Exp $"

#Function: get all free Logical Volumes 
#Parameters:
    #none
#output:
    #$VgName	$VgSize	$LvNickName
#exit code:
    #0 ---- success
    #1 ---- failure
    
use strict;
use NS::VolumeConst;
use NS::VolumeCommon;
use NS::NsguiCommon;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::ReplicationCommon;
use NS::DdrCommon;

my $volumeConst = new NS::VolumeConst;
my $volumeCommon = new NS::VolumeCommon;
my $nsgui = new NS::NsguiCommon;
my $fsConst = new NS::FilesystemConst;
my $fsCommon = new NS::FilesystemCommon;
my $repliCommon = new NS::ReplicationCommon;
my $ddrCommon    = new NS::DdrCommon;

#get $lvInfo{lvName} = "$vgSize:$ldPathList";
#VgName is same to LvName and VgSize equals LvSize.
#error code: 0x1080006d
my $lvInfo = $volumeCommon->getVgdisplayInfo();
if ((defined($$lvInfo{$volumeConst->ERR_FLAG}))&&($$lvInfo{$volumeConst->ERR_FLAG} ne "")){ 
    $volumeConst->printErrMsg($$lvInfo{$volumeConst->ERR_FLAG});
    exit 1;
}
my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds();
my $pairLds = {%$mvLdHash, %$rvLdHash};

my @vg_assign = ();#all vg name in /etc/group0|1/vg_assing
my %vg_cfstab = ();
my %vg_mount = ();
my %lvm_nickname = ();

my @freeLV;

&getVg_assign(\@vg_assign);
&getVg_cfstab(\%vg_cfstab);
&getVg_mount(\%vg_mount);
&getLvm_nickname(\%lvm_nickname);

foreach(@vg_assign){
	if (!defined($vg_cfstab{$_}) 
	    && !defined($vg_mount{$_})
	    && defined($$lvInfo{$_})){
		my $vg_size = (split(/:/, $$lvInfo{$_}))[0];
		my $ldpathList = (split(/:/, $$lvInfo{$_}))[1];
		if(defined($vg_size) && ($vg_size ne "") && ($vg_size ne "--")
		&& defined($ldpathList) && ($ldpathList ne "")) {
    		my $lv_nickname = $lvm_nickname{$_};
    		if (!defined($lv_nickname) || $lv_nickname eq ""){
    			$lv_nickname = $fsConst->NO_LVM_NICKNAME;	
    		}
    		## get VG's pair info
    		my $vgPairFlag = $repliCommon->ldpaircheck($ldpathList, $pairLds);
    		push(@freeLV, $_."\t".$vg_size."\t".$lv_nickname."\t".$vgPairFlag);
	    }
	}
}

foreach(@freeLV){
	print $_."\n";	
}
exit 0;


##################sub defination#########################
###Function : Get all vg name in /etc/group[0|1]/vg_assing;
###Parameter:
###         \@vg_assign	refers to @vg_assign
###Return:
###         none
sub getVg_assign(){
	my $vg_assign = shift;
	my $vg_assignFile = $volumeCommon->getVg_assignFile();
	my $CMD_CAT = $volumeConst->CMD_CAT; 
	my @content = `$CMD_CAT $vg_assignFile 2>/dev/null`;
	foreach(@content){
		my $tmp = (split(/\s+/,$_))[0];
		push(@$vg_assign,$tmp);
	}
}

###Function : Get all vg name in /etc/group[0|1]/cfstab;
###Parameter:
###         \%vg_cfstab	refers to %vg_cfstab
###			key=vg name; value=this line of the cfstab
###Return:
###         none
sub getVg_cfstab(){
	my $vg_cfstab = shift;
	my $cfstabFile = $volumeCommon->getCfstabFile();
	my $CMD_CAT = $volumeConst->CMD_CAT;
	my @content = `$CMD_CAT  $cfstabFile 2>/dev/null`;
	foreach(@content){
		my $tmp = (split(/\s+/,$_))[0];
		if ($tmp =~ /^\/dev\/(\S+)\/\S+/){
			$$vg_cfstab{$1} = $tmp;	
		}
	}
}

###Function : Get all vg name in mount's result;
###Parameter:
###         \%vg_cfstab	refers to %vg_cfstab
###			key=vg name; value=this line of mount result
###Return:
###         none
sub getVg_mount(){
	my $vg_mount = shift;
	my $CMD_MOUNT = $volumeConst->CMD_MOUNT;
	my @result = `$CMD_MOUNT 2>/dev/null`;
	foreach(@result){
		my $tmp = (split(/\s+/,$_))[0];
		if (($tmp =~ /^\/dev\/(\S+)\/(\S+)/) && ($1 eq $2)){
			$$vg_mount{$1} = $tmp;	
		}
	}
}

###Function : Get all lvm nicknames in /etc/group[0|1]/lvm_nickname;
###Parameter:
###         \%lvm_nickname refers to %lvm_nickname
###			key=vg name; value=this line of mount result
###Return:
###         none
sub getLvm_nickname(){
	my $lvm_nickname = shift;
	
	my $lvm_nicknameFile = $fsCommon->getLVMNickNameFile();
	
	if (!(-e $lvm_nicknameFile)){ 
		return;
	}
	my $CMD_CAT = $volumeConst->CMD_CAT;
	my @content = `$CMD_CAT $lvm_nicknameFile 2>/dev/null`;
	foreach(@content){
		my $tmp_key = (split(/\s+/,$_))[0];
		my $tmp_value = (split(/"/,$_))[1];
		$$lvm_nickname{$tmp_key} = $tmp_value;	
	}	
}



