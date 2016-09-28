#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setClientListMode.pl,v 1.2301 2005/08/29 02:49:21 liq Exp $"
use strict;
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $client_list = shift;
my $portNo = shift;
my $accessMode = shift; # Allow|Deny


my @client_array = split(',',$client_list);

for(my $idx = 0; $idx < scalar(@client_array); $idx ++){

	my $client=$client_array[$idx];
	my @pattern=("0","0","0","0");
	my $temp = $client;

	if(chop($temp) eq  '.'){
		my @ip_array=split('\.',$client);
		for(my $i=0; $i<scalar(@ip_array);$i++){
			$pattern[$i]=$ip_array[$i];	
		}
	$client=join(".",@pattern)."/".scalar(@ip_array)*8;
	}
	
	#Deny client list
	my $cmd1;
	my $cmd2;
	if($accessMode eq "Deny"){
	$cmd1 = "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -s $client -i  ! bond0 -p tcp --dport ${portNo} -j ACCEPT 2>/dev/null";
	}else{
        $cmd1 = "/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -s $client -i  ! bond0 -p tcp --dport ${portNo} -j ACCEPT";
	}

    system($cmd1);

}
system("/home/nsadmin/bin/nsgui_iptables_save.sh");
exit 0;
