#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: dirquota_allow.pl,v 1.2306 2007/06/01 00:57:24 liul Exp $"

use strict;
use NS::CodeConvert;

my $len = @ARGV;
if($len != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";    
    exit 1; 
}

my $path = shift;
my $cc=new NS::CodeConvert();
$path=$cc->hex2str($path);

if (!$path){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my @info=`/usr/sbin/sxfs_dataset -a \Q$path\E`;
my $return=$?;


if($return==0){
    if( (scalar(@info)-1)>=4095 ){
        print "false\n";
    }else{
        print "true\n";
    }
}else{
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";  
    exit 1;  
}

exit 0;     
