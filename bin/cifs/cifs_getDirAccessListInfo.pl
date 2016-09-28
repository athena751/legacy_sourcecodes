#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getDirAccessListInfo.pl,v 1.3 2007/06/28 01:44:06 fengmh Exp $"

#Function: 
    #get the dir access list informations: [directory],[allowHost],[denyHost]
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
    #$shareName        : the Share Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #------------------------------------------------------
    #|STDOUT Content         | Line Number (n=0,1,2,3,4...)|
    #------------------------------------------------------
    #|directory=<directory>  |  3*n + 1
    #|allowHost=<allowHost>  |  3*n + 2
    #|denyHost=<denyHost>    |  3*n + 3
    #------------------------------------------------------
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::CodeConvert;

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $codeConvert = new NS::CodeConvert;

if(scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $shareName = shift;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}
$shareName = $codeConvert->changeUTF8Encoding($shareName, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);
if(!defined($shareName)) {
    print STDERR $const->ERRMSG_CHANGEENCODING."\n";
    $comm->writeErrMsg($const->ERRCODE_CHANGEENCODING,__FILE__,__LINE__+1);
    exit 1;
}

my $dirAccessFile = $cifsCommon->getDirAccessConfFileName($groupNumber, $domainName, $computerName);

if($dirAccessFile eq ""){
   $dirAccessFile = $cifsCommon->getDefaultDirAccessConfFileName($groupNumber, $domainName, $computerName);
}
if(-f $dirAccessFile){
    
    open(F, $dirAccessFile);
    my @fileContent = <F>;
    close(F);
    my $shareSectionStartIndex = $cifsCommon->getShareSectionStartIndex($shareName, \@fileContent);
    if(!defined($shareSectionStartIndex)){
        exit 0;
    }
    my $shareSectionEndIndex = $cifsCommon->getShareSectionEndIndex(\@fileContent, $shareSectionStartIndex);
    
    my $tmpIndex = $shareSectionStartIndex + 1;
    my $tmpDir;
    my $tmpAllow;
    my $tmpDeny;
    my %listInfo;# the key is the dir;
                 # the value is a Ref of Array which contain the corresponding allowHost and denyHost
    while(1){
        $tmpIndex = $cifsCommon->getNextValidLineIndex(\@fileContent, $tmpIndex, $shareSectionEndIndex);
        if(defined($tmpIndex)){
            if($fileContent[$tmpIndex]=~/^dir:(.+)/){
                #the line such as [dir:xxxxxxxxxxxxx]
                $tmpDir = $1;
                $tmpIndex++;
                if(defined($listInfo{$tmpDir})){
                    next;
                }
                $tmpIndex = $cifsCommon->getNextValidLineIndex(\@fileContent, $tmpIndex, $shareSectionEndIndex);
                if(defined($tmpIndex)){
                    if($fileContent[$tmpIndex]=~/^allow:(.*)/){
                        #the line such as [allow:]
                        $tmpAllow = $1;
                        $tmpIndex++;
                        $tmpIndex = $cifsCommon->getNextValidLineIndex(\@fileContent, $tmpIndex, $shareSectionEndIndex);
                        if(defined($tmpIndex)){
                            if($fileContent[$tmpIndex]=~/^deny:(.*)/){
                                #the line such as [deny:]
                                $tmpDeny = $1;
                                $tmpIndex++;
                                my $testIndex = $cifsCommon->getNextValidLineIndex(\@fileContent, $tmpIndex, $shareSectionEndIndex);
                                if(defined($testIndex)){
                                    #the next line is a valid line
                                    if($fileContent[$testIndex]!~/^dir:/){
                                        #the next line is not a new dir entry
                                        next;
                                    }
                                }
                                $tmpAllow =~ s/^\s+|\s+$//g;
                                $tmpDeny =~ s/^\s+|\s+$//g;
                                $listInfo{$tmpDir} = [$tmpAllow, $tmpDeny];
                            }else{
                                next;# because can not match "deny" ,find next entry;
                            }
                        }else{
                            last;# can not find new valid line
                        }
                    }else{
                        next;# because can not match "allow" ,find next entry;
                    }
                }else{
                    last; # can not find new valid line
                }
            }else{
                $tmpIndex++;# because can not match "dir" ,find next entry;
            }
        }else{
            last; #  can not find new valid line
        }
    }
    my @dirList = keys(%listInfo);
    foreach my $dirForDisplay(@dirList){
    	my $directoryForPrint = $codeConvert->changeUTF8Encoding($dirForDisplay, $expGroupEncoding, $codeConvert->ENCODING_UTF_8);
    	if(!defined($directoryForPrint)) {
            print "directory=$dirForDisplay\n";
        } else {
            print "directory=$directoryForPrint\n";
        }
        my $tmpRef = $listInfo{$dirForDisplay};
        print "allowHost=$$tmpRef[0]\n";
        print "denyHost=$$tmpRef[1]\n";
    }
}

exit 0;