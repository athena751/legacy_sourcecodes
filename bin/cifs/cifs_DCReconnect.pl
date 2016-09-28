#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_DCReconnect.pl,v 1.2 2006/05/12 09:21:59 fengmh Exp $"

use strict;
use NS::CIFSConst;

my $const = new NS::CIFSConst;

my $dc_reConnect = $const->COMMAND_DC_RECONNECT;
my $dc_command_path = $const->COMMAND_DC_PATH;

if(system("$dc_command_path$dc_reConnect 2>/dev/null") != 0) {
    exit 1;
}
exit 0;

