#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: DdrCommon.pm,v 1.13 2008/05/30 07:15:19 liuyq Exp $"

##
# @fileoverview This file is to do something for ddr.
#
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.1.28
# @version 0.1
# @copyright 2008
##
package NS::DdrCommon;
use strict;
use NS::VolumeCommon;
use NS::SystemFileCVS;
use NS::VolumeConst;
use NS::NsguiCommon;
use NS::DdrConst;

my $ddrConst     = new NS::DdrConst;
my $volumeCommon = new NS::VolumeCommon;
my $fileCommon   = new NS::SystemFileCVS;
my $nsguiCommon  = new NS::NsguiCommon;
my $volumeConst  = new NS::VolumeConst;

sub new() {
    my $this = {};    # Create an anonymous hash, and #self points to it.
    bless $this;      # Connect the hash to the package update.
    return $this;     # Return the reference to the hash.
}

##
# @Function
#   This is a function to get the mv and rv'name of all pairs.
# @param
#     {string}      $executeIP: at which the commond will be executed.
# @return (\%mvRvNameListHash, $errCode)
#   {hash ref}      \%mvRvNameListHash  : all mv and rv's name info, if occars error, it will be set to undef.
#     struct:
#       key   : {string}      for example: "NV_LVM_***".
#       value : {array reference} in which stores the rvName.
#         its possible values are :
#           1. %mvRvNameListHash  when no error occars.
#           2. undef        when error occars.
#   {int}     $errCode      : specified error code.
#         its possible values are :
#           1. undef    when no error occars.
#           2. 0x10800095 Friend node is not actived..
#           3. 0x10000004 rsh excute fail.
#           4. 0x13700001 Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 list vol.
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.1.28
##
sub getMvRvNameList() {
    my $self     = shift;
    my $friendIP = shift;

    my $cmd      = $ddrConst->CMD_REPL2_LIST_VOL . " 2>/dev/null";
    my @mvrvInfo = ();
    if ( defined($friendIP) ) {
        ## check status of specified node
        if ( $nsguiCommon->isActive($friendIP) != 0 ) {
            return ( undef, $volumeConst->ERR_FRIEND_NODE_DEACTIVE );
        }

        ## get the mvrvinfo from the specified node
        my ( $exitCode, $mvrvInfoAryRef ) = $nsguiCommon->rshCmdWithSTDOUT( "sudo $cmd", $friendIP );
        if ( !defined($exitCode) ) {
            return ( undef, $nsguiCommon->ERRCODE_RSH_COMMAND_FAILED );
        }

        if ( $exitCode != 0 ) {
            return ( undef, $ddrConst->ERR_EXECUTE_REPL2_LIST_VOL );
        }

        push( @mvrvInfo, @$mvrvInfoAryRef );
    }

    my @mvrvInfoLocal = `$cmd`;
    ## $? exitcode is 1 when there is no pair.
    if ( $? != 0 ) {
        return ( undef, $ddrConst->ERR_EXECUTE_REPL2_LIST_VOL );
    }

    push( @mvrvInfo, @mvrvInfoLocal );
    my %seen = ();
    @mvrvInfo = grep { !$seen{$_}++ } @mvrvInfo;

    my %mvRvNameListHash = ();
    for ( my $i = 0 ; $i < scalar(@mvrvInfo) ; $i++ ) {
        if ( $mvrvInfo[$i] =~ /^\s*(\S+)\s*<==>\s*(\S+?)(?:\.spl)?\s*$/ ) {
            my $mvName = $1;
            my $rvName = $2;
            if ( !exists( $mvRvNameListHash{$mvName} ) ) {
                my @rvNameList = ($rvName);
                $mvRvNameListHash{$mvName} = \@rvNameList;
            }
            else {
                my $rvNameListAryRef = $mvRvNameListHash{$mvName};
                push( @$rvNameListAryRef, $rvName );
            }
        }
    }

    return ( \%mvRvNameListHash, undef );
}

##
# @Function
#   This is a function to get the volume pair info of the assigned pair.
# @param
#     {String}  $mvName : the mv name a pair.
#   {String}  $rvName : the rv name a pair.
# @return (\@ldPairListOfVolPair, $errCode)
#   {array reference}   \@ldPairListOfVolPair : all ldpair's info of a vol pair.
#       element in @ldPairListOfVolPair is a hash reference.
#         its struct is :
#           key   : {string}      for example: "syncState".
#           value : {string}      for example: "seperated".
#         its possible values are :
#           1. @ldPairListOfVolPair when no error occars.
#           2. undef        when error occars.
#   {int}     $errCode      : specified error code.
#         its possible values are :
#           1. undef    when no error occars.
#           2. 0x13700002 Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 info vol pair.
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.26
##
sub getLdPairListOfVolPair() {
    my $self   = shift;
    my $mvName = shift;
    my $rvName = shift;

    my $cmd = $ddrConst->CMD_REPL2_INFO_VOL_PAIR . " " . $mvName . " " . $rvName;

    ## get the pair's info.
    my @volPairInfo = `$cmd 2>/dev/null`;

    if ( $? != 0 ) {
        return ( undef, $ddrConst->ERR_EXECUTE_REPL2_INFO_VOL_PAIR );
    }

    my %capacityUnit2ByteHash = (
        "KB" => 1024,
        "MB" => 1024 * 1024,
        "GB" => 1024 * 1024 * 1024,
        "TB" => 1024 * 1024 * 1024 * 1024
    );

    my @ldPairListOfVolPair = ();
    my $ldCount             = 0;

    my $len = scalar(@volPairInfo);
    ## parse the @volPairInfo to @ldPairListOfVolPair by ldpair.
    for ( my $i = 0 ; $i < $len ; $i++ ) {
        if ( $volPairInfo[$i] =~ /^\s*$/ ) {
            next;
        }

        my %oneLdPairInfo = ();

        while ( $i < $len && ( my $cotent = $volPairInfo[ $i++ ] ) !~ /^\s*$/ ) {
            if ( $cotent =~ /^\s*MV:\s*LD\s*Name\s+(\S+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_MVLDNAME } = $1;
                next;
            }

            if ( $cotent =~ /^\s*RV:\s*LD\s*Name\s+(\S+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_RVLDNAME } = $1;
                next;
            }

            if ( $cotent =~ /^\s*Activity\s*State\s+(.+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_ACTIVITYSTATE } = $1;
                $oneLdPairInfo{ $ddrConst->PAIRINFO_ACTIVITYSTATE } =~ s/\s+$//;
                next;
            }
            
            if ( $cotent =~ /^\s*Sync\s*State\s+(\S+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_SYNCSTATE } = $1;
                next;
            }

            if ( $cotent =~ /^\s*\S+\s*Start\s*Time\s+(.+)\s*$/
                    || $cotent =~ /^\s*Forced\s+Separate\s+Time\s+(.+)\s*$/
                    || $cotent =~ /^\s*Fault\s+Time\s+(.+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_STARTTIME } = $1;
                $oneLdPairInfo{ $ddrConst->PAIRINFO_STARTTIME } =~ s/\s+$//;
                next;
            }
            
            if ( $cotent =~ /^\s*\S+\s*End\s*Time\s+(.+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_ENDTIME } = $1;
                $oneLdPairInfo{ $ddrConst->PAIRINFO_ENDTIME } =~ s/\s+$//;
                next;
            }

            if ( $cotent =~ /^\s*Separate\s*Diff\s+([\.\d]+)([a-zA-Z]+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_SEPARATEDIFF } = $1 * $capacityUnit2ByteHash{ uc($2) };
                next;
            }
            
            if ( $cotent =~ /^\s*Copy\s*Diff\s+([\.\d]+)([a-zA-Z]+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYDIFF } = $1 * $capacityUnit2ByteHash{ uc($2) };
                next;
            }

            if ( $cotent =~ /^\s*Copy\s*Control\s*State\s+(.+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYCONTROLSTATE } = $1;
                $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYCONTROLSTATE } =~ s/\s+$//;
                next;
            }
            
            if ( $cotent =~ /^\s*RV\s*Access\s+(\S+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_RV_ACCESS } = $1;
                next;
            }
            
            if ( $cotent =~ /^\s*Previous\s*Active\s+(.+)\s*$/ ) {
                $oneLdPairInfo{ $ddrConst->PAIRINFO_PRE_ACTIVE } = $1;
                $oneLdPairInfo{ $ddrConst->PAIRINFO_PRE_ACTIVE } =~ s/\s+$//;
                next;
            }
        }

        $oneLdPairInfo{ $ddrConst->PAIRINFO_MVLDNAME }         = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_MVLDNAME } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_RVLDNAME }         = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_RVLDNAME } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_ACTIVITYSTATE }    = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_ACTIVITYSTATE } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_SYNCSTATE }        = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_SYNCSTATE } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_STARTTIME }        = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_STARTTIME } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_ENDTIME }          = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_ENDTIME } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_SEPARATEDIFF }     = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_SEPARATEDIFF } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYDIFF }         = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYDIFF } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYCONTROLSTATE } = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_COPYCONTROLSTATE } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_RV_ACCESS }        = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_RV_ACCESS } ) );
        $oneLdPairInfo{ $ddrConst->PAIRINFO_PRE_ACTIVE }       = "--" if ( !defined( $oneLdPairInfo{ $ddrConst->PAIRINFO_PRE_ACTIVE } ) );
        
        $ldPairListOfVolPair[ $ldCount++ ] = \%oneLdPairInfo;
    }

    return ( \@ldPairListOfVolPair, undef );
}

