#!/usr/bin/perl -w
#
#       Copyright (c) 2008-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: csar_getLogForBoth.pl,v 1.9 2009/03/30 05:11:42 fengmh Exp $"
#Function:  
#   get archive file in fip node
#Parameters: 
#   logType: full|summary
#Output:
#   mainresult
#   otherresult
#   http
#   mainoutput
#   otheroutput

#
#exit code:
#   0 -- success
#   1 -- failed

use strict;
use NS::SystemFileCVS;
use NS::NsguiCommon;
use NS::CsarConst;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $logType = shift;
my $const = new NS::CsarConst;
my $logCMD=$const->CSAR_CMD_GET_SUMMARY;
if($logType eq "full"){
    $logCMD=$const->CSAR_CMD_GET_FULL;
}
my $logdir=$const->CSAR_DIR;

my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $nsgui = new NS::NsguiCommon;

my @execInfo=();
my $mainResult="-1";
my $mainOutput;
my $otherResult="-1";
my $otherOutput="";
my @noticeInfo=();
my $bothTarFile="";
my $ret;
my $rshVar;

#1:get log files in self node
my $mainlogFile;
my $mainmd5File;
@execInfo=`/home/nsadmin/bin/csar_getLogForOne.pl $logType 2>/dev/null`;
if($? != 0){
    exit 1;
}else{
    chomp(@execInfo);
    $mainResult=shift(@execInfo);
    $mainOutput=shift(@execInfo);
    if ($mainResult eq "-1"){ #secceed to get log
        $mainResult="6";
        if ($mainOutput=~/\s*(csar\S+),(\S+md5sum),\d+\s*$/){
            $mainlogFile=$1;
            $mainmd5File=$2;
        }else {
            print STDERR "Failed to get the log file name of csar log for the main node in perl script(",__FILE__,")!\n";
            exit 1;
        }
    }else{# failed to get log
        $mainResult=$mainResult-1;
    }
}

#2:ping before get tar file
my $friendIP = $nsgui->getFriendIP();
chomp($friendIP);
if(!defined($friendIP) || $friendIP eq ""){
    print STDERR "Failed to get the IP of the partner node in perl script(",__FILE__,")!\n";
    exit 1;
}
if(system("sudo ping -c 1 -w 2  ${friendIP} >& /dev/null") != 0 ){
    $otherResult="0";
}

#3:get information files in other node
if ($otherResult eq "-1"){
    ($ret, $rshVar) = $nsgui->rshCmdWithSTDOUT("sudo /home/nsadmin/bin/csar_getLogForOne.pl $logType", $friendIP);
    if (!defined($ret)){
        $otherResult="0";
    }elsif($ret != 0){
        exit 1;
    }else{
        @execInfo=@$rshVar;
        chomp(@execInfo);
        $otherResult=shift(@execInfo);
        $otherOutput=shift(@execInfo);
    }
}

#4:if other node succees do check volume capability
my $otherlogFile;
my $othermd5File;
if ($otherResult eq "-1"){ # succeed to get information files in other node
    #5:check volume capability
    my $diskAvailable=`df -B 1 /var/crash | grep /var/crash | awk '{print \$4;}'`;
    chomp($diskAvailable);
    my $size;
    if ($otherOutput=~/\s*(csar\S+),(\S+md5sum),(\d+)\s*$/){ #csar-log-stinger0-20080130-010940.tar.gz,stinger0.md5sum,1234567
        $otherlogFile=$1;
        $othermd5File=$2;
        $size=$3;
    }else {
        print STDERR "Failed to get the size of csar log for the partner node in perl script(",__FILE__,")!\n";
        exit 1;
    }
                
    if ($size>$diskAvailable*2/3){#not enough space.
        $otherResult="8";
        $otherOutput="";
    }
}

#5:ping before rcp
if($otherResult eq "-1"){
    if(system("sudo ping -c 1 -w 2  ${friendIP} >& /dev/null") != 0 ){
        $otherResult="7";
        $otherOutput="";
    }    
}

