#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_check_smbstatus.pl,v 1.4 2006/08/21 10:25:25 zhangjx Exp $"

#    Function: check whether the specified export has any CIFS connection
#
#    Parameter:
#            g_num            ----- "0" | "1"   
#            ntdomain         ----- domain name
#            netbios          ----- computer name    
#
#    Return value:
#            yes , has CIFS connection
#            no , no CIFS connection 

use strict;
use NS::CIFSCommon;

if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 3 parameters.\n";
    exit(255);
}
my ($g_num, $ntdomain, $netbios) = @ARGV;
my $cifCom = new NS::CIFSCommon;

#get share list
#my $share_list = $cifCom->getAllShareName(${g_num},$ntdomain,$netbios);
my $isBusy = "false";
$isBusy = $cifCom->isWorkingShare(${g_num},$ntdomain,$netbios,".+");
chomp($isBusy);
if ($isBusy eq "true"){
    exit 1;
}
#foreach (@$share_list){
#    $isBusy = $cifCom->isWorkingShare(${g_num},$ntdomain,$netbios,$_);
#    chomp($isBusy);
#    if ($isBusy eq "true"){
#        exit 1;
#    }
#}
exit 0;