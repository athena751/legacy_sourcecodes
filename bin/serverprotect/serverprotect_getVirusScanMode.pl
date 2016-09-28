#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: serverprotect_getVirusScanMode.pl,v 1.1 2007/02/12 01:11:42 qim Exp $"
#Function: 
    #get virus scan mode value
#Arguments: 
    #$nodeNum          : the group number 0 or 1
    #$domainName       : the domain Name
    #$computerName     : the Computer Name
#exit code:
    #0 ---- success
    #1 ---- failure
#output:
    #undefined         :undefine the key <virus scan mode>.
    #$virusScanMode    :the value of the key <virus scan mode>.
    #                   possible value:yes|no.
use strict;
use NS::ConfCommon;
use NS::CIFSCommon;
my $ConfCommon = new NS::ConfCommon;
my $CifsCommon = new NS::CIFSCommon;
if(scalar(@ARGV)!=3){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNum,$domainName,$computerName) = @ARGV;
my $cifsConfFile = $CifsCommon->getSmbFileName($nodeNum,$domainName,$computerName);
if(!(-f $cifsConfFile)){
    print "undefined\n";
    exit 0;
}
open(FILE, $cifsConfFile);
my @cifsContent = <FILE>;
close(FILE);
my $virusScanMode = $ConfCommon->getKeyValue("virus scan mode","global",\@cifsContent);
if(!defined($virusScanMode)){
    print "undefined\n";
}else{
    print $virusScanMode."\n";
}
exit 0;