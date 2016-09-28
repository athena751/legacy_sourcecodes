#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#"@(#) $Id: DdrConst.pm,v 1.9 2008/07/21 05:46:46 xingyh Exp $"

package NS::DdrConst;
use strict;
use NS::NsguiCommon;
use NS::Syslog;
my $nsguiCommon = new NS::NsguiCommon;

use constant ERR_FLAG       	                   => "ERROR";
use constant SUCCESS_CODE   	                   => "0x00000000";


## define constant of file and command
use constant CMD_CAT                               => "/bin/cat";
use constant CMD_LDDEV2LDNAME                      => "/sbin/lddev2ldname";
use constant CMD_REPL2                             => "/opt/nec/nvtools-rplctl/bin/repl2";
use constant CMD_REPL2_LIST_VOL                    => "/opt/nec/nvtools-rplctl/bin/repl2 list vol";
use constant CMD_REPL2_LIST_LD                     => "/opt/nec/nvtools-rplctl/bin/repl2 list ld";
use constant CMD_REPL2_INFO_VOL_PAIR               => "/opt/nec/nvtools-rplctl/bin/repl2 info vol pair";
use constant CMD_REPL2_SCHED_LIST                  => "/opt/nec/nvtools-rplctl/bin/repl2 sched list";
use constant CMD_RCLI_VOL_SCAN                     => "/usr/lib/rcli/vol scan >&/dev/null";
use constant PATH_ETC_NODE0                        => "/etc/group0/";
use constant PATH_ETC_NODE1                        => "/etc/group1/";
use constant CMD_REPL2_PAIR_VOL                    => "/opt/nec/nvtools-rplctl/bin/repl2 pair vol";
use constant CMD_REPL2_REPLICATE                   => "/opt/nec/nvtools-rplctl/bin/repl2 replicate";
use constant CMD_REPL2_ADD_SCHEDULE                => "/opt/nec/nvtools-rplctl/bin/repl2 sched";
use constant CMD_REPL2_VOLLIST_SCAN                => "/opt/nec/nvtools-rplctl/bin/repl2 vollist scan";
use constant CMD_REPL2_EXTEND_RV                   => "/opt/nec/nvtools-rplctl/bin/repl2 extend";
use constant CMD_VOL_SCAN                          => "/opt/nec/nvtools-fs/bin/vol scan";
use constant CMD_LDNAME_TO_LDDEV                   => "/sbin/ldname2lddev";
use constant ASYNCPAIR_FILE                        => "/opt/nec/nsadmin/etc/ddr_asyncfile";
use constant CMD_VG_GETGROUP                       => "/sbin/vg_getgroup";
use constant CMD_VGPAIRCHECK                       => "/sbin/vgpaircheck";
use constant SCRIPT_DDR_MAKE_PAIR                  => "/opt/nec/nsadmin/bin/ddr_makePair.pl";
use constant SCRIPT_DDR_EXTEND_PAIR                => "/opt/nec/nsadmin/bin/ddr_extendPair.pl";
use constant SCRIPT_GET_CANDIDATE_MV               => "/opt/nec/nsadmin/bin/ddr_getCandidateMvInfo.pl";
use constant DDR_HASASYNCPAIR4ONENODE_PL           => "/opt/nec/nsadmin/bin/ddr_hasAsyncPair4OneNode.pl";
use constant CMD_CHECK_RV_CAPACITY                 => "/sbin/check_rv_capacity";
## define error code
use constant ERR_PARAMETER_COUNT                   => "0x13700000";
use constant ERR_EXECUTE_REPL2_LIST_VOL            => "0x13700001";
use constant ERR_EXECUTE_REPL2_INFO_VOL_PAIR       => "0x13700002";
use constant ERR_EXECUTE_REPL2_SCHED_LIST          => "0x13700003";
use constant ERR_EXECUTE_GROUP_CFSTAB              => "0x13700004";
use constant ERR_EXECUTE_REPL2_LIST_LD             => "0x13700005";

use constant DDR_EXCEP_WRONG_PARAMETER             => "0x13700010";
use constant DDR_EXCEP_CAN_NOT_UNPAIR              => "0x13700011";
use constant DDR_EXCEP_UNPAIR_FAILED_UNKNOWN       => "0x13700012";
use constant DDR_EXCEP_DELETE_SCHEDULE_FAILED      => "0x13700019";

