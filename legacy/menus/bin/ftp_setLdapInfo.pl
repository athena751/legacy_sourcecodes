#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ftp_setLdapInfo.pl,v 1.2308 2005/08/29 02:49:21 liq Exp $"

use strict;
use NS::FTPCommon;
use NS::SystemFileCVS;

#check number of the argument,if it isn't 11,exit
my $parameter_count = scalar(@ARGV);
if(($parameter_count!=15) and ($parameter_count!=14))
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#get the parameter
my $ldapServer = shift;
my $ldapBaseDN = shift;
my $ldapAuthType = shift;
my $ldapAuthName = shift;
my $ldapCAFilePath = shift;
my $ldapCAFileDir = shift;
my $ldapUsetls = shift;
my $ldapUserFilter = shift;
my $ldapGroupFilter = shift;
my $ldapUtoa = shift; #add by liq 2004/11/4
my $ldapUserInput = shift; #add by xinghui
my $nodeNo = shift;
my $groupNo = shift;
my $comeFrom = shift; # FTP,MAPD
my $ldapAuthPasswd = "";

if ($parameter_count == 15){
    $ldapAuthPasswd = shift;
}else{
    $ldapAuthPasswd = <STDIN>;
    chomp($ldapAuthPasswd);
}
my $ftpComm    = new NS::FTPCommon;

my $region = "";
#-------------------------------------------------
#GUI should be assure these values must be NOT ""
if($ldapServer eq ""){
    exit 1;
}
if($ldapBaseDN eq ""){
    exit 1;
}
if($ldapAuthType eq ""){
    exit 1;
}
if($ldapUsetls eq ""){
    exit 1;
}
#---------------------------------------------------

my @cmd_adddomain =("/usr/bin/ims_domain","-A","ldu:.ftp-${nodeNo}");

my @cmd_options = ("-o",
                   "host=${ldapServer}",
                   "-o",
                   "basedn=${ldapBaseDN}",
                   "-o",
                   "mech=${ldapAuthType}");

if ($ldapUsetls eq "yes"){
    push(@cmd_options,("-o","useldaps=y"));
}elsif($ldapUsetls eq "start_tls"){
    push(@cmd_options,("-o","usetls=y"));
}else{
    push(@cmd_options,("-o","usetls=n"));
}
if ($ldapUserFilter ne ""){
    push(@cmd_options,("-o","userfilter=${ldapUserFilter}"));
}
if ($ldapGroupFilter ne ""){
    push(@cmd_options,("-o","groupfilter=${ldapGroupFilter}"));
}
if ($ldapAuthName ne ""){
    push(@cmd_options,("-o","bindname=${ldapAuthName}"));

#    $cmd_options .= " -o bindname='${ldapAuthName}'";
}
if ($ldapAuthPasswd ne ""){

    push(@cmd_options,("-o","bindpasswd=${ldapAuthPasswd}"));
#    $cmd_options .= " -o bindpasswd='${ldapAuthPasswd}'";
}
if ($ldapCAFilePath ne ""){
    push(@cmd_options,("-o","certfile=$ldapCAFilePath"));
#    $cmd_options .= " -o certfile=$ldapCAFilePath";
}
if ($ldapCAFileDir ne ""){
    push(@cmd_options,("-o","certdir=$ldapCAFileDir"));
#    $cmd_options .= " -o certdir=$ldapCAFileDir";
}

#$cmd_adddomain .= $cmd_options;
    push(@cmd_adddomain,@cmd_options);

#$cmd_adddomain .= " -f -c /etc/group${groupNo}/ims.conf";
    push(@cmd_adddomain,("-f", "-c", "/etc/group${nodeNo}/ims.conf"));



#ldap.conf from here

my $LDAP_CONF = "/etc/ftpd/proftpd_ldap.conf";

my @ldaparray = ("nas_host $ldapServer\n",
                 "nas_basedn $ldapBaseDN\n",
                 "nas_mech $ldapAuthType\n");

