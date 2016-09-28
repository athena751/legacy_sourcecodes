#!/usr/bin/perl -w
#       Copyright (c)2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_getSettingInfo.pl,v 1.1 2008/05/08 09:15:30 chenbc Exp $"

# Function:
#       Get the Global Info for Schedule Scan'Basic Setting.
# Parameters:
#       nodeNo
#       domainName
#       computerName
# output:
#       selectedInterfaces
#       selectedUsers
#       scanServer
# Return value:
#       0: successfully exit;
#       1: parameters error or command running error occured;
use strict;
use NS::NsguiCommon;
use NS::ScheduleScanCommon;
use NS::ScheduleScanConst;
use NS::CIFSCommon;
my $SSConst=new NS::ScheduleScanConst;
my $nsguiComm=new NS::NsguiCommon;
my $cifsComm=new NS::CIFSCommon;
my $SSComm=new NS::ScheduleScanCommon;

if(scalar(@ARGV)!=3){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNo,$domainName,$computerName)=@ARGV;

if ($computerName eq ""){
    exit 0;
}
my $smbFile=$cifsComm->getSmbFileName($nodeNo,$domainName,$computerName);
if (-f $smbFile){
    my $fileContent=$nsguiComm->getFileContent($smbFile);
    if(!defined($fileContent)){
        print STDERR "FILE OPEN ERROR.\n";
        $nsguiComm->writeErrMsg($SSConst->ERRCODE_GET_INFO,__FILE__,__LINE__+1);
        exit 1;
    }
    my $selectedInterfaces=$SSComm->getUsedInterface($fileContent);
    if (!defined($selectedInterfaces)){
        $selectedInterfaces="";
    }
    my $scanServer=$SSComm->getScanServer($fileContent);
    if (!defined($scanServer)){
        $scanServer="";
    }
    my $selectedUsers=$SSComm->getUsedLudbUser($domainName,$fileContent);
    if (!defined($selectedUsers)){
        $selectedUsers="";
    }
    if($selectedInterfaces eq ""&&
       $selectedUsers eq ""&&
       $scanServer eq ""){
           exit 0;
    }
    print "selectedInterfaces=$selectedInterfaces\n";
    print "selectedUsers=$selectedUsers\n";    
    print "scanServer=$scanServer\n";
    
}
exit 0;

