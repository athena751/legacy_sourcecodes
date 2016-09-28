#!/usr/bin/perl
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: serverprotect_delConfFile.pl,v 1.4 2007/03/23 05:19:07 qim Exp $"
#Function: 
    #delete the setting of the server protect selected.
#Arguments: 
    #$nodeNum          : the group number 0 or 1
    #$computerName     : the Computer Name
#exit code:
    #0 ---- success
    #1 ---- failure

use strict;
use NS::ServerProtectConst;
use NS::ServerProtectCommon;
my $SPConst  = new NS::ServerProtectConst;
my $SPCommon = new NS::ServerProtectCommon;
if(scalar(@ARGV)!=2){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my ($nodeNum,$computerName) = @ARGV;
my $cmdPath = $SPConst->COMMAND_NVAVS_CONFIG;
my $confFile = $SPCommon->getConfFilePath($nodeNum,$computerName);
my $delRRDFileCmd = "/opt/nec/nsadmin/bin/statis_delNvavsRRDFile.pl";
if((-f $confFile)){
    my $ret = system("$cmdPath -m delete -g $nodeNum -n \Q${computerName}\E 2>/dev/null 1>&2");
    if($ret == 0){
        system("$delRRDFileCmd $computerName 2>/dev/null 1>&2");
        exit 0;
    }else{
	print STDERR "DELETE SETTING ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	exit 1;
    }
}else{
    exit 0;
}

