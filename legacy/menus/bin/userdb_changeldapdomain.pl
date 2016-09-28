#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_changeldapdomain.pl,v 1.3 2004/11/12 02:36:51 zhangjx Exp $"
#    Function: update ldap infos add update smb.conf.*  that use ldapsam
#
#    Parameter:
#            group number           ----- "0" | "1"
#            ldapServers
#            ldapBasedn
#            ldap mech
#            ldap Usetls
#            ldap bindname
#            ldap cert file
#            ldap UserFilter
#            ldap GroupFilter
#            ldap bindpasswd  ----- from <STDIN>
#
#    Return value:
#           0 , if succeed
#           1 , if failed
#           6 , iptable command failed.
use strict;

if(scalar(@ARGV)!=10){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my ($group_no,     $ldap_hosts,   $ldap_basedn,    $ldap_mech,       $ldap_usetls,
    $ldap_bindname,$ldap_certfile,$ldap_userfilter,$ldap_groupfilter,$ldap_un2dn) = @ARGV;

my      $ldap_bindpasswd = <STDIN>;
chomp($ldap_bindpasswd);
if($ldap_mech eq "Anonymous"){
    $ldap_mech = "SIMPLE";
}


my      $GLOBAL_DIR = "/etc/group${group_no}/nas_cifs/DEFAULT";

#open iptable's ports for ldap host, and update other ldu regions


my $ftp_ret = system("/home/nsadmin/bin/ftp_setLdapInfo.pl",
                    $ldap_hosts,
                    $ldap_basedn,
                    $ldap_mech,
                    $ldap_bindname,
                    $ldap_certfile,
                    "",
                    $ldap_usetls,
                    $ldap_userfilter,
                    $ldap_groupfilter,
                    $ldap_un2dn,
                    "",
                    $group_no,
                    $group_no,
                    "MAPD",
                    $ldap_bindpasswd);
${ftp_ret} = ${ftp_ret} >> 8;

if(${ftp_ret} != 0){
    #if ldap host is invalid, ftp will return 101
    if(${ftp_ret}!=1)
    {
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 6;
    }else{
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}

#update smb.conf.* that use ldapsam,
# call perl writen by xiaobai
system("/home/nsadmin/bin/ftp_ldapSmbConfUpdate.pl",
        $GLOBAL_DIR,
        $ldap_hosts,
        $ldap_usetls,
        $ldap_bindname,
        $ldap_basedn,
        $ldap_userfilter,
        $ldap_mech,
        $ldap_certfile,
        $ldap_bindpasswd);

exit 0;