##
# @Function
#   This is a function to get the schedule info of the assigned mv.
# @param
#     {string}  $mvName : the mv name.
#     {array ref} $rvNameListAry : mv's rv list.
#     {array ref} $scheduleInfo : all the schedule info.
# @return (\@scheduleInfo, $errCode)
#   {string}  $scheduleInfoList : all schedule info of the assigned mv,such as
#                     "scheduleInfo1#scheduleInfo2#...", which is divided by "#".
#         its possible values are :
#           1. scheduleinfo when has schedule info.
#           2. "--"     when "sched list" failed or current mv has more than one schedule.
#           3. ""     when has no schedule.
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.27
##
sub getSchedule() {
    my $self         = shift;
    my $mvName       = shift;
    my $rvNameListAry= shift;
    my $scheduleInfo = shift;

    my $len = scalar(@$scheduleInfo);
    if ( $len > 0 && $$scheduleInfo[0] eq $ddrConst->ERR_EXECUTE_REPL2_SCHED_LIST ) {
        return "--";
    }

    my $rvNameListStr = join( ",", @$rvNameListAry );
    my $scheduleInfoList = "";
    for ( my $i = 0 ; $i < $len ; $i++ ) {
        my $currentSchedule = $$scheduleInfo[$i];
        if ( $currentSchedule =~ /^\s*((?:\S+\s+){4}\S+)\s+$mvName\s+(\S+)\s+(\S+)\s*$/ ) {
            if ( $3 eq "\Qrepliandsper\(sync\)\E" && (&isListStringSame($self, $rvNameListStr, $2, ",")) == 0 ) {
                $scheduleInfoList .= "#" . $1;
            }
        }
    }

    $scheduleInfoList =~ s/^#//;
    
    if ( $scheduleInfoList =~ /#/ ) {
        return "--";
    }

    return $scheduleInfoList;
}

##
# @Function
#   This is a function to get the assigned vol pair's progress Rate.
# @param
#   {Array ref} $ldPairListOfVolPairAryRef  : the ldPairListOfVolPairAry Ref of the assigned pair.
#   {Hash ref}  $ldInfoList         : the ld info list hash of vol pair.
# @return ($progressRate)
#   {string}  $progressRate
#         its possible values are :
#           1. progess rate
#           2. "--"
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.25
##
sub getProgressRate() {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;
    my $ldInfoList                = shift;
    my $currentActivityState      = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);
    return "--" if ( $ldCount == 0 );
    
    my $diffType;
    if ( $currentActivityState eq $ddrConst->ACTIVITYSTATE_REPLICATE 
            || $currentActivityState eq $ddrConst->ACTIVITYSTATE_RESTORE 
            || $currentActivityState eq $ddrConst->ACTIVITYSTATE_RESTORE_PROTECT){
        $diffType = $ddrConst->PAIRINFO_SEPARATEDIFF;
    }
    elsif ( $currentActivityState eq $ddrConst->ACTIVITYSTATE_SEPARATE ) {
        $diffType = $ddrConst->PAIRINFO_COPYDIFF;
    }
    else {
        return "--";
    }
    
    my $diffCapacity = 0;
    my $ldCapacity   = 0;

    ## calculate all LD's Capacity and all separateDiff.
    for ( my $i = 0 ; $i < $ldCount ; $i++ ) {
        my $ldPairInfo = $$ldPairListOfVolPairAryRef[$i];

        ## statistics of diff capacity.
        my $diffCapacityTmp = $ldPairInfo->{ $diffType };
        if ( !defined($diffCapacityTmp) || $diffCapacityTmp !~ /^\s*\d+\s*$/ ) {
            return "--";
        }
        $diffCapacity += $diffCapacityTmp;

        ## statistics of ld capacity.
        my $ldName = $ldPairInfo->{ $ddrConst->PAIRINFO_MVLDNAME };
        return "--" if ( $ldName eq "--" );

        my $ldInfoHash = $ldInfoList->{$ldName};
        return "--" if ( !defined($ldInfoHash) );

        my $ldCapacityTmp = $ldInfoHash->{ $ddrConst->LDINFO_CAPACITY };

        $ldCapacity += $ldCapacityTmp * 1024;
    }
    if ( $ldCapacity == 0 ) {
        return "--";
    }
    
    my $progressRate = 100 - $diffCapacity / $ldCapacity * 100;
    
    if ( $progressRate < 0 ) {
        $progressRate = 0;
    }
    
    ## set $progressRate to one decimal.
    $progressRate = $nsguiCommon->deleteAfterPoint( $progressRate, 1 );

    ## if the decimal is 0, truncate it.
    if ( $progressRate =~ /^\s*(\d+)\.0\s*$/ ) {
        $progressRate = $1;
    }

    return $progressRate;
}

