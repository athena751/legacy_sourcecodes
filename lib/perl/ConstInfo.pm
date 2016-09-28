#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: ConstInfo.pm,v 1.2307 2007/03/07 05:12:01 zhangjun Exp $"


#Coding by Wang Zhoufei,NAS-Group.
package NS::ConstInfo;
use strict;
use NS::Syslog;

    my $NAS             = "NAS";
    my $IPSAN           = "IPSAN";
    my $FCSAN           = "FCSAN";
    my $CPUStatesOID    = ".1.3.6.1.4.1.2021.60.101";
    my $RpqNum          ="0002";
    
    my $CPUStates       = "CPU_States";
    my $NetworkIO       = "Network_IO";
    #my $networkPackets = "NETWORK_Packets";
    my $Filesystem      = "Filesystem";
    my $Filesystem_Quantity      = "Filesystem_Quantity";
    #my $physicalDisk = "PHYSICAL_Disk";
    my $NAS_LV_IO       = "NAS_LV_IO";
    my $FCSAN_LD_IO     = "FCSAN_LD_IO";
    my $FCSAN_PD_IO     = "FCSAN_PD_IO";
    my $iSCSI_Session   = "iSCSI_Session";
    my $iSCSI_Auth      = "iSCSI_Auth";
    my $Anti_Virus_Scan = "Anti_Virus_Scan";
    
    my $CPUUserErr      = "Failed to get cpuUserTime of ";
    my $CPUNiceErr      = "Failed to get cpuNiceTime of ";
    my $CPUSystemErr    = "Failed to get cpuSystemTime of ";
    my $CPUIdleErr      = "Failed to get cpuIdleTime of";
    
    my $CPUNumErr       = "Failed to get the number of CPUs.";
    my $CPUNameErr      = "Failed to get name of CPU:";
    #my $CPUDataErr = "Failed to get data of CPU:";
    my $RRDDefInfoErr   = "Failed to acquire information that defines RRD file.";
    my $RRDCreateErr    = "Failed to create RRD: ";
    my $parameterErr    = "Failed to get parameters.";
    my $RRDUpdateErr    = "Failed to update RRD: ";
    my $SNMPErr         = "No response from snmpd(timed out).";
    my $NoSuchItemErr   = "The target does not support such collection item.";
    my $NoSuchTargetErr = "No such type of target.";
    # define a base code to a type of err.
    my $BNoSuchTargetErr    = 1; # base code of NoSuchTargetErr
    my $BNoSuchItemErr      = 2;# base code of NoSuchItemErr
    my $BSNMPErr            = 3;
    my $BParameterErr       = 4;
    my $BRRDDefInfoErr      = 5;
    my $BRRDCreateErr       = 6;
    my $BRRDUpdateErr       = 7;

    my $BCPUNumErr          = 1000; # base code of CPUNumErr
    my $BCPUNameErr         = 2000; # base code of CPUNameErr
    my $BCPUUserErr         = 3000; # base code of CPUUserTimeErr
    my $BCPUNiceErr         = 4000; # base code of CPUNiceTimeErr
    my $BCPUSystemErr       = 5000; # base code of CPUSystemTimeErr
    my $BCPUIdleErr         = 6000; # base code of CPUIdleTimeErr
    
    # define some const strings 
    my $host                = "host"; # hostname or ip address of SNMP agent
    my $collectionItem      = "collectionItem"; # SNMP community string
    my $SNMP                = "snmp";
    my $community           = "community"; # SNMP community string
    my $port                = "port"; # allow remote UDP port to be overridden
    my $version             = "version"; # version of snmp
    my $user                = "user"; # security name
    my $authType            = "authType"; # security level
    my $auth                = "auth"; # authentication protocol
    my $authPassPhrase      = "authPassPhrase"; # authentication passphrase
    my $privProto           = "priv"; # privacy protocol
    my $privPassPhrase      = "privPassPhrase"; # privacy passphrase
    
    my $cluster             = "CLUSTER";
    my $standAlone          = "STANDALONE";
    my $scattered           = "SCATTERED";
    my $multiple            = "MULTIPLE";
    
    #constant of collector thread   liuhy add at 2001/10/23
    
    my $flagFileSubDir      = "var/rrddata/";
    my $flagFileAcitve      = ".Active";
    my $flagFileUpdate      = ".Update";
    my $flagFileLock        = ".Lock";
    
    #some file name
    my $collectorThread     = "CollectorThread";
    my $collector           = "Collector.pl";
        
    #constant about syslog
    my $syslogEmerg         = LOG_EMERG;
    my $syslogAlert         = LOG_ALERT;
    my $syslogCrit          = LOG_CRIT;
    my $syslogErr           = LOG_ERR;
    my $syslogWarning       = LOG_WARNING;
    my $syslogNotice        = LOG_NOTICE;
    my $syslogInfo          = LOG_INFO;
    my $syslogDebug         = LOG_DEBUG;
    
    my $syslogSymbol        = "NSPerformanceMonitor";
    
    #error information about collector thread
    my $colThreadCLNumErr
        = "The number of parameters in command line of collector is wrong.\n"; 
    my $colThreadTarStatErr
        = "Failed to judge whether target is on or off.\n";
    my $lockRRDNodefErr
        = "No such target or collection item.\n";
    my $lockRRDFailed
        = "Failed to lock RRD file.\n";
    my $colThreadLoadRRDInfoErr
        = "Failed to load RRDfile.\n";
    my $colThreadForkErr
        = "Failed to fork.\n";
    my $colThreadLoadDefErr
        = "Failed to load file.\n";
    my $colThreadGetTargetFailed
        = "Failed to get target list.\n";
    my $colThreadNewMonitorFailed
        = "Failed to new object of MonitorConfig.\n";
    my $colThreadCantFork
        = "Failed to fork.\n";
    my $colThreadCLParamErr
        = "The parameters in command line are invalid.\n";    
    
    #END of constant about colletor thread
    my $NetworkOID = ".1.3.6.1.4.1.2021.65.101";
    my $EthNumErr
        = "Failed to get the number of network interfaces.";
    my $BEthNumErr          = 7000;
    my $EthNameErr
        = "Failed to get the name of network interface.";
    my $BEthNameErr         = 8000;
    my $InOctetsErr
        = "Failed to get InOctets of network interface.";
    my $BInOctetsErr        = 9000;
    my $OutOctetsErr
        = "Failed to get OutOctets of network interface.";
    my $BOutOctetsErr       = 10000;
    my $InPacketsErr
        = "Failed to get InPackets of network interface.";
    my $BInPacketsErr       = 11000;
    my $OutPacketsErr
        = "Failed to get OutPackets of network interface.";
    my $BOutPacketsErr      = 12000;
    my $InErrorsErr
        = "Failed to get InErrors of network interface.";
    my $BInErrorsErr        = 13000;
    my $OutErrorsErr
        = "Failed to get OutErrors of network interface.";
    my $BOutErrorsErr       = 14000;
    my $InDropErr
        = "Failed to get InDrop of network interface.";
    my $BInDropErr          = 15000;
    my $OutDropErr
        = "Failed to get OutDrop of network interface.";
    my $BOutDropErr         = 16000;
    my $CollisionErr
        = "Failed to get Collision of network interface.";
    my $BCollisionErr       = 17000;
    
    my $DeviceFileOID = ".1.3.6.1.4.1.2021.70.101";
    my $DeviceFileNumErr
        = "Failed to get the number of filesystems.";
    my $BDeviceFileNumErr   = 18000;
    my $DeviceFileNameErr
        = "Failed to get the name of device file.";
    my $BDeviceFileNameErr  = 19000;
    my $FilesystemTypeErr
        = "Failed to get type of filesystem.";
    my $BFilesystemTypeErr  = 20000;
    my $MountPointErr
        = "Failed to get mount point of device file.";
    my $BMountPointErr      = 21000;
    my $DiskAvailableErr
        = "Failed to get DiskAvailable of device file.";
    my $BDiskAvailableErr   = 22000;
    my $InodeAvailableErr
        = "Failed to get InodeAvailable of device file.";
    my $BInodeAvailableErr  = 23000;
    my $TotalSizeErr
        = "Failed to get total size of filesystem.";
    my $BTotalSizeErr       = 24000;
    my $TotalInodesErr
        = "Failed to get total inodes of filesystem.";
    my $BTotalInodesErr     = 25000;
    my $DiskUsedErr
        = "Failed to get disk used of filesystem.";
    my $BDiskUsedErr        = 26000;
    my $InodeUsedErr
        = "Failed to get inode used of filesystem.";
    my $BInodeUsedErr       = 27000;
    
    my $LogicalVolumeOID = ".1.3.6.1.4.1.2021.71.101";
    my $LV_NumErr="Failed to get the number of logical volumes.";
    my $BLV_NumErr          = 28000;
    my $LV_NameErr
        = "Failed to get name of logical volume.";
    my $BLV_NameErr         = 29000;
    my $Read_IOErr
        = "Failed to get total reads of logical volume.";
    my $BRead_IOErr         = 30000;
    my $Write_IOErr
        = "Failed to get total writes of logical volume.";
    my $BWrite_IOErr        = 31000;

    my $iSCSI_Session_OID = ".1.3.6.1.4.1.2021.80.101";
    my $BiSCSI_Num_Err      = 32000;
    my $iSCSI_Num_Err
        = "Failed to get the number of iSCSI sessions.";
    my $BiSCSI_Name_Err     = 33000;
    my $iSCSI_Name_Err
        = "Failed to get name of iSCSI.";
    my $BiscsiInstSsnDigestErrors_Err       = 34000;
    my $iscsiInstSsnDigestErrors_Err
        = "Failed to get iscsiInstSsnDigestErrors of iSCSI.";
    my $BiscsiInstSsnCxnTimeoutErrors_Err   = 35000;
    my $iscsiInstSsnCxnTimeoutErrors_Err
        = "Failed to get iscsiInstSsnCxnTimeoutErrors of iSCSI.";
    my $BiscsiInstSsnFormatErrors_Err       = 36000;
    my $iscsiInstSsnFormatErrors_Err
        = "Failed to get iscsiInstSsnFormatErrors of iSCSI.";
    
    my $iSCSI_Auth_OID=".1.3.6.1.4.1.2021.81.101";
    my $BTarget_Num_Err                     = 37000;
    my $Target_Num_Err = "Failed to get the number of iSCSI auths.";
    my $BTarget_Name_Err                    = 38000;
    my $Target_Name_Err = "Failed to get target name of iSCSI.";
    my $BiscsiTgtLoginAccepts_Err           = 39000;
    my $iscsiTgtLoginAccepts_Err
        = "Failed to get iscsiTgtLoginAccepts of iSCSI.";
    my $BiscsiTgtLoginRedirects_Err         = 40000;
    my $iscsiTgtLoginRedirects_Err
        = "Failed to get iscsiTgtLoginRedirects of iSCSI.";
    my $BiscsiTgtLoginAuthorizeFails_Err    = 41000;
    my $iscsiTgtLoginAuthorizeFails_Err
        ="Failed to get iscsiTgtLoginAuthorizeFails of iSCSI.";
    my $BiscsiTgtLoginAuthenticateFails_Err = 42000;
    my $iscsiTgtLoginAuthenticateFails_Err
        = "Failed to get iscsiTgtLoginAuthenticateFails of iSCSI.";
    my $BiscsiTgtLoginNegotiateFails_Err    = 43000;
    my $iscsiTgtLoginNegotiateFails_Err
        = "Failed to get iscsiTgtLoginNegotiateFails of iSCSI.";
    my $BiscsiTgtLoginOtherFails_Err        = 44000;
    my $iscsiTgtLoginOtherFails_Err
        = "Failed to get iscsiTgtLoginOtherFails of iSCSI.";
    my $BiscsiTgtLogoutAccepts_Err          = 45000;
    my $iscsiTgtLogoutAccepts_Err
        = "Failed to get iscsiTgtLogoutAccepts of iSCSI.";
    my $BiscsiTgtLogoutOtherFails_Err       = 46000;
    my $iscsiTgtLogoutOtherFails_Err
        = "Failed to get iscsiTgtLogoutOtherFails of iSCSI.";
    use constant SNMP_AGENT_ERR_KEY     => "NORESPONSE";
    use constant SNMP_AGENT_ERR_NUM     => 47000;
    use constant SNMP_AGENT_ERR_MESSAGE => "No response from SNMP agent";
    use constant UPTIME_OID             => ".1.3.6.1.2.1.1.3.0";
    use constant UPTIME_ERROR_CODE      => 50000;
    use constant UPTIME_ERROR_MSG       => "Ignored as sampling data.";
    use constant UNKNOWN_SNMP_ERR_NUM       => 51000;
    use constant UNKNOWN_SNMP_ERR_MESSAGE   => "No response from SNMP agent";
    use constant MOUNTPOINT_MAX_LENGTH      => 1023;
    
    #added by hetao start:
    
    use constant ERR_STRING_CAN_NOT_GET_INTERVAL    => "Failed to get the interval.";
    use constant ERR_CODE_CAN_NOT_GET_INTERVAL      => 60000;
    use constant ERR_STRING_CAN_NOT_OPEN_CPU_INFO_FILE       => "Failed to open cpu information file.";
    use constant ERR_CODE_CAN_NOT_OPEN_CPU_INFO_FILE         => 61000;
    use constant ERR_STRING_CMD_GET_DISKIO_FIALED    => "Failed to execute \"lvmsadc|lvmsar -s\" command.";
    use constant ERR_CODE_CMD_GET_DISKIO_FIALED      => 62000;
    use constant ERR_STRING_CAN_NOT_OPEN_NETWORKIO_INFO_FILE => "Failed to open networkio information file.";
    use constant ERR_CODE_CAN_NOT_OPEN_NETWORKIO_INFO_FILE   => 63000;
    use constant ERR_STRING_CAN_NOT_OPEN_ISCSI_INSTANCE_FILE => "Failed to open iscsi instance file.";
    use constant ERR_CODE_CAN_NOT_OPEN_ISCSI_INSTANCE_FILE   => 64000;
    use constant ERR_STRING_NO_SUCH_ISCSI_INSTANCE_FOUND => "Failed to find iscsi instance.";
    use constant ERR_CODE_NO_SUCH_ISCSI_INSTANCE_FOUND   => 65000;
    use constant ERR_STRING_CAN_NOT_OPEN_ISCSI_AUTH_FILE => "Failed to open iscsi auth file:";
    use constant ERR_CODE_CAN_NOT_OPEN_ISCSI_AUTH_FILE   => 66000;
    use constant ERR_STRING_CMD_FILE_SYSTEM_DF_FIALED    => "Failed to execute \"df\" command.";
    use constant ERR_CODE_CMD_FILE_SYSTEM_DF_FIALED      => 67000;
    use constant ERR_STRING_CMD_FILE_SYSTEM_MOUNT_FIALED    => "Failed to execute \"mount\" command.";
    use constant ERR_CODE_CMD_FILE_SYSTEM_MOUNT_FIALED      => 68000;
    use constant ERR_STRING_UNKNOWN_ERROR => "Unknown error. ";
    use constant ERR_CODE_TIME_OUT => 69000;
    use constant ERR_STRING_TIME_OUT => "No response error. ";
    use constant ERR_CODE_UNKNOWN_ERROR => 70000;
    use constant ERR_CODE_RSH_TIME_OUT => 71000;
    use constant ERR_CODE_RRD_FILE_BROKEN => 72000;
    use constant ERR_CODE_RRD_FILE_BROKEN_WHEN_UPDATE => 73000;
    use constant ERR_STRING_CMD_NVAVS_STAT_FIALED   => "Failed to execute \"/opt/nec/nvavs/bin/nvavs_stat\" command.";
    use constant ERR_CODE_CMD_NVAVS_STAT_FIALED     => 74000;
    use constant ERR_STRING_CLUSTER_STATUS_FIALED   => "The cluster status is error.";
    use constant ERR_CODE_CLUSTER_STATUS_FIALED     => 75000;
    use constant ERR_STRING_RRD_FILE_BROKEN => " is not an RRD file";
    use constant ERR_STRING_FAILED_TO_UPDATE_RRD => "Failed to update RRD.";
    use constant ERR_STRING_RRD_FILE_BROKEN_SYSLOG => " is not a RRD file, just recreated.";
    use constant RSH_TIME_OUT => "rsh_time_out";
    use constant ERR_STRING_RSH_TIME_OUT => "No response from partner node(timed out).";
    use constant SHELL_SCRIPT_GET_MY_ADDRASS => "/opt/nec/nsadmin/bin/getMyAddress.sh";
    use constant SCRIPT_TUNE_RRD_FILES => "/opt/nec/nsadmin/bin/statis_tuneRRDFile.pl";
    use constant SHELL_SCRIPT_CHECK_UPTIME => "/opt/nec/nsadmin/bin/statis_checkUptime.sh";
    use constant SCRIPT_KILL_CHILD => "/opt/nec/nsadmin/bin/nsgui_killchild.pl";
    use constant SCRIPT_NSGUI_FSYNC => "/opt/nec/nsadmin/bin/nsgui_fsync";
    use constant FILESYTEM_OS_KEY_LD => "/dev/ld";
    use constant FILESYTEM_OS_KEY_HMD => "/dev/hmd";    
    use constant CMD_NVAVS_STAT => "sudo /opt/nec/nvavs/bin/nvavs_stat -t";
    use constant CMD_GET_LICENSE=> "sudo /opt/nec/nsadmin/bin/getLicenseInfo.sh";

    use constant ERR_STRING_CAN_NOT_OPEN_DISKIO_INFO_FILE =>"Failed to open diskio information file.";
    use constant ERR_CODE_CAN_NOT_OPEN_DISKIO_INFO_FILE => 69000;
    
    use constant ERR_STRING_FAIL_TO_GET_VIRTUAL_PATH_INFO => "Failed to get virtual export informations: "; 
    use constant ERR_STRING_FAIL_TO_GET_SERVER_INFO => "Failed to get server informations: ";
    use constant ERR_STRING_FAIL_TO_GET_NODE_INFO => "Failed to get node informations: ";
    use constant NFS_VIRTUAL_EXPORT => "NSW_NFS_Virtual_Export";
    use constant NFS_VIRTUAL_SERVER => "NSW_NFS_Server";
    use constant NFS_VIRTUAL_NODE => "NSW_NFS_Node";
    #added by hetao end
    
        
