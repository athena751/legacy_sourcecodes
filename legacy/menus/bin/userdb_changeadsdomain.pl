#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_changeadsdomain.pl,v 1.4 2006/05/16 01:11:57 liq Exp $"
#    Function: add ads domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            exportGroup      ----- fullpath of export group

#            groupNo          ----- "0" | "1"
#            ntDomain
#            netbios
#
#            dns_domain
#            kdc_server
#            join_username
#            join_passwd      ----- from <STDIN>
#
#    Return value:
#           0 , if succeed
#           1 , ims_domain command failed
#           7 , join domain failed.
use strict;

if(scalar(@ARGV)!= 10){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my ($isFriend,     $export_group,  $group_no,    $ntdomain,
    $netbios,      $dns_domain,    $kdc_server,  $join_username, $dc, $isJoin ) = @ARGV;

$ntdomain = uc($ntdomain);
$netbios  = uc($netbios);

if($kdc_server eq ""){ $kdc_server = $dns_domain;}
$dns_domain = uc($dns_domain);

my      $join_passwd = <STDIN>;
chomp($join_passwd);

my      $GLOBAL_DIR = "/etc/group${group_no}/nas_cifs/DEFAULT";
my      $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntdomain};
my      $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";


#update krb5.conf and other ads smb.conf.<netbios>
if(system("/home/nsadmin/bin/mapd_setadsconf.pl","$DOMAIN_DIR/",$dns_domain,$kdc_server,$dc)){
    print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
if((${isFriend} eq "false") && ($isJoin eq "true")){

    #/usr/bin/nascifsjoin -t ads -j  <domain> -G </etc/groupN/nas_cifs >  -U <user%passwd> -s /etc/groupN/nas_cifs/DEFAULT/domain/smb.conf.netbios
    my @domain_join_cmd = ("/usr/bin/nascifsjoin","-t","ads","-j","$ntdomain",
                            "-G","/etc/group$group_no/nas_cifs",
                            "-U",${join_username}."%".${join_passwd},
                            "-s",$SMB_CONF_FILE);

    if(system(@domain_join_cmd)){
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 7;
    }
}

