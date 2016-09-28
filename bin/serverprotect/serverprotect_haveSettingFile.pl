#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: serverprotect_haveSettingFile.pl,v 1.1 2007/02/09 10:31:23 qim Exp $"
#Function: 
    #judge whether has the setting file or not.
#Arguments: 
    #$nodeNum          : the group number 0 or 1
    #$computerName     : the Computer Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #yes ---- have setting file.
    #no  ---- without setting file.
use strict;
use NS::ServerProtectCommon;
my $SPCommon  = new NS::ServerProtectCommon;
if(scalar(@ARGV)!=2){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNum,$computerName) = @ARGV;
my $SPConfFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
if(!(-f $SPConfFile)){
    print "no\n";
}else{
    print "yes\n";
}
exit 0;