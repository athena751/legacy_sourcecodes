#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_getPairList.pl,v 1.7 2008/05/30 02:14:28 pizb Exp $"
## Function:
##     get all pair info for pair list page
##
## Parameters:
##     none.
##
## Output:
##     STDOUT
##        usage=***
##        mvName=***
##        rvName=***
##        syncState=***|--
##        progressRate=0~100|--
##        syncStartTime=***|--
##        schedule=***|--
##        status=***|--
##        mvResultCode=***|--
##        rvResultCode=***|--
##        schedResultCode=***|--
##        mvLdNameList=***|--
##        rvLdNameList=***|--
##        copyControlState=***|--
##        [blank line]
##     STDERR
##          error message and error code
##
## Returns:
##     0 -- success
##     1 -- failed
use strict;

use NS::DdrCommon;
use NS::DdrConst;

################################################################
## declare global variable.
my $ddrCommon       = new NS::DdrCommon;
my $ddrConst        = new NS::DdrConst;
my $operatingCode   = $ddrConst->OPERATING_CODE;
my $operatedCode    = $ddrConst->OPERATED_CODE;
my $operateStopCode = $ddrConst->OPERATE_STOP_CODE;
my $processDiedCode = $ddrConst->DDR_EXCEP_PROCESS_HAS_DIED;
my $err_code;

################################################################
## get mv and rv names.
my $mvRvNameListHashRef;
( $mvRvNameListHashRef, $err_code ) = $ddrCommon->getMvRvNameList();
if ( defined($err_code) ) {
    $ddrConst->printErrMsg( $err_code, __FILE__, __LINE__ + 1 );
    exit 1;
}

################################################################
## get all Async pair info from file [/opt/nec/nsadmin/etc/ddr_asyncfile].
my $asyncPairListHashRef = $ddrCommon->getAsyncPairListHash( $ddrConst->ASYNCPAIR_FILE );
if ( exists( $$asyncPairListHashRef{ $ddrConst->ERR_FLAG } ) ) {
    $ddrConst->printErrMsg( $$asyncPairListHashRef{ $ddrConst->ERR_FLAG }, __FILE__, __LINE__ + 1 );
    exit 1;
}

################################################################
## get all uniq mv name list which contains sync and async pairs.
my @mvNameList = keys %{$mvRvNameListHashRef};
push( @mvNameList, keys %{$asyncPairListHashRef} );
my %seen = ();
@mvNameList = grep { !$seen{$_}++ } @mvNameList;

## there is no pair.
if ( scalar(@mvNameList) == 0 ) {
    exit 0;
}

################################################################
## get all ld info which contains ld capacity.
my $ldInfoListHashRef = $ddrCommon->getRepl2LdInfo();
if ( defined( $ldInfoListHashRef->{ $ddrConst->ERR_FLAG } ) ) {
    $ddrConst->printErrMsg( $ldInfoListHashRef->{ $ddrConst->ERR_FLAG }, __FILE__, __LINE__ + 1 );
    exit 1;
}

################################################################
## get all schedule info.
my $cmd          = $ddrConst->CMD_REPL2_SCHED_LIST;
my @scheduleInfo = `$cmd 2>/dev/null`;
if ( $? != 0 ) {
    @scheduleInfo = ( $ddrConst->ERR_EXECUTE_REPL2_SCHED_LIST );
}

################################################################
## get all vgLdName info.
my $vgLdNameInfoHashRef = $ddrCommon->getVgLdNameInfoHash();
if ( exists( $$vgLdNameInfoHashRef{ $ddrConst->ERR_FLAG } ) ) {
    $ddrConst->printErrMsg( $$vgLdNameInfoHashRef{ $ddrConst->ERR_FLAG }, __FILE__, __LINE__ + 1 );
    exit 1;
}

