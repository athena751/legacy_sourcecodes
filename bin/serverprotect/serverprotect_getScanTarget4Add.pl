#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_getScanTarget4Add.pl,v 1.1 2007/03/23 05:23:31 qim Exp $"

#Function: 
    #get the share list information for displaying in setting page.
    #the share list information includes [shareName],[writeCheck]
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #----------------------------------------------------------
    #|STDOUT Content         | Line Number (n=0,1,2,3,4...255)|
    #----------------------------------------------------------
    #|<shareName>  |  2*n + 1
    #|<sharePath>  |  2*n + 2
   
    #------------------------------------------------------
use strict;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::ServerProtectCommon;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $SPCommon  = new NS::ServerProtectCommon;

if(scalar(@ARGV)!=3){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;

my $cifsConfFile = $cifsCommon->getSmbFileName($groupNumber,$domainName,$computerName);
if(!(-f $cifsConfFile)){
    exit 0;
}

open(FILE, $cifsConfFile);
my @cifsContent = <FILE>;
close(FILE);

my $smb_conf_content = \@cifsContent;
my ($shareNameRef, $shareSectionIndexRef) = $cifsCommon->getAllShareInfo($smb_conf_content);
push(@$shareSectionIndexRef,scalar(@$smb_conf_content));
my $shareNumbers = scalar(@$shareNameRef);
my @shareNameArray = ();
my @directoryArray = ();
if($shareNumbers > 0){
    
    for(my $tmpIndex = 0; $tmpIndex < $shareNumbers; $tmpIndex++){
        my $shareType;
        my $directory;
        my $shareName = @$shareNameRef[$tmpIndex];
        if($shareName !~ /^[\$0-9a-zA-Z]+$/){
        	next;
        }
        my $endIndex = @$shareSectionIndexRef[$tmpIndex + 1] - 1;
        my @tmpSection = @$smb_conf_content[@$shareSectionIndexRef[$tmpIndex]..$endIndex];
        
        $shareType = $cifsCommon->getShareType($shareName,\@tmpSection);
        if($shareType ne "realtime_scan"){
        	next;
        }
        
        $directory = $confCommon->getKeyValue("path", $shareName, \@tmpSection);
        if(!defined($directory)){
            next;
        }
        $directory=~ s/\/*$//;
        
        push(@directoryArray,$directory);
        push(@shareNameArray,$shareName);

    }
}
my $SPConfFilePath = $SPCommon->getConfFilePath($groupNumber,$computerName);
my %shareInfoHash=();
if((-f $SPConfFilePath)){
    open(FILE,"$SPConfFilePath");
    my @fileContent = <FILE>;
    close(FILE);
    my $shareInfoHashAddress = $SPCommon->getShareInfo(\@fileContent);
    %shareInfoHash = %$shareInfoHashAddress;
}
for(my $arrayIndex=0;$arrayIndex<scalar(@directoryArray);$arrayIndex++){
    my $shareName = $shareNameArray[$arrayIndex];
    if(defined($shareInfoHash{$shareName})){    	
        next;
    }else{
        print "$shareName\n";
        print "$directoryArray[$arrayIndex]\n";
    }
}
exit 0;