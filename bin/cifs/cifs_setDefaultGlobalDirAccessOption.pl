#!/usr/bin/perl -w
#       Copyright (c) 2004-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_setDefaultGlobalDirAccessOption.pl,v 1.2 2005/08/29 19:29:05 key Exp $"

#Function: 
    #set global option [dir access list file = %r/%D/diraccesslist.%L] 
    # for smb.conf.%L
#Arguments: 
    #$groupNumber       : the group number 0 or 1
    #$domainName        : the domain Name
    #$computerName      : the computer Name
#exit code:
    #0:succeed 
    #1:failed

use strict;
use NS::SystemFileCVS;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::NsguiCommon;
use NS::ConfCommon;
 
my $comm  = new NS::NsguiCommon;
my $cvs = new NS::SystemFileCVS;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;

my $smb_conf_File = $cifsCommon->getSmbFileName($groupNumber, $domainName, $computerName);
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if($cvs->checkout($smb_conf_File)!=0){
    print STDERR "Failed to checkout $smb_conf_File.\n";
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;
}

open(FILE,"$smb_conf_File");
my @fileContent = <FILE>;
close(FILE);
$confCommon->setKeyValue("dir access list file","%r/%D/diraccesslist.%L", "global", \@fileContent);

open(WRITE,"|${cmd_syncwrite_o} ${smb_conf_File}");
print WRITE @fileContent;
if(!close(WRITE)) {
     $cvs->rollback($smb_conf_File);
     print STDERR "The $smb_conf_File can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     exit 1;
}

if($cvs->checkin($smb_conf_File)!=0){
    $cvs->rollback($smb_conf_File);
    print STDERR "Failed to checkin $smb_conf_File.\n";
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE,__FILE__,__LINE__+1);
    exit 1;
}

exit 0;