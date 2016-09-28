#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_setSysInfo.pl,v 1.5 2007/07/12 03:10:08 caows Exp $"

#Function: 
#   modify information of system subtree in /etc/snmp/snmpd.conf

#Arguments: 
#   sysContact----------sysContact
#   sysLocation------sysLocation 

#exit code:
#   0---------succed 
#   1---------failed

use strict;
use NS::NsguiCommon;
use NS::ConstForSNMP;
use NS::SNMPCommon;

my $comm  = new NS::NsguiCommon;
my $const=new NS::ConstForSNMP;
my $snmpCommon = new NS::SNMPCommon;

if(scalar(@ARGV)!=2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($sysContact, $sysLocation) = @ARGV;

my ($ret,$errcode) = $snmpCommon->snmpProcess(\&modifySysInfo,'isNotCommunity');
if($ret == 0){
    exit 0;
}elsif($ret == 1 && !defined($errcode)){
    print STDERR $snmpCommon->error();
    $comm->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}elsif($ret == 5){
	$comm->writeErrMsg($const->ERRCODE_SETSYS_FAILED, __FILE__,__LINE__+1);
	exit 1;
}else{
    $comm->writeErrMsg($errcode,__FILE__,__LINE__+1);
    exit 1;
}
#Function:
#   modify system's information of the @$confContent
#parameters:
#   $confContent: the reference to the array of snmp's content
#return:
#   0------succeed
#   1------failed

sub modifySysInfo(){
    my ($useless,$confContent) = @_;
    my $SYSLOCATION = $const->SYSLOCATION;
    my $SYSCONTACT = $const->SYSCONTACT;
    my $locationFinded = 0;             #syslocation hasn't been found
    my $contactFinded = 0;              #syscontact hasn't been found
    foreach(@$confContent){
        if(/^\s*${SYSCONTACT}\s+/i){    #the line such as:  syscontact	root<root@necas.nec.com.cn>
            $_ = "${SYSCONTACT} ${sysContact}\n";
            $contactFinded = 1;         #syscontact has been found
        }elsif(/^\s*${SYSLOCATION}\s+/i){   #the line such as:  syslocation	NECAS 8F-South 
            $_ = "${SYSLOCATION} ${sysLocation}\n";
            $locationFinded = 1;        #syslocation has been found
        }
    }
    if($contactFinded == 0 || $locationFinded == 0){
        print STDERR "Directive \"$SYSLOCATION\" or \"$SYSCONTACT\" is not found.";
        $comm->writeErrMsg("",__FILE__,__LINE__+1);
        return 1;
    }
    return 0;
}