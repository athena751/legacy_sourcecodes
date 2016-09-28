#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: statis_createTmpCsvFile.pl,v 1.3 2007/09/04 02:02:55 yangxj Exp $"
use strict;

if(scalar(@ARGV) != 9){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my ($host,$infotype,$start,$end,$resource,$item,$displayMountpoint,$version,$cpName) = @ARGV;
my $home = $ENV{HOME} || (getpwuid($>))[7];
if(!$home){
    print STDERR "Failed to get home directory. Exit in perl script:",
                     __FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $saveDir = "/var/opt/nec/statistics/tmp";
if(!-e $saveDir){
    if(system("mkdir ${saveDir}") != 0){
        print STDERR "Failed to execute \"mkdir ${saveDir}\". Exit in perl script:",
                     __FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
my $tmpCsvname = "${saveDir}/${host}_${infotype}.csv.$$";
system("${home}/bin/statis_rmTmpcsvfile.sh ${tmpCsvname}& > & /dev/null");
my $cmd = "${home}/bin/rrd2csv -s ${start} -e ${end} -v ${version}";
if($displayMountpoint){
    $cmd = "${cmd} -m";
}
if($resource){
    $cmd = "${cmd} -r \Q${resource}\E";
}
if($cpName){
    $cmd = "${cmd} -c ${cpName}";
}
$cmd = "${cmd} -i ${item} -o ${tmpCsvname} ${host} ${infotype}";
my $exitCode = system($cmd);
$exitCode = $exitCode >> 8;
if($exitCode == 0){
    print "$tmpCsvname\n";
    exit 0;
}else{
    exit $exitCode+1;
}