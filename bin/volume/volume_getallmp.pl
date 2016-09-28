#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_getallmp.pl,v 1.1 2004/08/14 10:29:42 changhs Exp $"

###Function : get all the mount point path in system from mount command and cfstab file
###Parameter: 
###     none
###Return:
###     0 : success
###     1 : error occurs
###Output:
###     1.stdout
###       /export/volume/16
###       /export/volume/16/subchild
###     2.stderr
###       Failed to execute /bin/cat.
###       Error occured. (error_code=0x1080009e)

use strict;
use NS::VolumeCommon;
use NS::VolumeConst;

my $volumeConst = new NS::VolumeConst;
my $volumeCommon = new NS::VolumeCommon;

my %mpHash = ();

my $cmd_mount = $volumeConst->CMD_MOUNT;
my $cmd_cat = $volumeConst->CMD_CAT;

my $cfstabFile = $volumeCommon->getCfstabFile();

### get mount point path from cfstab file
if(-e $cfstabFile){
    my @cfstabContent = `$cmd_cat $cfstabFile 2>/dev/null`;
    if($? != 0){
        $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_CAT);
        exit 1;
    }
    
    foreach(@cfstabContent){
        if($_ =~ /^\s*#.+/){
            next;
        }
        if($_ =~ /^\s*\S+\s+(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s*$/){
            $mpHash{$1."\n"} = "";
        }
    }
}

### get mount point path from mount command
my @mountContent = `$cmd_mount 2>/dev/null`;
if($? != 0){
    $volumeConst->printErrMsg($volumeConst->ERR_EXECUTE_MOUNT);
    exit 1;
} 
foreach(@mountContent){
    if($_ =~ /^\s*\S+\s+on\s+(\S+)\s+/){
        $mpHash{$1."\n"} = "";
    }
}

my @mpAry = sort keys %mpHash;
print @mpAry;

exit 0;