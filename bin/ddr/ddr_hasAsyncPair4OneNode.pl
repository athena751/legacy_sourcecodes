#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: ddr_hasAsyncPair4OneNode.pl,v 1.2 2008/04/26 06:08:11 xingyh Exp $"
#
#Function:
#       Check whether has async operation or not in one node.
#Arguments:
#       null
#exit code:
#       0:succeeded
#       1:failed
#output:
#       $action $mv $result\n
#           ($action : create or extend)
#           ($mv     : mv name)
#           ($result : 0x137f0000 or 0x137fffff or error code)
use strict;

use NS::DdrCommon;
use NS::DdrConst;
use NS::SystemFileCVS;
use NS::VolumeCommon;

my $ddrCommon = new NS::DdrCommon;
my $ddrConst = new NS::DdrConst;
my $fileCommon = new NS::SystemFileCVS;
my $volumeCommon = new NS::VolumeCommon;

if(scalar(@ARGV) != 0){
    $ddrConst->printErrMsg($ddrConst->DDR_EXCEP_WRONG_PARAMETER , __FILE__, __LINE__ + 1);
    exit 1;
}
my $asyncPairFile = $ddrConst->ASYNCPAIR_FILE;
my $asyncPairListHash = $ddrCommon->getAsyncPairListHash($asyncPairFile);

if(defined($$asyncPairListHash{$ddrConst->ERR_FLAG})){
    $ddrConst->printErrMsg($$asyncPairListHash{$ddrConst->ERR_FLAG} , __FILE__, __LINE__ + 1);
    exit 1;
}
my $hasActiveAsync = 0;
my $cmd_ps  = "/bin/ps -ef --cols 500 2>/dev/null";
my @retVal = `$cmd_ps`;
my $makePair  = "/usr/bin/perl -w ".$ddrConst->SCRIPT_DDR_MAKE_PAIR;
my $extendPair = "/usr/bin/perl -w ".$ddrConst->SCRIPT_DDR_EXTEND_PAIR;
if(scalar(grep(/$makePair/, @retVal)) >0 || scalar(grep(/$extendPair/, @retVal)) > 0){
    $hasActiveAsync = 1;
}

my $needModify = 0;

my $createStatus = $ddrConst->PAIRINFO_STATUS_CREATE;
my $extendStatus = $ddrConst->PAIRINFO_STATUS_EXTEND;
my $doing        = $ddrConst->OPERATING_CODE;
my $done         = $ddrConst->OPERATED_CODE;
my $stopped      = $ddrConst->DDR_EXCEP_PROCESS_HAS_DIED;

my @resultArray = ();
foreach(keys %$asyncPairListHash){
    
    my $oneAsync = $$asyncPairListHash{$_};
    my $result = $doing;
    my ($mvName, $mvResult, $rv0Result, $rv1Result, $rv2Result, $schedResult);
    my $action = $$oneAsync{"action"};
    
    if(defined($action)){
        if($action eq $createStatus){
            if(defined($$oneAsync{"mv"}) && $$oneAsync{"mv"} =~ /^\s*(\S+)\s*:\s*(\S+)\s*$/){
                $mvName = $1;
            }else{
                next;
            }
            if(defined($$oneAsync{"sched"}) && $$oneAsync{"sched"} =~ /:\s*(\S+)\s*$/){
                 $schedResult = $1;
            }
            
        }elsif($action eq $extendStatus){
            if(defined($$oneAsync{"mv"}) && $$oneAsync{"mv"} =~ /^\s*(\S+)\s*:\s*(\S+)\s*$/){
                $mvName = $1;
                $mvResult = $2;
            }else{
                next;
            }
        }else{
            next;
        }
        
        if($result eq $doing){
            if(defined($$oneAsync{"rv0"}) && $$oneAsync{"rv0"} =~ /:\s*(\S+)\s*$/){
                $rv0Result = $1;
            }
            if(defined($$oneAsync{"rv1"}) && $$oneAsync{"rv1"} =~ /:\s*(\S+)\s*$/){
                $rv1Result = $1;
            }
            if(defined($$oneAsync{"rv2"}) && $$oneAsync{"rv2"} =~ /:\s*(\S+)\s*$/){
                $rv2Result = $1;
            }
            
            if(($action eq $extendStatus) && ($mvResult ne $doing) && ($mvResult ne $done)){
                #mv extend failed
                $result = $mvResult;
            }elsif(defined($rv0Result) && ($rv0Result ne $doing) && ($rv0Result ne $done)){
                $result = $rv0Result;
            }elsif(defined($rv1Result) && ($rv1Result ne $doing) && ($rv1Result ne $done)){
                $result = $rv1Result;
            }elsif(defined($rv2Result) && ($rv2Result ne $doing) && ($rv2Result ne $done)){
                $result = $rv2Result;
            }elsif(($action eq $createStatus) && defined($schedResult) && ($schedResult ne $doing) && ($schedResult ne $done)){
                $result = $schedResult;
            }
        }
        if(($hasActiveAsync == 0)&& ($result eq $doing)){
            $result = $stopped;
            &modifyResult2Stop($oneAsync);
            $needModify = 1;
        }
        push(@resultArray, "$mvName $result\n");
    }
}

print @resultArray;
if($needModify == 1 && $fileCommon->checkout($asyncPairFile) == 0){
    if ($volumeCommon->writeAsyncVolToFile($asyncPairListHash, $asyncPairFile) != 0 || $fileCommon->checkin($asyncPairFile) != 0){
        $fileCommon->rollback($asyncPairFile);
        $ddrConst->writeLog($ddrConst->ERR_EDIT_DDR_ASYNCFILE);
    }
}else{
	if($needModify == 1){
	    $ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKOUT);
	}
   
}
exit 0;

sub modifyResult2Stop(){
    my $oneAsynPairHash = shift;
    foreach(keys %$oneAsynPairHash){
        $$oneAsynPairHash{$_} =~ s/:\s*$doing\s*/:$stopped/;
    }
}

