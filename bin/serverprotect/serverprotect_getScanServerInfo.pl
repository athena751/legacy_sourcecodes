#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: serverprotect_getScanServerInfo.pl,v 1.1 2007/02/12 08:58:45 qim Exp $"
#Function: 
    #get the scan server information for displaying in setting page.
    #the scan server list information includes [scanServer],[interface].
#Arguments: 
    #$nodeNum          : the group number 0 or 1
    #$computerName     : the Computer Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #----------------------------------------------------------
    #|STDOUT Content         | Line Number (n=0,1,2,3,4...32)|
    #----------------------------------------------------------
    #|host=<$scanServer>     |  5*n + 1
    #|port=<>                |  5*n + 2
    #|multiple=<>            |  5*n + 3
    #|interfaces=<$interface>|  5*n + 4
    #|connectStatus=<>       |  5*n + 5
    
    #------------------------------------------------------
use strict;
use NS::ServerProtectCommon;
my $SPCommon  = new NS::ServerProtectCommon;
if(scalar(@ARGV)!=2){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNum,$computerName) = @ARGV;
my $SPConfFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
if (!(-f $SPConfFile) || !(-s $SPConfFile)) {
    exit 0;
}
open(FILE, $SPConfFile);
my @content = <FILE>;
close(FILE);
my @ScanServerInfo = $SPCommon->getScanServerInfo(\@content);
print @ScanServerInfo;
exit 0;