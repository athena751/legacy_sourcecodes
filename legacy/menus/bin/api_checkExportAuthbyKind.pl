#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: api_checkExportAuthbyKind.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"

#Function: 
#   check whether specified kind auth has been set for specified export 

#Arguments: 
#   etcPath:     /etc/group[0|1]/ 
#   exportGroup: export group
#   kind:        
#exit code:
#   0---------succed 
#   1---------failed

use strict;
use NS::APICommon;

if(scalar(@ARGV) != 3){
    print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my ($etcPath, $exportGroup, $kind) = @ARGV;
my $apiCommon = new NS::APICommon;
my $retHashRef = $apiCommon->fillAuthDomainInfoByExGrpKind($etcPath, $exportGroup, $kind);
if(!defined($retHashRef)){
    print STDERR $apiCommon->error()," Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}elsif($retHashRef eq ""){
    print "false\n";
    exit 0;
}
my %retHash = %{$retHashRef};
if(!defined($retHash{$kind})){
    print "false\n";
}else{
    print "true\n";
}
exit 0;


