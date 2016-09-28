#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_checkdirecthosting.pl,v 1.4 2008/05/09 02:56:57 chenbc Exp $"

# Function:
#       Check direct hosting in one group.
# Parameters:
#       groupN
# output:
#       yes
#       no
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::CIFSCommon;
use NS::NsguiCommon;

my $cifsCommon = new NS::CIFSCommon;
my $comm  = new NS::NsguiCommon;

if(scalar(@ARGV)!=1)
{
    print STDERR "Parameter'number Error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

my $groupN = shift;
my @content;
my $VIRTUAL_FILE = $cifsCommon->getVsFileName($groupN);

if(-f $VIRTUAL_FILE){
    @content = `cat $VIRTUAL_FILE 2>/dev/null`;
    my $newVSContent = $comm->getVSContent(\@content);
    @content = @$newVSContent;
}else{
    print("no\n");
    exit(0);
}
foreach(@content){
    if (/^\s*\/export\/(\S+)\s+(\S+)\s+([a-zA-Z0-9\-]+)/) {
        my $dh=$cifsCommon->getDirectHosting($groupN,$2,$3);
        print("$dh\n");
        exit(0);
    }
}
print("no\n");
exit(0);
