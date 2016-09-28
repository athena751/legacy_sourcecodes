#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportgroup_delete.pl,v 1.8 2005/11/02 08:01:53 xingh Exp $"

use strict;
use NS::SystemFileCVS;
use NS::ExportgroupConst;
use NS::NsguiCommon;
use NS::ExportgroupFun;
use NS::NFSCommon;

my $common = new NS::SystemFileCVS;
my $const = new NS::ExportgroupConst;
my $commFun = new NS::ExportgroupFun;
my $cluster = new NS::NsguiCommon;
my $nfsCommon = new NS::NFSCommon;

if(scalar(@ARGV)!=2){
    print STDERR " ",__FILE__,"  parameter error!\n";
    $cluster->writeErrMsg($const->ERR_CODE_PARAMETER_NUM);
    exit(1);
}
my $groupNo = shift;
my $exportRoot = shift;

my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

my $fileName = $commFun->getFileName($groupNo);

#check whether has mountpoint in the exportroot
my $mtabfile = "/etc/group${groupNo}/cfstab";
my @mtabContent = `cat ${mtabfile} 2>/dev/null`;
foreach (@mtabContent){
    if(/^\s*#.*/){
        next;
    }elsif($_=~m"\s\Q${exportRoot}\E/"){
        $cluster->writeErrMsg($const->ERR_CODE_DELETE_NOT_UMOUNT);
        exit 1;
    }
}

my @content;
if(!open(INPUT,"$fileName")){
    print STDERR "Failed to read \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_FILE);
    exit 1;
}
@content = <INPUT>;
close(INPUT);

if($common->checkout($fileName)!=0){
    print STDERR "Failed to checkout \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_FILE);
    exit 1;    
}
if(!open(OUTPUT,"|${cmd_syncwrite_o} $fileName")) {
    $common->rollback($fileName);
    print STDERR "$fileName can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_FILE);
    exit(1);
}
foreach(@content){
    if(/^\s*\Q${exportRoot}\E\s+/){
        #match the export group, and delete this line
    }else{
        print OUTPUT $_;
    }
}
if(!close(OUTPUT)) {
    $common->rollback($fileName);
    print STDERR "$fileName can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_FILE);
    exit(1);
}



#rm exportroot directory
if(system("rm -rf $exportRoot") != 0){
    $common->rollback($fileName);

    print STDERR "Failed to rm -rf $exportRoot. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_DIR);
    exit 1; 
}

if ($common->checkin($fileName)!=0){
    #rollback
    $common->rollback($fileName);
    `mkdir -p $exportRoot`;

    print STDERR "Failed to checkin \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_FILE);
    exit 1;
}

my $ret;
#rm exportgroup directory in friend node.
my $targetIP = $cluster->getFriendIP();
if (defined($targetIP)){
    my $cmds = "sudo rm -rf $exportRoot";
    $ret = $cluster->rshCmd (${cmds},$targetIP);
    if (!defined($ret)&&($ret!=0)){
        print STDERR "Failed to rm -rf $exportRoot in $targetIP. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        $cluster->writeErrMsg($const->ERR_CODE_DELETE_EXPORTGROUP_IN_PARTNER);
        exit 1;
    }
}

#delete nfs content of the exportgroup
$ret = $nfsCommon->deleteEntryOfExpGrp($exportRoot,"/etc/group${groupNo}/exports");
if (!defined($ret)){
    print STDERR "Failed to delete nfs info of ${exportRoot}. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $cluster->writeErrMsg($const->ERR_CODE_DELETE_NFS);
    exit 1;
}

exit(0);
