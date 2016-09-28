#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: api_getLocalDomain.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"
#Function: 
#   Get exportgroup's ntdomain,netbios and security
#   from file:  /etc/group[0|1]/nas_cifs/DEFAULT/virtual_servers
#               /etc/group[0|1]/nas_cifs/DEFAULT/{ntdomain}/smb.conf.{netbios}

#Parameters: 
#   groupPath -- /etc/group[0|1]/
#   exportgroup -- path whose ntdomain,netbios and security is needed 

#Output:
#   localdomain xxx
#   netbios xxx
#   security xxx

#exit code:
#   0 -- successful 
#   1 -- failed

use strict;
use NS::APICommon;
use NS::ConstForAPI;
if (scalar(@ARGV) != 2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($etcPath,$exportgroup) = @ARGV;
my $common  = new NS::APICommon();
my $const   = new NS::ConstForAPI();
my $allNTDomainAndNetbios = $common->getALLLocalDomainAndNetbios($etcPath);
if(!defined($allNTDomainAndNetbios)){
    print STDERR $common->error();
    exit $const->PERL_ERROR_EXIT_CODE;
}
my $domainAndNetbios = $$allNTDomainAndNetbios{$exportgroup};
if(defined($domainAndNetbios)){
    print $const->STRING_NTDOMAIN_INFO_START," ",$$domainAndNetbios[0]."\n";;
    print $const->STRING_NETBIOS_INFO_START," ",$$domainAndNetbios[1]."\n";
    if($$domainAndNetbios[1] eq ""){
        print $const->STRING_SECURITY_INFO_START," \n";
    }else{
        print $const->STRING_SECURITY_INFO_START," "
                ,$common->getSecurity($etcPath,$$domainAndNetbios[0],$$domainAndNetbios[1])
                ,"\n";
    }
}
exit $const->PERL_SUCCESS_EXIT_CODE;