################################################################
## get the pair info by mv Name.
foreach ( sort @mvNameList ) {
    ################################################################
    ## init MV Name as current mv, init other pair info as "--".
    my $currentUsage            = "--";
    my $currentMvName           = $_;
    my $currentRvName           = "--";
    my $currentActivityState    = "--";
    my $currentSyncState        = "--";
    my $currentProgressRate     = "--";
    my $currentStartTime        = "--";
    my $currentEndTime          = "--";
    my $currentSchedule         = "--";
    my $currentStatus           = "--";
    my $currentMvResultCode     = "--";
    my $currentRvResultCode     = "--";
    my $currentSchedResultCode  = "--";
    my $currentMvLdNameList     = "--";
    my $currentRvLdNameList     = "--";
    my $currentCopyControlState = "--";

    my $currentAsyncPairHash = $$asyncPairListHashRef{$currentMvName};
    ################################################################
    ## the current mv is asynchronism.
    if ( defined($currentAsyncPairHash) ) {
        my $action = $$currentAsyncPairHash{"action"};

        ################################################################
        ## if mv's asynchronism action is [create].
        if ( $action eq $ddrConst->PAIRINFO_STATUS_CREATE ) {
            ################################################################
            ## set the usage of current sync pair, initialize it as "always".
            $currentUsage = $ddrConst->USAGE_ALWAYS;

            my $rvNumber = 0;
            for ( my $j = 0 ; $j < 3 ; $j++ ) {
                my $rvKey = "rv" . $j;
                if ( exists( $$currentAsyncPairHash{$rvKey} ) ) {
                    $rvNumber++;
                }
            }

            ## the current mv has more than 1 RV.
            if ( $rvNumber > 1 ) {
                ## modify the usage of current Async pair to "generation"
                $currentUsage = $ddrConst->USAGE_GENERATION;

                ################################################################
                ## set the schedule of current Async pair.
                if ( $$currentAsyncPairHash{"sched"} =~ /^\s*(.+)\s*:\s*(\S+)\s*$/ ) {
                    $currentSchedule        = $1;
                    $currentSchedResultCode = $2;
                    ## set the status of current mv as "createschedfail".
                    if ( $currentSchedResultCode !~ /$operatingCode|$operateStopCode|$operatedCode|$processDiedCode/ ) {
                        $currentStatus = $ddrConst->PAIRINFO_STATUS_CREATE_SCHED_FAIL;
                    }
                }
            }
            else {
                $currentSchedule = "";
            }

            ################################################################
            ## print the pair info of current mv.
            for ( my $j = 0 ; $j < 3 ; $j++ ) {
                my $rvKey     = "rv" . $j;
                my $currentRv = $$currentAsyncPairHash{$rvKey};
                if ( defined($currentRv) && $currentRv =~ /^\s*(\S+)\s+.*?:\s*(\S+)\s*$/ ) {
                    $currentRvName       = $1;
                    $currentRvResultCode = $2;
                    
                    if ( $currentStatus ne $ddrConst->PAIRINFO_STATUS_CREATE_SCHED_FAIL ) {
                        $currentStatus = "--";
                    }
                    ## modify the error code if exists and modify the status as [create fail].
                    ## set the status of current rv.
                    if ( $currentStatus eq "--" ) {
                        ## set the status as [creating].
                        if ( $currentSchedResultCode =~ /$operatingCode/ 
                                || $currentRvResultCode =~ /$operatingCode/ ) {
                            $currentStatus = $ddrConst->PAIRINFO_STATUS_CREATING;
                        }
                        ## set the status as [created].
                        elsif ( $currentRvResultCode =~ /$operatedCode/ ) {
                            $currentStatus = $ddrConst->PAIRINFO_STATUS_CREATED;
                        }
                        ## set the status as [createfail].
                        elsif ( $currentRvResultCode !~ /$operatingCode|$operatedCode/ ) {
                            $currentStatus = $ddrConst->PAIRINFO_STATUS_CREATE_FAIL;
                        }
                    }

                    print "usage=$currentUsage\n";
                    print "mvName=$currentMvName\n";
                    print "rvName=$currentRvName\n";
                    print "syncState=--\n";
                    print "progressRate=--\n";
                    print "syncStartTime=--\n";
                    print "schedule=$currentSchedule\n";
                    print "status=$currentStatus\n";
                    print "mvResultCode=--\n";
                    print "rvResultCode=$currentRvResultCode\n";
                    print "schedResultCode=$currentSchedResultCode\n";
                    print "mvLdNameList=--\n";
                    print "rvLdNameList=--\n";
                    print "copyControlState=--\n";
                    print "\n";
                }
            }
            next;
        }

        ################################################################
        ## if mv's asynchronism action is [extend].
        if ( $action eq $ddrConst->PAIRINFO_STATUS_EXTEND ) {
            ## get the rvNameListAry reference of current mv.
            my $rvNameListAryRef = $mvRvNameListHashRef->{$currentMvName};

            ## if current mv is not in the result [list vol], which means
            ## the current mv is recorded incorrectly, so filter it.
            next if ( !defined($rvNameListAryRef) );

            ## set the usage of current mv.
            $currentUsage = $ddrCommon->getUsage($rvNameListAryRef);

            ## set the schedule.
            if ( $currentUsage eq $ddrConst->USAGE_ALWAYS ) {
                $currentSchedule = "";
            }
            else {
                $currentSchedule = $ddrCommon->getSchedule( $currentMvName, $rvNameListAryRef, \@scheduleInfo );
            }

            ## set the status as [extendmvfail] if the mv extend failed.
            if ( $$currentAsyncPairHash{"mv"} =~ /^\s*\S+\s*:\s*(\S+)\s*$/ ) {
                $currentMvResultCode = $1;
                ## set the status as [extendmvfail].
                $currentStatus = $ddrConst->PAIRINFO_STATUS_EXTEND_MV_FAIL if ( $currentMvResultCode !~ /$operatingCode|$operatedCode/ );
            }

            ################################################################
            ## print the pair info of current mv.
            foreach $currentRvName ( sort @$rvNameListAryRef ) {
                $currentMvLdNameList = "--";
                $currentRvLdNameList = "--";
                $currentRvResultCode = "--";
                if ( $currentStatus ne $ddrConst->PAIRINFO_STATUS_EXTEND_MV_FAIL ) {
                    $currentStatus = "--";
                }
                
                my $ldPairListOfVolPair;
                ## get the ldpair list of current vol pair.
                ( $ldPairListOfVolPair, $err_code ) = $ddrCommon->getLdPairListOfVolPair( $currentMvName, $currentRvName );
                if ( !defined($err_code) ) {
                    ( $currentMvLdNameList, $currentRvLdNameList ) = $ddrCommon->getLdNameListOfVolPair($ldPairListOfVolPair);
                }
                ################################################################
                ## set current rv's result code and status according to async file.
                for ( my $j = 0 ; $j < 3 ; $j++ ) {
                    my $rvKey     = "rv" . $j;
                    my $currentRv = $$currentAsyncPairHash{$rvKey};
                    if ( defined($currentRv) && $currentRv =~ /^\s*$currentRvName\s+.*?:\s*(\S+)\s*$/ ) {
                        $currentRvResultCode = $1;
                        if ( $currentStatus eq "--" ) {
                            $currentStatus = $ddrConst->PAIRINFO_STATUS_EXTENDING if ( $currentRvResultCode =~ /$operatingCode/ );
                            $currentStatus = $ddrConst->PAIRINFO_STATUS_EXTENDED  if ( $currentRvResultCode =~ /$operatedCode/ );
                            $currentStatus = $ddrConst->PAIRINFO_STATUS_EXTEND_FAIL if ( $currentRvResultCode !~ /$operatingCode|$operatedCode/ );
                        }
                        last;
                    }
                }

                print "usage=$currentUsage\n";
                print "mvName=$currentMvName\n";
                print "rvName=$currentRvName\n";
                print "syncState=--\n";
                print "progressRate=--\n";
                print "syncStartTime=--\n";
                print "schedule=$currentSchedule\n";
                print "status=$currentStatus\n";
                print "mvResultCode=$currentMvResultCode\n";
                print "rvResultCode=$currentRvResultCode\n";
                print "schedResultCode=--\n";
                print "mvLdNameList=$currentMvLdNameList\n";
                print "rvLdNameList=$currentRvLdNameList\n";
                print "copyControlState=--\n";
                print "\n";
            }
            next;
        }
    }

    ################################################################
    ## the current mv is not asynchronism.

    ## get the rvNameListAry reference of current mv.
    my $rvNameListAryRef = $mvRvNameListHashRef->{$currentMvName};

    ## set the usage of current mv.
    $currentUsage = $ddrCommon->getUsage($rvNameListAryRef);

    ## set the schedule.
    if ( $currentUsage eq $ddrConst->USAGE_ALWAYS ) {
        $currentSchedule = "";
    }
    else {
        $currentSchedule = $ddrCommon->getSchedule( $currentMvName, $rvNameListAryRef, \@scheduleInfo );
    }

    ################################################################
    ## set other pair info according to the result of command
    ## [repl2 info vol pair].
    my %rvPairInfoListHash = ();
    foreach $currentRvName (@$rvNameListAryRef) {
        $currentActivityState    = "--";
        $currentSyncState        = "--";
        $currentStartTime        = "--";
        $currentEndTime          = "--";
        $currentCopyControlState = "--";
        $currentProgressRate     = "--";
        $currentMvLdNameList     = "--";
        $currentRvLdNameList     = "--";
        $currentStatus           = "--";
        $currentRvResultCode     = "--";
        
        my $ldPairListOfVolPair;
        ## get the ldpair list of current vol pair.
        ( $ldPairListOfVolPair, $err_code ) = $ddrCommon->getLdPairListOfVolPair( $currentMvName, $currentRvName );

        if ( !defined($err_code) ) {
            $currentActivityState    = $ddrCommon->getActivityState($ldPairListOfVolPair);
            $currentSyncState        = $ddrCommon->getSyncState($ldPairListOfVolPair);
            $currentStartTime        = $ddrCommon->getStartTime($ldPairListOfVolPair);
            $currentEndTime          = $ddrCommon->getEndTime($ldPairListOfVolPair);
            $currentCopyControlState = $ddrCommon->getCopyControlState($ldPairListOfVolPair);
            $currentProgressRate     = $ddrCommon->getProgressRate( $ldPairListOfVolPair, $ldInfoListHashRef, $currentActivityState );
            ( $currentMvLdNameList, $currentRvLdNameList ) = $ddrCommon->getLdNameListOfVolPair($ldPairListOfVolPair);

            ## when the sync state is replicated or restored,
            ## set the progress to "", sync start time to "".
            if ( $currentSyncState eq $ddrConst->SYNCSTATE_RPL_SYNC || $currentSyncState eq $ddrConst->SYNCSTATE_RST_SYNC ) {
                $currentProgressRate = "";
                $currentStartTime    = "";
            }

            my $vgLdNameList = $$vgLdNameInfoHashRef{$currentMvName};
            ## when the current pair is abnormal, set its status as [abnormalcomposition],
            ## set its result code as [0x137fcccc]
            if ( !defined($vgLdNameList) || $ddrCommon->isPairAbnormal( $vgLdNameList, $currentMvLdNameList ) != 0 ) {
                $currentStatus       = $ddrConst->PAIRINFO_STATUS_ABNORMAL_COMPOSITION;
                $currentRvResultCode = $ddrConst->DDR_EXCEP_ABNORMAL_COMPOSITION;
            }
        }

        ## store the info for print then.
        my %rvPairInfoHash = ();
        $rvPairInfoListHash{$currentRvName} = \%rvPairInfoHash;
        
        $rvPairInfoHash{ $ddrConst->PAIRINFO_USAGE }            = $currentUsage;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_MVNAME }           = $currentMvName;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_RVNAME }           = $currentRvName;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_SYNCSTATE }        = $currentSyncState;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_PROGRESSRATE }     = $currentProgressRate;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_STARTTIME }        = $currentStartTime;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_ENDTIME }          = $currentEndTime;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_SCHEDULE }         = $currentSchedule;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_STATUS }           = $currentStatus;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_RV_RESULT_CODE }   = $currentRvResultCode;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_MVLDNAMELIST }     = $currentMvLdNameList;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_RVLDNAMELIST }     = $currentRvLdNameList;
        $rvPairInfoHash{ $ddrConst->PAIRINFO_COPYCONTROLSTATE } = $currentCopyControlState;
    }

    ################################################################
    ## sort the rv name list and then print.
    my $sortedRvNameList = &getSortedRvNameList( \%rvPairInfoListHash );
    foreach $currentRvName (@$sortedRvNameList) {
        my $rvPairInfoHash = $rvPairInfoListHash{$currentRvName};
        print "usage=$$rvPairInfoHash{ $ddrConst->PAIRINFO_USAGE }\n";
        print "mvName=$$rvPairInfoHash{ $ddrConst->PAIRINFO_MVNAME }\n";
        print "rvName=$$rvPairInfoHash{ $ddrConst->PAIRINFO_RVNAME }\n";
        print "syncState=$$rvPairInfoHash{ $ddrConst->PAIRINFO_SYNCSTATE }\n";
        print "progressRate=$$rvPairInfoHash{ $ddrConst->PAIRINFO_PROGRESSRATE }\n";
        print "syncStartTime=$$rvPairInfoHash{ $ddrConst->PAIRINFO_STARTTIME }\n";
        print "schedule=$$rvPairInfoHash{ $ddrConst->PAIRINFO_SCHEDULE }\n";
        print "status=$$rvPairInfoHash{ $ddrConst->PAIRINFO_STATUS }\n";
        print "mvResultCode=--\n";
        print "rvResultCode=$$rvPairInfoHash{ $ddrConst->PAIRINFO_RV_RESULT_CODE }\n";
        print "schedResultCode=--\n";
        print "mvLdNameList=$$rvPairInfoHash{ $ddrConst->PAIRINFO_MVLDNAMELIST }\n";
        print "rvLdNameList=$$rvPairInfoHash{ $ddrConst->PAIRINFO_RVLDNAMELIST }\n";
        print "copyControlState=$$rvPairInfoHash{ $ddrConst->PAIRINFO_COPYCONTROLSTATE }\n";
        print "\n";
    }
}

