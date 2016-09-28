#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_setDirectoryInfo.pl,v 1.2302 2007/02/12 05:13:12 cuihw Exp $"

use strict;
use NS::SystemFileCVS;
my $common=new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

my $middlefile;
my @content;
my $in = 0;
my $virtualHost="";
my $node;
my $file;
my $serverType;
my $olddirectory;
my $newdirectory;
my $action;
my $directory;
my @info;
my $done =0;
my @output;

while(<STDIN>){
   chop;
   push(@ARGV,$_);
}

if(scalar(@ARGV) < 5)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

$node = shift;
$file = shift;
#$middlefile = 'http.conf';
$serverType = shift;
if ($serverType eq "MainServerConfig") {
#	$middlefile = '/etc/group'.$node.'.setupinfo/httpd/interim/main'.$file.'.conf';
	$middlefile = '/tmp/main'.$file.'.conf';

    if ($node ne $file && $serverType eq "MainServerConfig") {
       $virtualHost = shift;
       $serverType = "VirtualHostConfig";
       $virtualHost = "$serverType\\s+$virtualHost";
    }else{
       $virtualHost = $serverType;
    }
} else {
    $virtualHost = shift;
#	$middlefile = '/etc/group'.$node.'.setupinfo/httpd/interim/virtual'.$file.'.conf';
	$middlefile = '/tmp/virtual'.$file.'.conf';
    $virtualHost = "$serverType\\s+$virtualHost";
}
$action = shift;
$olddirectory = shift;
$newdirectory = shift;

@info = @ARGV;

if (!open(INPUT,"$middlefile")) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
@content = <INPUT>;
close(INPUT);
if (!open(OUTPUT, "| ${cmd_syncwrite_o} $middlefile")) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}


foreach(@content){
    if (/^\s*<$virtualHost>\s*$/) {
        if ($in == 0) {
            $in = 1;
        }
    }
#    if (/^\s*<Directory\s+$olddirectory>\s*$/) {
    if (/^\s*<Directory\s+(\S.*)>\s*$/) {
        my $dir = $1;
        if(($olddirectory eq $dir) or ($olddirectory eq "\"".$dir."\"")){
            if ($in == 1) {
                    $in = 2;
            
                if ($action ne "DELETE") {
                    $done = 1;
                    push(@output, "<Directory $newdirectory>\n");
                    foreach(@info) {
                        push(@output, "$_\n");
                    }
                    push(@output, "</Directory>\n");
                }
            }
        }
    }

    if ($serverType eq "VirtualHostConfig" && /^\s*<\/VirtualHost>\s*$/) {
        if (($in == 1) && ($done == 0) && ($action ne "DELETE")) {
            push(@output, "<Directory $newdirectory>\n");
            foreach(@info) {
                push(@output, "$_\n");
            }
            push(@output, "</Directory>\n");
            $done = 1;
        }
        #if ($in == 1) {
        #    push(@output, "</$serverType>\n");
        #}
        if ($in == 1) {
            $in = 0;
        }
    }
    if ($serverType eq "MainServerConfig" && /^\s*<\/$serverType>\s*$/) {
        if (($in == 1) && ($done == 0) && ($action ne "DELETE")) {
            push(@output, "<Directory $newdirectory>\n");
            foreach(@info) {
                push(@output, "$_\n");
            }
            push(@output, "</Directory>\n");
            $done = 1;
        }
        #if ($in == 1) {
        #    push(@output, "</$serverType>\n");
        #}
        if ($in == 1) {
            $in = 0;
        }
    }
    if ($in < 2){# && $_ !~ /^<\/$serverType>$/) {
        push(@output, "$_");
#    } elsif ($in >1 && $action ne "DELETE") {
#        push(@output, $_);
    }
    if (/^\s*<\/Directory>\s*$/) {
        if ($in == 2) {
            $in = 1;
        }
    }
    if (($in == 1) && ($action eq "ADD" )
            && (/^\s*<Directory\s+$newdirectory>\s*$/)) {
        print OUTPUT @content;
        if(!close(OUTPUT)){
		print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	};
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 3;
    }
    if (($in == 1) && ($action eq "MODIFY" && $newdirectory ne $olddirectory)
            && (/^\s*<Directory\s+$newdirectory>\s*$/)) {
        print OUTPUT @content;
        if(!close(OUTPUT)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        };
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 3;
    }
}
#add for zero size of file /tmp/main0.conf or /tmp/main1.conf

if((scalar(@content) == 0) && ($serverType eq "MainServerConfig")){
    push(@output,"<$serverType>\n");
    push(@output, "<Directory $newdirectory>\n");
    foreach(@info){
         push(@output, $_."\n");
    }
    push(@output,"</Directory>\n");
    push(@output,"</$serverType>\n");
}

#add end

print OUTPUT @output;
if(!close(OUTPUT)){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
};
exit 0;
