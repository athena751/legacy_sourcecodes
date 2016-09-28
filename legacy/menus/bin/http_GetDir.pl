#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_GetDir.pl,v 1.2301 2005/07/22 10:40:52 wangzf Exp $"

use strict;
use NS::CodeConvert;
use NS::ReplicationCommand;

my $paranum = scalar(@ARGV);
if($paranum!=4 and $paranum!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $CodeConvert = new NS::CodeConvert;
my $etcPath = shift;
my $imsPath = shift;
my $directory = "0x2f";
if ($paranum != 3) {
    $directory = shift;
}
my $flag = shift; # 0 means all dir; 1 means mounted dir; 2 means auth dir; 5, get all files.

my $path;
my $encodedPath;
my $thisLine;
 $directory = $CodeConvert->hex2str($directory);
my $mountPoint;
my @mountList;
my @authList;
my $replication;
my @tempResult;
my $tempLine;
my @temp;

unless (-d $directory) {
    print STDERR "the directroy \"$directory\" doesn't exist!\n";
    exit 21;
}

if ($flag == 1) {
    @tempResult = `mount |grep $directory`;
    foreach $tempLine (@tempResult) {
        @temp = split(/\s+/,$tempLine);
        push @mountList,$temp[2];
    }
}

if ($flag == 2) {
    @authList = `/usr/bin/ims_auth -Lv -c $imsPath `;
}

if ($flag == 3 or $flag == 4) {
    $replication = new NS::ReplicationCommand;
}
my @content = `ls -l '--time-style=+%a %b %d %H:%M:%S %G' "$directory/"`;
my @subDir;
my $link;
my $dirProperty; #2003-01-14 lhy add
foreach $thisLine(@content){

    if ($flag == 5) {
        if ($thisLine=~/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
            $dirProperty = $1;
            $path = $2;
            if($thisLine =~ /[\200-\377]/){
                next;
            }
            if($path =~ /[^a-zA-Z0-9_\.\-~\s]/){ #2003-01-13 lhy add
                next;
            }

            if ( $thisLine =~/^l/ ) { # if this file is a link
                if ($path =~/(\S+)\s+->\s+(\S+)/) {
                    $link = $1;
                    if ( $2 =~/\/$/ ) {
                       $dirProperty = ~s/^l/d/;
                    } else {
                        $dirProperty = ~s/^l/-/;
                    }
                    $thisLine = join("",($dirProperty,$link));#2003-01-14 lhy add
                    $path = $link;
                }
            }
            $encodedPath=$CodeConvert->str2hex($path);
            $thisLine = join("",($dirProperty,$encodedPath));#2003-01-14 lhy add
            $thisLine=~s/\s+/ /g;
            $thisLine = $thisLine."\n";
            push @subDir,$thisLine;
        }
        next;
    }
    if ($thisLine!~/^(d\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+)(.*)$/){ #2003-01-14 lhy add
        next;
    }
    $dirProperty = $1;
    $path = $2;
    if($thisLine =~ /[\200-\377]/){
        next;
    }
    if($path =~ /[^a-zA-Z0-9_\.~\-]/){ #2003-01-13 lhy add
        next;
    }
    $encodedPath=$CodeConvert->str2hex($path);
#    $encodedPath = $path;
   # $thisLine=~s/($path)$/$encodedPath/; #2003-01-13 lhy delete
    if(substr($dirProperty,length($dirProperty)-1) eq "("){
        $dirProperty = substr($dirProperty,0,length($dirProperty)-2);
    }
    $thisLine = join("",($dirProperty,$encodedPath,));
    $thisLine=~s/\s+/ /g;

    if ($flag == 0) {
        $thisLine = $thisLine."\n";
        push @subDir,$thisLine;
    }
    elsif ($flag == 1) {
        $mountPoint = $directory ."/". $path;
        my $foundMount = 0;
        foreach (@mountList) {
            if ($mountPoint eq $_) {
                $foundMount = 1;
                last;
            }
        }
        if ($foundMount) {
            $thisLine = $thisLine."\n";
            push @subDir,$thisLine;
        }
    }
    elsif ($flag ==2) {
        my $region;
        $mountPoint = $directory ."/".$path;

        my $mountPointHex = $CodeConvert->str2hex($mountPoint);
        my $fstype = `quota_getfstype.pl $mountPointHex`;
        if($fstype eq "sxfsfw\n"){
            $thisLine = $thisLine." sxfsfw";
        }else{
            foreach $tempLine(@authList){
                if ($tempLine=~/^$mountPoint\s+.*/) {


                    @temp = split(/\s+/,$tempLine);
                    if (scalar(@temp)==2) {
                        $region=$temp[1];
                        $thisLine = $thisLine." ".$region;
                    }
                }
            }
        }

        $thisLine = $thisLine."\n";
        push @subDir,$thisLine;
    }
    elsif ($flag == 3) {
        $mountPoint = $directory ."/". $path;
        if ((!$replication->checkReplicMP($mountPoint))&&(!$replication->checkFstab($etcPath, $mountPoint))) {
            $thisLine = $thisLine."\n";
            push @subDir,$thisLine;
        }else{
            $thisLine = $thisLine." mounted\n";
            push @subDir,$thisLine;
        }
    }
    elsif ($flag == 4) {
        $mountPoint = $directory ."/". $path;
        if (!$replication->checkFstab($etcPath,$mountPoint)) {
            $thisLine = $thisLine."\n";
            push @subDir,$thisLine;
        }
        else {
            $thisLine = $thisLine." mounted\n";
            push @subDir,$thisLine;
        }
    }

}
print @subDir;

exit 0;
