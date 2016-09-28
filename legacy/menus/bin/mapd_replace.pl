#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_replace.pl,v 1.2305 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::SystemFileCVS;
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if(scalar(@ARGV)!=4) {
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    print STDERR "The parameters is: @ARGV\n";
    exit 1;
}
my $cmd = shift;        # $cmd = "/home/nsadmin/bin/nsgui_iptables.sh"
my $filename = shift;   # $filename = "/etc/yp.conf"
my $domain = shift;     # domain to add
my $server = shift;     # server to add

if (!open(INPUT,$filename)) {
    print STDERR "Failed to open file \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @content = <INPUT>;
close(INPUT);

if (!open(OUTPUT,"| ${cmd_syncwrite_o} $filename")) {
    print STDERR "Failed to open file \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $exitValue=0;
my @modServers = (); #modified servers(deleted or added)
my @last = ();

# delete the line including the domain that to add in this file.
foreach(@content) {
    if ($_=~/^\s*domain\s+\Q${domain}\E\s+server\s+(\S+)\s*$/) {
        my $serv = $1;
        if(!&isInUsed($serv, \@content)
			&& system("${cmd} -D -s ${serv} 512:65535/udp")==0) {
#            $exitValue=1;
#            last;
            push(@modServers, $serv);   #deleted servers
        }
    } elsif ($_=~/^\s*domain\s+\Q${domain}\E\s+server\s+(\S+)\s+#FTP-/) {
        push(@last, $_);
    } else {
        print OUTPUT $_;
    }
}

push(@modServers, ""); #split the deleted server and the added server
my @servers = split(/\s+/, $server);
# add one line including the specify domain and server

foreach (@servers) {
	my $newLine = join(" ", ("domain", $domain, "server", $_, "\n"));
	print OUTPUT $newLine;

    if(system("${cmd} -A -s $_ 512:65535/udp")!=0) {
        $exitValue=2;
    } else {
		my $already_exist = 0;
		my $serv = $_;
		foreach my $modserver (@modServers){
			if ($serv eq $modserver) {
				$already_exist = 1;
			}
		}
		if ($already_exist == 0) {
	        push(@modServers, $serv);		#added servers
		}
    }
}

foreach(@last) {
    print OUTPUT $_;
}


if(!close(OUTPUT)){
	
    print STDERR "Failed to close file Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};

# print the servers with the specified domain to STDOUT
print "$exitValue\n";
foreach(@modServers){
    print "$_\n";
}
exit 0;

sub isInUsed(){
	my $serv = shift;
	my $tmp = shift;
	my @contents = @$tmp;
	my $useTimes = 0;
	foreach(@contents){
		if (($_ =~/^\s*domain\s+\S+\s+server\s+\Q${serv}\E\s*$/)
			|| ($_ =~/^\s*domain\s+\S+\s+server\s+\Q${serv}\E\s*#.*$/)) {
			$useTimes++;
			if ($useTimes == 2) {
				return 1;
			}
		}
	}
	return 0;
}
