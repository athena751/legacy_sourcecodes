#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: DiskCommon.pm,v 1.1 2005/09/21 01:58:55 liq Exp $"

package NS::DiskCommon;
use strict;
use NS::DiskConst;
my $const = new NS::DiskConst();

sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;         # Connect the hash to the package update.
     return $this;         # Return the reference to the hash.
}

#get errorcode 
#return "0x107000$errorcode,$errorcode"
sub getErrorcode(){
    my $self = shift;
	my $result = shift;
	my $errorcode="00";
	my %extraError= ("11"=>11,"03"=>3,"09"=>9,"15"=>15,"36"=>36,"14"=>14,"32"=>32,"20"=>20,"35"=>35,"06"=>6);
    
    foreach (@$result){
        if($_=~/.+\(error_code=-(\d+)/){
            $errorcode=$1;
        }
    }
    if ($errorcode=~/^\d$/){
        $errorcode ="0".$errorcode;
    }
    if($errorcode eq "31"){#common expect error
        return "0x10700031,$errorcode";    
    }
    if (exists($extraError{$errorcode})){#extra expect error
        return "0x107000FF,$errorcode";    
    }else{#unexpect error
        return "0x10700000,$errorcode";    
    }
}

#check the poolname exists or not in a diskarray
#paramater : $arrayname, $poolname
#return: 
#exist: "0x10700031,31"
#not exist : false
#error: "0x107000$errorcode,$errorcode"
sub isPoolNameExists(){
    my $self = shift;
    my $arrayname = shift;
    my $poolname = shift;
    
    #get the diskarrayname 's id
    my @getidcmd = ($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_D,"2>&1");
    my @diskinfo = `@getidcmd`;
    if ($? != 0){
        my $errorcode = &getErrorcode($self,\@diskinfo);
        return $errorcode;
    }
    my $arrayid="";
    foreach (@diskinfo){
        if ($_=~/^\s*(0[0-9]{3})\s+${arrayname}\s+/){
            $arrayid = $1;
            last;
        }
    }
    #check poolname in diskarray
    my @diskcmd =($const->CMD_DISK_LIST,$const->CMD_DISK_LIST_POOL,$const->CMD_DISK_LIST_AID,$arrayid,"2>&1");
    my @poolinfo = `@diskcmd`;
    if ($? != 0){
        my $errorcode = &getErrorcode($self,\@poolinfo);
        return $errorcode;
    }
    foreach(@poolinfo){
        if ($_=~/^\s*[a-fA-F0-9]{4}h\s+${poolname}\s+/){
            return "0x10700031,31";
        }
    }
    return "false";
}

1;
