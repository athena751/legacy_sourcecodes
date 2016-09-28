#!/usr/bin/perl 
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ConstForGFS.pm,v 1.5 2005/12/01 01:53:22 zhangjun Exp $"

package NS::ConstForGFS;

use strict;

sub new(){
     my $this = {};     # Create an anonymous hash, and self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}

use constant GFS_FILENAME_GROUP0      => "/etc/group0.setupinfo/gfstab_s";
use constant GFS_FILENAME_GROUP1      => "/etc/group1.setupinfo/gfstab_s";
use constant GFS_TEMPFILE_GROUP0      => "/etc/group0.setupinfo/gfstab_s_temp";
use constant GFS_TEMPFILE_GROUP1      => "/etc/group1.setupinfo/gfstab_s_temp";
use constant FILE_ASSIGN_NODE0        => "/etc/group0/vg_assign";
use constant FILE_ASSIGN_NODE1        => "/etc/group1/vg_assign";
use constant FILE_CFSTAB_NODE0        => "/etc/group0/cfstab";
use constant FILE_CFSTAB_NODE1        => "/etc/group1/cfstab";
use constant FILE_LDHARDLN_CONF       => "/etc/ldhardln.conf";

use constant CMD_CAT                  => "/bin/cat";
use constant CMD_RM                   => "/bin/rm";
use constant CMD_MOUNT                => "/bin/mount";
use constant CMD_GFSSERV_SETDEVICE    => "/usr/lib/rcli/gfsserv setdevice";
use constant CMD_VGDISPLAY            => "/sbin/vgdisplay -Dv";
use constant CMD_SFDISK               => "/sbin/sfdisk -s";
use constant CMD_GFSSERV_SERIAL       => "/usr/lib/rcli/gfsserv serial";

use constant CMD_SUDO                 => "sudo";
use constant PRA_DEV2NULL             => "2>/dev/null";

use constant ERRCODE_PARAMETER_NUMBER_ERROR  => "0x13300001";
use constant ERRCODE_GFSSERVADD_FAILED       => "0x13300010";

1;