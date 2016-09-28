#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: snap_getSchedule.pl,v 1.2301 2004/03/04 09:17:42 liuhy Exp $"


use strict;
use NS::CodeConvert;
#check number of the argument,if it isn't 3,exit
if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $snapCronFile=shift;

if(-f $snapCronFile)
{
    my $cc=new NS::CodeConvert();
    my $mp = shift;
    $mp=$cc->hex2str($mp);
    my $devname = shift;# 2003/07/14 by maojb, xinghui
#   my $mountpoint=" ".$mp." "; #comment out by maojb , xinghui
    # read the content of $snapCronFile, if the cron line is related to mountpoint,output it.
    if(!open(SNAPSHOT_CRONFILE,"$snapCronFile"))
    {
        print STDERR "Open the file \"$snapCronFile\" failed:$!. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    while(<SNAPSHOT_CRONFILE>){
        if(!(/^\s*#.*/)){
            if($_=~ /\s+(\Q${mp}\E|${devname})\s+/){
                print "$_";
            }
        }
    }
    close(SNAPSHOT_CRONFILE);
}
exit(0);

## -------------------END--------------------##
