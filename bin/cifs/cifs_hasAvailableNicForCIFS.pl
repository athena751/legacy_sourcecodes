#!/usr/bin/perl -w
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_hasAvailableNicForCIFS.pl,v 1.1 2005/12/14 05:42:05 fengmh Exp $"

#Function: check has available Service LAN NIC or not 
#Parameters:

#output:
    #true  ------ has available Service LAN NIC
    #false ------ has no available Service LAN NIC
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

my ($allInterfaces, $allInterfacesLabel) = $cifsCommon->getAllInterfaces();

if($allInterfaces eq ""){
    print "false\n";
}else{
    print "true\n";
}

exit 0;