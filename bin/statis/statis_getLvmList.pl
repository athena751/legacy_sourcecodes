#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_getLvmList.pl,v 1.2 2005/10/20 14:33:39 het Exp $"

#Function:
#   get groupNo from  /etc/nascluster.conf

#Arguments:
#   hostname

#exit code:
#   0---------succed
#   1---------failed

use strict;
use NS::NsguiCommon;
use NS::ConstForStatis;

my $comm  = new NS::NsguiCommon;
my $const = new NS::ConstForStatis;

if(scalar(@ARGV)!=1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my $groupNo = shift;

my $filename = join("",($const->ETC_GROUP,$groupNo,$const->VG_ASSIGN));
my @content = `cat $filename`;

foreach(@content){
    chomp;
    if(/^\s*#/){
        next;
    }
    if(/^\s*(\S+)\s+\S+/){
        my $rrdID = join("",("/dev/",$1,"/",$1));
        $rrdID  = $1 if($rrdID =~ /^\s*\/dev\/NV_LVM_([^\/]+)\/NV_LVM_\1\s*$/);
        print "${rrdID}\n";
    }
}

exit 0;