#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_getMoveNavigatorList.pl,v 1.2 2005/07/22 10:42:46 wangzf Exp $"
## Function:
##     get destination mountpoint for filesystem move
##
## Parameters:
##     $rootDir	   -- destination mountpoint's root directory
##     $nowDir     -- current destination directory has selected or input
##     $checkOrNot -- flag, indicate if need to check $nowDir
##     $codepage   -- encoding of source mountpoint's  export group
##     $fsType     -- filesystem type of source mountpoint
##  
## Output:
##     STDOUT
##         mount   drwxrwxrwx 4 root root 32 Tue Mar 29 16:22:31 2005  directory1
##         unmount drwxrwxrwx 4 root root 32 Tue Mar 29 16:22:31 2005  directory2
##         
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed
use strict;
use NS::FilesystemCommon;
use NS::FilesystemConst;
use NS::VolumeCommon;
use NS::VolumeConst;

my $filesystemCommon = new NS::FilesystemCommon;
my $filesystemConst  = new NS::FilesystemConst;
my $volumeCommon     = new NS::VolumeCommon;
my $volumeConst      = new NS::VolumeConst;

## check parameters 
if (scalar(@ARGV) != 5) {
    $filesystemConst->printErrMsg($filesystemConst->ERR_PARAM_NUM);
    exit 1;
}

my ($rootDir, $nowDir, $checkOrNot, $codepage, $fsType) = @ARGV;

## check if $rootDir exist
if (!(-d $rootDir)) {
    $filesystemConst->printErrMsg($filesystemConst->ERR_ROOT_DIR_NOT_EXIST, $rootDir);
    exit 1;    
}

## get the longest exist directoy of $nowDir
if ($checkOrNot eq "check") {
    while (!(-d $nowDir)) {
        $nowDir = $filesystemCommon->getParentDir($nowDir);
    }
}

## get action type: get export group, get direct directory or get sub directory
my $actionType;
my $dirLevel = $filesystemCommon->getDirLevel($nowDir);
if ($dirLevel == 1) {
    $actionType = "getExpgrp";    
} elsif ($dirLevel >= 2) {
    $actionType = "getDirectory";
}

my $errFlag = $volumeConst->ERR_FLAG;
## get common info for check directory
my ($mountMP, $cfstabMP, $exportsMP, $importsMP, $errCode);
if ($dirLevel >= 2) {
    ## get all mount point from `mount`
    $mountMP = $volumeCommon->getMountMP();
    if (defined($$mountMP{$errFlag})) {
        $volumeConst->printErrMsg($$mountMP{$errFlag});
        exit 1;    
    }
    
    ## get all mount point from cfstab
    $cfstabMP = $volumeCommon->getMountOptionsFromCfstab();
    if (defined($$cfstabMP{$errFlag})) {
        $volumeConst->printErrMsg($$cfstabMP{$errFlag});
        exit 1;    
    }
    
    ## get all mount point has set replication 
    ($exportsMP, $importsMP, $errCode) = $volumeCommon->getReplicationMP();
    if (defined($errCode)) {
        $volumeConst->printErrMsg($errCode);
        exit 1;
    }
}

my @dirInfoArr;
my ($mountStatus, $dirProperty, $dirName);
my $retValue;
my $cmd_ls = $volumeConst->CMD_LS;
my @lsContent = `$cmd_ls -l '--time-style=+%a %b %d %H:%M:%S %G' $nowDir/`;

foreach (@lsContent) {
    my $line = $_;
    
    ## check if this line is a directory
    if ($line!~/^(d\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
        next;
    }

    $dirProperty = $1;
    $dirName     = $2;
    
    ## delete following lines to support UNICODE  
    if($line =~ /[\200-\377]/){
        next;
    }
    
    ## check if directory name is valid
    if($dirName =~ /^[~-]|[^a-zA-Z0-9_\.\-~]/){ 
    	next;
    }
    
    ## check directroy and get mount status
    my $tmpDir   = $nowDir."/".$dirName;
    if ($actionType eq "getExpgrp") {
        ## check export group directory
        $retValue = $filesystemCommon->checkExpgrpDir($tmpDir, $codepage);
        if (($retValue eq $volumeConst->ERR_FS_NO_CODEPAGE) || ($retValue eq "1")) {
            next;
        } elsif ($retValue =~ /^0x108000/) {
            last;
        }
        
        ## directory is valid
        $mountStatus = "unmount";
        &generateDirInfo();
 
    } else {
        ## check direct directory
        $retValue = $filesystemCommon->checkDirectory($tmpDir, $fsType, $mountMP, $cfstabMP, $exportsMP, $importsMP);
        if ($retValue == 1) {
            next;
        } elsif ($retValue == 2) {
            $mountStatus = "unmount";
        } else {
            $mountStatus = "mount";
        } 
        
        ## directory is valid
        &generateDirInfo();

    } 
}

## print valid directory info
if ($checkOrNot eq "check") {
    print "$nowDir\n";
}

print @dirInfoArr;
exit 0;

######### sub function begin ##############
## Function:
##     generate directory info according with $dirProperty, $dirName and $mountStatus
##
## Parameters:
##     none
##
## Returns:
##     none
##     
## Output:
##     none
sub generateDirInfo() {
    if (substr($dirProperty, length($dirProperty)-1) eq "("){
        $dirProperty = substr($dirProperty, 0, length($dirProperty)-2);
    }
    my $dirLine = join("", $dirProperty, $dirName);
    $dirLine    = $mountStatus." ".$dirLine;
    $dirLine    =~ s/\s+/ /g;
    $dirLine    = $dirLine."\n";
    push (@dirInfoArr, $dirLine);
}
######### sub function end ##############