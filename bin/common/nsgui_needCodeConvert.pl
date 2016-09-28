#!/usr/bin/perl
#       copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nsgui_needCodeConvert.pl,v 1.1 2007/06/29 01:06:43 yangxj Exp $"

# function:
#       Check whether needs to convert encoding.
# Parameters:
#       encoding
# output:
#       y: need to convert;
#       n: need not to convert;
# Return value:
#       0: normal;
#       1: some error occured;

use strict;
use NS::CodeConvert;

if(scalar(@ARGV)!=1){
    print STDERR " ",__FILE__,"  parameter error!\n";
    exit(1);
}

my $encoding = shift;
my $cc = new NS::CodeConvert;

my $checkResult = $cc->needChange($encoding);
if(!defined($checkResult)){
	#undef is returned.
    exit 1;
}elsif($checkResult eq "n"){
    #is not necessary to convert encoding
    print "n\n";
}elsif($checkResult eq "y"){
    #is necessary to convert encoding
    print "y\n";
}else{
    #is unknown
    exit 1;
}
exit 0;

