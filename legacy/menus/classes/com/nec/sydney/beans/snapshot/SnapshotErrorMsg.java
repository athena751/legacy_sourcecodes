/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.snapshot;

import javax.servlet.http.HttpSession;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.sydney.framework.NSException;

public class SnapshotErrorMsg {
	private static final String     cvsid = "@(#) $Id: SnapshotErrorMsg.java,v 1.1 2007/05/30 10:06:50 liy Exp $";
  
	public static String getErrorMsg(HttpSession session, NSException e) throws Exception{

		String key = "";
		int errorCode = e.getErrorCode();
		switch (errorCode) {
		case 3:
			key = "nas_snapshot/alert/snapshot_cmd_volume_notexist";
			break;
		case 4:
			key = "nas_snapshot/alert/invalidname";
			break;
		case 5:
			key = "nas_snapshot/alert/contain_special_name";
			break;
		case 6:
			key = "nas_snapshot/alert/snapshot_cmd_duplicatename";
			break;
		case 7:
			key = "nas_snapshot/alert/snapshot_cmd_volume_notset";
			break;
		case 8:
			key = "nas_snapshot/alert/snapshot_cmd_set_failed";
			break;
		case 10:
			key = "nas_snapshot/alert/snapshot_cmd_volume_readonly";
			break;
		case 11:
			key = "nas_snapshot/alert/snapshot_cmd_gen_create_failed";
			break;
		case 12:
			key = "nas_snapshot/alert/snapshot_cmd_gen_del_failed";
			break;
		case 14:
			key = "nas_snapshot/alert/snapshot_cmd_conflict";
			break;
		case 15:
			key = "nas_snapshot/alert/snapshot_cmd_dataset_backup_set_failed";
			break;
		case 16:
			key = "nas_snapshot/alert/snapshot_cmd_quota_backup_set_failed";
			break;
		default:
			throw e;
		}
		return NSMessageDriver.getInstance().getMessage(session,
				"common/alert/failed")
				+ "\\r\\n"
				+ NSMessageDriver.getInstance().getMessage(session, key);

	}
}