use constant ERR_EXECUTE_LDNAME2LDDEV              => "0x13700020";
use constant ERR_EXECUTE_REPL2_VOLLIST_SCAN        => "0x13700021";
use constant ERR_EXECUTE_VOL_SCAN                  => "0x13700022";
use constant ERR_EXECUTE_VOL_SCAN_IN_FRIEND_NODE   => "0x13700023";

use constant ERR_EXE_REPL2_PAIR_VOL                => "0x13700031";
use constant ERR_EXE_REPL2_ADD_SCHEDULE            => "0x13700051";
use constant ERR_EXE_REPL2_REPLICATE               => "0x13700052";
use constant ERR_EXE_REPL2_SEPARATE                => "0x13700053";

use constant DDR_EXCEP_MODIFY_READCRON   		   => "0x13700061";
use constant DDR_EXCEP_MODIFY_EDITCRON 		   	   => "0x13700062";
use constant DDR_EXCEP_MODIFY_RELOADCRON   		   => "0x13700063";
use constant DDR_EXCEP_MODIFY_SYNCCRON 		       => "0x13700064";

use constant ERR_EXE_LOCALE_GET_CANDIDATE_MV       => "0x13700071";
use constant ERR_EXE_REMOTE_GET_CANDIDATE_MV       => "0x13700072";
use constant ERR_PARAM_UNKNOWN                     => "0x13700073";
use constant ERR_RV_MP_ALREADY_EXIST               => "0x13700074";
use constant ERR_RV_DIF_CODEPAGE                   => "0x13700075";
use constant ERR_GET_CODEPAGE                      => "0x13700076";
use constant ERR_CHECK_RV_CAPACITY                 => "0x13700077";

use constant ERR_EXTEND_SYNCSTATE_INVALID          => "0x13700090";
use constant ERR_EXTEND_CHECK_SIZE                 => "0x13700091";

use constant ERR_OPEN_FILE_READING                 => "0x137000a0";
use constant ERR_EXECUTE_VGGETGROUP                => "0x137000a1";
use constant ERR_EXECUTE_CAT_FRIEND                => "0x137000a2";

use constant OPERATING_CODE   	                   => "0x137f0000";
use constant OPERATED_CODE 	                       => "0x137fffff";
use constant OPERATE_STOP_CODE 	                   => "0x137ffffe";
use constant DDR_EXCEP_CHECKOUT                    => "0x137f0001";
use constant DDR_EXCEP_CHECKIN                     => "0x137f0002";
use constant DDR_EXCEP_FAILED_TO_GET_ASYNCPAIRINFO => "0x137f0003";
use constant DDR_EXCEP_FAILED_TO_WRITE_ASYNCPAIRINFO => "0x137f0004";
use constant DDR_EXCEP_PROCESS_HAS_DIED            => "0x137f0005";
use constant DDR_EXCEP_ABNORMAL_COMPOSITION        => "0x137fcccc";
use constant ERR_EDIT_DDR_ASYNCFILE                => "0x137f0006";
use constant ERR_NOT_ASYNC_PAIR_RESULT             => "0x137f0007";

###for old ddr module
use constant DDR_EXCEP_NO_SAME_SCHEDULE            => "0x13711111";
use constant DDR_EXCEP_NO_CRONTAB_FAILED           => "0x13711112";

###for old ddr module

# define constant name
use constant PAIRINFO_USAGE   	                   => "usage";
use constant PAIRINFO_MVNAME   	                   => "mvname";
use constant PAIRINFO_RVNAME   	                   => "rvname";
use constant PAIRINFO_ACTIVITYSTATE                => "ActivityState";
use constant PAIRINFO_SYNCSTATE                    => "syncState";
use constant PAIRINFO_PROGRESSRATE                 => "progressRate";
use constant PAIRINFO_STARTTIME                    => "startTime";
use constant PAIRINFO_ENDTIME                      => "endTime";
use constant PAIRINFO_RV_ACCESS                    => "rvAccess";
use constant PAIRINFO_PRE_ACTIVE                   => "preActive";
use constant PAIRINFO_SCHEDULE	                   => "schedule";
use constant PAIRINFO_STATUS	                   => "status";
use constant PAIRINFO_MV_RESULT_CODE               => "mvResultCode";
use constant PAIRINFO_RV_RESULT_CODE               => "rvResultCode";
use constant PAIRINFO_SCHED_RESULT_CODE            => "schedResultCode";
use constant PAIRINFO_MVLDNAMELIST                 => "mvLdNameList";
use constant PAIRINFO_RVLDNAMELIST                 => "rvLdNameList";
use constant PAIRINFO_COPYCONTROLSTATE             => "copyControlState";

