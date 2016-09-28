#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_modifyCron.pl,v 1.2304 2007/01/16 03:04:57 wangzf Exp $"

use strict;
use NS::CodeConvert;
use NS::SystemFileCVS;
use NS::NsguiCommon;

if(scalar(@ARGV)!=2){  #/2003/07/14 maojb xinghui add , add a parameter $devname
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $path = shift;
my $devname = shift; #2003/07/14 maojb, xinghui add
my $cc = new NS::CodeConvert();
my $cvs = new NS::SystemFileCVS;
my $nsgui_common = new NS::NsguiCommon;
my $cronfile = "/var/spool/cron/snapshot";
my @content = ();
$path = $cc->hex2str($path);
-f $cronfile or exit 0;

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if($cvs->checkout($cronfile)!=0){
    print STDERR "Checkout $cronfile failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if(!open(IN, $cronfile)){
    print STDERR "The $cronfile can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cvs->rollback($cronfile);
    exit(1);
}
@content = <IN>;
close(IN);
if(!open(OUTPUT,"| ${cmd_syncwrite_o} $cronfile"))
{
    print STDERR "The $cronfile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cvs->rollback($cronfile);
    exit(1);
}
foreach(@content){
    if($_=~/^\s*#/){
        print OUTPUT $_;
    }elsif($_=~/\s+\Q${path}\E\// or $_=~/\s+${devname}\/\s+/ or $_=~/\s+(\Q${path}\E|${devname})\s+/){
    	#2003/07/14 maojb, xinghui modified
    }else{
        print OUTPUT $_;
    }
}
if(!close(OUTPUT)) {
    print STDERR "The $cronfile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cvs->rollback($cronfile);
    exit(1);
}

$nsgui_common->reloadCron("snapshot", $cronfile);

if($cvs->checkin($cronfile)!=0){        
    $cvs->rollback($cronfile);            
    print STDERR "check in file \"$cronfile\" failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
    
exit(0);