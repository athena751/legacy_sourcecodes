#!/usr/bin/perl 
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: EthguardCommon.pm,v 1.7 2005/08/30 08:32:01 key Exp $"


package NS::EthguardCommon;
use strict;

sub new(){
     my $this = {};     # Create an anonymous hash, and self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}
  
use constant CONN_STATUS_AVAILABLE      => "available";
use constant CONN_STATUS_DENY           => "deny";
use constant CONN_STATUS_UNKNOWN        => "unknown";
use constant CONN_STATUS_ERROR          => "error";
use constant VERSION_TYPE_JAPAN         => "japan";
use constant VERSION_TYPE_ABROAD        => "others";

use constant FILE_TOMCAT_CONF        => "/home/nsadmin/etc/properties/tomcat.conf";
#use constant FILE_TOMCAT4_CONF        => "/home/nsadmin/etc/properties/tomcat4.conf";
#modify for tomcat4->tomcat5 @2004-07-26

use constant CMD_DENY_BOND_8282          => "/home/nsadmin/bin/nsgui_iptables2.sh -I INPUT 1 -p tcp -i ! bond0 --dport 8282 -j DROP";
use constant CMD_DENY_BOND_8585          => "/home/nsadmin/bin/nsgui_iptables2.sh -I INPUT 1 -p tcp -i ! bond0 --dport 8585 -j DROP";
use constant CMD_DENY_LO_8282         	 => "/home/nsadmin/bin/nsgui_iptables2.sh -I INPUT 1 -p tcp -i lo --dport 8282 -j ACCEPT";
use constant CMD_DENY_LO_8585            => "/home/nsadmin/bin/nsgui_iptables2.sh -I INPUT 1 -p tcp -i lo --dport 8585 -j ACCEPT";
use constant CMD_AVAIL_BOND_8282         => "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -p tcp -i ! bond0 --dport 8282 -j DROP";
use constant CMD_AVAIL_BOND_8585         => "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -p tcp -i ! bond0 --dport 8585 -j DROP";
use constant CMD_AVAIL_LO_8282           => "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -p tcp -i lo --dport 8282 -j ACCEPT";
use constant CMD_AVAIL_LO_8585           => "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -p tcp -i lo --dport 8585 -j ACCEPT";


#use constant CMD_AVAIL_8282          => "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -p tcp -i ! bond0 --dport 8282 -j DROP";
#use constant CMD_AVAIL_8585          => "/home/nsadmin/bin/nsgui_iptables2.sh -D INPUT -p tcp -i ! bond0 --dport 8585 -j DROP";
#use constant CMD_DENY_8282         => "/home/nsadmin/bin/nsgui_iptables2.sh -I INPUT 1 -p tcp -i ! bond0 --dport 8282 -j DROP";
#use constant CMD_DENY_8585         => "/home/nsadmin/bin/nsgui_iptables2.sh -I INPUT 1 -p tcp -i ! bond0 --dport 8585 -j DROP";

use constant CMD_IPTABLES_SAVE          => "/home/nsadmin/bin/nsgui_iptables_save.sh";
use constant CMD_IPTABLES_Lnv_INPUT     => "/sbin/iptables -nL INPUT -v";

sub getConnectionInfo(){
    my $cmd_iptables_Lnv_INPUT = CMD_IPTABLES_Lnv_INPUT;
    my @content = `$cmd_iptables_Lnv_INPUT`;
    if($?!=0){
        return CONN_STATUS_ERROR;
    }
    
    my $open_8282 = 0;
    my $open_8585 = 0;
    foreach(@content){
    	if(/^\s*\S+\s+\S+\s+DROP\s+\S+\s+\S+\s+\!bond0\s+\S+\s+\S+\s+\S+\s+tcp\s+dpt\s*:\s*8282\s*$/){
            # the port 8282 is closed
            $open_8282 = 1;
        }elsif(/^\s*\S+\s+\S+\s+DROP\s+\S+\s+\S+\s+\!bond0\s+\S+\s+\S+\s+\S+\s+tcp\s+dpt\s*:\s*8585\s*$/){
            # the port 8585 is closed
            $open_8585 = 1;
        }
    }
    if($open_8282 == 1 && $open_8585 == 1){
        # the port 8282 and 8585 are both closed
        return CONN_STATUS_DENY;
    }elsif($open_8282 == 0 && $open_8585 == 0){
        # the port 8282 and 8585 are not closed
        return CONN_STATUS_AVAILABLE;
    }else{
        return CONN_STATUS_UNKNOWN;
    }
}

1;
