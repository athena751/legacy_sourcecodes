#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getInterfaceFromSmb.pl,v 1.1 2004/09/03 09:04:45 baiwq Exp $"

#Function: 
    #get the interfaces from smb.conf.%L file
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
#exit code:
    #0:succeed 
    #1:failed
#output:
    #   "\n" | "<IP>\n"

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName) = @ARGV;

my $smbContent = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);

my $interfaces = $confCommon->getKeyValue("interfaces", "global", $smbContent);
defined($interfaces) or $interfaces = "";

print "$interfaces\n";

exit 0;