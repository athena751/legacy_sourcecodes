#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_getScanServer4List.pl,v 1.2 2007/03/23 05:20:31 wanghb Exp"
# Function:
#       Get the Scan Server with connect status for list.
# Parameters:
#       groupN
#       computerName
# output:
#       host=
#       interfaces=
#       connectStatus=
#
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::ServerProtectCommon;
use NS::ServerProtectConst;

my $serverprotectCommon = new NS::ServerProtectCommon;
my $const = new NS::ServerProtectConst;

if(scalar(@ARGV)!=2)
{
    print STDERR "Parameter'number Error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupN = shift;
my $computerName = shift;
my $configfile = $serverprotectCommon->getConfFilePath($groupN,$computerName);
my $command_ctl = $const->COMMAND_NVAVS_DAEMON_CTL;
my $command_stat = $const->COMMAND_NVAVS_STAT;

my @content=();
if(-f $configfile){
    @content = `cat $configfile 2>/dev/null`;
}else{
    print STDERR "Open $configfile failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my @scanServerInfo = $serverprotectCommon->getScanServerInfo(\@content);
my $exitCode = system("$command_ctl -l -g \Q$groupN\E -n \Q$computerName\E >&/dev/null");
$exitCode = $exitCode >> 8;
if( $exitCode == 0 ){
    my %connectInfo=();
    @content=`$command_stat -c -g \Q$groupN\E -n \Q$computerName\E 2>/dev/null`;
    foreach(@content){
        if ($_=~/^\s*(\S+)\s+(connect|disconnect)\s*$/) {
            $connectInfo{$1}=$2;
        }
    }
    my $host="";
    for(my $i = 0; $i < scalar(@scanServerInfo); $i+=3){
        $host = $scanServerInfo[$i];
        if( $host=~/^\s*host\s*=\s*(\S+)\s*$/ && defined($connectInfo{$1}) ){
            $scanServerInfo[$i+2] = "connectStatus=$connectInfo{$1}\n";
        }
    }
}elsif( $exitCode == 100 || $exitCode == 101 || $exitCode == 102 ){
    my $connectStatus="";
    for(my $i = 0; $i < scalar(@scanServerInfo); $i++){
        $connectStatus = $scanServerInfo[$i];
        if($connectStatus=~/^\s*connectStatus\s*=\s*(.*)\s*$/){
            $scanServerInfo[$i] = "connectStatus=disconnect\n";
        }
    }
}else{
}
print @scanServerInfo;
exit 0;
