#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ethguard_getVersionInfo.pl,v 1.4 2004/08/09 09:46:24 maojb Exp $"

use strict;
use NS::EthguardCommon;

my $common = new NS::EthguardCommon;
my $confFile = $common->FILE_TOMCAT_CONF;
my $nsgui_title = $common->VERSION_TYPE_ABROAD;
if(open(TMPFILE,$confFile)){
    foreach(<TMPFILE>){
        if(/^\s*NSGUI_TITLE\s*=\s*(\w+)\s*$/){
            $nsgui_title = $1;
            last;
        }
    }
    close(TMPFILE);
}
print "$nsgui_title\n";
exit 0;