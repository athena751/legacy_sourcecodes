#!/usr/bin/perl
#       copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nsgui_setvalue.pl,v 1.1 2005/10/19 00:16:13 fengmh Exp $"

# function:
#       Set the value of the property.
# Parameters:
#       filePath
#       property
#       value
# output:
#       none
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::SystemFileCVS;
if(scalar(@ARGV)!=3){
    print STDERR " ",__FILE__,"  parameter error!\n";
    exit(1);
}
my $filePath=shift;
my $property=shift;
my $value=shift;

my $common = new NS::SystemFileCVS;

if($common->checkout($filePath)!=0)
{
    print STDERR "Failed to checkout \"$filePath\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit (1);
}
my @content;
if(-f $filePath){
    @content = `cat $filePath`;
}else{
    $common->rollback($filePath);
    print STDERR "Open $filePath failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

my $line;
my $new;
my $flag=0;
my @tmpcontent;
if(!open(OUTPUT,">$filePath")) {
    $common->rollback($filePath);
    print STDERR "Write $filePath failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

foreach $line(@content) {
    if($line=~/^\s*\Q$property\E\s*=\s*(.*)\s*$/) {
        $line=$property."=".$value."\n";
        $flag=1;
        push(@tmpcontent,$line);
    }else{
        push(@tmpcontent,$line);
    }
}
if($flag==0){
    $new=$property."=".$value."\n";
    @tmpcontent=@content;
    push(@tmpcontent,$new);
}
print OUTPUT @tmpcontent;

if(!close(OUTPUT)){
    $common->rollback($filePath);
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if($common->checkin($filePath)!=0){
    $common->rollback($filePath);
    print STDERR "Failed to checkin \"$filePath\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
exit(0);
