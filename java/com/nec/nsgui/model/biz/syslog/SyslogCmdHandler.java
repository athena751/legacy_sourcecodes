/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.syslog;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.cifs.NSBeanUtil;
import com.nec.nsgui.model.entity.syslog.*;

public class SyslogCmdHandler implements SyslogBeanConst {

	private static final String cvsid = "@(#) $Id: SyslogCmdHandler.java,v 1.24 2008/09/23 09:41:29 penghe Exp $";

	public static final String ERROR_CODE_FAILED_CONNECT_OTHER_NODE = "0x12900010";

	private static final String SCIRPT_IS_IN_SHARE_PARTITION = "/bin/log_isInSharePartition.pl";

	private static final String SCIRPT_GET_CATEGORIES_INFO = "/bin/log_getCategories.pl";

	private static final String SCIRPT_GET_COMPUTER_LIST_INFO = "/bin/log_getCifsComputerListInfo.pl";

	private static final String SCIRPT_GET_HTTP_LOG_FILES = "/bin/log_getHttpLogFiles.pl";

	private static final String SCIRPT_GET_FTP_LOG_FILES = "/bin/log_getFtpLogFiles.pl";

	private static final String SCIRPT_FILE_IS_NOT_EMPTY = "/bin/log_fileIsNotEmpty.pl";

	private static final String SCIRPT_GET_EXPORT_LIST_INFO = "/bin/log_get_exportlist.pl";

	private static final String SCIRPT_GET_LOG_FILE_NAME = "/bin/log_get_logfilename.pl";

	private static final String SCIRPT_GET_PERFORM_FILE_NAME = "/bin/log_get_performfilename.pl";

	private static final String NFS_ACCESS_LOG_CONF = "/etc/sysconfig/nfsd/nfsaccesslog.conf";

	private static final String SCIRPT_FILE_EXISTS = "/bin/log_fileexists.pl";

	private static final String SCIRPT_LOG_OPERATION = "/bin/log_operation.sh";

	private static final String SCIRPT_MAKE_FILE = "/bin/log_makeFile.sh";

	private static final String SCIRPT_MAKE_NFSPERF_FILE = "/bin/log_makeNFSPerformFile.sh";

	private static final String SCIRPT_CLEANUP = "/bin/log_cleanup.sh";

	private static final String SCIRPT_READ_FILE = "/bin/log_readfile.sh";

	private static final String SCIRPT_CLUSTER_GET_GROUP_STATUS = "/bin/cluster_getGroupStatus.pl";

	private static final String SCIRPT_GET_ROTATE_LOG_FILES = "/bin/log_getRotateLogFiles.pl";

	private static final String SCIRPT_KILL_NFSPFMINFO2_PROCESS = "/bin/log_kill_nfspfminfo2_process.pl";

	private static final String SCIRPT_CLEAN_TMP_FILE = "/bin/log_cleanTmpFile.pl";

	private static final String SCIRPT_CLEANTMPFILE_4LOGIN = "/bin/log_cleanTmpFile4login.sh";

	private static final String SCRIPT_GET_FILE_SIZE_LIST = "/bin/log_getFileSizeList.pl";

