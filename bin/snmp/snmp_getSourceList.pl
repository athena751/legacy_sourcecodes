#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_getSourceList.pl,v 1.1 2005/08/21 04:53:28 zhangj Exp $"

use strict;
use NS::NsguiCommon;
use NS::SNMPCommon;

my $nsguicommon  = new NS::NsguiCommon;
my $snmpCommon = new NS::SNMPCommon;

my $failed = $snmpCommon->getSourceList();
if($failed){
    print STDERR $snmpCommon->error();
    $nsguicommon->writeErrMsg("",__FILE__,__LINE__+1);
     exit 1;
}

exit 0;