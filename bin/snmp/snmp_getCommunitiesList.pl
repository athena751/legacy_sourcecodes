#!/usr/bin/perl -w
#	
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#	
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getCommunitiesList.pl,v 1.3 2007/09/10 01:18:58 lil Exp $"

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
#  comNumber
#  communityName
#  source read write notify\tsource read write notify\t...
#  communityName
#  source read write notify\tsource read write notify\t...
#--------------------------------------------
#  recovery=0
#  0
#  errorCom1 errorCom2 ...(0 if no errors in communities)
#  comNumber
#  communityName
#  source read write notify\tsource read write notify\t...
#   .........
use strict;
use NS::NsguiCommon;
use NS::ConstForSNMP;
use NS::SNMPCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $const = new NS::ConstForSNMP;
my $snmpCommon = new NS::SNMPCommon;

my $failed = $snmpCommon->getInfoList4GUI($const->TYPE_COMMUNITIES);
if($failed){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
     exit 1;
}

# get community_max
my $get_maxComm = $const->GET_MAX_COMM_NUM;
system($get_maxComm);

if(!$snmpCommon->recovery()){
    if($snmpCommon->convertHost2IPFailed()){
        $nsguicommon->writeErrMsg($const->ERRCODE_CONVERT_HOST2IP_FAILED,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInCommunities() == 1){#errors only in communities 
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_COMMUNITY4COMMUNITYLIST,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInCommunities() == 2){#errors only in communities 
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_COMMUNITY_IPTABLE,__FILE__,__LINE__+1);
        exit 1;
    }
    exit 0;
}else{
    $nsguicommon->writeErrMsg($const->ERRCODE_RECOVERY, __FILE__, __LINE__+1);
    exit 1;
}