#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getUserInfo.pl,v 1.1 2005/08/21 04:53:28 zhangj Exp $"

#Function: 
#   get information of specified user from  /etc/snmp/snmpd.conf

#Arguments: 
#   user

#exit code:
#   0: succed 
#   1: failed

#output
#-------------------------------------------------
#  source read write notify
#  source read write notify
#   .........

use strict;
use NS::NsguiCommon;
use NS::SNMPCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $snmpCommon = new NS::SNMPCommon;
use NS::ConstForSNMP;

my $const = new NS::ConstForSNMP;
if(scalar(@ARGV)!=1){
    $nsguicommon->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}


my $user = shift;
my $failed = $snmpCommon->printUserInfo4GUI($user);
if($failed){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
exit 0;
