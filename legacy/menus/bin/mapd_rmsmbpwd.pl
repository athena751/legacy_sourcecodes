#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_rmsmbpwd.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::SystemFileCVS;
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if(scalar(@ARGV) != 6){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my ($ludb_root, $global, $ntdomain, $netbios, $ludb_name, $etcpath) = @ARGV;

my $dir       = "$ludb_root/.nas_cifs/$global/$ntdomain";
my $link_file = "$ludb_root/.nas_cifs/$global/$ntdomain/smbpasswd.$netbios";
my $info_file = "${etcpath}ludb.info";

system("sudo rm -rf $link_file");

my $filenum =`ls -1 $dir|wc -l`;
$filenum =~ s/\s//g;
if ($filenum eq "0") {
    system("sudo rm -rf $dir");
}

if(!open(IN_FILE,"$info_file")){
    print STDERR "$info_file can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @content=<IN_FILE>;
close(IN_FILE);

if(!open(OUT_FILE,"| ${cmd_syncwrite_o} $info_file")){
    print STDERR "$info_file can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

foreach(@content){
  if($_ !~/^\s*$ludb_name\s+$link_file\s*$/){
    print OUT_FILE $_;
  }
}
if(!close(OUT_FILE)){
	
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};

exit 0;
