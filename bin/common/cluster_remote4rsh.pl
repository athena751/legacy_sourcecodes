#!/usr/bin/perl  -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# 
 
# "@(#) $Id: cluster_remote4rsh.pl,v 1.4 2005/08/21 06:50:20 zhangj Exp $"

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

if (scalar(@ARGV) < 1){
    $comm->writeErrMsg($comm->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $hexCmds = shift;
my $hexPwds = shift;
my @cmds = ();
my @pwds = ();

#print "in remote: ".$hexCmds."\n";
if ($hexCmds ne ""){
    my $tmpret = &hexstr2cmds($hexCmds);
    @cmds = @$tmpret;
}else{
    exit 1;
}
if (defined($hexPwds) && $hexPwds ne ""){
    my $tmpret = &hexstr2cmds($hexPwds);
    @pwds = @$tmpret;
}

my $ret=0;
if (scalar(@pwds) <= 0 ){
    $ret = system(@cmds)/256;
    print STDOUT "\nrsh command excuted result : $ret\n";
    exit 0;
}

my $pid = open(KID_TO_WRITE, "|-");
if (!defined($pid)) {
    print STDERR "Can not fork child process\n";
    exit 1;
}
if ($pid) {  # parent process
    foreach(@pwds){
        print KID_TO_WRITE $_;
    }
    close(KID_TO_WRITE) ;
    $ret = $?/256;
    print STDOUT "\nrsh command excuted result : $ret\n";
    exit 0;
} else {     # child process
    exec @cmds;
}

sub hexstr2cmds() {
    my $hexstr = shift;
    my @tmpCmds = split("#",$hexstr,-1);
    foreach (@tmpCmds){
        $_ = $comm->hex2str($_);
    }
    return \@tmpCmds;
}