#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_getnisdomainlist.pl,v 1.1 2004/02/13 00:30:22 wangli Exp $"

use strict;
my @content =`cat /etc/yp.conf`;
foreach(@content){
    if ($_=~/^\s*domain\s+\S+\s+server\s+\S+\s+#FTP-/) {
        next;
    }
    if ($_=~/^\s*domain\s+(\S+)\s+server\s+\S+/) {
        if ($1 ne "localdomain"){
            print $1."\n";
        }
    }
}
exit 0;