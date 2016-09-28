#!/usr/bin/perl
#
#       Copyright (c) 2007-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportgroup_delSPConf.pl,v 1.2 2008/05/09 00:40:27 liul Exp $"

#Function:
    #delete the server protect configuration file;
#Arguments:
    #groupN: 0 or 1
    #exportgroup: exportgroup path, e.g. /export/wanghb
#exit code:
    #0:succeeded
    #1:failed
#output:
    #null.
use strict;

use NS::USERDBConst;
use NS::ExportgroupConst;
use NS::NsguiCommon;

my $const = new NS::USERDBConst;
my $expgrp_const = new NS::ExportgroupConst;
my $nsgui = new NS::NsguiCommon;

if( scalar(@ARGV)!= 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $groupN = shift;
my $export = shift;
my $netbios = "";
my $virtualServer_file= ($const->DIR_NAS_CIFS_DEFAULT)[$groupN]."/virtual_servers";
my @virtualServerContent=();
if (-f $virtualServer_file){
    @virtualServerContent = `/bin/cat $virtualServer_file 2>/dev/null`;
}
my $content = $nsgui->getVSContent(\@virtualServerContent);
foreach(@$content){
    if(/^\s*\Q$export\E\s+\S+\s+(\S+)\s*/){
        $netbios = $1;
    }
}

my $cmd = "/home/nsadmin/bin/userdb_deleteserverprotectconf.pl";
if ( $netbios ne "" ){
    `$cmd \Q${netbios}\E $groupN 2>/dev/null`;
    if ($?!=0){
        print STDERR "Faile to delete server protect settings. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        $nsgui->writeErrMsg($expgrp_const->ERR_CODE_DELETE_SERVERPROTECT);
        exit 1;
    }
}
exit 0;
