#!/usr/bin/perl
#copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_getignorelist.pl,v 1.2 2007/08/28 04:58:31 chenbc Exp $"
#Function :
    #use command(linkdown_ctl status) to get ignorelist.
#Arguments: --
#exit code:
    #0:succeed 
    #1:error
    #2:known error
#output:
   #xx,xx
use strict;

my $command="/usr/sbin/linkdown_ctl status 2>/dev/null";
my @linkdowninfo=`$command`;
my $errorcode=$?/256;
if ($errorcode==0){
    foreach (@linkdowninfo){
        if (/^\s*ignore\s+interface\(s\)\s*:\s*(\S+)\s*$/){
            print "$1\n";
        }
    }
}
exit 0;
