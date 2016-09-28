#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_addUser.pl,v 1.4 2008/02/26 08:02:23 lil Exp $"

#Function: 
#   add the user information into /etc/snmp/snmpd.conf

#Arguments: 
#   userName----------user name
#   authProtocol------authentication protocol
#   password----------password
#   privacyProtocol---privacy protocol
#   passphrase--------passphrase

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

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($userName,$authProtocol,$privacyProtocol) = @ARGV;
my ($password,$passphrase) = <STDIN>;
defined($password) and chomp($password);
defined($passphrase) and chomp($passphrase);

my ($ret,$errcode) = $snmpCommon->snmpProcess(\&addUser, 'isUser');
if($ret == 0){
    exit 0;
}elsif($ret == 1 && !defined($errcode)){
    print STDERR $snmpCommon->error();
    $comm->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}elsif($ret == 5){
	$comm->writeErrMsg($const->ERRCODE_USER_ADD_FAILED, __FILE__,__LINE__+1);
	exit 1;
}else{
    $comm->writeErrMsg($errcode,__FILE__,__LINE__+1);
    exit 1;
}

#Function:
#   add user information to the @$confContent
#parameters:
#   $confContent: the reference to the array of snmp's content
#return:
#   0------succeed
#   1,$const->ERRCODE_MAX_USER_EXIST------------------The max user has exist.
#   1,$const->ERRCODE_USER_EXIST----------------------The user has exist
#   1,$const->ERRCODE_EXEC_IP_TABLE_FAILED_ADD_USER---The excute of iptable is error
#   1,$const->ERRCODE_SAVE_IP_TABLE_FAILED_ADD_USER---The save process of iptable is error

sub addUser(){
    #the parameter useless never be used
    my ($useless,$confContent) = @_;
    my $userInfo = $snmpCommon->getUserNames($confContent);
    my $needOpenPort = 0;
    if(!defined($userInfo)){
        print STDERR $snmpCommon->error();
        $comm->writeErrMsg("",__FILE__,__LINE__+1);
        return 1;
    }elsif(scalar(@$userInfo) >= $const->MAX_USERS_IN_CONF){
        return (1,$const->ERRCODE_MAX_USER_EXIST);
    }elsif(scalar(@$userInfo) == 0){
        $needOpenPort = 1;
    }else{
        foreach(@$userInfo){
            if($_ eq $userName){
                #the user to be added has existed.
                return (1,$const->ERRCODE_USER_EXIST);
            }
        }
    }
    my $constCreateUser = $const->CREATEUSER;
    my $constRO_User = $const->RO_USER;
    if($passphrase eq ""){
        $passphrase = $password;
    }
    my $userLine = join(" ", $constCreateUser, $userName, $authProtocol, $password, $privacyProtocol, "'$passphrase'");
    push @$confContent,"${constRO_User} ${userName}\n";
    push @$confContent,"${userLine}\n";

    if($needOpenPort){
        my $returnFilter = $snmpCommon->processUserFilter($const->OPEN);
        if($returnFilter != 0){
            return 1;
        }
    }
    return 0;
}