##
# @Function
#   This is a function to get the activity State of the assigned pair.
# @param
#   {Array ref}   $ldPairListOfVolPairAryRef      : the ldPairListOfVolPairAry Ref of the assigned pair.
# @return (string)
#   {string}    : the activity State of the assigned pair.
#         its possible values are :
#           1. "separate"
#           2. "replicate"
#           3. "restore"
#           4. "restore (protect)"
#           5. "--"
##
sub getActivityState {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);

    return "--" if ( $ldCount == 0 );

    my %activityState = ();

    for ( my $i = 0 ; $i < $ldCount ; $i++ ) {
        my $ldPairInfo   = $$ldPairListOfVolPairAryRef[$i];
        my $activityStateTmp = $ldPairInfo->{ $ddrConst->PAIRINFO_ACTIVITYSTATE };
        
        return "--" if ( $activityStateTmp =~ /^[\s-]*$/ );
        
        $activityState{$activityStateTmp}++;
    }
    
    my @Activities = keys %activityState;
    ## if all LD's activity state are one kind of activity state, then
    ## the activity state should be the one.
    if ( scalar(@Activities) == 1 ) {
        return $Activities[0];
    }
    
    return "--";
}

##
# @Function
#   This is a function to get the Sync State of the assigned pair.
# @param
#   {Array ref}   $ldPairListOfVolPairAryRef      : the ldPairListOfVolPairAry Ref of the assigned pair.
# @return (string)
#   {string}    : the Sync State of the assigned pair.
#         its possible values are :
#           1. "separated"
#           2. "sep/exec"
#           3. "cancel"
#           4. "fault"
#           5. "rpl/sync"
#           6. "rpl/exec"
#           7. "rst/sync"
#           8. "rst/exec"
#           9. "--"
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.27
##
sub getSyncState {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);

    return "--" if ( $ldCount == 0 );

    my %syncState = (
        $ddrConst->SYNCSTATE_SEPARATED => 0,
        $ddrConst->SYNCSTATE_SEP_EXEC  => 0,
        $ddrConst->SYNCSTATE_CANCEL    => 0,
        $ddrConst->SYNCSTATE_FAULT     => 0,
        $ddrConst->SYNCSTATE_RPL_SYNC  => 0,
        $ddrConst->SYNCSTATE_RPL_EXEC  => 0,
        $ddrConst->SYNCSTATE_RST_SYNC  => 0,
        $ddrConst->SYNCSTATE_RST_EXEC  => 0
    );

    for ( my $i = 0 ; $i < $ldCount ; $i++ ) {
        my $ldPairInfo   = $$ldPairListOfVolPairAryRef[$i];
        my $syncStateTmp = $ldPairInfo->{ $ddrConst->PAIRINFO_SYNCSTATE };

        $syncState{$syncStateTmp}++;
    }

    ## if there is any one LD whose sync state is 'cancel'.
    if ( $syncState{ $ddrConst->SYNCSTATE_CANCEL } > 0 ) {
        return $ddrConst->SYNCSTATE_CANCEL;
    }

    ## if there is any one LD whose sync state is 'fault'.
    if ( $syncState{ $ddrConst->SYNCSTATE_FAULT } > 0 ) {
        return $ddrConst->SYNCSTATE_FAULT;
    }

    ## if all LD's sync State is 'separated'.
    if ( $syncState{ $ddrConst->SYNCSTATE_SEPARATED } == $ldCount ) {
        return $ddrConst->SYNCSTATE_SEPARATED;
    }
    elsif ( $syncState{ $ddrConst->SYNCSTATE_SEPARATED } + $syncState{ $ddrConst->SYNCSTATE_SEP_EXEC } == $ldCount ) {
        return $ddrConst->SYNCSTATE_SEP_EXEC;
    }

    ## if all LD's sync State is 'replicated'.
    if ( $syncState{ $ddrConst->SYNCSTATE_RPL_SYNC } == $ldCount ) {
        return $ddrConst->SYNCSTATE_RPL_SYNC;
    }
    elsif ( $syncState{ $ddrConst->SYNCSTATE_RPL_EXEC } + $syncState{ $ddrConst->SYNCSTATE_RPL_SYNC } == $ldCount ) {
        return $ddrConst->SYNCSTATE_RPL_EXEC;
    }

    ## if all LD's sync State is 'restored'.
    if ( $syncState{ $ddrConst->SYNCSTATE_RST_SYNC } == $ldCount ) {
        return $ddrConst->SYNCSTATE_RST_SYNC;
    }
    elsif ( $syncState{ $ddrConst->SYNCSTATE_RST_EXEC } + $syncState{ $ddrConst->SYNCSTATE_RST_SYNC } == $ldCount ) {
        return $ddrConst->SYNCSTATE_RST_EXEC;
    }

    return "--";
}

##
# @Function
#   This is a function to get the Sync Start Time of the assigned pair.
# @param
#   {Array ref}   $ldPairListOfVolPairAryRef  : the ldPairListOfVolPairAry Ref of the assigned pair.
# @return (string)
#   {string}    : the Sync Start Time of the assigned pair.
#         its possible values are :
#           1. time   eg: "2008/04/18 20:29:36".
#           2. "--"
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.27
##
sub getStartTime {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);
    return "--" if ( $ldCount == 0 );

    my @timeList = ();

    for ( my $i = 0 ; $i < $ldCount ; $i++ ) {
        my $startTimeTmp = $$ldPairListOfVolPairAryRef[$i]->{ $ddrConst->PAIRINFO_STARTTIME };

        if ( $startTimeTmp =~ /^\s*\d+\/\d+\/\d+\s+\d+:\d+:\d+\s*$/ ) {
            push( @timeList, $startTimeTmp );
        }
    }

    ## get the earliest time.
    my @sortedTimeList = sort { $a cmp $b } @timeList;
    my $earlistTime = "--";
    if ( scalar(@sortedTimeList) > 0 ) {
        $earlistTime = $sortedTimeList[0];
    }

    return $earlistTime;
}

##
# @Function
#   This is a function to get the Sync End Time of the assigned pair.
# @param
#   {Array ref}   $ldPairListOfVolPairAryRef  : the ldPairListOfVolPairAry Ref of the assigned pair.
# @return (string)
#   {string}    : the Sync End Time of the assigned pair.
#         its possible values are :
#           1. time   eg: "2008/04/18 20:29:36".
#           2. "--"
##
sub getEndTime {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);
    return "--" if ( $ldCount == 0 );

    my @timeList = ();

    for ( my $i = 0 ; $i < $ldCount ; $i++ ) {
        my $endTimeTmp = $$ldPairListOfVolPairAryRef[$i]->{ $ddrConst->PAIRINFO_ENDTIME };

        if ( $endTimeTmp =~ /^\s*\d+\/\d+\/\d+\s+\d+:\d+:\d+\s*$/ ) {
            push( @timeList, $endTimeTmp );
        }
        else {
            return "--";
        }
    }
    
    ## get the latest time.
    my @sortedTimeList = sort { $b cmp $a } @timeList;

    return $sortedTimeList[0];
}

