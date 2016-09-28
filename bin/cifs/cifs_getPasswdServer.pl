#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getPasswdServer.pl,v 1.2 2006/05/12 09:24:45 fengmh Exp $"

use strict;
use NS::NsguiCommon;
use NS::CIFSConst;
use NS::CIFSCommon;
use NS::ConfCommon;

my $comm       = new NS::NsguiCommon;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!= 3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($groupNo, $domainName, $computerName) = @ARGV;
my $smbContent = $cifsCommon->getSmbContent($groupNo, $domainName, $computerName);
my $passwdServer = $confCommon->getKeyValue("password server", "global", $smbContent);
defined($passwdServer) or $passwdServer = "";
print "$passwdServer\n";
exit 0;
