#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: serverprotect_getDaemonState.pl,v 1.3 2007/04/02 07:02:39 liul Exp $"
#Function:
    #get daemon status of the specified export group
#Arguments:
    #$nodeNum          : the group number 0 or 1
    #$computerName     : the Computer Name
#exit code:
    #0 ----    :success(Here we take unexpected error as active status.)
    #1 ----    :PARAMETER ERROR
#output:
    #active         :the daemon is active
    #inactive       :the daemon is inactive


use strict;
if(scalar(@ARGV)!=2){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my ($nodeNum,$computerName) = @ARGV;
my $ret=system("/opt/nec/nvavs/bin/nvavs_daemon_ctl -l -g $nodeNum -n \Q$computerName\E >& /dev/null");
$ret=$ret>>8;

if($ret==100 || $ret==101 || $ret==102){
    print "inactive\n";
}else{
    print "active\n";
}

exit 0;
