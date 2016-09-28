#!/usr/bin/perl -w

#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportroot_del_expgrps.pl,v 1.2301 2005/08/23 08:06:58 liq Exp $"

use strict;
use NS::SystemFileCVS;
if(scalar(@ARGV)!=2){
    print STDERR " ",__FILE__,"  parameter error!\n";
    exit(1);
}
my $fileName = shift;
my $exportRoot = shift;
my $common = new NS::SystemFileCVS;
if(system("rm -rf $exportRoot") != 0){
    print STDERR "Failed to rm -rf $exportRoot. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1; 
}
my @content;
if(open(INPUT,"$fileName")){
    @content = <INPUT>;
    close(INPUT);
}

if($common->checkout($fileName)!=0){
    print STDERR "Failed to checkout \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
if(!open(OUTPUT,">$fileName"))
{
    $common->rollback($fileName);
    print STDERR "$fileName can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my $expPattern = $exportRoot;
$expPattern =~ s/\//\\\//;
foreach(@content){
    if(/^\s*$expPattern\s+/){
        #match the export group, and delete this line
    }else{
        print OUTPUT $_;
    }
}
close(OUTPUT);
$common->checkin($fileName);

# for deleting local user database;
my $cmd = "/usr/bin/ludb_admin root";
my @ludbcontent = `$cmd`;
if($?){
    print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
$exportRoot = substr($exportRoot,rindex($exportRoot,"/")+1);
chomp($ludbcontent[0]);
my $ludb_path = $ludbcontent[0]."/.expgrp/".$exportRoot;

if(system("rm -rf $ludb_path") != 0){
    print STDERR "Failed to rm -rf $ludb_path. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 20; 
}

exit(0);