#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_getbaseinfo.pl,v 1.2302 2008/12/23 03:07:55 gaozf Exp $"

use strict;
if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $nodeNo = shift;
my $groupNo = shift;
my $proftpd_conf = "/etc/group".$nodeNo.".setupinfo/ftpd/proftpd.conf.${groupNo}";
my $proftpd_auth_conf = "/etc/group".$nodeNo.".setupinfo/ftpd/proftpd_auth.conf.${groupNo}";

my $ftpusers = "/etc/group".$groupNo."/ftpusers";


my $bUseFTPService = "no"; # (1)
my $portNumber = "21";  # (2)
my $passiveStart = "36864";
my $passiveEnd = "40960";
my $basMaxConnections = "";  # (3)
my $basIdentdMode ="on"; # shench 2008.11.21 
my $basAccessMode = "ReadWrite";  # (4)
my $basClientMode = "Allow"; # (5)
my $basClientList = ""; # (6)
my $basUseManageLAN = "true"; # (7)
my $authDBType = "";  # (8)
my $authAccessType = "allow"; # (9)
my $authUserList = ""; # (10)
my $authUserMappingMode = "Normal"; # (11)
my $authAnonUserName = "nobody"; # (11)
my $homeDirMode = "AuthDB"; # (12)
my $homeDirName ="%h"; # (12)
my $useAnonFTP = "false"; # (13)
my $anonFTPDir = ""; # (14)
my $anonMaxConnections = ""; # (15)
my $anonAccessMode = "ReadWrite"; # (16)
my $anonClientMode = "Allow";  # (17)
my $anonClientList = ""; # (18)
my $anonUserName = "ftp";
my $anonGroupName = "ftp";

my $content     = &readFile($proftpd_conf);
my $auth        = &readFile($proftpd_auth_conf);

my $user        = &readFile($ftpusers);
my $count = 0;
for($count=0;$count<scalar(@$content);$count++)
{

    if($$content[$count] =~ /^\s*ftp\s+(yes|no)/){
    	$bUseFTPService = $1;
    }elsif($$content[$count] =~ /^\s*Port\s+(\d+)/){
    	$portNumber = $1;
    }elsif($$content[$count] =~ /^\s*PassivePorts\s+(\d+)\s+(\d+)/){
    	$passiveStart = $1;
    	$passiveEnd = $2;
    }elsif($$content[$count] =~ /^\s*MaxClients\s+(\d+|none)/){
        $basMaxConnections = $1;
        if($1 eq "none"){
               $basMaxConnections = "0";
        }
    }elsif($$content[$count] =~ /^\s*IdentLookups\s+(\S*)/){           #shench 2008.11.21
        $basIdentdMode = $1;                                           #shench 2008.11.21
    }elsif($$content[$count] =~ /^\s*<Limit\s+WRITE>/){
        if($$content[$count+1] =~/^\s*DenyAll/){
            $basAccessMode = "ReadOnly";
            $count=$count+2;
        }
    }elsif($$content[$count] =~ /^\s*<Limit\s+LOGIN>/){
        if($$content[$count+1] =~/^\s*(Deny|Allow)All/)
        {
            $basClientMode = $1;
            $count = $count + 2;
        }
        elsif( $$content[$count+1] =~ /^\s*Order\s+(Allow|Deny)/ )
        {
           $basClientMode = $1;
            if ($$content[$count+2] =~ /^\s*(Allow|Deny)\s+from\s+(\S+)/){
            	$basClientList = $2;
            }
            $count = $count + 3;
        }
    }elsif($$content[$count] =~ /^\s*DefaultChdir\s(.+)/){
        if($1 eq "%h")
        {
            $homeDirMode = "AuthDB";
	}else
	{
	    $homeDirMode = "FSSpecify";
        }
        $homeDirName = $1;
        $homeDirName =~ s/\"//g; # remove the "\"" in directory string
#    }elsif($$content[$count] =~ /^\s*<Anonymous\s+(\S+)>/)
    }elsif($$content[$count] =~ /^\s*<Anonymous\s(.+)>/)
    {
        $useAnonFTP = "true";
        $anonFTPDir = $1;
        $anonFTPDir =~ s/\"//g;
        # anon loop
        for(my $index=$count;$index<scalar(@$content);$index++)
        {
            if($$content[$index] =~ /^\s*<\/Anonymous/){
                # the anonomous end
                $count = $index;
                last;
            }elsif($$content[$index] =~ /^\s*MaxClients\s+(\d+|none)/)
            {
                $anonMaxConnections = $1;
                if($1 eq "none"){
                    $anonMaxConnections = "0";
                }
            }elsif($$content[$index] =~ /^\s*<Limit\s+(WRITE|STOR)>/)
            {
                if($1 =~/WRITE/)
                {
                    if($$content[$index+1] =~/^\s*AllowAll/){
                        $anonAccessMode = "ReadWrite";
                        $index=$index+2;
                    }
                    elsif($$content[$index+1] =~/^\s*DenyAll/){
                        $anonAccessMode = "DownloadOnly";
                        $index=$index+2;
                    }
    	        }else{
                    $anonAccessMode = "UploadOnly";
                    $index=$index+5;
                }
            }elsif($$content[$index] =~ /^\s*<Limit\s+LOGIN>/)
            {
                if($$content[$index+1] =~/^\s*(Deny|Allow)All/)
                {
                    $anonClientMode = $1;
                    $index = $index + 2;
                }
                elsif ($$content[$index+1] =~ /^\s*Order\s+(Deny|Allow)/ )
                {
                    $anonClientMode = $1;
                    if($$content[$index+2] =~ /^\s*(Allow|Deny)\s+from\s+(\S+)/){
                    	$anonClientList = $2;
                    }
                    $index = $index + 3;
                }
            }elsif($$content[$index] =~ /^\s*User\s+(.*)/){
                $anonUserName = $1;
                $anonUserName =~ s/\"//g;
            }elsif($$content[$index] =~ /^\s*Group\s+(.*)/){
                $anonGroupName = $1;
                $anonGroupName =~ s/\"//g;
            }
        }# end anon loop

    }elsif($$content[$count] =~ /^\s*#useManageLAN\s+(true|false)/){
        $basUseManageLAN = $1;
    }
}


