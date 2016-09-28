#!/usr/bin/perl -w
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_canSetDirectHosting.pl,v 1.2 2008/05/09 02:48:15 chenbc Exp $"
#
#Function:
#    judge whether self node can set direct hosting.
#    if there are more than 1 windows domain has been set, 
#    it means that you can not set direct hosting.
#Arguments:
#    $groupNumber
#Exit code:
#    0 : executed successfully
#    1 : executed failed
#Output:
#    yes : can set direct hosting
#     no : can NOT set direct hosting 
# 

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;

my $comm = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV) != 1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my $groupNumber = $ARGV[0];

my $virtual_servers = $cifsCommon->getVsFileName($groupNumber);
my $windowsDomainCount = 0;
if(-f $virtual_servers) {
    my @virtual_servers_content = `cat $virtual_servers 2>/dev/null`;
    my $newContent = $comm->getVSContent(\@virtual_servers_content);
    foreach(@$newContent) {
        if(/^\s*\/\S+\s+\S+\s+\S+\s*$/) {
            $windowsDomainCount ++;
        }
        if($windowsDomainCount > 1) {
            print "no\n";
            exit 0;
        }
    }
}
print "yes\n";
exit 0;
