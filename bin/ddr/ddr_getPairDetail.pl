#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_getPairDetail.pl,v 1.4 2008/05/04 04:37:16 yangxj Exp $"
## Function:
##     get pair detail info
##
## Parameters:
##     nodeNo -- current node number
##     mvName -- mv's name
##     rvName -- rv's name, more than 1:separated by '#'
##     asyncStatus -- async status
##     rvLdName -- ld's path, format:"rv0ld1:rv0ld2#rv1ld1:rv1ld2"
##
## Output:
##     STDOUT
##		    name=***
##		    node=***
##		    capacity=***
##		    mp=***
##		    aname=***
##		    poolNameAndNo=***(***),***(***)
##		    raidType=***
##		    aid=***
##		    
##		    name=***#***#***
##		    node=***#***#***
##		    poolNameAndNo=***(***),***(***)#***(***),***(***)#***(***),***(***)
##		    raidType=***#***#***
##		    wwnn=***
##     STDERR
##          error message and error code
##
## Returns:
##     0 -- success
##     1 -- failed
use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::DdrCommon;
use NS::DdrConst;

my $nsguiCommon  = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;
my $ddrCommon = new NS::DdrCommon;
my $ddrConst  = new NS::DdrConst;

if(scalar(@ARGV) != 5){
    $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_WRONG_PARAMETER, __FILE__, __LINE__ + 1);
    exit 1;
}

# get param
my $nodeNo = shift;
my $mvName = shift;
my $rvName = shift;
my $asyncStatus = shift;
my $rvLdName = shift;

# pair detail hash
my %pairDetail = ();

# split rvName
my @rvNameArrs = split("#", $rvName);

# get rv ldpath
my @rvLdPathArrs = ();
my $cmd = $ddrConst->CMD_LDNAME_TO_LDDEV;
my @rvLdNameArrs = split("#", $rvLdName);
foreach(@rvLdNameArrs){
    my @rvLdPath = ();
    my @tmpArrs = split(":", $_);
    foreach(@tmpArrs){
        my $rvLdPathTmp = `$cmd $_ 2>/dev/null`;
        chomp($rvLdPathTmp);
        if($rvLdPathTmp ne ""){
            push(@rvLdPath, $rvLdPathTmp);
        }
    }
    if(scalar(@rvLdPath) == 0){
        push(@rvLdPathArrs, "--");
    }else{
        push(@rvLdPathArrs, join(",", @rvLdPath));
    }
}

# get mv group no
my ($mvGroup, $errCode) = $ddrCommon->getGroup($mvName);
if(defined($errCode)){
    $ddrConst->printErrMsg($errCode, __FILE__, __LINE__ + 1);
    exit 1;
}

# get mv node no
my $mvNodeNo = "--";
my $vg_assignPath = "/etc/group".$mvGroup."/vg_assign";
if(-f $vg_assignPath){
    $mvNodeNo = $nodeNo;
}else{
    $mvNodeNo = 1 - $nodeNo;
}

# get mv's mount point
my $cfstabPath = "/etc/group".$mvGroup."/cfstab";
my $cfstabContent;
if(-f $cfstabPath){
    $cfstabContent = $nsguiCommon->getFileContent($cfstabPath);
    if(!defined($cfstabContent)){
        $ddrConst->printErrMsg($ddrConst->ERR_OPEN_FILE_READING, __FILE__, __LINE__ + 1);
        exit 1;
    }
}else{
    $cmd = $ddrConst->CMD_CAT." ".$cfstabPath;
    my $friendIP = $nsguiCommon->getFriendIP();
    if(defined($friendIP)){
        my $exitVal = $nsguiCommon->isActive($friendIP);
        if($exitVal != 0 ){
            $volumeConst->printErrMsg($volumeConst->ERR_FRIEND_NODE_DEACTIVE);
            exit 1;
        }
        (my $ret, $cfstabContent) = $nsguiCommon->rshCmdWithSTDOUT($cmd, $friendIP);
        if(!defined($ret) || ($ret != 0)){
            $ddrConst->printErrMsg($ddrConst->ERR_EXECUTE_CAT_FRIEND, __FILE__, __LINE__ + 1);
            exit 1;
        }
    }
}
$pairDetail{'mvDetail'}{$mvName}{'mp'} = '--';
if(defined($cfstabContent)){
    foreach(@$cfstabContent){
        if($_ =~ /^\s*(?:\/dev\/\S+\Q$mvName\E)\s+(\S+)\s+(?:\S+)\s+(?:\S+)\s+0\s+0\s*$/){
            $pairDetail{'mvDetail'}{$mvName}{'mp'} = $1;
            last;
        }
    }
}