#6:rcp
if($otherResult eq "-1"){
    system("sudo mkdir -p ${logdir} >& /dev/null");
    system("sudo chmod 775 ${logdir} >& /dev/null");
    system("sudo chgrp nsadmin ${logdir} >& /dev/null");
    if (system("sudo -u nsgui /usr/bin/rcp -p ${friendIP}:${logdir}/${otherlogFile} ${friendIP}:${logdir}/${othermd5File} ${logdir} >& /dev/null") == 0) {
        #add by liq for delete pater node file @2008/3/19   [nsgui-necas-sv4:28372]
        my @rshDelInfo=`sudo -u nsgui /usr/bin/rsh ${friendIP} sudo /bin/rm -f ${logdir}/${otherlogFile} ${logdir}/${othermd5File} 2>&1`;
        my $rshDelExitCode=$?/256;
        if ($rshDelExitCode==0){
            $otherResult="a";
        }else{
            print STDERR "Failed to remove partner node logs in perl script(",__FILE__,")!\n";
            print STDERR "Please try it again.\n";
            print STDERR "rsh exit code==$rshDelExitCode\n";
            print STDERR @rshDelInfo;
            exit 1;
        }
        #end of liq@2008/3/19
    }else{
        $otherResult="9";
        $otherOutput="";
    }
}


#7: make 2 node's tar file
my $tarresult;
my $hostname="";
my $friendnodehost="";
my $noticeFile="";
my $tmpinfo="";
my $tarflag="no"; #"no"->have not do tar |"all"->do maintar+othertar  | "main"->do maintar+othernotice | "other"->do mainnotice+othertar

#get host name of both nodes for mkdir to move information files
#when get information successfully at least on one node, need to tar files
if(($mainResult eq "6") || ($otherResult eq "a")){
    #get host name of fip node
    $hostname=`/bin/hostname -s`;
    chomp($hostname);
    if (!defined($hostname) || $hostname eq ""){
        print STDERR "Failed to get the host name for the fip node in perl script(",__FILE__,")!\n";
        exit 1;
    }
    
    #get host name of friend node
    $friendnodehost=`/opt/nec/nsadmin/bin/cluster_getFriendHostName.pl`;
    chomp($friendnodehost);
    if (!defined($friendnodehost) || $friendnodehost eq ""){
        print STDERR "Failed to get the host name for the partner node in perl script(",__FILE__,")!\n";
        exit 1;
    }
    
    #mkdir to move information files
    system("sudo mkdir -p ${logdir}/csar/${hostname} ${logdir}/csar/${friendnodehost} >& /dev/null");
    system("sudo chmod 775 ${logdir}/csar/${hostname} ${logdir}/csar/${friendnodehost} >& /dev/null");
    system("sudo chgrp nsadmin ${logdir}/csar/${hostname} ${logdir}/csar/${friendnodehost} >& /dev/null");
    
    #move information to directory which belongs to
    if($mainResult eq "6"){#get information successfully of main node
        system("sudo mv -f ${logdir}/${mainlogFile} ${logdir}/csar/${hostname} >& /dev/null");
        system("sudo mv -f ${logdir}/${mainmd5File} ${logdir}/csar/${hostname} >& /dev/null");
    }
    if($otherResult eq "a"){#get information successfully of other node
        system("sudo mv -f ${logdir}/${otherlogFile} ${logdir}/csar/${friendnodehost} >& /dev/null");
        system("sudo mv -f ${logdir}/${othermd5File} ${logdir}/csar/${friendnodehost} >& /dev/null");
    }
}