##
# @Function
#   This is a function to get the sync pair list.
# @param
#   {string}  $file : the file from which to get info.
# @return (string)
#   {hash ref}  \%asyncPairListHash:
#           key= mvname, value= \%subhash
#                    (key is "mv",["rv0","rv1","rv2"],"action","sched")
#         error: key= $ddrConst->ERR_FLAG, value= $ddrConst->DDR_EXCEP_FAILED_TO_GET_ASYNCPAIRINFO[0x137f0003]
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.3.25
##
sub getAsyncPairListHash() {
    my ( $self, $file ) = @_;

    my %asyncPairListHash = ();

    if ( !defined($file) || !-f $file ) {
        return \%asyncPairListHash;
    }

    my $content = $nsguiCommon->getFileContent($file);

    if ( !defined($content) ) {
        $asyncPairListHash{ $ddrConst->ERR_FLAG } = $ddrConst->DDR_EXCEP_FAILED_TO_GET_ASYNCPAIRINFO;
        return \%asyncPairListHash;
    }

    my $len = scalar(@$content);
    for ( my $i = 0 ; $i < $len ; $i++ ) {
        if ( $$content[$i] =~ /^\s*$/ ) {
            next;
        }

        my %oneAsyncPairHash = ();
        while ( $i < $len && $$content[$i] !~ /^\s*$/ ) {
            ## set the one mv info to hash.
            if ( $$content[ $i++ ] =~ /^\s*(\S+?)\s*=\s*(.+)\s*$/ ) {
                $oneAsyncPairHash{$1} = $2;
            }
        }

        ################################################################
        ## judge whether the file's format is correct. **START**

        ## judge whether the mv's format is correct.
        my $mvValue = $oneAsyncPairHash{"mv"};
        next if ( !defined($mvValue) );
        next if ( $mvValue !~ /^\s*(\S+)\s*:\s*0x[0-9a-f]{8}\s*$/ );
        my $mvName = $1;

        ## judge whether the action's format is correct.
        my $actionValue = $oneAsyncPairHash{"action"};
        next if ( !defined($actionValue) );
        next if ( $actionValue !~ /^\s*(create|extend)\s*$/ );

        ## judge whether the rv's format is correct.
        my $rvNumber         = 0;
        my $isRvValueCorrect = 0;
        for ( my $j = 0 ; $j < 3 ; $j++ ) {
            my $rvKey   = "rv" . $j;
            my $rvValue = $oneAsyncPairHash{$rvKey};
            if ( defined($rvValue) ) {
                if ( $rvValue !~ /^\s*\S+\s+\S+\s*\((?:\S+\s*,\s*)*\S+\s*\)\s*:\s*0x[0-9a-f]{8}\s*$/ ) {
                    $isRvValueCorrect = 1;
                    last;
                }
                $rvNumber++;
            }
        }

        next if ( $rvNumber == 0 );
        next if ( $isRvValueCorrect == 1 );

        ## judge whether the sched's format is correct.
        if ( $actionValue eq $ddrConst->PAIRINFO_STATUS_CREATE && $rvNumber > 1 ) {
            my $schedValue = $oneAsyncPairHash{"sched"};
            next if ( !defined($schedValue) );
            next if ( $schedValue !~ /^\s*(?:\S+\s+){4}\S+\s*:\s*0x[0-9a-f]{8}\s*$/ );
        }
        ## judge whether the file's format is correct. **END**
        ################################################################

        $asyncPairListHash{$mvName} = \%oneAsyncPairHash;
    }

    return \%asyncPairListHash;
}

##
# @Function
#   This is a function to get the Copy Control State of the assigned pair.
# @param
#   {Array ref}   $ldPairListOfVolPairAryRef  : the ldPairListOfVolPairAry Ref of the assigned pair.
# @return (string)
#   {string}    : the Copy Control State of the assigned pair.
#         its possible values are :
#           1. "foreground copy (sync)"
#           2. "foreground copy (semi)"
#           3. "normal suspend"
#           4. "abnormal suspend"
#           5. "background copy"
#           6. "freeze"
#           7. "--"
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.3.10
##
sub getCopyControlState {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);
    return "--" if ( $ldCount == 0 );

    my $copyControlState = $$ldPairListOfVolPairAryRef[ $ldCount - 1 ]->{ $ddrConst->PAIRINFO_COPYCONTROLSTATE };

    return "--" if ( $copyControlState =~ /^[\s-]*$/ );

    return $copyControlState;
}

##
# @Function
#   This is a function to get the Sync Start Time of the assigned pair.
# @param
#   {Array ref}   $ldPairListOfVolPairAryRef  : the ldPairListOfVolPairAry Ref of the assigned pair.
# @return ( $mvLdNameListStr, $rvLdNameListStr )
#   {string}    : the mv ld name list of the assigned vol pair.
#         its possible values are :
#           1. mvLdName:mvLdName...
#           2. "--"
#   {string}    : the rv ld name list of the assigned vol pair.
#         its possible values are :
#           1. rvLdName:rvLdName...
#           2. "--"
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.27
##
sub getLdNameListOfVolPair {
    my $self                      = shift;
    my $ldPairListOfVolPairAryRef = shift;

    my $ldCount = scalar(@$ldPairListOfVolPairAryRef);

    return ( "--", "--" ) if ( $ldCount == 0 );

    my $mvLdNameListStr = "";
    my $rvLdNameListStr = "";
    ## get the ld name.
    for ( my $i = 0 ; $i < $ldCount ; $i++ ) {
        my $ldPairInfoTmp = $$ldPairListOfVolPairAryRef[$i];
        my $mvLdName      = $ldPairInfoTmp->{ $ddrConst->PAIRINFO_MVLDNAME };
        my $rvLdName      = $ldPairInfoTmp->{ $ddrConst->PAIRINFO_RVLDNAME };

        $mvLdNameListStr .= ":" . $mvLdName;
        $rvLdNameListStr .= ":" . $rvLdName;
    }

    $mvLdNameListStr =~ s/^://;
    $rvLdNameListStr =~ s/^://;
    $mvLdNameListStr =~ s/\s//g;
    $rvLdNameListStr =~ s/\s//g;
    return ( $mvLdNameListStr, $rvLdNameListStr );
}

##
# @Function
#   This is a function to get the usage of the assigned mv.
# @param
#   {Array ref}   $rvNameListAryRef   : the rvNameListAry Ref of the assigned mv.
# @return (string)
#   {string}    $usage    : the usage of the assigned mv.
#         its possible values are :
#           1. "always"
#           2. "generation"
# @author Pi ZhiBing pizb@nec-as.nec.com.cn @date 2008.2.27
##
sub getUsage {
    my $self             = shift;
    my $rvNameListAryRef = shift;

    my $usage = $ddrConst->USAGE_ALWAYS;
    $usage = $ddrConst->USAGE_GENERATION if ( scalar(@$rvNameListAryRef) > 1 );

    return $usage;
}

