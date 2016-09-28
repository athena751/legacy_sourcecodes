#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nfs_createTempFile.pl,v 1.1 2004/08/09 12:50:44 het Exp $"

#Function: 
    #save content to target file
#Arguments: 
    #group          : the group number of target file
    #sourceFile       : the file name to be modified.
#exit code:
    #0:succeed 
    #1:failed
    
use strict;
use NS::SystemFileCVS;
use NS::NsguiCommon;
use NS::NFSCommon;
my $comm  = new NS::NsguiCommon;
my $const = new NS::NFSConst;
my $nfsComm = new NS::NFSCommon;

if(scalar(@ARGV) != 1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}     
my ($group) = @ARGV;
my @content = <STDIN>;
my $ret = $nfsComm->saveConfigFile($group,\@content);
if(!defined($ret)){
    exit 1;
}
print $ret,"\n";
exit 0;

    

