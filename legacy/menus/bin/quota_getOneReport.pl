#!/usr/bin/perl
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_getOneReport.pl,v 1.4 2007/02/27 07:27:29 zhangjun Exp $"

use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########

if(scalar(@ARGV) != 4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1); 
} 

#get all the parameters , and change filesystem's coding
my $cc = new NS::CodeConvert();
my $TEMPLATE = "TEMPLATE";
my ($command1, $command2, $filesystem, $id) = @ARGV;
if ($filesystem=~/^0x/){
    $filesystem = $cc->hex2str($filesystem);
}
########add by zhangjun
$filesystem =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$filesystem = $cc->changeUTF8Encoding($filesystem, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($filesystem) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

#run the command
my @result = `$command1 $command2 \Q$filesystem\E`;
if ($? != 0){
    print STDERR "Failed to execute   \"$command1 $command2 $filesystem\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my @idInfo;
if($id == 0){
    if($command2 eq "-vd"){
        @idInfo = grep(/^\d+\s+/,@result);
    }else{
        @idInfo = grep(/^$TEMPLATE\s+/,@result);
    }
}else{
   @idInfo = grep(/^$id\s+/,@result);
}
if(scalar(@idInfo) == 0){
    print "\n";
    exit 0;
}
my @info = split(/\s+/,$idInfo[0]);
my @limitInfo;
if(($id == 0) and ($command2 ne "-vd" )){#get info for TEMPLATE
    push(@limitInfo,$info[2],$info[3]); #block soft,block hard
    my $offset = 0;
    if(scalar(@info) == 9){
        $offset = 1;
    }
    push(@limitInfo,$info[5+$offset],$info[6+$offset]); #file soft,file hard
}else{
    push(@limitInfo,$info[3],$info[4]); #block soft,block hard  
    #push file soft,file hard   
    if($info[1] eq "--" || $info[1] eq "-+"){
        push(@limitInfo,$info[6],$info[7]); #file soft,file hard         
    }else{ # $info[1] eq "+-" or others
        my $offset = 0;
        if(scalar(@info) > 8){
            $offset = 1;
        }
        push(@limitInfo,$info[6+$offset],$info[7+$offset]); #file soft,file hard   
    }
}
foreach(@limitInfo){
        print $_," ";
}
print "\n";