##
# @Function
#   add a new async pair information to file
# @param
#   {hash ref}  $oneAsyncPairHash   : the hash reference which has async pair information.
#   {string}  $file   : async file path.
# @return ()
#   {int}
#         its possible values are :
#           1. 0x00000000:  successful.
#           2. 0x137f0003:  error at getting async pair info.
#           2. 0x137f0004:  error at writing async pair info.
##
sub addAsyncPair2File() {
    my ( $self, $oneAsyncPairHash, $file ) = @_;

    ## SyncPair info's hash is empty
    if ( scalar( keys %$oneAsyncPairHash ) == 0 ) {
        return $ddrConst->SUCCESS_CODE;
    }

    ## get all sync pair info from file ddr_syncfile
    my $asyncPairListHash = &getAsyncPairListHash( $self, $file );
    if ( exists( $$asyncPairListHash{ $ddrConst->ERR_FLAG } ) ) {
        return $$asyncPairListHash{ $ddrConst->ERR_FLAG };
    }

    ## add current $oneAsyncPairHash to $asyncPairListHash
	$$oneAsyncPairHash{"mv"} =~ /^\s*(\S+)\s*:.*$/;
    my $mvName = $1;
    $$asyncPairListHash{$mvName} = $oneAsyncPairHash;

    ## write info from $asyncPairListHash to file 'ddr_syncfile'
    my $retVal = $volumeCommon->writeAsyncVolToFile( $asyncPairListHash, $file );
    if ( $retVal != 0 ) {
        return $ddrConst->DDR_EXCEP_FAILED_TO_WRITE_ASYNCPAIRINFO;
    }

    return $ddrConst->SUCCESS_CODE;
}

##
# @Function
#   get VG Name and its LDName from vgdisplay command result
# @param
#   none.
# @return (\%vgLdNameInfo)
#   {hash ref}  : \%vgLdNameInfo
#         succeed: $vgLdNameInfo{$vgName} = "$ldNameList";
#                     eg: $vgLdNameInfo{"NV_LVM_16"} = "20000030138402660032:20000030138402660033";
#               error  :   $vgLdNameInfo{"ERROR"} = $errCode
##
sub getVgLdNameInfoHash() {
    my $self             = shift;
    my %vgLdNameInfoHash = ();

    my $vgInfoHash = $volumeCommon->getVgdisplayInfo();
    if ( exists( $$vgInfoHash{ $volumeConst->ERR_FLAG } ) ) {
        $vgLdNameInfoHash{ $ddrConst->ERR_FLAG } = $$vgInfoHash{ $volumeConst->ERR_FLAG };
        return \%vgLdNameInfoHash;
    }

    my $cmd = $ddrConst->CMD_LDDEV2LDNAME;

    ## the %$vgInfoHash is : $vgInfo{$vgName} = "$vgSize:$ldPathList".
    ## eg: $vgInfo{"NV_LVM_16"} = "0.2: /dev/sda6,/dev/sda7".
    while ( my ( $vgName, $vgInfo ) = each(%$vgInfoHash) ) {
        my @oneVgInfoAry = split( ":", $vgInfo );
        my @ldPathList   = split( ",", $oneVgInfoAry[1] );
        my $ldNameList   = "";
        foreach my $ldPath (@ldPathList) {
            my $ldName = `$cmd $ldPath 2>/dev/null`;
            if ( $? != 0 ) {
                $ldName = "--";
            }

            $ldNameList .= ":" . $ldName;
        }

        $ldNameList =~ s/^://;
        $ldNameList =~ s/\s//g;
        $vgLdNameInfoHash{$vgName} = $ldNameList;
    }
    return \%vgLdNameInfoHash;
}

##
# @Function
#   judge whether the VG is abnormal.
# @param
#   {String}  : $vgLdNameList   vgdisplay info's MV LD Name List.
#   {String}  : $repl2LdNameList  repl2 info vol pair's MV LD Name List.
# @return
#   0 : the pair is normal.
#   1 : the pair is abnormal.
##
sub isPairAbnormal() {
    my ( $self, $vgLdNameList, $repl2LdNameList ) = @_;

    ## the ld number is different between $vgLdNameList and $repl2LdNameList.
    if ( length($vgLdNameList) != length($repl2LdNameList) ) {
        return 1;
    }

    my @vgLdNameAry    = sort split( ":", $vgLdNameList );
    my @repl2LdNameAry = sort split( ":", $repl2LdNameList );

    for ( my $i = 0 ; $i < scalar(@vgLdNameAry) ; $i++ ) {
        if ( $vgLdNameAry[$i] ne $repl2LdNameAry[$i] ) {
            return 1;
        }
    }

    return 0;
}

##
# @Function
#   judge whether the two string is the same.
# @param
#   {String}  : $listString1
#   {String}  : $listString2
#   {String}  : $separator
# @return
#   0 : the two string is the same as each other.
#   1 : the two string is not the same as each other.
#   2 : at least one of the param is undef.
##
sub isListStringSame() {
    my ( $self, $listString1, $listString2, $separator ) = @_;

    if ( !defined($listString1) || !defined($listString2) || !defined($separator) ) {
        return 2;
    }
    
    if ( $listString1 eq $listString2 ) {
        return 0;
    }
    
    if ( length($listString1) != length($listString2) ) {
        return 1;
    }

    my @listString1Ary    = sort split( $separator, $listString1 );
    my @listString2Ary    = sort split( $separator, $listString2 );
    
    if ( scalar(@listString1Ary) != scalar(@listString2Ary) ) {
        return 1;
    }
    
    for ( my $i = 0 ; $i < scalar(@listString1Ary) ; $i++ ) {
        if ( $listString1Ary[$i] ne $listString2Ary[$i] ) {
            return 1;
        }
    }

    return 0;
}

###Function : Get Export defined in cfstab and not Syncfs
###
###Parameter:
###           mount point $mp
###Return:
###           $exportGroup
###
sub slipExportGroup() {
    my ( $self, $mp ) = @_;
    my $exportGroup;
    if ( $mp =~ /^\s*(\/export\/[^\/]+)\// ) {
        $exportGroup = $1;
    }
    return $exportGroup;
}
###Function : Get current /etc/group0?1/ path
###
###Parameter:
###           null
###Return:
###           $ectPath
###
sub getEtcPath() {
    my $self   = shift;
    my $nodeNo = $nsguiCommon->getMyNodeNo();    ##don't need check the result

    if ( $nodeNo eq "1" ) {
        return $ddrConst->PATH_ETC_NODE1;
    }
    return $ddrConst->PATH_ETC_NODE0;
}

###Function : transform code page from perl to session mode
###
###Parameter:
###           $codePage
###Return:
###           $guiCodePage
###
sub toGuiCodePage() {
    my ( $self, $codePage ) = @_;
    my $guiCodePage = $codePage;
    if ( $codePage eq "UTF8" ) {
        $guiCodePage = "UTF-8";
    }
    return $guiCodePage;
}

