/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.statis;


import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.nec.nsgui.action.statis.StatisActionConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.statis.NasSwitchMaxAverBean;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;

/**
 *
 */
public class NswStatisHandler implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: NswStatisHandler.java,v 1.1 2005/10/18 16:34:22 het Exp $";
	private static final String SCRIPT_GET_MAX_LIST =
		"/bin/statis_getRRADatas.pl";
	public static List getSubItemInfoList(
		int count,
		String startTime,
		String endTime,
		String collectionID,
		String interval,
		Map resultMap)
		throws Exception {
		String[] inputs = new String[2 * count];
		int h = 0;
		Iterator iterator = resultMap.values().iterator();
		while (iterator.hasNext()) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) iterator.next();
			String subItem = subItemInfo.getSubItem();
			String isWhichNode = subItemInfo.getIsWhichNode();
			if (isWhichNode.equals("both") || isWhichNode.equals("group0")) {
				inputs[h++] = subItem;
				inputs[h++] = subItemInfo.getBean4Node0().getNode();
			}
			if (isWhichNode.equals("both") || isWhichNode.equals("group1")) {
				inputs[h++] = subItem;
				inputs[h++] = subItemInfo.getBean4Node1().getNode();
			}
		}
		String[] cmds =
			{
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_MAX_LIST,
				collectionID,
				startTime,
				endTime,
				interval };
		NSCmdResult result = CmdExecBase.localExecCmd(cmds, inputs, true);
		String[] stdout = result.getStdout();
		int length = stdout.length;
		for (int i = 0; i < length; i++) {
			String[] subItemLine = stdout[i].split("\\s+");
			NasSwitchMaxAverBean nodeData = new NasSwitchMaxAverBean();
			nodeData.setNode(subItemLine[1]);
			nodeData.setAccess_average(subItemLine[2]);
			nodeData.setAccess_max(subItemLine[3]);
			nodeData.setResponse_average(subItemLine[4]);
			nodeData.setResponse_max(subItemLine[5]);
			nodeData.setRover_average(subItemLine[6]);
			nodeData.setRover_max(subItemLine[7]);
			NasSwitchSubItemInfoBean subItemInfo_temp =
				(NasSwitchSubItemInfoBean) resultMap.get(subItemLine[0].trim());
			if (subItemInfo_temp != null) {
				if (subItemLine[1]
					.trim()
					.equals(subItemInfo_temp.getBean4Node0().getNode())) {
					subItemInfo_temp.setBean4Node0(nodeData);
				}
				if (subItemLine[1]
					.trim()
					.equals(subItemInfo_temp.getBean4Node1().getNode())) {
					subItemInfo_temp.setBean4Node1(nodeData);
				}
				subItemInfo_temp.setAccess_average(subItemLine[2]);
				subItemInfo_temp.setAccess_max(subItemLine[3]);
				subItemInfo_temp.setResponse_average(subItemLine[4]);
				subItemInfo_temp.setResponse_max(subItemLine[5]);
				subItemInfo_temp.setRover_average(subItemLine[6]);
				subItemInfo_temp.setRover_max(subItemLine[7]);
				resultMap.put(subItemLine[0], subItemInfo_temp);
			}
		}
		return Arrays.asList(resultMap.values().toArray());
	}
}