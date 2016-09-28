#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cifs_getShareListInfo.pl,v 1.7 2008/12/18 07:35:57 chenbc Exp $"

#Function: 
    #get the share list informations: [shareName],[directory],[fsType],[connection],[readOnly],[comment],[isLogging],[antiVirus]
#Arguments: 
    #$groupNumber      : the group number 0 or 1
    #$domainName       : the Domain Name
    #$computerName     : the Computer Name
    #$shareType        : the Share Type (special/normal)
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #when shareType is undef
    #------------------------------------------------------
    #|STDOUT Content         | Line Number (n=0,1,2,3,4...)|
    #------------------------------------------------------
    #|shareName=<shareName>  |  7*n + 1
    #|directory=<directory>  |  7*n + 2
    #|comment=<comment>      |  7*n + 3
    #|fsType=<fsType>        |  7*n + 4
    #|connection=<connection>|  7*n + 5
    #|readOnly=<readOnly>    |  7*n + 6
    #|logging=<isLogging>    |  7*n + 7
    
    #when shareType is normal
    #------------------------------------------------------
    #|STDOUT Content         | Line Number (n=0,1,2,3,4...)|
    #------------------------------------------------------
    #|shareName=<shareName>  |  8*n + 1
    #|directory=<directory>  |  8*n + 2
    #|comment=<comment>      |  8*n + 3
    #|fsType=<fsType>        |  8*n + 4
    #|connection=<connection>|  8*n + 5
    #|readOnly=<readOnly>    |  8*n + 6
    #|logging=<isLogging>    |  8*n + 7
    #|antiVirus=<antiVirus>  |  8*n + 8
    
    #when shareType is special
    #------------------------------------------------------
    #|STDOUT Content             | Line Number (n=0,1,2,3,4...)|
    #------------------------------------------------------
    #|shareName=<shareName>      |  7*n + 1
    #|directory=<directory>      |  7*n + 2
    #|comment=<comment>          |  7*n + 3
    #|fsType=<fsType>            |  7*n + 4
    #|connection=<connection>    |  7*n + 5
    #|readOnly=<readOnly>        |  7*n + 6
    #|sharePurpose=<sharePurpose>|  7*n + 7

    #------------------------------------------------------
    
use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::CodeConvert;
use NS::RPQLicenseNo;

use constant TYPE_NORMAL => "normal";
use constant TYPE_SPECIAL => "special";
use constant PURPOSE_BACKUP => "backup";
use constant PURPOSE_REALTIME => "realtime_scan";

my $comm  = new NS::NsguiCommon;
my $const = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;
my $codeConvert = new NS::CodeConvert;
my $RPQ_No = new NS::RPQLicenseNo;

if(scalar(@ARGV)!=3 and scalar(@ARGV)!=4){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $groupNumber = shift;
my $domainName = shift;
my $computerName = shift;
my $shareType = shift;
defined($shareType) or $shareType = "";

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);
if(!defined($expGroupEncoding)) {
    print STDERR $const->ERRMSG_GETEXPORTGROUP."\n";
    $comm->writeErrMsg($const->ERRCODE_GETEXPORTGROUP,__FILE__,__LINE__+1);
    exit 1;
}


