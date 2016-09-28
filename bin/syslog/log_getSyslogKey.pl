#!/usr/bin/perl -w
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: log_getSyslogKey.pl,v 1.1 2006/07/10 10:04:10 yangxj Exp $"

use strict;

my @keyWordList=`/opt/nec/nsadmin/bin/log_getCategories.pl|grep 'keyword='|cut -d= -f2`;

my $keyString="";
foreach my $keyWord (@keyWordList){
    chomp($keyWord);
    $keyString=$keyString.$keyWord."|";
}
chop($keyString);
print "$keyString";

exit 0;
