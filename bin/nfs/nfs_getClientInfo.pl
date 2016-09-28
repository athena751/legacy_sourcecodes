#!/usr/bin/perl
#
#       Copyright (c) 2008-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nfs_getClientInfo.pl,v 1.3 2009/04/10 01:37:00 yangxj Exp $"

use strict;
use NS::NFSCommon;
use NS::NFSConst;
if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $common  = new NS::NFSCommon();
my $const   = new NS::NFSConst(); 

my ($mountpoint,$groupNo) = @ARGV;
my $clientOptions;

if($mountpoint=~/^\/export/){
    $clientOptions = $common->getClientAndOption($mountpoint,$groupNo);
    if(!defined($clientOptions)){
        print STDERR $common->error();
        exit 1;
    }
}

foreach(@$clientOptions){
    #print "172.28.11.140 nisdomain readOnly usermapping rootSquash annonuid annongid subtree hide secure secureLock accesslog profile create remove write read";
    my $result = &analyseClient($_);
    print "$result\n";
}

exit 0;

sub analyseClient{
    my $oneLine = shift;
    my $client = "";
    my $nisdomain = "--";
    my $accessMode = "ro";
    my $userMapping = "no_map";
    my $rootSquash = "root_squash";
    my $uid = "-2";
    my $gid = "-2";
    my $subtree = 1;
    my $hide = 1;
    my $secure = 1;
    my $secureLock = 1;
    my $accesslog = 0;
    my $unstablewrite = 0;
    my $create = 1;
    my $remove = 1;
    my $write = 1;
    my $read = 1;
    my @allProc = ("SETATTR", "CREATE", "MKDIR", "SYMLINK", "MKNOD", "LINK", "REMOVE", "RMDIR", "RENAME", "WRITE", "READ");
    my @createProc = @allProc[0..5];
    my @removeProc = @allProc[6..8];
    my $writeProc = $allProc[9];
    my $readProc = $allProc[10];
    
    $client = substr($oneLine, 0, index($oneLine, "("));
    my $option = substr($oneLine, index($oneLine, "(") + 1);    
    $option =~ s/\)\s*$//;
    # get accesslogproc
    my $accesslogproc;
    my $hasProc=0;
    if($option =~ /\baccesslogproc=\"([^\"]*)\"/) {
        $accesslogproc = $1;
        $hasProc=1;
        $option =~ s/\baccesslogproc=\"[^\"]*\"//g;
    }
    
    # get nisdomain
    if($option =~ /\bnisdomain=([^,]*)/) {
        $nisdomain = $1;
        $option =~ s/\bnisdomain=[^,]*//g;
    }

    # get annon uid
    if($option =~ /\banonuid=([^,]*)/) {
        $uid = $1;
        $option =~ s/\banonuid=[^,]*//g;
    }
    
    # get annon gid
    if($option =~ /\banongid=([^,]*)/) {
        $gid = $1;
        $option =~ s/\banongid=[^,]*//g;
    }
            
    $option =~ s/,+/,/g;
    $option =~ s/^,*//g;
    $option =~ s/,*$//g;

    
    my $hasMap = 0;
    my $hasAnon = 0;   
    # get other options
    my @otherOptions = split(",", $option);
    for(my $i=scalar(@otherOptions)-1; $i>=0; $i--) {
        my $curOpt = $otherOptions[$i];
        $curOpt = &trim($curOpt);
        if($curOpt eq "rw") {
            $accessMode = "rw";
        } elsif($curOpt eq "map") {
            $userMapping = "map";
            $hasMap = 1;
        } elsif($curOpt eq "anon") {
            $hasAnon = 1;
        } elsif($curOpt eq "all_squash") {
            $rootSquash = "all_squash";
        } elsif($curOpt eq "no_root_squash") {
            $rootSquash = "no_root_squash";
        } elsif($curOpt eq "no_subtree_check") {
            $subtree = 0;
        } elsif($curOpt eq "nohide") {
            $hide = 0;            
        } elsif($curOpt eq "insecure") {
            $secure = 0;            
        } elsif($curOpt eq "insecure_locks") {
            $secureLock = 0;            
        } elsif($curOpt eq "accesslog") {
            if($hasProc==0) {
                $accesslog = 1;            
            } elsif($accesslogproc ne "") {
                $accesslog = 1;            
            }
        } elsif($curOpt eq "unstable_write") {
            $unstablewrite = 1;
        }
    }
    if($hasMap && $hasAnon) {
        $userMapping = "anon";
    }
    
    if($accesslog) {
        if($hasProc) {
            my @procs = split(",", $accesslogproc);
            my $temp;
            foreach $temp (@createProc) {
                if(grep(/^${temp}$/, @procs)<1) {
                    $create=0;
                    last;
                }
            }

            foreach $temp (@removeProc) {
                if(grep(/^${temp}$/, @procs)<1) {
                    $remove=0;
                    last;
                }
            }

            if(grep(/^${writeProc}$/, @procs)<1) {
                $write=0;
            }

            if(grep(/^${readProc}$/, @procs)<1) {
                $read=0;
            }
        }
    } else {
        $create = "--";
        $remove = "--";
        $write = "--";
        $read = "--";
    }
    return join(" ", ($client, $nisdomain, $accessMode, $userMapping, $rootSquash, $uid, $gid, $subtree, $hide, $secure, $secureLock, $accesslog, $create, $remove, $write, $read, $unstablewrite)); 
}

sub trim {
    my $str = shift;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    return $str;
}
