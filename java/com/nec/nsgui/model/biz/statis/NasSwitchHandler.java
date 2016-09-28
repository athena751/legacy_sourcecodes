/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.statis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.statis.LineNumComparator;
import com.nec.nsgui.action.statis.StatisActionConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.statis.NasSwitchMaxAverBean;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;

/**
 *
 */
public class NasSwitchHandler implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: NasSwitchHandler.java,v 1.1 2005/10/18 16:34:22 het Exp $";
	private static final String SCRIPT_GET_MAX_LIST =
		"/bin/statis_getRRADatas.pl";
	private static final String SCRIPT_GET_SUBITEM_LIST =
		"/bin/statis_getNasSwitchInfo.pl";

	public static HashMap getAllSubItemList(String collectionID)
		throws Exception {
		HashMap subItemMap = new HashMap();
		String[] cmds =
			{
				CmdExecBase.CMD_SUDO,
				System.getProperty("user.home") + SCRIPT_GET_SUBITEM_LIST,
				collectionID };
		NSCmdResult result = CmdExecBase.execCmdInMaintain(cmds, true);
		String[] stdout = result.getStdout();
		for (int i = 0; i < stdout.length; i++) {
			String[] subItemLine = stdout[i].split("\t");
			subItemMap.put(subItemLine[0], subItemLine[1]);
		}
		return subItemMap;
	}
	public static List getSubItemInfoList(
		int count,
		String startTime,
		String endTime,
		String collectionID,
		String interval,
		List subItemList)
		throws Exception {
		String[] inputs = new String[count];
		int h = 0;
		for (int i = 0; i < subItemList.size(); i++) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) subItemList.get(i);
			String subItem = NSActionUtil.ascii2hStr(subItemInfo.getSubItem());
			String node0 = subItemInfo.getBean4Node0().getNode();
			String node1 = subItemInfo.getBean4Node1().getNode();
			if (!node0.equals("")) {
				inputs[h++] = subItem;
				inputs[h++] = node0;
			}
			if (!node1.equals("")) {
				inputs[h++] = subItem;
				inputs[h++] = node1;
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
		List subItemInfoList = new ArrayList();
		String[] stdout = result.getStdout();
		int length = stdout.length;
		for (int i = 0; i < length; i++) {
			String[] subItemLine = stdout[i].split("\t");
			for (int j = 0; j < subItemList.size(); j++) {
				NasSwitchSubItemInfoBean subItemInfo_temp =
					(NasSwitchSubItemInfoBean) subItemList.get(j);
				NasSwitchMaxAverBean bean4Node0 =
					(NasSwitchMaxAverBean) subItemInfo_temp.getBean4Node0();
				NasSwitchMaxAverBean bean4Node1 =
					(NasSwitchMaxAverBean) subItemInfo_temp.getBean4Node1();
				if (subItemLine[0].trim().equals(subItemInfo_temp.getSubItem())
					&& subItemLine[1].trim().equals(bean4Node0.getNode())) {
					bean4Node0.setAccess_average(subItemLine[2]);
					subItemInfo_temp.setAccess_average(subItemLine[2]);
					bean4Node0.setAccess_max(subItemLine[3]);
					subItemInfo_temp.setAccess_max(subItemLine[3]);
					bean4Node0.setResponse_average(subItemLine[4]);
					subItemInfo_temp.setResponse_average(subItemLine[4]);
					bean4Node0.setResponse_max(subItemLine[5]);
					subItemInfo_temp.setResponse_max(subItemLine[5]);
					bean4Node0.setAccess_average(subItemLine[6]);
					subItemInfo_temp.setAccess_average(subItemLine[6]);
					bean4Node0.setAccess_max(subItemLine[7]);
					subItemInfo_temp.setAccess_max(subItemLine[7]);
					subItemInfo_temp.setBean4Node0(bean4Node0);
				}
				if (subItemLine[0].trim().equals(subItemInfo_temp.getSubItem())
					&& subItemLine[1].trim().equals(bean4Node1.getNode())) {
					bean4Node1.setAccess_average(subItemLine[2]);
					subItemInfo_temp.setAccess_average(subItemLine[2]);
					bean4Node1.setAccess_max(subItemLine[3]);
					subItemInfo_temp.setAccess_max(subItemLine[3]);
					bean4Node1.setResponse_average(subItemLine[4]);
					subItemInfo_temp.setResponse_average(subItemLine[4]);
					bean4Node1.setResponse_max(subItemLine[5]);
					subItemInfo_temp.setResponse_max(subItemLine[5]);
					bean4Node1.setAccess_average(subItemLine[6]);
					subItemInfo_temp.setAccess_average(subItemLine[6]);
					bean4Node1.setAccess_max(subItemLine[7]);
					subItemInfo_temp.setAccess_max(subItemLine[7]);
					subItemInfo_temp.setBean4Node0(bean4Node1);
				}
				subItemInfoList.add(subItemInfo_temp);
			}
		}
		LineNumComparator stringNumCom = new LineNumComparator();
		List resultList = new ArrayList();
		for (int i = 0; i < subItemInfoList.size(); i++) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) subItemInfoList.get(i);
			NasSwitchMaxAverBean bean4Node0 =
				(NasSwitchMaxAverBean) subItemInfo.getBean4Node0();
			NasSwitchMaxAverBean bean4Node1 =
				(NasSwitchMaxAverBean) subItemInfo.getBean4Node1();
			if (stringNumCom
				.compare(
					bean4Node0.getAccess_average(),
					bean4Node1.getAccess_average())
				>= 0) {
				subItemInfo.setAccess_average(bean4Node0.getAccess_average());
			} else {
				subItemInfo.setAccess_average(bean4Node1.getAccess_average());
			}
			if (stringNumCom
				.compare(bean4Node0.getAccess_max(), bean4Node1.getAccess_max())
				>= 0) {
				subItemInfo.setAccess_average(bean4Node0.getAccess_max());
			} else {
				subItemInfo.setAccess_average(bean4Node1.getAccess_max());
			}
			if (stringNumCom
				.compare(
					bean4Node0.getResponse_average(),
					bean4Node1.getResponse_average())
				>= 0) {
				subItemInfo.setAccess_average(bean4Node0.getResponse_average());
			} else {
				subItemInfo.setAccess_average(bean4Node1.getResponse_average());
			}
			if (stringNumCom
				.compare(
					bean4Node0.getResponse_max(),
					bean4Node1.getResponse_max())
				>= 0) {
				subItemInfo.setAccess_average(bean4Node0.getResponse_max());
			} else {
				subItemInfo.setAccess_average(bean4Node1.getAccess_average());
			}
			if (stringNumCom
				.compare(
					bean4Node0.getRover_average(),
					bean4Node1.getRover_average())
				>= 0) {
				subItemInfo.setAccess_average(bean4Node0.getRover_average());
			} else {
				subItemInfo.setAccess_average(bean4Node1.getRover_average());
			}
			if (stringNumCom
				.compare(bean4Node0.getAccess_max(), bean4Node1.getAccess_max())
				>= 0) {
				subItemInfo.setAccess_average(bean4Node0.getAccess_max());
			} else {
				subItemInfo.setAccess_average(bean4Node1.getAccess_max());
			}
			resultList.add(subItemInfo);
		}
		return resultList;
	}
}