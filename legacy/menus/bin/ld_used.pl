#! /usr/bin/perl
#
#       Copyright (c) 2005-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ld_used.pl,v 1.4 2009/01/05 10:10:34 wanghb Exp $"

use strict;
use NS::NsguiCommon;

my $nsguiCommon     = new NS::NsguiCommon;

my $CMD_PVDISPLAY   = "/sbin/pvdisplay -c 2>/dev/null";
my $CMD_ISADISKLIST = "/opt/nec/nsadmin/sbin/iSAdisklist -d";
my $LDHARDLN_CONF   = "/etc/ldhardln.conf";

my @retPV = `$CMD_PVDISPLAY`;
if ($? != 0){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $targetIP = $nsguiCommon->getFriendIP();
if (defined($targetIP)){
    if ($nsguiCommon->isActive($targetIP) != 0){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
if (defined($targetIP)){
    my $cmds = "sudo $CMD_PVDISPLAY";
    my $ret;
    my $fcontents;
    ($ret,$fcontents) = $nsguiCommon->rshCmdWithSTDOUT ($cmds,$targetIP);
    if (!defined($ret)||($ret!=0)){
	    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	    exit 1;
    }
    push(@retPV, @$fcontents);
}
my %pv=();
foreach(@retPV){
    my @column  = split(/:/, $_);
    my $pvname  = $column[0];
    my $vgname  = $column[1];
    $pvname     =~ s/^\s+|\s+$//g;
    $pv{$pvname}= $vgname;
}
my $vg_assign=&getvgassign($targetIP);
if(!defined($vg_assign)){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $pv_tmp="";
my $vg_tmp="";
foreach(@$vg_assign){
    if(/^\s*(\S+)\s+(.*)/){
        $pv_tmp=$2;
        $vg_tmp=$1;
        my @pv_array  = split(/\s+/, $pv_tmp);
        foreach(@pv_array){
            $_ =~ s/^\s+|\s+$//g;
            if( $_ ne ""){
                $pv{$_} = $vg_tmp;
            }
        }
    }
}
my @retISA = `$CMD_ISADISKLIST`;
if ($? != 0){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my %diskarray = ();
foreach(@retISA){
    if($_ =~ /^\s*([0-9]{4})\s+.*\s+([0-9a-z]{16})\s*$/){
        $diskarray{$2} = $1;
    }
}

my @retConf = `cat $LDHARDLN_CONF`;
foreach(@retConf){
    my @tmpInfo = split(/,/, $_);
    my $ldpath  = $tmpInfo[0];
    my $wwnn    = $tmpInfo[1];
    my $lun     = $tmpInfo[2];
    if (exists $pv{$ldpath} && exists $diskarray{$wwnn}){
        my $aid = $diskarray{$wwnn};
        $pv{$ldpath} = "$aid:$lun:".$pv{$ldpath};
    }
}

foreach(keys %pv){
    if ($pv{$_} ne ""){
        if( $pv{$_} =~ /^\s*\S+:\S+:\S+\s*$/){
            print $pv{$_}."\n";
        }
    }
}

exit 0;

#get the content of /etc/group[0|1]/vg_assign
sub getvgassign(){
    my $friendIP = shift;
    my $nodeNo = $nsguiCommon->getMyNodeNo();
    my $CMD_CAT = "/bin/cat";
    my @vg_assign_content = ();
    my $vg_assign_file = "/etc/group${nodeNo}/vg_assign";
    #get the content of vg_assign from this node
    my $tmp_content = $nsguiCommon->getFileContent(${vg_assign_file});
    if(!defined($tmp_content)){
        return undef;
    }
    @vg_assign_content = @$tmp_content;

    #get the content of vg_assign from another node
    if (defined($friendIP)){
        my $friendNo = 1 - $nodeNo;
        my $vg_assign_file_friend = "/etc/group${friendNo}/vg_assign";
        my $ret = $nsguiCommon->rshCmd("sudo [ -f ${vg_assign_file_friend} ]", $friendIP);
        if (!defined($ret)) {
            return undef;
        }
        if ($ret == 0){
            my ($ret, $vg_assign_friend) = $nsguiCommon->rshCmdWithSTDOUT("sudo $CMD_CAT $vg_assign_file_friend", $friendIP);
            if (!defined($ret) || $ret != 0) {
                return undef;
            }
            push(@vg_assign_content, @$vg_assign_friend);
        }
    }
    return \@vg_assign_content;
}
