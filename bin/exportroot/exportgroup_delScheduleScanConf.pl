#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: exportgroup_delScheduleScanConf.pl,v 1.1 2008/05/09 00:35:41 liul Exp $"

# Function:
#     delete schedule scan configuration info
# Parameters:
#     $groupNo-------group number
#     $expgrpPath----exportgroup path
# Output:
#     STDOUT----null
#     STDERR----error message
# Returns:
#     0----success
#     1----failed

use strict;
use NS::NsguiCommon;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
use NS::ExportgroupConst;

my $nsguiComm = new NS::NsguiCommon;
my $cifsComm = new NS::CIFSCommon;
my $ssComm = new NS::ScheduleScanCommon;
my $const = new NS::ExportgroupConst;

if(scalar(@ARGV)!=2){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $nsguiComm->writeErrMsg($const->ERR_CODE_PARAMETER_NUM);
    exit 1;
}

my $groupNo = shift;
my $expgrpPath = shift;
my $domainName = "";
my $ssComputerName = "";

my $vsFile = $cifsComm->getVsFileName($groupNo);
if(-f $vsFile) {
    my @vsContent = `cat $vsFile 2>/dev/null`;
    my $vsContent4SS = $ssComm->getVSContent4ScheduleScan(\@vsContent);
    foreach(@$vsContent4SS) {
        if(/^\s*\Q${expgrpPath}\E\s+(\S+)\s+(\S+)\s*$/) {
            $domainName = $1;
            $ssComputerName = $2;
            last;
        }
    }
}
if( ($domainName eq "") || ($ssComputerName eq "") ){
    exit 0;
}

my $cmd = "/opt/nec/nsadmin/bin/schedulescan_delConfigFile.pl";
`$cmd ${groupNo} \Q${expgrpPath}\E \Q${domainName}\E \Q${ssComputerName}\E >& /dev/null`;
if ($?!=0){
    print STDERR "Failed to delete schedule scan settings. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $nsguiComm->writeErrMsg($const->ERR_CODE_DELETE_SCHEDULESCAN);
    exit 1;
}
exit 0;

