#!/usr/bin/perl -w

 #      Copyright (c) 2005 NEC Corporation
 #
 #      NEC SOURCE CODE PROPRIETARY
 #
 #      Use, duplication and disclosure subject to a source code
 #      license agreement with NEC Corporation.
 #
# "@(#) $Id: http_getusedport.pl,v 1.2 2005/12/12 08:06:30 xingh Exp $"

#define ethguard file
my $ETH_FILE = "/etc/sysconfig/ethguard";

#define a var to contant the tcp port
my @tcp_port = ();

#open /etc/sysconfig/ethguard

if (! -e $ETH_FILE || !open(INPUT,$ETH_FILE)){
   exit 0;
}

my @content = <INPUT>;
close(INPUT);

#analyse each line
#find each port which is tcp port and
#its port number is more than 1024.
#if the port is defined by name, change it
#to number and then analyse.

my @line;
foreach(@content){
	if(/^\s*#/){
		next;
	}

	@line = split(/\s+/,$_);

	if (scalar(@line) < 3) {
		next;
	}

	if(   ($line[0] eq "mlan" ||$line[0] eq "slan") &&
	      ($line[2] eq "tcp")){

		if ($line[1] =~ /[a-zA-z]/){
			my $portnum = getservbyname($line[1], "tcp");
			push(@tcp_port, $portnum);
		}elsif ($line[1] =~ /:/){
			my @port = split(/:/,$line[1]);
			foreach($port[0]..$port[1]){
				push(@tcp_port, $_);
			}
		}else{
			push(@tcp_port, $line[1]);
		}
	}
}

my @newArr=();
foreach(@tcp_port){
   if ($_ != 80){
        push (@newArr,$_);
   }
}
print "@newArr\n";

exit 0;

