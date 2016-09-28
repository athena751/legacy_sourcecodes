#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nfs_fileNavigatorList.pl,v 1.7 2005/07/22 10:55:17 wangzf Exp $"

#Function:
#   get directory and files' info of input directory.
#Arguments:
#   $rootDir,$nwoDir,$checkOrNot,$groupNo
#Output:
#   drwxr-xr-x 2 root root 4096 Mon Mar 08 17:33:23 2004 abc
#   drwxrwx--x 3 root root 4096 Mon Aug 30 17:25:25 2004 abcd
#   drwxr-xr-x 3 root root 4096 Fri Aug 27 18:03:08 2004 alicool
#   ......
use strict;
use NS::APICommon;
use NS::NFSCommon;
#get the parameters
my $paranum = scalar(@ARGV);
if($paranum!=4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($rootDir,$nowDir,$checkOrNot,$groupNo) = @ARGV;
# if current directory is not below the root directory,display root directory
if($nowDir!~/^\Q$rootDir\E\//){
    $nowDir = $rootDir;
}
#get the list of exportgroup
my $api = new NS::APICommon;
my $egResult = $api->getExportGroupInfo("/etc/group${groupNo}/");
if(!defined($egResult)){
    print STDERR $api->error();
    exit 1;
}
my @exportgrouplist = keys(%$egResult);
#get the list of mountpoint from /etc/group[0|1]/cfstab
my $cfstabFile = "/etc/group${groupNo}/cfstab";
my @mountpointlist;
if(-f $cfstabFile){
    if(!open(FILE,$cfstabFile)){
        print STDERR "Failed to open file \"${cfstabFile}\". Exit in perl script:"
                        ,__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    foreach(<FILE>){
        if(/^\s*$/ || /^\s*#/){
            next;
        }
        if(/^\s*\S+\s+(\S+)\s+/){
            push(@mountpointlist,$1);
        }
    }
    close(FILE);
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
    my $isUserArea = 0;
    foreach(@mountpointlist){
        if($nowDir =~/^\Q$_\E\// || $nowDir eq $_
                || $nowDir eq $_."/"){
            $isUserArea = 1;    
        }
    }
    if(!$isUserArea){
        $nowDir=~/^(\/export\/[^\/]+)/;
        my $includeEg = $1;
        if(defined($includeEg) && scalar(grep(/^\Q${includeEg}\E$/,@exportgrouplist))!=0){
            $nowDir = $includeEg;
        }else{
            $nowDir = $rootDir;
        }
    }
}#end of if
my @content = `ls -al '--time-style=+%a %b %d %H:%M:%S %G' \Q${nowDir}/\E`;
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
        #delete the invalid directories
        if($path =~ /[^a-zA-Z0-9\!#\$\%\&\'\(\)\+\-\.\/\=\@\^_\`\~]/){
            next;
        }
        if($path eq "." || $path eq ".."){
            next;
        }
        #filter the directories and set the status of left ones
        my $mountPoint = $nowDir."/".$path;
        if ($nowDir eq "/export" && scalar(grep(/^\Q${mountPoint}\E$/,@exportgrouplist))==0) {
            next;
        }elsif ($nowDir =~/^\/export\/[^\/]+$/ && scalar(grep(/^\Q${mountPoint}\E$/,@mountpointlist))==0) {
            next;
        }
        $mountStatus = "unmount";
        if ($thisLine =~ /^d/ && scalar(grep(/^\Q${mountPoint}\E$/,@mountpointlist))!=0){
            $mountStatus = "mount";
        }

        if (substr($dirProperty,length($dirProperty)-1) eq "("){
            $dirProperty = substr($dirProperty,0,length($dirProperty)-2);
        }
        $dirProperty = $mountStatus." ".$dirProperty;
        $thisLine = join("",($dirProperty,$path));
        $thisLine=~s/\s+/ /g;
        $thisLine = $thisLine."\n";
        push @subDir,$thisLine;
    }#end of if
}
if ($checkOrNot eq "check") {
    print $nowDir."\n";
}
print @subDir;

exit 0;
