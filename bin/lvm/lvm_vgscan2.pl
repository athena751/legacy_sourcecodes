#!/usr/bin/perl -w

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: lvm_vgscan2.pl,v 1.1 2005/10/24 05:43:41 liuyq Exp $"

##Function : 
##          execute /sbin/vgscan2 in this node and friend node
##Parameter:
##          none
##Output   :
##          none
##Return   :
##          0 -- successful
##          not 0 -- failed

use strict;
use NS::NasHeadCommon;

use constant ERROR_CODE_RSH       => 5;

my $common =  new NS::NasHeadCommon;
my $VGSCAN_2 = "sudo /sbin/vgscan2";
my $GET_FRIEND_IP_SH = "sudo /home/nsadmin/bin/getMyFriend.sh";

my $retVal = system(${VGSCAN_2});
if($retVal != 0){
    exit 101;
}

my $friendIp = `${GET_FRIEND_IP_SH}`;
if($? != 0){
    print STDERR "Failed to execute:${GET_FRIEND_IP_SH}. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

chomp($friendIp);
if (defined($friendIp)&& $friendIp ne ""){
    
    if ($common->isActive($friendIp) != 0 ){
        print STDERR "Friend node (${friendIp}) is not actived. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;      
    }
    
    $retVal = $common->rshCmd(${VGSCAN_2} , $friendIp);
    if($retVal == ERROR_CODE_RSH){
        print STDERR "Failed to execute:sudo -u nsadmin /usr/bin/rsh. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }elsif($retVal != 0){
        exit 101;
    }
}

exit(0);