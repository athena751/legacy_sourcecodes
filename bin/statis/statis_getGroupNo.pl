#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_getGroupNo.pl,v 1.1 2005/10/18 16:21:14 het Exp $"

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
my $hostname = shift;

my $conffile = $const->NASCLUSTER_CONF;
my @content = `cat $conffile`;
my $groupNo = 0;

foreach(@content){
    chomp;
    if(/^\s*#/){
        next;
    }
    if(/^\s*NODE0\s*=\s*(\S+)$/){
        if($1 eq $hostname){
            $groupNo = 0;
        }
    }elsif(/^\s*NODE1\s*=\s*(\S+)$/){
        if($1 eq $hostname){
            $groupNo = 1;
        }
    }
}

print "${groupNo}\n\n";

exit 0;