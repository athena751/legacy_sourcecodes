#!/usr/bin/perl -w
#       copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nfs_setAccessStatus.pl,v 1.1 2005/11/21 01:24:58 liul Exp $"

use strict;
use NS::SystemFileCVS;
use NS::NFSConst;
use NS::NsguiCommon;
my $comm  = new NS::NsguiCommon;
my $cvs = new NS::SystemFileCVS;
my $const = new NS::NFSConst;

my $file = "/etc/sysconfig/nfsd/nfsd.conf";
my $cmd = "/sbin/sysctl -p ";


if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_a = $cvs->COMMAND_NSGUI_SYNCWRITE_A;
my $para=shift;

if(($para ne "available")&&($para ne "deny")){
    print STDERR "Invalid parameter given.Exit in perl script:"
                        ,__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if(!-d "/etc/sysconfig/nfsd"){
    if(system("mkdir -p /etc/sysconfig/nfsd")!=0){
        print STDERR "Failed to make dir /etc/sysconfig/nfsd. Exit in perl script:"
                        ,__FILE__," line:",__LINE__+1,".\n";
        exit 1;                
    }
}

if(!-e ${file}){
    system("touch ${file}");
    if($? != 0){
        print STDERR "Failed to create file ${file}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

if($cvs->checkout(${file})!=0){
    print STDERR "Failed to checkout file ${file}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}

my @content = `cat $file`;
my $flag=0;
foreach(@content){
    if( /^\s*$/ || /^\s*#/ ){
        next;
    }

    if(/^\s*fs\.nfs\.correct_access\s*=/){
        $flag =1;
        if($para eq "available"){
            $_="fs.nfs.correct_access = 0 \n";
        }

        else{
            $_="fs.nfs.correct_access = 1 \n";
        }
        last;
    }
}

if($flag==1){
    if(!open(OUT, "|${cmd_syncwrite_o} ${file}")){
        $cvs->rollback($file);
        print STDERR "Failed to write ${file}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    print OUT @content;
    close(OUT);
}
if($flag==0){
    if(!open(OUT, "|${cmd_syncwrite_a} ${file}")){
        $cvs->rollback($file);
        print STDERR "Failed to write ${file}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n";
        exit 1;   
    }
    if($para eq "available"){
        print OUT "fs.nfs.correct_access = 0 \n";
        close(OUT);
    }
    else{
        print OUT "fs.nfs.correct_access = 1 \n";
        close(OUT);
    }
}
system("${cmd} ${file} 2>/dev/null");

if($cvs->checkin($file)!=0){
    $cvs->rollback($file);
    print STDERR "Failed to checkin ${file}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
exit 0;
