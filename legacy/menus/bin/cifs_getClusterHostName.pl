#!/usr/bin/perl
#
#       Copyright (c) 2001~2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getClusterHostName.pl,v 1.2301 2008/02/26 09:07:37 zhangjun Exp $"

use NS::ClusterStatus;
my $cs = new NS::ClusterStatus;
if (scalar(@ARGV) != 0) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $nodeID="";
my $nodeNetbios="";

my @content = ();
if( $cs->isCluster() ){
    @content = `cat /etc/nascluster.conf`;
}
if (defined(@content) && scalar(@content)>0){
    foreach $thisLine (@content) {
        if ($thisLine=~/^\s*MYNODE\s*=\s*(\S+)\s*$/i) {
            $nodeID = $1;
            last;
        }
    }   
    foreach $thisLine (@content){
        if ($thisLine=~/^\s*NODE${nodeID}\s*=\s*(\S+)\s*$/i) {
                $nodeNetbios = $1;
                last;         
        }
    }
}
print "$nodeNetbios\n";

exit (0);


