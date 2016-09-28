#!/usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: CsarConst.pm,v 1.3 2008/03/06 12:44:35 qim Exp $"

package NS::CsarConst;
use strict;
sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;         # Connect the hash to the package update.
     return $this;         # Return the reference to the hash.
}

use constant CSAR_DIR => "/var/crash/.nsgui";
use constant CSAR_CMD_GET_FULL => "/sbin/csar save -C log --without-summary --nsgui_directory";
use constant CSAR_CMD_GET_SUMMARY => "/sbin/csar save -C log_select --summary --nsgui_directory";
#error hash
my %errorinfo = ();  ###error info for write into notice file

### code page=>error code
$errorinfo{"0"} = "The collection of analysis information has failed. Maybe the node is not running.";
$errorinfo{"1"} = "The collection of analysis information has failed, because it is being edited.";
$errorinfo{"2"} = "The collection of analysis information has failed, because there is no enough available space.";
$errorinfo{"4"} = "The creation of md5sum file has failed.";
$errorinfo{"5"} = "The archive of analysis information collected has failed, because there is no enough available space.";
$errorinfo{"6"} = "The archive of analysis information collected has failed.";
$errorinfo{"7"} = "Cannot copy the analysis information because of the possibility that the node is not running.";
$errorinfo{"8"} = "It has failed to copy analysis information, because there is no enough available space.";
$errorinfo{"9"} = "It has failed to copy analysis information.";

sub getErrorInfo(){
    my ($self, $errCode) = @_;
    return $errorinfo{$errCode};
}

1;