if ($ldapUsetls eq "yes"){
    push(@ldaparray, "nas_usetls ssl\n");
}elsif($ldapUsetls eq "start_tls"){
    push(@ldaparray, "nas_usetls y\n");
}else{
    #"no"
    push(@ldaparray, "nas_usetls n\n");
}
if ($ldapUserFilter ne ""){
    push(@ldaparray, "nas_pam_filter ${ldapUserFilter}\n");
}
if ($ldapGroupFilter ne ""){
    push(@ldaparray, "nas_groupfilter ${ldapGroupFilter}\n");
}

if ($ldapAuthName ne ""){
    push(@ldaparray, "nas_bindname $ldapAuthName\n");
}
if ($ldapAuthPasswd ne ""){
    push(@ldaparray, "nas_bindpasswd $ldapAuthPasswd\n");
}
if ($ldapCAFilePath ne ""){
    push(@ldaparray, "nas_certfile $ldapCAFilePath\n");
}
if ($ldapCAFileDir ne ""){
    push(@ldaparray, "nas_certdir $ldapCAFileDir\n");
}
if ($ldapAuthType eq "DIGEST-MD5" || $ldapAuthType eq "CRAM-MD5"){ 
    if ($ldapUtoa eq "y"){
        push(@ldaparray, "nas_sasl_auth_id dn\n");
    }
}
my @userinput=split(/\n/,${ldapUserInput});
   unshift(@userinput,"# ldap.conf from here");
   push(@userinput,"# ldap.conf to here\n");


#ldap.conf end here





#check region and delete client domain before add domain


#read ldap.conf and find the userinput start line
my $ldap_conf_file = $ftpComm->readFile($LDAP_CONF);
my $userinput_start = scalar(@$ldap_conf_file);

for(my $idx = 0; $idx < scalar(@$ldap_conf_file); $idx ++ ){
    my $line=$$ldap_conf_file[$idx];

    if($line =~ /^#\s*ldap.conf\s*from\s*here\s*/){
        if($comeFrom eq "FTP"){

            splice(@$ldap_conf_file,$idx);  #FTP should call
        }

        $userinput_start = $idx;
        last;
    }
}


    #delete origin settings from ldap.conf
