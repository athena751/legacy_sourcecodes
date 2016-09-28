#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: Common.pm,v 1.2300 2003/11/24 00:55:20 nsadmin Exp $"



package NS::Common;

use strict;
use NS::ConstInfo;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use NS::Syslog

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

# Initialize
sub init
{
}
#liuhy add at 2001/10/23
sub writeSyslog
{
       
   my $ConstInfo=new NS::ConstInfo();
   ####funciton:process syslog
   ####Parameter:  
       #String $message,
       #String $priority,  This determines the importance of the messag
   ####Return Value: 0:succed;1:error. 

   ####1.judge whether the parameter is valid
                shift(@_);
                my @param=@_;
       #1)if number of parameters is not 4,then return 1;
                my $len=@param;
                if($len!=4){
                     return 1;
                }
       #2)else judge whether values of parameter is valid
                my $filename=$param[0];
                my $functioname=$param[1];
                my $priority=$param[2];
                my $message=$param[3];
                
               #a)if $message equal  "" or equal null ,return 1;
                if($message eq ""){
                      return 1;
                }
                
               #b)if $prority not in 'emerg','alert','crit','err','warning','notice','info','debug',then return 1;

              if($priority ne $ConstInfo->getSyslogEmerg()&&
                   $priority ne $ConstInfo->getSyslogAlert()&&
                   $priority ne $ConstInfo->getSyslogCrit()&&
                   $priority ne $ConstInfo->getSyslogErr()&&
                   $priority ne $ConstInfo->getSyslogWarning()&&
                   $priority ne $ConstInfo->getSyslogNotice()&&
                   $priority ne $ConstInfo->getSyslogInfo()&&
                   $priority ne $ConstInfo->getSyslogDebug()){
                    return 1;  
              }     
                       
               #c)if $0 eq null or $0 eq "",then return 1;
                if($0 eq ""){
                      return 1;
                }
                
   ####2.process syslog
       #1)get symbolic string from constInfo
            my $symbo=$ConstInfo->getSyslogSymbol();
       #2)  
            NS::Syslog::syslog_open("GRAPH-STATISTICS Report",0, LOG_USER); 
            my $tmpMsg=$message;
            NS::Syslog::syslog_put($priority, $tmpMsg);
            NS::Syslog::syslog_close();
   ####3.     
            return 0;
}
1;

