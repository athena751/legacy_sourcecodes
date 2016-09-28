#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: EventCommon.pm,v 1.3 2007/04/06 09:05:51 liul Exp $"

package NS::EventCommon;

use strict;
use IO::Select;
use NS::Syslog;
use constant DEFAULT_INTERVAL => 0.1; # interval measured in seconds;
use constant DEFAULT_WAIT_TIME => 2; # wait time measured in seconds;
use constant TRUE => 1; # boolean value
use constant FALSE => 0; # boolean value

use constant JA => 'ja';
use constant EN => 'en';

use constant RSRC_FILE     => '/opt/nec/nsadmin/etc/eventlog.conf/eventlog.properties.'; # resource file
use constant EVENT_COLLECT => '/opt/nec/nsadmin/bin/event_collect.pl 2> /dev/null';
use constant GET_VER_INF   => '/home/nsadmin/bin/ethguard_getVersionInfo.pl 2>/dev/null';
use constant KEY_FILE      => "/opt/nec/nsadmin/etc/eventlog.conf/event_reptab.xml";
use constant SYS_LOG       => "/var/log/messages";
use constant EVENT_LOG_DIR => "/var/log/eventlog";
use constant EVENT_LOG     => "/var/log/eventlog/eventlog";
use constant EVENT_INFO    => "/var/log/eventlog/.eventinfo";
use constant EVENT_LOCK    => "/var/log/eventlog/.eventlog.lck";

use constant ROTATE_SIZE => 2097152;

use constant MSG_0001  => "0001:The operation is locked by another user.";
use constant MSG_0002  => "0002:Syslog has been changed.";
use constant MSG_0003  => "0003:Timed out.Too many log messages.";

use constant DEFAULT_TIME_OUT => 300;
use constant TIME_TO_ADD => 60;
use constant FORMTAG   => 'formtag';
use constant TIME      => 'time';
use constant ID        => 'id';
use constant MAIL      => 'mail';
use constant SNMP      => 'snmp';
use constant COMPONENT => 'component';
use constant LEVEL     => 'level';
use constant CONTENT   => 'content';
use constant DETAIL    => 'detail';
use constant DEAL      => 'deal';


sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;         # Connect the hash to the package update.
     return $this;         # Return the reference to the hash.
}

sub lockwait{
    my ($self, $lockFile, $waitTime, $interval) = @_;
    if(not defined $interval){
        $interval = &DEFAULT_INTERVAL;
    }
    if(not defined $waitTime){
        $waitTime = &DEFAULT_WAIT_TIME;
    }
    # limit the time
    for(my $curTime = 0; $curTime < $waitTime; $curTime += $interval){
        if(-f $lockFile){
            select(undef, undef, undef, $interval); # if file has been locked, wait
        }else{
            return 0; # no locked file now, return successfully
        }
    }
    return 1; # time out, return in spite of locked file
}

sub writeSyslog{
    my ($self,$errMsg)=@_;

    NS::Syslog::syslog_open("EventLog",0,LOG_USER);
    NS::Syslog::syslog_put(LOG_ERR,$errMsg);
    NS::Syslog::syslog_close();
}

1;
