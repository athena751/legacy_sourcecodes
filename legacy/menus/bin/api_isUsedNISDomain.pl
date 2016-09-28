#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: api_isUsedNISDomain.pl,v 1.3 2004/03/05 00:42:05 liuyq Exp $"

#Function: 
#   check whether specified nisdomain has been used

#Arguments: 
#   etcPath:     /etc/group[0|1]/ 
#   nisDomain:   nisDomain name
#exit code:
#   0---------succed 
#   1---------failed

use strict;
use NS::ConstForAPI;
use NS::APICommon;

if(scalar(@ARGV) != 2){
    print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my ($etcPath, $nisDomain) = @ARGV;
my $apiCommon = new NS::APICommon;
my $retHashRef = $apiCommon->changeImsDomainResult($etcPath);
if(!defined($retHashRef)){
    print STDERR $apiCommon->error()," Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my %retHash = %{$retHashRef};
my @regions = keys(%retHash);
foreach(@regions){
    if(/^\s*nis:/){
        if(scalar(grep(/^\Q$nisDomain\E$/,@{$retHash{$_}})) !=0){
            print "true\n";
            exit 0;
        }  
    }   
}

print "false\n";
exit 0;


