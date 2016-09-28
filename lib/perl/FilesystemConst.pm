#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: FilesystemConst.pm,v 1.7 2007/07/11 07:36:25 jiangfx Exp $"

package NS::FilesystemConst;
use strict;
use NS::NsguiCommon;

my $nsguiCommon = new NS::NsguiCommon;

######################## constant definition begin ######################
## codepage constants
use constant CODEPAGE_LOWERCASE_UTF8        => "utf8";
use constant CODEPAGE_LOWERCASE_GUI_UTF_8   => "utf-8";
use constant CODEPAGE_LOWERCASE_ISO8859_1   => "iso8859-1";
use constant CODEPAGE_LOWERCASE_GUI_ENGLISH => "english";

## file constants
use constant FILE_NV_DEVTABLE => "/proc/hmd/devtable";
use constant FILE_ETC_GROUP_0 => "/etc/group0/";
use constant FILE_ETC_GROUP_1 => "/etc/group1/";

### no nick name
use constant NO_LVM_NICKNAME 					=> "--";

### constant for move function
use constant FILE_LVM_NICKNAME_NODE0    => "/etc/group0/lvm_nickname";
use constant FILE_LVM_NICKNAME_NODE1    => "/etc/group1/lvm_nickname";
use constant RRDFILE_PATH               => "/var/log/statistics/rrddata/";
use constant RRDFILE_PREFIX             => "/NAS_LV_IO/RRD";
use constant RRDFILE_SUFFIX             => ".rrd";
use constant CMD_CHECKOUT            => "/home/nsadmin/bin/checkout";
use constant CMD_CHECKIN             => "/home/nsadmin/bin/checkin";
use constant CMD_ROLLBACK            => "/home/nsadmin/bin/rollback";
use constant CMD_HOSTNAME            => "/bin/hostname";
use constant CMD_XFS_INFO            => "/usr/sbin/xfs_info";

## error code constant
### common error
use constant ERR_PARAM_NUM          => "0x13200000";
use constant ERR_PARAM_INVALID      => "0x13200001";
use constant ERR_ROOT_DIR_NOT_EXIST => "0x13200002";


### create error
use constant ERR_DIFF_FSTYPE        => "0x13200020";
use constant ERR_DIFF_ENCODEING_EUC         => "0x13200021";
use constant ERR_DIFF_ENCODEING_SJIS        => "0x13200022";
use constant ERR_DIFF_ENCODEING_IS0         => "0x13200023";
use constant ERR_DIFF_ENCODEING_UTF8        => "0x13200024";

### delete error
use constant ERR_GET_REPLICATION_STATUS			=> "0x13200060";
use constant ERR_RM_FILESET						=> "0x13200061";
use constant ERR_RM_EXPORT						=> "0x13200062";
use constant ERR_RM_IMPORT						=> "0x13200063";
use constant ERR_CMD_XFS_INFO                   => "0x13200064";


use constant ERR_HAS_MOUNTED            => "0x13200030";
use constant ERR_VG_HAS_PAIR            => "0x13200040";

## error code for move function
use constant ERR_HAS_ORIGINAL       => "0x13200051";
use constant ERR_HAS_REPLICA        => "0x13200052";
use constant ERR_HAS_SCHEDULE       => "0x13200054";
use constant ERR_HAS_AUTH           => "0x13200053";
use constant ERR_EXPORTGOUP              => "0x13200055";
use constant ERR_DIRECTORY_EXIST         => "0x13200056";
use constant ERR_NOT_SAME_FSTYPE         => "0x13200057";
use constant ERR_PARENT_READONLY         => "0x13200058";
use constant ERR_PARENT_HAS_REPLICATION  => "0x13200059";
use constant ERR_CHECKOUT_CFSTAB         => "0x13200070";
use constant ERR_DELETE_PSID             => "0x13200071";
use constant ERR_LVM_MOVE                => "0x13200072";
use constant ERR_FILESYSTEM_MOVE         => "0x13200073";
use constant ERR_MOUNT_IN_DESTINATION         => "0x13200074";
use constant ERR_LOGIN_PSID_IN_DESTINATION    => "0x13200075";
use constant ERR_DIRECTMP_UMOUNTED            => "0x13200076";

