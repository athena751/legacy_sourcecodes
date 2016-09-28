#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_getProperty.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;

use constant MAX_LIMIT => 5000; 
my $file = shift;
my $limit = MAX_LIMIT;
if(!-f $file) {
    print "$limit\n";
    exit 0;
}

if(open(IN, $file)){
    while(<IN>){
        if($_=~/^\s*DISPLAY\s*=\s*(\d+)\s*/) {
            $limit = $1;
            last;
        }
    }
    close(IN);
}

if($limit <= 0){
       $limit = MAX_LIMIT;
}
print "$limit\n";
exit 0;
 