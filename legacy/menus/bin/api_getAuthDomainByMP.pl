#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: api_getAuthDomainByMP.pl,v 1.2 2004/01/05 01:33:26 wangw Exp $"

#Function: 
#   get auth domain by mountpoint

#Arguments: 
#   etcPath: /etc/group[0|1]/ 
#   mp:      mountpoint1 mountpoint2 mountpoint3 ...

#exit code:
#   0---------succed 
#   1---------failed

use strict;
use NS::APICommon;
use NS::CodeConvert;

if(scalar(@ARGV) != 2){
    print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my ($etcPath, $mp) = @ARGV;
my $codeConvert = new NS::CodeConvert();
my @mpList = split(/\s+/, $mp);
@mpList = map($codeConvert->hex2str($_),@mpList);
my $apiCommon = new NS::APICommon;
my $retHashRef = $apiCommon->fillAuthDomainInfoByMp($etcPath,\@mpList);
if(!defined($retHashRef)){
    print STDERR $apiCommon->error()," Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my @kinds = keys(%{$retHashRef});
foreach(@kinds){
    print "[$_]\n";
    my @info = @{$$retHashRef{$_}};
    for(my $i = 0; $i < @info; $i++){
        
        print "$info[$i]\n";
    }
}
exit 0;