my $smb_conf_content = $cifsCommon->getSmbContent($groupNumber, $domainName, $computerName);
my ($shareNameRef, $shareSectionIndexRef) = $cifsCommon->getAllShareInfo($smb_conf_content);
my $shareNumbers = scalar(@$shareNameRef);
if($shareNumbers > 0){
    my $needChangeCode = $codeConvert->needChange($expGroupEncoding);
    if(defined($needChangeCode) && $needChangeCode eq "y") {
        $needChangeCode = "yes";
    } else {
        $needChangeCode = "no";
    }
    
    my $directory;
    my $comment;
    my $logging;
    my $connection;
    my $readOnly;
    my $fstypeOfAllMP = $cifsCommon->getFstypeOfAllMP($groupNumber);
    my $fsType;
    my $antiVirusForGlobal = $confCommon->getKeyValue("virus scan mode", "global", $smb_conf_content);
    defined($antiVirusForGlobal) or $antiVirusForGlobal = "no";
    $antiVirusForGlobal = $cifsCommon->equalsIgnoreCase($antiVirusForGlobal, "yes");
    for(my $tmpIndex = 0; $tmpIndex < $shareNumbers; $tmpIndex++){
        my $shareName = @$shareNameRef[$tmpIndex];
        my $endIndex;
        if($tmpIndex == ($shareNumbers - 1)){
            $endIndex = scalar(@$smb_conf_content) - 1;
        }else{
            $endIndex = @$shareSectionIndexRef[$tmpIndex + 1] - 1;
        }
        my @tmpSection = @$smb_conf_content[@$shareSectionIndexRef[$tmpIndex]..$endIndex];
        $directory = $confCommon->getKeyValue("path", $shareName, \@tmpSection);
        defined($directory) or $directory   = "";
        $fsType = $cifsCommon->getFstypeOfSpecifiedDir($directory, $groupNumber, $fstypeOfAllMP);
        if($fsType ne ""){
            my $sharePurpose = $cifsCommon->getShareType($shareName, \@tmpSection);
            if($shareType eq &TYPE_SPECIAL){
                if($sharePurpose eq "normal"){
                    next;
                }
                print "sharePurpose=$sharePurpose\n";
            }else{
                if($shareType eq &TYPE_NORMAL){
                    if($sharePurpose ne "normal"){
                        next;
                    }
                    my $noScan = $confCommon->getKeyValue("no scan", $shareName, \@tmpSection);
                    defined($noScan) or $noScan = "";
                    my $antiVirusForDisplay = $cifsCommon->getFinalAntiVirus($noScan, $antiVirusForGlobal);
                    print "antiVirus=$antiVirusForDisplay\n";
                }
                $logging = $confCommon->getKeyValue("alog enable", $shareName, \@tmpSection);
                defined($logging)   or $logging     = "";
                $logging = $cifsCommon->convertBoolean($logging, "no");
                print "logging=$logging\n";
            }
            $comment = $confCommon->getKeyValue("comment", $shareName, \@tmpSection);
            $connection = $confCommon->getKeyValue("available", $shareName, \@tmpSection);

            defined($comment)   or $comment     = "";
            defined($connection) or $connection = "";

            $comment=~s/^\"|\"$//g;
            $connection = $cifsCommon->convertBoolean($connection, "yes");
            $readOnly = &getReadOnlyValueByShare($shareName, \@tmpSection);

            my $share_dir_comment = "shareName=$shareName\ndirectory=$directory\ncomment=$comment\n";

            if($needChangeCode eq "yes"){
                &printChangedCode($share_dir_comment);
            }else{
                print $share_dir_comment;
            }

            print "fsType=$fsType\n";
            print "connection=$connection\n";
            print "readOnly=$readOnly\n";
        }
    }
}
exit 0;

sub printChangedCode(){
    my $iconv = join(" ", "/usr/bin/iconv", "-c", "-f", "UTF8-NEC-JP", "-t", "UTF-8");
    $_ = shift;
    open(ICONV, "|$iconv");
    print(ICONV);
    close(ICONV);
}

sub getReadOnlyValueByShare(){
    my $shareName = shift;
    my $sectionRef = shift;
    my $readOnly = $confCommon->getKeyValue("read only", $shareName, $sectionRef);
    my $writeable = $confCommon->getKeyValue("writeable", $shareName, $sectionRef);
    defined($readOnly) or $readOnly = "";
    defined($writeable) or $writeable = "";
    
    $readOnly = $cifsCommon->convertBoolean($readOnly, "yes");
    $writeable = $cifsCommon->convertBoolean($writeable, "yes");
    
    my $readOnlyIndex  = $confCommon->getKeyIndex("read only", $shareName, $sectionRef);
    my $writeableIndex = $confCommon->getKeyIndex("writeable", $shareName, $sectionRef);
    
    #proccess readOnly
    if ($readOnlyIndex < $writeableIndex){
        $readOnly = ($writeable eq "yes") ? "no" : "yes";
    }
    return $readOnly;
}
