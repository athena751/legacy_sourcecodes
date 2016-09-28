#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: api_getNativeDomain.pl,v 1.4 2004/01/09 08:22:54 het Exp $"

#Function: 
#   get native domain information

#Arguments: 
#   etcPath: /etc/group[0|1]/ 
#   NetworkOrNTdomain - network | netdomain 
#   Kind - "win"| "unix


#exit code:
#   0---------succed 
#   1---------failed

use strict;
use NS::APICommon;

if(scalar(@ARGV) != 3){
    print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my ($etcPath,$NetworkOrNTdomain,$kind) = @ARGV;
my $apiCommon = new NS::APICommon;
my $retHashRef = $apiCommon->fillNativeDomainInfo($etcPath,$kind,$NetworkOrNTdomain);
if(!defined($retHashRef)){
    print STDERR $apiCommon->error()," Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my @kinds = keys(%{$retHashRef});
if(scalar(@kinds) == 0){
    exit 0;
}
$apiCommon->printDomainInfo($retHashRef,$kinds[0]);
exit 0;


