#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: nfs_getAllDetailInfo.pl,v 1.1 2004/09/03 02:41:39 wangw Exp $"

use strict;
use NS::NFSCommon;
use NS::APICommon;
use NS::NFSConst;
if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $common  = new NS::NFSCommon();
my $api     = new NS::APICommon();
my $const   = new NS::NFSConst(); 
my ($exportGroup,$mountpoint,$groupNo) = @ARGV;
#get selected nis domain infos
my ($selectedNisDomain4Unix,$selectedNisDomain4Win);
my $egKeyPart   = ($exportGroup=~/^\/export\/(\S+)$/)?$1:"";
my $etcPath     = "/etc/group${groupNo}/";
my $nisdomainlist = $api->ClassifyDomainFilterAttr($etcPath,"auth");
if(!defined($nisdomainlist)){
    print STDERR $api->error();
    exit 1;
}
my $domainlistRef = $$nisdomainlist{"NISDomain"};
foreach(keys(%$domainlistRef)){
    if(/^\s*nis\s*:\s*${egKeyPart}-\d+\s*$/){
        $selectedNisDomain4Unix = ${$$domainlistRef{$_}}[0];
        last;
    }
}
my $domainlistRef = $$nisdomainlist{"NISDomain4Win"};
foreach(keys(%$domainlistRef)){
    if(/^\s*nis\s*:\s*${egKeyPart}-\d+\s*$/){
        $selectedNisDomain4Win = ${$$domainlistRef{$_}}[0];
        last;
    }
}
#get many infos by mountpoint if mountpoint exists
my ($needAuthDomain,$isSxfsfw,$isSubmount,$clientOptions);
if($mountpoint=~/^\/export/){
    # execute "/usr/bin/ims_auth -Lv -c /etc/group[0|1]/ims.conf"
    # and "mount" command's result
    my $imsResultRef = $common->execCmd(join(" ",$const->COMMAND_IMS_AUTH
                                            ,"${etcPath}ims.conf"));
    if(!defined($imsResultRef)){
        print STDERR $common->error();
        exit 1;
    }
    my $mountResultRef = $common->execCmd("mount");
    if(!defined($mountResultRef)){
        print STDERR $common->error();
        exit 1;
    }
    #get needAuth , isSxfsfw and isSubmount
    my @tmpRef = $common->getInfoOfMP($mountpoint,$mountResultRef,$imsResultRef);
    $isSxfsfw = ($tmpRef[0] eq "sxfsfw")?"true":"false";
    $needAuthDomain = $tmpRef[2]?"false":"true";
    $isSubmount = ($tmpRef[1] && $mountpoint=~/^\/[^\s\/]+\/[^\s\/]+\/[^\s\/]+\/[^\s\/]+/)
                        ?"true":"false";
    #get client and options
    $clientOptions = $common->getClientAndOption($mountpoint,$groupNo);
    if(!defined($clientOptions)){
        print STDERR $common->error();
        exit 1;
    }
}#end of if
#get other infos by exportgroup
my ($needNativeDomain,@nisDomains);
#check the unix's native whether exists 
my $nativeList = $api->getImsNativeResult($etcPath);
if(!defined($nativeList)){
    print STDERR $api->error();
    exit 1;
}
my $unixNativeRef = $$nativeList{"unix"};
$needNativeDomain = (scalar(keys(%$unixNativeRef)) != 0)?"false":"true";
#get nisdoamins' list
if( !open(YP,"/etc/yp.conf") ){
    print STDERR "Failed to open file /etc/yp.conf. Exit in perl script:",
            __FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
foreach(<YP>){
    if (/^\s*domain\s+\S+\s+server\s+\S+\s+#FTP-/) {
        next;
    }elsif (/^\s*domain\s+(\S+)\s+server\s+\S+/) {
        if ($1 ne "localdomain"){
            push(@nisDomains,$1);
        }
    }
}
close(YP);
#filter the not existed nisdomain
if(defined($selectedNisDomain4Unix)){
    if(scalar(grep(/^\Q${selectedNisDomain4Unix}\E$/,@nisDomains))==0){
        $selectedNisDomain4Unix = "";
    }
}
if(defined($selectedNisDomain4Win)){
    if(scalar(grep(/^\Q${selectedNisDomain4Win}\E$/,@nisDomains))==0){
        $selectedNisDomain4Win = "";
    }
}         
#print the info to STDOUT
print "# Directory Information\n","$needAuthDomain\n$isSxfsfw\n$isSubmount\n"
        ,"$selectedNisDomain4Unix\n$selectedNisDomain4Win\n";
foreach(@$clientOptions){
    print "$_\n";
}
print "# Other Information\n","$needNativeDomain\n";
foreach(@nisDomains){
    print "$_\n";
}
exit 0;
