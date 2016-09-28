#! /usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_delDirectory.pl,v 1.6 2008/12/29 03:51:23 fengmh Exp $"
use strict;
use NS::CodeConvert;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::VolumeConst;
use NS::VolumeCommon;

my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;
my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $volumeConst      = new NS::VolumeConst;
my $volumeCommon     = new NS::VolumeCommon;

my $rmDirCmd = "/bin/rmdir";
my $lsDirCmd = "/bin/ls -A";

my $errFlag = $volumeConst->ERR_FLAG;

my $paranum = scalar(@ARGV);
if($paranum != 4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}


my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $directoryPath = shift;
$directoryPath =~ s/\/*$//;
$directoryPath =~ s/\/+/\//g;
my $mountPoint; #3level

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR "Get export group is error"."\n";
    exit 1;
}
$directoryPath = $codeConvert->changeUTF8Encoding($directoryPath, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($directoryPath)){
    print STDERR "Change encoding is error.\n";
    exit 1;
}


if (!(-d $directoryPath)) {
	$comm->writeErrMsg("0x1020003D",__FILE__,__LINE__+1);
    exit 1;
}

if($directoryPath =~ /^(\/.+?\/.+?\/.+?\/).+/){
   $mountPoint = $1;
}

my $cfstabMPHash = $volumeCommon->getMountOptionsFromCfstab();
if (defined($$cfstabMPHash{$volumeConst->ERR_FLAG})) {
    print STDERR "Check MountPoint is wrong!\n";
    exit 1;
}
if (defined($$cfstabMPHash{$directoryPath})) {
    $comm->writeErrMsg("0x1020003C",__FILE__,__LINE__+1);
    exit 1;
}

my $tmpDir = $cifsCommon->getMP($groupNumber, $directoryPath);
$tmpDir = $tmpDir."/"."/";
my ($parentFsType, $parentAccess , $errCode) = $volumeCommon->getTypeAccessOfParent($tmpDir);
if(defined($errCode)){
    print STDERR "Check FS access mode is wrong!\n";
    exit 1;
}
if($parentAccess eq "ro"){
    $comm->writeErrMsg("0x1020003A",__FILE__,__LINE__+1);
    exit 1;
}

#guard whether the directory is empty
my @fileArray = `$lsDirCmd \Q$directoryPath\E`;
if($? !=0){
	print STDERR "Check directory whether is empty error!\n";
    exit 1;
}
if((defined(@fileArray))&&scalar(@fileArray)>0){
	$comm->writeErrMsg("0x10200036",__FILE__,__LINE__+1);
    exit 1;
}

my $issxfsMp = $cifsCommon->isSXFS_MP($directoryPath, $groupNumber);
#0 <-->sxfsfw
#1 <-->sxfs

if(!defined($issxfsMp)){
    print STDERR "Check file system type is wrong!\n";
    exit 1;
}
if($issxfsMp ==0){
    $directoryPath = $cifsCommon->compactPath4Win($directoryPath);
}
$directoryPath =~ s/\/*$/\//;
#guard whether is cifs share 
my %shareHash = ();
my $smb_conf_content = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);
my ($shareNameRef, $shareSectionIndexRef) = $cifsCommon->getAllShareInfo($smb_conf_content);
my $shareNumbers = scalar(@$shareNameRef);
if($shareNumbers > 0){
    
    for(my $tmpIndex = 0; $tmpIndex < $shareNumbers; $tmpIndex++){
        my $shareName = @$shareNameRef[$tmpIndex];
        my $endIndex;
        if($tmpIndex == ($shareNumbers - 1)){
            $endIndex = scalar(@$smb_conf_content) - 1;
        }else{
            $endIndex = @$shareSectionIndexRef[$tmpIndex + 1] - 1;
        }
        my @tmpSection = @$smb_conf_content[@$shareSectionIndexRef[$tmpIndex]..$endIndex];
        my $directory = $confCommon->getKeyValue("path", $shareName, \@tmpSection);
        if(!defined($directory)){
            next;
        }
        $directory =~ s/\/*$/\//;
        $directory =~ s/\/+/\//g;
        if(index($directory,$mountPoint) !=0){
            next;
        }
        if($issxfsMp ==0){
            $directory = $cifsCommon->compactPath4Win($directory);
            if($directory =~ /^\Q$directoryPath\E/i){
                $comm->writeErrMsg("0x10200037",__FILE__,__LINE__+1);
       	        exit 1;
            }
        }
        if($issxfsMp ==1){
             $shareHash{lc($shareName)} = $directory;
             if($directory =~ /^\Q$directoryPath\E/){
                 $comm->writeErrMsg("0x10200037",__FILE__,__LINE__+1);
                 exit 1;
             }
        }
    }
}
#guard whether is directory control

my $dirAccessFile = $cifsCommon->getDirAccessConfFileName($groupNumber, $domainName, $computerName);

if($dirAccessFile eq ""){
   $dirAccessFile = $cifsCommon->getDefaultDirAccessConfFileName($groupNumber, $domainName, $computerName);
}

if(-f $dirAccessFile){
    open(F, $dirAccessFile);
    my @fileContent = <F>;
    close(F);
    my $lines = scalar(@fileContent);
    my $startShare;
    my $endShare;
    my $shareName;
    my $i = 0;
    my $dirAccessArray;
    while($lines > 0){
    	my @tempArray = $cifsCommon->getDirAccessShareSection(\@fileContent,$i);
    	if(scalar(@tempArray)>0){
    	    $shareName = lc(pop(@tempArray));
    	    $endShare = pop(@tempArray);
            $startShare = pop(@tempArray);
    	}else{
            last;
    	}
    	if(!defined($shareHash{$shareName})){
    	    if($lines <= $endShare+1){
                last;
            }else{
                $i = $endShare+1;
                next;
    	    }
    	}
    	$dirAccessArray = $cifsCommon->getDirAccessArray(\@fileContent,$startShare,$endShare);
    	if(scalar(@$dirAccessArray)>0){
            foreach(@$dirAccessArray){
                my $tmpdir = $shareHash{$shareName}."/".$_;
                $tmpdir =~ s/\/*$/\//;
                $tmpdir =~ s/\/+/\//g;
    		if($tmpdir =~ /^\Q$directoryPath\E/){
                    $comm->writeErrMsg("0x10200039",__FILE__,__LINE__+1);#have dir access setting 
                    exit 1;
                }
    	    }
    	}
    	$i = $endShare+1;
    	
    }
}

#guard whether is nfs share
if($cifsCommon->checkNFSShare($groupNumber,$directoryPath,$issxfsMp,$mountPoint) eq "yes"){
    $comm->writeErrMsg("0x10200038",__FILE__,__LINE__+1);
    exit 1;
}

#rmdir
$directoryPath =~ s/\/*$//;
my $ret = system("${rmDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
if($ret !=0){
    $comm->writeErrMsg("0x10200036",__FILE__,__LINE__+1);
    exit 1;
}
exit 0;
