#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nashead_assign.pl,v 1.5 2005/08/26 11:50:03 wangzf Exp $"

use strict;
use NS::SystemFileCVS;
use NS::NasHeadCommon;
use NS::NasHeadConst;

sub localrollback;
sub remoterollback;

if ( (scalar(@ARGV) != 3) && (scalar(@ARGV) != 2)) {
    print STDERR "The parameters' number of perl script(", __FILE__,
      ") is wrong!\n";
    exit 1;
}
my $ldinfo   = shift;                   # such as wwnn,lun,ldname,
my @ld       = split( /,/, $ldinfo );
my $wwnn     = $ld[0];
my $lun      = $ld[1];
my $ldname   = $ld[2];
my $label    = $ld[3];
$ldinfo = join("," , $wwnn , $lun, $ldname);
my $flag = shift;
my $friendIp = shift;

my $common      = new NS::SystemFileCVS;
my $ldcommon    = new NS::NasHeadCommon;
my $const       = new NS::NasHeadConst();
my $ldconf_file = $ldcommon->getldhardln_conf();

my $cmd_syncwrite_a = $common->COMMAND_NSGUI_SYNCWRITE_A;

if ( $common->checkout($ldconf_file) != 0 ) {
    print STDERR "Failed to checkout \"$ldconf_file\". Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}
if ( !open( OUTPUT, "| ${cmd_syncwrite_a} $ldconf_file" ) ) {
    $common->rollback($ldconf_file);
    print STDERR "Exit in perl script:", __FILE__, " line:", __LINE__ + 1,
      ".\n";
    exit 1;
}
if(($flag eq "1") && (lc($label) ne "gpt")){
    print OUTPUT $ldname . "," . $wwnn . "," . $lun . "\n";
}else{
    print OUTPUT $ldname . "," . $wwnn . "," . $lun . ",gpt\n";
}
if(!close(OUTPUT)) {
    $common->rollback($ldconf_file);
    print STDERR "Exit in perl script:", __FILE__, " line:", __LINE__ + 1,
      ".\n";
    exit 1;
}

my $errcode          = 0;
my $cmd_ldhardln_add = $const->CMD_LDHARDLN_ADD;

#if doesn't format disk
if ($flag eq "1"){
	$cmd_ldhardln_add = $cmd_ldhardln_add." -k";
}
my $cmd_ldhardln_del = $const->CMD_LDHARDLN_DEL;
$errcode = system("sudo $cmd_ldhardln_add $ldinfo");
if ( $errcode != 0 ) {
    $common->rollback($ldconf_file);
    print STDERR
      "Failed to execute:$cmd_ldhardln_add $ldinfo. Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

my $targetFile;
if(defined($friendIp) && ($friendIp ne "")){
    if ( $ldconf_file eq $const->FILE_GROUP0_LDHARDLN_CONF ) {
        $targetFile = $const->FILE_GROUP1_LDHARDLN_CONF;
    }
    else {
        $targetFile = $const->FILE_GROUP0_LDHARDLN_CONF;
    }
    if ( $ldcommon->syncFile( $ldconf_file, $targetFile, $friendIp ) == 1 ) {
        do localrollback();
        print STDERR
    "Failed to execute:syncFile($ldconf_file, $targetFile, $friendIp). Exit in perl script:",
          __FILE__, " line:", __LINE__ + 1, ".\n";
        exit 1;
    }
    $errcode = $ldcommon->rshCmd( "sudo $cmd_ldhardln_add $ldinfo", $friendIp );
    
    if ( $errcode != 0 ) {
        do localrollback();
        $ldcommon->syncFile( $ldconf_file, $targetFile, $friendIp );## rollback friend file
        print STDERR
    "Failed to execute:rshCmd(\"sudo $cmd_ldhardln_add $ldinfo\",$friendIp). Exit in perl script:",
          __FILE__, " line:", __LINE__ + 1, ".\n";
        exit 1;
    }
}

if ( $common->checkin($ldconf_file) != 0 ) {
    do localrollback();
    do remoterollback();
    print STDERR "Failed to checkin \"$ldconf_file\". Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}
exit 0;

#Function:
#   roll back the remote node's operation
#Arguments:
#   no
#return value:
#   no
sub remoterollback {
    if(defined($friendIp) && ($friendIp ne "")){
        $ldcommon->rshCmd( "sudo $cmd_ldhardln_del $ldname", $friendIp );
        $ldcommon->syncFile( $ldconf_file, $targetFile, $friendIp );
    }
}

#Function:
#   roll back the local node's operation
#Arguments:
#   no
#return value:
#   no
sub localrollback {
    system("sudo $cmd_ldhardln_del $ldname");
    $common->rollback($ldconf_file);
}
