#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_modifyCommunity.pl,v 1.2 2007/07/11 11:51:30 hetao Exp $"

#Function: 
#   modify the community information into /etc/snmp/snmpd.conf

#Arguments: 
#   communityName: community name
#   sourceinfo   : source Info
#   isFoced      : 
#
#exit code:
#   0: succed
#   1: failed
#   2: failed to convert host to ip
#
#error code
#   ERRCODE_PARAMETER_NUMBER_ERROR: the parameter's number is error
#   ERRCODE_COMMUNITY_NOT_EXIST   : the community to modify is not found

use strict;
use NS::ConstForSNMP;
use NS::SNMPCommon;
use NS::NsguiCommon;
my $const=new NS::ConstForSNMP;
my $nsguicommon  = new NS::NsguiCommon;
my $snmpcommon = new NS::SNMPCommon;

if(scalar(@ARGV) != 3){
    $nsguicommon->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($communityName,$srcInfo, $isForced) = @ARGV;
if($isForced eq "true"){
    $isForced = 1; 
}else{
    $isForced = 0;
}
my $ret = $snmpcommon->modifyCommunity4GUI($communityName, $srcInfo, $isForced);
if($ret == 0){
    print "false";
    exit 0;
}elsif($ret == 1){
    print STDERR $snmpcommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
}elsif($ret == 2){
    #failed to convert host to ip
    print "true";
    exit 0;
}elsif($ret == 3){
    #the community to modify is not found
    $nsguicommon->writeErrMsg($const->ERRCODE_COMMUNITY_NOT_EXIST,__FILE__,__LINE__+1);
}elsif($ret == 4){
    #max number
    $nsguicommon->writeErrMsg($const->ERRCODE_MAX_COMMUNITY_EXIST_MODIFY,__FILE__,__LINE__+1);
}elsif($ret == 5){

	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPDCONF_MODIFY_FAILED, __FILE__,__LINE__+1);
}elsif($ret == 6){

	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPTRAP_MODIFY_FAILED, __FILE__,__LINE__+1);
}

exit 1;