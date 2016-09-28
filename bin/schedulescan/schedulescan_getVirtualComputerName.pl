#!/usr/bin/perl -w
#       Copyright (c)2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_getVirtualComputerName.pl,v 1.1 2008/05/08 09:15:30 chenbc Exp $"

# Function:
#       Get the virtual Computer Name for Schedule Scan.
# Parameters:
#       nodeNo
#       exportGroup
#       domainName
# output:
#       computerName
# Return value:
#       0: successfully exit;
#       1: parameters error or command running error occured;
use strict;
use NS::ScheduleScanCommon;
my $SSComm = new NS::ScheduleScanCommon;
if(scalar(@ARGV)!=3)
{
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my ($nodeNo,$exportGroup,$domainName)=@ARGV;
my $computerName = $SSComm->getComputerName4ScheduleScan($nodeNo,$exportGroup,$domainName);

if(!defined($computerName)){
    $computerName="";
}
print $computerName, "\n";

exit 0;
