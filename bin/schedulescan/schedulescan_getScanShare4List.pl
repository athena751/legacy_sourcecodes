#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_getScanShare4List.pl,v 1.2 2008/03/25 05:20:31 hanh Exp"

# Function:
#       Get the scan shares Info for List from the smb.conf.computer file.
# Parameters:
#        nodeNo
#        domainName
#        computerName
# output:
#        shareName
#        sharePath
# Return value:
#        0: successfully exit;
#        1: parameters error or command running error occured;
use strict;
use NS::ScheduleScanCommon;
use NS::ScheduleScanConst;
use NS::NsguiCommon;
use NS::CIFSCommon;
my $SSConst=new NS::ScheduleScanConst;
my $SSComm=new NS::ScheduleScanCommon;
my $nsguiComm=new NS::NsguiCommon;
my $cifsCommon = new NS::CIFSCommon;
if(scalar(@ARGV)!=3){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNo,$domainName,$computerName)=@ARGV;

my $smbFile=$cifsCommon->getSmbFileName($nodeNo,$domainName,$computerName);
if (!(-f $smbFile)){
    exit 0;
}
my $smbContent=$nsguiComm->getFileContent($smbFile);
if (!defined($smbContent)){
    print STDERR "FILE OPEN ERROR.\n";
    $nsguiComm->writeErrMsg($SSConst->ERRCODE_GET_INFO,__FILE__,__LINE__+1);
    exit 1;
}
my ($shareName,$sharePath)=$SSComm->getUsedScanShare($smbContent);
if (!defined($shareName)){
    exit 0;
}
my @shareNames=split(",",$shareName);
my @sharePaths=split(",",$sharePath);

for(my $i=0;$i<scalar(@shareNames);$i++){
    print "shareName=$shareNames[$i]\n";
    print "sharePath=$sharePaths[$i]\n";
}
exit 0;
