#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: csar_getLogForBothWithTimeout.pl,v 1.3 2008/04/24 01:20:05 fengmh Exp $"
#Function:  
#   get archive file in one node in 30mins
#Parameters: 
#   logType: full|summary
#Output:
#   errorcode:
#   http:
#   mainInfo:
#   otherInfo:
#
#exit code:
#   0 -- not time out
#   1 -- time out

use strict;
use NS::NsguiCommon;

my $nsgui = new NS::NsguiCommon();

my $SCRIPT_KILL_CHILD = "/opt/nec/nsadmin/bin/nsgui_killchild.pl";
if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $logType = shift;
my $result="";
my $fipNodeNo = `/opt/nec/nsadmin/bin/cluster_getMyNodeNumber.pl`;
if ($? !=0 ){exit 1;}
chomp($fipNodeNo);

my @info=();
eval{
    local $SIG{ALRM} = sub { system($SCRIPT_KILL_CHILD." 15 $$ 2>/dev/null");
                             die("timeout\n"); };
    alarm 30*60;
    @info=`/home/nsadmin/bin/csar_getLogForBoth.pl $logType`;
    $result=$?/256;
    alarm 0;
};
if ($@ eq "timeout\n") {
    $nsgui->writeErrMsg("0x13900${fipNodeNo}ff",__FILE__,__LINE__+1);
    exit 1;
}
if ($result!=0){
    exit 1;
}

chomp(@info);
my $mainresult=shift(@info);
my $otherresult=shift(@info);
my $http=shift(@info);
my $mainOutput=shift(@info);
my $otherOutput=shift(@info);

if ($mainresult eq "b"){
    print"errorcode:\n";
}else{
    print"errorcode:0x13900${fipNodeNo}${otherresult}${mainresult}\n";
}
print"http:$http\n";
print"mainInfo:${mainOutput}\n";
print"otherInfo:${otherOutput}\n";
exit 0;
