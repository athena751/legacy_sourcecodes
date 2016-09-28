#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_getauthinfo.pl,v 1.2303 2004/11/12 02:41:23 liq Exp $"

use strict;
use NS::FTPCommon;
my $ftpComm    = new NS::FTPCommon;

if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $nodeNo = shift;
my $groupNo = shift;

my $authDBType = "";

my $ludbName = "";

my $nisNetwork = "";
my $nisDomain = "";
my $nisServer = "";

my $ntDomain = "";
my $pdcName = "";
my $bdcName = "";

my $ldapServer = "";
my $ldapBaseDN = "";
my $ldapMeth = "";
my $ldapBindName = "";
my $ldapBindPasswd = "";
my $ldapUseTls = "";
my $ldapCertFile = "";
my $ldapCertDir = "";

my $ldapUserFilter = "";
my $ldapGroupFilter = "";
my $ldapUtoa = "n";

my $AUTH_CONF = "/etc/group${nodeNo}.setupinfo/ftpd/proftpd_auth.conf.${groupNo}";
my $LDAP_CONF = "/etc/ftpd/proftpd_ldap.conf";
#readFile allways return the file content
my $auth = $ftpComm->readFile($AUTH_CONF);

my $ldap = $ftpComm->readFile($LDAP_CONF);

my $userinput_start = scalar(@$ldap);

for(my $idx = 0; $idx < scalar(@$auth); $idx ++){
    my $line = $$auth[$idx];
    
    if ($line =~ /^\s*IMSClientDomain\s+(pwd|nis|dmc|ldu):/){
    	$authDBType = $1; #(8)
    }elsif($line =~ /^\s*nas_ludbname\s+(\S+)/){
        $ludbName = $1;
    }elsif($line =~ /^\s*nas_nisnetwork\s+(\S+)/){
        $nisNetwork = $1;
    }elsif($line =~ /^\s*nas_nisdomain\s+(\S+)/){
        $nisDomain = $1;
    }elsif($line =~ /^\s*nas_nissrv\s+(.*)/){
        $nisServer = $1;
    }elsif($line =~ /^\s*nas_ntdomain\s+(\S+)/){
        $ntDomain = $1;
    }elsif($line =~ /^\s*nas_pdc\s+(\S+)/){
        $pdcName = $1;
    }elsif($line =~ /^\s*nas_bdc\s+(\S+)/){
        $bdcName = $1;
    }
         
}

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
        $ldapServer = $1;
    }elsif($line =~ /^\s*nas_basedn\s+(\S+.*)/){
        $ldapBaseDN = $1;
    }elsif($line =~ /^\s*nas_mech\s+(\S+)/){
        $ldapMeth = $1;
    }elsif($line =~ /^\s*nas_bindname\s+(\S+.*)/){
        $ldapBindName = $1;
    }elsif($line =~ /^\s*nas_bindpasswd\s(.+)/){
        $ldapBindPasswd = $1;
    }elsif($line =~ /^\s*nas_usetls\s+(\S+)/){
        if($1 eq "y"){
            $ldapUseTls = "start_tls";
        }elsif($1 eq "n"){
            $ldapUseTls = "no";
        }elsif($1 eq "ssl"){
            $ldapUseTls = "yes";
        }
    }elsif($line =~ /^\s*nas_certfile\s+(\S+)/){
        $ldapCertFile = $1;
    }elsif($line =~ /^\s*nas_certdir\s+(\S+)/){
        $ldapCertDir = $1;
    }elsif($line =~ /^\s*nas_pam_filter\s+(.+)/){
        $ldapUserFilter = $1;
    }elsif($line =~ /^\s*nas_groupfilter\s+(.+)/){
        $ldapGroupFilter = $1;
    }elsif($line =~ /^\s*nas_sasl_auth_id\s+dn\s*$/){
        $ldapUtoa = "y";
    }
}

#don't change the order !!!

if($ldapMeth eq "SIMPLE" && $ldapBindName eq ""){
    $ldapMeth = "Anonymous";
}

print $authDBType."\n";

print $ludbName."\n";

print $nisNetwork."\n";
print $nisDomain."\n";
print $nisServer."\n";

print $ntDomain."\n";
print $pdcName."\n";
print $bdcName."\n";


print $ldapServer."\n";
print $ldapBaseDN."\n";
print $ldapMeth."\n";
print $ldapBindName."\n";
print $ldapBindPasswd."\n";
print $ldapUseTls."\n";
print $ldapCertFile."\n";
print $ldapCertDir."\n";
print $ldapUserFilter."\n";
print $ldapGroupFilter."\n";
print $ldapUtoa."\n";
for(my $idx = $userinput_start + 1; $idx < scalar(@$ldap)-1 ; $idx ++ ){
          
    print    $$ldap[$idx];
  
}
exit 0;