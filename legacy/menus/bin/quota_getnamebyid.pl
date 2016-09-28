#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_getnamebyid.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::CodeConvert;

#process command line
if (scalar(@ARGV)!=4)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $switch=shift;
my $id=shift;
my $path=shift;
my $type=shift;

my $cc    = new NS::CodeConvert();
$path= $cc->hex2str($path);
if (!$path) 
{
    print STDERR "Error occurred when decoding mount point. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my $getNameCmd="echo \"set dir=".$path.";set id=";
if ($type eq "sxfs") #Unix File System
{
    if ($switch eq "-u")
    {
        $getNameCmd=$getNameCmd."u-".$id.";mapto name\" |sudo /sbin/ims_ctl";
    }
    elsif ($switch eq "-g")
    {
        $getNameCmd=$getNameCmd."g-".$id.";mapto name\" |sudo /sbin/ims_ctl";
    }
    else
    {
        print STDERR "Command line error in perl script(quota_getnamebyid.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    
}
elsif ($type eq "sxfsfw") #NTFS
{
    $getNameCmd=$getNameCmd."p-".$id.";mapto name\" |sudo /sbin/ims_ctl";
}
else
{
    print STDERR "The specified file system is neither UXFS nor NTFS. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $name=`$getNameCmd`;
if (!$name)
{
    print STDERR "Cannot get name. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
    
print $name;
exit 0;