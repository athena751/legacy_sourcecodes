#!/usr/bin/perl
#copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_getlinkdowninfo.pl,v 1.3 2007/08/28 04:58:31 chenbc Exp $"
#Function :
    #use command(linkdown_ctl status) to get portfail over 's info.
#Arguments: --
#exit code:
    #0:succeed 
    #1:error
    #2:known error
#output:
    #takeOver=yes|no
    #bondDown=all|each
    #checkInterval=30
    #ignoreList=xx,xx
use strict;
use NS::NsguiCommon;
use NS::NicCommon;
my $com = new NS::NsguiCommon;
my $nicCmn = new NS::NicCommon;

my $command="/usr/sbin/linkdown_ctl status 2>/dev/null";
my $to="takeOver";
my $bd="bondDown";
my $ci="checkInterval";
my $ig="ignoreList";
my %linkinfo=($to=>"no",$bd=>"all",$ci=>"30",$ig=>"");
my @linkdowninfo=`$command`;
my $errorcode=$?/256;
if ($errorcode==2){
    print STDERR $nicCmn->ERRMSG_CONF_FILE_NOT_EXIST."\n";
    $com->writeErrMsg($nicCmn->ERRCODE_CONF_FILE_NOT_EXIST, __FILE__, __LINE__);
    exit 1;
}elsif($errorcode!=0){
    print STDERR 'Failed to get linkdown status. Exit in perl script:',
                 __FILE__, ' Line:', __LINE__+1, ".\n";
    exit 1;
} 

foreach (@linkdowninfo){
    if (/^\s*take\s+over\s+at\s+link\s+down\s*:\s*(yes|no)\s*$/){
        $linkinfo{$to}=$1;
    }elsif (/^\s*bonding\s+interface\s+down\s*:\s*(all|each)\s*$/){
        $linkinfo{$bd}=$1;
    }elsif (/^\s*check\s+interval\s*:\s*(\d+)\s*$/){
        $linkinfo{$ci}=$1;
    }elsif (/^\s*ignore\s+interface\(s\)\s*:\s*(\S+)\s*$/){
        $linkinfo{$ig}=$1;
    }
}

print "$to=$linkinfo{$to}\n";
print "$bd=$linkinfo{$bd}\n";
print "$ci=$linkinfo{$ci}\n";
print "$ig=$linkinfo{$ig}\n";

exit 0;