#!/usr/bin/perl -w
#
#       Copyright (c) 2006-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: event_collect.pl,v 1.7 2008/03/21 13:43:47 chenbc Exp $"

#Function:  
#    As eventlog, get the trouble information form syslog accorcding to the keywords of the actions.
#    The eventlog file is /var/log/eventlog/eventlog.

#Arguments:
#    no

#output:
#    no

#Return:
#    0:success
#    1:the operation has been locked
#    2:unexpected error

use strict;

use XML::DOM;
use NS::SystemFileCVS;
use NS::EventCommon;

my $cvs = new NS::SystemFileCVS;
my $parser = new XML::DOM::Parser;
my $common = new NS::EventCommon;

my $keyword_file=$common->KEY_FILE;
my $syslog_file=$common->SYS_LOG;
my $event_dir=$common->EVENT_LOG_DIR;
my $event_file=$common->EVENT_LOG;
my $info_file=$common->EVENT_INFO;
my $lock_file=$common->EVENT_LOCK;


#------------------------signal trap------------------------------
my $stop_flag=0;
$SIG{HUP}=\&handler;
$SIG{INT}=\&handler;
$SIG{QUIT}=\&handler;
$SIG{TERM}=\&handler;
$SIG{ALRM} = \&time_out;
my $timeout=60;

#-----------------------make sure the eventlog directory is exist----------------------
if(!-d ${event_dir}){
    system("/bin/rm -rf ${event_dir} && /bin/mkdir ${event_dir}");
    if($? != 0){
        print STDERR "Failed to create directory ${event_dir}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
        exit 2;
    }
}


#-----------------------lock operation------------------------
my $lock_time=100;
system("/usr/bin/lockfile -l ${lock_time} -s 0 -r 0 ${lock_file} 2>/dev/null");
if($? != 0){
    $common->writeSyslog($common->MSG_0001);
    print STDERR "The operation is locked by another user.\n";
    exit 1;
}


#-------------------------check the syslog-----------------------
if(!-f ${syslog_file}){
    print STDERR "Can not find file ${syslog_file}. Exit in perl script:"
              ,__FILE__," line:",__LINE__+1,".\n";
    &myexit(2);
}


#-----------------------check eventlog file----------------------
if(!-f ${event_file}){
    system("/bin/rm -rf ${event_file} && /bin/touch ${event_file}");
    if($? != 0){
        print STDERR "Failed to create file ${event_file}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
        &myexit(2);
    }
}


#------------------------eventlog rotate check--------------------------------
my $size=(-s ${event_file});
if( $common->ROTATE_SIZE < $size ){
    system("/bin/mv -f ${event_file} ${event_file}.1 && /bin/touch ${event_file}");
    if($? != 0){
        print STDERR "Failed to rotate eventlog ${event_file}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
        &myexit (2);
    }
}


#-------------------------create hash table of keywords and relative information-------------------------
my $doc = $parser -> parsefile(${keyword_file});
my $nodes = $doc -> getElementsByTagName("keyWord");
my %index;
my %info;

my ($keyword,$id,$level,$component,$mail_report,$snmp_report);

for(my $i = 0; $i < $nodes -> getLength(); ++$i){
    my $curNode = $nodes -> item($i);
    $keyword = $curNode -> getAttribute("value");
    $id=$curNode->getAttribute ("ID");
    $level=$curNode->getAttribute ("Level");
    $component=$curNode->getAttribute ("component");
    $mail_report=$curNode->getAttribute ("Mail");
    $snmp_report=$curNode->getAttribute ("SNMP");

    $info{$keyword}="$id,$level,$component,$mail_report,$snmp_report";

    my ($curPrefix) = $keyword =~/^(.*?\:).*$/;
    if( (!defined $curPrefix) || ($curPrefix =~/^\s*\:$/) ){
        $curPrefix = $keyword;
    }
    if(!defined $index{$curPrefix}){
        $index{$curPrefix} = [$keyword];
    }else{
        push @{$index{$curPrefix}}, $keyword;
    }
}