use constant PAIRINFO_SEPARATEDIFF                 => "separateDiff";
use constant PAIRINFO_COPYDIFF                     => "copyDiff";
use constant PAIRINFO_MVLDNAME                     => "mvLdName";
use constant PAIRINFO_RVLDNAME                     => "rvLdName";

use constant PAIRINFO_STATUS_EXTEND			   	   => "extend";
use constant PAIRINFO_STATUS_EXTENDING			   => "extending";
use constant PAIRINFO_STATUS_EXTENDED			   => "extended";
use constant PAIRINFO_STATUS_EXTEND_FAIL		   => "extendfail";
use constant PAIRINFO_STATUS_EXTEND_MV_FAIL		   => "extendmvfail";
use constant PAIRINFO_STATUS_CREATE			   	   => "create";
use constant PAIRINFO_STATUS_CREATING			   => "creating";
use constant PAIRINFO_STATUS_CREATED		   	   => "created";
use constant PAIRINFO_STATUS_CREATE_FAIL		   => "createfail";
use constant PAIRINFO_STATUS_CREATE_SCHED_FAIL	   => "createschedfail";
use constant PAIRINFO_STATUS_ABNORMAL_COMPOSITION  => "abnormalcomposition";

use constant USAGE_ALWAYS                          => "always";
use constant USAGE_D2D2T                           => "d2d2t";
use constant USAGE_GENERATION                      => "generation";

use constant ACTIVITYSTATE_SEPARATE                => "separate";
use constant ACTIVITYSTATE_REPLICATE               => "replicate";
use constant ACTIVITYSTATE_RESTORE                 => "restore";
use constant ACTIVITYSTATE_RESTORE_PROTECT         => "restore(protect)";
use constant SYNCSTATE_SEPARATED                   => "separated";
use constant SYNCSTATE_RPL_SYNC                    => "rpl/sync";
use constant SYNCSTATE_RST_SYNC                    => "rst/sync";
use constant SYNCSTATE_CANCEL                      => "cancel";
use constant SYNCSTATE_FAULT                       => "fault";
use constant SYNCSTATE_SEP_EXEC                    => "sep/exec";
use constant SYNCSTATE_RPL_EXEC                    => "rpl/exec";
use constant SYNCSTATE_RST_EXEC                    => "rst/exec";

use constant COPYCONTROLSTATE_ABNORMAL_SUSPEND     => "abnormal suspend";

use constant LDINFO_ATTRIBUTE                      => "Attribute";
use constant LDINFO_CAPACITY                       => "Capacity";

use constant WRITE_LOG_PROGRAM    => "iStorageManager IP DISK BACKUP";
##Error message defination
my %errMsgHash = ();
my %errCodeHash = ();

