#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_setServerInfo.pl,v 1.2302 2007/02/12 05:12:29 cuihw Exp $"

use strict;
#use NS::HTTPCommon;
use NS::SystemFileCVS;
my $common=new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_c = $common->COMMAND_NSGUI_SYNCWRITE_C;

my $middlefile;
my @content;
my $http;
my $in = 0;
my $virtualHost="";
my $pattern = "";
my $newPattern = "";
my $done = 0;
my $serverType;
my @info;
my $newVirtualHost;
my @arr;
my @output="";
my $action = "MODIFY";
my $file = "";
my $node;

while(<STDIN>){
   chop;
   push(@ARGV,$_);
}

if(scalar(@ARGV) < 4)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
{
    my $tmp_main0 = "/tmp/main0.conf";
    my $tmp_main1 = "/tmp/main1.conf";
    my $tmp_virtual0 = "/tmp/virtual0.conf";
    my $tmp_virtual1 = "/tmp/virtual1.conf";
    my $tmp_main0_bak = "/tmp/main0.conf.bak";
    my $tmp_main1_bak = "/tmp/main1.conf.bak";
    my $tmp_virtual0_bak = "/tmp/virtual0.conf.bak";
    my $tmp_virtual1_bak = "/tmp/virtual1.conf.bak";

    if( -f $tmp_main0_bak ){
        `${cmd_syncwrite_c} $tmp_main0_bak $tmp_main0 >& /dev/null`;
    }

    if( -f $tmp_main1_bak ){
        `${cmd_syncwrite_c} $tmp_main1_bak $tmp_main1 >& /dev/null`;
    }

    if( -f $tmp_virtual0_bak ){
        `${cmd_syncwrite_c} $tmp_virtual0_bak $tmp_virtual0 >& /dev/null`;
    }

    if( -f $tmp_virtual1_bak ){
        `${cmd_syncwrite_c} $tmp_virtual1_bak $tmp_virtual1 >& /dev/null`;
    }
}

$node = shift;
$file = shift;
$serverType = shift;
$pattern = $serverType;

if ($serverType eq "BasicConfig") {
    $middlefile = '/tmp/httpd.conf';
    #$middlefile = '/etc/group'.$file.'.setupinfo/httpd/interim/httpd.conf';
}
if ($serverType eq "VirtualHostConfig") {
    $middlefile = '/tmp/virtual'.$file.'.conf';
    #$middlefile = '/etc/group'.$node.'.setupinfo/httpd/interim/virtual'.$file.'.conf';
    $virtualHost = shift;
    if (scalar(@ARGV) == 0) {
        $action = "DELETE";
    } else {
        $newVirtualHost = shift;
        $newPattern = "$serverType\\s+$newVirtualHost";
        $action = "MODIFY";
        if ($virtualHost eq "") {
            $action = "ADD";
            $virtualHost = $newVirtualHost;
        }
    }
    $pattern .= "\\s+$virtualHost";
} elsif ($serverType eq "MainServerConfig") {
    #$middlefile = '/etc/group'.$node.'.setupinfo/httpd/interim/main'.$file.'.conf';
    $middlefile = '/tmp/main'.$file.'.conf';
    if ($node ne $file) {
        $serverType = "VirtualHostConfig";
        $action = "MODIFY";
        $virtualHost = shift;
        $newVirtualHost = shift;
        $newPattern = "$serverType\\s+$newVirtualHost";
        $pattern = "$serverType\\s+$virtualHost";
    }
}
@info = @ARGV;


if (!open(INPUT,"$middlefile")) {
    @content=();
}else {
    @content = <INPUT>;
    close(INPUT);
}

if (!open(OUTPUT,"| ${cmd_syncwrite_o} $middlefile")) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

foreach(@content){
    if ($serverType eq "VirtualHostConfig" && $action eq "MODIFY" && $done == 1 && (/^\s*<$newPattern>\s*$/)) {
        print OUTPUT @content;
        print $in;
        if(!close(OUTPUT)){
	
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	};
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 2;
    }
    if (/^\s*<$pattern>\s*$/) {
        if ($in == 0) {
            $in = 1;
        }
        if ($action ne "DELETE") {
            $done = 1;
            push(@output, "<$serverType");
            if ($serverType eq "VirtualHostConfig") {
                push(@output, " $newVirtualHost");
            }
            push(@output, ">\n");
            foreach(@info) {
                push(@output, "$_\n");
            }
        }
    }
    if (/^\s*<Directory\s+/) {
        if ($in == 1) {
            $in = 2;
        }
    }
    if ($in == 0) {
        push(@output, $_);
    } elsif ($in >1 && $action ne "DELETE") {
        push(@output, $_);
    }

#    if ($serverType eq "VirtualHostConfig" && /^\s*<\/VirtualHost>\s*$/) {
#        if ($in == 1 && $action ne "DELETE") {
#            push(@output, "</VirtualHost>\n");
#        }
#        if ($in == 1) {
#            $in = 0;
#        }
#    }

#   if ($serverType ne "VirtualHostConfig" && /^\s*<\/$serverType>\s*$/) {
    if (/^\s*<\/$serverType>\s*$/) {
        if ($in == 1 && $serverType eq "VirtualHostConfig" && $action ne "DELETE") {
            push(@output, "</VirtualHost>\n");
            push(@output, "</VirtualHostConfig>\n");
        } elsif ($in == 1 && $action ne "DELETE") {
            push(@output, "</$serverType>\n");
        }
        if ($in == 1) {
            $in = 0;
        }
    }

    if (/^\s*<\/Directory>\s*$/) {
        if ($in == 2) {
            $in = 1;
        }
    }

    if ($serverType eq "VirtualHostConfig" && $action eq "ADD" && (/^\s*<$newPattern>\s*$/)) {
#    if (($action ne "DELETE" )&& $in != 1
#           && $serverType eq "VirtualHostConfig" && (/^\s*<$newPattern>\s*$/)) {
        print OUTPUT @content;
        close(OUTPUT);
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 2;
    }
    if ($serverType eq "VirtualHostConfig" && $action eq "MODIFY" && $done == 0 && (/^\s*<$newPattern>\s*$/)) {
        print OUTPUT @content;
        close(OUTPUT);
        print STDERR "newPattern = ${newPattern};Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 2;
    }
}

if ($action ne "DELETE" && $done == 0) {
    push(@output, "<$serverType");
    if ($serverType eq "VirtualHostConfig") {
        push(@output, " $newVirtualHost");
    }
    push(@output, ">\n");
    foreach(@info) {
        push(@output, "$_\n");
    }
    if ($serverType eq "VirtualHostConfig") {
        push(@output, "</VirtualHost>\n");
    }
    push(@output, "</$serverType>\n");
}
print OUTPUT @output,;
if(!close(OUTPUT)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	exit 1;
};


exit 0;
