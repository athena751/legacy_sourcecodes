#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: statis_getNasSwitchInfo.pl,v 1.1 2005/10/18 16:21:14 het Exp $"

# funciton: get all service group for export path or server host
# parameter: $collectionItem - collection item id
# output:
#           (when the collection item is virtual export)
#           exportpath1    servicegroup1
#           exportpath2    servicegroup2
#           exportpath3    servicegroup3
#           ...  ...
#           (when the collection item is server host)
#           serverhost1    servicegroup1
#           serverhost2    servicegroup2
#           serverhost3    servicegroup3
#           ...  ...

use strict;
use NS::NASCollector3;

my $collector3          = new NS::NASCollector3;
my $collectionItem      = shift;
my $serviceGroupHashRef = $collector3->getServiceGroupHash($collectionItem,1);
print "$_\t$$serviceGroupHashRef{$_}\n" foreach(keys(%$serviceGroupHashRef));
