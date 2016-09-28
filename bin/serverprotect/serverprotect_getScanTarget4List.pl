#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_getScanTarget4List.pl,v 1.2 2007/03/23 05:20:36 qim Exp $"

# Function:
#       Get the Scan Target.
# Parameters:
#       groupN
#       computerName
# output:
#       shareName=
#       writeCheck=
#       readCheck=
#       sharePath=
#
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::ServerProtectConst;
use NS::ServerProtectCommon;

my $const = new NS::ServerProtectConst;
my $serverprotectCommon = new NS::ServerProtectCommon;

if(scalar(@ARGV)!=2)
{
    print STDERR "Parameter'number Error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupN = shift;
my $computerName = shift;

my $configfile = $serverprotectCommon->getConfFilePath($groupN,$computerName);
my $cmd_cat = $const->CMD_CAT;
my @content;

if(-f $configfile){
    @content = `$cmd_cat $configfile 2>/dev/null`;
}else{
    print STDERR "Open $configfile failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $scanTargetInfo = $serverprotectCommon->getScanTargetInfo(\@content);
print @$scanTargetInfo;
exit 0;
