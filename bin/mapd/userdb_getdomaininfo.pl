#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_getdomaininfo.pl,v 1.3 2008/05/09 05:29:23 liq Exp $"

#   Function: get a exportgroup's existed sxfsfw/sxfs domain.
#   parameters:
#              exportgroup --------------- exportgroup Name   eg--"liq"
#              type       --------------- domain type        "sxfsfw" or "sxfs"
#              groupN     --------------- group Number       "0" or "1"
#   Return value:
#              0 , if succeed
#              1 , if failed


use strict;
use NS::MAPDCommon;
use NS::APICommon;
use NS::ConstForAPI;
use NS::FTPCommon;
use NS::NsguiCommon;
use NS::USERDBConst;
use NS::NsguiCommon;
my $comm = new NS::NsguiCommon;

if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong! \n This script need 3 parameters.\n";
    print "Usage: <exportgroup> <sxfs|sxfsfw> <group no>\n";
    exit 1;
}
my $exportgroup = shift;
my $exportshort = $exportgroup;
if ($exportgroup =~ /^\/export\//){
    $exportshort = (split("/",$exportgroup))[2];
}
my $type = shift;
my $groupN = shift;

my $domaintype   ="";
my $region       ="";
my $netbios      ="";
my $ntdomain     ="";
my $nisdomain    ="";
my $nisserver    ="";
my $ludb         ="";
my $ldapserver   ="";
my $basedn       ="";
my $mech         ="";
my $tls          ="";
my $authname     ="";
my $authpwd      ="";
my $ca           ="";
my $ufilter      ="";
my $gfilter      ="";
my $dns          ="";
my $kdcserver    ="";
my $username     ="Administrator";
my $passwd       ="";
my $un2dn        ="n";


my @alldomain=();
my $const = new NS::USERDBConst;
my $tmpcmd;
#Step1: when type="sxfsfw"(windows domain),first get ntdomain and netbios.
my @domain_server=();
my $virtualServer_file= ($const->DIR_NAS_CIFS_DEFAULT)[$groupN]."/virtual_servers";
if ($type eq "sxfsfw"){
    if (-f $virtualServer_file){
        $tmpcmd = $const->CMD_CAT." ".$virtualServer_file;
        @domain_server = `$tmpcmd`;
        #add for the changing of the VS file's format at 2008/05/06
        my $VSFileArray = $comm->getVSContent(\@domain_server);
        @domain_server = @$VSFileArray;
    }

    for ( my $i = 0 ; $i < scalar(@domain_server); $i++ ) {
        chomp($domain_server[$i]);
        if ($domain_server[$i] =~/^\s*\/export\/$exportshort\s+(\S+)\s+(\S+)\s*/) {
            $ntdomain = $1;
            $netbios = $2;
            last;
        }
    }
}

