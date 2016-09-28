#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nashead_modifyStorageName.pl,v 1.3 2005/08/26 11:50:03 wangzf Exp $"

use strict;
use NS::SystemFileCVS;
use NS::NasHeadCommon;
use NS::NasHeadConst;

if(scalar(@ARGV) != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $nasHeadercommon = new NS::NasHeadCommon();
my $friendIp = $nasHeadercommon->getFriendIP();
if (defined($friendIp) && ($friendIp ne "")){
    if($nasHeadercommon->isActive($friendIp) == 1){
        print STDERR "The friend node is not active. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

my $wwnn = shift;
my $storageName = shift;

my $common = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

my $sanNickName_conf = $nasHeadercommon->getsannickname_conf();
if(!(-f $sanNickName_conf)){
    `touch $sanNickName_conf`;
}

my @content;
if(open(READ,"$sanNickName_conf")){
    @content = <READ>;
    close(READ);
}

my @newContent;
if($storageName ne ""){
    #check the storage name is used by other WWNN or not
    foreach(@content){
        if(/^\s*(\w+),(.+)$/){
            my $existStorage = $2;
            chomp($existStorage);
            if(($existStorage eq $storageName)&&($wwnn ne $1)){
                #the name has been used for other wwnn
                exit 50;
            }
        }
    }
    
    #change the storage name
    my $existWwnn = 0;
    foreach(@content){
        
        if(/^\s*${wwnn},/){
            push(@newContent, "$wwnn,$storageName\n");
            $existWwnn=1;
        }else{
            push(@newContent, $_);
        }
    }
    
    if($existWwnn == 0){
        push(@newContent, "$wwnn,$storageName\n");
    }
}else{
    #delete the storage name
    foreach(@content){
        if(/^\s*${wwnn},/){
            #delete this line
        }else{
            push(@newContent, $_);
        }
    }
}
if($common->checkout($sanNickName_conf)!=0){
    print STDERR "Failed to checkout \"$sanNickName_conf\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
if(open(WRITE,"| ${cmd_syncwrite_o} $sanNickName_conf")){
    print WRITE @newContent;
    if(!close(WRITE)) {
        $common->rollback($sanNickName_conf);
        print STDERR "Failed to write \"$sanNickName_conf\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;    
    }
    ### rcp file to friend node when cluster case
    if(defined($friendIp) && ($friendIp ne "")){
        my $targetFile;
        my $const = new NS::NasHeadConst();
        if($sanNickName_conf eq $const->FILE_GROUP0_SANNICKNAME_CONF){
            $targetFile = $const->FILE_GROUP1_SANNICKNAME_CONF;
        }else{
            $targetFile = $const->FILE_GROUP0_SANNICKNAME_CONF;
        }
        if ($nasHeadercommon->syncFile($sanNickName_conf, $targetFile, $friendIp) != 0){
            $common->rollback($sanNickName_conf);
            print STDERR "Failed to execute:syncFile($sanNickName_conf, $targetFile, $friendIp). Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit 1;
        }
    }
}else{
    $common->rollback($sanNickName_conf);
    print STDERR "Failed to open \"$sanNickName_conf\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
$common->checkin($sanNickName_conf);

exit 0;