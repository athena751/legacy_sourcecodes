#!/usr/bin/perl -w	
#	
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#	
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_addCommunity.pl,v 1.4 2007/07/11 11:51:30 hetao Exp $"

#Function: 
#   add the community information into /etc/snmp/snmpd.conf

#Arguments: 
#   communityName----------community name
#   sourceInfo------source  


#exit code:
#   0---------succeeded 
#   1---------failed
#error code:
#   ERRCODE_PARAMETER_NUMBER_ERROR: the parameter's number is error
#   ERRCODE_MAX_COMMUNITY_EXIST   : the communities pairs' number has be max number
#   ERRCODE_COMMUNITY_EXIST       : the community to add has existed

use strict;
use NS::ConstForSNMP;
use NS::SNMPCommon;
use NS::NsguiCommon;

my $const=new NS::ConstForSNMP;
my $nsguicommon  = new NS::NsguiCommon;
my $snmpcommon=new NS::SNMPCommon;

if(scalar(@ARGV)!=2){
    $nsguicommon->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($communityName,$srcInfo) = @ARGV;
my $ret = $snmpcommon->addCommunity4GUI($communityName,$srcInfo);
if($ret == 0){
    exit 0;
}elsif($ret == 1){
    print STDERR $snmpcommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
}elsif($ret == 2){
    #todo:max number
    $nsguicommon->writeErrMsg($const->ERRCODE_MAX_COMMUNITY_EXIST,__FILE__,__LINE__+1);
}elsif($ret == 3){
    #todo:community to add has existed
    $nsguicommon->writeErrMsg($const->ERRCODE_COMMUNITY_EXIST,__FILE__,__LINE__+1);
}elsif($ret == 4){
    my $failedHostHashRef = $snmpcommon->getFailedHosts();
    my @failedHosts = keys(%$failedHostHashRef);
    if(scalar(@failedHosts) > 0){
        print STDERR "Failed to convert the following hosts to IP:@failedHosts\n";
    }    
    $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_FAILED_CONVERT_HOST2IP_ADDCOM,__FILE__,__LINE__+1);
}elsif($ret == 5){

	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPDCONF_ADD_FAILED, __FILE__,__LINE__+1);
}elsif($ret == 6){

	$nsguicommon->writeErrMsg($const->ERRCODE_SNMPTRAP_ADD_FAILED, __FILE__,__LINE__+1);
}


exit 1;
