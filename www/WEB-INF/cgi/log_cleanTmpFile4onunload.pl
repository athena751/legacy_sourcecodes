#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_cleanTmpFile4onunload.pl,v 1.2 2006/07/05 05:45:29 yangxj Exp $"

use CGI;
use strict;
my $cgi = new CGI;
my $sessionID = $cgi->param("sessionID");
my $tmplogdir = "/var/log/nsgui/logview/$sessionID";
system("sudo /bin/rm -rf $tmplogdir");
print qq(Content-Type: text/html\r\n\r\n<html></html>);
exit 0;