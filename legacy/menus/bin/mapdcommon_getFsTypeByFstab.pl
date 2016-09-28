#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: mapdcommon_getFsTypeByFstab.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::CodeConvert;

if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# define and initial some variables
my $filePath=shift;
my $cc        = new NS::CodeConvert();
#my $filename    = "/etc/fstab";
my $filename    = $filePath."cfstab";
my $mountPoint     = $cc->hex2str(shift);
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# Open the file specified by $filename and read it

if(!open(INPUT,"$filename"))
{
    print STDERR "Open the file \"$filename\" failed:$! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my @currLine;
my $flag    = 2;
while(<INPUT>)
{
    @currLine    = split(/\s+/,$_);
    if($currLine[0]    eq undef)
    {
        shift @currLine;    
    }
    if($currLine[1] eq $mountPoint)
    {
        $flag        = 1;
        if($currLine[2] eq "syncfs")
        {
            my @tmp        = split(",",$currLine[3]);
            foreach(@tmp)
            {
                if($_=~/cache_type=/)
                {
                    my $type=substr($_,11,length($_)-1);
                    print "$type\n";
                    last;
                }
            }
        }else
        {
            print "$currLine[2]\n";
        }
        last;        
    }### end if    
}### end while circle
close(INPUT);
if($flag==2)
{
    print STDERR "No matched mountpoint in the file! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 2;
}
exit 0;
