#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: dirquota_dolist.pl,v 1.2 2007/06/28 01:33:51 liul Exp $"

use strict;

use NS::CodeConvert;
use NS::NsguiCommon;
use NS::USERDBCommon;
use NS::RPQLicenseNo;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
my $RPQ_No       = new NS::RPQLicenseNo;
my $cc           =new NS::CodeConvert();

my $path = shift;
$path=$cc->hex2str($path);
if (!$path){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########add by zhangjun
$path =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$path = $cc->changeUTF8Encoding($path, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($path) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########
my $isProcyonOrLater = $nsguicommon->isProcyonOrLater();
if(!defined($isProcyonOrLater)){
    print STDERR "Failed to get the machine series. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if (!(-d $path)){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    print STDERR $!," : ",$path,".\n";
    exit 1;
}

my @all=`ls -l  '--time-style=+%a %b %d %H:%M:%S %G' \Q$path\E |grep ^d`;
if ($?!=0){
    #print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 0;
}

my $directory=$path."/";
my @mount = `mount |grep \Q$directory\E`;

my $first=&removeMP(\@all,\@mount);

my $RPQ = $nsguicommon->checkRPQLicense($RPQ_No->RPQLICENSENO_UTF8);
my $RPQ_SJIS = $nsguicommon->checkRPQLicense($RPQ_No->RPQLICENSENO_SJIS);

my @second=();
foreach(@$first){
    my $single=$_;
    my $tmp_sub;
    if($single=~/^(\S+\s+){9}\S+\s(.*)$/){
        $tmp_sub = $2;
    }else{
        next;
    }
    if($tmp_sub=~/\s+/){
        next;
    }
    if( ( $isProcyonOrLater && ( $encoding ne "CP437" ) ) || 
            ( $RPQ==0 && ( $encoding eq "UTF8-NEC-JP" || $encoding eq "UTF-8" ) ) || 
            ( $RPQ_SJIS==0 && $encoding eq "SJIS-NEC-JP" ) ){
    }else{                
        if($tmp_sub=~/[^\000-\177]/){
            next;
        }
    }
    
    my $subpath=$path."/".$tmp_sub;
    my @subAll=`ls -l  '--time-style=+%a %b %d %H:%M:%S %G' \Q$subpath\E`;

    my $dirno=0;
    my $japanno=0;
    my $fileno=0;
    my $mpno=0;

    foreach(@subAll){
        if(&checkMP($subpath."/".$_,\@mount)==1){
            $mpno=$mpno+1;
            next;
        }

        if(/^d.*$/){
            $dirno=$dirno+1;
        }

        if( (/^-.*$/)||(/^l.*$/) ){
            $fileno=$fileno+1;
            next;
        }
    }

    my @back=split(/\s+/,$single);

    if($dirno>0){
        $back[1]="enter";
    }elsif($dirno==0 && $fileno>0){
        $back[1]="notsel";
    }elsif($dirno==0 && $mpno>0){
        $back[1]="notsel";
    }elsif($dirno==0 && $japanno>0){
        $back[1]="notsel";
    }elsif($dirno==0 && $fileno==0 && $mpno==0 && $japanno==0){
        $back[1]="sel";
    }
    push @second,join(" ",$back[0],$back[1],$back[2],$back[3],$back[4],$back[5],$back[6],$back[7],$back[8],$back[9],$tmp_sub)."\n";
}

if( ((!$isProcyonOrLater) && ($RPQ!=0)) || $encoding ne $cc->ENCODING_UTF8_NEC_JP ){
    print @second;
}else{
    open(ICONV, "| /home/nsadmin/bin/nsgui_iconv.pl -f UTF8-NEC-JP -t UTF-8") or die ("cannot pipe to iconv: $!\n");
    print ICONV @second;
    close(ICONV);
}
exit 0;

sub removeMP(){
    my $all=shift;
    my $mount=shift;
    my @pick=();

    foreach(@$all){
        my $single=$_;
        my $flag=1;

        if(/^d.*$/){
            foreach(@$mount){
                if( $path."/".(split(/\s+/,$single))[10] eq (split(/\s+/,$_))[2]){
                    $flag=0;
                    last;
                }
            }
        }

        if($flag==1){
            push @pick,$single;
        }
    }
    return \@pick;
}

sub checkMP(){
    my $single=shift;
    my $mount=shift;
    my $flag=0;

    foreach(@$mount){
        if( $single eq (split(/\s+/,$_))[2]){
            $flag=1;
            last;
        }
    }

    return $flag;
}
