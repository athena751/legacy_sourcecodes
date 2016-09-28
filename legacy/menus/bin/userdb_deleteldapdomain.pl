#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_deleteldapdomain.pl,v 1.3 2006/02/20 01:20:46 liq Exp $"
#    Function: update ldap infos add update smb.conf.*  that use ldapsam
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            exportGroup      ----- fullpath of export group
#            domain_type       ----- "sxfs" | "sxfsfw"
#            group No          ----- "0" | "1"
#            ntDomain
#            netbios
#
#    Return value:
#           0 , if succeed
#           1 , ims_domain command failed
#           6 , iptable command failed.
use strict;
use NS::USERDBCommon;
if(scalar(@ARGV)!=7){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my ($isFriend, $export_group,   $domain_type,
    $group_no, $ntdomain,       $netbios,   $ldap_hosts) = @ARGV;

$ntdomain = uc($ntdomain);
$netbios = uc($netbios);

my      $GLOBAL_DIR = "/etc/group${group_no}/nas_cifs/DEFAULT";
my      $IMSCONF_FILE="/etc/group${group_no}/ims.conf";

my $udb_common  = new NS::USERDBCommon();


if(${isFriend} eq "false"){
    #in node 0 , do following 2 steps
    #step1 delete auth

    $udb_common->delExportGroupAuthByType($export_group,$group_no,$domain_type);

    #step2 delete domain defination

    my $domain_region = "";
    while(($domain_region = $udb_common->getEGDomainRegion($export_group,$IMSCONF_FILE,${domain_type})) ne ""){
        system("/usr/bin/ims_domain -D $domain_region -af -c $IMSCONF_FILE");
    }
}


if(($isFriend eq "false") and ($domain_type eq "sxfsfw")){

    $udb_common->delDomainDir($group_no,$export_group,$ntdomain,$netbios);

    # restart xsmbd
    system("/home/nsadmin/bin/ns_nascifsstart.sh");
}


#in node 0 and node 1 do following steps, when domain type is sxfsfw
if($domain_type eq "sxfsfw"){
#delete native domain defination and native
    my $native_region =$udb_common->getNativeRegion($group_no, "$ntdomain+$netbios" , "win" , "ldu");

    if($native_region ne ""){

        system("/usr/bin/ims_native","-D","-n",".","-r","${ntdomain}+${netbios}","-f", "-c","$IMSCONF_FILE");
        system("/usr/bin/ims_domain","-D",$native_region,"-af","-c",$IMSCONF_FILE);
    }
}

#close port for unused ldap hosts by iptable
system("sudo", "-u","nsgui","/home/nsadmin/bin/mapd_deliptable.pl",$ldap_hosts,$group_no);
#run command nsgui_iptables_save.sh
system("/home/nsadmin/bin/nsgui_iptables_save.sh");

exit 0;
