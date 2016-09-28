#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ConstForAgent.pm,v 1.2305 2007/09/04 02:13:17 yangxj Exp $"



########################################################
#  in this program it will define some constants for   #
#  all kind of agent program                           #
#  it will be used by NS::CPUAgent                     #
########################################################

package NS::ConstForAgent;
use strict;

################the begin of the main function############

sub new()
{
    my $this = {}; # Create an anonymous hash,and #self points to it.
    bless $this; # Connect the hash to the package update.
    return $this; # Return the reference to the hash.
}
  
use constant  CPU_INFO_FILE         => "/proc/stat";
use constant  DISKIO_INFO_FILE      =>"/proc/dm/iostat";
use constant  NETWORK_INFO_FILE     => "/proc/net/dev64";
use constant  COMMAND_DF_KT         => "df -kT";
use constant  COMMAND_DF_KI         => "df -ki";
use constant  COMMAND_DISKIO        => "sudo /bin/sh -c \"/sbin/lvmsadc | /sbin/lvmsar -s\"";
use constant  COMMAND_NFSGW_SMR     => "sudo /usr/sbin/nfsgw_smr";
use constant  ISCSI_ERROR_FILEL     => "/proc/iscsi/mib/iscsiInstance";
use constant  ISCSI_INSTANCE_FILE   => "/proc/iscsi/mib/iscsiInstanceNumber";
use constant  ISCSI_ERROR_FILER     => "/iscsiInstanceSessionErrorStatusTable";
use constant  ISCSI_LOGIN_FILER     => "/iscsiTarget/iscsiTargetLoginStatsTable";
use constant  ISCSI_LOGOUT_FILER    => "/iscsiTarget/iscsiTargetLogoutStatsTable";

use constant  KAMUI     => "toe";
use constant  VKAMUI    => "vtoe";
use constant  SXFS      => "sxfs";
use constant  SXFSFW    => "sxfsfw";
use constant  SYNCFS    => "syncfs";

use constant  TIME_OUT_MESSAGE          => "NORESPONSE\n";
use constant  CPU_WAITING_TIME          => 2;
use constant  NETWORK_WAITING_TIME      => 6;
use constant  DISK_WAITING_TIME         => 10;
use constant  FILESYSTEM_WAITING_TIME   => 2;
use constant  FILESYSTEM_QUANTITY_WAITING_TIME   => 2;
use constant  ISCSI_SESSION_WAITING_TIME    => 6;
use constant  ISCSI_AUTH_WAITING_TIME       => 10;
use constant  NFS_VIRTUAL_PATH_WAITING_TIME => 45;
use constant  NFS_SERVER_WAITING_TIME => 20;
use constant  NFS_NODE_WAITING_TIME => 10;
use constant  NVAVS_WAITING_TIME    => 6;

use constant  TIMEOUT_CPU               => "Timeout_CPU";
use constant  TIMEOUT_DISK_IO           => "Timeout_DiskIO";
use constant  TIMEOUT_NETWORK_IO        => "Timeout_NetworkIO";
use constant  TIMEOUT_FILESYSTEM        => "Timeout_Filesystem";
use constant  TIMEOUT_FILESYSTEM_QUANTITY        => "Timeout_Filesystem_Quantity";
use constant  TIMEOUT_ISCSI_SESSION     => "Timeout_iSCSI_Session";
use constant  TIMEOUT_ISCSI_AUTH       	=> "Timeout_iSCSI_Auth";
use constant  TIMEOUT_NFS_VIRTUAL_PATH  => "Timeout_NFS_Virtual_Path";
use constant  TIMEOUT_NFS_SERVER        => "Timeout_NFS_Server";    
use constant  TIMEOUT_NFS_NODE          => "Timeout_NFS_Node";
use constant  TIMEOUT_NVAVS             => "Timeout_NVAVS";

use constant  SG_FILE_STATIS_AGENT      
                => "/home/nsadmin/etc/properties/statis_agent.conf";
use constant  SCRIPT_NEEDDISPCPU3       => "/opt/nec/nsadmin/bin/statis_displayCpu3.pl";

1; 
