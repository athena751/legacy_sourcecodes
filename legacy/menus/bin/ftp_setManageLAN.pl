#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setManageLAN.pl,v 1.2302 2005/08/29 02:49:21 liq Exp $"

use strict;

#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=4)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $bUseFTP = shift; # true|false
my $manageLANStatus = shift; #true|false
my $nodeNo = shift;
my $groupNo = shift;

my $portNo ="21"; #service lan's port number


my $cmd ="";


#find service LAN portNo from /etc/groupN.setupinfo/ftpd/proftpd.conf.N
my $ftpd_conf = "/etc/group${nodeNo}.setupinfo/ftpd/proftpd.conf.${groupNo}";
$cmd = "awk '{if(\$1 == \"Port\") {print \$2}}' ${ftpd_conf}";

if( -f $ftpd_conf){
    $portNo = `$cmd`;
    chomp($portNo);
}

if($portNo eq ""){
    $portNo = "21";
}

#change the manage LAN's use status
if ($bUseFTP eq "true"){

    #open service lan
    system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -i ! bond0 -p tcp --dport 20 -j ACCEPT");
    system("/home/nsadmin/bin/nsgui_iptables2.sh -A INPUT -i ! bond0 -p tcp --dport ${portNo} -j ACCEPT");
    
    system("/home/nsadmin/bin/nsgui_iptables_save.sh");        
    
}
else{

    # close service lan
    system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -i ! bond0 -p tcp --dport 20 -j ACCEPT 2>/dev/null");
    
    system("/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -i ! bond0 -p tcp --dport ${portNo} -j ACCEPT 2>/dev/null");
 
    system("/home/nsadmin/bin/nsgui_iptables_save.sh");

}
exit 0;