sub new()
{
    my $this = {}; # Create an anonymous hash,and #self points to it.
    bless $this; # Connect the hash to the package update.
    return $this; # Return the reference to the hash.
}

sub getRpqNum()
{
    return $RpqNum;
}

sub getNAS()
{
    return $NAS;
}

sub getIPSAN()
{
    return $IPSAN;
}

sub getFCSAN()
{
    return $FCSAN;
}

sub getCPUStatesOID()
{
    return $CPUStatesOID;
}

sub getCPUStates()
{
    return $CPUStates;
}

sub getNetworkIO()
{
    return $NetworkIO;
}

sub getFilesystem()
{
    return $Filesystem;
}

sub getFilesystem_Quantity()
{
    return $Filesystem_Quantity;
}

sub getNAS_LV_IO()
{
    return $NAS_LV_IO;
}

sub getFCSAN_LD_IO()
{
    return $FCSAN_LD_IO;
}

sub getFCSAN_PD_IO()
{
    return $FCSAN_PD_IO;
}

sub getiSCSI_Session()
{
    return $iSCSI_Session;
}

sub getiSCSI_Auth()
{
    return $iSCSI_Auth;
}

sub getAnti_Virus_Scan(){
    return $Anti_Virus_Scan;
}

sub getCPUUserErr()
{
    return $CPUUserErr;
}

