#!/usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: schedulescan_checkComputerName.pl,v 1.1 2008/05/08 09:15:30 chenbc Exp $"

# function:
#       check whether the specified computer name
#       has been used.
# Parameter:
#       $groupNumber  : [0|1]
#       $computerName : computer name.
# return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;
# output value:
#       "notexist": specified computer name has not been used.
#       "exist"   : specified computer name has been used.
use strict;
use NS::CIFSCommon;

my $cifsCommon = new NS::CIFSCommon;

if ( scalar(@ARGV) != 2 ) {
    print STDERR "PARAMETER NUMBER ERROR!\nError exit in perl script:", __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

my ( $groupNumber, $computerName ) = @ARGV;

my $vsFile = $cifsCommon->getVsFileName($groupNumber);

if ( -f $vsFile ) {
    open( VSFILE, "$vsFile" );
    my @vsContent = <VSFILE>;
    close(VSFILE);
    foreach (@vsContent) {
        if ( $_ =~ /^\s*\/export\/\w+\s+[\w\.-]+\s+$computerName\s*(#.*)?$/o ) {
            print STDOUT "exist\n";
            exit 0;
        }
    }
}
print STDOUT "notexist\n";
exit 0;