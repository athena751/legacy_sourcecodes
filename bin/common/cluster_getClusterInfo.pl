#!/usr/bin/perl  -w
#
#       Copyright (c) 2001-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
 
# "@(#) $Id: cluster_getClusterInfo.pl,v 1.5 2009/03/30 03:47:29 lil Exp $"

#Function: 
#   get the cluster's information.

#Parameters: 
#   none.

#Output:
#   /etc/nascluster.conf file's content. 

#STDERR:
#   none.
# 
#exit code: 0 
use strict;
use NS::NsguiCommon;
my $comm = new NS::NsguiCommon;
my $nsCheckFile = $comm->FILE_NASCLUSTER_CHECK;
my $nsconf = $comm->FILE_NASCLUSTER_CONF;
my $checkCmd = $comm->SCRIPT_CHECK_NODE;

my $nodeType = `$checkCmd 2> /dev/null`;
chomp($nodeType);
if (($nodeType eq "0") || ($nodeType eq "100") || ($nodeType eq "200") 
     || ($nodeType eq "400") || ($nodeType eq "500")){
    ##NV7200GS/7300GS or NV8210 or NV7300S/5300S or NV1-1*/NV3-1*/NV5-1*
    exit 0;  # single Node!;
}

if (!(-e $nsCheckFile) || !(-e $nsconf)){
    exit 1; # is cluster node , but node registered!;
}
my @checkFile = `cat $nsCheckFile`;
my @confile = `cat $nsconf`;
if (grep(/^\s*NAS_CLUSTER\s*=\s*y\s*$/i,@checkFile) <= 0){
    exit 0; #not cluster;
}
print @confile;