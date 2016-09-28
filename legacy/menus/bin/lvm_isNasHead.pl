#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lvm_isNasHead.pl,v 1.2301 2004/11/12 03:41:28 liuyq Exp $"

##fuctions:
	##to check this node is "iStorageG node"
##parameter:
	##none
##return value:
	##0:This script excutes successfully
	##not 0:When this script is excetuing,some errors occur;
##output:
	##TRUE:This node is "iStorageG node" 
	##FALSE:This node is not "iStorageG node"

use strict;
use NS::NsguiCommon;

my $nsguiCommon = new NS::NsguiCommon;
my $MSG_TRUE = "TRUE";
my $MSG_FALSE = "FALSE";

my $isNashead = $nsguiCommon->isNashead();
if($isNashead){
    print ${MSG_TRUE}."\n";
}else{
    print ${MSG_FALSE}."\n";
}
exit 0;