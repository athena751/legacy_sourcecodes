#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_delConfigFile.pl,v 1.2 2008/03/25 05:20:31 hanh Exp"

# Function:
#       Get the Global Info .
# Parameters:
#        nodeNo
#        exportGroup
#        domainName
#        computerName
# output:
#        none
# Return value:
#       0: successfully exit;
#       1: parameters error or command running error occured;
use strict;
use NS::ScheduleScanCommon;
use NS::ScheduleScanConst;
use NS::CIFSCommon;
use NS::SystemFileCVS;
use NS::NsguiCommon;
my $SSComm=new NS::ScheduleScanCommon;
my $SSConst=new NS::ScheduleScanConst;
my $cifsComm=new NS::CIFSCommon;
my $cvs=new NS::SystemFileCVS;
my $nsguiComm=new NS::NsguiCommon;
if(scalar(@ARGV)!=4){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNo,$exportGroup,$domainName,$computerName)=@ARGV;
my $synwrite=$cvs->COMMAND_NSGUI_SYNCWRITE_O;
my @content;
my @tmpContent;
my $cifsRestartCmd=$SSConst->COMMAND_CIFS_RESTART;
my $VSFileName;
my $smbFile;
my $smbContent;
$VSFileName=$cifsComm->getVsFileName($nodeNo);
if (-f $VSFileName){
    if(!open(FILE,"<$VSFileName")){
        print STDERR "FILE OPEN ERROR.\n";
        $nsguiComm->writeErrMsg($SSConst->ERRCODE_DELETE_INFO,__FILE__,__LINE__+1);
        exit 1;                        #failed -- can not open the virtual_servers for reading
    }
    @content=<FILE>;
    close(FILE);
    my $line;
    foreach $line (@content){
        if (!($line=~/^\s*\Q$exportGroup\E\s+$domainName\s+$computerName\s*$/)){
            push(@tmpContent,$line);
        }
    }
    if($cvs->checkout($VSFileName)!=0){
        print STDERR "FILE CHECKOUT ERROR.\n";
        $nsguiComm->writeErrMsg($SSConst->ERRCODE_DELETE_INFO,__FILE__,__LINE__+1);
        exit 1;                        #failed -- checkout failed
    }
    if(!open(FILE,"|$synwrite $VSFileName")){
        $cvs->rollback($VSFileName);
        print STDERR "FILE OPEN FOR WRITE ERROR.\n";
        $nsguiComm->writeErrMsg($SSConst->ERRCODE_DELETE_INFO,__FILE__,__LINE__+1);
        exit 1;                        #failed -- can not open the virtual_servers for writing
    }
    print FILE @tmpContent;
    if (!close(FILE)){
        $cvs->rollback($VSFileName);
        print STDERR "FILE CLOSE AFTER WRITE ERROR.\n";
        $nsguiComm->writeErrMsg($SSConst->ERRCODE_DELETE_INFO,__FILE__,__LINE__+1);
        exit 1;                        #failed -- write failed
    }
    if ($cvs->checkin($VSFileName)!=0){
        $cvs->rollback($VSFileName);
        print STDERR "FILE CHECKIN ERROR.\n";
        $nsguiComm->writeErrMsg($SSConst->ERRCODE_DELETE_INFO,__FILE__,__LINE__+1);
        exit 1;                        #failed -- checkin failed
    }
    $smbFile=$cifsComm->getSmbFileName($nodeNo,$domainName,$computerName);
    if(-f $smbFile){
    	system("/bin/rm -f $smbFile 2>/dev/null");
        system("$cifsRestartCmd 2>/dev/null");
    }
}else{
    print STDERR "FILE NOT EXSIT ERROR.\n";
    $nsguiComm->writeErrMsg($SSConst->ERRCODE_DELETE_INFO,__FILE__,__LINE__+1);
    exit 1;                            #virtual_servers does not exsit
}
exit 0;                                #successfully deleted

