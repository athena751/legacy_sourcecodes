#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportroot_checkFTPUseOrNot.pl,v 1.2302 2004/03/03 08:11:39 xiaocx Exp $"
use strict;
use NS::CodeConvert;

if(scalar(@ARGV) != 2) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $cc = new NS::CodeConvert();
my $hexMP = shift;
my $myNum = shift;

my $ftpdConfFile = "/etc/group".$myNum.".setupinfo/ftpd/proftpd.conf.".$myNum;

unless(-e $ftpdConfFile) {
    print "false\n";
    exit 0;
}

if(!open(FTPDCONF , $ftpdConfFile)) {
    print STDERR "Read $ftpdConfFile failed! Exit in perl script:",__FILE__,"line:",__LINE__+1,".\n";
    exit 1;
}

my @content = <FTPDCONF>;
close(FTPDCONF);
my $strMP = $cc->hex2str($hexMP);


my $find = "false";
foreach (@content) {
    my $thisLine = $_;

    my $thisPath;
    my @thisLineMP;
    my $thisMP;
    if(($thisLine=~/^\s*DefaultChdir\s+\"(.+)\"\s*$/)
       ||($thisLine=~/^\s*DefaultChdir\s+\'(.+)\'\s*$/)
       ||($thisLine=~/^\s*DefaultChdir\s+(.+)$/)){
	    $thisPath = $1;
	    if($thisPath!~/%/){
	        $thisMP = $thisPath;
	    } else {
	        @thisLineMP = split(/%/,$thisPath);
            $thisMP = $thisLineMP[0];
	    }
	    if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
            $find = "true";
            last;
        }
    }
    if(($thisLine=~/^\s*<Anonymous\s+\"(.+)\"\s*>\s*$/)
       ||($thisLine=~/^\s*<Anonymous\s+\'(.+)\'\s*>\s*$/)
       ||($thisLine=~/^\s*<Anonymous\s+(.+)>\s*$/)){
	    $thisMP = $1;
	    if(($strMP eq $thisMP) || ($thisMP=~/^\Q$strMP\E\//)){
	        $find = "true";
	        last;
	    }
    }
}
print "$find\n";
exit 0;

