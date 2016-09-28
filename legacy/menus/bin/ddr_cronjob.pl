#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ddr_cronjob.pl,v 1.1 2004/08/24 09:47:14 wangw Exp $"

#Function:      execute ddr command
#Parameters:    mv ------ the mv's lvm name. e.g. NV_LVM_VG0
#               rv ------ the rv's lvm name. e.g. NV_RV0_VG0
#               action -- parameters of command
#Output:        none
use strict;
if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
if(index($ARGV[2],"(") > 0){
    $ARGV[2] =~ /^(\w+)\((\w+)\)$/;
    my $commandType = $1;
    my $copyMode = $2;
    if($commandType eq "replicate"){
        if(-f "/usr/sbin/vgrpl_replicate"){
            system("/usr/sbin/vgrpl_replicate -mv $ARGV[0] -rv $ARGV[1] -cpmode $copyMode");
        }
    }else{
        if(-f "/usr/sbin/vgrpl_replicate"){
            system("/usr/sbin/vgrpl_replicate -mv $ARGV[0] -rv $ARGV[1] -cpmode $copyMode");
        }
        if(-f "/usr/sbin/vgrpl_wait"){
            system("/usr/sbin/vgrpl_wait -cond sync -mv $ARGV[0] -rv $ARGV[1]");
        }
        if(-f "/usr/sbin/vgrpl_separate"){
            system("/usr/sbin/vgrpl_separate -mv $ARGV[0] -rv $ARGV[1]");
        }
    }
}else{
    if(-f "/usr/sbin/vgrpl_separate"){
        system("/usr/sbin/vgrpl_separate -mv $ARGV[0] -rv $ARGV[1]");
    }
}
exit 0;