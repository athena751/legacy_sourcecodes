#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: api_getNativeList.pl,v 1.3 2004/01/09 08:22:54 het Exp $"

#Function: 
#   get native domain information

#Arguments: 
#   etcPath: /etc/group[0|1]/ 

#exit code:
#   0---------succed 
#   1---------failed

use strict;
use NS::APICommon;

if(scalar(@ARGV) != 1){
    print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my $etcPath = $ARGV[0];
my $apiCommon = new NS::APICommon;
my $retHashRef = $apiCommon->fillNativeDomainInfo($etcPath,"win");
if(!defined($retHashRef)){
    print STDERR $apiCommon->error()," Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my @kinds = keys(%{$retHashRef});
foreach(@kinds){
    $apiCommon->printDomainInfo($retHashRef,$_);
}
$retHashRef = $apiCommon->fillNativeDomainInfo($etcPath,"unix");
if(!defined($retHashRef)){
    print STDERR $apiCommon->error()," Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
@kinds = keys(%{$retHashRef});
foreach(@kinds){
    $apiCommon->printDomainInfo($retHashRef,$_);
}
exit 0;


