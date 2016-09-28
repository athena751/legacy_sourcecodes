#!/usr/bin/perl
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nfs_saveLogOptionsToFile.pl,v 1.7 2008/09/23 09:35:26 penghe Exp $"

#Function: 
    #save the log options info access log file
#Arguments: 
    #$accessFileName  : the path of access log's output files 
    #$accessCanRead   : the sign that used to make the dir of access log files
    #$accessRotation  : the generations of access log files
    #$accessSize      : the size of one access log file
    #$performFileName : the path of perform log's output files 
    #$performCanRead  : the sign that used to make the dir of perform log files
    #$performRotation : the generations of perform log files
    #$performSize     : the size of one perform log file
    #$performCycle    : the sign that used to make the dir of perform log files
    #$groupNo         : 0 or 1
#Exit code:
    #0:succeed 
    #1:failed
use strict;
use NS::SystemFileCVS;
use NS::NFSConst;
use NS::NsguiCommon;
use NS::CIFSCommon;
my $comm    = new NS::NsguiCommon;
my $cvs     = new NS::SystemFileCVS;
my $const   = new NS::NFSConst;
if(scalar(@ARGV) != 5){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my ($accessFileName,$accessCanRead,$accessRotation,$accessSize,$groupNo) = @ARGV;
#if the path of access log/performance info's output files are not on os/user area,exit 1
my $cfstabFile = "/etc/group${groupNo}/cfstab";
my @mpList;
if($accessFileName=~/^\/export\//){
    if(-f $cfstabFile){
        if(!open(FILE,$cfstabFile)){
            print STDERR  "Failed to open file [$cfstabFile]. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit 1;
        }
        @mpList = <FILE>;
        close(FILE);    
    }
}
my $accessCheckResult = &checkFilePath($accessFileName,"/var/opt/nec/nfsaccesslog/nfsaccesslog",\@mpList);
if($accessCheckResult){
    $comm->writeErrMsg($const->ERRCODE_ACCESS_LOGFILE_PATH_INVALID,__FILE__,__LINE__+1);
    exit 1;
}

#if the path of access log's output files have problems,do something to make it better
my $result = NS::CIFSCommon->makeLogFileDir($accessFileName, $accessCanRead);
if($result == 1){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_LOGFILE_FILEISDIR,__FILE__,__LINE__+1);
    exit 1;
}elsif($result == 2){
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_LOGFILE_DIRISFILE,__FILE__,__LINE__+1);
    exit 1;
}

#change the log conf infos
my $accessActionFailure=0;
my %tmpAccessInfo = ($const->LOG_FILE_KEY_LOGFILE,$accessFileName,
                        $const->LOG_FILE_KEY_ROTATION,$accessRotation,
                        $const->LOG_FILE_KEY_SIZE,$accessSize);

$accessActionFailure = &writeLogFile($const->FILE_NFSACCESSLOG_CONF,$const->COMMAND_NFSACCESSLOGSET
                                        ,\%tmpAccessInfo,$const->SEPARATE_SIGN_OF_NFSACCESSLOG);

if($accessActionFailure ne "success"){
    print STDERR $accessActionFailure;
    $comm->writeErrMsg($const->ERRCODE_FAILED_TO_MODIFY_ACCESSLOG,__FILE__,__LINE__+1);
    exit 1;
}else{
    exit 0;
}

sub writeLogFile(){
    my ($filename,$commandStr,$info,$seperator) = @_;
    if(-f $filename && !open(FILE,$filename)){
        return join("","Failed to open ${filename}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");
    }
    my @contents = <FILE>;
    my @filterContents;
    for(my $i=0;$i<scalar(@contents);$i++){
        if( $contents[$i]=~/^\s*$/ || $contents[$i]=~/^\s*#/ ){
            push(@filterContents,$contents[$i]);
        }elsif( $contents[$i]=~/^\s*([^${seperator}]+)${seperator}/ ){
            my $formmerKey = $1;
            $formmerKey =~s/^\s+//;
            $formmerKey =~s/\s+$//;
            my $notfind = 1;
            for(my $j=$i+1;$j<scalar(@contents);$j++){
                if($contents[$j] =~/^\s*${formmerKey}\s*${seperator}/){
                    $notfind = 0;
                    last;    
                }
            }
            if($notfind){
                push(@filterContents,$contents[$i]);
            }
        }else{
            push(@filterContents,$contents[$i]);
        } 
    }
    my @resultContents;
    foreach(@filterContents){
        if( /^\s*$/ || /^\s*#/ ){
            push(@resultContents,$_);
            next;
        }
        if(/^\s*([^${seperator}]+)\s*${seperator}\s*.*$/){
            my $tmpKey = $1;
            $tmpKey =~s/^\s+//;
            $tmpKey =~s/\s+$//;
            if(defined($$info{$tmpKey})){
                push(@resultContents,"${tmpKey}${seperator}$$info{${tmpKey}}\n");
                delete($$info{$tmpKey});
            }else{
                push(@resultContents,$_);
            }
        }else{
            push(@resultContents,$_);
        }    
    }
    close(FILE);
    #add the keys that does not exist in file
    foreach(keys(%$info)){
        push(@resultContents,"$_${seperator}$$info{$_}\n");
    }
    #write the new content into the file
    if(!-d "/etc/sysconfig/nfsd"){
        if(system("mkdir -p /etc/sysconfig/nfsd")!=0){
            return join("","Failed to make dir /etc/sysconfig/nfsd. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");
        }
    }
    if($cvs->checkout($filename)!=0){
        return join("","Failed to checkout ${filename}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");
    }
    if(!open(OUT, "|${cmd_syncwrite_o} ${filename}")){
        $cvs->rollback($filename);
        return join("","Failed to write ${filename}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");
    }
    print OUT @resultContents;
    if(!close(OUT)) {
        $cvs->rollback($filename);
        return join("","Failed to write ${filename}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");    
    }
    if(system("$commandStr 2> /dev/null") != 0){
        $cvs->rollback($filename);
        return join("","Failed to execute command ${commandStr}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");
    }
    if($cvs->checkin($filename)!=0){
        $cvs->rollback($filename);
        return  join("","Failed to checkin ${filename}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n");
    }
    return "success";
}

sub checkFilePath(){
    my ($filePath,$defaultPath,$mountResultRef) = @_;
    if($filePath eq $defaultPath){
        return 0;
    }else{
        foreach(@$mountResultRef){
            if(/^\s*$/ || /^\s*#/){
                next;
            }
            if(/^\s*\S+\s+(\S+)\s+/ && ($filePath=~/^\Q$1\E\// 
                                        || $filePath eq $1
                                        || $filePath eq $1."/")){
                return 0;
            }
        }
        return 1;
    }
}
