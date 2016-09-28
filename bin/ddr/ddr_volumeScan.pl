#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ddr_volumeScan.pl,v 1.1 2008/04/19 10:00:11 liuyq Exp $"

### Must Execute this command on the FIP node
###

use strict;
use NS::NsguiCommon;
use NS::DdrConst;

my $nsguiCommon = new NS::NsguiCommon;
my $ddrConst    = new NS::DdrConst;

##do not execute vollist command in FIP node
##my $cmd = $ddrConst->CMD_REPL2_VOLLIST_SCAN;
##my $vollist_scan = `$cmd 2>/dev/null`;
##if ($? != 0){
##    $ddrConst->printErrMsg($ddrConst->ERR_EXECUTE_REPL2_VOLLIST_SCAN) ;
##    exit 1;
##}

## vol scan on this node
my $cmdVolScan = $ddrConst->CMD_VOL_SCAN;
my $retVal     = `$cmdVolScan >&/dev/null`;
if ($? != 0){
    $ddrConst->printErrMsg($ddrConst->ERR_EXECUTE_VOL_SCAN);
    exit 1;
}
my $targetIP = $nsguiCommon->getFriendIP();
if(defined($targetIP) && ($nsguiCommon->isActive($targetIP) == 0)){

    ## vol scan on partner node	
    my $retCode = $nsguiCommon->rshCmd("sudo $cmdVolScan >&/dev/null", $targetIP);
    if (!defined($retCode) || $retCode != 0 ){
        $ddrConst->printErrMsg($ddrConst->ERR_EXECUTE_VOL_SCAN_IN_FRIEND_NODE);
        exit 1;
    }

    ## repl2 vollist scan on not FIP node	
    ## my $cmdVollistScan = $ddrConst->CMD_REPL2_VOLLIST_SCAN;
    ## $retCode = $nsguiCommon->rshCmd("sudo $cmdVollistScan >&/dev/null", $targetIP);
    ## if (!defined($retCode) || $retCode != 0){
    ##     $ddrConst->printErrMsg($ddrConst->ERR_EXECUTE_REPL2_VOLLIST_SCAN) ;
    ##     exit 1;
    ## }
}
exit 0;