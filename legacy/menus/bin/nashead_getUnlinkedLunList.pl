#!/usr/bin/perl
#
#       Copyright (c) 2001-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nashead_getUnlinkedLunList.pl,v 1.3 2009/01/07 03:04:30 wanghb Exp $"

use strict;
use NS::NasHeadCommon;
use NS::NasHeadConst;

my @ldhardlnConfContent;
my @oslinkConfContent;
my $const = new NS::NasHeadConst();
my $nasHeadCommon = new NS::NasHeadCommon();

my $friendIp = $nasHeadCommon->getFriendIP();

#1. execute /sbin/rescandd in both node
my $home = $ENV{HOME} || "/home/nsadmin";
my $scan_cmd = ${home}."/bin/".$const->PL_DDSCAN_TWONODE_PL;
if(system("sudo $scan_cmd >& /dev/null") != 0){
    print STDERR "Failed to execute $scan_cmd",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $file_ldhardln_conf = $nasHeadCommon->getldhardln_conf();

#2. check devicepath status, if not exist, delete from file.
if ( -f $file_ldhardln_conf ) {
#    my $retValue = $nasHeadCommon->check_devicepath_status($file_ldhardln_conf);
#    if ($retValue != 0){
#	    if ($retValue == $const->ERROR_CODE_FILE_CHECKOUT){
#            print STDERR "Failed to checkout \"$file_ldhardln_conf\". Exit in perl script:",
#              __FILE__, " line:", __LINE__ + 1, ".\n";
#	    }elsif($retValue == $const->ERROR_CODE_FILE_CHECKIN){
#            print STDERR "Failed to checkin \"$file_ldhardln_conf\". Exit in perl script:", __FILE__,
#              " line:", __LINE__ + 1, ".\n";
#	   	}elsif($retValue == $const->ERROR_CODE_FILE_OPEN){
#            print STDERR "Failed to open \"$file_ldhardln_conf\". Exit in perl script:",
#              __FILE__, " line:", __LINE__ + 1, ".\n";
#	   	}elsif($retValue == $const->ERROR_CODE_FILE_SYNC){
#           print STDERR "Failed to rcp \"$file_ldhardln_conf\" to partner node. Exit in perl script:",
#              __FILE__, " line:", __LINE__ + 1, ".\n";
#		}
#	    exit 1;
#	}
	@ldhardlnConfContent = `cat $file_ldhardln_conf`;
}

#3. run getddmap cmd
my $cmd_getddmap = $const->CMD_GETDDMAP;
my @ddmapContent = `$cmd_getddmap`;
if ( $? != 0 ) {
    print STDERR "Failed to execute $cmd_getddmap",__FILE__," line:",__LINE__+1,".\n";
    exit 10;
}

my $file_oslink_conf = $const->FILE_OSLINK_CONF;
if (-f $file_oslink_conf){
    @oslinkConfContent = `cat $file_oslink_conf`;
}

#4.1 get used lun info
my %usedLunInfo;
foreach(@ldhardlnConfContent){
    if(/^\s*\/dev\/ld([\d]+)\s*,\s*(\w+)\s*,\s*(\d+)\b/){
        #the /dev/ldxx exist in ldhardln.conf
        $usedLunInfo{"$2,$3"} = "";
    }
}

#4.2 get maximum lun's number
my $maxLuns = 0;
$maxLuns = 496 - scalar(keys(%usedLunInfo));

foreach(@oslinkConfContent){
    if(/^\s*\/dev\/ld([\d]+)\s*,\s*(\w+)\s*,\s*(\d+)\b/){
        #the /dev/ldxx exist in oslink.conf
        $usedLunInfo{"$2,$3"} = "";
    }
}

#5. get available lun info

my @availabeWWNN_LUN;
my $wwnn;
my $name;
foreach(@ddmapContent){
    if(/^\/dev\/dd\w+\s*,\s*(\w+)\s*,\s*(\d+)\s*,.+/){
        # match the line such as "/dev/dda,wwnn,lun,...."
        if(!defined($usedLunInfo{"$1,$2"})){
            $name = $nasHeadCommon->getStorageName($1);
            push (@availabeWWNN_LUN,"$name,$1,$2\n");
        }
    }
}
print "maxLuns:".$maxLuns."\n";
foreach(@availabeWWNN_LUN){
    print "$_";
}

exit 0;