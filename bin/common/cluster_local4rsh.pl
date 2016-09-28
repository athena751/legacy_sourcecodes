#!/usr/bin/perl  -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# 
 
# "@(#) $Id: cluster_local4rsh.pl,v 1.3 2004/08/30 09:02:42 changhs Exp $"

#Function: 
#   execute the specified command.

#Parameters: 
#   @cmds     : to excute command and its parameter.
#   $pwdCount : the parameters' number to be passed by <STDIN>
#   $friendIP : the other node's IP.
#   
#Output:
#   command's STDOUT. 

#STDERR:
#   when command successfully executed,command's STDERR.
#   when command excute failed,the error message include errorCode.
#
#exit code: 
#    command's exit value.

use strict;
use NS::NsguiCommon;
my $comm = new NS::NsguiCommon;

if (scalar(@ARGV) < 3){
    $comm->writeErrMsg($comm->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $targetIP = pop(@ARGV);
if ($comm->isActive($targetIP) != 0){
    $comm->writeErrMsg($comm->ERRCODE_TARGET_NOT_ACTIVE,__FILE__,__LINE__+1);
    exit 1;
}

my $pwdCount = pop(@ARGV);
my $hexCmds = &cmds2hexstr(\@ARGV);
my $hexPwds = "";
my @pwds = ();

if ($pwdCount > 0){
    my $tmppwd="";
    for (my $i = 0 ; $i < $pwdCount ; $i ++){
        $tmppwd = <STDIN>;
        push (@pwds,$tmppwd);
    }
}
$hexPwds = &cmds2hexstr(\@pwds);

my $remoteRshCmd = $comm->SCRIPT_REMOTE_RSHCMD;
my $rshcmd = "/usr/bin/rsh ${targetIP} $remoteRshCmd $hexCmds $hexPwds";
my @content=`$rshcmd`;
if ($? != 0){
    $comm->writeErrMsg($comm->ERRCODE_RSH_COMMAND_FAILED,__FILE__,__LINE__+1);
    exit 1;
}
my $retLine;
if (scalar(@content) > 0){
    $retLine = $content[scalar(@content)-1];
}
#get the exit value of the command! it is printed in the last Line of STDOUT .
if (defined($retLine) 
    && $retLine =~ /^\s*rsh\s*command\s*excuted\s*result\s*:\s*([\-]*\d+)\s*$/){
    my $ret = $1;
    pop(@content);
    if (scalar(@content) > 0  && $content[scalar(@content) - 1 ] =~ /^$/){
        pop(@content);
    }
    print @content;
    exit $ret;
}else{
    $comm->writeErrMsg($comm->ERRCODE_RSH_COMMAND_FAILED,__FILE__,__LINE__+1);
    exit 1;
}

sub cmds2hexstr() {
    my $tmpCmds = shift;
    my $hexstr = "";
    foreach (@$tmpCmds){
        $_ = $comm->str2hex($_);
    }
    $hexstr = join("#",@$tmpCmds);
    return $hexstr;
}
