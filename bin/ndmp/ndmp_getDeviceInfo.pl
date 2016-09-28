#!/usr/bin/perl
#    copyright (c) 2006 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_getDeviceInfo.pl,v 1.2 2006/10/09 01:26:18 qim Exp $"
use strict;
my $cmd="/opt/nec/ndmp/ndmp_device";
my $parameter="robot";
my @result=`$cmd $parameter 2>/dev/null`;
if($? == 0){
    &printDeviceInfo($parameter, \@result);
}

$parameter="drive";
my @result=`$cmd $parameter 2>/dev/null`;
if($?==0){
    &printDeviceInfo($parameter, \@result);
}
exit 0;

sub printDeviceInfo {
    my ($deviceType, $result) = @_;
    for (@$result) {
        chomp($_);
        my @array = split (/,/, $_);
        my %deviceInfo = ("deviceType","",
                          "deviceName","",
                          "modelName","",
                          "contrlNo","",
                          "channelNo","",
                          "id","",
                          "lun","",
                          "connectionType","",
                          "wwnn","",
                          "wwpn","",
                          "protID","");
        $deviceInfo{"deviceType"} = $deviceType;
        $deviceInfo{"deviceName"} = $array[0];
        $deviceInfo{"modelName"} = $array[1];
        $deviceInfo{"contrlNo"} = $array[2];
        $deviceInfo{"channelNo"} = $array[3];
        $deviceInfo{"id"} = $array[4];
        $deviceInfo{"lun"} = $array[5];
        $deviceInfo{"connectionType"} = $array[6];
        if ($array[6] =~ /^SCSI$/i) {
            $deviceInfo{"wwnn"} = "--";	
            $deviceInfo{"wwpn"} = "--";
            $deviceInfo{"protID"} = "--";            
        } else {
            $deviceInfo{"wwnn"} = $array[7];
            $deviceInfo{"wwpn"} = $array[8];
            $deviceInfo{"protID"} = $array[9];
        }  
        foreach (keys(%deviceInfo)) {
            print "$_=$deviceInfo{$_}\n";
        }        
    } 
    return;     	
}