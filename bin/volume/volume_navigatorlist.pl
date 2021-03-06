#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: volume_navigatorlist.pl,v 1.7 2005/07/25 02:44:04 liuyq Exp $"

use strict;

my $paranum = scalar(@ARGV);
if($paranum!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $rootDir = shift;
my $nowDir = shift;
my $checkOrNot = shift;

if (!(-d $rootDir)) {
    print STDERR "The directory ${rootDir} doesn't exist!\n";
    exit 1;
}

if ($checkOrNot eq "check") {
    while (1) {
        if (-d $nowDir) {
            last;
        } else {
            my $thePos = rindex($nowDir , "/");
            $nowDir = substr($nowDir , 0 , $thePos);
        }
    }
}

my @resultMount    =`/bin/mount`;

my @content = `ls -l '--time-style=+%a %b %d %H:%M:%S %G' $nowDir/`;
my @subDir;
my $linkName;
my $dirProperty; 
my $path;
my $thisLine;
my $mountStatus;

foreach $thisLine(@content){
    if ($thisLine=~/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
        $dirProperty = $1;
        $path = $2;
        
        #delete following lines to support UNICODE 
        if($thisLine =~ /[\200-\377]/){
            next;
        }
        
        if($path =~ /^[~-]|[^a-zA-Z0-9_\.\-~]/){ 
            next;
        }

	if ($thisLine !~ /^d/) {
        	next;
        }
        
        $mountStatus = "unmount";
        my $mountPoint = $nowDir."/".$path;
        foreach(@resultMount){
            if($_=~/\s+on\s+\Q${mountPoint}\E\s+/){
                $mountStatus = "mount";
                last;
            }
        }
            
        if (substr($dirProperty,length($dirProperty)-1) eq "("){
            $dirProperty = substr($dirProperty,0,length($dirProperty)-2);
        }
            
        $thisLine = join("",($dirProperty,$path));
        $thisLine = $mountStatus." ".$thisLine;
        $thisLine=~s/\s+/ /g;
        $thisLine = $thisLine."\n";
        push @subDir,$thisLine;
    }
}
if ($checkOrNot eq "check") {
    print $nowDir."\n";
}
print @subDir;

exit 0;
