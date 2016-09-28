#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_getdmountlist.pl,v 1.1 2005/06/13 08:07:20 liq Exp $"

#   Function: get a exportgroup's existed sxfsfw/sxfs/all Direct Mountpoint,filetype, and authStatus.
#   parameters: 
#               exportroot --------------- exportgroup Name   eg--"liq"
#               groupN     --------------- group Number       "0" or "1"  
#               whichtype  --------------- filesyetem type        "sxfsfw" | "sxfs" | "all"
#   OUTPUT example:
#               dmount,fstype,hasauth,authtype
#               "/export/liq/win,sxfsfw,y,nis"
#               "/export/liq/unix,sxfs,n,none" 
#   Return value:
#               0 , if succeed
#               1 , if failed


use strict;
use NS::USERDBConst;

my $const = new NS::USERDBConst;

if(scalar(@ARGV)!=3)
{
    print STDERR "Parameter'number Error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $exportroot = $const->DIR_EXPORT.$ARGV[0];
my $groupN = $ARGV[1];
my $whichtype = $ARGV[2];


#get direct mountpoint, and then putted into @dmount.
my $mountfile=$const->FILE_MTAB_CONF;
my @dmount=();
if(!open(INPUT,"$mountfile"))
{
    print STDERR "the $mountfile can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $er=join("",split("/",$exportroot));
while(<INPUT>){
    if(/^\s*#.*/){
        next;
    }elsif($_!~m"$exportroot"){
        next;
    }else{
        my @tmp=split(/\s+/,$_);
        if(scalar(@tmp)>1){
            my @list=split("/",$tmp[1]);
            if((scalar(@list)==4)&&($er eq $list[1].$list[2])){
                my $dm= "/".$list[1]."/"."$list[2]"."/".$list[3];
                push (@dmount, $dm);
            }
        }
    }
}
close(INPUT);
my $tmpcmd;
#get each direct mountpoint filesystem type, and then putted into @fsinfo.
my @fsinfo=();
my $cfstab_file=($const->FILE_CFSTAB_CONF)[$groupN];
my @cfstabinfo= ();
if (-f $cfstab_file){
    $tmpcmd = $const->CMD_CAT." ".$cfstab_file;
    @cfstabinfo=`$tmpcmd`;
}
my @currLine;
for (my $i=0;$i<scalar(@dmount);$i++){
    foreach(@cfstabinfo){
        @currLine  = split(/\s+/,$_);
        if(!defined($currLine[0])){
            shift @currLine;    
        }
        if($currLine[1] eq $dmount[$i]){
            if($currLine[2] eq "syncfs"){
                my @tmp = split(",",$currLine[3]);
                foreach(@tmp){
                    if($_=~/cache_type=/){
                        my $type=substr($_,11,length($_)-1);
                        push (@fsinfo, $dmount[$i].",".$type);
                        last;
                    }
                }
            }else{
                push (@fsinfo, $dmount[$i].",".$currLine[2]);
            }
            last;        
        }
    }
}

#get each direct mountpoint authStatus
my $ims_conf= ($const->FILE_IMS_CONF)[$groupN];
my @dmount_auth=();
my @allauth=();
my $authStatus ;
my $which;
if (-f $ims_conf){
    $tmpcmd = $const->CMD_IMS_AUTH." -Lv"." -c"." $ims_conf";
    @allauth = `$tmpcmd`;    
    if ( $? != 0 ) {
        exit 1;
    }
    for (my $i=0;$i<scalar(@fsinfo);$i++){
        $authStatus = "n";
        $which = "none";
        my @tmp=split(/,/,$fsinfo[$i]);
        my $tmpdm= $tmp[0];
        foreach(@allauth){
            if ($_=~/^\Q$tmpdm\E\s+(ads|dmc|shr|ldu|pwd|nis)\:/){
                $authStatus="y";
                $which=$1;
                last;
            }
        }
        push (@dmount_auth, $fsinfo[$i].",".$authStatus.",".$which);
    }
}else{
    foreach(@fsinfo){
        push (@dmount_auth, $_.",n".",none");
        
    }
}

if ($whichtype eq "all"){
    foreach (@dmount_auth){
        print $_."\n";
    }
}else{
    foreach (@dmount_auth){
        my @tmp=split(/,/,$_);
        if($tmp[1] eq $whichtype){
            print $_."\n";
        }
    }
}

exit 0;

           