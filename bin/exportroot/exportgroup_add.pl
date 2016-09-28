#!/usr/bin/perl -w

#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportgroup_add.pl,v 1.8 2005/11/02 08:01:36 xingh Exp $"

use strict;
use NS::SystemFileCVS;
use NS::ExportgroupConst;
use NS::NsguiCommon;
use NS::ExportgroupFun;

my $common = new NS::SystemFileCVS;
my $const = new NS::ExportgroupConst;
my $cluster = new NS::NsguiCommon;
my $commFun  = new NS::ExportgroupFun;

if(scalar(@ARGV)!=3){
    print STDERR " ",__FILE__,"  parameter error!\n";
    $cluster->writeErrMsg($const->ERR_CODE_PARAMETER_NUM);
    exit(1);
}

my $groupNo = shift;
my $exportRoot = shift;
my $codePage = shift;

my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

my $fileName = $commFun->getFileName($groupNo);
unless (-f $fileName){
    system("touch $fileName");
}

#check whether exportroot exists or not
my @content = `cat ${fileName} 2>/dev/null`;
#my $expPattern = $exportRoot;
#$expPattern =~ s/\//\\\//;
foreach(@content){
    if(/^\s*\Q${exportRoot}\E\s+/){
        $cluster->writeErrMsg($const->ERR_CODE_ADD_EXISTED_SELF);
        exit 1;        
    }
}

my $ret;
my $cmds;
my $targetIP = $cluster->getFriendIP();
#check whether exportroot exists or not in friend node.
if (defined($targetIP)){
    my $friendGroupNo;
    my $friendContent;
    my $friendFileName;
    if($groupNo eq "1"){
        $friendGroupNo = "0";
    }else{
        $friendGroupNo = "1";
    }
    $friendFileName = $commFun->getFileName($friendGroupNo);
    $cmds = "sudo touch ${friendFileName} && sudo cat ${friendFileName} 2>/dev/null";
    ($ret,$friendContent) = $cluster->rshCmdWithSTDOUT (${cmds},$targetIP);
    if (!defined($ret)||($ret!=0)){
        $cluster->writeErrMsg($const->ERR_CODE_UNKNOWN);
        exit 1;        
    }else{
        foreach(@$friendContent){
            if(/^\s*\Q${exportRoot}\E\s+/){
                $cluster->writeErrMsg($const->ERR_CODE_ADD_EXISTED_PARTNER);
                exit 1;        
            }
        }
    }
}

#create dir in local node
if(system("mkdir -p $exportRoot") != 0){
    print STDERR "Failed to mkdir -p $exportRoot. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_ADD_EXPORTGROUP_DIR);
    exit 1; 
}


#create exportgroup directory in friend node.
if (defined($targetIP)){
    $cmds = "sudo mkdir -p $exportRoot";
    $ret = $cluster->rshCmd (${cmds},$targetIP);
    
    if (!defined($ret)||($ret!=0)){
        print STDERR "Failed to mkdir -p $exportRoot in $targetIP. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        $cluster->writeErrMsg($const->ERR_CODE_ADD_EXPORTGROUP_IN_PARTNER);
        exit 1;
    }
}

#write expgrps file
$codePage = $commFun->getStandardCodePage($codePage);

if($common->checkout($fileName)!=0){
    print STDERR "Failed to checkout \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_ADD_EXPORTGROUP_FILE);
    exit 1;    
}

if(!open(OUTPUT,"|${cmd_syncwrite_o} $fileName")) {
    $common->rollback($fileName);
    print STDERR "$fileName can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_ADD_EXPORTGROUP_FILE);
    exit(1);
}

push(@content,"$exportRoot\t$codePage\n");
print OUTPUT @content;
if(!close(OUTPUT)) {
    $common->rollback($fileName);
    print STDERR "$fileName can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_ADD_EXPORTGROUP_FILE);
    exit(1);
}

if ($common->checkin($fileName)!=0){
    $common->rollback($fileName);
    print STDERR "Failed to checkin \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_ADD_EXPORTGROUP_FILE);
    exit 1;    
}

exit(0);
