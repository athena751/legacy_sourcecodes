#!/usr/bin/perl
#
#       Copyright (c) 2003 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_replace.pl,v 1.1 2004/11/22 10:58:12 maojb Exp $"
use strict;
my $str = shift;
$str =~ s/\\-/-/g;
print "$str\n";
exit 0;