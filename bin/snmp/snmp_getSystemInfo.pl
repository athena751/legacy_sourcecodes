#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getSystemInfo.pl,v 1.1 2005/08/21 04:53:28 zhangj Exp $"

#Function: 
#   get information of system subtree,  communites,users from  /etc/snmp/snmpd.conf

#Arguments: 
#   none

#exit code:
#   0---------succed 
#   1---------failed
#output
#-------------------------------------------------
#  recovery=1
#  1(sign recovery)
#  node number 
#  systemlocation NEC
#  systemcontact root
#  another node number
#  systemlocation NEC
#  systemcontact root
#--------------------------------------------
#  recovery=0
#  0(sign not recovery)
#  systemlocation NEC
#  systemcontact root

use strict;
use NS::NsguiCommon;
use NS::ConstForSNMP;
use NS::SNMPCommon;

my $common  = new NS::NsguiCommon;
my $const = new NS::ConstForSNMP;
my $snmpCommon = new NS::SNMPCommon;

my $failed = $snmpCommon->getInfoList4GUI($const->TYPE_SYSTEM);
if($failed){
    print STDERR $snmpCommon->error();
    $common->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if($snmpCommon->recovery()){
    $common->writeErrMsg($const->ERRCODE_RECOVERY, __FILE__, __LINE__+1);
    exit 1;
}
exit 0;
