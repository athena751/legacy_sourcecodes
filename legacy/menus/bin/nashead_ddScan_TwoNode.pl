#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nashead_ddScan_TwoNode.pl,v 1.2 2004/11/12 03:44:12 liuyq Exp $"

use strict;
use NS::NasHeadCommon;
use NS::NasHeadConst;

my $nasHeadCommon = new NS::NasHeadCommon;
my $const =  new NS::NasHeadConst;
my $home = $ENV{HOME} || "/home/nsadmin";

my $localScan_pl = $const->PL_DDLOCALSCAN_PL;
if (system("sudo ${home}/bin/$localScan_pl") != 0){
    print STDERR "Failed to execute:${home}/bin/$localScan_pl. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

### deal in friend node when cluster case
my $friendIp = $nasHeadCommon->getFriendIP();
if (defined($friendIp) && ($friendIp ne "")){
    if($nasHeadCommon->isActive($friendIp) == 1){
        print STDERR "The friend node is not active. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    
    #execute in friend node
    my $remoteScan_pl = $const->PL_DDREMOTESCAN_PL;
    system("sudo ${home}/bin/$remoteScan_pl $friendIp &");
}

exit 0;