#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cluster_activeSync.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"


use strict;
use NS::CIFSCommon;

if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $file = shift;
my $host = shift;
my @tmp;
my $tarName;
my $flag = 0;
my $path;

if($file=~/^\$(\S+)/) {
    my $cifs = new NS::CIFSCommon;
    @tmp = split(":",$1);
    if(scalar(@tmp)==4){
        $path = $cifs->getSmbOrVsName(@tmp,1);
        $file = $cifs->getSmbOrVsName(@tmp,0);
        @tmp = split("/",$file);
        $tarName = pop(@tmp);
    }else{
        $file="";
        push(@tmp, "");
        $path = $cifs->getSmbOrVsName(@tmp,1);
        pop(@tmp);
        $tarName=pop(@tmp);
    }
    $flag = 1;
}else{
    @tmp = split("/",$file);
    $tarName=pop(@tmp);
}

$tarName = "/tmp/sync_".$tarName.".tar.gz";
if($flag){
    $file = $file." ${path}/smbpasswd";
}

system("rsh ${host} sudo rm -f ${tarName}");

if (system("sudo tar Pczf ${tarName} ${file}") != 0) {
    print STDERR "Execute command: tar Pczf ${tarName} ${file} failed:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if (system("/usr/bin/rcp -p ${tarName} ${host}:${tarName}") != 0) {
    system("sudo rm -f ${tarName}");
    exit 1;
}

if (system("sudo rm -f ${tarName}") != 0) {
    exit 1;
}

exit 0;