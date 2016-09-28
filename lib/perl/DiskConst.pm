#!/usr/bin/perl
#
#       Copyright (c) 2005-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: DiskConst.pm,v 1.3 2006/11/10 12:30:53 liq Exp $"

package NS::DiskConst;
use strict;
sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;         # Connect the hash to the package update.
     return $this;         # Return the reference to the hash.
}

### disk list cmd
use constant CMD_DISK_LIST => "/opt/nec/nsadmin/sbin/iSAdisklist";
use constant CMD_DISK_LIST_P => "-p";
use constant CMD_DISK_LIST_AID => "-aid";
use constant CMD_DISK_LIST_POOL => "-pool";
use constant CMD_DISK_LIST_D => "-d";
use constant CMD_DISK_LIST_POOLP => "-poolp";


### pool bind cmd
use constant CMD_POOL_BIND => "/opt/nec/nsadmin/sbin/iSAsetpool";
use constant CMD_POOL_BIND_B => "-b";
use constant CMD_POOL_BIND_ANAME => "-aname";
use constant CMD_POOL_BIND_PDG => "-pdg";
use constant CMD_POOL_BIND_PDN => "-pdn";
use constant CMD_POOL_BIND_PNO => "-pno";
use constant CMD_POOL_BIND_PNAME => "-pname";
use constant CMD_POOL_BIND_RAID => "-raid";
use constant CMD_POOL_BIND_BASEPD => "-basepd";
use constant CMD_POOL_BIND_RBTIME => "-rbtime";
use constant CMD_POOL_BIND_E => "-e";
use constant CMD_POOL_BIND_EMODE => "-emode";
use constant CMD_POOL_EXPAND_TIME => "-exptime";

#simulate
use constant CMD_POOL_BIND_SB => "-sb";
use constant CMD_POOL_BIND_SE => "-se";
1;
