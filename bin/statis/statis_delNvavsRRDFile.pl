#!/usr/bin/perl
#
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: statis_delNvavsRRDFile.pl,v 1.2 2008/07/02 06:27:09 yangxj Exp $"

# parameter: cpName
#
# Sometimes the exit code is not correct. Please ignore it.
#

use strict;
use NS::NsguiCommon;
use NS::ClusterStatus;

my $LOCAL_DELETE_SCRIPT = "/opt/nec/nsadmin/bin/statis_localDelNvavsRRDFile.pl";

if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $cpName = shift;
# Prepare
my $nsgui = new NS::NsguiCommon;
my $cs = new NS::ClusterStatus;

my $localExitCode = 0;

#first: call statis_localDelNvavsRRDFile.pl on my node
`sudo $LOCAL_DELETE_SCRIPT $cpName`;
if ($? != 0){
    print STDERR "Execute statis_localDelNvavsRRDFile.pl on local node is failed.\n";
    $localExitCode = 1;
}

# if cluster, need to call on friend node
# if single, none to do
if($cs->isCluster()){
    #is cluster
    #second: call on friend node
    my $friendAddr = $nsgui->getFriendIP();
    if(defined($friendAddr)){
        my $isActive = $nsgui->isActive($friendAddr);
        if($isActive == 0){
            # Friend node is active.
            `sudo -u nsgui /usr/bin/rsh $friendAddr sudo $LOCAL_DELETE_SCRIPT $cpName`;
        }else{
            print STDERR "Partner node is not actived.\n";
            exit 1;
        }
    }else{
        print STDERR "Failed to get the IP of the partner node.\n";
        exit 1;
    }
}
exit $localExitCode;
