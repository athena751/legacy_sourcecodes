#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: lic_graceperiod.pl,v 1.2 2007/07/10 10:37:45 liy Exp $"

##user:
##status -- root,nsgui
##start,stop -- root

use strict;
use NS::LicenseCommon;
use NS::LicenseConst;
use NS::NsguiCommon;
use NS::Syslog;
use Getopt::Long;

my %optHash;
## get ARGS
if(!GetOptions(\%optHash,"t=s")){
    exit 2;
}
my $timeout = $optHash{'t'};
if(defined($timeout) && $timeout !~ /^\d+$/){
    exit 2;	
}

my $licenseCommon = new NS::LicenseCommon;
my $nsguiCommon  = new NS::NsguiCommon;
my $licenseConst  = new NS::LicenseConst;

if ( scalar(@ARGV) > 0 ) {
    my $cmd = shift @ARGV;

    if ( $cmd eq 'start' ) {
        my $exitCode = $licenseCommon->start($timeout);
        $nsguiCommon->writeLog( $licenseConst->LICENSE_CHECK,LOG_INFO, sprintf($licenseConst->GRACE_PERIOD_START_LOGMSFG,$exitCode));
    }elsif ( $cmd eq 'stop' ) {
        my $exitCode = $licenseCommon->stop($timeout);
        $nsguiCommon->writeLog( $licenseConst->LICENSE_CHECK,LOG_INFO, sprintf($licenseConst->GRACE_PERIOD_STOP_LOGMSFG,$exitCode));
    }elsif ( $cmd eq 'status' ) {
        my ($status, $remaining)= $licenseCommon->getStatus($timeout);
        print  "status   	:	 $status\nremaining	:	 $remaining\n";
    }
}

exit 0;
