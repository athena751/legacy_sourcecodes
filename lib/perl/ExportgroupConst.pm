#!/usr/bin/perl 
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ExportgroupConst.pm,v 1.6 2008/05/09 00:44:36 liul Exp $"

package NS::ExportgroupConst;
use strict;

sub new() {
    my $this = {};    # Create an anonymous hash, and self points to it.
    bless $this;      # Connect the hash to the package update.
    return $this;     # Return the reference to the hash.
}

#Command Constants
use constant CMD_LUDB_ROOT        => "/usr/bin/ludb_admin root";

#File Constants
use constant FILE_MTAB        => "/etc/mtab";

#Error code
use constant ERR_CODE_UNKNOWN               => "0x10600000";
use constant ERR_CODE_PARAMETER_NUM         => "0x10600001";
use constant ERR_CODE_ADD_EXISTED_SELF      => "0x10600002";
use constant ERR_CODE_ADD_EXISTED_PARTNER   => "0x10600003";
use constant ERR_CODE_ADD_EXPORTGROUP_DIR       => "0x10600004";
use constant ERR_CODE_ADD_LUDB_PATH         => "0x10600005";
use constant ERR_CODE_ADD_EXPORTGROUP_IN_PARTNER    => "0x10600006";
use constant ERR_CODE_DELETE_NOT_UMOUNT     => "0x10600007";
use constant ERR_CODE_DELETE_EXPORTGROUP_DIR    => "0x10600008";
use constant ERR_CODE_DELETE_LUDB_PATH      => "0x10600009";
use constant ERR_CODE_DELETE_EXPORTGROUP_IN_PARTNER => "0x1060000A";
use constant ERR_CODE_LIST_EXPORTGROUP      => "0x1060000B";
use constant ERR_CODE_ADD_LUDB_IN_PARTNER    => "0x1060000C";
use constant ERR_CODE_DELETE_LUDB_IN_PARTNER    => "0x1060000D";
use constant ERR_CODE_ADD_EXPORTGROUP_FILE       => "0x1060000E";
use constant ERR_CODE_DELETE_EXPORTGROUP_FILE    => "0x1060000F";
use constant ERR_CODE_DELETE_NFS    =>     "0x10600010";
use constant ERR_CODE_DELETE_SERVERPROTECT    =>     "0x10600011";
use constant ERR_CODE_DELETE_SCHEDULESCAN    =>     "0x10600012";

#Other Constants
use constant STRING_LOWERCASE_EUC_JP    => "euc-jp";
use constant STRING_UPPERCASE_EUC_JP    => "EUC-JP";
use constant STRING_LOWERCASE_SJIS      => "sjis";
use constant STRING_UPPERCASE_SJIS      => "SJIS";
use constant STRING_LOWERCASE_UTF       => "utf8";
use constant STRING_UPPERCASE_UTF       => "UTF-8";
use constant STRING_LOWERCASE_UTF_NFC       => "utf8-nfc";
use constant STRING_UPPERCASE_UTF_NFC       => "UTF8-NFC";
use constant STRING_ISO8859             => "iso8859-1";
use constant STRING_ENGLISH             => "English";

1;
