#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_deliptable.pl,v 1.2301 2004/08/24 14:35:03 liq Exp $"
use strict;
if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $serverName = shift;
my $myNodeNo = shift;
my @myFriend = `sudo /home/nsadmin/bin/getMyFriend.sh`;
my $myFriendIP = $myFriend[0];

my $myFriendNo = ($myNodeNo eq "1")?"0":"1";
my @friendNode;
my $hasUsed="0";

my $cmd = "sudo /usr/bin/ims_domain -Lv -c /etc/group${myNodeNo}/ims.conf";
my @myNode = `$cmd`;
if ($? != 0) {
         print STDERR "Failed to execute command \"${cmd}\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
         exit 1;
    }
if (defined($myFriendIP) && ($myFriendIP ne "")){
    $myFriendIP =~ s/\s+//g;
    $cmd = "rsh $myFriendIP sudo /usr/bin/ims_domain -Lv -c /etc/group${myFriendNo}/ims.conf";
    @friendNode = `$cmd`;
    if ($? != 0) {
         print STDERR "Failed to execute command \"${cmd}\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
         exit 1;
    }
    push(@myNode,@friendNode);
}

foreach my $line(@myNode) {
    if ($line =~/^ldu:.*/) {
        $hasUsed = "1";
        last;
    }
}
if ($hasUsed eq "0") {
    foreach (split(/\s+/, $serverName)) {
        $_ =~ s/:.*$//g;
        system("sudo /home/nsadmin/bin/nsgui_iptables.sh -D -s $_ -- -389/tcp -389/udp -636/tcp -636/udp 2> /dev/null");
    }
}
