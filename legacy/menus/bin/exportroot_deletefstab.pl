#!/usr/bin/perl -w

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportroot_deletefstab.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

use strict;
use NS::SystemFileCVS;
if(scalar(@ARGV)!=2){
    print STDERR " ",__FILE__,"  parameter error!\n";
    exit(1);
}
my $filePath=shift;
my $exportRoot=shift;
my $filename=$filePath."cfstab";
my $common = new NS::SystemFileCVS;
if($common->checkout($filename)!=0)
{
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
if(!open(INPUT,"$filename"))
{
    $common->rollback($filename);
    print STDERR "$filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my @content=<INPUT>;
close(INPUT);

if(!open(OUTPUT,">$filename"))
{
    $common->rollback($filename);
    print STDERR "$filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
foreach(@content){
    if(/^\s*#.*/){
        print OUTPUT $_;
    }elsif($_=~m"$exportRoot"){
        my @list=split(/\s+/,$_);
        if(scalar(@list)>1){
            if($list[1]!~m"^${exportRoot}/"){
                print OUTPUT $_;
            }
        }
        else
        {
            print OUTPUT $_;
        }
    }else{
        print OUTPUT $_;
    }
}
close(OUTPUT);
$common->checkin($filename);
exit(0);