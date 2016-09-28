#!/usr/bin/perl
#
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: mapd_hasspecifiedallip.pl,v 1.1 2004/11/12 02:36:23 caoyh Exp $"

#    Function: Check the ims_native command's output , if has such style "NS=/", return true
#              or return false;
#    Parameter:
#            myNodeNum         ----- my node number 0 or 1.   
#
#    Return value: 
#           If has , print true;
#           else , print false;
use strict;

if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $myNodeNum = shift; #0/1
my $imsFile = "/etc/group".$myNodeNum."/ims.conf";
my @allIpDomain = `/usr/bin/ims_native -L -c $imsFile`;
my @foundlist = grep(/\s*NS=\/\s+/, @allIpDomain);
if (scalar(@foundlist) > 0){
    print "true\n";
}else{
    print "false\n";
}
exit 0;