#!/usr/bin/perl  -w
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# 
 
# "@(#) $Id: cluster_rsh.pl,v 1.2 2006/02/20 01:15:02 dengyp Exp $"

#Function: 
#   execute the specified command.

#Parameters: 
#   @cmds     : to excute command and its parameter.
#   $friendIP : the other node's IP.
#   
#Output:
#   command's STDOUT. 

#STDERR:
#   command's STDERR.
#
#exit code: 
#    command's exit value.
use strict;
use NS::NsguiCommon;
my $comm = new NS::NsguiCommon;

if (scalar(@ARGV) < 2){
    $comm->writeErrMsg($comm->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $rshCmd = $comm->SCRIPT_LOCAL_RSHCMD;
my $friendIP = pop(@ARGV);
my @cmds = ("sudo","-u","nsgui",$rshCmd);
push(@cmds,@ARGV);
push(@cmds,"0",$friendIP);
exec(@cmds);