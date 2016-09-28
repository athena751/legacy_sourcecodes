#!/usr/bin/perl

#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: lvm_umount.pl,v 1.1 2005/10/24 05:43:41 liuyq Exp $"

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeCommon = new NS::VolumeCommon;
my $volumeConst = new NS::VolumeConst;

my $cfstab = $volumeCommon->getCfstabFile();
my @mps = &get_mp_in_cfstab($cfstab);
my @mount = `mount`;
my $line;
while(scalar(@mount)>0){
    $line=pop(@mount);
    my @tmp=split(/\s+/, $line);
    my $mp = $tmp[2];
    if( $mp=~/^\/export\// && grep(/^\Q$mp\E$/, @mps)<1) {
        system("umount $mp");
    }
}
exit(0);

sub get_mp_in_cfstab() {
    my $file=shift;
    my @mps=();
    my @content = ();
    if(-e $file) {
        my $cmd_cat = $volumeConst->CMD_CAT;
        @content = `$cmd_cat $file`;
        if($? != 0) {
            $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_CAT);
            exit 1;
        }
    }
    foreach(@content){
        my @tmp=split(/\s+/, $_);
        push(@mps, $tmp[1]);
    }
    return @mps;    
}