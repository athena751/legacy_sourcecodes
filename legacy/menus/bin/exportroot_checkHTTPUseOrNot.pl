#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportroot_checkHTTPUseOrNot.pl,v 1.2302 2004/03/03 08:11:29 xiaocx Exp $"
use strict;
use NS::CodeConvert;

if(scalar(@ARGV) != 2) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $cc = new NS::CodeConvert();
my $hexMP = shift;
my $myNum = shift;

my $httpdConfFile1 = "/etc/group".$myNum.".setupinfo/httpd/interim/main".$myNum.".conf";
my $httpdConfFile2 = "/etc/group".$myNum.".setupinfo/httpd/interim/virtual".$myNum.".conf";

unless(-e $httpdConfFile1 || -e $httpdConfFile2) {
    print "false\n";
    exit 0;
}

if(!open(HTTPDCONF1 , $httpdConfFile1)) {
    print STDERR "Read $httpdConfFile1 failed! Exit in perl script:",__FILE__,"line:",__LINE__+1,".\n";
    exit 1;
}
my @contentOfMain = <HTTPDCONF1>;
close(HTTPDCONF1);

my $strMP = $cc->hex2str($hexMP);

my $find = &checkFileContent(\@contentOfMain , $strMP);

if($find eq "true"){
    print "$find\n";
    exit 0;
} 

if(!open(HTTPDCONF2 , $httpdConfFile2)) {
    print STDERR "Read $httpdConfFile2 failed! Exit in perl script:",__FILE__,"line:",__LINE__+1,".\n";
    exit 1;
}
my @contentOfVirtual = <HTTPDCONF2>;
close(HTTPDCONF2);

$find = &checkFileContent(\@contentOfVirtual , $strMP);

print "$find\n";
exit 0;


sub checkFileContent {
    my $addr = shift;
    my @content = @$addr;
    my $strMP = shift;

    my $thisLine;
    my $thisMP;
    my $find = "false";

    foreach (@content) {
        $thisLine = $_;
        if(($thisLine=~/^\s*DocumentRoot\s+\"(.+)\"\s*$/)
        ||($thisLine=~/^\s*DocumentRoot\s+\'(.+)\'\s*$/)
        ||($thisLine=~/^\s*DocumentRoot\s+(.+)$/)){
            $thisMP = $1;
            if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
                $find = "true";
                last;
            }

        }
        if(($thisLine=~/^\s*TransferLog\s+\"(.+)\"\s*$/)
        ||($thisLine=~/^\s*TransferLog\s+\'(.+)\'\s*$/)
        ||($thisLine=~/^\s*TransferLog\s+(.+)$/)){
            $thisMP = $1;
            if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
                $find = "true";
                last;
            }
        }
        if(($thisLine=~/^\s*CustomLog\s+\"(.+)\"\s*$/)
        ||($thisLine=~/^\s*CustomLog\s+\'(.+)\'\s*$/)
        ||($thisLine=~/^\s*CustomLog\s+(.+)$/)){
            $thisMP = $1;
            if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
                $find = "true";
                last;
            }
        }
        if(($thisLine=~/^\s*ErrorLog\s+\"(.+)\"\s*$/)
        ||($thisLine=~/^\s*ErrorLog\s+\'(.+)\'\s*$/)
        ||($thisLine=~/^\s*ErrorLog\s+(.+)$/)){
            $thisMP = $1;
            if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
                $find = "true";
                last;
            }
        }

        if(($thisLine=~/^\s*<Directory\s+\"(.+)\"\s*>\s*$/)
        ||($thisLine=~/^\s*<Directory\s+\'(.+)\'\s*>\s*$/)
        ||($thisLine=~/^\s*<Directory\s+(.+)\s*>$/)){
            $thisMP = $1;
            if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
                $find = "true";
                last;
            }

        }
    }
    return $find;
}