#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cluster_sendstaticroute.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

my $host = shift;
my $srcFile = "/etc/sysconfig/static-routes";
my $destFile = "/tmp/static-routes:0";
if ( -f  $srcFile ){
    system("sudo chmod 644 $srcFile");
    if ( system("/usr/bin/rcp -p $srcFile ${host}:$destFile") !=0 ){
        print STDERR "Exec rcp failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

exit 0;

    