#!/usr/bin/perl -w
use strict;
use NS::SystemFileCVS;
#use NS::Common;
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_add.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"

#check number of the argument,if it isn't 3,exit
#scalar(@ARGV)==3 or exit 1;
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my $filename=shift;
my $domain=shift;
my $server=shift;
my $line="domain ".$domain." server ".$server."\n";
my $flag=0;
my @content;
#my $common = new NS::Common;
my $common      = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
#$common->checkout($filename)==0 or exit 1;
#if($common->checkout($filename)!=0)
#{
#    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
#    exit 1;
#}
if (!open(INPUT,$filename)) {
#    $common->rollback($filename);
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
@content = <INPUT>;
close(INPUT);

if (!open(OUTPUT,"| ${cmd_syncwrite_o} $filename")) {
#    $common->rollback($filename);
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

foreach(@content){
    if(/^\s*#.*/){
        print OUTPUT $_;
    }elsif(/$line/){
        print OUTPUT $_;
        $flag=1;
    }else{
        print OUTPUT $_;
    }
}
if($flag==0)
{
    print OUTPUT $line;
}

if(!close(OUTPUT)){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
;
#$common->checkin($filename);
exit 0;
