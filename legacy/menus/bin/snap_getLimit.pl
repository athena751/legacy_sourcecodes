#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_getLimit.pl,v 1.2300 2003/11/24 00:54:37 nsadmin Exp $"


use strict;
use NS::CodeConvert;
#check number of the argument,if it isn't 1,exit
if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
#get the parameter and change its coding
my $cc    = new NS::CodeConvert();
my $mp    = $cc->hex2str(shift);
#run the command
my @result    = `/usr/sbin/sxfs_fileset $mp`;
if($?){
    print STDERR "Failed to execute \"/usr/sbin/sxfs_fileset $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if((split(/\s+/, $result[0]))[1] !~ /\bSNAPSHOT\b/)
{
    `/usr/sbin/sxfs_snapshot -s $mp`;
    if($?){
        print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -s $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
if(system("/usr/sbin/sxfs_snapshot -P $mp")!=0){
    print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -P $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
exit(0);

## -------------------END--------------------##
