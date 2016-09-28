#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: serverprotect_getRealTimeScanInfo.pl,v 1.3 2007/03/25 07:08:12 qim Exp $"

#Function: 
    #get real time scan information.
#Arguments: 
    #$nodeNum          : the group number 0 or 1
    #$computerName     : the Computer Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #----------------------------------------------------------
    #|STDOUT Content                       | Line Number:3     |
    #-----------------------------------------------------------
    #|extension=<$extension>               |  1
    #lludbUser=<$ludbUser1:$ludbUser2>     |  2
    #|defaultExtension=<$defaultExtension> |  3
    #-----------------------------------------------------------
use strict;
use NS::ServerProtectCommon;
use NS::ServerProtectConst;
my $SPCommon  = new NS::ServerProtectCommon;
my $SPConst = new NS::ServerProtectConst;
if(scalar(@ARGV)!=2){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNum,$computerName) = @ARGV;
my $SPConfFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
if ((-f $SPConfFile)) {
    open(FILE, $SPConfFile);
    my @content = <FILE>;
    close(FILE);
    my @realTimeScanInfo = $SPCommon->getRealTimeScanInfo(\@content);
    print @realTimeScanInfo;
}
my $defaultExtensionFile = $SPConst->DEFAULT_EXTENSION_FILE;
if(!(-f $defaultExtensionFile)){
    print STDERR "DEFAULT EXTENSION FILE NOT EXIST.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $defaultExtension = `/bin/cat $defaultExtensionFile 2>/dev/null`;
chomp($defaultExtension);
print "defaultExtension=".$defaultExtension."\n";
exit 0;
