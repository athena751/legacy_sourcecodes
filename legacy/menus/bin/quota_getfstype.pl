#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_getfstype.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::CodeConvert;

#process command line
if (scalar(@ARGV)!=1)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $path= shift;
my $count;
my @mountInfo;
my @line;
my $cc    = new NS::CodeConvert();

$path= $cc->hex2str($path);
if (!$path) 
{
    print STDERR "Error occurred when decoding mount point in perl script(quota_getfstype.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}

@mountInfo=`sudo mount`;
if (!@mountInfo ||scalar(@mountInfo)==0)
{
    print STDERR "Error occurred when executing system command \"mount\" in perl script(quota_getfstype.pl). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

for ($count=0;$count<scalar(@mountInfo);$count++)
{
    @line=split(/\s+/,$mountInfo[$count]);
    if ($line[2] eq $path)
    {
        if ($line[4] eq "syncfs")
        {
            #my $endPosition=index($line[5],",");
            #if ($endPosition==-1) # no ","
            #{
            #    $endPosition=index($line[5],")");
            #}
            #print substr($line[5],1,$endPosition-1);
            my $tmp = substr $line[5],1,length($line[5])-2;
            my @tmp = split /,/,$tmp;
            foreach(@tmp)
            {
                if($_=~/cache_type\s*=(\S+)/)
                {
                    print $1;
                    last;
                }    
            }
        }
        else
        {
            print $line[4];
        }
        print "\n";
        exit 0;
    }
}
print STDERR "Cannot find any file system on the specified mount point. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
exit 1;