/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

import com.nec.nsgui.action.statis.LineNumComparator;

/**
 *
 */
public class NasSwitchSubItemInfoBean {
        private static final String cvsid ="@(#) $Id: NasSwitchSubItemInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
	private int sequence;
	private String subItem = "";
	private String access_max = "--";
	private String response_max = "--";
	private String rover_max = "--";
	private String access_average = "--";
	private String response_average = "--";
	private String rover_average = "--";
	private String stockPeriod = "--";
	private NasSwitchMaxAverBean bean4Node0 = new NasSwitchMaxAverBean();
	private NasSwitchMaxAverBean bean4Node1 = new NasSwitchMaxAverBean();
	private String isWhichNode = "";
	private String interval = "--";
	private LineNumComparator lineNumCom = new LineNumComparator();

	/**
	 * @return
	 */
	public String getAccess_average() {
		return access_average;
	}

	/**
	 * @return
	 */
	public String getAccess_max() {
		return access_max;
	}

	/**
	 * @return
	 */
	public NasSwitchMaxAverBean getBean4Node0() {
		return bean4Node0;
	}

	/**
	 * @return
	 */
	public NasSwitchMaxAverBean getBean4Node1() {
		return bean4Node1;
	}

	/**
	 * @return
	 */
	public String getResponse_average() {
		return response_average;
	}

	/**
	 * @return
	 */
	public String getResponse_max() {
		return response_max;
	}

	/**
	 * @return
	 */
	public String getRover_average() {
		return rover_average;
	}

	/**
	 * @return
	 */
	public String getRover_max() {
		return rover_max;
	}

	/**
	 * @return
	 */
	public int getSequence() {
		return sequence;
	}

	/**
	 * @return
	 */
	public String getStockPeriod() {
		return stockPeriod;
	}

	/**
	 * @return
	 */
	public String getSubItem() {
		return subItem;
	}

	/**
	 * @param string
	 */
	public void setAccess_average(String string) {
        if(string.equals("nan")){
            string="--";
        }
		if (lineNumCom.compare(string, access_average) > 0) {
			access_average = string;
		}
	}

	/**
	 * @param string
	 */
	public void setAccess_max(String string) {
        if(string.equals("nan")){
            string="--";
        }
		if (lineNumCom.compare(string, access_max) > 0) {
			access_max = string;
		}
	}

	/**
	 * @param bean
	 */
	public void setBean4Node0(NasSwitchMaxAverBean bean) {
		bean4Node0 = bean;
	}

	/**
	 * @param bean
	 */
	public void setBean4Node1(NasSwitchMaxAverBean bean) {
		bean4Node1 = bean;
	}

	/**
	 * @param string
	 */
	public void setResponse_average(String string) {
        if(string.equals("nan")){
            string="--";
        }
		if (lineNumCom.compare(string, response_average) > 0) {
			response_average = string;
		}
	}

	/**
	 * @param string
	 */
	public void setResponse_max(String string) {
        if(string.equals("nan")){
            string="--";
        }
		if (lineNumCom.compare(string, response_max) > 0) {
			response_max = string;
		}
	}

	/**
	 * @param string
	 */
	public void setRover_average(String string) {
        if(string.equals("nan")){
            string="--";
        }
		if (lineNumCom.compare(string, rover_average) > 0) {
			rover_average = string;
		}
	}

	/**
	 * @param string
	 */
	public void setRover_max(String string) {
        if(string.equals("nan")){
            string="--";
        }
		if (lineNumCom.compare(string, rover_max) > 0) {
			rover_max = string;
		}
	}

	/**
	 * @param i
	 */
	public void setSequence(int i) {
		sequence = i;
	}

	/**
	 * @param string
	 */
	public void setStockPeriod(String string) {
		stockPeriod = string;
	}

	/**
	 * @param string
	 */
	public void setSubItem(String string) {
		subItem = string;
	}

	/**
	 * @return
	 */
	public String getInterval() {
		return interval;
	}

	/**
	 * @param string
	 */
	public void setInterval(String string) {
		interval = string;
	}

	/**
	 * @return
	 */
	public String getIsWhichNode() {
		return isWhichNode;
	}

	/**
	 * @param string
	 */
	public void setIsWhichNode(String string) {
		isWhichNode = string;
	}

}
