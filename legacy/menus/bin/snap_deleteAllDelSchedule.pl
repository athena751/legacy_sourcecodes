#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snap_deleteAllDelSchedule.pl,v 1.6 2007/05/31 05:05:38 liy Exp $"


use strict;

use NS::SystemFileCVS;
use NS::NsguiCommon;

my $systemFileCVS = new NS::SystemFileCVS;
my $filename="/var/spool/cron/snapshot";
my $cmd_syncwrite_o = $systemFileCVS->COMMAND_NSGUI_SYNCWRITE_O;
my $nsguiCommon = new NS::NsguiCommon;
my $cronfile="/home/nsadmin/bin/snap_cronjob4del.pl";
my @content;

#checkout /var/spool/cron/snapshot
if ($systemFileCVS->checkout($filename) != 0) {
	print STDERR "File $filename checkin failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
  exit 1;		
}

if(!open(INPUT,"$filename"))
{
    print STDERR "The $filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
@content=<INPUT>;
close(INPUT);
if(!open(OUTPUT,"| ${cmd_syncwrite_o} $filename"))
{
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
foreach(@content){
    if(/^\s*#.*/){
        print OUTPUT $_;
	}elsif($_=~/\s+\Q${cronfile}\E\s+/){
		
	}else{
		print OUTPUT $_;
    }
}

if(!close(OUTPUT)) {
    print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
#checkin /var/spool/cron/snapshot
if ($systemFileCVS->checkin($filename) != 0) {
	$systemFileCVS->rollback($filename);
	print STDERR "File $filename checkin failed! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
  exit 1;			
}

## sync /var/spool/cron/snapshot to other node if cluster
my $friendIP = $nsguiCommon->getFriendIP();
if (defined($friendIP)) {
	if ($nsguiCommon->syncFileToOther($filename, $friendIP) != 0) {
		$nsguiCommon->writeErrMsg("fail to sync /var/spool/cron/snapshot to the other node.Exit in perl script:", __FILE__, __LINE__+1);
		exit 1;				
	}
}
exit(0);

##------------------------END----------------------##