#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_deleteCommunity.pl,v 1.2 2007/07/11 11:51:30 hetao Exp $"

#Function: 
#   delete the community information into /etc/snmp/snmpd.conf

#Arguments: 
#   communityName: community name
#   isForced:       
#
#exit code:
#   0: succed 
#   1: failed
#   2: failed to convert host to IP
#
#error code:
#   ERRCODE_PARAMETER_NUMBER_ERROR: the parameter's number is error


use strict;
use NS::ConstForSNMP;
use NS::SNMPCommon;
use NS::NsguiCommon;
my $const=new NS::ConstForSNMP;
my $nsguicommon  = new NS::NsguiCommon;
my $snmpcommon = new NS::SNMPCommon;

if(scalar(@ARGV) != 2){
    $nsguicommon->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($communityName,$isForced) = @ARGV;
if($isForced eq "true"){
    $isForced = 1; 
}else{
    $isForced = 0;
}
my $ret = $snmpcommon->deleteCommunity4GUI($communityName,$isForced);
if($ret == 0){
    print "false";
    exit 0;
}elsif($ret == 1){
    print STDERR $snmpcommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
}elsif($ret == 2){
    #failed to convert host to IP
    print "true";
    exit 0;
}elsif($ret == 5){
	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPDCONF_DELETE_FAILED, __FILE__,__LINE__+1);
	exit 1;
}elsif($ret == 6){
	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPTRAP_DELETE_FAILED, __FILE__,__LINE__+1);
	exit 1;
}


exit 1;