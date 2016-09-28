#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getCifsComputerListInfo.pl,v 1.4 2008/05/14 01:05:26 zhangjun Exp $"

#Function: 
    #get the computer name,cifs access log,the encoding of the log file
#Arguments: 
    #$groupNumber       : the group number 0 or 1
#exit code:
    #0:succeed 
    #1:parameter's number error
#output:
    #computerName=<computerName>
    #accessLogFile=<accessLogFile>
    #encoding=<encoding of the log file>

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;
use NS::SyslogCommon;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::ExportgroupFun;
use NS::ExportgroupConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;
my $syslogCommon = new NS::SyslogCommon;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $export = new NS::ExportgroupFun;
my $exportgroupConst = new NS::ExportgroupConst();
#check the parameter's number =1
if(scalar(@ARGV)!=1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
	exit 1;
}
my ($groupNumber) = @ARGV;

#get the file path use the groupNumber,
#if haven't the file:#/etc/group1/nas_cifs/DEFAULT/virtual_servers,exit 0,
#if have,read the content to the array @vsContent
my $virServers = $cifsCommon->getVsFileName($groupNumber);
if (!(-f $virServers)){
    exit 0;
}
open VTSV,"<${virServers}";
my @vsContent = <VTSV>;
close VTSV;
my $validVSContent = $comm->getVSContent(\@vsContent);

#get the exportroot and codepage from file /etc/group[0|1]/exgrps
my $etcPath = $const->CONST_ETC_GROUP_PATH."${groupNumber}/";
my $pExportGroup = $export->getExportGroupInfo($etcPath);

my ($exportGroup,$domainName,$computerName,$smbConfContent,$alogFile);
foreach(@$validVSContent){
    if(/^\s*(\/export\/\S+)\s+(\S+)\s+(\S+)/){
        $exportGroup = $1;
        $domainName = $2;
        $computerName = $3;
        $smbConfContent = $cifsCommon->getSmbContent($groupNumber,$domainName,$computerName);
        $alogFile = $confCommon->getKeyValue("alog file","global",$smbConfContent);
        if( defined($alogFile) ){
            my $encoding = $syslogCommon->getEncoding($alogFile,$pExportGroup);                  
            if($encoding eq ""){
                $encoding = $syslogCommon->getEncoding($exportGroup,$pExportGroup);                
            }
            print "computerName=${computerName}\n";
            print "accessLogFile=${alogFile}\n";
            print "encoding=${encoding}\n";
        }
    }
}

exit 0;