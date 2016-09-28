#!/usr/bin/perl
#    copyright (c) 2006 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_getNDMPSessionInfo.pl,v 1.4 2006/12/26 01:10:42 qim Exp $"
use strict;
use NS::NDMPCommonV4;
my $common  = new NS::NDMPCommonV4;
if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR\n";
    exit 1;
}
my $sessionFileDir = ${ARGV[0]};
my @fNameArray = `ls -l $sessionFileDir 2>/dev/null | awk '{ if(\$1 ~/^-/)print \$9;}'`;
foreach(@fNameArray){
    my $fName = $sessionFileDir.$_;
    open(SESSION_FILE, $fName);
    my @sessioncontent = <SESSION_FILE>;
    close(SESSION_FILE);
    my %info = ("sessionId","",
                "sessionType","",
                "sessionTypeJob","--",
                "startTime","UNKNOWN",
                "dmaIp","",
                "dataIp","--",
                "dataState","",
                "moverIp","--",
                "moverState","",
                "MBytesTxferred","UNKNOWN",
                "bytesTxferred","UNKNOWN",
                "currentThruput","UNKNOWN",
                "scsiDevice","",
                "tapeDevice","",
                "tapeOpenMode","");
    my $sessionid = $common->getKeyValue("SESSION_ID",\@sessioncontent);
    if(!defined($sessionid)){
        next;
    }else{
        $info{"sessionId"} = $sessionid;
    }
    my $sessiontype = $common->getKeyValue("SESSION_TYPE",\@sessioncontent);
    if(defined($sessiontype)){
        my $sessiontypejob = $sessiontype;
        $sessiontype =~ s/_.*//;
        if($sessiontype ne "LOCAL" && $sessiontype ne "MOVER" && $sessiontype ne "DATA" && $sessiontype ne "IDLE"){
            next;
        }
        $info{"sessionType"} = $sessiontype;
        $sessiontypejob =~ s/LOCAL_{0,1}|MOVER_{0,1}|DATA_{0,1}|IDLE//;
        if($sessiontypejob ne ""){
            $info{"sessionTypeJob"} = $sessiontypejob;
        }
    }else{
        next;
    }
    my $starttime = $common->getKeyValue("START_TIME",\@sessioncontent);
    if(defined($starttime)){
        $starttime =~ s/\..*//;
        if($starttime =~ /^[0-9]+$/){
            my($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime($starttime);
            my $month = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")[$mon];
            $year = $year +1900;
            $info{"startTime"} = $month." ".$day." ".$hour.":".$min.":".$sec." ".$year;
        }
    }
    my $dmaip = $common->getKeyValue("DMA_IP",\@sessioncontent);
    if(defined($dmaip)){
        $info{"dmaIp"} = $dmaip;
    }
    my $dataip = $common->getKeyValue("DATA_IP",\@sessioncontent);
    if(defined($dataip)&&($dataip ne "")){
       $info{"dataIp"} = $dataip;
    }
    if($info{"sessionType"} eq "MOVER"){
        $info{"dataState"} = "--";
    }else{
        my $datastate = $common->getKeyValue("DATA_STATE",\@sessioncontent);
        if(defined($datastate)){
            $info{"dataState"} = $datastate;
        }
    }
    my $moverip = $common->getKeyValue("MOVER_IP",\@sessioncontent);
    if(defined($moverip)&&($moverip ne "")){
       $info{"moverIp"} = $moverip;
    }
    if($info{"sessionType"} eq "DATA"){
        $info{"moverState"} = "--";
    }else{
        my $moverstate = $common->getKeyValue("MOVER_STATE",\@sessioncontent);
        if(defined($moverstate)){
            $info{"moverState"}=$moverstate;
        }
    }
    my $bytestxferred = $common->getKeyValue("BYTES_TXFERRED",\@sessioncontent);
    if(defined($bytestxferred)){
        $bytestxferred =~ s/\..*//;
        if($bytestxferred =~ /^[0-9]+$/){
            my $tmp = $bytestxferred;
            $info{"bytesTxferred"} = $common->getFormatNum($tmp)."(Bytes)";
            $tmp = sprintf("%.0f",$tmp/1024/1024);
            $info{"MBytesTxferred"} = $common->getFormatNum($tmp);
        }
    }
    my $currentthruput = $common->getKeyValue("CURRENT_THRUPUT",\@sessioncontent);
    if(defined($currentthruput)){
        $currentthruput =~ s/\..*//;
        if($currentthruput =~ /^[0-9]+$/){
            $info{"currentThruput"} = $common->getFormatNum($currentthruput)."(Bytes/Sec)";
        }
    }
    my $scsidevice = $common->getKeyValue("SCSI_DEVICE",\@sessioncontent);
    if(defined($scsidevice)){
        $info{"scsiDevice"} = $scsidevice;
    }
    my $tapedevice = $common->getKeyValue("TAPE_DEVICE",\@sessioncontent);
    if(defined($tapedevice)){
        $info{"tapeDevice"} = $tapedevice;
    }
    my $tapeopenmode = $common->getKeyValue("TAPE_OPEN_MODE",\@sessioncontent);
    if(defined($tapeopenmode)){
        $info{"tapeOpenMode"} = $tapeopenmode;
    }
    my @allkeys = keys(%info);
    foreach(@allkeys){
        my $infoVal = $info{$_};
        print $_."=".$infoVal."\n";
    }
}
exit 0;
