#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapnative_create_smbdir.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
if( @ARGV!=1 ){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $path     = shift;
if(!(-d $path)){
    if ( system("mkdir -p $path")!=0 ){
        exit 1;
    }
}
my $smbpasswdfile = $path."/smbpasswd";
if (system("touch $smbpasswdfile")!=0) {
    print STDERR "Can't create smbpasswd file.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
exit 0;



