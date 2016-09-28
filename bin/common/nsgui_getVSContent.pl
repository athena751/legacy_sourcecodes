#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nsgui_getVSContent.pl,v 1.1 2008/05/09 05:06:52 qim Exp $"

#Function: 
    #get content of the file (virtual servers).
#Arguments: 
    #$groupNumber      : the group number 0 or 1
#exit code:
    #0 ---- success


use strict;
use NS::NsguiCommon;
use NS::CIFSCommon;
my $confCommon = new NS::NsguiCommon;
my $cifsCommon = new NS::CIFSCommon;

if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupNumber = shift;
my $vsFile = $cifsCommon->getVsFileName($groupNumber);

if(-f $vsFile){
    open(FILE, $vsFile);
    my @content = <FILE>;
    close(FILE);
    my $vsFileContent = $confCommon->getVSContent(\@content);
    if(scalar(@$vsFileContent)>0){
        print @$vsFileContent;
    }
}
exit 0;