###Function : Combine the same item splited by "," and sort.
###
###Parameter:
###           $before like "item1,itm3,item3,item2,item1,item2"
###Return:
###           $after  like "item1,item2,item3"
###       $count  number of item.
sub compactAndSort() {
    my ( $self, $before ) = @_;
    my @tmp = split( ",", $before );
    if ( scalar(@tmp) == 1 ) {
        return ( $before, 1 );
    }
    my %compactHash = ();
    foreach (@tmp) {
        $compactHash{$_} = "";
    }
    my @sorted = sort( keys(%compactHash) );
    my $after = join( ",", @sorted );
    return ( $after, scalar(@sorted) );
}

###Function : Get ld information (attribute, capacity,...)
###
###Parameter:
###           null
###Return:
###           \%ldhash
###           key= ldname, value= \%subhash
###                    (eg: "Attribute"=> MV, "Capacity"=> 1.0 GB)
###         error: key= $ddrConst->ERR_FLAG, value= $ddrConst->ERR_EXECUTE_REPL2_LIST_LD
sub getRepl2LdInfo() {
    my $cmd     = $ddrConst->CMD_REPL2_LIST_LD;
    my @result  = `$cmd 2>/dev/null`;
    my $retcode = $?;
    my %ldhash  = ();

    if ( $retcode == 0 ) {
        foreach (@result) {
            if ( $_ =~ /^[\da-f]{4}h\s+/i ) {
                my %subhash = ();
                my @tmp     = split( /\s+/, $_ );
                my $num     = scalar(@tmp);

                my $capa = $tmp[ $num - 3 ];
                if ( $tmp[ $num - 2 ] eq "TB" ) {
                    $capa = sprintf( "%.1f", $capa * 1024 * 1024 * 1024 );
                }elsif($tmp[$num-2] eq "GB"){
                    $capa = sprintf( "%.1f", $capa * 1024 * 1024 );
                }elsif($tmp[$num-2] eq "MB"){
                    $capa = sprintf( "%.1f", $capa * 1024 );
                }

                $subhash{ $ddrConst->LDINFO_CAPACITY }  = $capa;
                $subhash{ $ddrConst->LDINFO_ATTRIBUTE } = $tmp[ $num - 4 ];

                $ldhash{ $tmp[ $num - 5 ] } = \%subhash;
            }
        }
    }else{
        $ldhash{ $ddrConst->ERR_FLAG } = $ddrConst->ERR_EXECUTE_REPL2_LIST_LD;
    }
    return \%ldhash;
}

###Function : Get MVlds and RVlds
###
###Parameter:
###           null
###Return:
###           (\%mvLdHash, \%rvLdHash)
###           key= ldpath, value= ""
###         error: key= $ddrConst->ERR_FLAG, value= $ddrConst->ERR_EXECUTE_LDNAME2LDDEV
sub getMvRvLds() {
    my $ldInfo   = &getRepl2LdInfo();
    my %rvLdHash = ();
    my %mvLdHash = ();
    if ( !defined( $$ldInfo{ $ddrConst->ERR_FLAG } ) ) {
        my $cmd = $ddrConst->CMD_LDNAME_TO_LDDEV;
        foreach my $key ( keys(%$ldInfo) ) {
            my $ldInfoValue = $$ldInfo{$key};
            my $attr        = "IV";
            if ( $$ldInfoValue{"Attribute"} =~ /RV/ ) {
                $attr = "RV";
            }elsif($$ldInfoValue{"Attribute"} =~ /MV/){
                $attr = "MV";
            }else{
                next;
            }
            my $ldpath = `$cmd $key 2>/dev/null`;
            chomp($ldpath);
            if ( $ldpath eq "" ) {
                next;
            }
            if ( $attr eq "MV" ) {
                $mvLdHash{$ldpath} = "";
            }elsif($attr eq "RV"){
                $rvLdHash{$ldpath} = "";
            }
        }
    }
    return ( \%mvLdHash, \%rvLdHash );
}

## Function
##     get ldPath and its wwnn,lun,storage from ldhardln.conf and nasnickname file
##     get VG Name and its VG Size,PV Name from vgdisplay command result
##     get ld and disk array info
##
## Parameters
##     none
##
## Return
##     $vgLdInfoHash
##          |
##        $ldhardlnHash
##             |
##            ldPath --> "wwnn,lun,storage"
##        $vgInfo
##             |
##            vgName --> "vgSize:ldPathList"
##        $ldInfoHash
##             |
##            wwnn ----> \%singleLdInfoHash
##                                |
##                               lun --> "lun ldType ldName ldsz poolNo poolName raidType"
##                               aid --> ld's disk array's id
##                               aname --> ld's disk array's name
##     errCode: error code
sub getVgLdInfoHash() {
    my $ldhardlnHash = {};
    my $vgInfo       = {};
    my $ldInfoHash   = {};
    my $vgLdInfoHash = {};

    # get ldPath and its wwnn,lun,storage from ldhardln.conf and nasnickname file
    $ldhardlnHash = $volumeCommon->getLdhardlnStorage();
    if ( defined( $$ldhardlnHash{ $volumeConst->ERR_FLAG } ) ) {
        return ( $vgLdInfoHash, $$ldhardlnHash{ $volumeConst->ERR_FLAG } );
    }

    # get VG Name and its VG Size,PV Name from vgdisplay command result
    $vgInfo = $volumeCommon->getVgdisplayInfo();
    if ( defined( $$vgInfo{ $volumeConst->ERR_FLAG } ) ) {
        return ( $vgLdInfoHash, $$vgInfo{ $volumeConst->ERR_FLAG } );
    }

    # get ldNo and its pool of current disk array
    $ldInfoHash = $volumeCommon->getLdInfo( "1", "1" );
    if ( defined( $$ldInfoHash{ $volumeConst->ERR_FLAG } ) ) {
        return ( $vgLdInfoHash, $$ldInfoHash{ $volumeConst->ERR_FLAG } );
    }

    $$vgLdInfoHash{'ldhardlnHash'} = $ldhardlnHash;
    $$vgLdInfoHash{'vgInfo'}       = $vgInfo;
    $$vgLdInfoHash{'ldInfoHash'}   = $ldInfoHash;
    return ( $vgLdInfoHash, undef );
}

