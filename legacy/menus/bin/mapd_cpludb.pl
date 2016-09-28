#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_cpludb.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::SystemFileCVS;
my $common      = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

my $argleng = scalar(@ARGV);
if($argleng != 6){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my ($ludb_root, $expgrp, $fstype, $ludb_name,$writeLudb,$etcpath) = @ARGV;

my $dir       = "$ludb_root/.expgrp/$expgrp/$fstype";
my $src_file  = "../../../.ludb/$ludb_name";
my $link_file = "$ludb_root/.expgrp/$expgrp/$fstype/$ludb_name";
my $info_file = "${etcpath}ludb.info";
my $add_line  = "$ludb_name $dir\n";

if (-e $link_file) {
    exit 0;
}
system("rm -rf $link_file");
if (!(-e $dir)){
    system("mkdir -p $dir");
}
if (system("ln -s $src_file $link_file")!=0) {
    exit 1;
}
if ($writeLudb eq "false"){
    exit 0;
}

if(!open(IN_FILE,"$info_file")){
    system("rm -rf $link_file");
    print STDERR "$info_file can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @content=<IN_FILE>;
close(IN_FILE);

if(!open(OUTPUT,"| ${cmd_syncwrite_o} $info_file")) {
    system("rm -rf $link_file");
    print STDERR "$info_file can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

foreach(@content){
    print OUTPUT $_;
}

print OUTPUT $add_line;
if(!close(OUTPUT)){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
	
};
exit 0;
