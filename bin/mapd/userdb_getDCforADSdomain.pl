#!/usr/bin/perl -w
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_getDCforADSdomain.pl,v 1.3 2008/05/09 05:27:41 liq Exp $"

#Function: 
    #get the "passwd server" from smb.conf.%L file
#Arguments: 
    #$groupN       : the group number 0 or 1
    #$fromwhere  : domain|client
    #$exportORdomain  : the exportgroup Name or domain name 
    #(fromwhere=domain this value is exportgroup ; fromwhere=client this value is domain )
#exit code:
    #0:succeed 
    #1:failed
#output:
    #   "\n" | "<passwd server>\n"

use strict;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::USERDBConst;
use NS::MAPDCommon;
use NS::NsguiCommon;

my $cifs = new NS::CIFSCommon;
my $conf = new NS::ConfCommon;
my $const = new NS::USERDBConst;
my $MC = new NS::MAPDCommon;
my $comm = new NS::NsguiCommon;

if( scalar(@ARGV)!= 3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    print "Usage: <group no> <domain|client> <exportgrop name | domain>\n";
    exit 1;
}


my ($groupN, $fromwhere, $exportORdomain)=@ARGV;
my $dcinfo="";
my $smbContent="";

if ($fromwhere eq "domain"){
    my $exportshort=$exportORdomain;
    if ($exportORdomain =~ /^\/export\//){
        $exportshort = (split("/",$exportORdomain))[2];
    }
    
    my @domain_server=();
    my $tmpcmd="";
    my $ntdomain="";
    my $netbios="";
    my $virtualServer_file= ($const->DIR_NAS_CIFS_DEFAULT)[$groupN]."/virtual_servers";
    
    if (-f $virtualServer_file){
        $tmpcmd = $const->CMD_CAT." ".$virtualServer_file;
        @domain_server = `$tmpcmd`;
        
        #add for the changing of the VS file's format at 2008/05/06
        my $VSFileArray = $comm->getVSContent(\@domain_server);
        @domain_server = @$VSFileArray;
    }
    
    for ( my $i = 0 ; $i < scalar(@domain_server); $i++ ) {
        chomp($domain_server[$i]);
        if ($domain_server[$i] =~/^\s*\/export\/$exportshort\s+(\S+)\s+(\S+)\s*/) {
            $ntdomain = $1;
            $netbios = $2;
            last;
        }
    }
    if ($ntdomain ne "" && $netbios ne ""){
        $smbContent = $cifs->getSmbContent($groupN, $ntdomain, $netbios);
    }
    
}else{
    my $path = ($const->DIR_NAS_CIFS_DEFAULT)[$groupN]."/$exportORdomain/";
    my $smbFiles = $MC->getADSSMBFiles($path);
    
    if (scalar(@$smbFiles) == 0) {
        print "$dcinfo\n";
        exit 0;
    }
    my $oneSmb = @$smbFiles[0];
    my @content = `cat ${oneSmb}`;
    $smbContent = \@content;
}

if ($smbContent ne ""){
    $dcinfo = $conf->getKeyValue("password server", "global", $smbContent);
}

if ($dcinfo eq "*"){
    $dcinfo="";
}
print "$dcinfo\n";
exit 0
