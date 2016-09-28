#!/usr/bin/perl -w
#    Copyright (c) 2006 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: hosts_readFile.pl,v 1.1 2006/05/19 05:11:32 qim Exp $"
#Function:
    #get the hosts setting info;
#Arguments:
    #node
#exit code:
    #0:succeeded
    #1:failed
#output:
    #the hosts setting.
use strict;
use NS::HostsCommon;
my $comm  = new NS::HostsCommon;
my $hosts_File = $comm->HOSTS_CONFIG;
 
if(!-f $hosts_File){
   system("touch",${hosts_File});
}

my $dispFileContent = $comm->getNotNVInfo();
print STDOUT @$dispFileContent;
exit 0;