## Function
##     get storage and pool info
##
## Parameters
##     $volName -- volume's name
##     $ldpath -- if mv, set ''
##                if rv, set ldpath, eg:/dev/ld6,/dev/ld7
##     $vgLdInfoHash -- refer to the return value of method "getVgLdInfoHash"
##
## Return
##     $wwnn -- multi $wwnn of $ldPath joined with ",".
##     $aid -- disk array's id. multi joined with ",".
##     $aname -- disk array's name. multi joined with ",".
##     $poolNameAndNo --  multi joined with ",". eg: 00h,01h
##     $raidType -- 1|5|10|50|6(4+PQ)|6(8+PQ)
##     $capacity -- capacity, unit:G. eg: 0.2
sub getStoragePoolInfo() {
    my ( $self, $volName, $ldpath, $vgLdInfoHash ) = @_;
    my $ldhardlnHash = $$vgLdInfoHash{'ldhardlnHash'};
    my $vgInfo       = $$vgLdInfoHash{'vgInfo'};
    my $ldInfoHash   = $$vgLdInfoHash{'ldInfoHash'};

    # get capacity & mvldpath
    my $capacity  = "--";
    my $ldpathTmp = "--";
    if ( defined( $$vgInfo{$volName} ) ) {
        ( $capacity, $ldpathTmp ) = split( ":", $$vgInfo{$volName} );
    }
    if ( $ldpath eq '' ) {
        $ldpath = $ldpathTmp;
    }

    # get wwnn & lunNo
    my ( $storage, $lunNo, $wwnn ) = $volumeCommon->getStorage( $ldpath, $ldhardlnHash );

    # get array name & pool info
    my ( $aid, $aname, $poolNameAndNo, $raidType ) = $volumeCommon->getPool( $wwnn, $lunNo, $ldInfoHash );

    return ( $poolNameAndNo, $raidType, $capacity, $aid, $aname, $wwnn );
}

## Function
##     get group use command "/sbin/vg_getgroup"
##
## Parameters
##     $volName -- volume's name
##
## Return
##     $group -- 0 or 1
##     $errCode -- success:undef
##                 fail:error code
sub getGroup() {
    my ( $self, $volName ) = @_;

    my $cmd   = $ddrConst->CMD_VG_GETGROUP;
    my $group = `$cmd $volName 2>/dev/null`;
    if ( $? != 0 ) {
        return ( undef, $ddrConst->ERR_EXECUTE_VGGETGROUP );
    }
    chomp($group);
    return ( $group, undef );
}

# Function
#       Check whether has async operation or not.
# Parameters
#       null
# Return
#       \@result
sub hasAsyncPair() {
    my $self     = shift;
    my $cmd      = $ddrConst->DDR_HASASYNCPAIR4ONENODE_PL;
    my $friendIP = $nsguiCommon->getFriendIP();
    my @result   = ();
    @result = `$cmd 2>/dev/null`;
    if ( defined($friendIP) && $nsguiCommon->isActive($friendIP) == 0 ) {
        my ( $ret, $stdout ) = $nsguiCommon->rshCmdWithSTDOUT( "sudo $cmd 2>/dev/null", $friendIP );
        if ( defined($ret) && $ret == 0 ) {
            push( @result, @$stdout );
        }
    }
    return \@result;
}

# Function
#       Delete a async pair information from ddr_asyncfile.
# Parameters
#       $volName      : volume name
#       $asyncPairFile : the file path of ddr_asyncfile
# Return
#        0x00000000: successful
#        error code: failed
sub delAsyncPairFromFile() {
    my ( $self, $volName, $asyncPairFile ) = @_;
    ## get all async pair info from ddr_asyncfile
    my $asyncPairsHash = &getAsyncPairListHash( $self, $asyncPairFile );
    ## ddr_asyncfile is empty
    if ( scalar( keys %$asyncPairsHash ) == 0 ) {
        return $ddrConst->SUCCESS_CODE;
    }
    ## failed to get async pair info
    if ( defined( $$asyncPairsHash{ $ddrConst->ERR_FLAG } ) ) {
        return $$asyncPairsHash{ $ddrConst->ERR_FLAG };
    }
    ## delete a async pair info from $asyncPairsHash which key is equals with $volName
    if ( defined( $$asyncPairsHash{$volName} ) ) {
        delete( $$asyncPairsHash{$volName} );
    }else {
        return $ddrConst->SUCCESS_CODE;
    }
    ## write info from $asyncPairsHash to ddr_asyncfile
    my $retVal = $volumeCommon->writeAsyncVolToFile( $asyncPairsHash, $asyncPairFile );
    if ( $retVal != 0 ) {
        return $ddrConst->DDR_EXCEP_FAILED_TO_WRITE_ASYNCPAIRINFO;
    }
    return $ddrConst->SUCCESS_CODE;
}

# Function
#       Modify a rv resutl code in file
# Parameters
#       $mvName       : mv name
#       $asyncPairFile : the file path of ddr_asyncfile
#       $rvNo         : the rv number only can be (0,1,2),if $rvNo=undef,then set all result code
#       $resultCode   : the result code
# Return
#        0x00000000: successful
#        error code: failed
sub modifyRvResultCodeInFile() {
    my ( $self, $mvName, $asyncPairFile, $resultCodeHash ) = @_;
    ## get all sync pair info from ddr_syncfile
    my $asyncPairsHash = &getAsyncPairListHash( $self, $asyncPairFile );
    ## nas_fsbatch is empty
    if ( scalar( keys %$asyncPairsHash ) == 0 ) {
        return $ddrConst->ERR_NOT_ASYNC_PAIR_RESULT;
    }
    ## failed to get sync pair info
    if ( defined( $$asyncPairsHash{ $ddrConst->ERR_FLAG } ) ) {
        return $$asyncPairsHash{ $ddrConst->ERR_FLAG };
    }
    ## delete a sync pair info from $asyncPairsHash which key is equals with $volName
    my $oneAsyncPairHash = $$asyncPairsHash{$mvName};
    if ( !defined($oneAsyncPairHash) ) {
        return $ddrConst->ERR_NOT_ASYNC_PAIR_RESULT;
    }
    ## modify a rv result info in $oneAsyncPairHash
    foreach ( keys %$resultCodeHash ) {
        $$oneAsyncPairHash{$_} =~ s/:\S+/:$$resultCodeHash{$_}/;
    }
    $$asyncPairsHash{$mvName} = $oneAsyncPairHash;
    my $retVal = $volumeCommon->writeAsyncVolToFile( $asyncPairsHash, $asyncPairFile );
    if ( $retVal != 0 ) {
        return $ddrConst->DDR_EXCEP_FAILED_TO_WRITE_ASYNCPAIRINFO;
    }
    return $ddrConst->SUCCESS_CODE;
}
###Function : Add a pair info from ddr_asyncfile
###           
###Parameter:
###           $mvName
###           %oneAsyncPairHash
###         
###Return:    0x00000000: successful
###           error code: failed
sub addAsyncPairInfo(){
    my ($self,$oneAsyncPairHash) = @_;
    my $tmpFile = $ddrConst->ASYNCPAIR_FILE;
    if($fileCommon->checkout($tmpFile) != 0 ){
        $ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKOUT);
        return $ddrConst->DDR_EXCEP_CHECKOUT;
    }
    my $retVal = &addAsyncPair2File($self, $oneAsyncPairHash, $tmpFile);
    if($retVal ne $ddrConst->SUCCESS_CODE){
        $fileCommon->rollback($tmpFile);
        $ddrConst->writeLog($retVal);
        return $retVal;
    }
    if($fileCommon->checkin($tmpFile) != 0){
        $fileCommon->rollback($tmpFile);
        $ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKIN);
	    return $ddrConst->DDR_EXCEP_CHECKIN;
    }
    return $ddrConst->SUCCESS_CODE;
}
###Function : Delete pair info from ddr_asyncfile
###
###Parameter:
###           $mvName
###
###Return:    0x00000000: successful
###           error code: failed
sub deleteAsyncPairInfo() {
    my ( $self, $mvName ) = @_;
    my $tmpFile = $ddrConst->ASYNCPAIR_FILE;
    if ( $fileCommon->checkout($tmpFile) != 0 ) {
    	$ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKOUT);
        return $ddrConst->DDR_EXCEP_CHECKOUT;
    }
    my $retVal = &delAsyncPairFromFile( $self, $mvName, $tmpFile );
    if ( $retVal ne $ddrConst->SUCCESS_CODE ) {
    	$ddrConst->writeLog($retVal);
        $fileCommon->rollback($tmpFile);
        return $retVal;
    }
    if ( $fileCommon->checkin($tmpFile) != 0 ) {
        $fileCommon->rollback($tmpFile);
        $ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKIN);
        return $ddrConst->DDR_EXCEP_CHECKIN;
    }
    
    $nsguiCommon->deleteEmptyFile( $tmpFile );
    return $ddrConst->SUCCESS_CODE;
}

