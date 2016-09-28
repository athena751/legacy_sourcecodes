#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cluster_getMyNodeNumber.pl,v 1.1 2008/02/25 06:20:06 wanghui Exp"

# Function:
#       Get my node number from /etc/nascluster.conf(MYNODE=[0|1]).
#       Create for CsarGUI.
#       CsarGUI use the perl from FIP node , so the STDERR info is "can not get FIP node number"
#       If other module use it, maybe the message is not fitful.
# output:
#       $MyNodeNo  0|1
# Return value:
#       0: successfully exit;
#       1: parameters error ;

use strict;

if (scalar(@ARGV) != 0) {
    print STDERR "The parameters' number of perl script:",__FILE__," is wrong!\n";
    exit(1);
}
my $MyNodeNo="";
my @content = `cat /etc/nascluster.conf`;

if ( scalar(@content)>0 ){
    foreach (@content) {
        if (/^\s*MYNODE\s*=\s*(\d+)\s*$/i) {
            $MyNodeNo = $1;
            last;
        }
    }
}
if ($MyNodeNo eq ""){
    print STDERR "Failed to get FIP node number in perl script(",__FILE__,")\n";
    exit(1);
}
print "$MyNodeNo\n";
exit (0);
