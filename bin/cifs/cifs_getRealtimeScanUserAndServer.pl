#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

#"@(#) $Id: cifs_getRealtimeScanUserAndServer.pl,v 1.1 2007/03/23 05:40:47 chenbc Exp $"

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::ServerProtectCommon;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $spCommon = new NS::ServerProtectCommon;

if(scalar(@ARGV) != 3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($groupNumber, $domainName, $computerName) = @ARGV;
my $users = "";
my $server = "";
my $fileContentAddr = $spCommon->getFileContent($groupNumber, $computerName);
if(defined($fileContentAddr)) {
    my @realtime_scanInfo = $spCommon->getRealTimeScanInfo($fileContentAddr);
    foreach(@realtime_scanInfo) {
        if(/^\s*ludbUser\s*=\s*(.+)/) {
            $users = $1;
            chomp($users);
            $users =~ s/^\s+|\s+$//g;
            my @user = split(/:+/, $users);
            foreach my $line(@user) {
                $line =~ s/^\s+|\s+$//g;
                $line = $domainName."+".$line;
                if($line =~ /\s/) {
                    $line = "\"".$line."\"";
                }
            }
            $users = join(" ", @user);
            last;
        }
    }
    my @realtime_scanServer = $spCommon->getScanServerInfo($fileContentAddr);
    foreach(@realtime_scanServer) {
        if(/^\s*host\s*=\s*(\S+)/) {
            $server .= $1;
            chomp($server);
            $server .= " ";
        }
    }
    $server =~ s/^\s+|\s+$//g;
}
print $users."\n";
print $server."\n";
exit 0;