exit 0;

##
# @Function
#   apply a comparator for sort rv name, the rule is like this:
#   1. when the sync state is [***ing] (if there is more than one pair, the sequence
#      is RV0->RV1->RV2).
#      ##: [***ing] contains 
#               a. sep/exec separating
#               b. rpl/sync replicated
#               c. rpl/exec replicating
#               d. rst/sync restored
#               e. rst/exec restoring
#   2. when the sync state is [separated] and the start time is [--] ( if there is more
#      than one pair, the sequence is RV0->RV1->RV2).
#   3. when the sync state is [separated] and the start time is not [--] ( if there is more
#      than one pair, the sequence is according to the end time. the earliest will be first).
#   4. when the sync state is [cancel] or [fault] ( if there is more than one pair, the 
#      sequence is RV0->RV1->RV2).
# @param
#   {hash ref}  $rvPairInfoListHash   : the key is rvname.
# @return (\@rvNameList)
#   {array ref}
##
sub getSortedRvNameList() {
    my $rvPairInfoListHash = shift;
    
    ## store the [***ing], replicated, restored rv.
    my @unSeparatedRvList = ();
    ## store the separated rv whose start time is [--].
    my @unSyncRvList = ();
    ## store the separated normally rv.
    my @normalSeparatedRvList = ();
    ## store the separated abnormally rv.
    my @abnormalSeparatedRvList = ();
    ## store the unknown state rv.
    my @unknownRvList = ();
    
    while ( my ( $rvName, $rvPairInfoHash ) = each %$rvPairInfoListHash ) {
        my $copyControlState = $$rvPairInfoHash{ $ddrConst->PAIRINFO_COPYCONTROLSTATE };
        my $syncState = $$rvPairInfoHash{ $ddrConst->PAIRINFO_SYNCSTATE };
        my $syncStartTime = $$rvPairInfoHash{ $ddrConst->PAIRINFO_STARTTIME };
        
        if ( $copyControlState eq $ddrConst->COPYCONTROLSTATE_ABNORMAL_SUSPEND
                || $syncState eq $ddrConst->SYNCSTATE_CANCEL
                || $syncState eq $ddrConst->SYNCSTATE_FAULT ) {
            push ( @abnormalSeparatedRvList, $rvName );
        }
        elsif ( $syncState eq $ddrConst->SYNCSTATE_RPL_SYNC 
                || $syncState eq $ddrConst->SYNCSTATE_RST_SYNC
                || $syncState eq $ddrConst->SYNCSTATE_SEP_EXEC
                || $syncState eq $ddrConst->SYNCSTATE_RPL_EXEC
                || $syncState eq $ddrConst->SYNCSTATE_RST_EXEC ) {
            push ( @unSeparatedRvList, $rvName );
        }
        elsif ( $syncState eq $ddrConst->SYNCSTATE_SEPARATED && $syncStartTime eq "--" ) {
            push ( @unSyncRvList, $rvName );
        }
        elsif ( $syncState eq $ddrConst->SYNCSTATE_SEPARATED && $syncStartTime ne "--" ) {
            push ( @normalSeparatedRvList, $rvName );
        }
        else {
            push ( @unknownRvList, $rvName );
        }
    }
    
    @unSeparatedRvList = sort @unSeparatedRvList;
    @unSyncRvList = sort @unSyncRvList;
    @normalSeparatedRvList = sort @normalSeparatedRvList;
    @normalSeparatedRvList = sort { $$rvPairInfoListHash{$a}{$ddrConst->PAIRINFO_ENDTIME} cmp $$rvPairInfoListHash{$b}{$ddrConst->PAIRINFO_ENDTIME} } @normalSeparatedRvList;
    @abnormalSeparatedRvList = sort @abnormalSeparatedRvList;
    @unknownRvList = sort @unknownRvList;
    
    my @rvNameList = (@unSeparatedRvList, @unSyncRvList, @normalSeparatedRvList, @abnormalSeparatedRvList, @unknownRvList);

    return \@rvNameList;
}
