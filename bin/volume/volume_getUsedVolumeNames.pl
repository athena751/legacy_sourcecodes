#!/usr/bin/perl -w

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: volume_getUsedVolumeNames.pl,v 1.1 2004/08/30 10:09:08 caoyh Exp $"

use strict;

use NS::VolumeCommon;
use NS::VolumeConst;


my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

my $allLvName = $volumeCommon->getAllLvName();

if(defined($$allLvName{$volumeConst->ERR_FLAG})){
    $volumeConst->printErrMsg($$allLvName{$volumeConst->ERR_FLAG});
    exit 1;
}

foreach(keys(%$allLvName)){
    print $_."\n";
}

## successful
exit 0;
