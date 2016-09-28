#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_joindomain.pl,v 1.10 2007/09/25 05:41:41 fengmh Exp $"
use strict;
use NS::MAPDCommon;
use NS::SystemFileCVS;

if( scalar(@ARGV)!= 9){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
my $userAndPass = <STDIN>;
chomp($userAndPass);
my $MC = new NS::MAPDCommon;
my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;

my $netbiosname = pop(@ARGV);
my $dnsServer = pop(@ARGV);
my $smbconfpath = "";
my $hasSMBConf = 1;
if ($netbiosname =~ /^\s*$/){
    $hasSMBConf = 0;
}else{
    $smbconfpath = $ARGV[5] . "/DEFAULT/" . $ARGV[3] . "/smb.conf." . $netbiosname;
    my @content = `cat ${smbconfpath}`;
    if (!$MC->hasKey($MC->SMB_KEY_REALM, $MC->SMB_SEC_GLOBAL, \@content)) {
        $hasSMBConf = 0;
    }
}
if (!$hasSMBConf) {
    $smbconfpath =  &createTempConf($ARGV[1],$ARGV[3],$dnsServer);
    if (!defined($smbconfpath)){
        print STDERR "failed to create temp file!\n";
        exit 1;
    }
}

my @opts = @ARGV;
push (@opts,("$userAndPass","-s","$smbconfpath"));
if (system("/usr/bin/nascifsjoin",@opts) != 0){
    print STDERR "failed to execute command : /usr/bin/nascifsjoin\n";
    if (!$hasSMBConf){
        system("sudo rm -rf ${smbconfpath}");
    }
    exit 1;
}

if (!$hasSMBConf){
    system("sudo rm -rf ${smbconfpath}");
}

exit 0;


sub createTempConf(){
    my ($type, $ntdomain, $dns) = @_;
    my $pid = $$;
    system("sudo rm -rf /tmp/smb.conf.${pid}");
    system("touch /tmp/smb.conf.${pid}");
    if (!open(FILE, "| ${cmd_syncwrite_o} /tmp/smb.conf.${pid}")) {
        return undef;
    }
    if ($type eq "ads"){
        $type = "ads";
    }else{
        $type = "domain";
    }
    my $appendLines="";
    if (defined($dns) && $dns ne ""){
        $appendLines = "realm = ${dns}\n";
    }
    my @nasNetbiosname = `/home/nsadmin/bin/cifs_getClusterHostName.pl 2> /dev/null`;
    if (scalar(@nasNetbiosname) != 0 && $nasNetbiosname[0] !~ /^\s*$/){
        $nasNetbiosname[0] = uc($nasNetbiosname[0]);
        $appendLines = $appendLines . "netbios name = $nasNetbiosname[0]\n";
    }
print FILE (<<_EOF_);
[global]
encrypt passwords = yes
log file = %L-%m.log
log level = 0
# Made by GUI (Don't touch this comment.)
winbind enum groups = yes
winbind separator = +
template shell = /bin/bash
winbind gid = 10000-110000
winbind uid = 10000-110000
server string = ""
deadtime = 15
#irrevocable options
workgroup = ${ntdomain}
smb passwd file = %r/%D/smbpasswd
nt acl support = yes
password server = *
security = ${type}
${appendLines}
_EOF_
if(!close(FILE)){
	return "";
};
return "/tmp/smb.conf.${pid}";
}