my $old_ldap_hosts = "";
for(my $index = $userinput_start - 1  ;$index>=0 ; $index --){

    my $line=$$ldap_conf_file[$index];


    if($line =~/^\s*nas_host\s+(\S+.*)/){
        $old_ldap_hosts = $1;
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~ /^\s*nas_host\s+/){
        splice(@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_basedn\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_mech\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_bindname\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_bindpasswd\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_usetls\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_certfile\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_certdir\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_pam_filter\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_groupfilter\s+/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
    elsif($line =~/^\s*nas_sasl_auth_id\s+dn\s*/){
        splice (@$ldap_conf_file, $index, 1); # delete line
    }
}
    #delete end here


#read ldap.conf end here


#
#read proftpd_auth.conf and find the old region set before

my $PROFTPD_AUTHFILE = "/etc/group${nodeNo}.setupinfo/ftpd/proftpd_auth.conf.${groupNo}";

my @imsclientdomain = ("IMSClientDomain ldu:.ftp-${groupNo}\n",
                       "nas_authtype LDAP\n");

my $auth_file;
if($comeFrom  eq "FTP"){
    $auth_file = $ftpComm->readFile($PROFTPD_AUTHFILE);

    for(my $idx = scalar(@$auth_file) -1; $idx >= 0; $idx--){
        my $line = $$auth_file[$idx];

        if($line =~ /^\s*IMSClientDomain\s+(\S+)/){
            #get the old region from conf file
            $region = $1;
            splice(@$auth_file,$idx,1);
        }elsif($line =~ /^\s*nas_authtype\s+/){
            splice(@$auth_file,$idx,1);
        }
    }

}
#read proftpd_auth.conf end here
#



splice(@$ldap_conf_file, 0, 0, @ldaparray); # add line on the head of file
#add line in ldap.conf file,FTP need add userinput lines

if($comeFrom eq "FTP"){
    push(@$ldap_conf_file,join("\n",@userinput));
}



#close ports used by ldap hosts
if($old_ldap_hosts ne ""){
    my @ldap_host = split(/\s+/,$old_ldap_hosts);

    for(my $idx =0 ; $idx < scalar(@ldap_host); $idx ++){
        my $one_host = $ldap_host[$idx];

        $one_host =~ s/:.*$//g;

        if($one_host ne ""){
            my $cmd = "/home/nsadmin/bin/nsgui_iptables.sh -D -s '${one_host}' -- -389/tcp -389/udp -636/tcp -636/udp";
            if(system($cmd)!=0){
                #??? ignore error
            };
        }


    }

}

#open ports used by new ldap hosts

my @new_ldap_host = split(/\s+/,$ldapServer);

for(my $idx =0 ; $idx < scalar(@new_ldap_host); $idx ++){
    my $one_host = $new_ldap_host[$idx];
    $one_host =~ s/:.*$//g;


    if($one_host ne ""){
        my $cmd = "/home/nsadmin/bin/nsgui_iptables.sh -A -s '${one_host}' -- -389/tcp -389/udp -636/tcp -636/udp";
        if(system($cmd)!=0){
            #rollback -A operations
            while($idx>0){
                $idx --;
                my $rollback_host = $new_ldap_host[$idx];
                $rollback_host=~ s/:.*$//g;

                my $rollback_cmd = "/home/nsadmin/bin/nsgui_iptables.sh -D -s '${rollback_host}' -- -389/tcp -389/udp -636/tcp -636/udp 2>/dev/null";
                system($rollback_cmd);

            }
            #rollback -D operations
            if($old_ldap_hosts ne ""){
                my @deleted_ldap_host = split(/\s+/,$old_ldap_hosts);

                for(my $j = 0; $j < scalar(@deleted_ldap_host); $j ++){
                    my $deleted_host = $deleted_ldap_host[$j];

                    $deleted_host =~ s/:.*$//g;
                    my $rollback_deleted_cmd = "/home/nsadmin/bin/nsgui_iptables.sh -A -s '${deleted_host}' -- -389/tcp -389/udp -636/tcp -636/udp";
                    system($rollback_deleted_cmd);
                }
            }
            exit 101;#MAPD asked for this exit number
        };
    }


}

#------------------------------------------------------------------------
my $file_op_flag =0;
my $common=new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;

if(!(-f $LDAP_CONF)){

        my $pathname = substr($LDAP_CONF,0,rindex($LDAP_CONF,"/"));

        if (!(-d $pathname)){
            system("mkdir -p $pathname");
        }
        system("touch $LDAP_CONF");
}

my $ret=$common->checkout($LDAP_CONF);

if($ret!=0){
    $file_op_flag = 1;
   print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
}

if($file_op_flag == 0){
    open(FILE, "| ${cmd_syncwrite_o} $LDAP_CONF") ;
    print FILE @$ldap_conf_file;
    if(!close(FILE)){
   	print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
	exit 1;
    };
}


#run ftp_mkldap command
if($file_op_flag == 0){
    if(system("/usr/sbin/ftp_mkldap")){
            $common->rollback($LDAP_CONF);
            $file_op_flag =1;
            print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    }
}
if($file_op_flag == 0){
    $ret=$common->checkin($LDAP_CONF);
    if($ret!=0){
        $common->rollback($LDAP_CONF);
        $file_op_flag =1;
        print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    }
}
#----------------------------------------------------------

if($file_op_flag == 1){
    my @ldap_host = split(/\s+/,$ldapServer);

    for(my $idx =0 ; $idx < scalar(@ldap_host); $idx ++){
        my $one_host = $ldap_host[$idx];
        $one_host =~ s/:.*$//g;
        my $cmd = "/home/nsadmin/bin/nsgui_iptables.sh -D -s '${one_host}' -- -389/tcp -389/udp -636/tcp -636/udp";
        system($cmd);
    }

            #rollback -D operations
    if($old_ldap_hosts ne ""){
        my @deleted_ldap_host = split(/\s+/,$old_ldap_hosts);

        for(my $j = 0; $j < scalar(@deleted_ldap_host); $j ++){
            my $deleted_host = $deleted_ldap_host[$j];

            $deleted_host =~ s/:.*$//g;
            my $rollback_deleted_cmd = "/home/nsadmin/bin/nsgui_iptables.sh -A -s '${deleted_host}' -- -389/tcp -389/udp -636/tcp -636/udp";
            system($rollback_deleted_cmd);
        }
    }
    system("/home/nsadmin/bin/nsgui_iptables_save.sh");
   print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;

}
system("/home/nsadmin/bin/nsgui_iptables_save.sh");

if($comeFrom eq "FTP") {

    if($ftpComm->delAllDomain("ldu",$nodeNo,$groupNo) !=0){
        print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }

    #add domain
    if(system(@cmd_adddomain) != 0){
        print STDERR "Failed . Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        print STDERR @cmd_adddomain."\n";
        exit 1;
    }

}



#update other ldu regions
my $cmd =  "/usr/bin/ims_domain -Lv -c /etc/group${nodeNo}/ims.conf 2>/dev/null |grep ^ldu:|awk -F \" \" '{print \$1}'";

my @all_ldu_regions = `$cmd`;
my $group0_cmd = "grep '^d ldu:' /etc/group0/ims.conf 2>/dev/null";
my $group1_cmd = "grep '^d ldu:' /etc/group1/ims.conf 2>/dev/null";

my @regions_in_group0 = ();
my @regions_in_group1 = ();

if(-f "/etc/group0/ims.conf"){
    @regions_in_group0=`$group0_cmd`;
}
if(-f "/etc/group1/ims.conf"){
    @regions_in_group1=`$group1_cmd`;
}

for(my $idx = 0; $idx < scalar(@all_ldu_regions); $idx ++){
    my $one_region = $all_ldu_regions[$idx];
    chomp($one_region);
    my $sid="";
    my @found_region = grep(/^d\s+\Q$one_region\E\s+/, @regions_in_group0);

    if(scalar(@found_region)>0){
        #if($found_region[0] =~ /\s+\-o\s+sidprefix\s*=\s*(\S+)\s+\#/){
        if($found_region[0] =~ /\s+\-o\s+sidprefix\s*=(S(-\d+)+)\s*(#[^#]*)?$/){
            $sid = $1;
        }else{
            $sid = "";
        }
        my @update_cmd0 =("/usr/bin/ims_domain","-A","-f",${one_region});
        push(@update_cmd0,@cmd_options);

        if($sid ne ""){
        #    $update_cmd0 = "/usr/bin/ims_domain -A -f ${one_region} ${cmd_options} -o sidprefix=${sid} -c /etc/group0/ims.conf";
            push(@update_cmd0,("-o","sidprefix=${sid}"));
        }
        push(@update_cmd0,("-c","/etc/group0/ims.conf"));
        system(@update_cmd0);
    }

    @found_region = grep(/^d\s+\Q$one_region\E\s+/,@regions_in_group1);

    if(scalar(@found_region)>0){
        my @update_cmd1 =("/usr/bin/ims_domain","-A","-f",${one_region});
        push(@update_cmd1,@cmd_options);
        #if($found_region[0] =~ /\s+\-o\s+sidprefix\s*=\s*(\S+)\s+\#/){
        if($found_region[0] =~ /\s+\-o\s+sidprefix\s*=(S(-\d+)+)\s*(#[^#]*)?$/){
            $sid = $1;
        }else{
            $sid = "";
        }

        if($sid ne ""){
            #$update_cmd1 ="/usr/bin/ims_domain -A -f ${one_region} ${cmd_options} -o sidprefix=${sid} -c /etc/group1/ims.conf";
            push(@update_cmd1,("-o","sidprefix=${sid}"));
        }
        push(@update_cmd1,("-c","/etc/group1/ims.conf"));

        system(@update_cmd1);
    }
}

if($comeFrom eq "FTP"){
    splice(@$auth_file, 0, 0, @imsclientdomain); # add line on the head of file
    $ftpComm->writeFile($PROFTPD_AUTHFILE,$auth_file);


    my $pamdconf = "/etc/pam.d/ftpd-group".$groupNo;
    my @pamdcontent = ("auth sufficient /lib/security/pam_ldap.so\n",
                        "auth required /lib/security/pam_deny.so\n",
                        "account required /lib/security/pam_ldap.so\n",
                        "session optional /lib/security/pam_ldap.so\n");
    $ftpComm->writeFile($pamdconf,\@pamdcontent);
}

exit 0;
