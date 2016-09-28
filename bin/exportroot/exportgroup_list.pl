#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: exportgroup_list.pl,v 1.3 2004/08/24 09:55:53 xiaocx Exp $"
#Function: 
#   Get exporgroup and codepage according to file: /etc/group[0|1]/expgrps

#Parameters: 
#   groupNo -- [0|1]

#Output:
#   exportgroup1    codepage1
#   exportgroup2    codepage2
#   ......

#exit code:
#   0 -- successful 
#   1 -- failed
use strict;
use NS::ExportgroupFun;
use NS::ExportgroupConst;
use NS::APICommon;
use NS::NsguiCommon;

my $func  = new NS::ExportgroupFun;
my $const   = new NS::ExportgroupConst;
my $common  = new NS::APICommon();
my $cluster = new NS::NsguiCommon;

if (scalar(@ARGV) != 1){
    print STDERR " ",__FILE__,"  parameter error!\n";
    $cluster->writeErrMsg($const->ERR_CODE_PARAMETER_NUM);
    exit 1;
}

my $groupNo = shift;
my $etcPath = "/etc/group${groupNo}/";
my $filename = $etcPath."cfstab";
my @cfstab = `cat ${filename} 2>/dev/null`;


my @alldomain=();
my $ims_conf= "/etc/group${groupNo}/ims.conf";
if (-f $ims_conf){
    @alldomain = `/usr/bin/ims_domain -Lv -c $ims_conf 2>/dev/null`;
}

my $refResult = $func->getExportGroupInfo($etcPath);
my $allNTDomainAndNetbios = $common->getALLLocalDomainAndNetbios($etcPath);
if(!defined($refResult) || !defined($allNTDomainAndNetbios)){
    $cluster->writeErrMsg($const->ERR_CODE_LIST_EXPORTGROUP);
    exit 1;
}

my @allkeys = keys(%$refResult);
foreach (@allkeys) {
    my $path = $_;
    my $domainAndNetbios = $$allNTDomainAndNetbios{$path};
    my $domain = "-";
    my $netbios = "-";
    if(defined($domainAndNetbios)){
        $domain = $$domainAndNetbios[0];
        $netbios = ($$domainAndNetbios[1] ne "")?$$domainAndNetbios[1]:"-";
    }
    my $mounted = $func->checkMounted($path,\@cfstab);
    my $userdb = $func->checkUserDB($path,\@alldomain);
    print "$_\t$$refResult{$_}\t$domain\t$netbios\t$mounted\t$userdb\n";  #path coding domain netbios mounted
}
exit 0;