#Step2: get domain info by command "ims_domain -Lv "
my $ims_conf=($const->FILE_IMS_CONF)[$groupN];
my $tmpinfo="";
if (-f $ims_conf){
    $tmpcmd=$const->CMD_IMS_DOMAIN." -Lv"." -c"." $ims_conf 2>/dev/null | grep $exportshort";
    @alldomain = `$tmpcmd`;

    #get the domain info by different type, and set the domain info into $tmpinfo
    #sxfsfw: when domain is nis|ldu|pwd it have "sidprefix=...." as the last parameter.
    for ( my $j = 0 ; $j < scalar(@alldomain); $j++ ) {
        chomp($alldomain[$j]);
        if ($type eq "sxfsfw"){
            if ($alldomain[$j] =~/^\s*(nis|ldu|pwd)(:$exportshort\-\d+)\s+(.+)\s+sidprefix\s*=(S(-\d+)+)\s*$/){
                $region = $1.$2;
                $tmpinfo = $3;
                last;
            }
            if ($alldomain[$j] =~/^\s*(ads|shr|dmc)(:$exportshort\-\d+)\s+(.+)\s*/){
                $region = $1.$2;
                $tmpinfo = $3;
                last;
            }
        }else{
            if ($alldomain[$j] !~/\s+sidprefix\s*=(S(-\d+)+)\s*$/){
                if ($alldomain[$j] =~/^\s*(nis|ldu|pwd)(:$exportshort\-\d+)\s+(.+)\s*/){
                    $region = $1.$2;
                    $tmpinfo = $3;
                    last;
                }
            }
        }
    }
    #divide the $tmpinfo into divided info
    if ($region =~/^shr:/){#shr
        $domaintype="shr";
    }
    if ($region =~/^dmc:/){#dmc
        $domaintype="dmc";
    }

    if ($region =~/^pwd:/){#pwd
        $domaintype="pwd";
        my @tmp=split(/\s/,$tmpinfo);
        if ($tmp[0]=~/^passwd=.+\/(\S+)\/passwd$/){
            $ludb = $1;
        }
    }
    if ($region =~/^ads:/){#ads
        $domaintype="ads";
        my $MC = new NS::MAPDCommon;
        my $path = ($const->DIR_NAS_CIFS_DEFAULT)[$groupN]."/$ntdomain/";
        my    ($dnsDomain, $kdcServer) = $MC->getADSConf($path);
        if (defined($dnsDomain) && defined($kdcServer)) {
            $dns  = $dnsDomain;
            $kdcserver = $kdcServer;
        }else{# get DNS Domain and KDC from friend node
            my $nsgui = new NS::NsguiCommon;
            my $friendIP = $nsgui->getFriendIP();
            my $ret = 0;
            my $stdout;
            if(defined($friendIP)){
                my $friend_group_no = 1 - $groupN;
                my $friend_path =($const->DIR_NAS_CIFS_DEFAULT)[$friend_group_no]."/$ntdomain/";
                ($ret,$stdout)=$nsgui->rshCmdWithSTDOUT("sudo /home/nsadmin/bin/mapd_getadsconf.pl $friend_path",$friendIP);
                if($ret == 0){
                    chomp(@$stdout);
                    $dns = @$stdout[0];
                    $kdcserver = @$stdout[1];
                }

            }
        }
    }
    if ($region =~/^nis:/){#nis
        $domaintype="nis";
        if ($tmpinfo =~/^\s*domain\s*=\s*(\S+)\s*/){
            $nisdomain = $1;
        }
        my $common  = new NS::APICommon();
        my $allnisdomain = $common->getNisDomainServer();
        if(!defined($allnisdomain)){
            exit 1;
        }
        $nisserver = $$allnisdomain{$nisdomain};
    }
    if ($region =~/^ldu:/){#ldap
        $domaintype="ldu";
    }
    #get ldap info
    my $LDAP_CONF = $const->FILE_LDAP_CONF ;
    my $ftpComm    = new NS::FTPCommon;
    my $ldap = $ftpComm->readFile($LDAP_CONF);
    my $userinput_start = scalar(@$ldap);
    #find the userinput start line
    for(my $idx = 0; $idx < scalar(@$ldap) ; $idx ++ ){
        my $line=$$ldap[$idx];
        if($line =~ /^#\s*ldap.conf\s*from\s*here\s*/){
            $userinput_start = $idx;
            last;
        }
    }

    for(my $idx=0; $idx< $userinput_start; $idx++){
        my $line = $$ldap[$idx];
        if($line =~ /^\s*nas_host\s+(\S+.*)/){
        #nas_host host1 host2 host3
            $ldapserver = $1;
        }elsif($line =~ /^\s*nas_basedn\s+(\S+.*)/){
            $basedn = $1;
        }elsif($line =~ /^\s*nas_mech\s+(\S+)/){
            $mech = $1;
        }elsif($line =~ /^\s*nas_bindname\s+(\S+.*)/){
            $authname = $1;
        }elsif($line =~ /^\s*nas_bindpasswd\s(.+)/){
            $authpwd = $1;
        }elsif($line =~ /^\s*nas_usetls\s+(\S+)/){
            if($1 eq "y"){
                $tls = "start_tls";
            }elsif($1 eq "n"){
                $tls = "no";
            }elsif($1 eq "ssl"){
                $tls = "yes";
            }
        }elsif($line =~ /^\s*nas_certfile\s+(\S+)/){
            $ca = $1;
        }elsif($line =~ /^\s*nas_certdir\s+(\S+)/){
            $ca = $1;
        }elsif($line =~ /^\s*nas_pam_filter\s+(.+)/){
            $ufilter = $1;
        }elsif($line =~ /^\s*nas_groupfilter\s+(.+)/){
            $gfilter = $1;
        }elsif($line=~/\s*nas_sasl_auth_id\s+dn\s*/){
            $un2dn = "y";
        }
    }

    if($mech eq "SIMPLE" && $authname eq ""){
        $mech = "Anonymous";
    }
}


print $domaintype."\n";
print $region."\n";
print $netbios."\n";
print $ntdomain."\n";
print $nisdomain."\n";
print $nisserver."\n";
print $ludb."\n";
print $ldapserver."\n";
print $basedn."\n";
print $mech."\n";
print $tls."\n";
print $authname."\n";
print $authpwd."\n";
print $ca."\n";
print $ufilter."\n";
print $gfilter."\n";
print $dns."\n";
print $kdcserver."\n";
print $username."\n";
print $passwd."\n";
print $un2dn."\n";

exit 0;
