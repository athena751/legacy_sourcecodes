#!/usr/bin/perl -w
#
#       Copyright (c) 2001~2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cluster_getCluster.pl,v 1.2302 2008/03/12 02:18:22 zhangjun Exp $"


####add by zj: 4 Single Nvram
my $sn=`/opt/nec/nsadmin/bin/nsgui_isSingleNVRAM.sh`;
exit 0 if ($? != 0); 
chomp $sn;
exit 0 if ($sn eq "0"); # I am single NVRAM model.
####end of add

my $clusterconf = "/etc/nascluster.conf";
my $clusterfile = "/etc/rc.d/init.d/nascluster";

-f $clusterconf or exit 0;

my @content;

my $isCluster = "n";
my $myNodeNo;

if (-f $clusterfile) {
    if (!open(FILE,$clusterfile)) {
        print STDERR "Can't open file $clusterfile. \nExit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    @content=<FILE>;
    close(FILE);
    foreach $thisLine (@content) {
        if ($thisLine =~/^\s*nas_cluster\s*=\s*(\S+)\s*$/i) {
            $isCluster = $1;
        }elsif ($thisLine=~/^\s*nas_cluster_node\s*=\s*(\S+)\s*$/i) {
            $myNodeNo = $1;
        }
    }
}

if ($isCluster ne "n") {
    $isCluster = 1;
}else {
    $isCluster = 0;
}


if (!open(FILE,$clusterconf)) {
    print STDERR "Can't open file $clusterconf. \nExit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
@content=<FILE>;
close(FILE);


my %nodes=();
my $FIP;
my $FMask;
my %No;
foreach $thisLine (@content) {
    # if a blank line?
    if ($thisLine=~/^\s*NODE(\d+)\s*=\s*(\S+)/i) {
        $No{$1} = $1;
        $nodes{$1."name"} = $2;
    }
    elsif ($thisLine=~/^\s*IPADDR(\d+)\s*=\s*(\S+)/i) {
        $No{$1} = $1;
        $nodes{$1."IP"} = $2;
    }
    elsif ($thisLine=~/^\s*IPADDRMASK(\d+)\s*=\s*(\S+)/i) {
        $No{$1} = $1;
        $nodes{$1."mask"} = $2;
    }
    elsif ($thisLine=~/^\s*FIPADDR\s*=\s*(\S+)/i) {
        $FIP = $1;
    }
    elsif ($thisLine=~/^\s*FIPADDRMASK\s*=\s*(\S+)/i) {
        $FMask = $1;
    }
    else {
        next;
    }
}

my $myName = $myNodeNo."name";
my $myIP = $myNodeNo."IP";
my $myMask = $myNodeNo."mask";
unless (exists($nodes{$myName}) && exists($nodes{$myIP}) && exists($nodes{$myMask})) {
    print STDERR "The information of myNode in file $clusterconf is invalid. \nExit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if (!$FIP || !$FMask) {
    print STDERR "Can't find FIPADDR or FIPADDRMASK in file $clusterconf. \nExit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print $FIP ."\n";
print $FMask ."\n";
print delete($No{$myNodeNo})."\n";
print delete($nodes{$myName})."\n";
print delete($nodes{$myIP})."\n";
print delete($nodes{$myMask})."\n";

if (!$isCluster) {
    exit 0;
}

my @otherNodes = keys(%No);
foreach $aKey (@otherNodes) {
    my $nodeName = $aKey."name";
    my $nodeIP = $aKey."IP";
    my $nodeMask = $aKey."mask";
    unless (exists($nodes{$nodeName}) && exists($nodes{$nodeIP}) && exists($nodes{$nodeMask})) {
        print STDERR "The information of Node$aKey in file $clusterconf is invalid. \nExit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    print $aKey . "\n";
    print $nodes{$nodeName} . "\n";
    print $nodes{$nodeIP} . "\n";
    print $nodes{$nodeMask} . "\n";
}
