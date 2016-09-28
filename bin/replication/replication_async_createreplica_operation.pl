#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: replication_async_createreplica_operation.pl,v 1.5 2007/07/09 04:53:56 xingyh Exp $"

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;
use NS::ReplicationConst;
use NS::SystemFileCVS;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;
my $repliConst = new NS::ReplicationConst;
my $fileCommon = new NS::SystemFileCVS;

my $success = $volumeConst->SUCCESS_CODE;

my $repliParam = pop(@ARGV);
$repliParam =~ s/,/ /g;
foreach(@ARGV){
    if($_ =~ /\(|\)/){
        $_ = "\"".$_."\"";
    }
}
my $volumeParam = join(" ", @ARGV);
my $volName = $ARGV[2];

my $script_operation = $volumeConst->SCRIPT_VOLUME_ASYNC_OPERATION;
my @retAry = `sudo $script_operation $volumeParam >&/dev/null`;
my $retVal = $?;
if($retVal != 0){
    exit $retVal/256;
}


my $script_createRepica = $repliConst->SCRIPT_REPLI_CREATE_REPLICA;
@retAry = `sudo $script_createRepica $repliParam 2>&1`;
$retVal = $?;
my $errCode = $success;
if($retVal != 0){
    foreach(@retAry){
        if($_ =~ /\berror_code=(0x124[\da-fA-F]{5})\b/){
           $errCode = $1;
        }
    }
}else{
	$errCode = undef;
}
my $retStr = $volumeCommon->modifyAsyncFile($volName, $errCode, "yes");
if($retStr ne $success){
	$volumeConst->writeSysLog($volumeConst->ERR_EDIT_TMPFILE);
}
exit $retVal/256;
