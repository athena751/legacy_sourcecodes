#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nashead_setLunLink.pl,v 1.4 2006/11/17 02:59:52 liuyq Exp $"

use strict;
use NS::NasHeadCommon;
use NS::NasHeadConst;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $nsguiCommon  = new NS::NsguiCommon;

if ( (scalar(@ARGV) != 2)) {
    print STDERR "The parameters' number of perl script(", __FILE__,
      ") is wrong!\n";
    exit 1;
}

my $luninfo   = shift;                   # such as wwnn1,lun1 wwnn2,lun2...
my $flag   	  = shift;                   # "0"|"1"
my @availabeWWNN_LUN  = split( /\s+/, $luninfo );

my @ldhardlnConfContent;
my @oslinkConfContent;
my $const = new NS::NasHeadConst();
my $nasHeadCommon = new NS::NasHeadCommon();

my $friendIp = $nasHeadCommon->getFriendIP();

my $file_ldhardln_conf = $nasHeadCommon->getldhardln_conf();
my $file_oslink_conf = $const->FILE_OSLINK_CONF;
if (-e $file_ldhardln_conf){
    @ldhardlnConfContent = `cat $file_ldhardln_conf`;
}
if (-e $file_oslink_conf){
    @oslinkConfContent = `cat $file_oslink_conf`;
}

my %existedLdRecord;
foreach(@ldhardlnConfContent){
    if(/^\s*\/dev\/ld([\d]+)\s*,\s*(\w+)\s*,\s*(\d+)\b/){
        #the /dev/ldxx exist in ldhardln.conf
        $existedLdRecord{$1} = "";
    }
}
foreach(@oslinkConfContent){
    if(/^\s*\/dev\/ld([\d]+)\s*,\s*(\w+)\s*,\s*(\d+)\b/){
        #the /dev/ldxx exist in oslink.conf
        $existedLdRecord{$1} = "";
    }
}

#get avairable ld name
my @availabeLd;
my $prefix = "/dev/ld";
for(my $i = 16; $i <= 511; $i++){
    if(!(defined($existedLdRecord{$i}))){
        push (@availabeLd, "$prefix$i");
    }
}

my $availableWwnn_lunNumber = scalar(@availabeWWNN_LUN);
my $linkedNumber = 0;

my $home = $ENV{HOME} || "/home/nsadmin";
my $script_ld_assign = "${home}/bin/".$const->PL_NASHEAD_ASSIGN_PL;

#if ldhardln.conf file does't not exist, touch it.
if ( ! -e $file_ldhardln_conf ) {
	if (system("touch $file_ldhardln_conf")!=0) {
		print STDERR "Failed to touch \"$file_ldhardln_conf\". Exit in perl script:",
			__FILE__, " line:", __LINE__ + 1, ".\n";
		exit 1;
	}
}

#set link 
my $j = 0;
my %failedStorageList;
my $wwnnLunLabelHash;
if($flag eq "1"){
    $wwnnLunLabelHash = $nasHeadCommon->getLunLabelHash(\@availabeWWNN_LUN);
    if(!defined($wwnnLunLabelHash)){
        print STDERR "Exit in perl script:",__FILE__, " line:", __LINE__ + 1, ".\n";
		exit 1;
    }    
}

if(!$nsguiCommon->isNashead()){
	my $retVal = $volumeCommon->restartISMServ(2);
	if($retVal != 0){
		$volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_ISMSERV);
		exit 1;
	}
}
for(my $i = 0; $i < $availableWwnn_lunNumber; $i++){
    my $wwnn_lun_ld_label = "$availabeWWNN_LUN[$i],$availabeLd[$i]";
    ### add label for lun
    if($flag eq "1"){
        if(defined($$wwnnLunLabelHash{$availabeWWNN_LUN[$i]})){
            $wwnn_lun_ld_label = $wwnn_lun_ld_label.",".$$wwnnLunLabelHash{$availabeWWNN_LUN[$i]};
        }else{
            my @wwnnLun = split(/,/,$availabeWWNN_LUN[$i]);
        	my $name = $nasHeadCommon->getStorageName($wwnnLun[0]);
    		$failedStorageList{$name} .= $wwnnLun[1].",";   
    		next;         
        }
    }else{
        $wwnn_lun_ld_label = $wwnn_lun_ld_label.",gpt";
    }
    
    my $exitCode = system("sudo $script_ld_assign ${wwnn_lun_ld_label} ${flag} ${friendIp} >& /dev/null");
    $exitCode = $exitCode >> 8;
    if($exitCode == 0){
        $linkedNumber++;
    }else{
    	my @wwnnLun = split(/,/,$availabeWWNN_LUN[$i]);
    	my $name = $nasHeadCommon->getStorageName($wwnnLun[0]);
		$failedStorageList{$name} .= $wwnnLun[1].",";
    }
}

if(!$nsguiCommon->isNashead()){
	$volumeCommon->restartISMServ(1);
}

#print linked Luns
print "LinkedLuns:".$linkedNumber."\n";

#print luns that failed to link
my $key;
foreach $key(sort keys(%failedStorageList)){
	print "storageName:".$key."\n";
	chop($failedStorageList{$key});
	print "LUNS:".$failedStorageList{$key}."\n";
}

exit 0;