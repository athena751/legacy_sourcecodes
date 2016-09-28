#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setNisInfo.pl,v 1.2306 2005/08/29 02:49:21 liq Exp $"

use strict;

use NS::FTPCommon;
use NS::SystemFileCVS;

#check number of the argument,if it isn't 3,exit
if(scalar(@ARGV)!=5)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $nisNetwork = shift;
my $nisDomain = shift;
my $nisServer = shift;
my @addServer = split(/\s+/,$nisServer);
my $nodeNo = shift;
my $groupNo = shift;
my $region = "";

my $cmd_adddomain = "/usr/bin/ims_domain -A nis:.ftp-${nodeNo} -o domain=${nisDomain} -f -c /etc/group${nodeNo}/ims.conf";


my $proftpdauthfile = "/etc/group${nodeNo}.setupinfo/ftpd/proftpd_auth.conf.${groupNo}";
my @imsclientdomain = ("IMSClientDomain  nis:.ftp-${groupNo}\n",
                       "nas_authtype NIS\n",
# deleted              "nas_nisnetwork $nisNetwork\n",
                       "nas_nisdomain $nisDomain\n",
                       "nas_nissrv $nisServer\n");

my $pamdconf = "/etc/pam.d/ftpd-group".$groupNo;
my $myconf = "/etc/yp.conf";

my @my_new_line =();
foreach(@addServer){
    push(@my_new_line,"domain $nisDomain server $_ #FTP-${groupNo}\n");
}


my $ftpComm    = new NS::FTPCommon;

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
    }
    elsif($line =~/^\s*nas_authtype\s+/){
        splice (@$regioncontent, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_nisnetwork\s+/){
        splice (@$regioncontent, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_nisdomain\s+/){

        splice (@$regioncontent, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_nissrv\s+/){
        splice (@$regioncontent, $index, 1); # delete line
    }
}

#2. add line in proptpd file
splice(@$regioncontent, 0, 0, @imsclientdomain); # add line



#3. write file /etc/pam.d/ftpd-groupNo

my @pamdcontent = ("auth sufficient /lib/security/pam_ims.so likeauth nullok\n",
                   "auth required /lib/security/pam_deny.so\n",
                   "account required /lib/security/pam_ims.so\n",
                   "session required /lib/security/pam_ims.so\n");




#4. read file /etc/yp.conf
my $ypcontent = $ftpComm->readFile($myconf);

#begin of changhs code!
# before delete old server , add iptables for those server needing adding.
my $cmd = "/home/nsadmin/bin/nsgui_iptables.sh";

my @needAddSrv = ();
my @temp = ();
for(my $j=0;$j<scalar(@addServer);$j++)
{
	@temp = grep(/^\s*domain\s+(\S+)\s+server\s+(\Q$addServer[$j]\E)\s*(#.*)*\s*$/,@$ypcontent);
	if (scalar(@temp) <= 0){
		if (system("${cmd} -A -s $addServer[$j] 512:65535/udp") != 0){
			&delIptable(\@needAddSrv);
			print STDERR "Failed to add iptables for server $addServer[$j] !\n";
			exit 1;
		}
		push(@needAddSrv,$addServer[$j]); # save the added servers(not exist in the ims.conf), it is for rollback.
	}
}

#4.2 delete old domain in yp.conf

my @delete_server=();

for(my $index = scalar(@$ypcontent)-1; ${index}>=0 ; $index--){
    my $line=$$ypcontent[$index];
    if ($line =~/^\s*domain\s+(\S+)\s+server\s+(\S+)\s+\#FTP-${groupNo}/){
        push(@delete_server,$2);
        splice(@$ypcontent, $index ,1);
    }
}

# Add new lines.
push(@$ypcontent, @my_new_line); # add line

#checkout file and write ims.conf.
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if($cvs->checkout($myconf)!=0){
    print STDERR "Failed to checkout \"$myconf\". Exit in perl script:" ,__FILE__," line:",__LINE__+1,".\n";
    &delIptable(\@needAddSrv);
    exit 1;
}

if (!open(OUTPUT,"| ${cmd_syncwrite_o} $myconf")) {
    $cvs->rollback($myconf);
    &delIptable(\@needAddSrv);
    print STDERR "Failed to open file \"$myconf\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print OUTPUT @$ypcontent;
if(!close(OUTPUT)){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
};


#restart ypbind
if(system("/etc/rc.d/init.d/ypbind restart")!=0){
    &delIptable(\@needAddSrv);
    $cvs->rollback($myconf);
    exit 50;
}


#checkin file
if($cvs->checkin($myconf)!=0){
    &delIptable(\@needAddSrv);
    $cvs->rollback($myconf);
    system("/etc/rc.d/init.d/ypbind restart");
    print STDERR "Failed to checkin \"$myconf\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

# in the last , delete iptables, if error occured, ignore it.
for(my $n=0;$n<scalar(@delete_server);$n++){
	@temp = grep(/^\s*domain\s+\S+\s+server\s+\Q$delete_server[$n]\E\s*(#.*)*\s*$/,@$ypcontent);
    if (scalar(@temp)<=0){
        system("${cmd} -D -s $delete_server[$n] 512:65535/udp 2>/dev/null");
	}
}

#end of changhs code!


#xinghui, 2003-09-30
#if($nodeNo eq $groupNo){

if($ftpComm->delAllDomain("nis",$nodeNo,$groupNo) !=0){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}


    #1.2 add client domain
if(system($cmd_adddomain) != 0){
    print STDERR "Failed to command \"$cmd_adddomain\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

$ftpComm->writeFile($proftpdauthfile,$regioncontent);
$ftpComm->writeFile($pamdconf,\@pamdcontent);
exit 0;

sub delIptable(){
	my $tmp = shift;
	my @tempContent = @$tmp;
	foreach (@tempContent){
		system("${cmd} -D -s $_ 512:65535/udp 2>/dev/null");
	}
}
