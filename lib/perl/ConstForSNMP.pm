#!/usr/bin/perl 
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ConstForSNMP.pm,v 1.2309 2008/02/26 08:05:40 lil Exp $"

package NS::ConstForSNMP;
use strict;

sub new(){
     my $this = {};                 # Create an anonymous hash, and self points to it.
     bless $this;                   # Connect the hash to the package update.
     return $this;                  # Return the reference to the hash.
}

use constant SNMPD_CONF                 => "/etc/snmp/snmpd.conf";
use constant SNMPD_CONF_PERSISTENT      => "/var/net-snmp/snmpd.conf";

use constant SH_APPLY_IPTABLES_OF_FRINODE   => "/home/nsadmin/bin/snmp_applyIptablesofFriNode.sh";
use constant SH_GET_SNMP_IPTABLESINFO   => "/home/nsadmin/bin/snmp_getSNMPIPTablesInfo.sh";
use constant NSGUI_IPTABLES2            => "/home/nsadmin/bin/nsgui_iptables2.sh";
use constant NSGUI_IPTABLES_SAVE        => "/home/nsadmin/bin/nsgui_iptables_save.sh";
use constant CLUSTER_SYNCFILE           => "/home/nsadmin/bin/cluster_syncfile.pl";
use constant SCRIPT_GETINFOLIST_FRINODE => "/home/nsadmin/bin/snmp_getInfoListofFriNode.pl";
use constant SCRIPT_TRAPCONF =>  "/usr/sbin/nv_trapconf";
use constant GET_MAX_COMM_NUM => "/home/nsadmin/bin/snmp_getMaxCommunityNum.pl";

use constant SYSLOCATION                => "syslocation";
use constant SYSCONTACT                 => "syscontact";
use constant COM2SEC                    => "com2sec";
use constant GROUP                      => "group";
use constant ACCESS                     => "access";
use constant CREATEUSER                 => "createUser";
use constant RO_USER                    => "rouser";
use constant V1 						=> "v1";
use constant V2C						=> "v2c";

use constant COMMUNITY_PREFIX_GRP       => "grp";
use constant COMMUNITY_PREFIX_GROUP     => "group";
use constant COMMUNITY_PREFIX_NAS       => "nas";
use constant USER_NSADMIN               => "nsadmin";

use constant INTERFACE                  => "bond0";

use constant MAX_USERS_IN_CONF          => 10;

use constant OPEN                       => "open";
use constant CLOSE                      => "close";

use constant TYPE_ALL                   => "all";
use constant TYPE_COMMUNITIES           => "communities";
use constant TYPE_USERS                 => "users";
use constant TYPE_SYSTEM                => "system";

use constant ERRCODE_PARAMETER_NUMBER_ERROR             => "0x12700001";
use constant ERRCODE_USER_EXIST                         => "0x12700010";
use constant ERRCODE_MAX_USER_EXIST                     => "0x12700020";
use constant ERRCODE_USER_NOT_EXIST                     => "0x12700030";
use constant ERRCODE_COMMUNITY_EXIST                    => "0x12700040";
use constant ERRCODE_COMMUNITY_NOT_EXIST                => "0x12700050";
use constant ERRCODE_MAX_COMMUNITY_EXIST                => "0x12700060";
use constant ERRCODE_MAX_COMMUNITY_EXIST_MODIFY         => "0x12700070";

use constant ERRCODE_SNMPDCONF_MODIFY_FAILED             => "0x12700080";
use constant ERRCODE_SNMPDCONF_ADD_FAILED			           => "0x12700081";
use constant ERRCODE_SNMPDCONF_DELETE_FAILED             => "0x12700082";
use constant ERRCODE_SNMPDCONF_SYNC_FAILED               => "0x12700083";
use constant ERRCODE_SETSYS_FAILED				               => "0x12700084";
use constant ERRCODE_USER_ADD_FAILED										 => "0x12700085";
use constant ERRCODE_USER_DELETE_FAILED					         => "0x12700086";
use constant ERRCODE_USER_MODIFY_FAILED						       => "0x12700087";

use constant ERRCODE_SNMPTRAP_MODIFY_FAILED					     => "0x12700090";
use constant ERRCODE_SNMPTRAP_ADD_FAILED							   => "0x12700091";
use constant ERRCODE_SNMPTRAP_DELETE_FAILED							 => "0x12700092";
use constant ERRCODE_SNMPTRAP_SYNC_FAILED                => "0x12700093";

#------------------------
use constant ERRCODE_RECOVERY                           => "0x12700200";
use constant ERRCODE_INFO_RECOVERY                      => "0x12700210";
use constant ERRCODE_CONVERT_HOST2IP_FAILED             => "0x12700220";
use constant ERRCODE_RECOVERY_CONVERT_HOST2IP_FAILED    => "0x12700230";
use constant ERRCODE_ERROR_IN_USER                      => "0x12700240";
use constant ERRCODE_ERROR_IN_COMMUNITY                 => "0x12700250";
use constant ERRCODE_ERROR_IN_COMMUNITY4COMMUNITYLIST   => "0x12700251";
use constant ERRCODE_ERROR_IN_USER_COMMUNITY            => "0x12700260";
use constant ERRCODE_ERROR_IN_USER_IPTABLE              => "0x12700270";
use constant ERRCODE_ERROR_IN_COMMUNITY_IPTABLE         => "0x12700280";
use constant ERRCODE_ERROR_IN_USER_COMMUNITY_IPTABLE    => "0x12700290";
use constant ERRCODE_ERROR_FAILED_CONVERT_HOST2IP_ADDCOM=> "0x12700310";
1;