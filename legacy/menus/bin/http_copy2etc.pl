#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_copy2etc.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;

my $node;
my $file;
my $tmp_httpd;
my $tmp_virtual0;
my $tmp_virtual1;
my $tmp_main0;
my $tmp_main1;
my $etc_directory;

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
$etc_directory = "/etc/group".$node.".setupinfo/httpd/interim/";

if (!(-e $tmp_httpd) || !(-e $tmp_main0) || !(-e $tmp_virtual0)
        || !(-e $tmp_main1) || !(-e $tmp_virtual1)) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
} else {
    if (system("cp $tmp_httpd $etc_directory")
            || system("cp $tmp_main0 $etc_directory")
            || system("cp $tmp_main1 $etc_directory")
            || system("cp $tmp_virtual0 $etc_directory")
            || system("cp $tmp_virtual1 $etc_directory")) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
system("rm $tmp_httpd");
system("rm $tmp_main0");
system("rm $tmp_main1");
system("rm $tmp_virtual0");
system("rm $tmp_virtual1");

exit 0;