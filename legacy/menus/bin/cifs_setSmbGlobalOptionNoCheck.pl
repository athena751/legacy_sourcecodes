#!/usr/bin/perl 
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: cifs_setSmbGlobalOptionNoCheck.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

use strict;
use NS::CIFSCommon;
#use NS::SystemFileCVS;
    #Function: get content of smb.conf
    #Parameter:globalDomain localDomain NetBios "security=.. coding system=..  .."
    #return value:0:succed 1:failed
    #Process 
    
    #1.    check parameters
    if(scalar(@ARGV)!=6){
        print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
        exit(1);
    }
    my ($etcPath,$ignore,$globalDomain,$localDomain,$NetBios,$options)=@ARGV;
    
    #2.    call CIFSCommon::getSmbOrVsName to get full name of smb.conf.open it with readonly mode,if failed,exit 1,else read content to array @content;close file  
    my $cifs=new NS::CIFSCommon;
    my $filename=$cifs->getSmbOrVsName($etcPath,$globalDomain,$localDomain,$NetBios,0);
    if(!$filename){
        print STDERR "can't get file name by global Domain:$globalDomain,local Domain:$localDomain,netBios:$NetBios. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    my $exitFlag=0;
    $filename=$cifs->trim($filename);
    -f $filename or $exitFlag=1;
    if($exitFlag==1){
        print STDERR "file $filename doesn't exist or not normal file. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    open(FILE,$filename)or $exitFlag=1;
    if($exitFlag==1){
        print STDERR "file $filename can't be opened(read only). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    my @content=<FILE>;
    close(FILE);
    my @opt=();
    @opt=split(/\n/,$options);
    if(scalar(@opt)==0){
        exit(0);
    }
    my $index=-1;
    my $line="";
    my $flag;
    my $hasSecurity=0;
    if (scalar(grep(/^\s*security\s*=/i,@content))>0){
        exit 0;  # security has been set.
    }
    
    @opt=map($_."\n",@opt);
    for($index=0;$index<scalar(@content);$index++){
        $line=$content[$index];
        if($line=~/^\s*$/){
            next;
        }
        if($flag==0){
            if($line=~/^\s*\[\s*global\s*\]\s*$/i){
                $flag=1;
            }
            next;
        }
        $line=$line."\n";
        if($flag==1){
            my $fixed=$cifs->getFixedKey();
            if($line=~/^\s*#\s*$fixed\s*$/i){
                $flag=2;
                next;
            }
            elsif($cifs->isCommentLine($line)==1){
                next;
            }elsif($line=~/^\s*\[/){
                last;
            }else{
                next;                    
            }                    
        }
        if($flag==2){
           if($line=~/^\s*\[/){
                last;
           }
           $index = &modifyLine($index,\@opt,\@content);
            next;
        }
    }
    my $ref=$cifs->deleteItemsNoValue(@opt);
    @opt=@$ref;
    if($flag!=2){
        my $line=join("",("#irrevocable options","\n"));
        unshift(@opt,$line);
    }
    if($flag==0){
        my $line=join("",("[","global","]","\n"));
        unshift(@opt,$line);
    }
    splice(@content,$index,0,@opt);
    
    if (scalar(grep(/^\s*security\s*=\s*user\s*/i,@opt))>0){
        for($index=0;$index<scalar(@content);$index++){
            if (   ($content[$index] =~ /^\s*winbind\s*enum\s*groups\s*=/)
                || ($content[$index] =~ /^\s*winbind\s*separator\s*=/)
                || ($content[$index] =~ /^\s*winbind\s*gid\s*=/)
                || ($content[$index] =~ /^\s*winbind\s*uid\s*=/)
                || ($content[$index] =~ /^\s*template\s*shell\s*=/ )){
                splice(@content,$index,1);
                $index--;
            }
        }
    }
    
    open(FILE,">$filename");# or (print "can't open file $file.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";exit(1);)#$common->undoExit($filename,1,"write file $filename failed\n");
    print FILE @content;
    close FILE;
    exit(0);
    
sub modifyLine(){
    #Function:modify line(whose position is "index") in content by using corresponding params in param
    #Parameters:
        #index---line of this index being modified
        #param---used to modify this line
        #content---content of file
    #Returns:
        #undef---failed
        #new index---succeed
    #Process
    my ($index,$param,$content) = @_;
    my $line = $$content[$index];
    #get key of current line
    my ($key,$value)=$cifs->getKeyValueOfLine($line,"=");
    if(!$key){
        return $index;
    }
    if(scalar(@$param)>0){
        #get last one of lines including key---if exist,delete all lines including key from param
        my ($keyLine,$refParam)=$cifs->getKeyLine($key,@$param);
        if(!defined($keyLine)){
            return $index;
        }
        ($key,$value)=$cifs->getKeyValueOfLine($keyLine,"=");
        if(!$key){
            splice(@$content,$index,1);
            $index--;
        }else{
            splice(@$content,$index,1,$keyLine);
        }
        @$param=@$refParam;
    }
    return $index;
}
