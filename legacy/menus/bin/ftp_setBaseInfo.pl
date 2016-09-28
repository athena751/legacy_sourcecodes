#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setBaseInfo.pl,v 1.2301 2008/12/23 03:20:40 gaozf Exp $"

use strict;
use NS::FTPCommon;
use NS::ClusterStatus;

#check number of the argument,if it isn't 3,exit
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number:$ARGV[0] ### $ARGV[1] #### $ARGV[2], of perl script(",__FILE__,") is wrong!\n";
    exit(2);
}

#get the parameter
my $baseinfo = shift;
my $nodeNo = shift;
my $groupNo = shift;
#gaozf 20081127 start
my $passive_start="";
my $passive_stop="";
#end
my $ftpComm    = new NS::FTPCommon;
my $cs = new NS::ClusterStatus;

my $filename = "/etc/group${nodeNo}.setupinfo/ftpd/proftpd.conf.".${groupNo};
#check the current ftp service status
my @infolist = split('\^',$baseinfo);
for(my $i=0; $i<scalar(@infolist) ; $i++){
    $infolist[$i] = $infolist[$i]."\n";
    if($infolist[$i] =~ /^\s*PassivePorts\s+(\d+)\s+(\d+)\s*/){
                $passive_start = $1;
                $passive_stop  = $2;
        }
}

$ftpComm->writeFile($filename,\@infolist);
#gaozf 20081127 start
if ($cs->isCluster()){
    my $friendgroupNo=1-$groupNo;
    my $friendfilename="/etc/group${nodeNo}.setupinfo/ftpd/proftpd.conf.".${friendgroupNo};
    my $content = $ftpComm->readFile($friendfilename);
    for(my $count=0;$count<scalar(@$content);$count++){
        if(@$content[$count]=~/^\s*PassivePorts\s+(\d+)\s+(\d+)\s*/){
            @$content[$count] ="PassivePorts ".$passive_start." ".$passive_stop."\n";
         }
    }
    $ftpComm->writeFile($friendfilename,$content);
}

exit 0;
