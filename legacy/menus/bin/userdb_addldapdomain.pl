#!/usr/bin/perl
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: userdb_addldapdomain.pl,v 1.11 2008/05/09 05:35:03 liq Exp $"
#    Function: add ldap domain to the specified export group
#              add auth to direct volumns under the export group
#              if the domain type is sxfsfw, add native domain
#
#    Parameter:
#            isFriend         ----- "true"|"false"
#            exportGroup      ----- fullpath of export group
#            domain_type       ----- "sxfs" | "sxfsfw"
#            groupNo          ----- "0" | "1"
#            ntDomain
#            netbios
#
#            ldapServers
#            ldapBasedn
#            ldapMech
#            ldapUsetls
#            ldapAuthname
#            ldapCAfile
#            ldapUserFilter
#            ldapGroupFilter
#            ldapAuthPasswd  ----- from <STDIN>
#
#    Return value:
#           0 , if succeed
#           1 , ims_domain command failed
#           6 , iptable command failed.
use strict;
use NS::USERDBCommon;
use NS::SystemFileCVS;
use NS::USERDBConst;
use NS::CIFSCommon;
use NS::ScheduleScanCommon;
my $ssComm = new NS::ScheduleScanCommon;
my $cvs = new NS::SystemFileCVS;
my $udb_const = new NS::USERDBConst();
my $cifsCommon = new NS::CIFSCommon;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

if(scalar(@ARGV)!=15)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my ($isFriend,        $export_group, $domain_type,   $group_no,
    $ntdomain,        $netbios,      $ldap_hosts,    $ldap_basedn,
    $ldap_mech,       $ldap_usetls,  $ldap_bindname, $ldap_certfile,
    $ldap_userfilter, $ldap_groupfilter, $ldap_un2dn) = @ARGV;

$ntdomain = uc($ntdomain);
$netbios  = uc($netbios);


my      $ldap_bindpasswd = <STDIN>;
chomp($ldap_bindpasswd);
if($ldap_mech eq "Anonymous"){
    $ldap_mech = "SIMPLE";
}
my $udb_common  = new NS::USERDBCommon();
#sxfsfw only variant
my      $GLOBAL_DIR = "/etc/group${group_no}/nas_cifs/DEFAULT";
my      $VIRTUAL_FILE =${GLOBAL_DIR}."/virtual_servers";
my      $DOMAIN_DIR = ${GLOBAL_DIR}."/".${ntdomain};
my      $SMB_CONF_FILE = ${DOMAIN_DIR}."/smb.conf.${netbios}";
my      $SMBPASSWD_FILE = ${DOMAIN_DIR}."/smbpasswd";
my      $IMSCONF_FILE="/etc/group${group_no}/ims.conf";
my      $sid = "";

