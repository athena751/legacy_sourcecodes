#!/usr/bin/perl -w
#
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: userdb_deleteserverprotectconf.pl,v 1.4 2008/05/09 00:33:15 liul Exp $"

#Function:
    #delete the server protect configuration file;
#Arguments:
    #computerName: indicates which file to delete
    #nodeNum: 0 or 1, indicates which directory, e.g. /etc/group[0/1].setupinfo
#exit code:
    #0:succeeded
    #1:failed
#output:
    #null.
use strict;
use NS::ServerProtectCommon;

my $spComm = new NS::ServerProtectCommon;

if(scalar(@ARGV)!=2){
    print STDERR "Parameter'number Error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $computerName = shift;
my $nodeNum = shift;

#/etc/group[0/1].setupinfo/nvavs/computerName.nvavs.conf
my $spConfFile = $spComm->getConfFilePath($nodeNum, $computerName);
if (!(-f $spConfFile)) {
    exit 0;
}

#delete /etc/group[0/1].setupinfo/nvavs/computername.nvavs.conf
my $cmd = "/opt/nec/nsadmin/bin/serverprotect_delConfFile.pl";
`$cmd $nodeNum \Q${computerName}\E 2>/dev/null`;

if ($?==0){  
    exit 0;
}else {  
    print STDERR "Failed to delete server protect settings. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}


