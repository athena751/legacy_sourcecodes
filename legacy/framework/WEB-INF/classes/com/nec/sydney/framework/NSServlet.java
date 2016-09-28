/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.framework;

import	java.io.*;

import	javax.servlet.*;
import	javax.servlet.http.*;

import	com.nec.sydney.framework.*;

abstract public class NSServlet extends HttpServlet {
	private static final String	cvsid = "@(#) $Id: NSServlet.java,v 1.2300 2003/11/24 00:54:33 nsadmin Exp $";
	public void	init(ServletConfig config) throws ServletException {
		super.init(config);
	}
	abstract public void	doService(HttpServletRequest request,
						HttpServletResponse response) 
				throws ServletException, IOException;
	public void	doGet(HttpServletRequest request,
						HttpServletResponse response) 
				throws ServletException, IOException {
		doService(request, response);
	}
	public void	doPost(HttpServletRequest request,
						HttpServletResponse response) 
				throws ServletException, IOException {
		doService(request, response);
	}
	protected void	gotoPage(String thePage, HttpServletRequest request,
						HttpServletResponse response) 
				throws ServletException, IOException {
		RequestDispatcher	dispatcher =
			getServletContext().getRequestDispatcher(thePage);
		dispatcher.forward(request, response);
	}
}
