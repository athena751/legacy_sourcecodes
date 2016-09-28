#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_deleteSchedule.pl,v 1.2306 2008/07/01 07:21:41 liy Exp $"


use strict;
use NS::CodeConvert;
use NS::SystemFileCVS;
use NS::NsguiCommon;
#check number of the argument,if it isn't 4,exit
if(scalar(@ARGV)!=4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $cc=new NS::CodeConvert();
my $cvs    = new NS::SystemFileCVS();
my $nsgui_common = new NS::NsguiCommon;
my $filename=shift;
my $mp=shift;
$mp=$cc->hex2str($mp);

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

#add by maojb ,xinghui, 2003/07/14
my $devname = shift;

#end 2003/07/14

my $sch=shift;

my @content;
if(!open(INPUT,"$filename"))
{
    print STDERR "The $filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
@content=<INPUT>;
close(INPUT);
if(!open(OUTPUT,"| ${cmd_syncwrite_o} $filename"))
{
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
foreach(@content){
    if(/^\s*#.*/){
        print OUTPUT $_;
#    }elsif($_!~"${mountPoint}" && $_!~"${devname}"){
#        print OUTPUT $_;
#    }elsif($_!~"${schedule}"){
#        print OUTPUT $_;
# 	2003/07/14, changed by maojb, xinghui
	}elsif($_=~/\s+(\Q${mp}\E|${devname})\s+\Q${sch}\E\s+/){
		
	}else{
		print OUTPUT $_;
    }
}
if(!close(OUTPUT)) {
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

$nsgui_common->reloadCron("snapshot", $filename);

exit(0);

##------------------------END----------------------##