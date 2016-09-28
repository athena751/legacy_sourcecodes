#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_setLimit.pl,v 1.2302 2007/05/30 10:30:57 liy Exp $"


use strict;
use NS::CodeConvert;
#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=2) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
#define some variable and change the coding of mountpoint
my $cc    = new NS::CodeConvert();
my $limit    = shift;
my $mp    = shift;
$mp        = $cc->hex2str($mp);
#run the command
my @result    = `/usr/sbin/sxfs_fileset $mp`;
if($?){
    print STDERR "Failed to execute \"/usr/sbin/sxfs_fileset $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if((split(/\s+/, $result[0]))[1] !~ /\bSNAPSHOT\b/)
{
    my $returnCode = system("/usr/sbin/sxfs_snapshot -s $mp") >> 8;
    if($returnCode!=0){
        print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -s $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit $returnCode ;
    }
}
#execute the command and check the result
my $returnCode = system("/usr/sbin/sxfs_snapshot -p $limit $mp") >> 8;
if($returnCode != 0){
    print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -p $limit $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
}
exit($returnCode);

## -------------------END--------------------##
