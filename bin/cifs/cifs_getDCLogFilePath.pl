#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getDCLogFilePath.pl,v 1.3 2006/07/07 06:27:42 baiwq Exp $"

use strict;
use NS::CIFSConst;
use NS::NsguiCommon;
use NS::SystemFileCVS;
my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cvs = new NS::SystemFileCVS;

if(scalar(@ARGV) != 1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit(1);
}

my $domainName = shift;
my $command_nsgui_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $dcLogFileNew = $const->DC_LOGFILE_NEW;
my $dcLogFileOld = $const->DC_LOGFILE_OLD;
my $dcLogTmpFile = "/tmp/.dclog/.nas_cifs.dc.log$$";
my $cat = "/bin/cat";

`rm -f $dcLogTmpFile`;
`mkdir -p /tmp/.dclog`;
`touch $dcLogTmpFile`;
`chmod 664 $dcLogTmpFile`;

my $inodeInfo_0 = `ls -i $dcLogFileOld $dcLogFileNew 2>/dev/null`;
system("$cat $dcLogFileOld $dcLogFileNew 2>/dev/null".' | grep "^[[:space:]]*'."\Q$domainName\E".'[[:space:]]\+" | sed -e "s/^[[:space:]]\+//g" |'."$command_nsgui_syncwrite_o $dcLogTmpFile");
my $inodeInfo_1 = `ls -i $dcLogFileOld $dcLogFileNew 2>/dev/null`;
if($inodeInfo_0 ne $inodeInfo_1){
    #need to retry
    system("$cat $dcLogFileOld $dcLogFileNew 2>/dev/null".' | grep "^[[:space:]]*'."\Q$domainName\E".'[[:space:]]\+" | sed -e "s/^[[:space:]]\+//g" |'."$command_nsgui_syncwrite_o $dcLogTmpFile");
    $inodeInfo_0 = `ls -i $dcLogFileOld $dcLogFileNew 2>/dev/null`;
    if($inodeInfo_0 ne $inodeInfo_1){
        print "rotate\n";
        exit 0;
    }
}

print "$dcLogTmpFile\n";
exit 0;
