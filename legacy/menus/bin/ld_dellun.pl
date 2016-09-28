#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ld_dellun.pl,v 1.1 2005/09/28 00:59:20 wangli Exp $"

use strict;
use NS::NsguiCommon;
use NS::VolumeCommon;
use NS::VolumeConst;

my $nsguiCommon  = new NS::NsguiCommon;
my $volumeCommon = new NS::VolumeCommon;
my $volumeConst  = new NS::VolumeConst;

my $CMD_ISADISKLIST = "/opt/nec/nsadmin/sbin/iSAdisklist -d";

if (scalar(@ARGV) != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($aid, $lun) = @ARGV;

my @retISA = `$CMD_ISADISKLIST`;
if ($? != 0){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $wwnn = "";
foreach(@retISA){
    if($_ =~ /^\s*$aid\s+.*\s+([0-9a-z]{16})\s*$/){
        $wwnn = $1;
    }
}

if ($wwnn eq "") {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $lunLdHash = $volumeCommon->getLunLdPathHash();
if (defined($$lunLdHash{$volumeConst->ERR_FLAG})) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $ldpath = "";
if (exists($$lunLdHash{"$wwnn,$lun"})) {
    $ldpath = $$lunLdHash{"$wwnn,$lun"};
    my $cmd_deleteLun = $volumeConst->SCRIPT_DEL_LUN;
    my $retVal = system("$cmd_deleteLun $ldpath 2>/dev/null");
    if($retVal != 0){
        exit 1;
    }
}

exit 0;