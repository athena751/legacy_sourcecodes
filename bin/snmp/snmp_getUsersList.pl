#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getUsersList.pl,v 1.1 2005/08/21 04:53:28 zhangj Exp $"

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
#  user number 
#  username AuthProtocol PrivProtocol 
#  username AuthProtocol PrivProtocol
#  ....
#--------------------------------------------
#  recovery=0
#  0(sign not recovery)
#  user number 
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

my $failed = $snmpCommon->getInfoList4GUI($const->TYPE_USERS);
if($failed){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}
if(!$snmpCommon->recovery()){
    if($snmpCommon->errorsInUsers() == 1){#errors only in users
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_USER,__FILE__,__LINE__+1);
        exit 1;
    }
    if($snmpCommon->errorsInUsers() == 2){#errors only in users
        $nsguicommon->writeErrMsg($const->ERRCODE_ERROR_IN_USER_IPTABLE,__FILE__,__LINE__+1);
        exit 1;
    }
    exit 0;
}else{
    $nsguicommon->writeErrMsg($const->ERRCODE_RECOVERY, __FILE__, __LINE__+1);
    exit 1;
}

