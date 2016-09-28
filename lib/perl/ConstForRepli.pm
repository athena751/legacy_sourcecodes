#!/usr/bin/perl 
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ConstForRepli.pm,v 1.2300 2003/11/24 00:54:39 nsadmin Exp $"

#################################################

#Reversion History
    #nas-defect-350 2002/7/4 lhy modify for "bandWidth‹@”\‚Ì’Ç‰Á"

    #revision_2  lhy add for "fileset which is umounted"

#################################################

package NS::ConstForRepli;
use strict;

sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}

############names of config files
use constant FILE_EXPORT            => "mvdsync.export";
use constant FILE_FILESET           => "mvdsync.fileset";
use constant FILE_IMPORT            => "mvdsync.import";

############ write file "mvdsync.filesets" or "mvdsync.exports" or "mvdsync.imports"
use constant FLAG_WRITE_FILESET        => 0;
use constant FLAG_WRITE_EXPORTS        => 1;
use constant FLAG_WRITE_IMPORTS        => 2;
use constant NEED_NOT_WRITE_FILESETS   => 3;

############add client or export original
use constant FLAG_START_EXPORT        => 1;
use constant FLAG_ADD_CLIENT          => 0;

############delete client||stop export and delete filesets||only delete filesets
use constant FLAG_STOP_CLIENT               => 0;
use constant FLAG_STOP_EXPORT_DEL_FSET      => 1;
use constant FLAG_DELETE_FSET               => 2;

############command
use constant COMMAND_FILESET                => "/usr/bin/syncconf status filesets";
use constant COMMAND_EXPORT                 => "/usr/bin/syncconf status exports";
use constant COMMAND_IMPORT                 => "/usr/bin/syncconf status imports";
use constant COMMAND_BANDWIDTH              => "/usr/bin/syncconf bandwidth"; #nas-defect-350=>add
use constant CMD_SYNCCONF_MKFSET            => "/usr/bin/syncconf mkfset";
use constant CMD_SYNCCONF_EXPORT            => "/usr/bin/syncconf export";
use constant CMD_SYNCCONF_EXPORT_ALL        => "/usr/bin/syncconf export -a";
use constant CMD_SYNCCONF_DEMOTE            => "/usr/bin/syncconf promote -d";
use constant CMD_SYNCCONF_RMEXPORT          => "/usr/bin/syncconf rmexport";
use constant CMD_SYNCCONF_RMEXPORT_FORCE    => "/usr/bin/syncconf rmexport -f";
use constant CMD_SYNCCONF_RMIMPORT          => "/usr/bin/syncconf rmimport";
use constant CMD_SYNCCONF_RMFSET            => "/usr/bin/syncconf rmfset";
use constant CMD_SYNCCONF_RMFSET_FORCE      => "/usr/bin/syncconf rmfset -f";
use constant CMD_SYNCCONF_PROMOTE           => "/usr/bin/syncconf promote"; 
use constant CMD_SYNCCONF_BIND              => "/usr/bin/syncconf bind";
use constant CMD_SYNCCONF_BIND_EXPORT       => "/usr/bin/syncconf bind export";
use constant CMD_SYNCCONF_BIND_IMPORT       => "/usr/bin/syncconf bind import";
use constant CMD_SYNCCONF_BIND_DEL_EXPORT   => "/usr/bin/syncconf bind -d export";
use constant CMD_SYNCCONF_BIND_DEL_IMPORT   => "/usr/bin/syncconf bind -d import";
############special key
use constant FILESET_SEPARATOR         => "#";
use constant NO_FILESETS               => "\tNo filesets.";
use constant NO_IMPORTS                => "\tNo imports.";
use constant NO_EXPORTS                => "\tNo exports.";
use constant BAND_WIDTH                => "\tbandwidth";

###########fileset's status###########lhy add at 2002/08/23 
use constant EXPORT          => "export";
use constant IMPORT          => "import";
use constant LOCAL           => "local";
use constant NOT_REPLICAIOTN => "not_repli_fs";

use constant DELETE          => 0;
use constant NOT_DELETE      => 1;

###########security command###########lhy add at 2002/08/27
use constant COMMAND_SYNC_SECURITY => "/usr/bin/syncconf security ssl";

###########start/stop command#########lhy add at 2003/04/10
use constant COMMAND_SYNC_START    => "/usr/bin/syncconf start";
use constant COMMAND_SYNC_STOP     => "/usr/bin/syncconf stop";


###########umount ###############revision_2
use constant STATUS_UMOUNT => "umount";
use constant STATUS_MOUNT  => "mounted";

###########bind ip##############
use constant NO_BINDINGS   => "No bindings.";
use constant BINDINGS      => "\tBindings";

###########error code###########
use constant ERROR_CODE_DELLETE_FILESET_FAILED           => 2;
use constant ERROR_CODE_EXPORT_FAILED                    => 25;
use constant ERROR_CODE_EXPORT_BANDWIDTH_FAILED          => 26;
use constant ERROR_CODE_EXPORT_BINDIP_FAILED             => 27;
use constant ERROR_CODE_EXPORT_BANDWIDTH_BINDIP_FAILED   => 28;
use constant ERROR_CODE_EXPORT_IMPORT_BINDIP_FAILED      => 30;
use constant ERROR_CODE_EXPORT_RMFSET_FAILED             => 31;
use constant ERROR_CODE_EXPORT_RMEXPORT_FAILED           => 32;

use constant ERROR_CODE_RESTORE_BIND_EXPORT_FAILED       => 41;

use constant ERROR_CODE_RESTORE_BIND_IMPORT_FAILED       => 42;

use constant ERROR_CODE_RESTORE_BANDWIDTH_FAILED         => 43;

use constant ERROR_CODE_DEMOTE_CANT_RESTORE              => 44;
use constant ERROR_CODE_PROMOTE_CANT_RESTORE             => 45;

use constant ERROR_CODE_RMIMPORT_CANT_RESTORE            => 46;

use constant ERROR_CODE_ADDIMPORT_CANT_RESTORE           => 47;

use constant ERROR_CODE_STARTEXPORT_RESTORE_LOCAL_FAILED => 51;
use constant ERROR_CODE_STARTEXPORT_RMCLIENT_FAILED      => 52;

use constant ERROR_CODE_STOPEXPORT_RESTORE_CLIENT_FAILED => 53;
use constant ERROR_CODE_STOPEXPORT_RESTORE_EXPORT        => 54;
use constant ERROR_CODE_STOPEXPORT_RESTORE_FSET_FAILED   => 55;

use constant ERROR_CODE_SELSSL_FAILED                    => 56;
###########system command#######
use constant CMD_IFCONFIG => "/sbin/ifconfig -a";

1;
