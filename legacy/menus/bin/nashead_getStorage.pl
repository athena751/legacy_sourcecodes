#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nashead_getStorage.pl,v 1.1 2004/06/02 12:04:33 liq Exp $"

use strict;
use NS::SystemFileCVS;
use NS::NasHeadCommon;
use NS::NasHeadConst;

my $cvs = new NS::SystemFileCVS;
my $com = new NS::NasHeadCommon;
my $const =  new NS::NasHeadConst;

if(scalar(@ARGV)!=0)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong! \n This script donot need any parameter.\n";
    exit 1;
}
my $home = $ENV{HOME} || "/home/nsadmin";
my $scan_cmd = ${home}."/bin/".$const->PL_DDSCAN_TWONODE_PL;
if(system("sudo $scan_cmd") != 0){
    print STDERR "Failed to execute $scan_cmd",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}


my $cmd_getddmap = $const->CMD_GETDDMAP;
my @cmdresult = `$cmd_getddmap`;
if ($? != 0 ){
    exit 10;
}

my $nicknamefile=$com->getsannickname_conf();
my @nickresult=();
if(-f $nicknamefile){
    @nickresult=`cat $nicknamefile`;
}
my $storageFlag="false";
my @allStorage=();
my $wwnn;
my $model;

FORSTORAGE:for(my $i=0;$i<scalar(@cmdresult);$i++){
    chomp($cmdresult[$i]);
    if ($cmdresult[$i]=~/^### All SANs$/){
        $storageFlag="true";
        next;    
    }
    if($cmdresult[$i]=~/^### All dd devices$/){
        last FORSTORAGE;
    }
    if ($storageFlag eq "true"){
        if ($cmdresult[$i]=~/^(.+),.+,(.+)\s*,.+$/){
            my $name="";
            $wwnn=$1;
            $model=$2;
            foreach(@nickresult){
                if($_=~ /^\s*$wwnn\s*,\s*(.+)\s*/){
                    $name=$1;
                    last;
                }
            }
            push (@allStorage, $wwnn.",".$model.",".$name."\n");
        }
    }
}

foreach(@allStorage){
    print "$_";
}

exit 0;
