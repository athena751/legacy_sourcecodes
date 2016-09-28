#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_canAddShare.pl,v 1.3 2007/04/01 05:17:42 fengmh Exp $"

#Function: check there is volumes for CIFS share or not 
#Parameters:
    #$groupNumber      : the group number 0 or 1
    #$exportGroup      : the Export Group
    #$shareType        : if it is "special", just when sxfsfw volumes exist, output "true".
#output:
    #true  ------ there is volumes for CIFS share
    #false ------ there is not volumes for CIFS share
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV)!=2 && scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $exportGroup = shift;
my $shareType   = shift;
defined($shareType) or $shareType = "";

my $mountPointInfo = $cifsCommon->getMpInfo($groupNumber, $exportGroup);

my $has_sxfs = 0;

foreach my $mp (@$mountPointInfo){
    if($mp =~ /,sxfsfw,/){
        print "true\n";
        exit 0;
    } else {
        if($shareType eq "special") {
            next;
        } else {
            if($mp =~ /,sxfs,y,/){
                print "true\n";
                exit 0;
            }elsif($mp =~ /,sxfs,n,/){
                $has_sxfs = 1;
            }
        }
    }
}
if($has_sxfs == 1){
    #only has the unix volume, and need to check the unix domain
    my $home = $ENV{HOME} || "/home/nsadmin";
    my @domainInfo = `${home}/bin/userdb_getdomaininfo.pl $exportGroup sxfs $groupNumber`;
    chomp($domainInfo[0]);
    if($domainInfo[0] ne ""){
        print "true\n";
        exit 0;
    }
}

print "false\n";
exit 0;