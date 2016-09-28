#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setproftpdauth.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::FTPCommon;

#check number of the argument,if it isn't 7,exit
if(scalar(@ARGV)!=7)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $authUserMappingMode = shift;
my $authAnonUserName = shift;
my $nodeNo = shift;
my $groupNo = shift;
my $authAccessType = shift;
my $authUserList = shift;
# pwd , nis, ldu, dmc
my $authDBType = shift;


my $ftpComm    = new NS::FTPCommon;

my $proftpdauth = "/etc/group".$nodeNo.".setupinfo/ftpd/proftpd_auth.conf.${groupNo}";
my $pamdconf ;

#changed by xiaochangxing, mail: [nsgui-necas-sv4 1496]
$pamdconf = "/etc/pam.d/ftpd-group".$groupNo;

my $ftpusers = "/etc/group".$groupNo."/ftpusers";

my @auth = ("IMSAccessMode\t".$authUserMappingMode."\n",
# 2003-10-18 xinghui, for anonymous user name with space
#            "IMSAnonUser\t".$authAnonUserName."\n");
            "IMSAnonUser\t\"".$authAnonUserName."\"\n");

my $first_line;
if ($authAccessType ne "deny"){
    $first_line = "auth required /lib/security/pam_listfile.so item=user sense=allow file=/etc/group".$groupNo."/ftpusers onerr=fail\n";
}
else{
    $first_line = "auth required /lib/security/pam_listfile.so item=user sense=deny file=/etc/group".$groupNo."/ftpusers onerr=fail\n";
}

my @userList = split(',', $authUserList);
for(my $i=0; $i<scalar(@userList) ; $i++){
    if($userList[$i] ne ""){
        $userList[$i] = $userList[$i]."\n";
    }
}

#writting auth conf file
my $content = $ftpComm->readFile($proftpdauth);

my $userinput_start=scalar(@$content);



for(my $idx = 0; $idx < scalar(@$content); $idx ++ ){
    my $line=$$content[$idx];
    if($line =~ /^#\s*ldap.conf\s*from\s*here\s*/){
        $userinput_start = $idx;
        last;
    }

}
for(my $index = $userinput_start - 1 ; $index >= 0 ; $index--){
    my $line=$$content[$index];

    if ($line =~/^\s*(IMSAccessMode|IMSAnonUser)\s*/){
        splice (@$content, $index, 1); # delete line

    }
}
splice (@$content, 0, 0, @auth); # add line

$ftpComm->writeFile($proftpdauth,$content);


#writting pam.d conf file
my $pamdcontent = $ftpComm->readFile($pamdconf);

for(my $index = scalar(@$pamdcontent)-1; $index >=0 ; $index--){
    my $line=$$pamdcontent[$index];
    if ($line =~/^\s*auth\s+required\s+\/lib\/security\/pam_listfile.so\s+item=user\s+sense=/){
        splice (@$pamdcontent, $index, 1); # delete line
    }
}
splice (@$pamdcontent, 0, 0, $first_line); # add line

$ftpComm->writeFile($pamdconf,$pamdcontent);


#writting ftpusers file
$ftpComm->writeFile($ftpusers,\@userList);


exit 0;