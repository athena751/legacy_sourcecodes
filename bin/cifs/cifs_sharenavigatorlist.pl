#! /usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_sharenavigatorlist.pl,v 1.15 2008/03/06 14:22:10 qim Exp $"

use strict;
use NS::USERDBCommon;
use NS::CodeConvert;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::RPQLicenseNo;
use NS::CIFSCommon;

my $userdbCommon = new NS::USERDBCommon;
my $codeConvert = new NS::CodeConvert;
my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $RPQ_No = new NS::RPQLicenseNo;
my $cifsCommon = new NS::CIFSCommon;

my $paranum = scalar(@ARGV);
if($paranum != 4 && $paranum != 5){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $rootDir = shift;
my $nowDir = shift;
my $checkOrNot = shift;
my $groupNumber = shift;
my $notListfsType = shift;

my $rootDirNoChange = $rootDir;
my $expGroupName;
#modify for diraccessctrl
if($rootDir =~ /^\s*(\/[^\/]+\/[^\/]+).*/) {
    #get the [/export/exportGroupName] from the rootDir
    $expGroupName = $1;
}
my $expGroupEncoding = $userdbCommon->getExpgrpCodePage($groupNumber, $expGroupName);
$nowDir = $codeConvert->changeUTF8Encoding($nowDir, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
$rootDir = $codeConvert->changeUTF8Encoding($rootDir, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($nowDir) || !defined($rootDir)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}

if (!(-d $rootDir)) {
    #the shared directory does not exist
    print "$rootDirNoChange\n";
    exit 0;
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

my $mpInfoRef;
if(defined($notListfsType)) {
    my $conffile = "/etc/group$groupNumber/cfstab";
    my @cfstabContent = `cat $conffile`;
    $mpInfoRef = $cifsCommon->getFstypeOfAllMP($groupNumber, \@cfstabContent);
    my @dir = split("/", $nowDir);
    if(scalar(@dir) > 3) { 
        if($cifsCommon->getFstypeOfSpecifiedDir($nowDir, $groupNumber, $mpInfoRef) eq $notListfsType) {
            $nowDir = "/".$dir[1]."/".$dir[2];
        }
    }
}

my @content;
my $needChangeCode = $codeConvert->needChange($expGroupEncoding);
if(!defined($needChangeCode)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}
if($needChangeCode eq "y") {
    @content = `ls -lA '--time-style=+%a %b %d %H:%M:%S %G' \Q$nowDir\E | /home/nsadmin/bin/nsgui_iconv.pl -f UTF8-NEC-JP -t UTF-8`;
} else {
    @content = `ls -lA '--time-style=+%a %b %d %H:%M:%S %G' \Q$nowDir\E`;
}
my @subDir;
my $dirProperty;
my $path;
my $thisLine;
my $mountStatus;

my @resultMount    =`/bin/mount`;

my $dirLevel = scalar(split("/" , $nowDir));

foreach $thisLine(@content){
    if ($thisLine=~/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
        $dirProperty = $1;
        $path = $2;

    if ($thisLine !~ /^d/) {
            next;
        }
        
    if(defined($notListfsType) && $dirLevel == 3) {
        if($cifsCommon->getFstypeOfSpecifiedDir($nowDir."/".$path, $groupNumber, $mpInfoRef) eq $notListfsType) {
            next;
        }
    }
        
        $mountStatus = "unmount";
        my $mountPoint = $nowDir."/".$path;
        if ($dirLevel == 3) {
            my $flagFind = 0;
            foreach(@resultMount){
                if($_=~/\s+on\s+\Q${mountPoint}\E\s+/){
                    $flagFind = 1;
                    last;
                }
            }
            
            if ($flagFind == 0) {
                next;
            } else {
                $mountStatus = "mount";
            }
        } else {
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
        #add for delete directory
        #if($mountStatus eq "mount"){
        #    $thisLine = $thisLine.":no";
        #}elsif($path =~ /^\.snap$|^\.psid_lt$|^\.sync$|^\.datasetinfo$|^\.quotainfo$|^\.eainfo-.*$/i){
        #    $thisLine = $thisLine.":no";
        #}elsif($path =~ /^lost\+found(\d+)$/i){
        #    if(($1<=65535)&&($1>=0)){
        #        $thisLine = $thisLine.":no";
        #    }else{
        #        $thisLine = $thisLine.":yes";
        #    }
        #}else{
        #     $thisLine = $thisLine.":yes";
        #}
        #add end
        $thisLine = $thisLine."\n";
        push @subDir,$thisLine;
    }
}
if ($checkOrNot eq "check") {
	my $nowDirForPrint = $codeConvert->changeUTF8Encoding($nowDir, $expGroupEncoding, $codeConvert->ENCODING_UTF_8);
	if(!defined($nowDirForPrint)) {
	    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
        $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
        exit 1;
    }
    print $nowDirForPrint."\n";
}
print @subDir;

exit 0;
