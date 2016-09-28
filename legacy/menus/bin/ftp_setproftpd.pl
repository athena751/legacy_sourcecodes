#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setproftpd.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::FTPCommon;

#check number of the argument,if it isn't 1,exit
if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $nodeNo = shift;
my $groupNo = shift;

my $ftpComm    = new NS::FTPCommon;

my $filename1 = "/etc/group".$nodeNo.".setupinfo/ftpd/proftpd.conf.${groupNo}";
my $filename2 = "/etc/group".$nodeNo.".setupinfo/ftpd/proftpd_auth.conf.${groupNo}";
my $filename3 = "/etc/pam.d/ftpd-group".$groupNo;
my $group_user_file = "/etc/group${groupNo}/ftpusers";
my $str = "ftp no\n";
if(!-f $filename1){
    #create file
    my $pathname = substr($filename1,0,rindex($filename1,"/"));
    if (!-d $pathname){
        system("mkdir -p $pathname");
    }
    system("touch $filename1");
    
    my @content = ($str);
    push(@content, "port\t21\n");
    push(@content, "PassivePorts 36864 40960\n");
    push(@content, "MaxClients\tnone\n");
    push(@content, "DefaultChdir\t%h\n");
    push(@content, "<Limit LOGIN>\n");
    push(@content, "AllowAll\n");
    push(@content, "</Limit>\n");

#    push(@content, "#useManageLAN false\n");
    #writting proftpd.0
    $ftpComm->writeFile($filename1,\@content);
    
    #writting proftpd_auth.conf
    my @authMode = ("IMSAccessMode\tNormal\n");
    $ftpComm->writeFile($filename2,\@authMode);
    
    #writting ftpd-groupN
    #create file
    $pathname = substr($filename3,0,rindex($filename3,"/"));
    if (!-d $pathname){
        system("mkdir -p $pathname");
    }
    system("touch $filename3");
    if (!-f group_user_file)
    {
        system("touch ${group_user_file}");
    }
    my @pamd = ("auth required /lib/security/pam_listfile.so item=user sense=allow file=/etc/group".$groupNo."/ftpusers onerr=fail\n");
    $ftpComm->writeFile($filename3,\@pamd);
}else{
    #writting conf file
    my $content = $ftpComm->readFile($filename1);
    
    for(my $index = 0; $index < scalar(@$content); $index++){
        my $line=$$content[$index];
        if ($line =~/^\s*ftp\s+/){
            splice (@$content, $index, 1); # delete line 
        }
    }
    splice (@$content, 0, 0, $str); # add line 
    #writting proftpd.0
    $ftpComm->writeFile($filename1,$content);    
}

exit 0;