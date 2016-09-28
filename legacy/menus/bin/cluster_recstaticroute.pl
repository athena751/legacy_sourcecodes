#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cluster_recstaticroute.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"

my $srcFile = "/tmp/static-routes:0";
my $destFile = "/etc/sysconfig/static-routes:0";

if ( -f  $srcFile ){

    if ( system("/bin/cp -p $srcFile $destFile") != 0 ){
        print STDERR "cp failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    
    system("rm -fr $srcFile");
}

exit 0;