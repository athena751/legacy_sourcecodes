#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getIpInfo.pl,v 1.2303 2005/09/07 01:56:29 liq Exp $"

use strict;
#use NS::NDMPCommon;

#my $comm    = new NS::NDMPCommon;
#my $arrayRef  = $comm->getUpIPList();
#my @result = @$arrayRef;
#print the available IP address and the corresponding NIC name
#if(defined(@result) && scalar(@result)>0){
    #do not print out the eth0
#    for(my $index = 0; $index < @result; $index += 2){
#        if($result[$index + 1] !~ /^eth0/){
#            print "$result[$index]\n$result[$index+1]\n";
#        }
#    }
#}
use NS::NicCommon;
my $com = new NS::NicCommon;
#get service ip
my $ap = $com->getInterfaces("-s");
my @result;
if (defined($ap)){
    @result= @$ap;
}
#result : name[]UP[]IP[]B[]MAC[]MTU
#[]==space

if (defined(@result) && scalar(@result)>0){
    foreach(@result){
        if ($_=~/^\s*(\S+)\s+UP\s+([\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3})\/\d+\s+/){
            print "$2\n$1\n";
        }
    }
}

exit 0;