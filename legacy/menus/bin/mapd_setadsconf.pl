#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_setadsconf.pl,v 1.9 2006/05/16 01:08:45 liq Exp $"

#Function: 
#   update the smb.conf.<netbios> files name under <path>,
#   which contains "realm=" option, and krb5.conf
#Arguments: 
#   path:     /etc/group[0|1]/nas_cifs/DEFAULT/<ntdomain>/
#   dnsdomain
#   kdcserver
#   dc
#exit code:
#   0---------success 
#   1---------fail

#modified by zhangjx for [nsgui-necas-sv4:15074] on 2006/3/16

use strict;
use NS::MAPDCommon;
use NS::SystemFileCVS;
use NS::ConfCommon;
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $confCommon = new NS::ConfCommon;

if(scalar(@ARGV)!=4 && scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my ($path, $dnsDomain, $kdcServer, $dc) = @ARGV;
if(!defined($dc) || $dc eq ""){
    $dc = "*";   
}
my $MC = new NS::MAPDCommon;
my $KRB5_CONF_FILE = "/etc/krb5.conf";
my $SMB_KEY_PWSERV = "password server";

my @kdcs = ();
my @servers = split(/\s+/, $kdcServer);
foreach (@servers) {
    push(@kdcs, "kdc = $_:88\n");
}

my $smbFiles = $MC->getADSSMBFiles($path);
my $file = "";
foreach $file(@$smbFiles) {
    my @smbContent = `cat ${file} 2>/dev/null`;
    $confCommon->setKeyValue($SMB_KEY_PWSERV, $dc, $MC->SMB_SEC_GLOBAL, \@smbContent);
    $confCommon->setKeyValue($MC->SMB_KEY_REALM, $dnsDomain, $MC->SMB_SEC_GLOBAL, \@smbContent);
   
    if (!$MC->writeFile($file, \@smbContent)) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

my @krbContent = `cat ${KRB5_CONF_FILE} 2>/dev/null`;
if (scalar(@krbContent) == 0) {
    if (!&buildkrb5()) {
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    exit 0;
}

my $newKrbContent = &updateOrAddDNSInfo(
    $dnsDomain, $kdcServer, \@krbContent);
if (!defined($newKrbContent)) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if (defined($newKrbContent) && !$MC->writeFile($KRB5_CONF_FILE, $newKrbContent)) {
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

system("/home/nsadmin/bin/ns_nascifsstart.sh");
system("/usr/lib/rcli/rcli_cifs wb-restart");

exit 0;

sub buildkrb5(){
    if (!-d $path && system("mkdir -p ${path}")) {
        return 0;
    }
    system("touch ${KRB5_CONF_FILE}");
    if (!open(FILE, "| ${cmd_syncwrite_o} ${KRB5_CONF_FILE}")) {
        return 0;
    }
print FILE (<<_EOF_);
[logging]
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log
[libdefaults]
ticket_lifetime = 24000
dns_lookup_realm = false
dns_lookup_kdc = false
[realms]
${dnsDomain} = {
@{kdcs}}
[domain_realm]
.example.com = EXAMPLE.COM
example.com = EXAMPLE.COM
[kdc]
profile = /var/kerberos/krb5kdc/kdc.conf
[pam]
debug = false
ticket_lifetime = 36000
renew_lifetime = 36000
forwardable = true
krb4_convert = false
_EOF_
	if(!close(FILE)){
		return 0;
	}
	return 1;
}

#FUNCTION:
#       update or add the dns server/kerbos server pair
#PARAM:
#       $dnsserver
#       $krbserver
#       $section
#       @content
#RETURN:
#       \@      the new content of the conf file
#       undef   the specify section doesn't exist
sub updateOrAddDNSInfo(){
    my ($dnsDomain, $kdcServer, $tmpContent) = @_;
    my $foundDnsDomain = 0;
    my $foundRealms =0;
    my $realmsIndex = 0;
    my $dnsDomainIndex = 0;

    for (my $i=0; $i<scalar(@$tmpContent); $i++) {
        if($$tmpContent[$i] =~/^\s*\[\s*realms\s*\]\s*$/){
             $foundRealms = 1;
             $realmsIndex = $i;
             next;
        }
        if ($foundRealms
            && $$tmpContent[$i] =~ /^\s*\Q${dnsDomain}\E\s*\=\s*\{\s*$/) {
            $foundDnsDomain = 1;
            $dnsDomainIndex = $i;
            next;
        }
        if ($foundDnsDomain
            && $$tmpContent[$i] =~ /^\s*kdc\s*=\s*[a-zA-Z0-9\.\-\:]*\s*$/) {
            splice(@$tmpContent, $i, 1);
            $i--;
            next;
        }
        if ($foundDnsDomain
            && $$tmpContent[$i] =~/^\s*\}\s*$/) {
            last;
        }
    }
    
    if ($foundRealms) {
        if ($foundDnsDomain) {
            #add new kdcServer in old dnsDomain
            splice(@$tmpContent,$dnsDomainIndex+1,0,@kdcs);
        } else { 
            #add new dnsDomain
            splice(@$tmpContent,$realmsIndex+1,0,
                ("${dnsDomain} = {\n",@kdcs,"}\n"));
        }
        return $tmpContent;
    } else {
        return undef;
    }
}
