#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_setquota.pl,v 1.2301 2006/02/20 00:34:41 zhangjun Exp $"

use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########

#check the number of argument , if it isn't  8 , exit
if (scalar(@ARGV)!=8)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1); 
} 

#get all the parameters , and change filesystem's coding
my $cc = new NS::CodeConvert();

my $command1 = shift;
my $command2 = shift;
my $idnumber = shift;
my $blocksoft = shift;
my $blockhard = shift;
my $filesoft = shift;
my $filehard = shift;
my $filesystem = shift;
if ($filesystem=~/^0x/){
    $filesystem = $cc->hex2str($filesystem);
}

########add by zhangjun
$filesystem =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$filesystem = $cc->changeUTF8Encoding($filesystem, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($filesystem) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

#run the command
if (system("$command1 $command2 $idnumber $blocksoft $blockhard $filesoft $filehard \Q$filesystem\E")!=0)
{
    print STDERR "Failed to execute \"$command1 $command2 $idnumber $blocksoft $blockhard $filesoft $filehard $filesystem\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
exit(0);