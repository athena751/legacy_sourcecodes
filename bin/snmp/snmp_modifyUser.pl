#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_modifyUser.pl,v 1.4 2008/02/26 08:04:13 lil Exp $"

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
#   30--------the user to be changed does not exist in the file 

use strict;
use NS::ConstForSNMP;
use NS::SNMPCommon;
use NS::NsguiCommon;
my $const=new NS::ConstForSNMP;
my $comm  = new NS::NsguiCommon;
if (scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my ($userName,$authProtocol,$privacyProtocol) = @ARGV;
my ($password,$passphrase) = <STDIN>;
defined($password) and chomp($password);
defined($passphrase) and chomp($passphrase);
my $snmpcommon=new NS::SNMPCommon;
my ($ret,$errcode) = $snmpcommon->snmpProcess(\&modifyUser,'isUser');
if($ret == 0){
    exit 0;
}elsif($ret == 1 && !defined($errcode)){
    print STDERR $snmpcommon->error();
    $comm->writeErrMsg("",__FILE__,__LINE__+1);
    exit 1;
}elsif($ret == 5){
	$comm->writeErrMsg($const->ERRCODE_USER_MODIFY_FAILED, __FILE__,__LINE__+1);
	exit 1;
}else{
    $comm->writeErrMsg($errcode,__FILE__,__LINE__+1);
    exit 1;
}



sub modifyUser(){
    #the parameter useless never be used
    my ($useless,$confContent) = @_;
    my $userDisapear = 1;
    my $RO_userDisapear = 1;
    my $constCreateUser = $const->CREATEUSER;
    my $constRO_User = $const->RO_USER;
    my $lines = scalar(@$confContent);
    for(my $i = 0; $i < $lines; $i++){
        if($$confContent[$i] =~ /^\s*#/ || $$confContent[$i] =~ /^\s*$/){
            next;
        }
        if($$confContent[$i] =~ /^\s*$constCreateUser\s+(\S+)\s+\S+\s+(\S+)\s+\S+\s+(.+)/i){
            #the line such as:
            #createUser nsadmin SHA nsadmin00 DES "I have all the time in the world!"
            if($1 eq $userName){
                #find the line which will be changed
                $userDisapear = 0;
                my $passphraseString;
                my $passwordString;
                if($password eq ""){
                    #the password is not changed
                    $passwordString = $2;
                }else{
                    $passwordString = $password;
                }
                
                if($passphrase eq ""){
                    #the passphrase is not changed
                    $passphraseString = $3;
                    #if there is "\n" at the end of $passphrase, delete it.
                    chomp($passphraseString);
                }else{
                    $passphraseString = "'${passphrase}'";
                }
                my $userLine = join(" ", $constCreateUser, $userName, $authProtocol,
                                    $passwordString, $privacyProtocol, $passphraseString);
                
                #change this line
                $$confContent[$i] = "${userLine}\n";
            }
        }elsif($$confContent[$i] =~ /^\s*$constRO_User\s+(\S+)/i){
            #the line such as:
            #roser nsadmin 
            #need not change this line
            if($1 eq $userName){
                $RO_userDisapear = 0;
            }
        }
    }

    if($userDisapear == 1){
        # the user to be changed is not in the file
        my $errcode = $const->ERRCODE_USER_NOT_EXIST;
        return (1, $errcode);
    }
    if($RO_userDisapear == 1){
        print STDERR "Failed to find [${constRO_User} ${userName}] from the file.\n";
        return 1;
    }
    return 0;
}