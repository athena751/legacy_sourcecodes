#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: rrd2csvCGI.pl,v 1.1 2005/10/19 09:17:04 het Exp $"
use CGI;
use strict;

my $cgi = new CGI;
my $filename = $cgi->param("defaultFile");
my $tmpCsvfile = $cgi->param('tmpCsvfile');
print qq(Content-Type: application/x-csv\r\n);
print qq(Content-Transfer-Encoding: binary\r\n);
print qq(Content-Disposition: attachment; filename=$filename\r\n\r\n);
my $len = length($tmpCsvfile);
$tmpCsvfile = substr($tmpCsvfile,0,$len - 1);
system("cat ${tmpCsvfile}");
system("rm -f ${tmpCsvfile}");
exit;
