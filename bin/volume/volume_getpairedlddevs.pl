#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_getpairedlddevs.pl,v 1.1 2008/05/24 12:09:14 liuyq Exp $"

#Function:      
#               get paired lds 
#Parameters:    
#               none
#Exit:          
#               0 -- successful  
#Output
#               $lddev ---- ld dev path. eg /dev/ld16
use strict;
use NS::DdrCommon;

my $ddrCommon = new NS::DdrCommon;

my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds(); 
my $pairedLddevsHasH = {%$mvLdHash, %$rvLdHash};
foreach(sort keys(%$pairedLddevsHasH)){
    print $_."\n";
}

exit 0;