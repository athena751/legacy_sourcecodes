#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_recoveryConf.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
my $tmp_main0 = "/tmp/main0.conf";
my $tmp_main1 = "/tmp/main1.conf";
my $tmp_virtual0 = "/tmp/virtual0.conf";
my $tmp_virtual1 = "/tmp/virtual1.conf";
my $tmp_main0_bak = "/tmp/main0.conf.bak";
my $tmp_main1_bak = "/tmp/main1.conf.bak";
my $tmp_virtual0_bak = "/tmp/virtual0.conf.bak";
my $tmp_virtual1_bak = "/tmp/virtual1.conf.bak";

if( -f $tmp_main0_bak ){
    `cp -f $tmp_main0_bak $tmp_main0 >& /dev/null`;
}

if( -f $tmp_main1_bak ){
    `cp -f $tmp_main1_bak $tmp_main1 >& /dev/null`;
}

if( -f $tmp_virtual0_bak ){
    `cp -f $tmp_virtual0_bak $tmp_virtual0 >& /dev/null`;
}

if( -f $tmp_virtual1_bak ){
    `cp -f $tmp_virtual1_bak $tmp_virtual1 >& /dev/null`;
}


exit 0;
