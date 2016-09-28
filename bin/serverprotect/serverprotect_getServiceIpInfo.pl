#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_getServiceIpInfo.pl,v 1.1 2007/03/23 05:30:06 qim Exp $"

#Function: get available Service LAN NIC  
#Parameters:

#output:
    #serviceInterfaces      ------ available Service LAN NIC
    #serviceInterfacesLabel ------ available Service LAN NIC + Name
#exit code:
    #0 ---- success
    #1 ---- failure
    
use strict;
use NS::CIFSCommon;
use NS::NsguiCommon;
use NS::CIFSConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV)!=0){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($serviceInterfaces, $serviceInterfacesLabel) = $cifsCommon->getAllInterfaces();
print "$serviceInterfaces\n";
print "$serviceInterfacesLabel\n";

exit 0;
