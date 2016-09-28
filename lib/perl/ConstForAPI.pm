#!/usr/bin/perl 
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ConstForAPI.pm,v 1.4 2007/06/28 01:28:31 zhangjx Exp $"


package NS::ConstForAPI;
use strict;

sub new(){
     my $this = {};     # Create an anonymous hash, and self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}

    
use constant YP_CONF_FILE               => "/etc/yp.conf";
use constant STRING_USER                => "user";
use constant STRING_LOWERCASE_EUC_JP    => "euc-jp";
use constant STRING_UPPERCASE_EUC_JP    => "EUC-JP";
use constant STRING_LOWERCASE_SJIS      => "sjis";
use constant STRING_UPPERCASE_SJIS      => "SJIS";
use constant STRING_LOWERCASE_UTF      => "utf8";
use constant STRING_UPPERCASE_UTF      => "UTF8";
use constant STRING_LOWERCASE_UTF_NFC  => "utf8-nfc";
use constant STRING_UPPERCASE_UTF_NFC  => "UTF8-NFC";
use constant STRING_ISO8859             => "iso8859-1";
use constant STRING_ENGLISH             => "English";
use constant STRING_DEFAULT             => "DEFAULT";
use constant STRING_NTDOMAIN_INFO_START => "localdomain";
use constant STRING_NETBIOS_INFO_START  => "netbios";
use constant STRING_SECURITY_INFO_START => "security";
use constant STRING_SECURITY            => "security";
use constant STRING_SEPERATE_SIGN       => "--------------------------";
use constant STRING_SMB_PASSWD_FILE     => "smb passwd file";

#constant for ims command:
use constant IMS_AUTH_CMD       => "ims_auth -Lv -c ";
use constant IMS_NATIVE_CMD     => "ims_native -Lv -c ";
use constant IMS_DOMAIN_CMD     => "ims_domain -Lv -c ";
use constant IMS_FILE           => "ims.conf";


#EXIT CODE
use constant PERL_SUCCESS_EXIT_CODE     => 0;
use constant PERL_ERROR_EXIT_CODE       => 1;
1;
