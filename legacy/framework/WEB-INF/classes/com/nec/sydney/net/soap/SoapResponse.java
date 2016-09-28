/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.net.soap;

public class	SoapResponse {
	private static final String	cvsid = "@(#) $Id: SoapResponse.java,v 1.2300 2003/11/24 00:54:34 nsadmin Exp $";
	public SoapResponse() {
		successful = true;
		errorCode = 0;
		errorMessage = "";
	}
	public void	setSuccessful(boolean b) {
		successful = b;
	}
	public boolean	isSuccessful() {
		return successful;
	}
	public void	setErrorCode(int n) {
		errorCode = n;
	}
	public int	getErrorCode() {
		return errorCode;
	}
	public void	setErrorMessage(String msg) {
		errorMessage = new String(msg);
	}
	public String	getErrorMessage() {
		return errorMessage;
	}
	private boolean	successful;
	private int	errorCode;
	private String	errorMessage;
}