sub getCPUNiceErr()
{
    return $CPUNiceErr;
}

sub getCPUSystemErr()
{
    return $CPUSystemErr;
}

sub getCPUIdleErr()
{
    return $CPUIdleErr;
}

sub getCPUNumErr()
{
    return $CPUNumErr;
}

sub getCPUNameErr()
{
    return $CPUNameErr;
}

sub getRRDDefInfoErr()
{
    return $RRDDefInfoErr;
}

sub getParameterErr()
{
    return $parameterErr;
}

sub getRRDCreateErr()
{
    return $RRDCreateErr;
}

sub getRRDUpdateErr()
{
    return $RRDUpdateErr;
}

sub getSNMPErr()
{
    return $SNMPErr;
}

sub getNoSuchItemErr()
{
    return $NoSuchItemErr;
}

sub getNoSuchTargetErr()
{
    return $NoSuchTargetErr;
}

sub getBNoSuchTargetErr()
{
    return $BNoSuchTargetErr;
}

sub getBNoSuchItemErr()
{
    return $BNoSuchItemErr;
}

sub getBSNMPErr()
{
    return $BSNMPErr;
}

sub getBParameterErr()
{
    return $BParameterErr;
}

sub getBRRDDefInfoErr()
{
    return $BRRDDefInfoErr;
}