for(my $count=0; $count<scalar(@$auth); $count++){
    if($$auth[$count] =~ /^#\s*ldap.conf\s*from\s*here\s*/)
    {
        last;
    }elsif ($$auth[$count] =~ /^\s*IMSClientDomain\s+(pwd|nis|dmc|ldu):/)
    {
    	$authDBType = $1; #(8)
    }elsif($$auth[$count] =~ /^\s*IMSAccessMode\s+(Normal|Anonymous)/)
    {
    	$authUserMappingMode = $1; #(11)
    	#2003-10-18 xinghui , for anonymous user name with spaces : "Tom xing"
    }elsif($$auth[$count] =~ /^\s*IMSAnonUser\s+(.*)/){
    	$authAnonUserName = $1; #(11)
    	$authAnonUserName =~ s/\"//g;
    }
}
my $pamd_ftpd_group = "/etc/pam.d/ftpd-group".$groupNo;

my $userMode    = &readFile($pamd_ftpd_group);

for($count=0; $count<scalar(@$userMode); $count++)
{
    if (@$userMode[$count] =~ /^\s*auth\s+required\s+\/lib\/security\/pam_listfile.so\s+item\s*=\s*user\s+sense\s*=\s*(allow|deny)/)
    {
        $authAccessType = $1; #(9)
        last;
    }
}

for(my $count=0; $count<scalar(@$user); $count++)
{
    my $temp_user = $$user[$count];
    chomp($temp_user); #delete last return character
    if($temp_user ne "")
    {
        $authUserList = $authUserList.$temp_user.","; #(10)
    }
}
chop($authUserList); # delete last ","



print $bUseFTPService."\n";
print $portNumber."\n";
print $passiveStart."\n";
print $passiveEnd."\n";
print $basMaxConnections."\n";
print $basIdentdMode."\n"; #shench 2008.11.21
print $basAccessMode."\n";
print $basClientMode."\n";
print $basClientList."\n";
print $basUseManageLAN."\n";
print $authDBType."\n";
print $authAccessType."\n";
print $authUserList."\n";
print $authUserMappingMode."\n";
print $authAnonUserName."\n";
print $homeDirMode."\n";
print $homeDirName."\n";
print $useAnonFTP."\n";
print $anonFTPDir."\n";
print $anonMaxConnections."\n";
print $anonAccessMode."\n";
print $anonClientMode."\n";
print $anonClientList."\n";
print $anonUserName."\n";
print $anonGroupName."\n";



exit 0;

sub readFile(){
    my $filename = shift;
    if(!-f $filename){
        print STDERR "file $filename doesn't exist . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(10);
    }
    if(!open(FILE,$filename)){
        print STDERR "file $filename can't be opened. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    my @content=<FILE>;
    close(FILE);
    return \@content;
}
