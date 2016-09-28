#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_hasExport.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

use NS::CIFSCommon;
use NS::CodeConvert;
use strict;

    if(scalar(@ARGV)!=5){
        print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
        exit(1);
    }
    my ($etcPath,$globalDomain,$localDomain,$NetBios,$mp)=@ARGV;
    my $cifs=new NS::CIFSCommon;
    my $filename=$cifs->getSmbOrVsName($etcPath,$globalDomain,$localDomain,$NetBios,0);
    if(!$filename){
        print STDERR "can't get file name by global Domain:$globalDomain,local Domain:$localDomain,netBios:$NetBios. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }

    my $exitFlag=0;
    $filename=&trim($filename);
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
    my $convert=new NS::CodeConvert;
    $mp = $convert->hex2str($mp);
    my $line;
    my $index = 0;

    while ( $index<scalar(@content) ){
        $line=$content[$index];
        $line=&trim($line);
        if($line!~/^\s*\[\s*\S+.*\]\s*$/i || $line=~/^\s*\[\s*global\s*\]\s*/i || $line=~/^\s*\[\s*printers\s*\]\s*/i || $line=~/^\s*\[\s*homes\s*\]\s*/i){
            $index++;
            next;
        }
        for ($index++; $index<scalar(@content) && $content[$index]!~/^\s*\[\s*\S+.*\]\s*$/i; $index++) {
            $line = $content[$index];
            $line = &trim($line);
            if ($line=~/^\s*path\s*=\s*(.+)\s*$/i) {
                my $path = $1;
                if ($path eq $mp){
                    print "true\n";
                    exit 0;
                }elsif ( $path=~/^${mp}\/.*$/ ){
                    print "true\n";
                    exit 0;
                }
            }
        }
    }
    exit(0);

sub trim(){
    my $str=shift;
    $str=~s/^\s*//;
    $str=~s/\s*$//;
    return $str;
}