sub getBRRDCreateErr()
{
    return $BRRDCreateErr;
}

sub getBRRDUpdateErr()
{
    return $BRRDUpdateErr;
}

sub getBCPUNumErr()
{
    return $BCPUNumErr;
}

sub getBCPUNameErr()
{
    return $BCPUNameErr;
}

sub getBCPUUserErr()
{
    return $BCPUUserErr;
}

sub getBCPUNiceErr()
{
    return $BCPUNiceErr;
}

sub getBCPUSystemErr()
{
    return $BCPUSystemErr;
}

sub getBCPUIdleErr()
{
    return $BCPUIdleErr;
}

sub getHost()
{
    return $host;
}

sub getCollectionItem()
{
    return $collectionItem;
}

sub getSNMP()
{
    return $SNMP;
}

sub getCommunity()
{
    return $community;
}

sub getPort()
{
    return $port;
}

sub getVersion()
{
    return $version;
}

sub getUser()
{
    return $user;
}

sub getAuthType()
{
    return $authType;
}

sub getAuth()
{
    return $auth;
}

sub getAuthPassPhrase()
{

    return $authPassPhrase;
}    

sub getPrivProto()
{

    return $privProto;
}

sub getPrivPassPhrase()
{

    return $privPassPhrase;
}

sub getCluster()
{
    return $cluster;
}

