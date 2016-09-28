#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getInfoList.pl,v 1.1 2005/08/21 04:53:28 zhangj Exp $"

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
#  comNo
#  communityName 
#  source read write notify 0/1(filtering) source read write notify 0/1(filtering) ...
#  communityName
#  source read write notify 0/1(filtering)
#  userNo
#  username AuthProtocol PrivProtocol 
#  username AuthProtocol PrivProtocol
#  another node number
#  systemlocation NEC
#  systemcontact root
#--------------------------------------------
#  recovery=0
#  0(sign not recovery)
#  systemlocation NEC
#  systemcontact root
#  errorCom1 errorCom2 ...(0 if no errors in communities)
#  comNo
#  communityName
#  source read write notify 0/1(filtering) source read write notify 0/1(filtering) ...
#  communityName
#  source read write notify 0/1(filtering)
#  userNo
#  username AuthProtocol PrivProtocol 
#  username AuthProtocol PrivProtocol
#  ....
use strict;
use NS::NsguiCommon;
use NS::ConstForSNMP;
use NS::SNMPCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $const = new NS::ConstForSNMP;
my $snmpCommon = new NS::SNMPCommon;

my $failed = $snmpCommon->getInfoList4GUI($const->TYPE_ALL);
if($failed){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if(!$snmpCommon->recovery()){
    if($snmpCommon->convertHost2IPFailed()){
        $nsguicommon->writeErrMsg($const->ERRCODE_CONVERT_HOST2IP_FAILED,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInCommunities() == 1  && $snmpCommon->errorsInUsers() == 1){#errors both in communities and users
        #todo:max number
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_USER_COMMUNITY,__FILE__,__LINE__+1);
         exit 1;
    }
    if($snmpCommon->errorsInCommunities() ==1){#errors only in communities 
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_COMMUNITY,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInUsers() ==1){#errors only in users
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_USER,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInCommunities() == 2  && $snmpCommon->errorsInUsers() == 2){#errors both in communities and users
        #todo:max number
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_USER_COMMUNITY_IPTABLE,__FILE__,__LINE__+1);
         exit 1;
    }
    if($snmpCommon->errorsInCommunities() == 2){#errors only in communities 
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_COMMUNITY_IPTABLE,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInUsers() == 2){#errors only in users
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_USER_IPTABLE,__FILE__,__LINE__+1);
        exit 1;
    }
     exit 0;
}else{
    if($snmpCommon->convertHost2IPFailed()){
        $nsguicommon->writeErrMsg($const->ERRCODE_RECOVERY_CONVERT_HOST2IP_FAILED, __FILE__, __LINE__+1);
    }else{
        $nsguicommon->writeErrMsg($const->ERRCODE_INFO_RECOVERY, __FILE__, __LINE__+1);
    }
    exit 1;
}
