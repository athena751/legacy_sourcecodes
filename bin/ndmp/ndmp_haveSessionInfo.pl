#!/usr/bin/perl
#    copyright (c) 2006 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_haveSessionInfo.pl,v 1.1 2006/12/26 01:14:00 qim Exp $"
use strict;
use NS::NDMPCommonV4;
my $common  = new NS::NDMPCommonV4;
if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR\n";
    exit 1;
}
my $sessionFileDir = ${ARGV[0]};
$sessionFileDir=~ s/\/*$/\//;
my @fNameArray = `ls -l $sessionFileDir 2>/dev/null | awk '{ if(\$1 ~/^-/)print \$9;}'`;
foreach(@fNameArray){
    my $fName = $sessionFileDir.$_;
    open(FILE, $fName);
    my @filecontent = <FILE>;
    close(FILE);
    my $sessionid = $common->getKeyValue("SESSION_ID",\@filecontent);
    if(defined($sessionid)){
       print "true\n";
       exit 0;
    }
}
print "false\n";
exit 0;
