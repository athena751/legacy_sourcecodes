#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_delnisdomain.pl,v 1.1 2004/08/24 14:35:03 liq Exp $"

#    Function: delete nis domain to the specified export group
#              delete auth to direct volumns under the export group
#              if the domain type is sxfsfw, deleter native domain
#
#    Parameter:
#            fstype           ----- "sxfs"|"sxfsfw"
#            eg               ----- fullpath of export group  eg:"/export/zhangjx"
#            g_num            ----- "0" | "1"
#            nisdomain        ----- nisdomain name
#            nisserver        ----- nisserver name or IP
#            ntdomain         ----- domain name
#            netbios          ----- computer name
#            isFriend         ----- "true"|"false"
#
#    Return value:
#            0 , if succeed
#            1 , if failed
#            6 , iptables failed
#            255,parameter failed

use strict;
use NS::SystemFileCVS;
use NS::USERDBCommon;

if(scalar(@ARGV)!=8)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 8 parameters.\n";
    exit(1);
}

my ($fstype, $eg, $g_num, $nisdomain, $nisserver, $ntdomain, $netbios, $isFriend) = @ARGV;
my $udb_common  = new NS::USERDBCommon();
my $export_short = (split(/\/+/, $eg))[2];
my      $GLOBAL_DIR = "/etc/group${g_num}/nas_cifs/DEFAULT";
my      $IMSCONF_FILE="/etc/group${g_num}/ims.conf";

$ntdomain = uc($ntdomain);
$netbios  = uc($netbios);

if(${isFriend} eq "false"){
    #in node 0 , do following 2 steps
    #step1 delete auth

    $udb_common->delExportGroupAuthByType($eg,$g_num,$fstype);
    #step2 delete domain defination
    my $domain_region = "";
    while(($domain_region = $udb_common->getEGDomainRegion($eg,$IMSCONF_FILE,$fstype)) ne ""){
        system("/usr/bin/ims_domain -D $domain_region -af -c $IMSCONF_FILE >&/dev/null");
    }
}

if(($isFriend eq "false") and ($fstype eq "sxfsfw")){
    #in node 0 , only when domain type is sxfsfw, do following 3 steps
    $udb_common->delDomainDir($g_num,$eg,$ntdomain,$netbios);

    # restart xsmbd
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
}

#when domain type is sxfsfw, delete nativate domain on both node
if($fstype eq "sxfsfw"){
#delete native domain defination and native
    my $native_region =$udb_common->getNativeRegion($g_num, ${ntdomain}."+".${netbios} , "win" , "nis");

    if($native_region ne ""){
        system("/usr/bin/ims_domain","-D",$native_region,"-af","-c",$IMSCONF_FILE);
        system("/usr/bin/ims_native","-D","-n",".","-r","${ntdomain}+${netbios}","-f", "-c","$IMSCONF_FILE");
    }
}

#if nisdomain doesn't be used by other export group
#delete nisdomain from yp.conf and unusable nisserver on both node


#/home/nsadmin/bin/mapd_nisdomainusedbynfs.pl /etc/group0/ nisdomain = "yes"|"no"
#/home/nsadmin/bin/api_isUsedNISDomain.pl /etc/group0/ nisdomain  = "true"|"false"
#must be called after ims_domain -D
my @cmd1 = ("/home/nsadmin/bin/api_isUsedNISDomain.pl","/etc/group${g_num}/" ,"$nisdomain");
my $stdout = `@cmd1`;
chomp($stdout);
if(($? == 0) and ($stdout =~ /true/)){ exit 0;}

my @cmd2 = ("/home/nsadmin/bin/mapd_nisdomainusedbynfs.pl","/etc/group${g_num}/" ,"$nisdomain");
$stdout = `@cmd2`;
chomp($stdout);
if(($? == 0) and ($stdout =~ /yes/)){ exit 0;}

system("/home/nsadmin/bin/mapd_delete.pl","/home/nsadmin/bin/nsgui_iptables.sh","/etc/yp.conf",$nisdomain, $nisserver);
system("/home/nsadmin/bin/nsgui_iptables_save.sh");
exit 0;