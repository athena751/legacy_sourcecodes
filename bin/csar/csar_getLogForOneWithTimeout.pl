#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: csar_getLogForOneWithTimeout.pl,v 1.8 2009/03/30 05:11:42 fengmh Exp $"
#Function:  
#   get archive file in one node in 30mins
#Parameters: 
#   nodeN: 0|1|-1
#   logType: full|summary
#Output:
#   errorcode:
#   http:
#   mainInfo:
#
#exit code:
#   0 -- not time out
#   1 -- time out

use strict;
use NS::NsguiCommon;
use NS::CsarConst;

my $nsgui = new NS::NsguiCommon();
my $const = new NS::CsarConst;
my $logdir=$const->CSAR_DIR;

if(scalar(@ARGV)!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $nodeN = shift;
my $logType = shift;
my $perlresult;
my $result;
my $output;
my @info=();
my $tarfile;
my $logfile;
my $md5file;

my $SCRIPT_KILL_CHILD = "/opt/nec/nsadmin/bin/nsgui_killchild.pl";
eval{
    local $SIG{ALRM} = sub { system($SCRIPT_KILL_CHILD." 15 $$ 2>/dev/null");
                             die("timeout\n"); };
    alarm 30*60;
    #1:check the nodeN is FIP or not-->FIP or single: get log at this node
    if ($nodeN eq "-1"){ #single 
        @info=`/home/nsadmin/bin/csar_getLogForOne.pl $logType 2>/dev/null`;
        $perlresult=$?/256;
    }else{
        my $fipNodeNo = `/opt/nec/nsadmin/bin/cluster_getMyNodeNumber.pl`;
        if ($? !=0 ){exit 1;}
        chomp($fipNodeNo);
        if($fipNodeNo eq $nodeN){#FIP
            @info=`/home/nsadmin/bin/csar_getLogForOne.pl $logType 2>/dev/null`;
            $perlresult=$?/256;
        }else{#Other node
            system("/bin/rm -rf ${logdir}/csar*");
            system("/bin/rm -f ${logdir}/*.md5sum");
            system("/bin/rm -f ${logdir}/*.notice");
            #2:ping before get log
            my $friendIP = $nsgui->getFriendIP();
            chomp($friendIP);
            if(!defined($friendIP) || $friendIP eq ""){
                print STDERR "Failed to get the IP of the partner node in perl script(",__FILE__,")!\n";
                exit 1;
            }
            if(system("sudo ping -c 1 -w 2  ${friendIP} >& /dev/null") != 0 ){
                print "errorcode:0x13900200\n";
                print "http:\n";
                print "mainInfo:\n";
                exit 0;
            }
            #3:get log at other node
            my ($ret, $rshVar) = $nsgui->rshCmdWithSTDOUT("sudo /home/nsadmin/bin/csar_getLogForOne.pl $logType", $friendIP);
            if (!defined($ret)){
                print "errorcode:0x13900200\n";
                print "http:\n";
                print "mainInfo:\n";
                exit 0;            
            }elsif($ret != 0){
                exit 1;
            }
                        
            @info=@$rshVar;
            chomp(@info);
            $result=shift(@info);
            $output=shift(@info);
            if ($result eq "-1"){ # succeed to get information files in other node
                #delete old file
                system("sudo mkdir -p ${logdir} >& /dev/null");
                system("sudo chmod 775 ${logdir} >& /dev/null");
                system("sudo chgrp nsadmin ${logdir} >& /dev/null");
                
                #4:check volume capability
                my $diskAvailable=`df -B 1 /var/crash | grep /var/crash | awk '{print \$4;}'`;
                chomp($diskAvailable);
                my $size;
                if ($output=~/\s*(csar\S+),(\S+md5sum),(\d+)\s*$/){ #csar-log-stinger0-20080130-010940.tar.gz,stinger0.md5sum,1234567
                    $logfile=$1;
                    $md5file=$2;
                    $size=$3;
                }else {
                    print STDERR "Failed to get the size of csar log for the partner node in perl script(",__FILE__,")!\n";
                    exit 1;
                }
                
                if ($size>$diskAvailable*2/3){#not enough space.
                    print "errorcode:0x13900208\n";
                    print "http:\n";
                    print "mainInfo:\n";
                    exit 0;
                }
                #5:ping before rcp
                if(system("sudo ping -c 1 -w 2  ${friendIP} >& /dev/null") != 0 ){
                   print "errorcode:0x13900207\n";
                   print "http:\n";
                   print "mainInfo:\n";
                   exit 0;
                }
                #6:rcp
                if (system("sudo -u nsgui /usr/bin/rcp -p ${friendIP}:${logdir}/${logfile} ${friendIP}:${logdir}/${md5file} ${logdir}  >& /dev/null") == 0) {
                    #add by liq for delete pater node file @2008/3/19   [nsgui-necas-sv4:28372]
                    my @rshDelInfo=`sudo -u nsgui /usr/bin/rsh ${friendIP} sudo /bin/rm -f ${logdir}/${logfile} ${logdir}/${md5file} 2>&1`;
                    my $rshDelExitCode=$?/256;
                    if ($rshDelExitCode==0){
                        #get tar file name                        
                        if(${logfile}=~/csar\-(summary|log)\-(\S+)\.tar\.gz\s*$/){
                            $tarfile="csar-${logType}-$2.tar";
                        }
                        
                        #make archive file
                        #tar -cf a.tar log md5
                        my @tarinfo=`/bin/tar -cf ${logdir}/${tarfile} -C ${logdir} ${logfile} ${md5file} 2>&1`;
                        if ($? !=0){#failed to tar
                            $result="6";
                            foreach(@tarinfo){
                                if(($_=~/\s*Wrote\s+only\s+\d+\s+of\s+\d+\s*bytes\s+/)||
                                   ($_=~/\s*No\s+space\s+left\s+on\s+device\s+/)){#no enough space
                                    $result="5";
                                    last;
                                 }
                            }
                            system("/bin/rm -f ${logdir}/${tarfile}");
                            print "errorcode:0x1390020${result}\n";
                            print "http:\n";
                            print "mainInfo:\n";
                            exit 0;
                        }else{#succeed to tar
                            system("/bin/rm -f ${logdir}/${logfile}");
                            system("/bin/rm -f ${logdir}/${md5file}");
                            print "errorcode:\n";
                            print "http:$tarfile\n";
                            print "mainInfo:\n";
                            exit 0;
                        }
                        
                    }else{#failed to remove files
                        print STDERR "Failed to remove partner node logs in perl script(",__FILE__,")!\n";
                        print STDERR "Please try it again.\n";
                        print STDERR "rsh exit code==$rshDelExitCode\n";
                        print STDERR @rshDelInfo;
                        exit 1;
                    }
                    #end of liq@2008/3/19
                }else{#failed to rcp
                    print "errorcode:0x13900209\n";
                    print "http:\n";
                    print "mainInfo:\n";
                    exit 0;
                }
            }else{ # failed to get tar file in other node
                print "errorcode:0x1390020${result}\n";
                print "http:\n";
                print "mainInfo:$output\n";
                exit 0;
            }
        }
    }
    # FIP or single
    if ($perlresult !=0){exit 1;}
    chomp(@info);
    $result=shift(@info);
    $output=shift(@info);
    if ($result eq "-1"){ #secceed to get log
        if ($output=~/\s*(csar\S+),(\S+md5sum),(\d+)\s*$/){
            $logfile=$1;
            $md5file=$2;
        }else {
            print STDERR "Failed to get the file name of csar log for the specified node in perl script(",__FILE__,")!\n";
            exit 1
        };
        
        #get tar file name
        if(${logfile}=~/csar\-(summary|log)\-(\S+)\.tar\.gz\s*$/){
            $tarfile="csar-${logType}-$2.tar";
        }
                        
        #make archive file
        #tar -cf a.tar log md5
        my @tarinfo=`/bin/tar -cf ${logdir}/${tarfile} -C ${logdir} ${logfile} ${md5file} 2>&1`;
        if ($? !=0){#failed to tar
            $result="6";
            foreach(@tarinfo){
                if(($_=~/\s*Wrote\s+only\s+\d+\s+of\s+\d+bytes\s+/)||
                   ($_=~/\s*No\s+space\s+left\s+on\s+device\s+/)){#no enough space
                    $result="5";
                    last;
                }
            }
            system("/bin/rm -f ${logdir}/${tarfile}");
            print "errorcode:0x1390020${result}\n";
            print "http:\n";
            print "mainInfo:\n";
            exit 0;
        }else{#succeed to tar
            system("/bin/rm -f ${logdir}/${logfile}");
            system("/bin/rm -f ${logdir}/${md5file}");
            print "errorcode:\n";
            print "http:$tarfile\n";
            print "mainInfo:\n";
            exit 0;
        }
        
    }else{ # failed to get log
        print "errorcode:0x1390020${result}\n";
        print "http:\n";
        print "mainInfo:$output\n";
        exit 0;
    }
    alarm 0;
};
if ($@ eq "timeout\n") {
    $nsgui->writeErrMsg("0x139002ff",__FILE__,__LINE__+1);
    exit 1;
}

exit 0;