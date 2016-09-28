#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: dirquota_getDataSet.pl,v 1.2306 2007/06/28 01:14:39 liul Exp $"


use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
use NS::RPQLicenseNo;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
my $RPQ_No       = new NS::RPQLicenseNo;
########

#check the number of argument , if it isn't  4 , exit
if (scalar(@ARGV)!=1)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1); 
} 

#get all the parameters , and change filesystem's coding
my $cc = new NS::CodeConvert();

my $filesystem = shift;

$filesystem = $cc->hex2str($filesystem);

########add by zhangjun
$filesystem =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;

my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);
########

#run the command
my @result = `/usr/sbin/sxfs_dataset -a \Q$filesystem\E`;
if ($?)
{
    print STDERR "Failed to execute \"/usr/sbin/sxfs_dataset -a $filesystem\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

my $isProcyonOrLater = $nsguicommon->isProcyonOrLater();
if(!defined($isProcyonOrLater)){
    print STDERR "Failed to get the machine series. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my $RPQ = $nsguicommon->checkRPQLicense($RPQ_No->RPQLICENSENO_UTF8);
if( ((!$isProcyonOrLater) && ($RPQ!=0)) || $encoding ne $cc->ENCODING_UTF8_NEC_JP ){
    print @result;
}else{
    open(ICONV, "| /home/nsadmin/bin/nsgui_iconv.pl -f UTF8-NEC-JP -t UTF-8") or die ("cannot pipe to iconv: $!\n");
    print ICONV @result;
    close(ICONV);
}

exit(0);