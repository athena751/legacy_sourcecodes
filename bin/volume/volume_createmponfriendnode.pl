#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: volume_createmponfriendnode.pl,v 1.1 2004/08/30 10:09:08 caoyh Exp $"

use strict;

use NS::NsguiCommon;
use NS::VolumeConst;
my $nsguiCommon = new NS::NsguiCommon;
my $comm = new NS::VolumeConst;

my $nodeNo = $nsguiCommon->getMyNodeNo();
my $friendIp = $nsguiCommon->getFriendIP();
if(!defined($friendIp)){#means the machine type is single
    exit 0;
}
my $fstab = "/etc/group".$nodeNo.".setupinfo/cfstab";
if($nsguiCommon->syncFileToOther($fstab ,$friendIp) == 1){
    print STDERR "The file \"$fstab\" is synchronize failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($result,$mountResult) = $nsguiCommon->rshCmdWithSTDOUT("sudo /home/nsadmin/bin/filesystem_makeAllDir.pl $nodeNo", $friendIp);
if(!defined($result) || $result != 0){
    print STDERR "The remote command is failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if(defined($$mountResult[0])){
    chomp($$mountResult[0]);
    $comm->printErrMsg($comm->ERR_CREATE_ALL_DIR_IN_FRIEND_1, $$mountResult[0]);
    exit 1;
}
exit 0 ;
 