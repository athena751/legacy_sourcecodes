#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_deleteUser.pl,v 1.4 2008/02/26 08:03:07 lil Exp $"

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

my $comm  = new NS::NsguiCommon;
my $const=new NS::ConstForSNMP;
my $snmpCommon = new NS::SNMPCommon;

if(scalar(@ARGV)!=1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my $userName = shift;

my ($ret,$errcode) = $snmpCommon->snmpProcess(\&deleteUser,'isUser');
if($ret == 0){
    exit 0;
}elsif($ret == 1 && !defined($errcode)){
    print STDERR $snmpCommon->error();
    $comm->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}elsif($ret == 5){
	$comm->writeErrMsg($const->ERRCODE_USER_DELETE_FAILED, __FILE__,__LINE__+1);
	exit 1;
}else{
    $comm->writeErrMsg($errcode,__FILE__,__LINE__+1);
    exit 1;
}
#Function:
#   delete userinformation to the @$confContent
#parameters:
#   $confContent: the reference to the array of snmp's content
#return:
#   0------succeed
#   1,$const->ERRCODE_EXEC_IP_TABLE_FAILED_ADD_USER---The excute of iptable is error
#   1,$const->ERRCODE_SAVE_IP_TABLE_FAILED_ADD_USER---The save process of iptable is error

sub deleteUser(){
    #the parameter useless never be used
    my ($useless,$confContent) = @_;
    my @changedCotent;
    my $constCreateUser = $const->CREATEUSER;
    my $constRO_User = $const->RO_USER;
    foreach(@$confContent){
        if(/^\s*$constCreateUser\s+(\S+)\s+/i){
            #the line such as:
            #createUser nsadmin SHA nsadmin00 DES "I have all the time in the world!"
            if($1 eq $userName){
                #find the line which will be deleted
                #need not to add this line into @changedCotent
            }else{
                push(@changedCotent, $_);
            }
        }elsif(/^\s*$constRO_User\s+(\S+)/i){
            #the line such as:
            #roser nsadmin 
            if($1 eq $userName){
                #find the line which will be deleted
                #need not to add this line into @changedCotent
            }else{
                push(@changedCotent, $_);
            }
        }else{
            push(@changedCotent, $_);
        }
    }
    @$confContent = @changedCotent;

    #Check the number of the user,If there aren't user,close the port!
    my $userInfo = $snmpCommon->getUserNames(\@changedCotent);
    if(!defined($userInfo)){
        print STDERR $snmpCommon->error();
        $comm->writeErrMsg("",__FILE__,__LINE__+1);
        return 1;
    }
    if(scalar(@$userInfo) == 0){
        my $returnFilter = $snmpCommon->processUserFilter($const->CLOSE);
        if($returnFilter != 0){
            return 1;
        }
    }
    return 0;
}