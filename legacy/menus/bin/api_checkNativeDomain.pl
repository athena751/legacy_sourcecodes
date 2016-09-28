#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

use strict;
use NS::APICommon;

#    Definition: Network or NTDomain has set the native domain 
#    Parameter:
#            groupPath         ----- the group path of files   
#            NetworkOrNTDomain ----- network or ntdomain
#            Kind              ----- "win" | "unix"            
#
#    Return value: 
#           If has , print true;
#           else , print false;


#1.check number of the argument
if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

#get the parameters:
my $grpPath             = shift;
my $networkOrNT         = shift;
my $kind                = shift;
my $apiPm               = new NS::APICommon();
my $nativeList          = $apiPm->getImsNativeResult($grpPath);

#get the native list 
if(!defined($nativeList)){      #when function run error.
    print STDERR $apiPm->error()," Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

#check in unix native list
my $unixNativeRef       = $$nativeList{$kind};
my $region              = $$unixNativeRef{$networkOrNT};

#if doesn't find the region, check in windows native list
#if(!defined($region)){
#   my $winNativeRef    = $$nativeList{"win"};
#    $region             = $$winNativeRef{$networkOrNT};
#} del by hetao@2004-01-09

#print the result
if(!defined($region)){
    print "false\n";
}else{
    print "true\n";
}

exit 0;