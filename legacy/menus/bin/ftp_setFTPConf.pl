#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setFTPConf.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::FTPCommon;

#check number of the argument,if it isn't 1,exit
if(scalar(@ARGV)!=1)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $bUseFTPService = shift;

my $ftpComm    = new NS::FTPCommon;




my $filename = "/etc/sysconfig/proftpd";






#if ($bUseFTPService eq "true"){
#    if(system("/etc/rc.d/init.d/proftpd restart") != 0){
#        system("/etc/rc.d/init.d/proftpd stop");  # if restart failed, stop the proftpd
#        print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
#        exit 40;
#    }
#}
#else{
#    system("/etc/rc.d/init.d/proftpd stop");
#}



#write file /etc/sysconfig/proftpd
my $content = $ftpComm->readFile($filename);

if ($bUseFTPService eq "true"){
    for(my $index=0; $index<scalar(@$content); $index++){
        my $line=$$content[$index];
        if ($line =~/^\s*SERVICE\s*=\s*stop\s*/){
            splice (@$content, $index, 1); # delete line "SERVICE=stop"
        }
    }
}
else{
    my $flag = 1;
    for(my $index = 0; $index < scalar(@$content); $index++){
        my $line=$$content[$index];
        if ($line =~/^\s*SERVICE\s*=\s*stop\s*/){
            $flag = 0;
            last;
        }
    }
    if ($flag){
        push(@$content, "SERVICE=stop\n"); # add line "SERVICE=stop"
    }
}
$ftpComm->writeFile($filename,$content);

exit 0;