#make tar file
if ($mainResult eq "6"){#main node success
    if ($mainlogFile=~/(csar\-(summary|log)\-)[\w][\w\-]*(\-\d{8}\-\d{6}\.tar)\.gz/){#get bothtarfile name by main node
        $bothTarFile="csar-${logType}-both".$3;
    }
    if ($otherResult eq "a"){# both node success
        $tarflag="all";
        @execInfo=`/bin/tar -cf ${logdir}/${bothTarFile} -C ${logdir}/csar ${hostname} ${friendnodehost} 2>&1`;
        $tarresult=$?/256;
    }else{# only main node succeed
        $tarflag="main";
        #get the info that write into noticefile
        if ($otherResult ne "3"){# the error info is known
            push (@noticeInfo,$const->getErrorInfo($otherResult));
        }else{
            $tmpinfo=$otherOutput;
            $tmpinfo=~s/\t/\n/g;
            push (@noticeInfo,$tmpinfo);
        }
        
        $noticeFile="${logdir}/csar/${friendnodehost}/${friendnodehost}.notice";
        (-f ${noticeFile}) || system("touch ${noticeFile} >& /dev/null");
        open(FILE,"| ${cmd_syncwrite_o} ${noticeFile}");
        print FILE @noticeInfo;
        if(!close(FILE)){
            print STDERR "Failed to create notice file in perl script(",__FILE__,")!\n";
            system("/bin/rm -f ${noticeFile}");
            exit 1;
        }
        @execInfo=`/bin/tar -cf ${logdir}/${bothTarFile} -C ${logdir}/csar ${hostname} ${friendnodehost} 2>&1`;
        $tarresult=$?/256;
    }
}elsif($otherResult eq "a"){# only friend node success
    $tarflag="other";
    if ($otherlogFile=~/(csar\-(summary|log)\-)[\w][\w\-]*(\-\d{8}\-\d{6}\.tar)\.gz/){#get bothtarfile name by other node
        $bothTarFile="csar-${logType}-both".$3;
    }
    #get the info that write into noticefile
    if ($mainResult ne "2"){# the error info is known
        push (@noticeInfo,$const->getErrorInfo($mainResult+1));
    }else{
        $tmpinfo=$mainOutput;
        $tmpinfo=~s/\t/\n/g;
        push (@noticeInfo,$tmpinfo);
    }
    
    $noticeFile="${logdir}/csar/${hostname}/${hostname}.notice";
    (-f ${noticeFile}) || system("touch ${noticeFile} >& /dev/null");
    open(FILE,"| ${cmd_syncwrite_o} ${noticeFile}");
    print FILE @noticeInfo;
    if(!close(FILE)){
        print STDERR "Failed to create notice file in perl script(",__FILE__,")!\n";
        system("/bin/rm -f ${noticeFile}");
        exit 1;
    }
    @execInfo=`/bin/tar -cf ${logdir}/${bothTarFile} -C ${logdir}/csar ${hostname} ${friendnodehost} 2>&1`;
    $tarresult=$?/256;
}

if ($tarflag ne "no"){# have do tar
    if ($tarresult==0){#tar succeed
        system("/bin/rm -rf ${logdir}/csar");
        if ($tarflag eq "all"){#do maintar+othertar
             $mainResult="b";
             $mainOutput="";
             $otherOutput="";
        }elsif($tarflag eq "main"){#do maintar+othernotice
             $mainOutput="";
        }else{#do mainnotice+othertar
             $otherOutput="";
        }
    }else{#tar failed
        system("/bin/rm -f ${logdir}/${bothTarFile}");
        $bothTarFile="";
        my $isNoSpace = "no";
        foreach(@execInfo){
            if(($_=~/\s*Wrote\s+only\s+\d+\s+of\s+\d+\s*bytes\s+/)||
              ($_=~/\s*No\s+space\s+left\s+on\s+device\s+/)){#not sapce to do tar
                if ($tarflag eq "all"){#do maintar+othertar
                    $mainResult="7";
                    #$bothTarFile=$otherTarFile;
                    $mainOutput="";
                    $otherOutput="";
                }elsif($tarflag eq "main"){#do maintar+othernotice
                    $mainResult="9";
                    $mainOutput="";
                }else{#do mainnotice+othertar
                    $otherResult="b";
                    $otherOutput="";  
                }  
                $isNoSpace="yes";
                last;
            }
        } 
        
        if($isNoSpace eq "no"){
            if ($tarflag eq "all"){#do maintar+othertar
                    $mainResult="8";
                    #$bothTarFile=$otherTarFile;
                    $mainOutput="";
                    $otherOutput="";
                }elsif($tarflag eq "main"){#do maintar+othernotice
                    $mainResult="a";
                    $mainOutput="";
                }else{#do mainnotice+othertar
                    $otherResult="c";
                    $otherOutput="";
                }
        }
        
        #move information files to directory of "/var/crash/.nsgui" to adapt error messages
        system("/bin/mv -f ${logdir}/csar/${hostname}/* ${logdir}");
        system("/bin/mv -f ${logdir}/csar/${friendnodehost}/* ${logdir}");
        system("/bin/rm -rf ${logdir}/csar");

    }#end of tar failed
}

print "$mainResult\n";
print "$otherResult\n";
print "$bothTarFile\n";
print "$mainOutput\n";
print "$otherOutput\n";
exit 0;