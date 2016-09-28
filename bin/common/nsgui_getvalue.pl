#!/usr/bin/perl
#       copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nsgui_getvalue.pl,v 1.1 2005/10/19 00:16:13 fengmh Exp $"

# Function:
#       Get the value of property.
# Parameters:
#       filePath
#       property
# output:
#       value
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
if(scalar(@ARGV)!=2){
    print STDERR " ",__FILE__,"  parameter error!\n";
    exit(1);
}

my $filePath=shift;
my $property=shift;

my @content;
if(-f $filePath){
    @content = `cat $filePath`;
}else{
    print STDERR "Open $filePath failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my $line;
foreach $line(@content){
    if($line=~/^\s*\Q$property\E\s*=\s*(.*)\s*$/) {
        print($1);
        exit(0);
    }
}
print STDERR "Can not find the property.\n";
exit(1);
