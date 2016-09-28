#!/usr/bin/perl -w
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: CIFSConst.pm,v 1.12 2008/05/14 08:32:59 chenbc Exp $"
package NS::CIFSConst; 


use constant ERRCODE_PARAMETER_NUMBER_ERROR                 => "0x10200001";
use constant ERRCODE_FAILED_TO_CHECK_OUT_SMB_CONF_FILE      => "0x10200002";
use constant ERRCODE_FAILED_TO_WRITE_SMB_CONF_FILE          => "0x10200003";
use constant ERRCODE_FAILED_TO_EXEC_NASCIFSSTART            => "0x10200004";
use constant ERRCODE_FAILED_TO_CHECK_IN_SMB_CONF_FILE       => "0x10200005";

use constant ERRCODE_SHARE_NAME_EXIST                       => "0x10200006";
use constant ERRCODE_PATH_NOT_START_WITH_MP                 => "0x10200007";
use constant ERRCODE_NO_UNIX_DOMAIN_TO_ADD_AUTH             => "0x10200008";

use constant ERRCODE_FAILED_TO_ADD_AUTH                     => "0x10200009";

use constant ERRCODE_FILE_NAME_IS_DIRECTORY                 => "0x1020000A";
use constant ERRCODE_PATH_NAME_IS_NOT_DIRECTORY             => "0x1020000B";
use constant ERRCODE_FILE_IS_ON_WRONG_AREA                  => "0x1020000C";
use constant ERRCODE_FILE_IS_NOT_ON_SXFS                    => "0x1020000D";

use constant ERRCODE_FAILED_TO_GET_USER_NAME_FOR_SHARE_MODE => "0x10200010";
use constant ERRCODE_DMAPI_WAS_USED                         => "0x10200011";

use constant ERRCODE_FAILED_TO_CHECK_OUT_DIR_ACCESS_CONF_FILE =>"0x10200012";
use constant ERRCODE_FAILED_TO_CHECK_IN_DIR_ACCESS_FILE     => "0x10200013";
use constant ERRCODE_FAILED_TO_WRITE_DIR_ACCESS_FILE        => "0x10200014";
use constant ERRCODE_USE_ACCESS_CONTROL_FOR_SXFSFW          => "0x10200015";

use constant ERRCODE_DIR_ENTRY_EXIST                        => "0x10200016";
use constant ERRCODE_SET_GLOBALOPTION 						=> "0x10200020";

use constant ERRCODE_GET_DCCONNECTIONSTATUS_NULL            => "0x10200021";
use constant ERRCODE_GET_DCCONNECTIONSTATUS_OPTIONERR       => "0x10200022";
use constant ERRCODE_GET_DCCONNECTIONSTATUS_TIMEOUT         => "0x10200023";

use constant ERRCODE_GETEXPORTGROUP                         => "0x10200024";
use constant ERRCODE_CHANGEENCODING                         => "0x10200025";
use constant ERRCODE_BACKUPSHARECANNOTUSESXFS               => "0x10200026";

use constant ERRCODE_STRING_TOOLONG_BY_EXPORTENCODING       => "0x10200040";

use constant CONST_etcPath => "/etc/group";
use constant CONST_cifsPath => "nas_cifs";
use constant CONST_globalPath => "DEFAULT";
use constant CONST_vsName => "virtual_servers";

use constant CONST_SECURITY_MODE_DOMAIN     => "Domain";
use constant CONST_SECURITY_MODE_ADS        => "ADS";
use constant CONST_SECURITY_MODE_SHARE      => "Share";
use constant CONST_SECURITY_MODE_NIS        => "NIS";
use constant CONST_SECURITY_MODE_PASSWORD   => "Passwd";
use constant CONST_SECURITY_MODE_LDAP       => "LDAP";


use constant COMMAND_SMB_STATUS => "/usr/bin/smbstatus";

use constant COMMAND_DC_PATH      => "/usr/lib/rcli/";
use constant COMMAND_DC_STAT      => "/usr/sbin/nascifsdcstat2";
use constant COMMAND_DC_RECONNECT => "rcli_cifs wb-restart";
use constant DC_LOGFILE_NEW       => "/var/log/nas_cifs.dc.log";
use constant DC_LOGFILE_OLD       => "/var/log/nas_cifs.dc.log.old";

use constant ERRMSG_GETEXPORTGROUP => "Getting export group failed.";
use constant ERRMSG_CHANGEENCODING => "Changing encoding failed.";

use constant CONST_NO_SERVICE_NETWORK => "No service network";
use constant CONST_NO_REMAINING_INTERFACE => "No remaining interface";

sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;         # Connect the hash to the package update.
     return $this;         # Return the reference to the hash.
}

1;
