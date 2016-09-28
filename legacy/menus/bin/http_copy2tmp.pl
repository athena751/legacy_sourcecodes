#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_copy2tmp.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::SystemFileCVS;
my $common=new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_c = $common->COMMAND_NSGUI_SYNCWRITE_C;

my $node;
my $file;
my $tmp_httpd;
my $tmp_virtual0;
my $tmp_main0;
my $tmp_virtual1;
my $tmp_main1;
my $etc_httpd;
my $etc_virtual0;
my $etc_main0;
my $etc_virtual1;
my $etc_main1;
my @content;
my $status;

if (scalar(@ARGV) != 2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

$node = shift;
$file = shift;

$tmp_httpd = "/tmp/httpd.conf";
$tmp_main0 = "/tmp/main0.conf";
$tmp_main1 = "/tmp/main1.conf";
$tmp_virtual0 = "/tmp/virtual0.conf";
$tmp_virtual1 = "/tmp/virtual1.conf";
$etc_httpd = "/etc/group".$node.".setupinfo/httpd/interim/httpd.conf";
$etc_main0 = "/etc/group".$node.".setupinfo/httpd/interim/main0.conf";
$etc_main1 = "/etc/group".$node.".setupinfo/httpd/interim/main1.conf";
$etc_virtual0 = "/etc/group".$node.".setupinfo/httpd/interim/virtual0.conf";
$etc_virtual1 = "/etc/group".$node.".setupinfo/httpd/interim/virtual1.conf";


#add 2003-10-21, to remove bak file of conf files
`/bin/rm /tmp/main{0,1}.conf.bak  -f`;
`/bin/rm /tmp/virtual{0,1}.conf.bak  -f`;
#add end


#$status = `/usr/sbin/nec_httpd_config status`;
#if ($? == 0 && $status == 0) {
#    $status = "http yes";
#} else {
#    $status = "http no";
#}
if (!(-e $etc_httpd)) {
    if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmp_httpd")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    @content = ("<BasicConfig>\n", "Listen 80\n", "http no\n", "</BasicConfig>\n");
    print OUTPUT @content;
	if(!close(OUTPUT)){
		print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";		
		exit 1;
	}

} else {
    if (!open(INPUT,"$etc_httpd")) {
        @content = ("<BasicConfig>\n", "Listen 80\n", "http no\n", "</BasicConfig>\n");
    } else {
        @content = <INPUT>;
        close(INPUT);
    }
    if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmp_httpd")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    print OUTPUT @content;
    #foreach(@content){
        #if (!(/^http\s+\S+$/)) {
        #    print OUTPUT $_;
        #}
        #if (/^<BasicConfig>/) {
        #    print OUTPUT "$status\n";
        #}
    #}
	if(!close(OUTPUT)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";		
			exit 1;
	}

}

if (!(-e $etc_main0)) {
    if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmp_main0")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
	if(!close(OUTPUT)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";		
			exit 1;
	}
} else {
    if (system("${cmd_syncwrite_c} $etc_main0 $tmp_main0")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

if (!(-e $etc_main1)) {
    if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmp_main1")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
	if(!close(OUTPUT)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";		
			exit 1;
	}

} else {
    if (system("${cmd_syncwrite_c} $etc_main1 $tmp_main1")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

if (!(-e $etc_virtual0)) {
    if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmp_virtual0")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
	if(!close(OUTPUT)){
		print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";		
		exit 1;
	}

} else {
    if (system("${cmd_syncwrite_c} $etc_virtual0 $tmp_virtual0")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

if (!(-e $etc_virtual1)) {
    if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmp_virtual1")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
	if(!close(OUTPUT)){
		print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";		
		exit 1;
	}

    
} else {
    if (system("${cmd_syncwrite_c} $etc_virtual1 $tmp_virtual1")) {
	print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	exit 1;
    }
}

exit 0;
