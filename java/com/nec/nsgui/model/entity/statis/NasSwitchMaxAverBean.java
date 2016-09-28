/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class NasSwitchMaxAverBean {
        private static final String cvsid ="@(#) $Id: NasSwitchMaxAverBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
	private String access_max="--";
	private String response_max="--";
	private String rover_max="--";
	private String access_average="--";
	private String response_average="--";
	private String rover_average="--";
	private String node="";
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
	public String getNode() {
		return node;
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
	 * @param string
	 */
	public void setAccess_average(String string) {
        if(string.equals("nan")){
            string="--";
        }
		access_average = string;
	}

	/**
	 * @param string
	 */
	public void setAccess_max(String string) {
        if(string.equals("nan")){
            string="--";
        }        
		access_max = string;
	}

	/**
	 * @param string
	 */
	public void setNode(String string) {
		node = string;
	}

	/**
	 * @param string
	 */
	public void setResponse_average(String string) {
        if(string.equals("nan")){
            string="--";
        }
		response_average = string;
	}

	/**
	 * @param string
	 */
	public void setResponse_max(String string) {
        if(string.equals("nan")){
            string="--";
        }
		response_max = string;
	}

	/**
	 * @param string
	 */
	public void setRover_average(String string) {
        if(string.equals("nan")){
            string="--";
        }
		rover_average = string;
	}

	/**
	 * @param string
	 */
	public void setRover_max(String string) {
        if(string.equals("nan")){
            string="--";
        }
		rover_max = string;
	}

}