sub getStandAlone()
{
    return $standAlone;
}

sub getScattered()
{
    return $scattered;
}

sub getMultiple()
{
    return $multiple;
}
#liuhy add 2001/10/23



sub getCollectorThread()
{
    return $collectorThread;
}

sub getCollector(){
    return $collector;
}

sub getFlagFileSubDir(){

   return $flagFileSubDir;
}

sub getFlagFileAcitve(){

   return $flagFileAcitve;
}
sub getFlagFileUpdate(){
 
   return $flagFileUpdate;
}

sub getFlagFileLock(){

   return $flagFileLock;
}


#error information about collector thread
sub getColThreadCLNumErr(){
    return $colThreadCLNumErr;
}

sub getColThreadTarStatErr(){
    return $colThreadTarStatErr;
}

sub getLockRRDNodefErr(){
    return $lockRRDNodefErr;
}

sub getLockRRDFailed(){
    return $lockRRDFailed;
}

sub getColThreadLoadRRDInfoErr(){
    return $colThreadLoadRRDInfoErr;
}

sub getColThreadForkErr(){
    return $colThreadForkErr;
}

sub getColThreadLoadDefErr(){
    return $colThreadLoadDefErr;
}

sub getColThreadGetTargetFailed(){
    return $colThreadGetTargetFailed;    
}

