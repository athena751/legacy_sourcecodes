#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_getFreeLd.pl,v 1.7 2008/05/24 12:06:50 liuyq Exp $"
## Function:
##     get free LD for filesystem extend
##
## Parameters:
##     none
##
## Output:
##     STDOUT
##         lun  storage ldSize  ldPath  
##     STDERR
##         error code and error message
##
## Returns:
##     0 -- success
##     1 -- failed
use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::FilesystemCommon;
use NS::DdrCommon;
use NS::FilesystemConst;

my $volumeCommon     = new NS::VolumeCommon;
my $volumeConst      = new NS::VolumeConst;
my $nsguiCommon      = new NS::NsguiCommon;
my $filesystemCommon = new NS::FilesystemCommon;
my $ddrCommon        = new NS::DdrCommon;
my $fsConst          = new NS::FilesystemConst;

my $errFlag = $volumeConst->ERR_FLAG;

my $usage = shift;
if(!defined($usage)){
    $fsConst->printErrMsg($fsConst->ERR_PARAM_NUM);
    exit 1;
}
## get all has been used LD, $$usedLd{$ldPath} = ""
my $usedLd = $volumeCommon->getAllUsedLd();
if (defined($$usedLd{$errFlag})) {
    $volumeConst->printErrMsg($$usedLd{$errFlag});
    exit 1;
}

## get all MV RV lds
my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds();
if($usage eq $volumeConst->CONST_DISPLAY_MVLUN){
   $usedLd = {%$usedLd, %$rvLdHash};   
}else{
   $usedLd = {%$usedLd, %$mvLdHash, %$rvLdHash};
}

## get all connected LD from /sbin/getddmap, $$connectedLd{$wwnn, $lun} = ""
my $connectedLd = $volumeCommon->getAllConnectedLd();
if (defined($$connectedLd{$errFlag})) {
    $volumeConst->printErrMsg($$connectedLd{$errFlag});
    exit 1;
} 

## get all hardlink LD from ldhardln.conf, $$linkedLd{$wwnn,$lun} = [$ldPath, $size]
my $linkedLd = $volumeCommon->getAllLunInfo();
if (defined($$linkedLd{$errFlag})) {
    $volumeConst->printErrMsg($$linkedLd{$errFlag});
    exit 1;
}

## get all wwnn's storage, $$wwnnHash{$wwnn} = $storage
my $wwnnHash = $volumeCommon->getAllWwnn();
if (defined($$wwnnHash{$errFlag})) {
    $volumeConst->printErrMsg($$wwnnHash{$errFlag});
    exit 1;
} 

## get free LD info and output
my ($wwnn, $lun, $storage, $ldSize, $ldPath);   
foreach (keys %$linkedLd) {
    
    ## check if LD is connect
    if (!defined($$connectedLd{$_})) {
        next;
    }
    
    ## check if LD has been used
    my $ldInfo = $$linkedLd{$_};                    
    ($ldPath, $ldSize) = @$ldInfo;
    if (defined($$usedLd{$ldPath})) {
        next;
    }        
    
    if (($ldPath  !~ /^\/dev\/ld(\d+)$/) || ($1 < 16)) {
        next;
    } 
    
    ## change ldSize unit, KB to GB, save one digit after point 
    $ldSize = $nsguiCommon->deleteAfterPoint(($ldSize/1024/1024), 1); 
    
    ## print LD's info if LD's size > 0.2G
    ($wwnn, $lun) = split(",", $_);
    if ($ldSize >= 0.2) {
        ## get $storage
        $storage = $$wwnnHash{$wwnn};
		print "$lun\t$storage\t$ldSize\t$ldPath\n";
    }
}

exit 0;