#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_delete.pl,v 1.2302 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::SystemFileCVS;

if(scalar(@ARGV)!=4) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    print STDERR "The parameters is: @ARGV\n";
    exit 1;    
}
my $cmd = shift;        # $cmd = "/home/nsadmin/bin/nsgui_iptables.sh"
my $filename = shift;   # $filename = "/etc/yp.conf"
my $domain = shift;     # domain to delete
my $server = shift;     # server to delete
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if (!open(INPUT,$filename)) {
    print STDERR "Failed to open file \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @content = <INPUT>;
close(INPUT);

if($cvs->checkout($filename)!=0){
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:" ,__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}

if (!open(OUTPUT,"| ${cmd_syncwrite_o} $filename")) {
    $cvs->rollback($filename);
    print STDERR "Failed to open file \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $writed = 0;
my @servers = split(/\s+/, $server);
foreach (@servers) {
	my $canDelete = 0;
	my $serv = $_;
	foreach (@content) {
		#if the line is used by FTP
		if ($_=~/^\s*domain\s+\S+\s+server\s+(\S+)\s+#FTP-/) {
			if ($writed == 0) {
				print OUTPUT $_;
			}
			if ($1 eq $serv) {
				$canDelete = 1;	#Used by FTP
			}
			next;
		}
		
		#if the line is used by MAPD
		if (($_=~/^\s*domain\s+(\S+)\s+server\s+(\S+)\s*$/)
			|| ($_=~/^\s*domain\s+(\S+)\s+server\s+(\S+)\s*#.*$/)) {
			if ($1 ne $domain) {     #if the line don't contain the specified domain
				if ($writed == 0) {
					print OUTPUT $_;
				}
				if ($2 eq $serv) {
					$canDelete = 1;  #Can not delete
				}				
	
			}
	
		}
	}
	$writed = 1;
	if ($canDelete == 0){
		system("${cmd} -D -s ${serv} 512:65535/udp");
	}
}

if(!close(OUTPUT)){
    $cvs->rollback($filename);
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};

if($cvs->checkin($filename)!=0){
    $cvs->rollback($filename);
    print STDERR "Failed to checkin \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
system("/etc/rc.d/init.d/ypbind restart");

exit 0;