	public static String isInSharePartition(int nodeNo, String targetFile)
			throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_IS_IN_SHARE_PARTITION,
				targetFile };
		NSCmdResult cmdResult = CmdExecBase.execCmdInServiceNode(cmds, null,
				nodeNo, true);
		return cmdResult.getStdout()[0];
	}

	public static NSCmdResult execCmdBaseTargetFile(String[] cmds,
			String[] inputs, int nodeNo, boolean errHandle, String targetFile)
			throws Exception {

		String myStatus = ClusterUtil.getMyStatus();
		if (myStatus.equals("0")) {
			// sigle node or normal cluster
			return CmdExecBase.execCmd(cmds, inputs, nodeNo, errHandle);
		} else if (myStatus.equals("1")) {
			// the status of machine is TakeOver
			if (isInSharePartition(nodeNo, targetFile).equals("true")) {
				// need exec in the node on which share partition is working
				return CmdExecBase.execCmdInServiceNode(cmds, inputs, nodeNo,
						errHandle);
			} else {
				return CmdExecBase.execCmdForce(cmds, inputs, nodeNo, errHandle);
			}
		} else {
			// the status of machine maitaining (one node is not active)
			if (isInSharePartition(nodeNo, targetFile).equals("true")) {
				// need exec in the node on which share partition is working
				return CmdExecBase.localExecCmd(cmds, inputs, true);
			} else {
				int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
				if (myNodeNo == nodeNo || myNodeNo == -1) {
					// need exec in local node
					return CmdExecBase.localExecCmd(cmds, inputs, true);
				} else {
					// need exec in remote node
					NSException e = new NSException(
							Class
									.forName("com.nec.nsgui.model.biz.syslog.SyslogCmdHandler"));
					e.setErrorCode(ERROR_CODE_FAILED_CONNECT_OTHER_NODE);
					e.setDetail("The target node(other node) is not active.");
					throw e;
				}
			}
		}
	}

	public static List getCategoryList(int nodeNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_CATEGORIES_INFO };
		NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
		String[] results = cmdResult.getStdout();
		return NSBeanUtil.createBeanList(
				"com.nec.nsgui.model.entity.syslog.SyslogCategoryInfoBean",
				results, 2);
	}

	public static Vector getCifsComputerList(int nodeNo) throws Exception {
		String[] cmds = {
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_COMPUTER_LIST_INFO,
				Integer.toString(nodeNo) };
		NSCmdResult cmdResult = CmdExecBase.execCmdInServiceNode(cmds, null,
				nodeNo, true);

		List cifsLogInfo = NSBeanUtil.createBeanList(
				"com.nec.nsgui.model.entity.syslog.SyslogCifsLogInfoBean",
				cmdResult.getStdout(), 3);

		int size = cifsLogInfo.size();
		for (int i = 0; i < size; i++) {
			SyslogCifsLogInfoBean tempCifsInfo = (SyslogCifsLogInfoBean) cifsLogInfo
					.get(i);
			String tempAccessLogFile = tempCifsInfo.getAccessLogFile();
			if (isInSharePartition(nodeNo, tempAccessLogFile).equals("true")) {
				tempCifsInfo.setRotateLogFiles((getRotateLogFiles(
						tempAccessLogFile, nodeNo, LOG_TYPE_CIFS_LOG)));
				tempCifsInfo.setNeedDisplayTime("true");
			}
		}

		Vector result = new Vector();
		List displayValidList = new ArrayList();
		List displayInvalidList = new ArrayList();
		String myStatus = ClusterUtil.getMyStatus();
		boolean targetNodeIsActive = true;
		if (ClusterUtil.getMyStatus().equals("2")) {
			// the status of the machine is maintaining, the remote node is not
			// active
			int myNodeNo = ClusterUtil.getInstance().getMyNodeNo();
			if (myNodeNo == nodeNo || myNodeNo == -1) {
				// the target node is the local node
				displayValidList = cifsLogInfo;
			} else {
				targetNodeIsActive = false;
				// the target node is the remote node
				int logInfoSize = cifsLogInfo.size();
				for (int i = 0; i < logInfoSize; i++) {
					SyslogCifsLogInfoBean info = (SyslogCifsLogInfoBean) cifsLogInfo
							.get(i);
					if (isInSharePartition(nodeNo, info.getAccessLogFile())
							.equals("true")) {
						// this log file can be referred
						String[] fileExistAndSize = fileExistWithSize(info
								.getAccessLogFile());
						info.setFileExist(Boolean.toString(fileExistAndSize[0]
								.equals("true")));
						info.setFileSize(fileExistAndSize[1]);
						displayValidList.add(info);
					} else {
						displayInvalidList.add(info);
					}
				}
			}
		} else {
			// both node is active
			displayValidList = cifsLogInfo;
		}

		if (targetNodeIsActive) {
			// judge the log file which will be displayed normal exist or not
			for (int i = 0; i < displayValidList.size(); i++) {
				SyslogCifsLogInfoBean info = (SyslogCifsLogInfoBean) cifsLogInfo
						.get(i);
				String[] fileExistAndSize = logFileExistWithSize(info
						.getEncoding(), info.getAccessLogFile(), nodeNo);
				info.setFileExist(fileExistAndSize[0]);
				info.setFileSize(fileExistAndSize[1]);
			}
		}

		result.add(displayValidList);
		result.add(displayInvalidList);
		return result;
	}

	public static String[] getHttpLogFiles(int nodeNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_HTTP_LOG_FILES };
		NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
		return cmdResult.getStdout();
	}

	public static String[] getFtpLogFiles(int nodeNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_FTP_LOG_FILES };
		NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, nodeNo, true);
		return cmdResult.getStdout();
	}

	public static String[] getExportList(int group) throws Exception {

		String fileName = "/etc/group" + Integer.toString(group) + "/exports";
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_EXPORT_LIST_INFO,
				fileName };

		NSCmdResult cmdResult = CmdExecBase.execCmdInServiceNode(cmds, null,
				group, true);
		return cmdResult.getStdout();
	}

	public static String[] getFileSizeList(String[] fileList, String logType,
			int nodeNoOrGroupNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_FILE_SIZE_LIST,
				logType };
		NSCmdResult cmdResult = CmdExecBase.execCmdForce(cmds, fileList,
				nodeNoOrGroupNo, true);
		return cmdResult.getStdout();
	}

	public static String getFileSize(String file, String logType,
			int nodeNoOrGroupNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_FILE_SIZE_LIST,
				logType };
		String[] fileList = {file};
		NSCmdResult cmdResult = SyslogCmdHandler.execCmdBaseTargetFile(cmds, fileList,
				nodeNoOrGroupNo, true, file);
		return cmdResult.getStdout()[0];
	}
	
	private static String getNfsAccessFileName(int group)
			throws Exception {

		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_LOG_FILE_NAME,
				NFS_ACCESS_LOG_CONF, "=" };

		NSCmdResult cmdResult = SyslogCmdHandler.execCmdBaseTargetFile(cmds,
				null, group, true, NFS_ACCESS_LOG_CONF);
		return cmdResult.getStdout()[0];
	}

	public static Vector getNfsLogInfo(int nodeNo) throws Exception {
		Vector nfsLogInfo = new Vector();

		String accessLogfileInfo = getNfsAccessFileName(nodeNo);
		String size = getFileSize(accessLogfileInfo,LOG_TYPE_NFS_LOG,nodeNo);
		nfsLogInfo.add(accessLogfileInfo);
		nfsLogInfo.add(size);
		if (accessLogfileInfo.equals("")) {
			nfsLogInfo.add("false");
		} else {
			nfsLogInfo.add(logFileExist("", accessLogfileInfo, nodeNo));
		}

		if (isInSharePartition(nodeNo, accessLogfileInfo).equals("true")) {
			nfsLogInfo.add(getRotateLogFiles(accessLogfileInfo, nodeNo,
					LOG_TYPE_NFS_LOG));
			nfsLogInfo.add("true");
		} else {
			nfsLogInfo.add(new ArrayList());
			nfsLogInfo.add("false");
		}

		return nfsLogInfo;
	}

	public static List getRotateLogFiles(String logFileName, int nodeNo,
			String logType) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_GET_ROTATE_LOG_FILES,
				logFileName, logType };
		NSCmdResult cmdResult = SyslogCmdHandler.execCmdBaseTargetFile(cmds,
				null, nodeNo, true, logFileName);
		return NSBeanUtil.createBeanList(
				"com.nec.nsgui.model.entity.syslog.SyslogLogFileInfo",
				cmdResult.getStdout(), 4);
	}

	public static SyslogCacheFileInfo makeCacheFile(int node,
			SyslogSearchConditions conditions, String id) throws Exception {
		return makeCacheFile(node, conditions, id, "isLogview");
	}

	public static SyslogCacheFileInfo makeCacheFile(int node,
			SyslogSearchConditions conditions, String id, String switchFlag)
			throws Exception {
		SyslogCommonInfoBean commonInfo = conditions.getCommonInfo();
		SyslogSystemSearchInfoBean systemlogSearchInfo = conditions
				.getSystemlogSearchInfo();
		SyslogCifsSearchInfoBean cifsSearchInfo = conditions
				.getCifsSearchInfo();
		String logfile = commonInfo.getLogFile();
		String viewOrder = commonInfo.getViewOrder();
		String searchWords = commonInfo.getSearchWords();
		String aroundLines = commonInfo.getAroundLines();
		String containWords = commonInfo.getContainWords();
		String caseSensitive = commonInfo.getCaseSensitive();
		String displayEncoding = commonInfo.getDisplayEncoding();
		String logType = commonInfo.getLogType();
		String searchAction = commonInfo.getSearchAction();
		String categoryKeyword = "";
		delTmpLogFile(id, logType);
		SyslogCacheFileInfo cachefileinfo = new SyslogCacheFileInfo();
		if (logType.equals(LOG_TYPE_SYSTEM_LOG)) {
			if (searchAction.equals(SEARCCH_ACTION_DISPLAY_ALL)
					|| switchFlag.equals("isDirectDown")) {
				categoryKeyword = systemlogSearchInfo
						.getKeywords_forSearch(true);
			} else {
				categoryKeyword = systemlogSearchInfo
						.getKeywords_forSearch(false);
			}
		}
		String viewLines = commonInfo.getViewLines();
		Vector vec = new Vector();
		vec.add(CmdExecBase.CMD_SUDO);
		vec.add(System.getProperty("user.home") + SCIRPT_MAKE_FILE);
		vec.add("-f");
		vec.add(logfile);
		if (viewOrder.equals("old") || switchFlag.equals("isDirectDown")) {
			vec.add("-r");
		}
		vec.add("-I");
		vec.add(id);
		if (!categoryKeyword.equals("")) {
			vec.add("-c");
			vec.add("'" + categoryKeyword + "'");
		}
		if (logType.equals(LOG_TYPE_CIFS_LOG)) {
			vec.add("-E");
			vec.add(conditions.getCommonInfo().getDisplayEncoding());
		}
		if (searchAction.equals(SEARCCH_ACTION_DISPLAY_ALL)
				|| switchFlag.equals("isDirectDown")) {
			vec.add("-a");
		} else {
			if (!searchWords.equals("")) {
				vec.add("-e");
				String searchPattern = searchWords.replaceAll("\\-", "\\\\-");
				vec.add("'" + searchPattern + "'");
			}

			if (containWords.equals("no")) {
				if (!searchWords.equals("")) {
					vec.add("-v");
				}
			}
			if (!aroundLines.equals("0")) {
				vec.add("-C");
				vec.add(aroundLines);
			}
			if (caseSensitive.equals("no")) {
				vec.add("-i");
			}
		}
		if (switchFlag.equals("isDirectDown")) {
			vec.add("-d");
		}
		vec.add("-l");
		vec.add(logType);

		String[] cmds = (String[]) vec.toArray(new String[vec.size()]);
		NSCmdResult cmdResult = execCmdBaseTargetFile(cmds, null, node, true,
				logfile);
		String[] tmpfile = cmdResult.getStdout();
		if (tmpfile[0].equals("false")) {
			return null;
		} else if (tmpfile[0].equals("DiskIsFull")
				|| tmpfile[0].equals("rotate")) {
			cachefileinfo.setErrorType(tmpfile[0]);
			return cachefileinfo;
		}
		int myNode = ClusterUtil.getInstance().getMyNodeNo();
		String myStatus = ClusterUtil.getMyStatus();
		if ((myNode == node || myNode == -1)
				|| myStatus.equals("2")
				|| (myStatus.equals("1") && isInSharePartition(node, logfile)
						.equals("true"))) {
			if (myStatus.equals("1")
					&& isInSharePartition(node, logfile).equals("true")) {
				String[] getStatusCmds = {
						CmdExecBase.CMD_SUDO,
						System.getProperty("user.home")
								+ SCIRPT_CLUSTER_GET_GROUP_STATUS };
				cmdResult = CmdExecBase.localExecCmd(getStatusCmds, null, true);
				String[] results = cmdResult.getStdout();
				if (results[0].equals("1")) {
					if (switchFlag.equals("isDirectDown")) {
						String[] splitCmds = {
								CmdExecBase.CMD_SUDO,
								System.getProperty("user.home")
										+ SCIRPT_LOG_OPERATION, "-f",
								tmpfile[1], "-d", "-I", id };
						cmdResult = CmdExecBase.localExecCmd(splitCmds, null,
								true);
					} else {
						String[] splitCmds = {
								CmdExecBase.CMD_SUDO,
								System.getProperty("user.home")
										+ SCIRPT_LOG_OPERATION, "-f",
								tmpfile[1], "-I", id };
						cmdResult = CmdExecBase.localExecCmd(splitCmds, null,
								true);
					}
				} else if (results[0].equals("2")) {
					String friendIp = ClusterUtil.getInstance().getMyFriendIP();
					if (switchFlag.equals("isDirectDown")) {
						String[] splitCmds = {
								CmdExecBase.CMD_SUDO,
								System.getProperty("user.home")
										+ SCIRPT_LOG_OPERATION, "-f",
								tmpfile[1], "-h", friendIp, "-d", "-I", id };
						cmdResult = CmdExecBase.localExecCmd(splitCmds, null,
								true);
					} else {
						String[] splitCmds = {
								CmdExecBase.CMD_SUDO,
								System.getProperty("user.home")
										+ SCIRPT_LOG_OPERATION, "-f",
								tmpfile[1], "-h", friendIp, "-I", id };
						cmdResult = CmdExecBase.localExecCmd(splitCmds, null,
								true);
					}
				}
			} else {
				if (switchFlag.equals("isDirectDown")) {
					String[] splitCmds = {
							CmdExecBase.CMD_SUDO,
							System.getProperty("user.home")
									+ SCIRPT_LOG_OPERATION, "-f", tmpfile[1],
							"-d", "-I", id };
					cmdResult = CmdExecBase.localExecCmd(splitCmds, null, true);
				} else {
					String[] splitCmds = {
							CmdExecBase.CMD_SUDO,
							System.getProperty("user.home")
									+ SCIRPT_LOG_OPERATION, "-f", tmpfile[1],
							"-I", id };
					cmdResult = CmdExecBase.localExecCmd(splitCmds, null, true);
				}
			}
		} else {
			String friendIp = ClusterUtil.getInstance().getMyFriendIP();
			if (switchFlag.equals("isDirectDown")) {
				String[] splitCmds = { CmdExecBase.CMD_SUDO,
						System.getProperty("user.home") + SCIRPT_LOG_OPERATION,
						"-f", tmpfile[1], "-h", friendIp, "-d", "-I", id };
				cmdResult = CmdExecBase.localExecCmd(splitCmds, null, true);
			} else {
				String[] splitCmds = { CmdExecBase.CMD_SUDO,
						System.getProperty("user.home") + SCIRPT_LOG_OPERATION,
						"-f", tmpfile[1], "-h", friendIp, "-I", id };
				cmdResult = CmdExecBase.localExecCmd(splitCmds, null, true);
			}
		}
		String[] result = cmdResult.getStdout();
		if (cmdResult.getExitValue() == 0) {
			if (result[0].equals("DiskIsFull")) {
				cachefileinfo.setErrorType("DiskIsFull");
				return cachefileinfo;
			} else {
				cachefileinfo.setLogFileName(result[0]);
				cachefileinfo.setTotalLine(Long.parseLong(result[1]));
			}
		} else {
			return null;
		}
		return cachefileinfo;
	}

	public static String readLogFile(String file, long startLine,
			int lineLength, SyslogSearchConditions condition) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_READ_FILE, "-f", file,
				"-s", Long.toString(startLine), "-l",
				Integer.toString(lineLength), "-t",
				condition.getCommonInfo().getLogType(), "-E",
				condition.getCommonInfo().getDisplayEncoding() };
		NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
		String[] results = cmdResult.getStdout();
		StringBuffer strBuf = new StringBuffer();
		if (results.length > 0) {
			strBuf.append(results[0]);
			for (int i = 1; i < results.length; i++) {
				strBuf.append("\n");
				strBuf.append(results[i]);
			}
		}
		return strBuf.toString();

	}

	public static boolean fileExist(String file) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_FILE_EXISTS, file };
		NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
		String[] result = cmdResult.getStdout();
		return result[0].equals("true");
	}

	public static String[] fileExistWithSize(String file) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_FILE_EXISTS, file, "",
				"true" };
		NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
		return cmdResult.getStdout();
	}

	public static String logFileExist(String encoding, String file, int nodeNo)
			throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_FILE_EXISTS, file,
				encoding };
		NSCmdResult cmdResult = SyslogCmdHandler.execCmdBaseTargetFile(cmds,
				null, nodeNo, true, file);
		return cmdResult.getStdout()[0];
	}

	public static String[] logFileExistWithSize(String encoding, String file,
			int nodeNo) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_FILE_EXISTS, file,
				encoding, "true" };
		NSCmdResult cmdResult = SyslogCmdHandler.execCmdBaseTargetFile(cmds,
				null, nodeNo, true, file);
		return cmdResult.getStdout();
	}

	public static void cancelNfsPerformLogSearch(String file, int nodeNo) {
		try {
			String[] cmds = {
					CmdExecBase.CMD_SUDO,
					System.getProperty("user.home")
							+ SCIRPT_KILL_NFSPFMINFO2_PROCESS };
			NSCmdResult cmdResult = SyslogCmdHandler.execCmdBaseTargetFile(
					cmds, null, nodeNo, true, file);
		} catch (Exception e) {
			// do nothing
		}
	}

	public static void delTmpLogFile(String id) {
		try {

			String[] cmds = { CmdExecBase.CMD_SUDO,
					System.getProperty("user.home") + SCIRPT_CLEAN_TMP_FILE, id };
			NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
			if (ClusterUtil.getInstance().isCluster()) {
				cmdResult = CmdExecBase.rshExecCmd(cmds, null, ClusterUtil
						.getInstance().getMyFriendIP());
			}
		} catch (Exception e) {
			// do nothing
		}

	}
	
	public static void delTmpLogFile(String id, String logType) {
		try {

			String[] cmds = { CmdExecBase.CMD_SUDO,
					System.getProperty("user.home") + SCIRPT_CLEAN_TMP_FILE, id, logType };
			NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
		} catch (Exception e) {
			// do nothing
		}

	}

	public static String getTmpFileSize(String id, String logType) {
		try {
			String cmd = "/bin/ls -l " + LOG_TEMP_DIR + id + "/" + logType
					+ "* | /bin/awk \'END {print $5}\'";
			String[] cmds = { CmdExecBase.CMD_SUDO, "/bin/sh", "-c", cmd };
			NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
			return cmdResult.getStdout()[0];
		} catch (Exception e) {
			return "0";
		}
	}

	public static void cleanTmpFile4login(String sessionsId) throws Exception {
		String[] cmds = { CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCIRPT_CLEANTMPFILE_4LOGIN,
				sessionsId };
		NSCmdResult cmdResult = CmdExecBase.localExecCmd(cmds, null, true);
	}
}