# get ldhardln.conf
# /sbin/vgdisplay -Dv
# get ld detail info
(my $vgLdInfoHash, $errCode) = $ddrCommon->getVgLdInfoHash();
if(defined($errCode)){
    $volumeConst->printErrMsg($errCode);
    exit 1;
}

# get mv 's wwnn,array name,pool,raid type,capacity
my $splitCount;
my ($poolNameAndNo, $raidType, $capacity, $aid, $aname) = $ddrCommon->getStoragePoolInfo($mvName, '', $vgLdInfoHash);
$pairDetail{'mvDetail'}{$mvName}{'capacity'} = $capacity;
$pairDetail{'mvDetail'}{$mvName}{'raidType'} = $raidType;
($poolNameAndNo, $splitCount) = $ddrCommon->compactAndSort($poolNameAndNo);
$pairDetail{'mvDetail'}{$mvName}{'poolNameAndNo'} = $poolNameAndNo;
my @anameArrs = split(",", $aname);
$pairDetail{'mvDetail'}{$mvName}{'aname'} = $anameArrs[0];
($aid, $splitCount) = $ddrCommon->compactAndSort($aid);
$pairDetail{'mvDetail'}{$mvName}{'aid'} = $aid;

# get all async pair info & all pool info
my %poolInfo = ();
my $currentAsyncPairHash = {};
if($asyncStatus eq 'creating' || $asyncStatus eq 'createfail' || $asyncStatus eq 'createschedfail'){
    # get all async pair info
    my $asyncPairListHashRef = $ddrCommon->getAsyncPairListHash($ddrConst->ASYNCPAIR_FILE);
    if (defined($$asyncPairListHashRef{$ddrConst->ERR_FLAG})) {
        $ddrConst->printErrMsg($$asyncPairListHashRef{ $ddrConst->ERR_FLAG }, __FILE__, __LINE__ + 1);
        exit 1;
    }
    $currentAsyncPairHash = $$asyncPairListHashRef{$mvName};
    
    # get all pool info
    my $poolInfoHash = $volumeCommon->getAllPoolInfo();
    if(defined($$poolInfoHash{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$poolInfoHash{$volumeConst->ERR_FLAG});
        exit 1;
    }
    # get pool info of the diskarray specified by $aid
    foreach(keys %$poolInfoHash){
        my ($aidTmp, $poolNo, $poolName);
        if($_ =~ /^\s*(\S+)\((\S+)\)\s*$/){
            $aidTmp = $1;
            $poolNo = $2;
        }
        if($aid ne $aidTmp){
            next;
        }
        my $singlePoolHash = $$poolInfoHash{$_};
        $poolName = $$singlePoolHash{"poolname"};
        $poolInfo{$poolName}->{'poolNameAndNo'} = $poolName.'('.$poolNo.')';
        $poolInfo{$poolName}->{'raidType'} = $$singlePoolHash{"raidtype"};
    }
}

# get rv raid type & pool
my @rvRaidTypeArrs = ();
my @rvPoolArrs = ();
#my @rvGroupArrs = ();
my @rvNodeNoArrs = ();
my @wwnnArrs = ();
for(my $i=0; $i<scalar(@rvNameArrs); $i++){
    # get rv group no
#    (my $rvGroup, $errCode) = $ddrCommon->getGroup($rvNameArrs[$i]);
#    if(defined($errCode)){
#        $ddrConst->printErrMsg($errCode, __FILE__, __LINE__ + 1);
#        exit 1;
#    }
#    push(@rvGroupArrs, $rvGroup);
    push(@rvNodeNoArrs, $nodeNo);
    
    my ($capacity, $aid, $aname, $wwnn);
    
    # async
    if($asyncStatus eq 'creating' || $asyncStatus eq 'createfail' || $asyncStatus eq 'createschedfail'){
        $poolNameAndNo = '--';
        $raidType = '--';
        $rvNameArrs[$i] =~ /^NV_RV(\d)_/;
        my $rvKey = "rv".$1;
        if(defined($$currentAsyncPairHash{$rvKey}) && $$currentAsyncPairHash{$rvKey} =~ /^\s*$rvNameArrs[$i]\s+\S+\((\S+)\)\s*:\s*(\S+)\s*$/){
            my @poolNameArrs = split(",", $1);
            my @poolNameAndNoArrs = ();
            foreach(@poolNameArrs){
                if(defined($poolInfo{$_}->{'poolNameAndNo'})){
                    push(@poolNameAndNoArrs, $poolInfo{$_}->{'poolNameAndNo'});
                }
                if($raidType eq '--' && defined($poolInfo{$_}->{'raidType'})){
                    $raidType = $poolInfo{$_}->{'raidType'};
                }
            }
            if(scalar(@poolNameAndNoArrs) > 0){
                $poolNameAndNo = join(",", @poolNameAndNoArrs);
            }
        }

    }else{
        ($poolNameAndNo, $raidType, $capacity, $aid, $aname, $wwnn) = $ddrCommon->getStoragePoolInfo($rvNameArrs[$i], $rvLdPathArrs[$i], $vgLdInfoHash);
    }

    push(@rvRaidTypeArrs, $raidType);
    ($poolNameAndNo, $splitCount) = $ddrCommon->compactAndSort($poolNameAndNo);
    push(@rvPoolArrs, $poolNameAndNo);
    ($wwnn, $splitCount) = $ddrCommon->compactAndSort($wwnn);
    push(@wwnnArrs, $wwnn);
}
$pairDetail{'rvDetail'}{$rvName}{'raidType'} = join("#", @rvRaidTypeArrs);
$pairDetail{'rvDetail'}{$rvName}{'poolNameAndNo'} = join("#", @rvPoolArrs);
$pairDetail{'rvDetail'}{$rvName}{'node'} = join("#", @rvNodeNoArrs);
$pairDetail{'rvDetail'}{$rvName}{'wwnn'} = join("#", @wwnnArrs);

# print pair detail
print "name=$mvName\n";
print "node=$mvNodeNo\n";
print "capacity=$pairDetail{'mvDetail'}{$mvName}{'capacity'}\n";
print "mp=$pairDetail{'mvDetail'}{$mvName}{'mp'}\n";
print "aname=$pairDetail{'mvDetail'}{$mvName}{'aname'}\n";
print "poolNameAndNo=$pairDetail{'mvDetail'}{$mvName}{'poolNameAndNo'}\n";
print "raidType=$pairDetail{'mvDetail'}{$mvName}{'raidType'}\n";
print "aid=$pairDetail{'mvDetail'}{$mvName}{'aid'}\n";
print "\n";
print "name=$rvName\n";
print "node=$pairDetail{'rvDetail'}{$rvName}{'node'}\n";
print "poolNameAndNo=$pairDetail{'rvDetail'}{$rvName}{'poolNameAndNo'}\n";
print "raidType=$pairDetail{'rvDetail'}{$rvName}{'raidType'}\n";
print "wwnn=$pairDetail{'rvDetail'}{$rvName}{'wwnn'}\n";

exit 0;
