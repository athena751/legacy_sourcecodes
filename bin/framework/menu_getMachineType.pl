#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: menu_getMachineType.pl,v 1.1 2004/07/21 03:00:11 het Exp $"

use NS::MenuCommon;
my $const            = new NS::MenuCommon();
my $shGetMachineType = $const->SHELL_SCIRPT_GET_MACHINE_TYPE;
my $machineType      = `$shGetMachineType`;
if ($?) {
    print STDERR
      "Failed to run command $shGetMachineType. Exit in perl script:", __FILE__,
      " line:", __LINE__ + 1, ".\n";
    print $const->MACHINE_TYPE_OTHERS;
    exit 1;
}
$machineType =~ s/\s+//;
$machineType = $const->getMachineType($machineType);
if ( defined($machineType) ) {
    print $machineType;
}
else {
    print $const->MACHINE_TYPE_OTHERS;
}
exit 0;
