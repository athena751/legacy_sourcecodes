#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
# 
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
 
# "@(#) $Id: cluster_getGroupPosition.pl,v 1.1 2005/01/21 03:24:11 wangw Exp $"

#Function:  
#   get the group that is mounted on current machine.

#Parameters: 
#   group num: group0 or group1

#Output:
#   if cluster ,0 or 1
#   else null
#
#exit code:
#   0 -- nomal
#   1 -- error

use strict;
use NS::NsguiCommon;
my $comm = new NS::NsguiCommon;
my $groupNo = shift;
my @content = `mount 2> /dev/null`;
foreach(@content){
    if(/^\s*\S+\s+on\s+\/etc\/(group[01])\.setupinfo\s+/){
        print $1,"\n";
    }
}
exit 0;