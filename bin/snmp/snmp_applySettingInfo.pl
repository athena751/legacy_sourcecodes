#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_applySettingInfo.pl,v 1.2 2007/07/11 11:51:30 hetao Exp $"

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

if(scalar(@ARGV)!=0){
    $nsguicommon->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $retValue = $snmpCommon->recoveryProcess();

if($retValue == 1){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}elsif($retValue == 5){

	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPDCONF_SYNC_FAILED, __FILE__,__LINE__+1);
	exit 1;
}elsif($retValue == 6){

	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPTRAP_SYNC_FAILED, __FILE__,__LINE__+1);
	exit 1;
}else{
    exit 0;
}