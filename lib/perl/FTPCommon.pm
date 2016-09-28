#!/usr/bin/perl

#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: FTPCommon.pm,v 1.2308 2005/08/29 02:56:39 liq Exp $"
package NS::FTPCommon;

use strict;
use NS::SystemFileCVS;
no utf8;
no warnings;

sub new(){
    my $this = {};
    bless $this;
    return $this;
}

sub getludbRootPath(){
    my $self = shift;
    my $cmd = "/usr/bin/ludb_admin root";
    my @content = `$cmd`;
    if($?){
        print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    chomp($content[0]);
    # print the ludb root's path
    return $content[0];
}

sub delPDCOrPWDDomain(){
    my $self = shift;
    if(scalar(@_)!=2){
        return 1;
    }
    my ($region,$nodeNo) = @_;
    my $cmd_deldomain = "";
    
    if($region =~ /\s*nis:./){
        return 0;
    }
    if($region =~ /\s*ldu:./){
        return 0;
    }
    if($region eq ""){
        return 0;
    }
    #region like pwd:.ftp-N dmc:.ftp-N
    if($region =~ /\s*pwd:./){
        $cmd_deldomain = "/usr/bin/ims_domain -D pwd:.ftp-${nodeNo} -af -c /etc/group${nodeNo}/ims.conf";
    }
    if($region =~ /\s*dmc:./){
        $cmd_deldomain = "/usr/bin/ims_domain -D dmc:.ftp-${nodeNo} -af -c /etc/group${nodeNo}/ims.conf";
    }
    
    system($cmd_deldomain);    
    return 0;
}

sub delNISDomain(){
    my $self = shift;
    if(scalar(@_)!=2){
        return 1;
    }
    my ($nodeNo,$groupNo) = @_;
    my $YPCONF = "/etc/yp.conf";
    my $common=new NS::SystemFileCVS;
    my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
    open(FILE,"$YPCONF");

    my @ypcontent = <FILE>;

    close(FILE);

    my @delete_server =();
    #find the NIS server in file /etc/yp.conf
    for(my $idx = scalar(@ypcontent)-1; ${idx}>=0 ; $idx--){
        my $line=$ypcontent[$idx];

        if ($line =~/^\s*domain\s+(\S+)\s+server\s+(\S+)\s+\#FTP-${groupNo}/){
            push(@delete_server,$2);
            splice(@ypcontent, $idx ,1);
        }
    }
#--------------------------------------------------------
    my $ret=$common->checkout($YPCONF);
    if($ret!=0){
        return 1;
    }
    open(FILE,"| ${cmd_syncwrite_o} $YPCONF");
    print FILE @ypcontent;
    if(!close(FILE)){
	return 1;
    };
    if(system("/etc/rc.d/init.d/ypbind restart")!=0){
        #rollback yp.conf
        $common->rollback($YPCONF);
        return 1;

    }
    $ret=$common->checkin($YPCONF);
    if($ret!=0){
        $common->rollback($YPCONF);
        return 1;
    }
#----------------------------------------------------------
    my $cmd = "/home/nsadmin/bin/nsgui_iptables.sh";
    my $found=0;
   
    system("/usr/bin/ims_domain -D nis:.ftp-${nodeNo} -af -c /etc/group${nodeNo}/ims.conf 2>/dev/null");   
    if(scalar(@delete_server)!=0){
        #delete the domain's declaration
        #   if($nodeNo eq $groupNo){
        
        #   }
        for(my $i=0;$i<scalar(@delete_server);$i++){
            $found=0;
        

        #see if there are other entries still use this server
        for(my $idx = 0; ${idx}< scalar(@ypcontent) ; $idx++){
            my $line=$ypcontent[$idx];

            if($line =~ /^\s*domain\s+(\S+)\s+server\s+\Q${delete_server[$i]}\E\s*$/){
                $found=1;
                last;
            }elsif($line =~ /^\s*domain\s+(\S+)\s+server\s+\Q${delete_server[$i]}\E\s+\#FTP-/){
                $found=1;
                last;
            }
        }

        if($found == 0){
         #server doesn't used by usermapping
            #run iptables -D
            system("${cmd} -D -s ${delete_server[$i]} 512:65535/udp 2>/dev/null");
            system("/home/nsadmin/bin/nsgui_iptables_save.sh");
        }
      }    
    }
#-----------------------------------------------------------
    return 0;
}

sub delLDAPDomain(){
    my $self = shift;
    if(scalar(@_)!=2){
        return 1;
    }
    my ($nodeNo,$groupNo) = @_;
    my $LDAP_CONF = "/etc/ftpd/proftpd_ldap.conf";
#    if($nodeNo eq $groupNo){
        system("/usr/bin/ims_domain -D ldu:.ftp-${nodeNo} -af -c /etc/group${nodeNo}/ims.conf 2>/dev/null");
#    }

    return 0;

}

sub readFile(){
    my $self = shift;
    my $filename = shift;
    if(!(-f $filename)){

        my $pathname = substr($filename,0,rindex($filename,"/"));

        if (!(-d $pathname)){
            system("mkdir -p $pathname");
        }
        system("touch $filename");
    }
    if(!open(FILE,$filename)){
        print STDERR "file $filename can't be opened. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    my @content=<FILE>;
    close(FILE);
    return \@content;
}

sub writeFile(){
    my $self = shift;
    my ($filename,$content) = @_;
    my $common=new NS::SystemFileCVS;
    my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
    if(!(-f $filename)){

        my $pathname = substr($filename,0,rindex($filename,"/"));

        if (!(-d $pathname)){
            system("mkdir -p $pathname");
        }
        system("touch $filename");
    }
    my $ret=$common->checkout($filename);
    if($ret!=0){
        print STDERR "check out file $filename failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    open(FILE,"| ${cmd_syncwrite_o} $filename") or $common->undoExit($filename,1,"write file $filename failed\n");
    print FILE @$content;
    close FILE;
    $ret=$common->checkin($filename);
    if($ret!=0){
        $common->rollback($filename);
        print STDERR "check in file $filename failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}


#liqing for delete all domain
sub delAllDomain(){
    my $self = shift;
    if(scalar(@_)!=3){
        return 1;
    }
    my $currType = shift;
    my $nodeNo = shift;
    my $groupNo = shift;
    my $temp;
    my @line=();
    my @regionAll=`/usr/bin/ims_domain -Lv -c /etc/group${nodeNo}/ims.conf | grep ftp`;
    for(my $i=0; $i<scalar(@regionAll); $i++){
        if($regionAll[$i] =~ /^\s*(\w+):\.ftp\-${nodeNo}/){
            $temp=$1;
            if ($temp ne $currType){
                if ($temp eq "nis"){
                    &delNISDomain($self,$nodeNo,$groupNo);
                }elsif($temp eq "ldu"){
                    &delLDAPDomain($self,$nodeNo,$groupNo);
                }else{
                    @line=split(/\s+/,$regionAll[$i]);
                    &delPDCOrPWDDomain($self,$line[0],$nodeNo);
                }
            }        
        }    
    }
    return 0;
}

1;
