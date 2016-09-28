#!/usr/bin/perl
#
#       Copyright (c) 2001-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nashead_getLunInfo.pl,v 1.10 2009/01/07 03:04:25 wanghb Exp $"

use strict;
use NS::SystemFileCVS;
use NS::NasHeadCommon;
use NS::NasHeadConst;
use NS::DdrCommon;


my $cvs   = new NS::SystemFileCVS;
my $com   = new NS::NasHeadCommon;
my $const = new NS::NasHeadConst;
my $ddrCommon = new NS::DdrCommon;

if ( scalar(@ARGV) != 3 ) {
    print STDERR "The parameters' number of perl script(", __FILE__,
      ") is wrong! \n This script need one parameter.\n";
    exit 1;
}

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $wwnn = shift;
my $needScan = shift;
my $isNsview = shift;

if($needScan eq "yes"){
    my $home = $ENV{HOME} || "/home/nsadmin";
    my $scan_cmd = ${home} . "/bin/" . $const->PL_DDSCAN_TWONODE_PL;
    if ( system("sudo $scan_cmd") != 0 ) {
        print STDERR "Failed to execute $scan_cmd", __FILE__, " line:",
          __LINE__ + 1, ".\n";
        exit 1;
    }
}

my $ldconffile = $com->getldhardln_conf();
my @deviceinfo = ();

if ( -f $ldconffile ) {
#    if($isNsview ne "yes") {
#        &check_devicepath_status($ldconffile);
#    }
    @deviceinfo = `cat $ldconffile`;
}
else {
    exit 0;
}

my $cmd_getddmap = $const->CMD_GETDDMAP;
my @cmdresult    = `$cmd_getddmap`;
if ( $? != 0 ) {
    exit 10;
}

my $cmd_vgdisplay = $const->CMD_VGDISPLAY_D_v;
my @lvresult      = `$cmd_vgdisplay 2>/dev/null`;
if ( $? != 0) {
    print STDERR "Can not get Lun's lvm status in perl script(", __FILE__,
      ")!\n";
    exit 1;
}

## get all MV RV lds
my ($mvLdHash, $rvLdHash) = $ddrCommon->getMvRvLds();
my $pairedLds = {%$mvLdHash, %$rvLdHash};

my $devicepath = "";
my $lun        = "";
my $connectstatus;
my $lvmstatus;
my $pairStatus;
my @allLUN = ();

for ( my $i = 0 ; $i < scalar(@deviceinfo) ; $i++ ) {
    $connectstatus = "n";
    $lvmstatus     = "n";
    $pairStatus    = "n";
    chomp( $deviceinfo[$i] );
    if ( $deviceinfo[$i] =~ /^\s*(.+)\s*,\s*$wwnn\s*,\s*(\d+)\b/ ) {
        $devicepath = $1;
        $lun        = $2;

        foreach (@cmdresult) {
            if ( $_ =~ /^\s*\/dev.+\s*,\s*$wwnn\s*,\s*$lun\s*,.+/ ) {
                $connectstatus = "y";
                last;
            }
        }

        foreach (@lvresult) {
            if ( $_ =~ /^\s*PV Name.+\Q$devicepath\E\s*/ ) {
                $lvmstatus = "y";
                last;
            }
        }
        
        if(defined($$pairedLds{$devicepath})){
            $pairStatus = "y";
        }
        push( @allLUN,
                $lun . ","
              . $devicepath . ","
              . $connectstatus . ","
              . $lvmstatus . ","
              . $pairStatus
              . "\n" );
    }
}

@allLUN = sort by_ldNum @allLUN;
foreach (@allLUN) {
    print "$_";
}

exit 0;

sub by_ldNum {
    my $aNum = 0;
    my $bNum = 0;
    if ( $a =~ /^(\d+),/ ) {
        $aNum = $1;
    }
    if ( $b =~ /^(\d+),/ ) {
        $bNum = $1;
    }
    if ( $aNum < $bNum ) {
        return -1;
    }
    elsif ( $aNum == $bNum ) {
        return 0;
    }
    elsif ( $aNum > $bNum ) {
        return 1;
    }
}

sub check_devicepath_status() {
    my $confFile = shift;
    my @content;
    @content = `cat $confFile`;
    my @newContent;
    my $needDelete = 0;
    foreach (@content) {
        if (/^\s*(.+)\s*,\s*\w+\s*,\s*\d+\b/) {
            my $ldPath = $1;
            if ( -b $ldPath ) {
                push( @newContent, $_ );
            }
            else {
                $needDelete = 1;

                #delete the line
            }
        }
        else {
            push( @newContent, $_ );
        }
    }
    if ( $needDelete == 1 ) {

        if ( $cvs->checkout($confFile) != 0 ) {
            print STDERR
              "Failed to checkout \"$confFile\". Exit in perl script:",
              __FILE__, " line:", __LINE__ + 1, ".\n";
            exit 1;
        }

        if ( !open( WFILE, "| ${cmd_syncwrite_o} $confFile" ) ) {
            $cvs->rollback($confFile);
            print STDERR "File $confFile can't be opened. Exit in perl script:",
              __FILE__, " line:", __LINE__ + 1, ".\n";
            exit 1;
        }

        print WFILE @newContent;
        if(!close(WFILE)) {
            $cvs->rollback($confFile);
            print STDERR "File $confFile can't be written. Exit in perl script:",
              __FILE__, " line:", __LINE__ + 1, ".\n";
            exit 1;        
        }
        ### rcp file to friend node when cluster case
        my $friendIp = $com->getFriendIP();
        my $confFile_friend;
        if(defined($friendIp) && ($friendIp ne "")){
            if ( $const->FILE_GROUP0_LDHARDLN_CONF eq $confFile ) {
                $confFile_friend = $const->FILE_GROUP1_LDHARDLN_CONF;
            }
            else {
                $confFile_friend = $const->FILE_GROUP0_LDHARDLN_CONF;
            }
            
            if ( $com->syncFile( $confFile, $confFile_friend, $friendIp ) != 0 ) {
                $cvs->rollback($confFile);
                print STDERR
                  "Failed to rcp \"$confFile\" to $friendIp. Exit in perl script:",
                  __FILE__, " line:", __LINE__ + 1, ".\n";
                exit 1;
            }
        }
        
        if ( $cvs->checkin($confFile) != 0 ) {
            $cvs->rollback($confFile);
            if(defined($friendIp) && ($friendIp ne "")){
                $com->syncFile( $confFile, $confFile_friend, $friendIp );
            }
            print STDERR
              "Failed to checkin \"$confFile\". Exit in perl script:", __FILE__,
              " line:", __LINE__ + 1, ".\n";
            exit 1;
        }
    }
}
