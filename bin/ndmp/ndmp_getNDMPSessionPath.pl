#!/usr/bin/perl
#    copyright (c) 2006 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_getNDMPSessionPath.pl,v 1.2 2006/10/09 01:26:18 qim Exp $"
use strict;
use NS::NDMPCommonV4;
my $common  = new NS::NDMPCommonV4;
if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR\n";
    exit 1;
}
my $groupNum = ${ARGV[0]};
my $confFile = $common->getNDMPConfFilePath($groupNum);
open(FILE, $confFile);
my @content = <FILE>;
close(FILE);
my $sessionFileDir = $common->getKeyValue("ADMIN_DATA",\@content);
if((!defined($sessionFileDir))||($sessionFileDir eq "")){
    print STDERR "SESSION FILE PATH UNDEFINE\n";
    exit 1;
}
$sessionFileDir=~ s/\/*$/\//;
print $sessionFileDir."\n";
exit 0;