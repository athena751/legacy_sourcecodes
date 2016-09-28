#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_checkNetbios.pl,v 1.2301 2004/03/05 00:41:25 liuyq Exp $"

# function: 
#       check whether the specified netbios name 
#       has been used.
# Parameter: 
#       $etcPath: /etc/group[0|1]/
#       $global : "DEFAULT"
#       $netbios : netBios name.
# return value: 
#       0: successfully exit;
#       1: parameters error or command excuting error occured;
# output value: 
#       "notexist": specified netbios name has not been used.
#       "exist": specified netbios name has been used.


use strict;
use NS::CIFSCommon;

my $paraNum = scalar(@ARGV);
if($paraNum != 3 ){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $etcPath = shift;
my $global = shift;
my $netbios = shift;

my $cifsCommon = new NS::CIFSCommon;
my $vsFile = $cifsCommon->getSmbOrVsName($etcPath,$global,0);

if (-f $vsFile){
    my @vscontent = `cat $vsFile`;
    foreach (@vscontent) {
        if ($_ =~ /^\s*\/export\/\w+\s+[\w\.-]+\s+$netbios\s*(#.*)?$/){
            print STDOUT "exist\n";
            exit 0;
        }
    }
}
print STDOUT "notexist\n";
exit 0;