sub getColThreadNewMonitorFailed(){
    return $colThreadNewMonitorFailed;
}

sub getColThreadCantFork(){
   return $colThreadCantFork;
}

sub getColThreadCLParamErr(){
   return $colThreadCLParamErr;    
}


#process about constant of syslog
sub getSyslogSymbol(){

   return $syslogSymbol;
}

sub getSyslogEmerg(){
    return $syslogEmerg;
}

sub getSyslogAlert(){
    return $syslogAlert;
}
    
sub getSyslogCrit(){
    return $syslogCrit;
}

sub getSyslogErr(){
    return $syslogErr;
}

sub getSyslogWarning(){
    return $syslogWarning;
}

sub getSyslogNotice(){
    return $syslogNotice;
}

sub getSyslogInfo(){
    return $syslogInfo;
}

sub getSyslogDebug(){
    return $syslogDebug;
}

#liuhy add END 2001/10/23
sub getNetworkOID
{
    return $NetworkOID;
}

sub getEthNumErr
{
    return $EthNumErr;
}

sub getBEthNumErr
{
    return $BEthNumErr;
}

sub getEthNameErr
{
    return $EthNameErr;
}

sub getBEthNameErr
{
    return $BEthNameErr;
}

sub getInOctetsErr
{
    return $InOctetsErr;
}

