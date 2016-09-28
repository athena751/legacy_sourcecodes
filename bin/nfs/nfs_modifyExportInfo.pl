#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nfs_modifyExportInfo.pl,v 1.5 2008/10/22 09:41:01 yangxj Exp $"

use strict;
use NS::NFSCommon;
use NS::NFSConst;
use NS::SystemFileCVS;
use NS::NsguiCommon;
#check number of the argument,if it isn't 2(tmpFile,groupNo: from GUI) or 3(tmpFile,groupNo,nvguide: from NVSETUP),exit
if(scalar(@ARGV)!=2 && scalar(@ARGV)!=3 ){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $cvs         = new NS::SystemFileCVS();
my $nfsCommon   = new NS::NFSCommon();
my $common      = new NS::NsguiCommon;
my $const       = new NS::NFSConst();

my ($tmpfilename,$groupNo,$flag) = @ARGV;
if(! -f $tmpfilename){
    print STDERR "Cannot find the file \"$tmpfilename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @tmpfilecontent=`cat $tmpfilename`;
system("rm -f ${tmpfilename}");
my $originalPath=shift(@tmpfilecontent);
chomp($originalPath);
my $newPath=shift(@tmpfilecontent);
chomp($newPath);

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my @newContent;
my $fileName = "/etc/group${groupNo}/exports";
my $fileContent = $nfsCommon->openFile($fileName);
if(!defined($fileContent)){
    print STDERR $nfsCommon->error();
    exit 1;
}
if($originalPath=~/^\/export\//){
    foreach(@$fileContent){
        if(!/^\s*\Q${originalPath}\E\s+/){
            push(@newContent,$_);
        }
    }
}else{
    @newContent = @$fileContent;
}
foreach my $currClient(@tmpfilecontent){
    $currClient =~ s/\n$//g;
    if($currClient=~/^\s*$/){
        next;
    }
    push(@newContent,"$newPath $currClient\n");
}
if($cvs->checkout($fileName)!=0){
    print STDERR "Failed to checkout \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
if(!open(OUTPUT,"|${cmd_syncwrite_o} $fileName")){
    $cvs->rollback($fileName);
    print STDERR "The $fileName can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print OUTPUT @newContent;
if(!close(OUTPUT)) {
    $cvs->rollback($fileName);
    print STDERR "The $fileName can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if($flag eq ""){
    # is from GUI
    my $cmd = $const->SCRIPT_EXPORTNAS_G;
    if(system("${cmd} ${groupNo} ${fileName} 2>/dev/null") != 0){
        $cvs->rollback($fileName);
        $common->writeErrMsg($const->ERRCODE_FAILED_TO_RUN_EXPORTNAS,__FILE__,__LINE__+1);
        exit 1;
    }
}
if($cvs->checkin($fileName)!=0){
    $cvs->rollback($fileName);
    print STDERR "Failed to checkin \"$fileName\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
exit 0;
