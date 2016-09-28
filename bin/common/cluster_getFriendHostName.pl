#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: cluster_getFriendHostName.pl,v 1.1 2008/02/25 06:20:06 wanghui Exp $"

# Function:
#       Get Host Name of NV for cluster and single node.
# Parameters:
#
# output:
#       $FriendHostName
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;

if (scalar(@ARGV) != 0) {
    print STDERR "The parameters' number of perl script:",__FILE__," is wrong!\n";
    exit(1);
}
my $FriendHostName="";
my $thisLine;
my @content = `cat /etc/nascluster.conf`;

if ( scalar(@content)>0 ){
    my $MyNodeNo;
    my $FriendNodeNo;
    foreach (@content) {
        if (/^\s*MYNODE\s*=\s*(\S+)\s*$/i) {
            $MyNodeNo = $1;
            last;
        }
    }
    $FriendNodeNo = 1 - $MyNodeNo;
    foreach (@content){
        if (/^\s*NODE${FriendNodeNo}\s*=\s*([\w][\w\-]*)\s*$/i) {
            $FriendHostName = $1;
            last;
        }
    }
}
print "$FriendHostName\n";
exit (0);
