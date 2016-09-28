#!/usr/bin/perl -w
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: http_getDynamicScript.pl,v 1.2302 2006/01/19 11:49:21 zhangjx Exp $"

use strict;
use NS::SystemFileCVS;
my $common=new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

my $type;
my $virtualHostName;
my $directory = "";
my $tmpFile = "/tmp/http_param_$$";
my $node;
my $middleFile;
my $in = 0;
my $pattern;
my $option;
my @content;
my @output = ();
my @script;

if(scalar(@ARGV) < 3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}

$node = shift;
$type = shift;
$option = shift;

if ($type eq "MainServerConfig") {
    if (scalar(@ARGV) >= 1) {
        $directory = shift;
    }
#    $middleFile = '/etc/group'.$node.'.setupinfo/httpd/interim/main'.$node.'.conf';
    $middleFile = '/tmp/main'.$node.'.conf';
} elsif ($type eq "VirtualHostConfig") {
    $virtualHostName = shift;
    if (scalar(@ARGV) >= 1) {
        $directory = shift;
    }
#    $middleFile = '/etc/group'.$node.'.setupinfo/httpd/interim/virtual'.$node.'.conf';
    $middleFile = '/tmp/virtual'.$node.'.conf';
} elsif ($type eq "BasicConfig") {
#    $middleFile = '/etc/group'.$node.'.setupinfo/httpd/interim/httpd.conf';
    $middleFile = '/tmp/httpd.conf';
}

if (!open(INPUT,"$middleFile")) {
    @content=();
} else {
    @content = <INPUT>;
    close(INPUT);
}

if (!open(OUTPUT,"| ${cmd_syncwrite_o} $tmpFile")) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if ($type eq "BasicConfig") {
    foreach (@content) {
        if (/^<\/$type>$/) {
            if ($in == 1) {
                $in = 0;
            }
        }
        if ($in == 1) {
            push(@output, $_);
        }
        if (/^<$type>$/) {
            if ($in == 0) {
                $in = 1;
            }
        }
    }
} elsif ($type eq "MainServerConfig" || $type eq "VirtualHostConfig") {
    $pattern = $type;
    if ($type eq "VirtualHostConfig") {
        $pattern = $pattern."\\s+$virtualHostName";
    }
    foreach (@content) {
        if (/^<\/$type>$/) {
            if ($in == 1) {
                $in = 0;
            }
        }
        if (/^<\/Directory>$/) {
            if ($in == 2) {
                $in = 1;
            }
        }
        if ($in == 2) {
            push(@output, $_);
        }
        if (/^<$pattern>$/) {
            if ($in == 0) {
                $in = 1;
            }
        }
        #if (/^<Directory\s+$directory>$/) {
        if (/^<Directory\s+(\S.*)>\s*$/) {
            my $dir=$1;
            if(($dir eq ${directory}) or ("\"".$dir."\"" eq ${directory}) or ($dir eq "\"".${directory}."\"")){
                if ($in == 1) {
                    $in = 2;
                }
            }
        }
    }
}

print OUTPUT @output;
if(!close(OUTPUT)){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};

@script = `/usr/sbin/nec_httpd_config options $option $tmpFile`;
if ($? != 0) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
system("sudo rm -f $tmpFile 2>&1 >&/dev/null");
print @script;
exit 0;
