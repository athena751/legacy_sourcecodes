#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_getidbyname.pl,v 1.2301 2006/02/20 00:34:41 zhangjun Exp $"

use strict;
use NS::CodeConvert;
########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########
#process command line
if (scalar(@ARGV)!=4)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $switch=shift;
my $name=shift;
my $path=shift;
my $type=shift;

# if name='abc abc   bbb', convert it to 'abc" "abc"   "bbb';

my $cc    = new NS::CodeConvert();
$path= $cc->hex2str($path);

########add by zhangjun
$path =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$path = $cc->changeUTF8Encoding($path, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($path) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

if (!$path)
{
    print STDERR "Error occurred when decoding mount point in perl script(quota_getidbyname.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

$name =~s/\"/\\\"/g;
$name =~s/\`/\\\`/g;
$name =~s/\$/\\\$/g;

my $getIdCmd="echo \"set dir=".$path.";set id=n-".$name.";mapto ";
if ($type eq "sxfs") #Unix File System
{
    if ($switch eq "-u")
    {
        $getIdCmd=$getIdCmd."uid\" |sudo /sbin/ims_ctl";
    }
    elsif ($switch eq "-g")
    {
        $getIdCmd=$getIdCmd."gid\" |sudo /sbin/ims_ctl";
    }
    else
    {
        print STDERR "Command line error in perl script(quota_getidbyname.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }

}
elsif ($type eq "sxfsfw") #NTFS
{
    if ($switch eq "-u")
    {
        $getIdCmd=$getIdCmd."upsid\" |sudo /sbin/ims_ctl";
    }
    elsif ($switch eq "-g")
    {
        $getIdCmd=$getIdCmd."gpsid\" |sudo /sbin/ims_ctl";
    }
    else
    {
        print STDERR "Command line error in perl script(quota_getidbyname.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
else
{
    print STDERR "The specified file system is neither UXFS nor NTFS in perl script(quota_getidbyname.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $id=`$getIdCmd`;
if (!$id)
{
    print STDERR "Cannot get id. in perl script(quota_getidbyname.pl) Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print $id;
exit 0;