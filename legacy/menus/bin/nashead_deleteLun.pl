#!/usr/bin/perl
#
#       Copyright (c) 2001-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#)$Id: nashead_deleteLun.pl,v 1.4 2009/01/07 03:04:19 wanghb Exp $"

use strict;
use NS::SystemFileCVS;
use NS::NasHeadCommon;
use NS::NasHeadConst;

my $cvs   = new NS::SystemFileCVS;
my $com   = new NS::NasHeadCommon;
my $const = new NS::NasHeadConst;

if ( scalar(@ARGV) != 1 ) {
    print STDERR "The parameters' number of perl script(", __FILE__,
      ") is wrong! \n This script need one parameter.\n";
    exit 1;
}
my $devicepath  = shift;
my $file_self   = $com->getldhardln_conf();

my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if ( !-f $file_self ) {
    exit 20;
}

my @ldconfcontent = `cat $file_self`;
my $exist = 1;    #the devicepath hasnot exist in the conf file;
for ( my $i = 0 ; $i < scalar(@ldconfcontent) ; $i++ ) {
    if ( $ldconfcontent[$i] =~ /^\s*\Q$devicepath\E\s*,.+/ ) {
        $exist = 0;
        last;
    }
}
if ($exist) {
    exit 20;
}
if ( $cvs->checkout($file_self) != 0 ) {
    print STDERR "Failed to checkout \"$file_self\". Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

my $cmd_del     = $const->CMD_LDHARDLN_DEL;
my $cmd_ls = "/bin/ls";
`$cmd_ls $devicepath >&/dev/null`;
if ( $? == 0 ){
    my $deletresult = system("$cmd_del $devicepath");
    if ( $deletresult == 256 ) {
        $cvs->rollback($file_self);
        exit 30;
    }
    elsif ( $deletresult == 512 ) {
        $cvs->rollback($file_self);
        exit 40;
    }
    elsif ( $deletresult != 0 ) {
        $cvs->rollback($file_self);
        print STDERR
          "Failed to execute:$cmd_del $devicepath. Exit in perl script:",
          __FILE__, " line:", __LINE__ + 1, ".\n";
        exit 1;
    }
}

my @newldconf = ();
for ( my $j = 0 ; $j < scalar(@ldconfcontent) ; $j++ ) {
    if ( $ldconfcontent[$j] =~ /^\s*\Q$devicepath\E\s*,.+/ ) {
    }
    else {
        push( @newldconf, $ldconfcontent[$j] );
    }
}

#renewal the file
if ( !open( WFILE, "| ${cmd_syncwrite_o} $file_self" ) ) {
    $cvs->rollback($file_self);
    print STDERR "File $file_self can't be opened. Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}
print WFILE @newldconf;
if(!close(WFILE)) {
    $cvs->rollback($file_self);
    print STDERR "File $file_self can't be written. Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

#11checkin file
if ( $cvs->checkin($file_self) != 0 ) {
    $cvs->rollback($file_self);
    print STDERR "Failed to checkin \"$file_self\". Exit in perl script:",
      __FILE__, " line:", __LINE__ + 1, ".\n";
    exit 1;
}

### deal in friend node when cluster
my $friendIp = $com->getFriendIP();
if ( defined($friendIp) && $friendIp ne "" ) {
    if ( $com->isActive($friendIp) != 0 ) {
        print STDERR "Failed to get the friend node info. Exit in perl :(",
          __FILE__, ") line:", __LINE__ + 1, ".\n";
        exit 1;
    }

    my $file_friend = "";
        
    if ( $const->FILE_GROUP0_LDHARDLN_CONF eq $file_self ) {
        $file_friend = $const->FILE_GROUP1_LDHARDLN_CONF;
    }
    else {
        $file_friend = $const->FILE_GROUP0_LDHARDLN_CONF;
    }

    #10rcp to friendnode
    if ( $com->syncFile( $file_self, $file_friend, $friendIp ) != 0 ) {
        print STDERR
          "Failed to rcp \"$file_self\" to $friendIp. Exit in perl script:",
          __FILE__, " line:", __LINE__ + 1, ".\n";
        exit 1;
    }

    #12rsh friendnode to execute ldhardln_del
    my $ret = $com->rshCmd( "sudo $cmd_ls $devicepath >&/dev/null", $friendIp );
    if( $ret == 0 ){
        my $rshresult = $com->rshCmd( "sudo $cmd_del $devicepath", $friendIp );
        if ( $rshresult == 0 ) {
            exit 0;
        }
        elsif ( $rshresult == $com->ERROR_CODE_CMD_1 ) {
            exit 30;
        }
        elsif ( $rshresult == $com->ERROR_CODE_CMD_2 ) {
            exit 40;
        }
        else {
            print STDERR
    "Failed to execute:$cmd_del $devicepath in $friendIp. Exit in perl script:",
              __FILE__, " line:", __LINE__ + 1, ".\n";
            exit 1;
        }
    }elsif($ret == $com->ERROR_CODE_RSH){
        print STDERR "Failed to execute:$cmd_ls $devicepath in $friendIp. Exit in perl script:",
            __FILE__, " line:", __LINE__ + 1, ".\n";
        exit 1;
    }else{
        exit 0;
    }
}
