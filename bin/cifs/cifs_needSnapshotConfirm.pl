#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_needSnapshotConfirm.pl,v 1.2 2004/12/13 05:22:31 baiwq Exp $"

#Function: 
    #check the directory whether the mount point has been set the snapshot schedule;
#Arguments: 
    #$groupNo       : the group number 0 or 1
    #$dir           : the share directory

#exit code:
    #0:succeed 
    #1:failed
#output:
    #true:  
    #     need confirm the user to add the snapshot schedule
    #false:
    #     1 volume is readonly (which the directory is included)
    #     2 snapshot schedule has  existed
    
use strict;

use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::VolumeCommon;

my $comm = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

if(scalar(@ARGV)!=2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my($groupNo,$dir) = @ARGV;

#get the mount point according to the directory
my $mp = $cifsCommon->getMP($groupNo,$dir);

if(!defined($mp)){
	exit 1;
}

#check that whether the volume is readonly.
my $mpsOptions = $volumeCommon->getMountOptionsFromCfstab();
if(defined($$mpsOptions{$volumeConst->ERR_FLAG})){
    exit 1;
}
my $oneMpOptions = $$mpsOptions{$mp};
if(!defined($oneMpOptions)){
    exit 1;
}
my $access = $$oneMpOptions{"access"};
if (defined($access) && $access eq "ro") {
    #1 volume is readonly (which the directory is included)
    print "false\n";
    print "$mp\n";
    exit 0;
}

my ($scheduleList,$errCode) = $volumeCommon->getSnapshotScheduleList($mp);
if (defined($errCode)) {
    $comm->writeErrMsg("$errCode",__FILE__,__LINE__+1);
    exit 1;
}    

if(scalar(@$scheduleList) > 0){
   #2 snapshot schedule has  existed
    print "false\n";
}else{
    print "true\n";
}
print "$mp\n";
exit 0;
