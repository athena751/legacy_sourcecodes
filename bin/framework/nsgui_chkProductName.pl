#!/usr/bin/perl -w
#       Copyright (c) 2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nsgui_chkProductName.pl,v 1.1 2009/04/10 09:22:41 liul Exp $"

#Function:      check if checknode works normally
#Arguments:     none.
#exit code:
    #0: normal
    #1: abnormal
#output:
    #normal:
        #line1: "normal"
    #abnormal
        #line1: "abnormal"
        #line2: checknode's exitcode
        #line3: Product Name

use strict;
my $cmd = "/usr/sbin/checknode --hwid >/dev/null 2>&1";
my $ret = system("$cmd");
$ret = $ret >> 8;

if ($ret == 0){
    print "normal\n";
    exit 0;
}else{
    my $product_name="";
    if( ($ret == 3) || ($ret == 11) ){
        my @content=`cat /proc/smbios/type1`;
        foreach(@content){
            if($_ =~ /^  Product Name : iStorage (NV.*)$/){
                $product_name=$1;
                last;
            }
        }
    }
    print "abnormal\n";
    print "$ret\n";
    print "$product_name\n";
    exit 1;
}

