#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_getNDMPInfo.pl,v 1.3 2006/10/23 01:56:57 wanghui Exp $"

#Function:
    #get the ndmp configuration file information;
    #If the entry does not exist, empty value will be output.
    #If the file is empty or doesn't exist, null will be output.
#Arguments:
    #node
#exit code:
    #0:succeeded
    #1:failed
#output:
    #the configuration file information.

use strict;
use NS::NDMPCommonV4;
use NS::NDMPConst;

my $ndmpComm = new NS::NDMPCommonV4;
my $ndmpConst = new NS::NDMPConst;

if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR\n";
    exit 1;
}

my $groupNo = shift;
my $ndmpConfFile = $ndmpComm->getNDMPConfFilePath($groupNo);

if (!(-e $ndmpConfFile) || !(-s $ndmpConfFile)) {
    exit 0;
}

open(FILE, $ndmpConfFile);
my @content = <FILE>;
close(FILE);

my %confInfo = ( #"enableNewSession", "",
                "defaultVersion", "",
                "ctrlConnectionIP", "",
                "dataConnectionIP", "",
                #"ndmpUserName", "",
                "authorizedDMAIP", "",
                #"tcpWindowSize", "",
                #"maxSessionNum", "",
                #"sessionFileUpdateInterval", "",
                #"eventLogLevel", "",
                "hasSetPassword", "");

#################################deleted####################################                
#my $value = $ndmpComm->getKeyValue("ENABLE_NEW_SESSIONS", \@content);
#$value = defined($value) ? ($value eq "N" ? "no" : "yes") : "yes";
#$confInfo{"enableNewSession"} = $value; 
#################################deleted#################################### 

my $value = $ndmpComm->getKeyValue("DEFAULT_PROTOCOL_VERSION", \@content);
if(defined($value)) {
    $confInfo{"defaultVersion"} = $value;
} 

$value = $ndmpComm->getKeyValue("NDMP_IP_ADDRS", \@content);
if(defined($value)) {
    #delete string as " ,, , ," at the head and in the tail of the string
    $value =~ s/^(\s*,*\s*)*|(\s*,*\s*)*$//g;  
    #convert string as " ,, , ," to ","
    $value =~ s/(\s*,+\s*)+/,/g;
    $confInfo{"ctrlConnectionIP"} = $value;
}

$value = $ndmpComm->getKeyValue("DATA_TX_TIER_1_IP_ADDRS", \@content);
if(defined($value)) {
    #delete string as " ,, , ," at the head and in the tail of the string
    $value =~ s/^(\s*\,*\s*)*|(\s*\,*\s*)*$//g;
    #convert string as " ,, , ," to ","
    $value =~ s/(\s*\,+\s*)+/,/g;
    $confInfo{"dataConnectionIP"} = $value;
}

#################################deleted#################################### 
#$value = $ndmpComm->getKeyValue("NDMP_USER_NAME", \@content);
#if(defined($value)) {
#    $confInfo{"ndmpUserName"} = $value;
#} 
#################################deleted#################################### 

#traslate the pattern ,,  ,xxx.xxx.xxx.xxx  ,, ,  ,xxx.xxx.xxx.xxx,xxx.xxx.xxx.xxx ,, , ,
#into xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx
$value = $ndmpComm->getKeyValue("AUTHORIZED_NDMP_CLIENTS", \@content);
if(defined($value)) {
    #delete string as " ,, , ," at the head and in the tail of the string
    $value =~ s/^(\s*,*\s*)*|(\s*,*\s*)*$//g;
    #convert string as " ,, , ," to " "
    $value =~ s/(\s*,+\s*)+/ /g;
    $confInfo{"authorizedDMAIP"} = $value;
} 

#################################deleted####################################
##traslate the unit byte into KB, and keep the value integer.
##if the value isn't number,then display it directly.
#$value = $ndmpComm->getKeyValue("NDMP_TCP_WND_SZ", \@content);
#if (defined($value)) {
#    if(($value !~ /\D/) && ($value ne "")) {
#        $value = $value/1024;
#       #match the integer part of the number
#        $value =~ /(^[0-9]*)/;
#        $confInfo{"tcpWindowSize"} = $1;
#    } else {
#        $confInfo{"tcpWindowSize"} = $value;
#    }
#} 
#
#$value = $ndmpComm->getKeyValue("MAX_NDMP_SESSIONS", \@content);
#if(defined($value)) {
#    $confInfo{"maxSessionNum"} = $value;
#}
#
#$value = $ndmpComm->getKeyValue("SESSION_UPDATE_INTERVAL", \@content);
#if (defined($value)) {    
#   $confInfo{"sessionFileUpdateInterval"} = $value;
#} 
#
#$value = $ndmpComm->getKeyValue("LOG_ERROR_THRESHOLD", \@content);
#if(defined($value)) {
#    $confInfo{"eventLogLevel"} = $value;
#}
#################################deleted####################################

#If has set password, then set 'yes'to 'hasSetPassword'.
#Or else set 'no'.
$value = $ndmpComm->getKeyValue("ENCRYPTED_PASSWORD", \@content);
$value = defined($value) && ($value ne "") ? "yes" : "no";
$confInfo{"hasSetPassword"} = $value;

foreach (keys(%confInfo)) {
    print "$_=$confInfo{$_}\n";
}

exit 0;