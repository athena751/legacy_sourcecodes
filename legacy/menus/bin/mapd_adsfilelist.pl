#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_adsfilelist.pl,v 1.1 2004/01/07 00:49:06 wangli Exp $"

#Function: 
#   get the smb.conf.<netbios> files name under <path>, 
#   which contains "realm=" option, and krb5.conf
#Arguments: 
#   path:     /etc/group[0|1]/nas_cifs/DEFAULT/<ntdomain>/
#Output:
#   the file names
#exit code:
#   0---------success
#   1---------fail

use strict;
use NS::MAPDCommon;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $path = shift;
my $MC = new NS::MAPDCommon;
my $filelist = $MC->getADSSMBFiles($path);
print @$filelist;
exit 0;