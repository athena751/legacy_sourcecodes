#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_changenisdomain.pl,v 1.1 2004/08/24 14:35:03 liq Exp $"

#    Function: change nis server
#
#    Parameter:
#            nisdomain
#            nisserver
#
#    Return value:
#            0 , if succeed
#            1 , if failed
#            6 , iptables failed
#            255,parameter failed

use strict;
use NS::SystemFileCVS;
use NS::USERDBCommon;

if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 2 parameters.\n";
    exit(255);
}

my ($nisdomain, $nisserver) = @ARGV;

my $COM = new NS::SystemFileCVS;
my $udb_comm = new NS::USERDBCommon;
my $YPCONF_FILE = "/etc/yp.conf";
my $iptables_cmd = "/home/nsadmin/bin/nsgui_iptables.sh";

$COM->checkout($YPCONF_FILE);
my @replace_cmd = ("/home/nsadmin/bin/mapd_replace.pl",$iptables_cmd,$YPCONF_FILE,$nisdomain,"\Q$nisserver\E");

my @result = `@replace_cmd`;

chomp(@result);

if ($? > 0){
    $COM->rollback($YPCONF_FILE);
    print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if ($result[0] ne "0"){

    $udb_comm->rollbackIPtable(\@result);
    $COM->rollback($YPCONF_FILE);
    if ($result[0] eq "2"){
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 6;
    } else{
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

#ypbind restart.If it is failed, rollback
if(system("/etc/rc.d/init.d/ypbind restart")){
    $udb_comm->rollbackIPtable(\@result);
    $COM->rollback($YPCONF_FILE);
    print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
    exit 6;
}

$COM->checkin($YPCONF_FILE);
system("/home/nsadmin/bin/nsgui_iptables_save.sh");
exit 0;
