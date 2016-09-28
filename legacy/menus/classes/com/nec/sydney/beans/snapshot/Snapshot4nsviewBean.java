/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.snapshot;

import java.util.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.atom.admin.snapshot.*;

public class Snapshot4nsviewBean extends TemplateBean implements NasConstants {
	private static final String cvsid = "@(#) $Id: Snapshot4nsviewBean.java,v 1.2 2007/05/30 10:03:37 liy Exp $";

	private Vector snapshotList;

	private SnapSummaryInfo snapSummaryInfo;

	private String exportGroup;

	private String mountPoint;

	private String hexMountPoint;

	public Snapshot4nsviewBean() {
	}

	public void onDisplay() throws Exception {
		exportGroup = request.getParameter("exportRoot");
		mountPoint = request.getParameter("mountPoint");
		hexMountPoint = request.getParameter("hexMountPoint");
		String deviceName = SnapSOAPClient.hexMP2DevName(hexMountPoint, target);
		snapshotList = SnapSOAPClient.getSnapList(hexMountPoint, deviceName,
				target).getSnapshotVector();

		snapSummaryInfo = SnapSOAPClient.getSnapSchedule(hexMountPoint,
				deviceName, SNAPSHOT, target);

	}

	public Vector getSnapshotList() {
		return snapshotList;
	}

	public Vector getScheduleList() {
		return SnapSchedulePair
				.makeSchedulePair(snapSummaryInfo.getSnapshotVector(),
						snapSummaryInfo.getDeleteSnapshotVector());
	}

	public String getMountPoint() {
		return mountPoint;
	}

	public String getExportGroup() {
		return exportGroup;
	}

	public String getHexMountPoint() {
		return hexMountPoint;
	}
}
