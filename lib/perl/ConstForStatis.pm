#!/usr/bin/perl
#
#       Copyright (c) 2005-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ConstForStatis.pm,v 1.2 2006/11/13 04:46:59 zhangjun Exp $"

package NS::ConstForStatis;
use strict;

sub new(){
     my $this = {};                 # Create an anonymous hash, and self points to it.
     bless $this;                   # Connect the hash to the package update.
     return $this;                  # Return the reference to the hash.
}

use constant NASCLUSTER_CONF            => "/etc/nascluster.conf";
use constant ETC_GROUP                  => "/etc/group";
use constant VG_ASSIGN                  => "/vg_assign";

use constant SCRIPT_NSGUI_FSYNC         => "/opt/nec/nsadmin/bin/nsgui_fsync";

use constant ERRCODE_PARAMETER_NUMBER_ERROR     => "0x12800001";

1;