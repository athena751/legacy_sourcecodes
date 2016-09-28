#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setPwdInfo.pl,v 1.2301 2003/12/25 03:19:51 liqing Exp $"

use strict;
use NS::SystemFileCVS;
use NS::FTPCommon;

#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $ludbName = shift;
my $nodeNo = shift;
my $groupNo = shift;
my $region = "";

my $ftpComm    = new NS::FTPCommon;
my $ludbrootpath  = $ftpComm->getludbRootPath();

my $passwdpath = $ludbrootpath."/.ludb/".$ludbName."/passwd" ;
my $grouppath = $ludbrootpath."/.ludb/".$ludbName."/group" ;
my $shadowpath = $ludbrootpath."/.ludb/".$ludbName."/shadow" ;

my $cmd_adddomain = "/usr/bin/ims_domain -A pwd:.ftp-${nodeNo} -o passwd=$passwdpath -o group=$grouppath ";

if(-f ${shadowpath}){
   $cmd_adddomain .= " -o shadow=$shadowpath ";
}
   $cmd_adddomain .= " -f -c /etc/group${nodeNo}/ims.conf";



my $proftpdauthfile = "/etc/group${nodeNo}.setupinfo/ftpd/proftpd_auth.conf.${groupNo}";
my @imsclientdomain = ("IMSClientDomain  pwd:.ftp-${groupNo}\n",
                       "nas_authtype LUDB\n",
                       "nas_ludbname ${ludbName}\n");
my $pamdconf = "/etc/pam.d/ftpd-group".$groupNo;


#1. add client ims_domain&ims_native
#1.1 check region and delete client domain before add domain

my $regioncontent = $ftpComm->readFile($proftpdauthfile);


my $userinput_start=scalar(@$regioncontent);


for(my $idx = 0; $idx < scalar(@$regioncontent); $idx ++ ){
    my $line=$$regioncontent[$idx];
    if($line =~ /^#\s*ldap.conf\s*from\s*here\s*/){
        $userinput_start = $idx;
        last;
    }
    
}


for(my $index = $userinput_start-1 ;$index>=0 ; $index --){
    my $line=$$regioncontent[$index];
    if ($line =~/^\s*IMSClientDomain\s+(\S+)\s*/){
        $region = $1;
        splice (@$regioncontent, $index, 1); # delete line 
    }elsif($line =~ /^\s*nas_authtype\s+/){
        splice (@$regioncontent, $index, 1); # delete line 
    }elsif($line =~ /^\s*nas_ludbname\s+/){
        splice (@$regioncontent, $index, 1); # delete line         
    }
}

if($ftpComm->delAllDomain("pwd",$nodeNo,$groupNo) !=0){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
  
#1.2 add client domain
if(system($cmd_adddomain) != 0){
    print STDERR "Failed to command \"$cmd_adddomain\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1; 
}
    
#    if(system($cmd_addnative) != 0){
#        print STDERR "Failed to command \"$cmd_addnative\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
#        exit 1; 
#    }

#}


#2. add line in proptpd file
splice(@$regioncontent, 0, 0, @imsclientdomain); # add line

$ftpComm->writeFile($proftpdauthfile,$regioncontent);

#3. write file /etc/pam.d/ftpd-groupNo

my @pamdcontent = ("auth sufficient /lib/security/pam_ims.so likeauth nullok\n",
                   "auth required /lib/security/pam_deny.so\n",
                   "account required /lib/security/pam_ims.so\n",
                   "session required /lib/security/pam_ims.so\n");
            
$ftpComm->writeFile($pamdconf,\@pamdcontent);

exit 0;