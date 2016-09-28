#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nsgui_getMachineSeries.pl,v 1.1 2007/06/28 01:02:17 liul Exp $"

my $cmd="/usr/sbin/checknode --hwid 2>/dev/null";
my $hwid=`$cmd`;
if($?==0){
    if($hwid >= 400){
        print "Procyon\n";
    }else{
        print "Callisto\n";
    }
}else{
    print "errorMachineSeries\n";
}

exit 0;
