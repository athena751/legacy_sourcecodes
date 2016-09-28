#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: menu_postlogin.pl,v 1.1 2008/03/21 10:34:01 zhangjun Exp $"

use strict;

my $postLoginFile="/opt/nec/nsadmin/bin/nsgui_postlogin.sh";
if(-f $postLoginFile){
    system("sudo $postLoginFile 2>/dev/null 1>&2");
}
exit 0;
