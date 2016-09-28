#!/usr/bin/perl -w

#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: CodeConvert.pm,v 1.2303 2007/06/28 01:44:37 fengmh Exp $"
package NS::CodeConvert;
$VERSION = '1.00';

use strict;
no utf8;
no warnings;

use constant ENCODING_UTF_8 => "UTF-8";
use constant ENCODING_UTF8_NEC_JP => "UTF8-NEC-JP";
my $nsguiIconv = "/home/nsadmin/bin/nsgui_iconv.pl";

sub new(){
    my $this = {};
    bless $this;
    return $this;
}

sub str2hex(){
    shift;
    my $str=shift;
    my $result;
    my @tmp=split(//,$str);
    foreach(@tmp){
        $result=$result.sprintf("0x%02x",ord($_));
    }
    return $result;    
}

sub hex2str(){
    shift;
    my $str=shift;
    my $result;
    my @tmp=split(/0x/,$str);
    shift(@tmp);
    $result = pack("H2" x scalar(@tmp), @tmp);
    return $result;
}

sub changeEncoding() {
    shift;
    my ($str, $fromEncoding, $toEncoding) = @_;
    if(!defined($str) || !defined($fromEncoding) || !defined($toEncoding)) {
        return undef;
    }
    my $rad = rand(1000);
    my $temp = "/tmp/utf8$$"."$rad";
    my $output;
    if(system("touch $temp") == 0) {
        open(FILE, ">$temp");
        print FILE $str;
        close (FILE);
    } else {
    	return undef;
    }
    $output = `cat $temp | $nsguiIconv -f $fromEncoding -t $toEncoding`;
    if($? != 0) {
    	system("rm -f $temp");
        return undef;
    }
    system("rm -f $temp");
    return $output;
}

sub changeUTF8Encoding() {
    my $self = shift;
    my ($str, $encoding, $toEncoding) = @_;
    my $output;
    if(!defined($str) || !defined($encoding) || !defined($toEncoding)) {
        return undef;
    }

    my $needChange = &needChange($self, $encoding);
    if(!defined($needChange)) {
        return undef;
    }

    if($needChange eq "n") {
        return $str;
    } else {
        if($toEncoding eq ENCODING_UTF8_NEC_JP) {
            $output = &changeEncoding($self, $str, ENCODING_UTF_8, ENCODING_UTF8_NEC_JP);
        } elsif($toEncoding eq ENCODING_UTF_8) {
            $output = &changeEncoding($self, $str, ENCODING_UTF8_NEC_JP, ENCODING_UTF_8);
        } else {
            return undef;
        }
    }
    return $output;
}

##Function : need change encoding or not
##  when encoding is not UTF8-NEC-JP(UTF8-MAC), don't need change encoding.
##  when encoding is not UTF8-NEC-JP(UTF8-MAC), and machine type is Procyon or later,
##    need change encoding.
##  when encoding is not UTF8-NEC-JP(UTF8-MAC), and machine type is Callisto(NVx300), 
##    and RPQ_0001=on, need change encoding.
##  other, don't need change encoding.
##Input : 
##        encoding, export group's encoding.
##Output:
##        "y" : need change encoding
##        "n" : do not need change encoding
##      undef : get machine type failed.
sub needChange() {
    use NS::RPQLicenseNo;
    use NS::NsguiCommon;
    my $RPQ_No = new NS::RPQLicenseNo;
    my $nsguiCommon = new NS::NsguiCommon;

    my ($self, $encoding) = @_;
    if($encoding ne ENCODING_UTF8_NEC_JP) {
        return "n";
    }
    my $procyonOrLater = $nsguiCommon->isProcyonOrLater();
    if(!defined($procyonOrLater)) {
        return undef;
    } elsif($procyonOrLater) {
        return "y";
    } else {
        my $isLicenseExist = $nsguiCommon->checkRPQLicense($RPQ_No->RPQLICENSENO_UTF8);
        if($isLicenseExist == 0) {
            return "y";
        }
    }
    return "n";
}
1;