$errMsgHash{"0x13700000"} = "The param number is not correct. Please input one param.";
$errMsgHash{"0x13700001"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 list vol.";
$errMsgHash{"0x13700002"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 info vol pair.";
$errMsgHash{"0x13700003"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 sched list.";
$errMsgHash{"0x13700004"} = "Failed to execute /etc/group[0|1]/cfstab.";
$errMsgHash{"0x13700005"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 list ld.";

$errMsgHash{"0x13700010"} = "Parameter's number is wrong.";
$errMsgHash{"0x13700011"} = "The sync state of the pair is sep/exec.";
$errMsgHash{"0x13700012"} = "Unknown unpair error occured";
$errMsgHash{"0x13700213"} = "The state of system is takeover.";
$errMsgHash{"0x13700214"} = "Failed to get the RPL file path.";
$errMsgHash{"0x13700215"} = "Failed to create TMP file.";
$errMsgHash{"0x13700216"} = "Failed to delete VG pair";
$errMsgHash{"0x13700217"} = "Failed to delete LD pair.";
$errMsgHash{"0x13700218"} = "Failed to delete the ld device link.";
$errMsgHash{"0x13700219"} = "Failed to delete the logical disk(s).";
$errMsgHash{"0x1370021a"} = "Failed to check the usage of the logical volume.";
$errMsgHash{"0x1370021b"} = "Failed to rescan the logical disk(s).";
$errMsgHash{"0x1370021c"} = "Failed to get RVVG.";
$errMsgHash{"0x13700019"} = "Failed to excute /opt/nec/nvtools-rplctl/bin/repl2 sched del.";

$errMsgHash{"0x13700020"} = "Failed to execute /sbin/ldname2lddev.";
$errMsgHash{"0x13700021"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 vollist scan on partner node.";
$errMsgHash{"0x13700022"} = "Failed to execute /opt/nec/nvtools-fs/bin/vol scan.";
$errMsgHash{"0x13700023"} = "Failed to execute /opt/nec/nvtools-fs/bin/vol scan on partner node.";

$errMsgHash{"0x13700031"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2. Internal error has occured.";
$errMsgHash{"0x13700032"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Excute on Nas Gateway.";
$errMsgHash{"0x13700033"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to make LD.";
$errMsgHash{"0x13700034"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to pair LD.";
$errMsgHash{"0x13700035"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to initialize LUN.";
$errMsgHash{"0x13700036"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to set VG pair.";
$errMsgHash{"0x13700037"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to get the LD name.";
$errMsgHash{"0x13700038"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to get LD size.";
$errMsgHash{"0x1370003a"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to recognize the information of LD.";
$errMsgHash{"0x1370003b"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. MV exists in the specified pool.";
$errMsgHash{"0x1370003c"} = "Failed to allocate a pool to RV. Please check the current status of the system.";
$errMsgHash{"0x1370003d"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. Failed to create a mount point. ";
$errMsgHash{"0x1370003f"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. System is in reduce state.";
$errMsgHash{"0x13700040"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. The specific RV is in use.";
$errMsgHash{"0x13700041"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 pair vol. The specific VG is already exist.";

$errMsgHash{"0x13700051"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 sched add.";
$errMsgHash{"0x13700052"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 replicate.";
$errMsgHash{"0x13700053"} = "Failed to execute /opt/nec/nvtools-rplctl/bin/repl2 separate.";

$errMsgHash{"0x13700061"} = "Failed to get the content of the cron file.";
$errMsgHash{"0x13700062"} = "Failed to edit the cron file.";
$errMsgHash{"0x13700063"} = "Failed to restart crond.";
$errMsgHash{"0x13700064"} = "Failed to synchronize the cron information to partner node.";

$errMsgHash{"0x13700070"} = "Failed to cat /export/group[0|1]/expgrps.";
$errMsgHash{"0x13700071"} = "Failed to execute /opt/nec/nsadmin/bin/ddr_getCandidateMvInfo.pl on this node.";
$errMsgHash{"0x13700072"} = "Failed to execute /opt/nec/nsadmin/bin/ddr_getCandidateMvInfo.pl on partner node.";
$errMsgHash{"0x13700073"} = "The sub command parameter is unknown.";
$errMsgHash{"0x13700074"} = "Failed to make D2D2T pair. The specific mount point of RV is already exist.";
$errMsgHash{"0x13700075"} = "Failed to make D2D2T pair. The specific mount point of RV is not the same with that of MV.";
$errMsgHash{"0x13700076"} = "Failed to get the code page of the MV";
$errMsgHash{"0x13700077"} = "Cannot create RV on the specified pool(s). For the pool capacity is not enough for the pair.";
$errMsgHash{"0x13700090"} = "The pair cannot be extended except when \"Sync state\" of the pair is in the state of \"Separated\".";
$errMsgHash{"0x13700091"} = "Cann't create pair with the specified pool(s)";

$errMsgHash{"0x137000a0"} = "Failed to open file for reading.";
$errMsgHash{"0x137000a1"} = "Failed to execute /sbin/vg_getgroup.";
$errMsgHash{"0x137000a2"} = "Failed to execute /bin/cat on partner node.";

$errMsgHash{"0x137f0001"} = "Failed to checkout /opt/nec/nsadmin/etc/ddr_asyncfile.";
$errMsgHash{"0x137f0002"} = "Failed to checkin /opt/nec/nsadmin/etc/ddr_asyncfile.";
$errMsgHash{"0x137f0003"} = "Failed to get async pair informations.";
$errMsgHash{"0x137f0004"} = "Failed to write async pair informations.";
$errMsgHash{"0x137f0005"} = "The background process terminated.";
$errMsgHash{"0x137f0006"} = "Failed to edit file /opt/nec/nsadmin/etc/ddr_asyncfile.";
$errMsgHash{"0x137f0007"} = "The pair information doesn't exist in /opt/nec/nsadmin/etc/ddr_asyncfile.";

##common internal error
$errCodeHash{1}  = "0x13700031";  

##create error
$errCodeHash{2}  = "0x13700032";
$errCodeHash{3}  = "0x13700033";
$errCodeHash{4}  = "0x13700034";
$errCodeHash{5}  = "0x13700035";
$errCodeHash{6}  = "0x13700036";
$errCodeHash{7}  = "0x13700037";
$errCodeHash{8}  = "0x13700038";
$errCodeHash{10} = "0x1370003a";
$errCodeHash{11} = "0x1370003b";
$errCodeHash{12} = "0x1370003c";
$errCodeHash{13} = "0x1370003d";
$errCodeHash{15} = "0x1370003f";
$errCodeHash{16} = "0x13700040";
$errCodeHash{17} = "0x13700041";

##extend error
$errCodeHash{103}  = "0x137f0113";
$errCodeHash{104}  = "0x137f0114";
$errCodeHash{105}  = "0x137f0115";
$errCodeHash{106}  = "0x137f0116";
$errCodeHash{107}  = "0x137f0117";
$errCodeHash{108}  = "0x137f0118";
$errCodeHash{110}  = "0x137f011a";
$errCodeHash{111}  = "0x137f011b";
$errCodeHash{112}  = "0x137f011c";
$errCodeHash{115}  = "0x137f011f";
$errCodeHash{116}  = "0x137f0120";
$errCodeHash{117}  = "0x137f0121";
$errCodeHash{118}  = "0x137f0122";
$errCodeHash{120}  = "0x137f0124";

##delete error
$errCodeHash{203}  = "0x13700213";
$errCodeHash{204}  = "0x13700214";
$errCodeHash{205}  = "0x13700215";
$errCodeHash{206}  = "0x13700216";
$errCodeHash{207}  = "0x13700217";
$errCodeHash{208}  = "0x13700218";
$errCodeHash{209}  = "0x13700219";
$errCodeHash{210}  = "0x1370021a";
$errCodeHash{211}  = "0x1370021b";
$errCodeHash{212}  = "0x1370021c";

## Async make pair
use constant SCRIPT_PARI_ASYNC_OPERATION => "/home/nsadmin/bin/ddr_makePair.pl";


###sub functions defination start ###
sub new() {
	my $this = {};    # Create an anonymous hash, and #self points to it.
	bless $this;      # Connect the hash to the package update.
	return $this;     # Return the reference to the hash.
}

### sub functions definition ##########
##function: print error message and output error code.
##parameter:
##      $errCode -- error code
##      $args    -- arguments to replace %s in the error message
sub printErrMsg() {
	my $self    = shift;
	my $errCode = shift;
	my $file    = shift;
	my $line    = shift;
	my $errMsg  = $errMsgHash{$errCode};

	if ( defined($errMsg) ) {
		##$errMsg = sprintf($errMsg , @_);
		print STDERR $errMsg . "\n";
	}
	$nsguiCommon->writeErrMsg( $errCode, $file, $line );
}

### sub functions definition ##########
##Function
##    get error code form errCodeHash.
##Parameter
##    $code -- repl2 pair vol result Code
sub getErrorCode(){
    my $self = shift;
    my $code = shift;
    my $errCode = "0x13700031";
    if($errCodeHash{$code}){
        $errCode = $errCodeHash{$code};
    }
    return $errCode;
}
sub writeLog(){
    my $self = shift;
    my $code = shift;
    my $errMsg = $code;
    if(defined($errMsgHash{$code})){
        $errMsg = "$code: $errMsgHash{$code}";
    }
    $nsguiCommon->writeLog(WRITE_LOG_PROGRAM, LOG_ERR, $errMsg);
}
1;
