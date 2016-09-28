#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_setPorts.pl,v 1.2302 2007/02/12 05:11:46 cuihw Exp $"

use strict;

my $node;
my $ftpmiddlefile0;
my $ftpmiddlefile1;
my $httpmiddlefile;
my $httpPorts;
my @newports;
my @oldports;
my @content;
my @commands;
my @addrport;
my $portnumber;
my $ipaddr_toe;
my $ipaddr_vtoe;

while(<STDIN>){
   chop;
   push(@ARGV,$_);
}

if(scalar(@ARGV) != 2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}

$node = shift;
$httpPorts = shift;
$ftpmiddlefile0 = '/etc/group'.$node.'.setupinfo/ftpd/proftpd.conf.0';
$ftpmiddlefile1 = '/etc/group'.$node.'.setupinfo/ftpd/proftpd.conf.1';
$httpmiddlefile = '/etc/group'.$node.'.setupinfo/httpd/interim/httpd.conf';
@newports = split(' ', $httpPorts);

if (!open(INPUT,"$ftpmiddlefile0")) {
    @content=();
} else {
    @content = <INPUT>;
    close(INPUT);
}

foreach(@content){
    if (/^\s*Port\s+(\S+)$/) {
        foreach(@newports) {
            @addrport = split(":", $_);
            if (scalar(@addrport) == 1) {
                $portnumber = $addrport[0];
            } else {
                $portnumber = $addrport[1];
            }
            if ($1 eq $portnumber) {
                print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
                exit 4;
            }
        }
        last;
    }
}

if (!open(INPUT,"$ftpmiddlefile1")) {
    @content=();
} else {
    @content = <INPUT>;
    close(INPUT);
}

foreach(@content){
    if (/^\s*Port\s+(\S+)$/) {
        foreach(@newports) {
            @addrport = split(":", $_);
            if (scalar(@addrport) == 1) {
                $portnumber = $addrport[0];
            } else {
                $portnumber = $addrport[1];
            }
            if ($1 eq $portnumber) {
                print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
                exit 4;
            }
        }
        last;
    }
}

if (!open(INPUT,"$httpmiddlefile")) {
    @content=();
} else {
    @content = <INPUT>;
    close(INPUT);
}

foreach(@content) {
    if (/^\s*Listen\s+(\S+)\s*$/) {
        @addrport = split(":", $1);
        if (scalar(@addrport) == 1) {
            system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -i ! bond0 -p tcp --dport $addrport[0] -j ACCEPT");
            system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -i ! bond0 -p udp --dport $addrport[0] -j ACCEPT");
        } else {
            system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -d $addrport[0] -p udp --dport $addrport[1] -j ACCEPT");
            system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -d $addrport[0] -p tcp --dport $addrport[1] -j ACCEPT");
        }
    }
}

foreach(@newports) {
    @addrport = split(":", $_);
    if (scalar(@addrport) == 1) {
        if (system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -i ! bond0 -p tcp --dport $addrport[0] -j ACCEPT")
         || system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -i ! bond0 -p udp --dport $addrport[0] -j ACCEPT")) {
            print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit 5;
        }
    } else {
        if (system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -d $addrport[0] -p udp --dport $addrport[1] -j ACCEPT")
            || system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -d $addrport[0] -p tcp --dport $addrport[1] -j ACCEPT")) {
            print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit 5;
        }
    }       
}

if(system("/home/nsadmin/bin/nsgui_iptables_save.sh")) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 5;
}
exit 0;