sub getBInOctetsErr
{
    return $BInOctetsErr;
}

sub getOutOctetsErr
{
    return $OutOctetsErr;
}

sub getBOutOctetsErr
{
    return $BOutOctetsErr;
}

sub getInPacketsErr
{
    return $InPacketsErr;
}

sub getBInPacketsErr
{
    return $BInPacketsErr;
}

sub getOutPacketsErr
{
    return $OutPacketsErr;
}

sub getBOutPacketsErr
{
    return $BOutPacketsErr;
}

sub getInErrorsErr
{
    return $InErrorsErr;
}

sub getBInErrorsErr
{
    return $BInErrorsErr;
}

sub getOutErrorsErr
{
    return $OutErrorsErr;
}

sub getBOutErrorsErr
{
    return $BOutErrorsErr;
}

sub getInDropErr
{
    return $InDropErr;
}

sub getBInDropErr
{
    return $BInDropErr;
}

sub getOutDropErr
{
    return $OutDropErr;
}

sub getBOutDropErr
{
    return $BOutDropErr;
}

sub getCollisionErr
{
    return $CollisionErr;
}

sub getBCollisionErr
{
    return $BCollisionErr;
}

sub getDeviceFileOID
{
    return $DeviceFileOID;
}

sub getDeviceFileNumErr
{
    return $DeviceFileNumErr;
}

sub getBDeviceFileNumErr
{
    return $BDeviceFileNumErr;
}

sub getDeviceFileNameErr
{
    return $DeviceFileNameErr;
}

sub getBDeviceFileNameErr
{
    return $BDeviceFileNameErr;
}

sub getFilesystemTypeErr
{
    return $FilesystemTypeErr;
}

sub getBFilesystemTypeErr
{
    return $BFilesystemTypeErr;
}

sub getMountPointErr
{
    return $MountPointErr;
}

sub getBMountPointErr
{
    return $BMountPointErr;
}

sub getTotalSizeErr
{
    return $TotalSizeErr;
}

sub getBTotalSizeErr
{
    return $BTotalSizeErr;
}

sub getTotalInodesErr
{
    return $TotalInodesErr;
}

sub getBTotalInodesErr
{
    return $BTotalInodesErr;
}

sub getDiskUsedErr
{
    return $DiskUsedErr;
}

sub getBDiskUsedErr
{
    return $BDiskUsedErr;
}

sub getInodeUsedErr
{
    return $InodeUsedErr;
}

sub getBInodeUsedErr
{
    return $BInodeUsedErr;
}

sub getLogicalVolumeOID
{
    return $LogicalVolumeOID;
}

sub getLV_NumErr
{
    return $LV_NumErr;
}

sub getBLV_NumErr
{
    return $BLV_NumErr;
}

sub getLV_NameErr
{
    return $LV_NameErr;
}

sub getBLV_NameErr
{
    return $BLV_NameErr;
}

sub getRead_IOErr
{
    return $Read_IOErr;
}

sub getBRead_IOErr
{
    return $BRead_IOErr;
}

sub getWrite_IOErr
{
    return $Write_IOErr;
}

sub getBWrite_IOErr
{
    return $BWrite_IOErr;
}    

