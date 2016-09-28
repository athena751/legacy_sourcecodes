#! /usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_makeDirectory.pl,v 1.7 2008/05/21 04:42:10 chenbc Exp $"

#Arguments: 
#    $groupNumber
#    $domainName
#    $computerName
#    $directoryPath
#    $nfcDirLength  : the length of $directoryPath, by UTF8(NFC) encoding

use strict;

use NS::CodeConvert;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::VolumeCommon;


my $codeConvert = new NS::CodeConvert;
my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $volumeCommon = new NS::VolumeCommon;

my $sxfsMakeDirCmd = "/bin/mkdir";
my $sxfsChownDirCmd = "/bin/chown";
my $lsDirCmd = "/bin/ls -ld";
my $chmodDirCmd = "/bin/chmod";
my $rmDirCmd = "/bin/rm -rf";
my $sxfsfwDirCmd = "/opt/nec/nasacl-utils/nasacl_mkdir";

my $paranum = scalar(@ARGV);
if($paranum != 4 && $paranum != 5){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}


my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $directoryPath = shift;
$directoryPath =~ s/\/*$//;
$directoryPath =~ s/\/+/\//g;

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
if ((-e $directoryPath)||(-l $directoryPath)) {
    print "0x10200031\n";
    exit 0;
}
#check $subDirectoryPath's length

my $thePos = rindex($directoryPath , "/");
my $subDirectoryPath = substr($directoryPath , $thePos+1);

# added for 0805 cifs limit
my $nfcDirLength = shift;
defined($nfcDirLength) or $nfcDirLength = 0;
if(length($directoryPath)>4095){
    $comm->writeErrMsg("0x1020003F",__FILE__,__LINE__+1);
    exit 1;
}
if(length($subDirectoryPath)>255){
    $comm->writeErrMsg("0x10200034",__FILE__,__LINE__+1);
    exit 1;
}
if($nfcDirLength > 240){
    $comm->writeErrMsg("0x10200041",__FILE__,__LINE__+1);
    exit 1;
}
if($nfcDirLength > 144){
    $comm->writeErrMsg("0x10200042",__FILE__,__LINE__+1);
    exit 1;
}
#

my $issxfsMp = $cifsCommon->isSXFS_MP($directoryPath, $groupNumber);
my $ret;
#sxfsfw
if( $issxfsMp == 0) {
    #mkdir,acl,chown,chmod command
    $ret = system("${sxfsfwDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    $ret = $ret/256;
    if($ret != 0){
    	if($ret ==1){
            $comm->writeErrMsg("0x10200032",__FILE__,__LINE__+1);
            exit 1;
        }else{
        	$comm->writeErrMsg("0x1020003E",__FILE__,__LINE__+1);
            exit 1;
        }
    }
}
#sxfs
if( $issxfsMp == 1) {
    #mkdir
    $ret = system("${sxfsMakeDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    if($ret != 0){
    	system("${rmDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    	$comm->writeErrMsg("0x10200033",__FILE__,__LINE__+1);
        exit 1;
    }
    
    my $parentDirPath = $directoryPath;
    $thePos = rindex($directoryPath , "/");
    $parentDirPath = substr($directoryPath , 0 , $thePos);
    my $result = `${lsDirCmd} \Q${parentDirPath}\E 2>/dev/null`;
    if($? !=0){
    	system("${rmDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    	print STDERR "Parent Directory lost!\n";
        exit 1;
    }
    my $owner;
    my $group;
    my $mode;
    if ($result=~/^(\S+)\s+\S+\s+(\S+)\s+(\S+).*$/){
        $mode = $1;
        $owner = $2;
        $group = $3;
        
    }
    #chown
    $ret = system("$sxfsChownDirCmd \Q$owner:$group\E \Q$directoryPath\E");
    if($ret != 0){
    	system("${rmDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    	$comm->writeErrMsg("0x10200035",__FILE__,__LINE__+1);
        exit 1;
    }
    #chmod
    $mode =~ s/^\S//;
    my $numMod = $cifsCommon->getNumericPermission($mode);
    if(defined($numMod)){
        $ret = system("$chmodDirCmd $numMod \Q$directoryPath\E");
        if($ret !=0){
        	system("${rmDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    	    print STDERR "chmod $directoryPath is error\n";
            exit 1;
        }
    }else{
    	system("${rmDirCmd} \Q${directoryPath}\E 2>/dev/null 1>&2");
    	print STDERR "Get ${directoryPath} Mode is error\n";
        exit 1;
    }
}
exit 0;