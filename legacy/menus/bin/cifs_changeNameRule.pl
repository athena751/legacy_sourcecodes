#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_changeNameRule.pl,v 1.2303 2005/08/29 02:49:21 liq Exp $"

# function: 
#       update name transfer rule of all the moutpoints in whose name rules there 
#       there is form as "{localdomain}+{oldnetbios}".
# Parameter: 
#       $etcPath: /etc/group[0|1]/
#       $localDomain :
#       $oldNetbios :
#       $newNetbios :
# return value: 
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::CIFSCommon;
use NS::SystemFileCVS;

my $paraNum = scalar(@ARGV);
if($paraNum != 4 ){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $etcPath = shift;
my $localDomain = shift;
my $cifs=new NS::CIFSCommon;
my $regNtdomain = $cifs->str2RegStr($localDomain);
my $oldNetbios = shift;
my $newNetbios = shift;

my $imsfile = $etcPath . "ims.conf";

my $common = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

if (-f $imsfile){
    my @content = `cat $imsfile`;
    my $path;
    my $region;
    my $findMountPoint = 0;
    my $needUpdate = 0;
    my @tempRule = ();
    my $count = 0 ;
    foreach(@content){ 
        if ($_ =~ /^\s*p\s+/){
            $findMountPoint = 0;
            $needUpdate = 0;
            @tempRule = ();
            
            my @tempArr = split(/\s+/,$');
            if (scalar(@tempArr) >= 2 && $_ =~ /^\s*p\s+.*-o@.*$/){
                $path = $tempArr[0];
                $region = $tempArr[1];
                $findMountPoint = 1;
            }
            next;
        }
        
        if($findMountPoint == 1){
            if($_ =~ /^\s*EOT\s*$/){
                if ($needUpdate == 1){
                    system("rm -rf /tmp/nametrans.rule");
                    system("touch /tmp/nametrans.rule");
                    open(FILE,"| ${cmd_syncwrite_o} /tmp/nametrans.rule");
                    print FILE @tempRule;
                    if(!close(FILE)){
                          print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
                          exit 1;
                    };
                    
                    my $command = "/usr/bin/ims_auth -A $region -f -d $path -c $imsfile -o \@/tmp/nametrans.rule";
                    if(system("$command") != 0 && $count == 0 ){
                        print STDERR "Update rule failed!";
                        exit(1);
                    }
                    $count ++;
                }
            }else{
                my $tmp = $_;
                if($_ =~ /#/){
                   $tmp = $`;
                   $tmp = $tmp."\n";
                }
                if ($tmp =~ /([\s\"])$regNtdomain\+$oldNetbios([\s\"])/){
                    $tmp = $` . $1 . "$localDomain\+$newNetbios" . $2 . $';
                    $needUpdate = 1;
                }
                push(@tempRule,$tmp);
    	    }
        }
    }
}
exit 0;