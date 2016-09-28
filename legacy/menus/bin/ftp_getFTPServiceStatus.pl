#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_getFTPServiceStatus.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"


use strict;

my $ftpServiceStatus = "unknown";

my $cmd = "/etc/rc.d/init.d/proftpd status";
my @content = `$cmd`;
if($?){
    print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    if(!-f){
        print STDERR "Command /etc/rc.d/init.d/proftpd doesn't exist!"."\n";
    }
    exit 1;
}

# print ftp service status
for(my $i=0;$i<scalar(@content);$i++){
    if ($content[$i] =~ /^\s*proftpd.+(stopped|running...)$/){
        $ftpServiceStatus = $1;
    }
}
print $ftpServiceStatus."\n";
exit 0;