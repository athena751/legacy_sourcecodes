#!/usr/bin/perl -w

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ftp_ldapSmbConfUpdate.pl,v 1.2 2004/08/24 14:35:03 liq Exp $"

use strict;
use NS::MAPDCommon;
my $parameter_count = scalar(@ARGV);
if(($parameter_count!=8) and ($parameter_count!=9))
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}


my $smb_confPath =shift;
my $ldapServer = shift;
my $ldapSSL = shift;
my $ldapAdminDN = shift;
my $ldapSuffix = shift;
my $ldapUserFilter = shift;
my $ldapBind = shift;
my $tls_cacert = shift;
my $ldapPassword = "";
if ($parameter_count == 9){
    $ldapPassword = shift;
}else{
    $ldapPassword = <STDIN>;
    chomp($ldapPassword);
}



my $mapdCommon = new NS::MAPDCommon();

my $ldapFiles = $mapdCommon->getLDAPSMBFiles($smb_confPath);
foreach(@$ldapFiles){
    my $result;
    if(&usedEncryptPassword($_) == 1){
        #is LDAPSAM, update the parameters for ldapsam in the file
        $result = $mapdCommon->updateLdapSamPara($_, $ldapServer, $ldapSSL, $ldapAdminDN,
             $ldapSuffix, $ldapUserFilter, $ldapBind, $tls_cacert, $ldapPassword);
    }else{
        #is LDAP, delete the parameters for ldapsam from the file
        $result = $mapdCommon->deleteLdapSamPara($_);
    }
    if($result != 0){
        exit 1;
    }
}
#execute ns_nascifsstart.sh
system("/home/nsadmin/bin/ns_nascifsstart.sh");

exit 0;

sub usedEncryptPassword(){
    my $ldapSmbFile = shift;
    my @encryptInfo = `cat $ldapSmbFile |grep encrypt`;
    foreach(@encryptInfo){
        if(/^\s*encrypt\s*passwords\s*=\s*yes\b/){
            return 1;
        }
    }
    return 0;
}