my %errMsgHash = ();    ###save error code and error message
my %codePageHash = ();  ###save code page and error code

### code page=>error code
$codePageHash{"euc-jp"}    =   "0x13200021";
$codePageHash{"sjis"}      =   "0x13200022";
$codePageHash{"iso8859-1"} =   "0x13200023";
$codePageHash{"utf8"}      =   "0x13200024";
$codePageHash{"utf8-nfc"}  =   "0x13200025";

### error message
$errMsgHash{"0x13200000"}   =   "Parameter's number is wrong!";
$errMsgHash{"0x13200060"}   =   "Failed to get replication status.";
$errMsgHash{"0x13200061"}   =   "Failed to execute command /usr/bin/syncconf rmfset -f.";
$errMsgHash{"0x13200062"}   =   "Failed to execute command /usr/bin/syncconf rmexport -f.";
$errMsgHash{"0x13200063"}   =   "Failed to execute command /usr/bin/syncconf rmimport -f.";
$errMsgHash{"0x13200064"}   =   "Failed to execute command /usr/sbin/xfs_info.";

$errMsgHash{"0x13200001"} = "Parameter is invalid.";  
$errMsgHash{"0x13200002"} = "The directory %s doesn't exist.";  

$errMsgHash{"0x13200030"} = "Mount point has been mounted by others.";

$errMsgHash{"0x13200040"} = "Replication(MVDSync) cannot be specified because the logical volume is used in ReplicationControl.";

$errMsgHash{"0x13200020"} = "Can't create the mount point because different fstype.";
$errMsgHash{"0x13200021"} = "Can't create the mount point because different encoding.";

## error message for move function
$errMsgHash{"0x13200051"}   =   "Original has been set on this mount point or its sub mount.";
$errMsgHash{"0x13200052"}   =   "Replica has been set on this mount point or its sub mount.";
$errMsgHash{"0x13200053"}   =   "Auth has been set on this mount point.";
$errMsgHash{"0x13200054"}   =   "Snapshot schedule has been set on this mount point or its sub mount.";
$errMsgHash{"0x13200055"}   =   "The encoding of export group is not same to source mount point.";
$errMsgHash{"0x13200056"}   =   "The destination mount point directory already exists.";
$errMsgHash{"0x13200057"}   =   "The fstype of the destination's parent is not same to the source mount point.";
$errMsgHash{"0x13200058"}   =   "The access mode of the destination's parent is read only.";
$errMsgHash{"0x13200059"}   =   "The destination's parent has been set replication.";
$errMsgHash{"0x13200070"}   =   "Failed to checkout cfstab.";
$errMsgHash{"0x13200071"}   =   "Failed to delete PSID.";
$errMsgHash{"0x13200072"}   =   "Failed to move logical volume between nodes.";
$errMsgHash{"0x13200073"}   =   "Failed to move file system between nodes.";
$errMsgHash{"0x13200074"}   =   "Failed to mount file system in destination.";
$errMsgHash{"0x13200075"}   =   "Failed to login PSID in destination.";
$errMsgHash{"0x13200076"}   =   "The direct mount point of destination has not been mounted.";

######################## constant definition end ######################

sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}


### sub functions definition ##########
##Function
##    print error message and output error code.
##Parameter
##    $errCode -- error code
sub printErrMsg(){
    my $self = shift;
    my $errCode = shift;
    my $errMsg  = $errMsgHash{$errCode};
    
    if(defined($errMsg)){
        $errMsg = sprintf($errMsg , @_);
        print STDERR $errMsg."\n";
    }
    $nsguiCommon->writeErrMsg($errCode);
}


### sub functions definition ##########
##Function
##    get errpr code form codePageHash.
##Parameter
##    $codePage -- codePage
sub getErrorCode(){
    my $self = shift;
    my $codePage = shift;
    return $codePageHash{$codePage};
}

1;