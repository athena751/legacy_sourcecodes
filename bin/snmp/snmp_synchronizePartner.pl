#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_synchronizePartner.pl,v 1.3 2007/07/12 00:56:31 caows Exp $"

#Function: 
#   add the user information into /etc/snmp/snmpd.conf

#Arguments: 
#   userName----------user name

#exit code:
#   0---------succed
#   1---------failed

use strict;
use NS::NsguiCommon;
use NS::ConstForSNMP;
use NS::SNMPCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $const=new NS::ConstForSNMP;
my $snmpCommon = new NS::SNMPCommon;

if(scalar(@ARGV) != 1){
    $nsguicommon->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
if($ARGV[0] ne $const->TYPE_ALL 
   && $ARGV[0] ne $const->TYPE_COMMUNITIES
   && $ARGV[0] ne $const->TYPE_USERS
   && $ARGV[0] ne $const->TYPE_SYSTEM){
    $nsguicommon->writeErrMsg("The parameter is error",__FILE__,__LINE__+1);
    exit 1;
}
my $retValue = $snmpCommon->partennerProcess($ARGV[0]);
    
if($retValue != 0){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}else{
    exit 0;
}