#!/usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_getFriendFTPService.pl,v 1.1 2008/12/23 03:11:27 gaozf Exp $"

use strict;
use NS::FTPCommon;
if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $nodeNo         = shift;
my $groupNo        = shift;
my $proftpd_conf   = "/etc/group".$nodeNo.".setupinfo/ftpd/proftpd.conf.${groupNo}";

my $bUseFTPService = "no"; 
my $ftpComm    = new NS::FTPCommon;

my $content        = $ftpComm->readFile($proftpd_conf);
my $count          = 0;
for($count=0;$count<scalar(@$content);$count++){
    if($$content[$count] =~ /^\s*ftp\s+(yes|no)/){
        $bUseFTPService = $1;
        }
}
print $bUseFTPService."\n";
exit 0;