#-----------------------get syslog to analyze----------------------------
my $firstRun_data=200000;
my ($nowFirst,$nowLength,$nowRemain,$rotateFirst,$rotateLength,$rotateRemain)=&getSyslogRegion();

my $begin_line=$nowLength + $rotateLength - $nowRemain - $rotateRemain + 1;
if($begin_line <= 0){
    $begin_line = 1;
}
my $all_length=$nowRemain + $rotateRemain;
open(SYSLOG,"/bin/cat ${syslog_file}.1 ${syslog_file} 2>/dev/null | /usr/bin/tail -n +${begin_line} |");

#----------------------open eventlog file for writing---------------------------------
if($cvs->checkout(${event_file})!=0){
    print STDERR "Failed to checkout file ${event_file}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
    &myexit(2);
}
if(!open(EVENTLOG, ">>${event_file}")){
    $cvs->rollback($event_file);
    print STDERR "Failed to write ${event_file}. Exit in perl script:"
                        ,__FILE__," line:",__LINE__+1,".\n";
    &myexit(2);
}


#----------------variable for analyzed data-------------------
my $analyzed_line=0;


#------------------------search syslog and save eventlog----------------------------------
eval{
    alarm($timeout);

    #------------------------time information(for adding year's use)------------------------
    my %month=("Jan"=>1,"Feb"=>2,"Mar"=>3,"Apr"=>4,"May"=>5,"Jun"=>6,"Jul"=>7,"Aug"=>8,"Sep"=>9,"Oct"=>10,"Nov"=>11,"Dec"=>12);
    my $this_time=`date "+%Y %m"`;
    chomp($this_time);
    my @timearray=split(" ",$this_time,2);
    my $this_year=$timearray[0];
    my $last_year=$this_year-1;
    my $this_month=$timearray[1];
    $this_month=~s/^0//;
    my ($add_year,$mth,$day,$fulltime,$left_msg);
    
    #------------------------eventlog analyze start---------------------------------
    my $line="";
    my $find_keyword=0;

    while(<SYSLOG>){
        if($stop_flag == 1){
            last;
        }
        $line=$_;
        $find_keyword=0;
        foreach my $key (keys(%index)){
            if(index($line, $key) != -1){
                foreach my $keyword (@{$index{$key}}){
                    if(index($line, $keyword) != -1){
                        $find_keyword=1;
                        if($line=~/^(\S+)\s+(\S+)\s+(\S+)\s+(.*)$/){
                            $mth=$month{$1};
                            $day=$2;
                            $fulltime=$3;
                            $left_msg=$4;
                            if(!defined($mth)){
                                last;
                            }
                            if($this_month!=1){
                                $add_year=$this_year;
                            }else{
                                if($mth!=1){
                                    $add_year=$last_year;
                                }else{
                                    $add_year=$this_year;
                                }
                            }
                        }else{
                            last;
                        }
                        
                        if($mth=~/^\d$/){
                            $mth="0"."$mth";
                        }
                        if($day=~/^\d$/){
                            $day="0"."$day";
                        }

                        print EVENTLOG "$add_year/$mth/$day $fulltime,$info{$keyword},\t$left_msg\n";                    
                        last;
                    }
                }
            }
            if($find_keyword == 1){
                last;
            }
        }
        $analyzed_line++;
    }
    
    alarm(0);

};

#---------------------------deal with time out-------------------------------
if($@ =~ /^TIMEDOUT/){
    $common->writeSyslog($common->MSG_0003);
}

close(SYSLOG);
close(EVENTLOG);
if($cvs->checkin($event_file)!=0){
    $cvs->rollback($event_file);
    print STDERR "Failed to checkin ${event_file}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n";
    &myexit(2);
}


