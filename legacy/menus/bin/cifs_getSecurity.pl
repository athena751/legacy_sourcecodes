#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getSecurity.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

use NS::CIFSCommon;
use strict;

    if(scalar(@ARGV)!=4){
        print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
        exit(1);
    }
    my ($etcPath,$globalDomain,$localDomain,$NetBios)=@ARGV;
    my $cifs=new NS::CIFSCommon;
    my $security="";
    my $filename=$cifs->getSmbOrVsName($etcPath,$globalDomain,$localDomain,$NetBios,0);
    if(!$filename){
        print STDERR "Can't get file name by global Domain:$globalDomain,local Domain:$localDomain,netBios:$NetBios. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    if (-e $filename) {
        my @content = `cat $filename`;
        foreach my $line(@content) {
            if ($line =~/^\s*security\s*=\s*(\S+)\s*$/i) {
                $security = $1;
                last;
            }
        }
    }
 print "$security\n";
 exit (0);