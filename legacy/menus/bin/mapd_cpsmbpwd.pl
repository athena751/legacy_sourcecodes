#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_cpsmbpwd.pl,v 1.2302 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::SystemFileCVS;
my $common      = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

if(scalar(@ARGV) != 7){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my ($ludb_root, $global, $ntdomain, $netbios, $ludb_name, $etcpath, $writeLudbinfo) = @ARGV;

my $dir       = "$ludb_root/.nas_cifs/$global/$ntdomain";
my $src_file  = "../../../.ludb/$ludb_name/smbpasswd";
my $link_file = "$ludb_root/.nas_cifs/$global/$ntdomain/smbpasswd.$netbios";
my $info_file = "${etcpath}ludb.info";
my $add_line  = "$ludb_name $link_file\n";

#if (-e $link_file) {
#    exit 0;
#}
# based on mail nas11877 , before creating the symbol link , delete it.

system("rm -rf $link_file");
system("sudo mkdir -p $dir");
if (system("sudo ln -s $src_file $link_file")!=0) {
    exit 1;
}
if ($writeLudbinfo ne "true"){
    exit 0;
}

if(!open(IN_FILE,"$info_file")){
    print STDERR "$info_file can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @content=<IN_FILE>;
close(IN_FILE);

if(!open(OUTPUT,"| ${cmd_syncwrite_o} $info_file")) {
    print STDERR "$info_file can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $w_flag = "true";
foreach(@content){
    if($_ =~/^\s*\Q$add_line\E\s*$/){
        $w_flag = "false";
    }
    print OUTPUT $_;
}

if ($w_flag eq "true") {
    print OUTPUT $add_line;
}

if(!close(OUTPUT)){
    print STDERR " Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};
exit 0;
