#!/usr/bin/perl -w
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_getRunningVersion.pl,v 1.1 2006/12/26 01:09:27 qim Exp $"

#Function:
    #get running version;
#Arguments:
    #null

#output:
    # 2:
    # 3:
    # 4:

use strict;
my $file = "/opt/nec/ndmp/ndmp_version.info";
if (!(-f $file)) {
    print "4";
} else {
    my @content = `cat $file`;
    my $versionLine = $content[0];
    if(!defined($versionLine)){
        print "4";
        exit 0;
    }
    chomp($versionLine);
    if ($versionLine =~ /^\s*2\s*$/) {
        print "2";
    } elsif($versionLine =~ /^\s*3\s*$/) {
        print "3";
    } else{
        print "4";
    }
}
exit 0;
