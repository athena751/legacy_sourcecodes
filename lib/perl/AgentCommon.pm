#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: AgentCommon.pm,v 1.2301 2006/03/03 04:45:08 pangqr Exp $"



package NS::AgentCommon;

use strict;
use NS::ConstForAgent;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
@EXPORT = qw(
);
$VERSION = '1.00';

# Constructor
sub new
{
    my $self = shift;
    my $type = ref($self) || $self;
    my $objref = {};
    bless $objref, $type;
    $objref->init();
    return $objref;
}
# init()
sub init
{
    my $self = shift;
}

sub getTimeoutSeconds (){

    my $const = new NS::ConstForAgent();
    shift;
    my $timeoutKey = shift;
    my $timeoutSeconds;
    # set the default seconds according the  timeoutKey:
    #"Timeout_CPU", "Timeout_DiskIO",  
    #"Timeout_NetworkIO", "Timeout_Filesystem" 
    if($timeoutKey eq $const->TIMEOUT_CPU){
        $timeoutSeconds = $const->CPU_WAITING_TIME;
    }elsif($timeoutKey eq $const->TIMEOUT_DISK_IO){
        $timeoutSeconds = $const->DISK_WAITING_TIME;
    }elsif($timeoutKey eq $const->TIMEOUT_NETWORK_IO){
        $timeoutSeconds = $const->NETWORK_WAITING_TIME;
    }elsif($timeoutKey eq $const->TIMEOUT_FILESYSTEM){
        $timeoutSeconds = $const->FILESYSTEM_WAITING_TIME;
    }elsif($timeoutKey eq $const->TIMEOUT_FILESYSTEM_QUANTITY){
        $timeoutSeconds = $const->FILESYSTEM_QUANTITY_WAITING_TIME;
    }elsif($timeoutKey eq $const->TIMEOUT_ISCSI_SESSION){
        $timeoutSeconds = $const->ISCSI_SESSION_WAITING_TIME;
    }elsif($timeoutKey eq $const->TIMEOUT_ISCSI_AUTH){
        $timeoutSeconds = $const->ISCSI_AUTH_WAITING_TIME;
    }
    
    #get the seconds from the SG file:
    # "/home/nsadmin/etc/properties/statis_agent.conf"
    if(open(SG,$const->SG_FILE_STATIS_AGENT)){
        while (<SG>){
            if(/^\s*$timeoutKey\s*=\s*(\d+)\s*$/){
                
                $timeoutSeconds = int($1);
                last;
            }
        }
        close SG;
    }
    return $timeoutSeconds;
}
1;

