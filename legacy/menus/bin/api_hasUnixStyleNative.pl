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

#    Definition: Has unix native domain or not. 
#    Parameter:
#            groupPath----- the group path of files   
#  
#    Return value: 
#           If have , print true;
#           else , print false;


#1.check number of the argument
if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

#get the parameters:
my $grpPath             = shift;
my $apiPm               = new NS::APICommon();
my $nativeList          = $apiPm->getImsNativeResult($grpPath);

#get the native list 
if(!defined($nativeList)){      #when function run error.
    print STDERR $apiPm->error()," Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $unixNativeRef       = $$nativeList{"unix"};
my %unixNative          = %$unixNativeRef;

#get the size of unix native list
my $size                = scalar(keys(%unixNative));

#print the result
if($size == 0){
    print "false\n";
}else{
    print "true\n";
}

exit 0;