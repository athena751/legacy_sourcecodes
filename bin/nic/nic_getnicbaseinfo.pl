#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getnicbaseinfo.pl,v 1.2 2005/09/26 02:48:59 dengyp Exp $"
#
#Function
                #to get all the interface's basic information.
#Output:
                #Output example
        #    ge1080     DOWN    11.11.11.11/8       11.255.255.255  00:00:4c:b9:29:6c 1500
        #    bond0      UP      172.28.11.201/25    172.28.11.255   00:00:4c:b9:29:6b 1500
        #    bond1      UP      192.168.245.1/24    192.168.245.255 00:03:47:72:2d:1c 1500
        #    bond1.2    DOWN    195.6.2.1/24        195.6.2.255     00:03:47:72:2d:1c 1500
        #    bond1.3    DOWN    --                  --              00:03:47:72:2d:1c 1500
        #    bond1.40   DOWN    --                  --              00:03:47:72:2d:1c 1500

#Parameters: none
#Returns:
                #0: successful
                #1:failure

use strict;
use constant ERRCODE_INTERFACES_CANNOTGET        => "0x18A00013";
use NS::NicCommon;
use NS::NsguiCommon;

my $nic_common = new NS::NicCommon;
my $nsgui_common = new NS::NsguiCommon;

#get the interface names.
my $nicInfo = $nic_common->getInterfaces(@ARGV);
if(!defined($nicInfo)){
                $nsgui_common->writeErrMsg(ERRCODE_INTERFACES_CANNOTGET, __FILE__, __LINE__+1);
                exit 1;
}
print @$nicInfo;

exit 0;
