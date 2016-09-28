#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: dirquota_deldataset.pl,v 1.2301 2006/02/20 00:34:41 zhangjun Exp $"

use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########

#check the number of argument , if it isn't  1 , exit
my $args=scalar(@ARGV);

if ($args!=1 )
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1); 
} 

#get all the parameters , and change hexDataset's coding
my $cc = new NS::CodeConvert();

my $hexDataset = shift;

#$hexDataset = $cc->hex2str($hexDataset);

if (!$hexDataset){
    print STDERR "Failed to execute   \"$hexDataset\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit (1);    
}

#run the command

########add by zhangjun:get encoding
$hexDataset =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$hexDataset = $cc->changeUTF8Encoding($hexDataset, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($hexDataset) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

my @result = `/usr/sbin/sxfs_dataset -r \Q$hexDataset\E`;

if ($? != 0){
    print STDERR "Failed to execute   \"$hexDataset\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit (1);
}

exit 0;
