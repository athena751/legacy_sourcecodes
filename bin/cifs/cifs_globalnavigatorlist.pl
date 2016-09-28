#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_globalnavigatorlist.pl,v 1.6 2005/07/22 10:07:41 key Exp $"

use strict;
use NS::CIFSCommon;

my $paranum = scalar(@ARGV);
if($paranum!=4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $rootDir = shift;
my $nowDir = shift;
my $checkOrNot = shift;
my $groupNumber = shift;

if (!(-d $rootDir)) {
    print STDERR "The directory ${rootDir} doesn't exist!\n";
    exit 1;
}

my $cifsCommon = new NS::CIFSCommon;
$nowDir = $cifsCommon->getValidBaseDir($nowDir, $groupNumber);

if ($checkOrNot eq "check") {
    while (1) {
        if ((-d $nowDir) && ($nowDir !~ /[\200-\377]/)) {
            last;
        } else {
            my $thePos = rindex($nowDir , "/");
            if (0 == $thePos) {
                $nowDir = "/";
                last;
            }
            $nowDir = substr($nowDir , 0 , $thePos);
        }
    }
}

my @resultMount    =`/bin/mount`;

my @content = `ls -lA '--time-style=+%a %b %d %H:%M:%S %G' \Q$nowDir\E`;
my @subDir;
my $dirProperty; 
my $path;
my $thisLine;
my $mountStatus;
my $exportGroupInfoRef;
my $mpInfoRef;
my $mountingInfoRef;

my $conffile = "/etc/group$groupNumber/cfstab";
my @cfstabContent = `cat $conffile`;
if($nowDir eq "/export"){
    #need check the result is exportGroup or not
    $exportGroupInfoRef = $cifsCommon->getAllExportGroup($groupNumber);
}elsif($nowDir =~ /^\/export\/[^\/]+$/){
    #such as /export/exportGroup
    
    #need check the mp is sxfsfw or not
    $mpInfoRef = $cifsCommon->getFstypeOfAllMP($groupNumber, \@cfstabContent);
    
    #need check the corresponding mp is mounting or not
    $mountingInfoRef = $cifsCommon->getAllMountingMP(\@resultMount);
}elsif($nowDir =~ /^\/export\/[^\/]+/){
    #such as /export/exportGroup/sxfs
    
    #need check the corresponding mp is mounting or not
    $mountingInfoRef = $cifsCommon->getAllMountingMP(\@resultMount);
}
foreach $thisLine(@content){
    if ($thisLine=~/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
        $dirProperty = $1;
        $path = $2;
    
        #no need to display japanese 
        if($thisLine =~ /[\200-\377]/){
            next;
        }    
	    if ($thisLine !~ /^d/ && $thisLine !~/^\-/) {
        	next;
        }
        my $tmpFileName = "$nowDir/$path";
        if(defined($exportGroupInfoRef)){
            #need check the result is exportGroup or not
            if(!defined($$exportGroupInfoRef{$tmpFileName})){
                #is not a exportGroup
                next;
            }
        }elsif(defined($mpInfoRef)){
            #need check the mp is sxfsfw or not
            if($cifsCommon->getFstypeOfSpecifiedDir($tmpFileName, $groupNumber, $mpInfoRef) ne "sxfs"){
                #the mp is not in sxfs
                next;
            }
        }
        
        if(defined($mountingInfoRef)){
            #need check the corresponding mp is mounting or not
            #get the corresponding mp of the file name
            my $tmpMp = $cifsCommon->getMP($groupNumber, $tmpFileName, \@cfstabContent);
            if(!defined($tmpMp)){
                next;
            }
            if(!defined($$mountingInfoRef{$tmpMp})){
                #is not mounting
                next;
            }
        }
        
        $mountStatus = "unmount";
        if ($thisLine =~ /^d/) {
            my $mountPoint;
            if ($nowDir eq "/") {
                $mountPoint = $nowDir.$path;
            } else {
                $mountPoint = $nowDir."/".$path;
            }
            foreach(@resultMount){
                if($_=~/\s+on\s+\Q${mountPoint}\E\s+/){
                    $mountStatus = "mount";
                    last;
                }
            }
        }
            
        if (substr($dirProperty,length($dirProperty)-1) eq "("){
            $dirProperty = substr($dirProperty,0,length($dirProperty)-2);
        }
            
        $dirProperty = $mountStatus." ".$dirProperty;
        $dirProperty=~s/\s+/ /g;
        $thisLine = join("",($dirProperty,$path));
        $thisLine = $thisLine."\n";
        push @subDir,$thisLine;
    }
}
if ($checkOrNot eq "check") {
    print $nowDir."\n";
}
print @subDir;

exit 0;
