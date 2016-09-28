#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_hasSetAccessLog.pl,v 1.1 2004/08/23 06:23:56 baiwq Exp $"

#Function: 
    #judge whether the access log has been setted;
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
#exit code:
    #0:succeed 
    #1:failed
#output:
    #true or false
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNumber, $domainName, $computerName) = @ARGV;
my $smbContent = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);
my $logfile = $confCommon->getKeyValue("alog file", "global", $smbContent);
if (!defined($logfile) || $logfile eq ""){
    print "false\n";
}else{
    print "true\n";
}
exit 0;



