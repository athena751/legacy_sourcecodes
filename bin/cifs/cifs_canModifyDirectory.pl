#! /usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_canModifyDirectory.pl,v 1.5 2008/12/29 03:51:23 fengmh Exp $"

use strict;

use NS::CIFSConst;
use NS::CIFSCommon;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::CodeConvert;

my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $codeConvert = new NS::CodeConvert;

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

while(1){
    if (-d $directoryPath) {
        last;
    } else {
        my $thePos = rindex($directoryPath , "/");
        $directoryPath = substr($directoryPath , 0 , $thePos);
    }
}

my @dirLevel = split ("/", $directoryPath);

if(scalar(@dirLevel)<=3){
    print "no\n";
    exit 0;
}

my $issxfsMp = $cifsCommon->isSXFS_MP($directoryPath, $groupNumber);

#sxfsfw
if( $issxfsMp == 0) {
   $directoryPath = $cifsCommon->compactPath4Win($directoryPath);
}
    my $tmpDir = $cifsCommon->getMP($groupNumber, $directoryPath);
    $tmpDir = $tmpDir."/"."/";
    $directoryPath = $directoryPath."/"."/";
    my ($parentFsType, $parentAccess , $errCode) = $volumeCommon->getTypeAccessOfParent($tmpDir);
    if(defined($errCode)){
        print "no\n";
        exit 0;
    }
    if($parentAccess eq "ro"){
        print "no\n";
        exit 0;
    }

if($directoryPath =~ /\/\.snap\/|\/\.psid_lt\/|\/\.sync\/|\/\.datasetinfo\/|\/\.quotainfo\/|\/\.quotainfo\.dir\/|\/\.eainfo-.*\//i){
    print "no\n";
    exit 0;
}

if ($directoryPath =~ /\/lost\+found(0|[1-9]\d{0,4})\//i) {
    my $number = scalar($1);
    if (($number >= 0) && ($number <= 65535)){
    	print "no\n";
        exit 0;
    }
}
print "yes\n";
exit 0;