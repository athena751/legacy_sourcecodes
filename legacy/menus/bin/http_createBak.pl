#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: http_createBak.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
my $CONF_FILE_NAME = shift;
my $CONF_FILE_NAME_BAK = $CONF_FILE_NAME.".bak";

if(not -f ${CONF_FILE_NAME}){
    `touch ${CONF_FILE_NAME} >& /dev/null`;
}
if( -f ${CONF_FILE_NAME}){
    `cp -f ${CONF_FILE_NAME} ${CONF_FILE_NAME_BAK} >& /dev/null`;
}


exit 0;