#------------------save the ending information--------------------------
if($analyzed_line != 0){

    #-----------------------caculate the end's place----------------------
    my $file_sign="";
    my $line_end=0;

    if($analyzed_line == $all_length){
        $file_sign=$nowFirst;
        $line_end=$nowLength;
    }else{
        if($rotateRemain != 0){
            if($analyzed_line <= $rotateRemain){
                $file_sign=$rotateFirst;
                $line_end=$rotateLength-$rotateRemain+$analyzed_line;
            }else{
                $file_sign=$nowFirst;
                $line_end= $analyzed_line - $rotateRemain;
            }    
        }else{
            $file_sign=$nowFirst;
            $line_end=$nowLength-$nowRemain+$analyzed_line;
        }
    }

    #---------------------save the sign-----------------------------
    if(!-f ${info_file}){
        system("/bin/rm -rf ${info_file} && /bin/touch ${info_file}");
        if($? != 0){
            print STDERR "Failed to create file ${info_file}. Exit in perl script:"
                      ,__FILE__," line:",__LINE__+1,".\n";
            &myexit(2);
        }
    }
    if($cvs->checkout(${info_file})!=0){
        print STDERR "Failed to checkout file ${info_file}. Exit in perl script:"
                      ,__FILE__," line:",__LINE__+1,".\n";
        &myexit(2);
    }
    if(!open(INFO, ">${info_file}")){
        $cvs->rollback($info_file);
        print STDERR "Failed to write ${info_file}. Exit in perl script:"
                            ,__FILE__," line:",__LINE__+1,".\n";
        &myexit(2);
    }
    print INFO "last_msg=$file_sign\n";
    print INFO "last_line=$line_end\n";
    close(INFO);
    if($cvs->checkin($info_file)!=0){
        $cvs->rollback($info_file);
        print STDERR "Failed to checkin ${info_file}. Exit in perl script:"
                                ,__FILE__," line:",__LINE__+1,".\n";
        &myexit(2);
    }

}

#------------------------all end--------------------------
&myexit(0);





#-------------------------------sub functions----------------------------------------------

sub getSyslogRegion{
	
	my $now_remain=0;
    my $rotate_remain=0;

    #----------------------------get syslog's information-------------------------------
    my $now_first=`head -n 1 ${syslog_file} 2>/dev/null`;
    chomp($now_first);
    my $now_length=`wc -l ${syslog_file} 2>/dev/null|awk '{print \$1}' 2>/dev/null`;
    chomp($now_length);
    my $rotate_first="";
    my $rotate_length=0;
    if(-f "${syslog_file}.1"){
        $rotate_first=`head -n 1 ${syslog_file}.1 2>/dev/null`;
        chomp($rotate_first);
        $rotate_length=`wc -l ${syslog_file}.1 2>/dev/null|awk '{print \$1}' 2>/dev/null`;
        chomp($rotate_length);
    }

    #---------------------------get last time's ending information---------------------------
    my $first_line="";
    my $line_num=0;
   
    my $first_run=0;

    if (-f ${info_file}){
        my @content=`cat ${info_file}`;
        foreach(@content){
            if( /^\s*$/ || /^\s*#/ ){
                next;
            }
            if($_=~/^\s*last_msg\s*=\s*(.*)$/){
                $first_line=$1;
            }
            if($_=~/^\s*last_line\s*=\s*(\d+)\s*$/){
                $line_num=$1;
            }
        }
        if(${first_line} eq ${now_first}){
            if(${now_length} < ${line_num}){
                $first_run=1;
            }else{
                $now_remain=$now_length-$line_num;
            }
        }elsif(${first_line} eq ${rotate_first}){
            $now_remain=$now_length;
            if(${rotate_length} < ${line_num}){
                $first_run=1;
            }else{
                $rotate_remain=$rotate_length-$line_num;
            }
        }else{
            $first_run=1;
        }
    }

    if((!-f ${info_file}) || $first_run == 1){
    	if($now_length < $firstRun_data){
    	    $now_remain=$now_length;
    	}else{
    	    $now_remain=$firstRun_data;
    	}
    }

    return ($now_first,$now_length,$now_remain,$rotate_first,$rotate_length,$rotate_remain);

}


sub handler{
    $stop_flag=1;
}


sub time_out{
    die "TIMEDOUT";
}


sub myexit{
    my $ret = shift;
    system("/bin/rm -f ${lock_file}");
    if($? != 0){
        print STDERR "Failed to delete lockfile ${lock_file}. Exit in perl script:"
                  ,__FILE__," line:",__LINE__+1,".\n";
        exit 2;
    }
    exit $ret;
}
