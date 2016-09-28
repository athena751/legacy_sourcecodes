package com.nec.nsgui.model.biz.base;
/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
import java.io.*;
public class NSException extends Exception {
	private static final String cvsid =
		"@(#) $Id: NSException.java,v 1.5 2005/09/06 05:55:10 dengyp Exp $";
	public NSException() {
		super(_defmsg);
		init();
	}
	public NSException(Class c) {
		super(_defmsg);
		init();
		setCategory(c);
	}
	public NSException(String msg) {
		super(msg);
		init();
	}
	public NSException(Class c, String msg) {
		super(msg);
		init();
		setCategory(c);
	}
	private void init() {
		detail = new StringBuffer("");
		category = this.getClass();
		level = org.apache.log4j.Priority.ERROR_INT;
		errorCode = "";
	}
	public void setDetail(String msg) {
		if (msg == null)
			msg = "";
		detail = new StringBuffer(msg);
	}
	public void setDetail(StringBuffer msg) {
		detail = (msg == null) ? new StringBuffer("") : msg;
	}
	public void appendDetail(String msg) {
		if (detail == null)
			detail = new StringBuffer();
		detail.append(msg);
	}
	public String getDetail() {
		if (detail == null)
			return null;
		return detail.toString();
	}
	public void setErrorCode(String str) {
		errorCode = str;
	}
	public String getErrorCode() {
		return errorCode;
	}
  public void setCommandErrorCode(String str) {
    commandErrorCode = str;
  }
  public String getCommandErrorCode() {
    return commandErrorCode;
  }
	public void setCategory(Class c) {
		category = c;
	}
	public Class getCategory() {
		return category;
	}
	public void setReportLevel(int n) {
		level = n;
	}
	public int getReportLevel() {
		return level;
	}
	public String where() {
		StringWriter sw = new StringWriter();
		PrintWriter writer = new PrintWriter(sw);
		this.printStackTrace(writer);
		return sw.toString();
	}
	public String[] getCmds() {
		return cmds;
	}
	public void setCmds(String[] strings) {
		cmds = strings;
	}
	private static final String _defmsg = "NS internal error";
	private StringBuffer detail;
	private String[] cmds;
	private String errorCode;
	private String commandErrorCode;
	private Class category;
	private int level;
}