#create smb.conf.<netbios> file at node 0 if domain_type if sxfsfw
if((${domain_type} eq "sxfsfw") and (${isFriend} eq "false")){
	# get available interface
    my $interface = "";
    my @toe = $cifsCommon->getUnusedInterfaces($group_no);
    if(scalar(@toe)>0){
        $interface = $toe[0];
    }else{
        print STDERR "There are not any interfaces which can be used. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 8;
    }

    (-d ${DOMAIN_DIR})      || system("mkdir -p ${DOMAIN_DIR}");
    (-f ${SMBPASSWD_FILE})  || system("touch ${SMBPASSWD_FILE}");
    (-f ${VIRTUAL_FILE})    || system("touch ${VIRTUAL_FILE}");

    #get code page for global section in file smb.conf.netbios.
    my $CodePage = $udb_common->getExpgrpCodePage(${group_no},${export_group});

    my $checkDirectHosting = $udb_common->checkDirectHostingForConsistency($group_no);
    # generate the global section content for cifs
    my @global_content = (
        "[global]\n",
        "unix charset = ${CodePage}\n",
        "encrypt passwords = no\n",
        "log file = %L-%m.log\n",
        "log level = 0\n",
        "server string = \"\"\n",
        "deadtime = 15\n"
    );
    
    push(@global_content,$udb_const->ALWAYS_CAP_W2K_SMBS);
    
    if($interface ne ""){
        push(@global_content,"interfaces = ${interface}\n");
        push(@global_content,"bind interfaces only = yes\n");
    }
    push(@global_content,"workgroup = ${ntdomain}\n");
    push(@global_content,"smb passwd file = %r/%D/smbpasswd.%L\n");
    push(@global_content,"nt acl support = yes\n");
    push(@global_content,"pam service name = xsmbd_ldap\n");
    push(@global_content,"security = user\n");
    #Set direct hosting when the direct hosting is set in friend node.
    if($checkDirectHosting eq "yes"){
        push(@global_content,$udb_const->SMB_PORTS);
    }
    #write smb.conf.<netbios>
    open(FILE,"| ${cmd_syncwrite_o} ${SMB_CONF_FILE}");
    print FILE @global_content;
    if(!close(FILE)){
	
        print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

    #write "sid machine prefix" line
    if(system("/usr/bin/smbpasswd -S -g DEFAULT -l ${ntdomain} -L ${netbios} -G /etc/group${group_no}/nas_cifs >&/dev/null"))
    {
        system("rm -f ${SMB_CONF_FILE}");
        print STDERR "failed to build sid. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    };

    #get sid from smb.conf.<netbios>
    $sid = `cat ${SMB_CONF_FILE} | awk -F \"=\" '{if(\$1 ~ /sid machine prefix/) print \$2}'`;
    chomp(${sid});
    $sid =~ s/\s+//g;#trim sid

}#end of domain type equal sxfsfw



#get export group short name /export/public -> public
my @eg = split("/",$export_group);
my $export_short = $eg[2];


#add ldap domain defination
my @cmd_adddomain =("/usr/bin/ims_domain","-A",${export_short},"ldu");
my @cmd_options = ("-o","\Qhost=${ldap_hosts}\E",
                   "-o","\Qbasedn=${ldap_basedn}\E",
                   "-o","\Qmech=${ldap_mech}\E");

if ($ldap_usetls eq "yes")          { push(@cmd_options,("-o","\Quseldaps=y\E"));}
elsif($ldap_usetls eq "start_tls")  { push(@cmd_options,("-o","\Qusetls=y\E"  ));}
else                                { push(@cmd_options,("-o","\Qusetls=n\E"  ));}

if ($ldap_userfilter ne "")         { push(@cmd_options,("-o","\Quserfilter=${ldap_userfilter}\E"));}
if ($ldap_groupfilter ne "")        { push(@cmd_options,("-o","\Qgroupfilter=${ldap_groupfilter}\E"));}
if ($ldap_bindname ne "")           { push(@cmd_options,("-o","\Qbindname=${ldap_bindname}\E"));}
if ($ldap_bindpasswd ne "")         { push(@cmd_options,("-o","\Qbindpasswd=${ldap_bindpasswd}\E")); }
if ($ldap_certfile ne "")           { push(@cmd_options,("-o","\Qcertfile=$ldap_certfile\E"));}


push(@cmd_adddomain,@cmd_options);
#only windows ldap domain need sid
if ($sid ne "")                     { push(@cmd_adddomain,("-o","\Qsidprefix=${sid}\E")); }

push(@cmd_adddomain,("-f", "-c", ${IMSCONF_FILE}));



#add domain and get the region of the added domain ,only in node 0
#output of command ims_domain -A :
#ldu:xinghui-14 added.
my $stdout = "";
my $region = "";

if($isFriend eq "false"){
    $stdout = `@cmd_adddomain`;
    chomp(${stdout});


    if($?){# command ims_domain -A is failed.
        if (${domain_type} eq "sxfsfw"){
            system("rm -f ${SMB_CONF_FILE}");
        }
        print STDERR "ims_domain -A failed. Exit in :",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }

    my @tmp_array = split(/\s+/,${stdout});

    #region will be used when set auth to mount point
    $region = $tmp_array[0];
}

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
    system("/usr/bin/ims_domain -D ${region} -af -c ${IMSCONF_FILE}");
    if(($isFriend eq "false") and (${domain_type} eq "sxfsfw")){
        system("rm -f ${SMB_CONF_FILE}");
    }
    #if ldap host is invalid, ftp will return 101
    if(${ftp_ret}!=1){ exit 6;}else{
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

if(${domain_type} eq "sxfsfw"){
    #add new line to virtual_servers for export group only at node0
    if(${isFriend} eq "false"){
        #my @virtual_servers_content = `cat ${VIRTUAL_FILE} | awk -F \" \" '{if(\$1 != \"${export_group}\") print \$0}'`;
        #modify for the changing of the VS file's format at 2008/05/06
        my @virtual_servers_content = `cat ${VIRTUAL_FILE} 2>/dev/null`;
        my $ssVSContent = $ssComm->getVSContent4ScheduleScan(\@virtual_servers_content);
        @virtual_servers_content = `/home/nsadmin/bin/nsgui_getVSContent.pl $group_no | awk -F \" \" '{if(\$1 != \"${export_group}\") print \$0}'`;
        push (@virtual_servers_content,"${export_group} ${ntdomain} ${netbios}\n");
        push (@virtual_servers_content,@$ssVSContent);    
        
        open(VF,"| ${cmd_syncwrite_o} ${VIRTUAL_FILE}");
        print VF @virtual_servers_content;
        if(!close(VF)){
		print STDERR "Exit in :",__FILE__," line:",__LINE__+1,".\n";
		exit 1;
 	};
        system("/home/nsadmin/bin/ns_nascifsstart.sh");
    }

    # sxfsfw add native domain at both nodes
    if( $udb_common->isNativeExist($group_no,${ntdomain}."+".${netbios},"win","ldu") == 0){
        my @nativedomain_add_cmd = ("/usr/bin/ims_domain","-A",".${group_no}","ldu");
        push(@nativedomain_add_cmd, @cmd_options);
        push(@nativedomain_add_cmd,("-f", "-c", ${IMSCONF_FILE}));
        my $native_stdout=`@nativedomain_add_cmd`;

        if($? == 0){#native domain succeed
            my @tmp_array2 = split(/\s+/,${native_stdout});
            my $native_region = $tmp_array2[0];
            system("/usr/bin/ims_native","-A",${native_region},"-n.","-r","${ntdomain}+${netbios}","-f","-c", ${IMSCONF_FILE});
        }
    }

}

# add auth to direct mount point under export group directory at node 0
if(${isFriend} eq "false"){
    #/usr/bin/ims_auth -A <region> -d <mp> -f -c <imspath>
    $udb_common->addExportGroupAuthByType($export_group,$group_no,$domain_type,$region);

}
exit 0;
