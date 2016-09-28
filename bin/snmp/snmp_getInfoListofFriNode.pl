#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getInfoListofFriNode.pl,v 1.1 2005/08/23 09:21:15 liuhy Exp $"

#Function: 
#   add the user information into /etc/snmp/snmpd.conf

#Arguments: 
#   userName----------user name

#exit code:
#   0---------succed
#   1---------failed

use strict;
use NS::NsguiCommon;
use NS::SNMPCommon;
use Data::Dumper;

my $comm  = new NS::NsguiCommon;
my $snmpCommon = new NS::SNMPCommon;

my $type = shift;
my $infoListOfFriNode = $snmpCommon->getInfoListInFriend($type);
if(!defined($infoListOfFriNode)){
    comm->writeErrMsg("Failed to get information for $type",__FILE__,__LINE__+1);
    exit 1;
}
print Dumper $infoListOfFriNode;

