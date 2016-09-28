#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nashead_autoLink.pl,v 1.2 2004/08/18 05:27:32 baiwq Exp $"

use strict;
use NS::NasHeadCommon;
use NS::NasHeadConst;

my @ldhardlnConfContent;
my @oslinkConfContent;
my $const = new NS::NasHeadConst();
my $nasHeadCommon = new NS::NasHeadCommon();

my $friendIp = $nasHeadCommon->getFriendIP();

#execute /sbin/rescandd in both node
my $home = $ENV{HOME} || "/home/nsadmin";
my $scan_cmd = ${home}."/bin/".$const->PL_DDSCAN_TWONODE_PL;
if(system("sudo $scan_cmd >& /dev/null") != 0){
    print STDERR "Failed to execute $scan_cmd",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $cmd_getddmap = $const->CMD_GETDDMAP;
my @ddmapContent = `$cmd_getddmap`;

my $file_ldhardln_conf = $nasHeadCommon->getldhardln_conf();
my $file_oslink_conf = $const->FILE_OSLINK_CONF;
if (-e $file_ldhardln_conf){
    @ldhardlnConfContent = `cat $file_ldhardln_conf`;
}
if (-e $file_oslink_conf){
    @oslinkConfContent = `cat $file_oslink_conf`;
}

my %usedLunInfo;
my %existedLdRecord;
foreach(@ldhardlnConfContent){
    if(/^\s*\/dev\/ld([\d]+)\s*,\s*(\w+)\s*,\s*(\d+)\b/){
        #the /dev/ldxx exist in ldhardln.conf
        $existedLdRecord{$1} = "";
        $usedLunInfo{"$2,$3"} = "";
    }
}
foreach(@oslinkConfContent){
    if(/^\s*\/dev\/ld([\d]+)\s*,\s*(\w+)\s*,\s*(\d+)\b/){
        #the /dev/ldxx exist in oslink.conf
        $existedLdRecord{$1} = "";
        $usedLunInfo{"$2,$3"} = "";
    }
}
my @availabeLd;
my $prefix = "/dev/ld";
for(my $i = 16; $i <= 127; $i++){
    if(!(defined($existedLdRecord{$i}))){
        push (@availabeLd, "$prefix$i");
    }
}

my $availableLdNumber = scalar(@availabeLd);
if($availableLdNumber == 0){
    #/dev/ld16~127 has been used
    exit 100;
}

my @availabeWWNN_LUN;
foreach(@ddmapContent){
    if(/^\/dev\/dd\w+\s*,\s*(\w+)\s*,\s*(\d+)\s*,.+/){
        # match the line such as "/dev/dda,wwnn,lun,...."
        if(!defined($usedLunInfo{"$1,$2"})){
            push (@availabeWWNN_LUN,"$1,$2");
        }
    }
}

my $availableWwnn_lunNumber = scalar(@availabeWWNN_LUN);
my $maxLinkNumber = ($availableLdNumber < $availableWwnn_lunNumber)?$availableLdNumber:$availableWwnn_lunNumber;
my $linkedNumber = 0;

my $script_ld_assign = "${home}/bin/".$const->PL_NASHEAD_ASSIGN_PL;
for(my $i = 0; $i < $maxLinkNumber; $i++){
    my $wwnn_lun_ld = "$availabeWWNN_LUN[$i],$availabeLd[$i]";
    my $exitCode = system("sudo $script_ld_assign ${wwnn_lun_ld} ${friendIp} >& /dev/null");
    $exitCode = $exitCode >> 8;
    if($exitCode == 0){
        $linkedNumber++;
    }else{
        `sudo echo "Failed to LUN Link WWNN,LUN,/dev/ldxx(${wwnn_lun_ld}), The Exit Code of $script_ld_assign is $exitCode." >& /dev/null`;
    }
}

print "$linkedNumber\n";

exit 0;