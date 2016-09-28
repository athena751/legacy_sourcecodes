#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getwwnnorluninfo.pl,v 1.9 2008/05/24 12:09:36 liuyq Exp $"


###Function : get all wwnns and their storage , 
###           or get all available lun information for creating volume 
###           or get all available lun information for creating volume of the specified wwnn 
###Parameter:
###     usage     -- "DISPLAYMV_LUN" for displaying the lun has mv property
###                   or "NOT_DISPLAY_MVLUN" for not displaying the lun has mv property
###                 
###     operation -- specifiy to get wwnn information or to get lun information."wwnn" and "lun"
###                 --wwnn when to get lun infomation , wwnn could be specified.
###Return:
###     0 : success
###     1 : failed
###Outputs:
###     1. get all wwnn
###        diskarray01 200000004c517fc7
###        diskarray08 200000004c517fc8
###     2. get all lun
###        diskarray01 200000004c517fc7 16 /dev/ld10 0.3
###        diskarray08 200000004c517fc8 18 /dev/ld12 0.5
###        diskarray09 200000004c517fc8 20 /dev/ld14 5.5
###     3. get all lun of specified wwnn
###        diskarray08 200000004c517fc8 18 /dev/ld12 0.5
###        diskarray09 200000004c517fc8 20 /dev/ld14 5.5
###     4. stderr
###         Parameter's number is wrong.
###         Error occured. (error_code=0x10800000)

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::DdrCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;
my $ddrCommon   = new NS::DdrCommon;

###check parameters number
my $usage = shift;
if(!defined($usage)){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}
if((scalar(@ARGV) != 1) && (scalar(@ARGV) != 3)){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit 1;
}
###validate parameters
my $operation = lc($ARGV[0]);
if( ($operation ne "wwnn") && ($operation ne "lun")){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
    exit 1;
}
if((scalar(@ARGV) == 3) && (lc($ARGV[1]) ne "--wwnn")){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
    exit 1;
}

### get all wwnn by $volumeCommon->getAllWwnn()
my $wwnnHash = $volumeCommon->getAllWwnn();
if(defined($$wwnnHash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$wwnnHash{$volumeConst->ERR_FLAG});
    exit 1;
}
if($operation eq "wwnn"){###process get wwnn information case
    my @storageAry = ();
    foreach(keys %$wwnnHash){
        push(@storageAry , $$wwnnHash{$_}." ".$_."\n");
    }
    @storageAry = sort @storageAry;
    print @storageAry;    
}else{###process get lun infomation case
    my $wwnn = $ARGV[2];
    my $lunHash = $volumeCommon->getAllLunInfo();
    if(defined($$lunHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$lunHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
    my ($lun , $lunSize , $ldPath);
    
    ## get all used ld by lv
    my $allUsedLds =  $volumeCommon->getAllUsedLd();
    if(defined($$allUsedLds{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$allUsedLds{$volumeConst->ERR_FLAG});
        exit 1;
    }
    
    ## get all MV RV lds
    my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds();
    if($usage eq $volumeConst->CONST_DISPLAY_MVLUN){
        $allUsedLds = {%$allUsedLds, %$rvLdHash};
    }else{
        $allUsedLds = {%$allUsedLds, %$mvLdHash, %$rvLdHash};
    }   

    if(!defined($wwnn)){
        my @outputs = ();
        foreach(keys %$lunHash){
            ($wwnn , $lun) = split("," , $_);
            if(!defined($$wwnnHash{$wwnn})){
                next;
            }
            
            my $info = $$lunHash{$_};
            ($ldPath , $lunSize ) = @$info;
            ## check if used
            if(defined($$allUsedLds{$ldPath})){
                next;
            }
            ## check size
            $lunSize = $nsguiCommon->deleteAfterPoint($lunSize/1024/1024 , 1);
            if ($lunSize < 0.1) {
                next;
            }
            push(@outputs , join(" " , $$wwnnHash{$wwnn} , $wwnn , $lun , $ldPath , $lunSize)."\n");
        }
        @outputs = sort byStorageAndLun @outputs;
        print @outputs;
    }else{
        my @outputs = ();
        my $wwnnTmp;
        if(!defined($$wwnnHash{$wwnn})){
            exit 0;
        }
        foreach(keys %$lunHash){
            ($wwnnTmp , $lun) = split("," , $_);
            if($wwnn ne $wwnnTmp){
                next;
            }
            my $info = $$lunHash{$_};
            ($ldPath , $lunSize ) = @$info;
            ## check if used
            if(defined($$allUsedLds{$ldPath})){
                next;
            }
            ## check size
            $lunSize = $nsguiCommon->deleteAfterPoint($lunSize/1024/1024 , 1);
            if ($lunSize < 0.1) {
                next;
            }
            push(@outputs , join(" " , $$wwnnHash{$wwnn} , $wwnn , $lun , $ldPath , $lunSize)."\n");
        }
        @outputs = sort byStorageAndLun @outputs;
        print @outputs;
    }
}

exit 0;

#### sub function defination start ####
### Function: show help message;
### Paremeters:
###     none;
### Return:
###     none
### Output:
###     usage
sub showHelp(){
    print (<<_EOF_);
Usage:
    volume_getwwnnorluninfo.pl <DISPLAYMV_LUN|NOT_DISPLAY_MVLUN> wwnn
    volume_getwwnnorluninfo.pl <DISPLAYMV_LUN|NOT_DISPLAY_MVLUN> lun [--wwnn wwnn]
        
_EOF_
}


### Function : sort array by storage and lun field
### Parameters:
###     @array -- the array to sort
###                 element in the array is like "storage wwnn lun ldpath size";
### Return :
###     0 -- equal
###     1 -- greater
###     -1 -- less
sub byStorageAndLun(){
    my ($aStorage , $aLun) = (split(/\s+/ , $a))[0 , 2];
    my ($bStorage , $bLun) = (split(/\s+/ , $b))[0 , 2];
    
    if($aStorage lt $bStorage){
        return -1;
    }
    if($aStorage gt $bStorage){
        return 1;
    }
    if($aLun < $bLun){
        return -1;
    }
    if($aLun > $bLun){
        return 1;
    }
    return 0;
}
#### sub function defination end   ####