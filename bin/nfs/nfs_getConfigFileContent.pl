#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nfs_getConfigFileContent.pl,v 1.1 2004/08/09 06:38:27 het Exp $"

#Function: 
    #get the config file content;
#Arguments: 
    #$configFileName       : the name of config file
#exit code:
    #0:succeed 
    #1:failed
#output:
    #content of configure file
    
use strict;
use NS::NFSConst;
use NS::NsguiCommon;
my $comm  = new NS::NsguiCommon;
my $const = new NS::NFSConst;

if(scalar(@ARGV)!=1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $fileName = shift;
if(!-f $fileName){
    system("touch ${fileName}");
}        
system("cat ${fileName}");
exit $?>>8;