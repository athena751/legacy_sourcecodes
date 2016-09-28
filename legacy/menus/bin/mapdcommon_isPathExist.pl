#!/usr/bin/perl

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapdcommon_isPathExist.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::CodeConvert;

if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $cc=new NS::CodeConvert();
my $filename="/etc/mtab";
if($ARGV[0] eq "-e"){
    my $exportRoot=$ARGV[1];
    #$exportRoot=$cc->hex2str($exportRoot);
    if(!$exportRoot){
        print STDERR "the second parameter should be hex string. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    if(!open(INPUT,"$filename"))
    {
        print STDERR "Open the file \"$filename\" failed:$!. Exit in perl script:",__FILE__," line:",__LINE__+1,"\n";
        exit(1);
    }
    while(<INPUT>){
        if(/^\s*#.*/){
            next;
        }elsif($_=~m"\s${exportRoot}/"){
            print "true\n";
            close(INPUT);
            exit(0);
        }
    }
    close(INPUT);    
}elsif($ARGV[0] eq "-p"){
    my $path=$ARGV[1];
    $path=$cc->hex2str($path);
    if(!$path){
        print STDERR "the second parameter should be hex string. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    if(!open(INPUT,"$filename"))
    {
        print STDERR "Open the file \"$filename\" failed:$!. Exit in perl script:",__FILE__," line:",__LINE__+1,"\n";
        exit(1);
    }
    while(<INPUT>){
        if(/^\s*#.*/){
            next;
        }elsif($_=~m"\s${path}\s"){
            print "true\n";
            close(INPUT);
            exit(0);
        }
    }
    close(INPUT);
}else{
    print STDERR "first parameter error! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
print "false";
exit(0);