#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk_getdiskarraytype.pl,v 1.1 2007/09/07 09:21:31 liq Exp $"

#Function:      get diskarray type
#Parameters:    --
#
#Exit:          0 -- successful  
#               1 -- failed
#Output
# S1500/D1/D3

use strict;
use NS::VolumeConst;
my $volumeConst  = new NS::VolumeConst;
my @diskinfo=`/opt/nec/nsadmin/sbin/iSAdisklist -d`;
if ($? !=0){
    print "--\n";
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_ISADISKLIST);
    exit 1;
}
#Array_ID Disk_Array Array_Type State Observation SAA WWNN
my $diskarraytype="";
foreach(@diskinfo){
    if ($_=~/^\s*([0-9]{4})\s+\S+\s+([0-9A-Fa-f]{2}h)\s+/){
        $diskarraytype=$2;
        last;
    }
}

if ($diskarraytype eq "05h") { 
    print "S1500\n";
}elsif ($diskarraytype eq "04h"){ 
    print "S1400\n";
}elsif ($diskarraytype eq "80h"){
    print "D1\n";
}elsif ($diskarraytype eq "81h"){
    print "D3\n";
}else{
    print "--\n";
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_ISADISKLIST);
    exit 1;
}

exit 0;