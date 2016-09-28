#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_deleteOneFile.pl,v 1.2 2006/05/12 09:22:19 fengmh Exp $"

use strict;
my $fileForDelete = shift;
system("/bin/rm -f $fileForDelete");
exit $?/256;