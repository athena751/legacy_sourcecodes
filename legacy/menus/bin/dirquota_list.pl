#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: dirquota_list.pl,v 1.2310 2007/02/27 12:45:28 zhangjun Exp $"

use strict;
use NS::CodeConvert;

my $cc = new NS::CodeConvert();
if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $path=shift;
my @list=`/opt/nec/nsadmin/bin/dirquota_dolist.pl \Q$path\E`;
if ($?!=0){
    exit 1;
}
my @hexList= ();
foreach(@list){
    if(/^((\S+\s+){10})(.*)$/){
        push @hexList,join(" ",$1,$cc->str2hex($3)."\n");
    }
}
print @hexList;
