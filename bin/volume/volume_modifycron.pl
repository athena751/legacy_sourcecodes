#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_modifycron.pl,v 1.5 2007/01/16 03:07:06 wangzf Exp $"

###Function : delete entry in /var/spool/cron/snapshot 
###           or modify mount point entry to device path entry
###Parameters:
###     operation: specified operation . delete or modify
###     mp : mount point path
###     dev : device path
###Output:
###     Stderr: error message
###Return :
###     0 : success
###     1 : failed

use strict;
use NS::SystemFileCVS;
use NS::VolumeConst;
use NS::NsguiCommon;

my $volumeConst = new NS::VolumeConst;
my $nsgui_common = new NS::NsguiCommon;
###check parameters' number
if(scalar(@ARGV)!=3){  
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
    exit(1);
}
###validate parameter 
my $operation = shift;
if( ($operation ne "delete") && ($operation ne "modify")){
    &showHelp();
    $volumeConst->printErrMsg($volumeConst->ERR_PARAM_INVALID);
    exit 1;
}

my $path = shift;
my $devname = shift; #2003/07/14 maojb, xinghui add
my $cvs = new NS::SystemFileCVS;
my $cronfile = $volumeConst->FILE_CRON_SNAPSHOT;
my @content = ();
-f $cronfile or exit 0;
if($cvs->checkout($cronfile)!=0){
    print STDERR "Checkout $cronfile failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if(!open(IN, $cronfile)){
    print STDERR "The $cronfile can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cvs->rollback($cronfile);
    exit(1);
}
@content = <IN>;
close(IN);

my $cmd_syncwrte_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
if(!open(OUTPUT , "|$cmd_syncwrte_o $cronfile")){
    $cvs->rollback($cronfile);
    print STDERR "The $cronfile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

if($operation eq "delete"){###process delete case
    foreach(@content){
        if($_=~/^\s*#/){
            print OUTPUT $_;
        }elsif($_=~/\s+\Q${path}\E\// or $_=~/\s+${devname}\/\s+/ or $_=~/\s+(\Q${path}\E|${devname})\s+/){

        }else{
            print OUTPUT $_;
        }
    }
}else{###process modify case
    foreach(@content){
        if($_=~/^\s*#/){
            print OUTPUT $_;
        }elsif($_=~/\s+\Q${path}\E\//){
        }elsif($_=~ s/\s\Q${path}\E\s/ $devname /){
            print OUTPUT $_;
        }else{
            print OUTPUT $_;
        }
    }
}
if(!close(OUTPUT)){
    $cvs->rollback($cronfile);
    print STDERR "The $cronfile can not be closed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

$nsgui_common->reloadCron("snapshot", $cronfile);

if($cvs->checkin($cronfile)!=0){        
    $cvs->rollback($cronfile);
    print STDERR "check in file \"$cronfile\" failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}    
exit(0);


#### sub function defination start ####
### Function: show help message;
### Paremeters:
###     none;
### Return:
###     none
### Output:
###     Usage:
###         volume_modifycron.pl [delete|modify] <mountpoint> <devicepath>
sub showHelp(){
    print (<<_EOF_);
Usage:
    volume_modifycron.pl [delete|modify] <mountpoint> <devicepath>

_EOF_
}

#### sub function defination end   ####