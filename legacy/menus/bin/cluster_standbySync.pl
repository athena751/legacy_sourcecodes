#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cluster_standbySync.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"


use NS::CIFSCommon;
use strict;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $file = shift;
my @tmp;
my $tarName;
my $path;
if($file=~/^\$(\S+)/) {
    my $cifs = new NS::CIFSCommon;
    @tmp = split(":",$1);
    if(scalar(@tmp)==4){
        $file = $cifs->getSmbOrVsName(@tmp,0);
        @tmp = split("/",$file);
        $tarName = pop(@tmp);
    }else{
        $path=$cifs->getSmbOrVsName(@tmp,1);
        $file=$path."/smbpasswd";
        $tarName = pop(@tmp);
    }
}else{
    @tmp = split("/",$file);
    $tarName = pop(@tmp);
}

$tarName = "/tmp/sync_".$tarName.".tar.gz";

if (-e ${tarName}) {
    if (system("rm -rf ${file}") != 0) {
        exit 1;
    }

    if (system("tar Pxzf ${tarName}") != 0) {
        exit 1;
    }

    if (system("rm -f ${tarName}") != 0) {
        exit 1;
    }
} else {
    exit 1;
}

exit 0;