#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: userdb_changedmcdomain.pl,v 1.2 2005/09/19 08:25:13 fengmh Exp $"

#    Function: when a dmc domain change username/passwd, execute this perl
#
#    Parameter:
#            groupN           ----- "0" | "1"             
#            ntDomain         ----- ntDomain name
#            netbios          ----- ntbios name      
#            user             ----- user name
#            pwd              ----- from <STDIN> 
#
#    Return value:
#           0 , if succeed
#           1 , if failed 

use strict;
use NS::SystemFileCVS;

if(scalar(@ARGV)!=4)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n This script need 3 parameters.\n";
    exit(1);
}

my ($groupN, $user, $ntDomain, $netbios) = @ARGV;
my $pwd = <STDIN>;
chomp($pwd);
my $user_pwd =$user."%".$pwd; 
$ntDomain = uc($ntDomain);
$netbios  = uc($netbios);



my $GLOBAL_DIR = "/etc/group${groupN}/nas_cifs/DEFAULT";
my $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntDomain};
my $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";

my @domain_join_cmd = ("/usr/bin/nascifsjoin","-t","rpc","-j","$ntDomain",
                            "-G","/etc/group$groupN/nas_cifs",
                            "-U","${user_pwd}",
                            "-s",$SMB_CONF_FILE);
my $ret=system(@domain_join_cmd);

if ($ret){
    print STDERR "failed to change User Name or Passwd.\n";
    exit 7;
}
exit 0;