#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: nfs_navigatorlist.pl,v 1.3 2005/07/22 11:09:52 wangzf Exp $"

use strict;
use NS::NFSConst;
use NS::NFSCommon;

my $const = new NS::NFSConst;
my $common = new NS::NFSCommon;

my $paranum = scalar(@ARGV);
if($paranum!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit $const->ERRCODE_PARAMETER_NUMBER_ERROR;
}

my $nowDir = shift;
my $checkOrNot = shift;
my $groupNo = shift;

#get the $nowDir's path as possible
if ($checkOrNot eq "check") {
    while (1) {
        if (-d $nowDir || $common->isExportGroup($nowDir)) {
            last;
        } else {
            my $thePos = rindex($nowDir , "/");
            $nowDir = substr($nowDir , 0 , $thePos);
        }
    }
}

my $isExportGroup = $common->isExportGroup($nowDir);
my $mountCmd = $const->COMMAND_MOUNT;
my $imsAuthCmd = $const->COMMAND_IMS_AUTH;
my $imsConfFile = "/etc/group${groupNo}/ims.conf";

my @mountResult = `${mountCmd} 2> /dev/null`;
my @imsAuthResult = `$imsAuthCmd ${imsConfFile} 2> /dev/null`;

my @content = `ls -l '--time-style=+%a %b %d %H:%M:%S %G' $nowDir/`;
my @subDir;
my $linkName;
my $dirProperty; 
my $path;
my $thisLine;

foreach $thisLine(@content){
    if ($thisLine=~/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
        $dirProperty = $1;
        $path = $2;
        
        #delete following lines to support UNICODE 
        if($thisLine =~ /[\200-\377]/){
            next;
        }

        if ($thisLine !~ /^d/) {
            next;
        } 
        
        if($path =~ /[^a-zA-Z0-9_\.\-~]/){ #2003-01-13 lhy add
            next;
        }
            
        if (substr($dirProperty,length($dirProperty)-1) eq "("){
            $dirProperty = substr($dirProperty,0,length($dirProperty)-2);
        }
            
        $thisLine = join("",($dirProperty,$path));
        $thisLine=~s/\s+/ /g;
        push @subDir,$thisLine;
    }
}

my $parent = &getParent($nowDir);
my $level = scalar(split("/", $parent));
if($level > 4) {
    my $isMount = $common->hasMounted($parent, \@mountResult);
    print "${isMount}\n";   
} else {
    print "0\n";   
}

if ($checkOrNot eq "check") {
    print $nowDir."\n";
}

my $line;
foreach $line(@subDir) {
    my $mp = $nowDir."/".$common->parseLine($line);
    my ($fsType, $isMount, $hasAuth) = $common->getInfoOfMP($mp, \@mountResult, \@imsAuthResult);
    next if(!defined($fsType));
    if($isExportGroup == 1) {
        if($isMount) {
            print "${line} ${fsType} 0 ${hasAuth}\n"; 
        }        
    } else {
        print "${line} ${fsType} ${isMount} ${hasAuth}\n"; 
    }
}

sub getParent() {
    my $path = shift;
    my @temp = split("/", $path);
    pop(@temp);
    return join("/", @temp);
}
exit 0;
