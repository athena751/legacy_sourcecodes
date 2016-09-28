/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.framework;

import	java.io.*;
import	java.util.*;

import	javax.servlet.*;
import	javax.servlet.http.*;

import	com.nec.sydney.net.soap.*;
import	com.nec.sydney.system.*;
import  com.nec.nsgui.model.biz.framework.NSTimeout;

public class NSFilter implements Filter {
	private static final String	cvsid = "@(#) $Id: NSFilter.java,v 1.2314 2008/06/05 05:30:48 hetao Exp $";
	private ServletContext	context;
	private List	nogc;
	private Set	noCheckPages;
    private Set cachablePages; 
    private Set forbidUri;
    
	public void	init(FilterConfig config) throws ServletException {
		NSConstant.getInstance().init(config);
		String	root = NSConstant.ConfigRootPath;
		NSReporter.getInstance().init(NSConstant.Log4JConfigFile);
		context = config.getServletContext();
        initNoCheckedPages();
        initCachablePages();
        initForbidUri();
		NSMessageDriver.getInstance().init();
		/* guard GC */
		nogc = new Vector();
		nogc.add(NSReporter.getInstance());
		nogc.add(NSConstant.getInstance());
		nogc.add(SoapManager.getInstance());
		nogc.add(UserManager.getInstance());
		nogc.add(NasManager.getInstance());
		nogc.add(ClusterManager.getInstance());
		nogc.add(Notice.getInstance());
		nogc.add(NSMessageDriver.getInstance());
		NSConstant.getInstance().setMytimeout();
		mytimeout = NSConstant.NSGUI_TIMEOUT;
		NSReporter.getInstance().report(NSReporter.INFO,
				"iStorageManager IP started("+mytimeout+")");
	}
	public void	doFilter(ServletRequest req, ServletResponse res,
					FilterChain chain) 
					throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest)req;
		traceRequest(request);
		HttpServletResponse response = (HttpServletResponse)res;
		String	uri = request.getRequestURI();
		HttpSession	session = request.getSession(false);
        if (session != null && !isForbidUri(uri)) {
			if (isNoCheckedPage(uri) || valid(session)) {
			 	/* 
				 * Ok, he has been already authenticated,
				 * and we proccess his request.
				 */
                String user = (String)session.getAttribute(NSConstant.SESSION_USERINFO);
                if (user != null && user.equals(NSConstant.USER_NAME_NSAMDIN)){
                    if (uri.endsWith("systime_set_dispatch.do")){
                        session.setMaxInactiveInterval(-1);
                    }else{
                        String defaultTimeout = NSTimeout
                            .getInstance().getNsadminTimeout();
                        String  to = request.getParameter("EXTEND_INACTIVE_INTERVAL");
                        int sec = Integer.parseInt(defaultTimeout) * 60;
                        try {
                            if (to != null) {
                                NSReporter.getInstance().report(NSReporter.INFO,
                                        "Extended timeout: "+to + ": " +uri);
                                sec = Integer.parseInt(to);
                            } else {
                            }
                        } catch (Exception ex) {
                            /* nothing to do */
                        }                        
                        session.setMaxInactiveInterval(sec);
                    }       
                } 			
                if (!isCachablePage(uri)) {
                /*if the page is not cachable , process cache. */
                    setNoCacheHeader(response);
                }
				chain.doFilter(request, response);
				return;
			}
			/* unknown value of 'authenticated' */
			session.removeAttribute(NSConstant.SESSION_AUTHENTICATED);
            session.removeAttribute(NSConstant.SESSION_USERINFO);
            //session.invalidate(); 
		}
		if (isNoCheckedPage(uri)) {
			chain.doFilter(request, response);
			return;
		}
		/* 
		 * This is the 1st access for him or time is over.
		 */
		forwardToLoginPage(request, response);
		return; // NEVER REACHED
	}
	private void	forwardToLoginPage(HttpServletRequest request,
						HttpServletResponse response)
			    throws IOException, ServletException {
		String	originalURI = request.getRequestURI();
		request.setAttribute(NSConstant.FORM_ORIGINALURI, originalURI);
		RequestDispatcher	dispatcher = 
			request.getRequestDispatcher(NSConstant.LoginURI);
		dispatcher.forward(request, response);
	}
	private boolean	isNoCheckedPage(String uri) {
		NSReporter.getInstance().report(NSReporter.DEBUG, "the URI: "+uri);
		if (uri.startsWith("/nsadmin/images/") 
			|| uri.startsWith("/nsadmin/help")
            || uri.endsWith(".css")
            || uri.endsWith(".js"))
			return true;
		return noCheckPages.contains(uri);
	}
    
    private boolean isForbidUri(String uri) {
        return forbidUri.contains(uri);
    }
        
    private boolean valid(HttpSession session) {
        int TIMEOUT_INTERVAL = 1000*10;
        String  authenticated = 
                                (String)session.getAttribute(NSConstant.SESSION_AUTHENTICATED);
        if (authenticated == null)
            return false;
        if (authenticated.equals("true")) {
            if (session.getAttribute(NSConstant.SESSION_USERINFO) == null) {
                return false;
            }
            //return true;
            if(session.getMaxInactiveInterval() < 0) {
                return true;
            } else if (System.currentTimeMillis() - session.getLastAccessedTime() 
                <= session.getMaxInactiveInterval() * 1000 + TIMEOUT_INTERVAL){
                // plus the TIMEOUT_INTERVAL to avoid processing the timeout event
                // at the same time with tomcat.
                return true;
            }
        }
        return false;
    }
    
	private void	traceRequest(HttpServletRequest req) {
		NSReporter	reporter = NSReporter.getInstance();
		String	uri = req.getRequestURI();
		reporter.trace(req.getRemoteAddr() + ":" 
				+ req.getMethod() + ":" + uri);
		Set	parms = req.getParameterMap().entrySet();
		Iterator	it = parms.iterator();
		while (it.hasNext()) {
			Map.Entry	param = (Map.Entry)it.next();
			String	name = (String)param.getKey();
			String[] values = (String[])param.getValue();
			StringBuffer	val = new StringBuffer(name+": ");
			for (int i = 0; i < values.length; ++i) {
				String	value;
				if (name.startsWith("_") || name.endsWith("_")){
				    value = "*****";
				}else{
    				try {
    					value = new String(values[i].getBytes("8859_1"), "JISAutoDetect");
    				} catch (Exception ex) {
    					value = values[i];
    				}
			    }
				val.append("<<"+value+">> ");
			}
			reporter.trace(val.toString());
		}
	}
	public void	destroy() {
		/* nothing to do */
	}
	private int	mytimeout;
    
    private void initCachablePages() {
        cachablePages = new HashSet(noCheckPages);
        cachablePages.add("/nsadmin/cgi/rrd2csvCGI.pl");
        cachablePages.add("/nsadmin/nas/logview/logdownload.jsp");
        cachablePages.add("/nsadmin/nas/csar/csardownload.jsp");
	}
    private boolean	isCachablePage(String uri) {
		if (uri.startsWith("/nsadmin/images/")
			|| uri.startsWith("/nsadmin/etc/")
			|| uri.startsWith("/nsadmin/download/") 
			|| uri.startsWith("/nsadmin/help"))
			return true;
		return cachablePages.contains(uri);
	}
    private void setNoCacheHeader(HttpServletResponse response) {

        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
    }
    private void	initNoCheckedPages() {
		noCheckPages = new HashSet();
		noCheckPages.add(NSConstant.LoginURI);
		noCheckPages.add(NSConstant.ConfigRootPath+"/framework/loginShow.do");
        noCheckPages.add(NSConstant.ConfigRootPath+"/framework/login.do");
        noCheckPages.add(NSConstant.ConfigRootPath+"/framework/logout.do");
        noCheckPages.add(NSConstant.ConfigRootPath+"/notfound.html");
		noCheckPages.add(NSConstant.ConfigRootPath+"/checkTarget.jsp");
		noCheckPages.add(NSConstant.ConfigRootPath+"/index.html");
		noCheckPages.add(NSConstant.ConfigRootPath+"/index.jsp");
        noCheckPages.add(NSConstant.ConfigRootPath);
        noCheckPages.add(NSConstant.ConfigRootPath+"/");
	}

    private void    initForbidUri() {
        forbidUri = new HashSet();
        forbidUri.add(NSConstant.ConfigRootPath+"/main.jsp");
        forbidUri.add(NSConstant.ConfigRootPath+"/login.jsp");
        forbidUri.add(NSConstant.ConfigRootPath+"/logout.jsp");
        forbidUri.add(NSConstant.ConfigRootPath+"/loginnofip.jsp");
        forbidUri.add(NSConstant.ConfigRootPath+"/loginuserwrong.jsp");
        forbidUri.add(NSConstant.ConfigRootPath+"/loginmaxsession.jsp");
    }

}
