#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_isInSharePartition.pl,v 1.3 2005/01/25 06:14:23 baiwq Exp $"

#Function: 
    #check if the target file is in the share Partition
#Arguments: 
    #$file:the full name of the file
#exit code:
    #0: success
    #1: parameter's number error
#output:
    #"true" :if the file is behind those directories
    #"false":else

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;
use NS::SyslogCommon;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;
my $syslogCommon = new NS::SyslogCommon;

my $file = shift;
my $actionInFriendNode = shift;

if(defined($actionInFriendNode)){
    #is called by the friend node
    $file = $comm->hex2str($file);
}

#get all the directories which belongs to the share partition
my @directories=($const->CONST_ETC_GROUP0,$const->CONST_ETC_GROUP1,
            $const->CONST_ETC_GROUP0SETUPINFO,$const->CONST_ETC_GROUP1SETUPINFO);

my $mp = $syslogCommon->getMountingMp();
foreach(@$mp){
    if(/\/$/){
        #no need to add the '/' at the tail
        push (@directories, $_);
    }else{
        #add the '/' at the tail
        push (@directories, "$_/");
    }
}

#check the target file 
foreach(@directories){
    if($file =~ /^\Q$_\E/){
        #the target file is in the share Partition
        print "true\n";
        exit 0;
    }
}
if(!defined($actionInFriendNode)){
#need check the file at the friend node
    my $friendIP = $comm->getFriendIP();
    if (defined($friendIP) && $friendIP ne ""){
        if ($comm->isActive($friendIP) == 0 ){
            #the friend node is active
            my $hex_fileName = $comm->str2hex($file);
            my ($ret,$content) = $comm->rshCmdWithSTDOUT("sudo /home/nsadmin/bin/log_isInSharePartition.pl $hex_fileName true", $friendIP);
            print @$content[0];
            exit 0;
        }
        
    }
    
}
print "false\n";

exit 0;