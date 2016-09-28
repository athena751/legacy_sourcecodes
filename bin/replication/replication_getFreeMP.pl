#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_getFreeMP.pl,v 1.3 2008/05/24 12:08:36 liuyq Exp $"

## Function:
##     get free mount point for original and replica
##
## Parameters:
##     $exportGroup	 -- export  group
##	   $oriOrReplica -- flag, indacate the free mount point is for original or replica 
##  
## Output:
##     STDOUT
##         mountPoint=***
##		   volumeName=***
##	       fsType=sxfs|sxfsfw
##     STDERR
##         error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::ReplicationConst;
use NS::ReplicationCommon;
use NS::DdrCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $repliConst = new NS::ReplicationConst;
my $repliCommon  = new NS::ReplicationCommon;
my $ddrCommon    = new NS::DdrCommon;

if(scalar(@ARGV) != 2){
     $repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT, __FILE__, __LINE__ + 1);
     exit 1;
}

my ($exportGroup, $oriOrReplica) = @ARGV;

my $mpsOption = $volumeCommon->getMountOptionsFromCfstab();
if(defined($$mpsOption{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$mpsOption{$volumeConst->ERR_FLAG});
    exit 1;
}

my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds();
my $pairLds = {%$mvLdHash, %$rvLdHash};
my $vgLdhash = $repliCommon->getVgLdsFromVgassign();

my @validMP = grep(/^\Q$exportGroup\E\/+\S+/, keys(%$mpsOption));
if(scalar(@validMP) == 0){
    exit 0;
}

## get mounted  mount point
my $mountMP = $volumeCommon->getMountMP();
if (defined($$mountMP{$volumeConst->ERR_FLAG})) {
    $volumeConst->printErrMsg($$mountMP{$volumeConst->ERR_FLAG});
    exit 1;
}

## get replic mount point and original mount point
my ($exportsMP, $importsMP, $errCode) = $volumeCommon->getReplicationMP();
if (defined($errCode)) {
    $volumeConst->printErrMsg($errCode);
    exit 1;
}


## get free mount point info
foreach (sort @validMP) {

        ## get mount point
        my $mp = $_;
        
        ## get $lvPath, $fsType, $access
        my $mpOption = $$mpsOption{$mp};
        my $lvPath = $$mpOption{"lvpath"};
        my $fsType = $$mpOption{"ftype"};
        my $access = $$mpOption{"access"};
        ## get volume name
        my $volumeName = (split(/\//, $lvPath))[3];
        
        if(($oriOrReplica eq "original") && ($access eq "ro")){
            next;
        } 
        
        ##the mp  used in DDR will be not list . lyb  2006.6.6
        my $ldpathList = $$vgLdhash{$volumeName};
        if(!defined($ldpathList)) {
            next; ## the volume is not managed.   
        }
        my $retVgpaircheck = $repliCommon->ldpaircheck($ldpathList, $pairLds);
        if($retVgpaircheck == 0 ){
            next;
        }
        
        
        ## must be mounted , syncfs
        if (!defined($$mountMP{$mp}) 
            || !defined($$mpOption{"repli"})) {
            next;
        }
        ## can not be original or replic
        if(defined($$importsMP{$mp}) 
           || defined($$exportsMP{$mp})){
            next;
        }
        
        my $retVal = $volumeCommon->hasChild($mp);
        if($retVal =~ /^0x108000/){
            $volumeConst->printErrMsg($retVal);
            exit 1;
        }elsif($retVal == 0){
            next;
        }
    
        $volumeName =~ s/NV_LVM_//;

        ## print free mount point info
        print "mountPoint=$mp\n";
        print "volumeName=$volumeName\n";
        print "fsType=$fsType\n";
        print "\n";
} ## end of foreach 

exit 0;