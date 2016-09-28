#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_closeOriginPassive.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"


use strict;
#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}


my $node_number = shift;
my $group_number = shift;

my $passive_start ="";
my $passive_stop = "";
my $portNo = "";

my $pro_conf="/etc/group".$node_number.".setupinfo/ftpd/proftpd.conf.".$group_number;
#print $pro_conf;
if(! -f $pro_conf){
	exit 0;
}

open(INPUT,"$pro_conf");
my @content = <INPUT>;
for(my $i=0; $i<scalar(@content); $i++){
	if(@content[$i] =~ /^\s*Port\s+(\d+)\s*/){
		$portNo = $1;
	}
	elsif(@content[$i] =~ /^\s*PassivePorts\s+(\d+)\s+(\d+)\s*/){
		$passive_start = $1;
		$passive_stop  = $2;
	}
}

#close original control port
if ($portNo ne ""){
    system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -i ! bond0 -p tcp --dport ${portNo} -j ACCEPT 2>/dev/null");
    system("/home/nsadmin/bin/nsgui_iptables_save.sh");	
}

#close original passive port
if(($passive_start ne "")  and  ($passive_stop ne "")){
    system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -i ! bond0 -p tcp --dport $passive_start:$passive_stop -j ACCEPT 2>/dev/null");	
    system("/home/nsadmin/bin/nsgui_iptables_save.sh");	
}

exit 0;
