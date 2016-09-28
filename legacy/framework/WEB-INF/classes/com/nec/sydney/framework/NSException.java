/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.framework;

import	java.io.*;

public class NSException extends Exception {
	private static final String	cvsid = "@(#) $Id: NSException.java,v 1.2300 2003/11/24 00:54:32 nsadmin Exp $";
	public NSException() {
		super(_defmsg);
		init();
	}
	public NSException(String msg){
		super(msg);
		init();
	}
	public NSException(Class c, String msg){
		super(msg);
		init();
		setCategory(c);
	}
	private void	init() {
		detail = null;
		category = this.getClass();
		level = org.apache.log4j.Priority.ERROR_INT;
		errno = 0;
	}
	public void	setReason(String msg) {
		if (msg == null) 
			msg = "";
		detail = new StringBuffer(msg);
	}
	public void	setDetail(String msg){
		setReason(msg);
	}
	public void	setWhy(String msg) {
		setReason(msg);
	}
	public void	appendReason(String msg) {
		if (detail == null) 
			detail = new StringBuffer();
		detail.append(msg);
	}
	public String	whatHappened() {
		if (detail == null) 
			return null;
		return detail.toString();
	}
	public void	setErrorCode(int n) {
		errno = n;
	}
	public int	getErrorCode() {
		return errno;
	}
	public void	setCategory(Class c) {
		category = c;
	}
	public Class	getCategory() {
		return category;
	}
	public void	setReportLevel(int n) {
		level = n;
	}
	public int	getReportLevel() {
		return level;
	}
	public String	where() {
		StringWriter	sw = new StringWriter();
		PrintWriter	writer = new PrintWriter(sw);
		this.printStackTrace(writer);
		return sw.toString();
	}
	private static final String	_defmsg = "NS internal error";
	private StringBuffer	detail;
	private int	errno;
	private Class	category;
	private int	level;
}
