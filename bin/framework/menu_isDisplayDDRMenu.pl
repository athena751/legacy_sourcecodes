#!/usr/bin/perl -w
#       Copyright (c) 2008-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: menu_isDisplayDDRMenu.pl,v 1.2 2009/03/30 03:38:42 lil Exp $"

# function:
#       check whether ddr menu display
# Parameters:
#       none
# output:
#        yes:   display the ddr menu
#        no:    don't display the ddr menu

use strict;

my $hwid = `/opt/nec/nsadmin/bin/nsgui_getHWID.sh`;
if($? != 0) {
    exit 1;
}
chomp $hwid;
if($hwid == 410 || $hwid == 411 || $hwid == 412 
    || $hwid == 420 || $hwid == 421 || $hwid == 422 || $hwid == 425 
    || $hwid == 510 || $hwid == 511 || $hwid == 512 
    || $hwid == 520 || $hwid == 521 || $hwid == 522 ){
    print "yes\n";
}else{
    print "no\n";
}
exit 0;
