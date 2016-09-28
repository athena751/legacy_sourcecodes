#!/usr/bin/perl -w

#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: quota_getGraceTime.pl,v 1.2302 2006/02/20 00:34:41 zhangjun Exp $"

use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########

if(scalar(@ARGV) != 2) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $cc = new NS::CodeConvert;
my $mountPoint = shift;
if ($mountPoint=~/^0x/){
    $mountPoint = $cc -> hex2str($mountPoint);
}

########add by zhangjun
$mountPoint =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$mountPoint = $cc->changeUTF8Encoding($mountPoint, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($mountPoint) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

my $dirFlag = shift;
my @content;
my @result;
my $tmp;

## *** Report for user quotas ***
if($dirFlag eq "isDir"){
    @content = `/usr/sbin/repquota -uvd \Q$mountPoint\E`;
} else {
    @content = `/usr/sbin/repquota -uv \Q$mountPoint\E`;
}
$tmp = &getGraceTime(\@content);
push(@result, @$tmp);

## *** Report for group quotas ***
if($dirFlag eq "isDir"){
    @content = `/usr/sbin/repquota -gvd \Q$mountPoint\E`;
} else {
    @content = `/usr/sbin/repquota -gv \Q$mountPoint\E`;
}
$tmp = &getGraceTime(\@content);
push(@result, @$tmp);

## *** Report for group quotas ***
if($dirFlag eq "isDir"){
    @content = `/usr/sbin/repquota -vd \Q$mountPoint\E`;
    $tmp = &getGraceTime(\@content);
    push(@result, @$tmp);
}

foreach(@result){
    print "$_ \n";
}

exit 0;

sub getGraceTime(){
    my $tmp = shift;
    my @content = @$tmp;
    my $flag = 1;
    my @result;
    foreach(@content){
        if($_ =~/Block\s+grace\s+time:\s+(\S+);\s+Inode\s+grace\s+time:\s+(\S+)/ ) {
            $flag = 0;
            push(@result, &switchTime($1));
            push(@result, &switchTime($2));
            last;
        }
    }

    if($flag){
        push(@result, (7,7));
    }
    return \@result;
}

sub switchTime() {
    my $graceTime = shift;
    my $result;
    if($graceTime) {
        if($graceTime=~/(\d+)days/) {
            $result = $1;
        } elsif($graceTime=~/(\d+):(\d+)/) {
            $result = ($1*3600 + $2*60)/(24*3600);
            if($result != 0 ) {
                my @tmp = split(/\./,$result);
                if( defined($tmp[1]) and length($tmp[1]) >4 ) {
                    $result = sprintf("%.4f", $result);
                }
            }
        }else{     
            $result = 7;
        }
    } else {
        print STDERR "Command: \"repquota -ugvd ...\" executed failed in perl script(",__FILE__,").\n";
        exit 1;
    }
    return $result;
}
