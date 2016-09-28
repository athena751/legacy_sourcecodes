#!/usr/bin/perl 
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: DdrScheduleCommon.pm,v 1.7 2007/09/10 11:22:09 liy Exp $"

package NS::DdrScheduleCommon;
use strict;
use constant COMMAND_VGRPL_QUERY    => "/usr/sbin/vgrpl_query ";
use constant CRONJOB_PATH           => "/home/nsadmin/bin/ddr_cronjob.pl";
use constant COMMAND_GETLD_INFO     => "/sbin/vgrcquery ";
use constant DISPLAY_NONE_INFO      => "--";
use constant RCLI_REPL2_LIST_VOL    => "/usr/lib/rcli/repl2 list vol 2>/dev/null";
use constant USERNAME_DDR			=> "ddr";
use NS::NsguiCommon;

my $cluster = new NS::NsguiCommon;

sub new(){
     my $this = {};     # Create an anonymous hash, and self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}

sub error(){
    my $self = shift;
    return $$self{ERROR};   
}

sub execCmd(){
    my ($self,$commandStr) = @_;
    my @result =`$commandStr`;
    if( $? ){
        $$self{ERROR} = join("",("Failed to run command \"$commandStr\". Exit in perl module:"
                                ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    return \@result;
}

sub openFile(){
    my ($self,$filePath) = @_;
    if(!-f $filePath){
        return [];
    }
    if (!open(FILE,$filePath)) {
        $$self{ERROR} = join("",("Failed to open \"$filePath\". Exit in perl module:"
                                ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    my @content = <FILE>;
    close(FILE);
    return \@content;
}
### Function:   get the mv name list
### Parameters: none
### Return:     ref of array(mv0,mv1...)    
sub getMvNameList(){
    my ($self,$groupNo) = @_;
    my @result;
    my @mvList = glob("/etc/group${groupNo}/vgrpl/*");
    foreach(@mvList){
        if(-d $_){
            my @rvList = glob($_."/*");
            foreach(@rvList){
                if(-f $_ && /^\/etc\/group${groupNo}\/vgrpl\/([^\s\/]+)\/[^\s\/]+\.[sr]pl$/){
                    push(@result,$1);
                    last;
                }
            }#end of foreach(@rvList)
        }#end of if
    }
    return \@result;
}
### Function:   execute command /sbin/vgrcquery and then get the needed info
### Parameters: mvName
### Return:     ref of Hash(volumeName=>[volumeLdNames,volumeDiskArrayName],...)    
sub getLDNameAndArrayName(){
    my ($self,$inputMvName) = @_;
    my %result;
    my $cmdResult = &execCmd($self,join("",COMMAND_GETLD_INFO,$inputMvName));
    if(!defined($cmdResult)){
        return undef;
    }
    my ($mvArrayName,$rvArrayName,$mvName,$rvName);
    my @mvLDList;
    my @rvLDList;
    my ($preMvName,$preRvName);
    #command's result:
    #group:	group0
    #
    #ArrayName:	DiskArray1	DiskArray1   
    #VG_Name:	NV_LVM_vg01	NV_RV0_vg01
    #LDName:	NAS_MV_LD1	NAS_RV_LD3
    #DevPath:	/dev/ld16	/dev/ld17
    #VAA:	200000004c5181db0010	200000004c5181db0011
    foreach(@$cmdResult){
        if(/^\s*ArrayName\s*:\s*(\S*)\s*(\S*)\s*$/i){
            $mvArrayName = defined($1)?$1:DISPLAY_NONE_INFO;
            $mvArrayName = ($mvArrayName=~/^\s*$/)?DISPLAY_NONE_INFO:$mvArrayName; 
            $rvArrayName = defined($2)?$2:DISPLAY_NONE_INFO;
            $rvArrayName = ($rvArrayName=~/^\s*$/)?DISPLAY_NONE_INFO:$rvArrayName; 
        }elsif(/^\s*VG_Name\s*:\s*(\S+)\s+(\S+)\s*$/i){
            $mvName = $1;
            $rvName = $2;
            if(defined($preRvName) && defined($preMvName) && ($preMvName eq $inputMvName)){
                if(!defined($result{$preMvName})){
                    $result{$preMvName} = [join(",",@mvLDList),$mvArrayName];
                }
                $result{$preRvName} = [join(",",@rvLDList),$rvArrayName];
            }
            $preMvName = $mvName;
            $preRvName = $rvName;
            @mvLDList = ();
            @rvLDList = ();
        }elsif(/^\s*LDName\s*:\s*(\S+)\s+(\S+)\s*$/i){
            my $mvldname = $1;
            my $rvldname = $2;
            if(scalar(grep(/^$mvldname$/,@mvLDList))==0){
                push(@mvLDList,$mvldname);
            }
            if(scalar(grep(/^$rvldname$/,@rvLDList))==0){
                push(@rvLDList,$rvldname);
            }
        }        
    }
    if(defined($preRvName) && defined($preMvName) && ($preMvName eq $inputMvName)){
        if(!defined($result{$preMvName})){
            $result{$preMvName} = [join(",",@mvLDList),$mvArrayName];
        }
        $result{$preRvName} = [join(",",@rvLDList),$rvArrayName];
    }
    if(scalar(keys(%result))==0){
        return undef;
    }
    return \%result;
}
### Function:   get the status info and schedule sign by input mv and rv
### Parameters: mvname,rvname
### Return:     e.g. (replicate,sync,1)    
sub getPairingStatusInfo(){
    my ($self,$mv,$rv) = @_;
    my $cmdString = join("",COMMAND_VGRPL_QUERY,"-mv $mv -rv $rv");
    my $cmdResult = &execCmd($self,$cmdString);
    if(!defined($cmdResult)){
        return ["-","-"];
    }
    my ($actState,$cpState);
    foreach(@$cmdResult){
        if(/^\s*Activity\s+State\s+(.+)\s*$/i){
            $actState = $1;
            if($actState =~/restore\s*\(protect\)/i){
                $actState = "restore[protect]";
            }
        }elsif(/^\s*Copy\s+Control\s+State\s+foreground\s+copy\s*\(\s*sync\s*\)\s*$/i){
            $cpState = "sync";
        }elsif(/^\s*Copy\s+Control\s+State\s+foreground\s+copy\s*\(\s*semi\s*\)\s*$/i){
            $cpState = "semi-sync";
        }elsif(/^\s*Copy\s+Control\s+State\s+normal\s+suspend\s*$/i){
            $cpState = "normalSuspend";
        }elsif(/^\s*Copy\s+Control\s+State\s+abnormal\s+suspend\s*$/i){
            $cpState = "abnormalSuspend";
        }elsif(/^\s*Copy\s+Control\s+State\s+background\s+copy\s*$/i){
            $cpState = "background";
        }elsif(/^\s*Copy\s+Control\s+State\s+freeze\s*$/i){
            $cpState = "freeze";
        }                   
    }
    if(!defined($actState)){
        $actState = "-";
    }
    if(!defined($cpState)){
        $cpState = "-";
    }
    return [$actState,$cpState];
}
### Function:   get the infos in the cron file
### Parameters: account--cron file's path which normally is /var/spool/cron/DDR
### Return:     ref of Hash like below:
###                  Key = mvName:rvName, Value = (* */4 * * *,replicate,background)   
sub getDdrScheduleInfo(){
    my ($self,$cronFile) = @_;
    my $cronContent = &openFile($self,$cronFile);
    if(!defined($cronContent)){
        return undef;
    }
    my %result;
    my $cronjobName = CRONJOB_PATH;
    foreach(@$cronContent){
        if(/^\s*([^#]+)\s+sudo\s+\Q${cronjobName}\E\s+(\S+)\s+(\S+)\s+(\S+)\s+/){
            if(index ($3,",")>0){
            	next;
            }
            if(defined($result{"$2 $3"})){
                my $tmpInfo = $result{"$2 $3"};
                push(@$tmpInfo,$1,$4);
                $result{"$2 $3"} = $tmpInfo;
            }else{
                $result{"$2 $3"} = [$1,$4];
            }
        }
    }
    return \%result;
}
### Function:   delete the content of cron file
### Parameters: fileContent--cron file's content
###             mv-----------mv's volume group name
###             rv-----------rv's volume group name
###             job-----------script to be executed
###             [timeStr-----time string like,1 1 * * * etc.]
### Return:     ref of Array which include the left content of cron file after deleting    
sub deleteScheduleInfo(){
    my ($self,$fileContent,$mvName,$rvName,$job,$timeStr) = @_;
    my @leftContent;
    if(defined($timeStr)){
        my $size = scalar(@$fileContent);
        for(my $i=0; $i<$size; $i++){
            if($$fileContent[$i]=~/^\s*#\s*MV\s*:\s*$mvName\s+RV\s*:\s*$rvName\s+BEGIN/
                && $$fileContent[$i+1]=~/^\s*\Q$timeStr\E\s+sudo\s+\Q${job}\E\s+$mvName\s+$rvName\s+/
                    && $$fileContent[$i+2]=~/^\s*#\s*MV\s*:\s*$mvName\s+RV\s*:\s*$rvName\s+END/){
                $i+=2;
            }elsif($$fileContent[$i]=~/^\s*\Q$timeStr\E\s+sudo\s+\Q${job}\E\s+$mvName\s+$rvName\s+/){
                next;
            }else{
                push(@leftContent,$$fileContent[$i]);
            }
        }
    }else{
        foreach(@$fileContent){
    		if(!/^\s*[^#]+\s+sudo\s+\Q${job}\E\s+$mvName\s+$rvName\s+/){
       			push(@leftContent,$_);
    		}
		}
		for(my $i=0;$i<scalar(@leftContent)-1;$i++){
   			if($leftContent[$i]=~/\s*#\s*MV\s*:\s*$mvName\s+RV\s*:\s*$rvName/
       			&& $leftContent[$i+1]=~/\s*#\s*MV\s*:\s*$mvName\s+RV\s*:\s*$rvName/){
        		splice(@leftContent,$i,2);
        		last;
    		}
		}
    }
    return \@leftContent;    
}
#Function:      synchronize the specified file to target Node.
#Arguments:     $cronFile: the file to synchronized;
#               $targetIP: the node's IP address;
#return value:  0---------success
#               1---------failed
sub syncDdrCronFile() {
    my $self        = shift;
    my $cronFile    = shift;
    my $targetIP    = shift;
    my $tmpFile = "/tmp/DDR.$$";
    system("sudo rm -f $tmpFile");
    if (system("sudo cat $cronFile > $tmpFile") != 0
        || &rshCmd($self, "sudo rm -f ${tmpFile}", $targetIP) != 0
        || system("sudo -u nsgui /usr/bin/rcp -p ${tmpFile} ${targetIP}:${tmpFile}") != 0
        || &rshCmd($self, "sudo /usr/bin/crontab -u ddr ${tmpFile}", $targetIP ) != 0)
    {
        system("sudo rm -f ${tmpFile}");
        &rshCmd( $self, "sudo rm -f ${tmpFile}", $targetIP );
        return 1;
    }
    system("sudo rm -f ${tmpFile}");
    &rshCmd( $self, "sudo rm -f ${tmpFile}", $targetIP );
    return 0;
}

#Function:  execute the specified command on target Node.
#Arguments: $cmd: the command to executed.
#           $targetIP:  the node's IP address;
#return value:
#   0---------success
#   1---------rsh failed;
sub rshCmd() {
    my $self     = shift;
    my $cmd      = shift;
    my $targetIP = shift;
    chomp($cmd);
    chomp($targetIP);
    if ( system("sudo -u nsgui /usr/bin/rsh ${targetIP} ${cmd}") != 0 ) {
        return 1;
    }
    return 0;
}

#Function: get all pairs. (Both node when cluster)
#Arguments: none
#return value: reference of a array
sub getAllPairs() {
	my $self = shift;
    my @allPairs = ();
    my $cmd = RCLI_REPL2_LIST_VOL;
    my @thisNodePairs = `$cmd`;
    my @otherNodePairs = ();
    my $targetIP = $cluster->getFriendIP();
    if (defined($targetIP) && $cluster->isActive($targetIP)==0 ){
    	my ($ret, $output) = $cluster->rshCmdWithSTDOUT("sudo $cmd", $targetIP);
        if(!defined($ret)) {
        	$$self{ERROR} = join("", ("Failed to run command \"/usr/bin/rsh\". Exit in perl module:"
                                , __FILE__, " line:", __LINE__, ".\n"));
            return undef;
        }
    	@otherNodePairs = @$output;
    }
    push(@thisNodePairs, @otherNodePairs);
    foreach(@thisNodePairs) {
    	if(/^\s*(\S+)\s+<==>\s+(\S+)\s*$/) {
    		push(@allPairs, "$1 $2");
    	}
    }
    return \@allPairs;
}

1;