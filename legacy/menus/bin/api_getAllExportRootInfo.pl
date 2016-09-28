#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: api_getAllExportRootInfo.pl,v 1.3 2004/08/27 05:37:43 xingh Exp $"
#Function:
#   Get all exportgroups' ntdomain,netbios and security
#   from file:  /etc/group[0|1]/nas_cifs/DEFAULT/virtual_servers
#               /etc/group[0|1]/nas_cifs/DEFAULT/{ntdomain}/smb.conf.{netbios}

#Parameters:
#   groupPath -- /etc/group[0|1]/

#Output:
#   exportgroup
#   localdomain xxx
#   netbios xxx
#   security xxx
#   --------------
#   ......

#exit code:
#   0 -- successful
#   1 -- failed

use strict;
use NS::APICommon;
use NS::ConstForAPI;
use NS::ConfCommon;

if (scalar(@ARGV) != 1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $etcPath = shift;
my $common  = new NS::APICommon();
my $const   = new NS::ConstForAPI();
my $cifs    = new NS::ConfCommon();

my $allExportgroups = $common->getExportGroupInfo($etcPath);
my $allNTDomainAndNetbios = $common->getALLLocalDomainAndNetbios($etcPath);
if(!defined($allExportgroups) || !defined($allNTDomainAndNetbios)){
    print STDERR $common->error();
    exit $const->PERL_ERROR_EXIT_CODE;
}
my @allEGKeys = keys(%$allExportgroups);
foreach(@allEGKeys){
    print "$_\n";
    my $domainAndNetbios = $$allNTDomainAndNetbios{$_};
    if(defined($domainAndNetbios)){
        print $const->STRING_NTDOMAIN_INFO_START," ",$$domainAndNetbios[0]."\n";
        print $const->STRING_NETBIOS_INFO_START," ",$$domainAndNetbios[1]."\n";
        my $domainname = $$domainAndNetbios[0];
	    my $computername = $$domainAndNetbios[1];
	    my $smbconffile = "${etcPath}nas_cifs/DEFAULT/${domainname}/smb.conf.${computername}";

        my @smbcontent = ();
        if(-f $smbconffile){ @smbcontent = `cat $smbconffile`;}

        if($$domainAndNetbios[1] eq ""){
            print $const->STRING_SECURITY_INFO_START," \n";
        }else{
            print $const->STRING_SECURITY_INFO_START," "
                    ,$cifs->getKeyValue("security", "global", \@smbcontent)
                    ,"\n";
        }
    }
    print $const->STRING_SEPERATE_SIGN."\n";
}
exit $const->PERL_SUCCESS_EXIT_CODE;
