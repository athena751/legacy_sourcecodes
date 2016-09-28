#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getpoolldlistfromfsbatch.pl,v 1.1 2008/11/26 09:15:21 chenb Exp $"
# Function:
#       Get the number of pool or ld which is for the volume of creating or extending.
# Parameters:
#       aname :  the name of disk array.
#       flag :   "GET_POOL" or "GET_LD"
#       ifRsh :  1 -- It's necessary to run on friend node.
#                0 -- It's not necessary to run on friend node.
# output:
#       @outputList : pool number list or ld list
#
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;
use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::NsguiCommon;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $nsguiCommon  = new NS::NsguiCommon;

if(scalar(@ARGV) != 3){
     $volumeConst->printErrMsg($volumeConst->ERR_PARAM_WRONG_NUM);
     exit 1;
}

my $aname = shift;
my $flag = shift;
my $ifRsh = shift;

my $tmpFile = $volumeConst->FILE_ASYNC_TMP;
my $cmd_getPoolLd_friendNode = "sudo /opt/nec/nsadmin/bin/disk_getpoolldlistfromfsbatch.pl $aname $flag 0";
my @outputList=();
my $async_hash = $volumeCommon->getAsyncVolFromFile($tmpFile);
if(defined($$async_hash{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$async_hash{$volumeConst->ERR_FLAG});
    exit 1;
}
#get pool number list or ld list from this node.
foreach(keys %$async_hash){
    my $oneAsync = $$async_hash{$_};
    if(defined($$oneAsync{"disklist"}) && defined($$oneAsync{"resultCode"}) && $$oneAsync{"resultCode"} eq $volumeConst->SUCCESS_CODE){
        my @poolInfo = split(",", $$oneAsync{"disklist"});
        foreach(@poolInfo){
            my @tmpPool = split("#", $_);
            if( $tmpPool[1] eq $aname ){
                if( $flag eq "GET_POOL" ){
                    push(@outputList,$tmpPool[3]);
                }elsif(defined($$oneAsync{"ldlist"})){
                    my @ldlist = split("#", $$oneAsync{"ldlist"});
                    foreach(@ldlist){
                        my @tmpLd = split(":", $_);
                        push(@outputList,$tmpLd[1]);
                    }
                }
            }
        }
    }
}
#get pool number list or ld list from friend node.
my $friendIP = $nsguiCommon->getFriendIP();
if ( $ifRsh eq "1" && defined($friendIP) && $nsguiCommon->isActive($friendIP)==0 ){
    my ($ret,$output) = $nsguiCommon->rshCmdWithSTDOUT(${cmd_getPoolLd_friendNode},$friendIP);
    if( defined($ret) && $ret==0 ){
        foreach(@$output){
             chomp($_);
        }
        push(@outputList,@$output);
    }
}
#remove the same contents.
my %tmp_hash=();
@outputList = grep(!$tmp_hash{$_}++, @outputList);
print join("\n",@outputList);
if(scalar(@outputList)!=0){
    print "\n";
}
exit 0;
