#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: replication_getSslStatus.pl,v 1.1 2005/09/15 05:29:22 liyb Exp $"
## Function:
##     get whether use SSL to communicate or not
##
## Parameters:
##     none
##  
## Output:
##     STDOUT
##		    on | off
##     STDERR
##          error message and error code
##
## Returns:
##     0 -- success 
##     1 -- failed
use strict;
use NS::ReplicationConst;

my $repliConst = new NS::ReplicationConst;

my $cmd_ssl = $repliConst->CMD_SYNCCONF_SECURITY_SSL;
my @sslContent = `${cmd_ssl} 2>/dev/null`;
if ($? != 0) {
	$repliConst->printErrMsg($repliConst->ERR_EXECUTE_SYNCCONF_SECURITY_SSL, __FILE__, __LINE__ + 1);
	exit 1;
}

if (($sslContent[0] =~ /^\s*Security\s*:\s*(\S+)\s*$/i) 
    || ($sslContent[1] =~ /^\s*ssl\s*:\s*(\S+)\s*$/i)) {
    if($1 =~ /on/i){
        print "on\n";
    } else {
        print "off\n";
    }
} else {
	$repliConst->printErrMsg($repliConst->ERR_NO_SSL_INFO, __FILE__, __LINE__ + 1);
	exit 1;
}

exit 0;