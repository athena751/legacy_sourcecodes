#!/usr/bin/perl -w
#
#       Copyright (c) 2007~2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_getHostName.pl,v 1.2 2008/02/26 09:05:40 zhangjun Exp $"

# Function:
#       Get Host Name of NV for cluster and single node.
# Parameters:
#
# output:
#       @hostname
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::ClusterStatus;

if (scalar(@ARGV) != 0) {
    print STDERR "The parameters' number of perl script:",__FILE__," is wrong!\n";
    exit(1);
}

my $nascluster_conf="/etc/nascluster.conf";
my @hostname=();
my $cs = new NS::ClusterStatus;
if( ! $cs->isCluster() ){
    my $cmd="/bin/hostname";
    my $hostname_single=`$cmd -s 2>/dev/null`;
    if($? == 0 && $hostname_single ne ""){
        chomp($hostname_single);
        $hostname[0] = uc($hostname_single)."\n";
    }
}else{
    if ( -f $nascluster_conf ){
        my @content = `cat $nascluster_conf 2>/dev/null`;
        if ($? == 0 && scalar(@content) != 0){
            foreach(@content) {
                if ($_ =~ /^\s*(NODE0|NODE1)\s*=\s*([\w][\w\-]*)\s*$/){
                    my $hostname_cluster = uc($2)."\n";
                    push (@hostname,$hostname_cluster);
                }

            }
        }
    }
}
print @hostname;
exit 0;
