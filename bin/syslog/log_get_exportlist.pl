#!/usr/bin/perl -w
#       Copyright (c) 2004 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_get_exportlist.pl,v 1.2 2004/11/22 09:59:55 key Exp $"

#Function: 
    #get the Export list which are set the perform log file
#Arguments: 
    #$fileName       : /etc/group(Group No) /exports
  
#exit code:
    #0:succeed 
    #1:failed
#output:
   #Export1\n Export2\n cc Exportn\n

    
use strict;
use NS::NsguiCommon;
use NS::SyslogConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;



if(scalar(@ARGV)!=1){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my $fileName = shift;
my @exportsFileInfo = `cat $fileName`;
my @result;
foreach (@exportsFileInfo){
    if(/^\s*(\/export\/\S+)\s+[^(]+([(][^)]+[)])/){
        my $exports = $1;
        if( $2 =~ /[,(]\s*profile\s*[,)]/){
            if (!&isExsit($exports)){
               push(@result,$exports);
            }
        }
    }
}

foreach  (@result) {
    print "$_\n";
}

sub isExsit(){
    my $ex= shift;
    foreach(@result){
        if ($_ eq $ex){
            return 1;
        }
    }
    return 0;
}
exit 0;
