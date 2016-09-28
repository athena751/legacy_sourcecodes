#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: dirquota_add.pl,v 1.2305 2006/02/20 00:34:41 zhangjun Exp $"

use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########

my $len = @ARGV;
if($len != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $path = shift;
my $filesystem = shift;
my $cc=new NS::CodeConvert();
#$path=$cc->hex2str($path);
$filesystem=$cc->hex2str($filesystem);

########add by zhangjun
$filesystem =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$path = $cc->changeUTF8Encoding($path, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($path) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

if (!$path){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $directory=$path."/";

#check the existence of the export root;
my $exportroot = "/export/".(split(/\//,$filesystem))[2]."/";
if (!-d $exportroot){
    print STDERR "The export root doesn't exist\n";   
    exit 1;
} 

#check the existence of the filesystem;
my @mount = `mount`;
my @result = grep(/\s\Q$filesystem\E\s/,@mount);
if (@result == 0){
    print STDERR  "No such mount point\n";
    exit 1;
} 

#check if the directory is a sub mount point
@mount = `mount |grep \Q$directory\E`;

foreach(@mount){
    if( $path eq (split(/\s+/,$_))[2]){
        print STDERR "This directory can't set dataset.\nExit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }    
}

my @return=`/usr/sbin/sxfs_dataset -s \Q$path\E`;

if($?!=0){
    print STDERR @return;
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

exit 0;