###Function : Modify rv result from ddr_asyncfile
###
###Parameter:
###           $mvName
###           %resultHash {rvNo => resultcode}
###
###Return:    0x00000000: successful
###           error code: failed
sub modifyPairResultInfo() {
    my ( $self, $mvName, $rvResultHash ) = @_;
    my $tmpFile = $ddrConst->ASYNCPAIR_FILE;
    if ( $fileCommon->checkout($tmpFile) != 0 ) {
    	$ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKIN);
        return $ddrConst->DDR_EXCEP_CHECKOUT;
    }
    my $retVal = &modifyRvResultCodeInFile( $self, $mvName, $tmpFile, $rvResultHash );
    if ( $retVal ne $ddrConst->SUCCESS_CODE ) {
        $fileCommon->rollback($tmpFile);
        $ddrConst->writeLog($retVal);
        return $retVal;
    }
    if ( $fileCommon->checkin($tmpFile) != 0 ) {
        $fileCommon->rollback($tmpFile);
        $ddrConst->writeLog($ddrConst->DDR_EXCEP_CHECKIN);
        return $ddrConst->DDR_EXCEP_CHECKIN;
    }
    return $ddrConst->SUCCESS_CODE;
}
###Function : Execute [repl2 pair vol -a] to make mv-rv pair
###
###Parameter:
###           $rvInfo: PoolName#mvName#wwnn#rvName
###
###Return:
###           ($result,$rvName)
sub exeRepl2PairVolCmd() {
    my ( $self, $rvInfo) = @_;
    my $repl2PairCmd = $ddrConst->CMD_REPL2_PAIR_VOL;
    my ($poolName,$mvName,$wwnn,$rvName) = split('#',$rvInfo);
    my @rvParam = ('-a');
    my @poolNameAry = split(',', $poolName);
    foreach(@poolNameAry){
        push (@rvParam, '-p');
        push (@rvParam, $_);
    }
    push(@rvParam, $mvName, $wwnn, $rvName); 
    `sudo ${repl2PairCmd} @rvParam >&/dev/null`;
    return ( $? >> 8, $rvName);
}

sub getSyncStatusSimple() {
    my ( $self, $mvName, $rvName ) = @_;
    my $syncStatus  = "--";
    my $cmd         = $ddrConst->CMD_REPL2_INFO_VOL_PAIR . " " . $mvName . " " . $rvName;
    my @volPairInfo = `$cmd 2>/dev/null`;
    if ( $? != 0 ) {
        return ( undef, $ddrConst->ERR_EXECUTE_REPL2_INFO_VOL_PAIR );
    }
    for ( my $i = 0 ; $i < scalar(@volPairInfo) ; $i++ ) {
        if ( $volPairInfo[$i] =~ /^\s*Sync\s*State\s+(\S+)\s*$/ ) {
            $syncStatus = $1;
            last;
        }
    }
    return $syncStatus;
}

###Function : Set check RV info 2 check_rv_capacity cmd parameter
###           -r <RVVG> -p <POOL> [-p <POOL> ...]
###Parameter:
###         $checkParamAry
###         $rvInfo = <poolName>#<mvName>#<wwnn>#<rvName>
###         
###Return:
###         none
sub setCheckRvCapParamAry(){
    my ($self,$rvInfo,$checkParamAry) = @_;
    if(!defined($rvInfo)){
        return;
    }
    my ($poolName,$mvName,$wwnn,$rvName) = split('#',$rvInfo);
    if($$checkParamAry[5] eq "--"){
        $$checkParamAry[5] = $wwnn;
    }
    push (@$checkParamAry,"-r");
    push (@$checkParamAry,$rvName);
    my @poolNameAry = split(',',$poolName);
    foreach(@poolNameAry){
        push (@$checkParamAry,'-p');
        push (@$checkParamAry,$_);
    }
}
###Function : Check parameter $rvInfo if have 4 part devide by '#'
###           Use in ddr_asyncMakePair.pl and ddr_checkPoolCapacity.pl  
###
###Parameter:
###
###         $rvInfo = <poolName>#<mvName>#<wwnn>#<rvName>
###
###Return:
###         1: ok
###         0: error
sub checkRvInfo(){
    my($self,$rvInfo) = @_;
    if(defined($rvInfo)&&($rvInfo =~/^\s*\S+?#\S+?#\S+?#\S+\s*$/)){
        return 1;
    }
    return 0;
}
###Function : Check pool capacity 
###         
###Parameter:
###         $mv     = volume name
###         $rv0Info = <poolName>#<mvName>#<wwnn>#<rvName>
###         $rv1Info = <poolName>#<mvName>#<wwnn>#<rvName>
###         $rv2Info = <poolName>#<mvName>#<wwnn>#<rvName>
###Return:
###         SUCCESS_CODE                 ok
###         ERR_CHECK_RV_CAPACITY        error
sub checkPoolCapacity(){
    my ($self,$mv,$rv0Info,$rv1Info,$rv2Info) = @_;
    my $cmdCheckRvCapacity = $ddrConst->CMD_CHECK_RV_CAPACITY;
    my @checkRvCapParamAry  = ("-c","create","-m",$mv,"-w","--");
    &setCheckRvCapParamAry($self,$rv0Info,\@checkRvCapParamAry);
    &setCheckRvCapParamAry($self,$rv1Info,\@checkRvCapParamAry);
    &setCheckRvCapParamAry($self,$rv2Info,\@checkRvCapParamAry);
    `sudo $cmdCheckRvCapacity @checkRvCapParamAry >&/dev/null`;
    if($?!=0 ){
        return $ddrConst->ERR_CHECK_RV_CAPACITY;
    }
    return $ddrConst->SUCCESS_CODE;
}
1;
