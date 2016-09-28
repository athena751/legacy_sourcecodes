#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nashead_ddLocalScan.pl,v 1.2 2006/05/26 01:22:06 jiangfx Exp $"

use strict;
use NS::NasHeadConst;

my $const =  new NS::NasHeadConst;

my $rescan_cmd_nooutput = $const->CMD_RESCANDD;

if (system("sudo $rescan_cmd_nooutput")!=0){
    print STDERR "Failed to execute:$rescan_cmd_nooutput. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

exit 0;