sub get_iSCSI_Session_OID{
    return $iSCSI_Session_OID;
}

sub get_iSCSI_Num_Err{
    return $iSCSI_Num_Err;
}

sub getB_iSCSI_Num_Err{
    return $BiSCSI_Num_Err;
}

sub get_iSCSI_Name_Err{
    return $iSCSI_Name_Err;
}

sub getB_iSCSI_Name_Err{
    return $BiSCSI_Name_Err;
}

sub getB_iscsiInstSsnDigestErrors_Err{
    return $BiscsiInstSsnDigestErrors_Err;
}

sub get_iscsiInstSsnDigestErrors_Err{
    return $iscsiInstSsnDigestErrors_Err;
}

sub getB_iscsiInstSsnCxnTimeoutErrors_Err{
    return $BiscsiInstSsnCxnTimeoutErrors_Err;
}

sub get_iscsiInstSsnCxnTimeoutErrors_Err{
    return $iscsiInstSsnCxnTimeoutErrors_Err;
}

sub getB_iscsiInstSsnFormatErrors_Err{
    return $BiscsiInstSsnFormatErrors_Err;
}

sub get_iscsiInstSsnFormatErrors_Err{
    return $iscsiInstSsnFormatErrors_Err;
}

sub get_iSCSI_Auth_OID{
    return $iSCSI_Auth_OID;
}

sub getB_Target_Num_Err{
    return $BTarget_Num_Err;
}

sub get_Target_Num_Err{
    return $Target_Num_Err;
}

sub getB_Target_Name_Err{
    return $BTarget_Name_Err;
}

sub get_Target_Name_Err{
    return $Target_Name_Err;
}

sub getB_iscsiTgtLoginAccepts_Err{
    return $BiscsiTgtLoginAccepts_Err;
}

sub get_iscsiTgtLoginAccepts_Err{
    return $iscsiTgtLoginAccepts_Err;
}

sub getB_iscsiTgtLoginRedirects_Err{
    return $BiscsiTgtLoginRedirects_Err;
}

sub get_iscsiTgtLoginRedirects_Err{
    return $iscsiTgtLoginRedirects_Err;
}

sub getB_iscsiTgtLoginAuthorizeFails_Err{
    return $BiscsiTgtLoginAuthorizeFails_Err;
}

sub get_iscsiTgtLoginAuthorizeFails_Err{
    return $iscsiTgtLoginAuthorizeFails_Err;
}

sub getB_iscsiTgtLoginAuthenticateFails_Err{
    return $BiscsiTgtLoginAuthenticateFails_Err;
}

sub get_iscsiTgtLoginAuthenticateFails_Err{
    return $iscsiTgtLoginAuthenticateFails_Err;
}

sub getB_iscsiTgtLoginNegotiateFails_Err{
    return $BiscsiTgtLoginNegotiateFails_Err;
}

sub get_iscsiTgtLoginNegotiateFails_Err{
    return $iscsiTgtLoginNegotiateFails_Err;
}

sub getB_iscsiTgtLoginOtherFails_Err{
    return $BiscsiTgtLoginOtherFails_Err;
}

sub get_iscsiTgtLoginOtherFails_Err{
    return $iscsiTgtLoginOtherFails_Err;
}

sub getB_iscsiTgtLogoutAccepts_Err{
    return $BiscsiTgtLogoutAccepts_Err;
}

sub get_iscsiTgtLogoutAccepts_Err{
    return $iscsiTgtLogoutAccepts_Err;
}

sub getB_iscsiTgtLogoutOtherFails_Err{
    return $BiscsiTgtLogoutOtherFails_Err;
}

sub get_iscsiTgtLogoutOtherFails_Err{
    return $iscsiTgtLogoutOtherFails_Err;
}

sub getBDiskAvailableErr{
    return $BDiskAvailableErr;
}

sub getDiskAvailableErr{
    return $DiskAvailableErr;
}

sub getBInodeAvailableErr{
    return $BInodeAvailableErr;
}

sub getInodeAvailableErr{
    return $InodeAvailableErr;
}
1; # package end.
