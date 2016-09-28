#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nfs_getLogFileInfo.pl,v 1.4 2008/09/23 09:33:45 penghe Exp $"

#Function:
#   get the infos from accesslog and performance file.
#Arguments:
#   none
#Output:
#   success/failure
#   access_logfile
#   access_read
#   access_rotation
#   access_sizeNum
#   access_sizeUnit
#   perform_logfile
#   perform_read
#   perform_cycle
#   perform_rotation
#   perform_sizeNum
#   perform_sizeUnit
use strict;
use NS::NFSCommon;
use NS::NFSConst;
use NS::NsguiCommon;
use NS::CIFSCommon;
my $common  = new NS::NFSCommon();
my $exeSign = "success";
#get info from access/performance log file
my $accessloginfo = $common->getInfoFromLogFile(NS::NFSConst::FILE_NFSACCESSLOG_CONF
                                            ,NS::NFSConst::SEPARATE_SIGN_OF_NFSACCESSLOG);
if(!defined($accessloginfo)){
    $exeSign = "failure";
}elsif(!defined($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_LOGFILE})||!defined($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_ROTATION})
            ||!defined($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_SIZE})){
    $exeSign = "failure";
}

print "${exeSign}\n";
#print the info to STDOUT
print $$accessloginfo{NS::NFSConst::LOG_FILE_KEY_LOGFILE},"\n";
if(defined($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_LOGFILE})){
    print NS::CIFSCommon->checkUserRead(
            substr($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_LOGFILE}
                    ,0,rindex($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_LOGFILE},"/")+1)
                    ),"\n";
}else{
    print "no\n";
}
print $$accessloginfo{NS::NFSConst::LOG_FILE_KEY_ROTATION},"\n";
if($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_SIZE}=~/^(\d+)\s*M$/i){
    print "$1\n";
    print NS::NFSConst::SIZE_UNIT_MB,"\n";
}elsif($$accessloginfo{NS::NFSConst::LOG_FILE_KEY_SIZE}=~/^(\d+)\s*k$/i){
    print "$1\n";
    print NS::NFSConst::SIZE_UNIT_KB,"\n";
}else{
    print $$accessloginfo{NS::NFSConst::LOG_FILE_KEY_SIZE},"\n";
    print NS::NFSConst::SIZE_UNIT_MB,"\n";
}

exit 0;
