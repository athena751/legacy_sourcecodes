#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lic_gettotalfscapacity.pl,v 1.6 2007/09/06 08:26:22 liy Exp $"

###Function: get total size of all volume that has a record in /etc/group0/cfstab and /etc/group1/cfstab
###          
###Parameter:
###         no
###Return:
###         0  --- normal execute
###         1  --- error occurs when  execute
###         2  --- time out parameter wrong
###Output:
###     total size of all volume
###User: root,nsgui

use strict;
use NS::NsguiCommon;
use NS::VolumeConst;
use NS::LicenseConst;
use Getopt::Long;

my %optHash;
## get ARGS
if(!GetOptions(\%optHash,"t=s","p")){
    exit 2;
}
my $timeout = $optHash{'t'};
if(defined($timeout) && $timeout !~ /^\d+$/){
    exit 2;	
}


my $nsguiCommon = new NS::NsguiCommon;
my $volConst = new NS::VolumeConst;
my $const = new NS::LicenseConst;
my %volumeHash = ();
my %dfHash = ();

my $CMD_CAT = $volConst->CMD_CAT;
my $cmd_dfInfo = $volConst->CMD_DF;
my $cmd_rvInfo = $volConst->CMD_RV;
if($optHash{'p'}){
    $cmd_rvInfo = $volConst->CMD_RVCORRECT; 
}
my $CFSTAB0 = $volConst->FILE_CFSTAB_NODE0;
my $CFSTAB1 = $volConst->FILE_CFSTAB_NODE1;
my $cmd_vol = "$CMD_CAT $CFSTAB0 $CFSTAB1";

my @vol = `${cmd_vol} 2>/dev/null`;
my $rvInfo = `sudo ${cmd_rvInfo} 2>/dev/null`;
my $dfInfo = `${cmd_dfInfo}  2>/dev/null`;

if($? != 0){
    $volConst->printErrMsg($volConst->ERR_EXECUTE_DF);
    exit 1;
}

my $rvCapacity = &getRvCapacity($rvInfo);

my $friendIP = $nsguiCommon->getFriendIP();
if(defined($friendIP)){
    my $retVal = $nsguiCommon->isActive($friendIP);## check friend node is active
    if($retVal == 0){
        my ($retVol,$rshVol) = $nsguiCommon->rshCmdTimeoutWithSTDOUT($cmd_vol, $friendIP, $timeout);
        my ($retDf,$rshDfInfo) = $nsguiCommon->rshCmdTimeoutWithSTDOUT($cmd_dfInfo, $friendIP, $timeout);
        my $retRv;
        ($retRv,$rvInfo) =  $nsguiCommon->rshCmdTimeoutWithSTDOUT("sudo ${cmd_rvInfo} 2>/dev/null", $friendIP, $timeout);
        if(defined($rshVol) && defined($rshDfInfo)&&defined($rvInfo)){
            push(@vol,@$rshVol);
            &setDfInfo2Hash(join("",@$rshDfInfo),\%dfHash);
            $rvCapacity = $rvCapacity + &getRvCapacity(join("",@$rvInfo));
        }
    }
}

##merge into HashTable 
for(my $i=0;$i<scalar(@vol);$i++){
    my @v = split(/\s+/,$vol[$i]);
    $volumeHash{$v[1]} = "";
}

##merge into HashTable
&setDfInfo2Hash($dfInfo,\%dfHash);

##get sum of all volume
my $sum = 0;
while ((my $v, my $size) = each(%dfHash)) {
    ## count total size of volumes that has a record in volume configure file
    if (exists ($volumeHash{$v})){
        $sum += $size;
    }
}
$sum = $sum / (1024*1024);
$sum = $sum + $rvCapacity/1024;
if($sum =~ /^\d+$/){
    print $sum.".0";
}
else{
    print ($nsguiCommon->deleteAfterPoint($sum,1));
}
print "\n";
exit 0;

###Function: get the volume mountpoint and size by output of [/bin/df] command,and set them into HashTable
###Parameter:
###         output of [/bin/df] command
###Return:
###      none
sub setDfInfo2Hash(){
    my ($retVal,$hash) = @_;
    $retVal =~s/\n/ /;
    my @dfVal = split (/\s+/, $retVal);
    splice(@dfVal,0,7);
    for (my $i=0; $i<@dfVal; $i+=6 ){
        $$hash{$dfVal[$i + 5]} = $dfVal[$i+1];
    }
}
###Function: get the volume mountpoint and size by output of [/sbin/dfrv_correct] command
###Parameter:
###         output of [/sbin/dfrv_correct] command
###Return:
###      total capcacity of rvs in rv information
sub getRvCapacity(){
    my ($rvInfo) = @_;
    my $sum = 0;
    $rvInfo =~s/\n/ /;
    my @rvInfos = split (/\s+/, $rvInfo);
    splice(@rvInfos,0,3);
    for (my $i=0; $i<scalar(@rvInfos); $i+=2 ){
        $sum = $sum + $rvInfos[$i];
    }
    return $sum;   
}