/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.base;

import java.util.*;
import javax.servlet.http.*;
import javax.servlet.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.net.soap.*;
import com.nec.sydney.framework.*;
import java.net.*;

import java.lang.*;
import java.lang.reflect.*;
import java.beans.*;
import com.nec.sydney.beans.base.*;


public abstract class AbstractJSPBean implements NasConstants,NSExceptionMsg{

    private static final String     cvsid = "@(#) $Id: AbstractJSPBean.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";

  /* constants used for _state */

  public static final int NEW = 0;
  public static final int PROC = 1;
  public static final int ERR = -1;

  private int _state; // current state
  //private String _errorMsg; // current message that is being appended during validation
  private static final String SESSION_CLUSTER_NUM = "clusterMyNum";
  /* standard Servlet objects that need to be setup for each JSP Bean */
  protected HttpServletRequest request;
  protected HttpServletResponse response;
  protected Servlet servlet;
  protected HttpSession session;
  protected String target;
  protected String etcPath;
  private String myNum;
  public AbstractJSPBean () {
    setState(NEW);
  }

  /**
   * Processing that will occur before the page output has starded,
   * for the second and all subsequent invocation of  the page.<br>
   * Implemet it in the concrete JSP java bean classes.
   */
  protected abstract void beanProcess() throws Exception;

  /**
   * Processing that will occur before the page output has started,
   * for the first invocation of  the page.<br>
   * Implemet it in the concrete JSP java bean classes.
   *
  protected abstract void beanFirstPassProcess() throws Exception;
    */

  /**
   * Processing that will occur after the page output is completed.<br>
   * Implemet it in the concrete JSP java bean classes
   */
  //protected abstract void beanFooterProcess() throws java.io.IOException;

  /**
   * Return the PAGE_CODE.
   * Implemet it in the concrete JSP java bean classes
   */
  //protected abstract String getJSPCode();

  /**
   * Processing that will occur before the page output has starded. Called from each
   * JSP page; actually it is called from includepageheader.jsp that should be
   * included in each JSP page. Page specific processing is accomplished by
   * calling abastract methods that are implemented in the concrete JSP beans.
   * @exception java.io.IOException: because beanProcess() would typically call
   * servlets methods that throw this exception.
   */
  public void process() throws Exception {
         target=request.getParameter(TARGET);
        String targetSession=(String)session.getAttribute(TARGET);
        if(target!=null){
            if( (targetSession==null) || (!target.equals(targetSession)) ) {
                session.setAttribute(SESSION_CLUSTER_NUM, null);
            }
            session.setAttribute(TARGET, target);
        } else {
            target=(String)session.getAttribute("target");
        }
        beanProcess();

    // validation that all common fields have been properly set by the application
    // this is actually checking that the code has been written properly
    String l_err = "";
    if (request == null) l_err = l_err + "; Request must be set";
    if (response == null) l_err = l_err + "; Response must be set";
    if (servlet == null) l_err = l_err + "; Servlet must be set";
    if (l_err != "") throw new IllegalStateException(l_err);
  }

  /**
   * Processing that will occur after the page output is completed.Called from each
   * JSP page; actually it is called from includefooter.jsp that should be
   * included in each JSP page. Page specific processing is accomplished by
   * calling abastract beanFooterProcess() that is implemented in the concrete JSP Beans
   * @exception java.io.IOException: because beanFooterProcess() can call
   * servlets methods that throw this exception
   */
  public void footerProcess() throws java.io.IOException {
    //beanFooterProcess();
  }

  /**
   * Append to the current error message and set the status to ERROR.
   * @param String addErrorMsg - Error message string to append
   */
  /*protected void addErrorMsg (String addErrorMsg) {
    if (_errorMsg == null) _errorMsg = addErrorMsg;
    else _errorMsg =  _errorMsg + " <br>\n" + addErrorMsg;

    setState(ERR);
  }*/
  /**
   * Reset (set to null) the current error message.
   */
 /* protected void resetErrorMsg () {
    _errorMsg = null;
  }*/
    protected void setMsg (String i_msg) {
        session.setAttribute("alertMessage",i_msg);
    }
    public String getMsg () {
        String tempMsg = (String)session.getAttribute("alertMessage");
        session.setAttribute("alertMessage",null);
        return tempMsg;
    }
  /**
   * Retrieve the error messagge.
   * @return String
   */
  /*public String getErrorMsg () {
      if (_errorMsg == null) return "";
      else return _errorMsg;
  }*/

  /**
   * Set the current state
   * @param String
   */
  protected void setState (int newState) {
    _state = newState;
  }
  /**
   * Retrieve the current state
   * @return String
   */
  public int getState () {
    return _state;
  }


  public void setRequest (HttpServletRequest newRequest) {
    request = newRequest;
    session = request.getSession(true);
  }
  /**
   * Set Http Response that is implicit object in all JSP. It might be required
   * for some processing. Called from includepageheader.jsp
   * @param HttpServletResponse
   */
  public void setResponse (HttpServletResponse newResponse) {
    response = newResponse;
  }
  /**
   * Set HttpServlet object that is implicit object in all JSP. It might be required
   * for some processing. Called from includepageheader.jsp
   * @param Servlet
   */
  public void setServlet (Servlet newServlet) {
    servlet = newServlet;
  }

    /* Check is ip address */
    public boolean isIp(String s){
        s=s.trim();
        int k=0,count=0;
        for(k=0;k<s.length();k++)
        {
            char a=s.charAt(k);
            if(a=='.'){
                count++;
            }
        }
        if(count!=3){
            return false;
        }
        StringTokenizer st = new StringTokenizer(s,".");
        if(st.countTokens()!=4){
            return false;
        }
        String single;
        while(st.hasMoreTokens())
        {
            single = st.nextToken();
            int n=-1;
            n=Integer.parseInt(single);
            if(n>255||n<0){
                return false;
            }
        }
        return true;
    }

    public String URLEncode( String value )
    {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch ( Exception e ) {
            return value;
        }
    }

    public String getEtcPath() {
        try {
            myNum = getMyNum();
            etcPath = "/etc/group" + myNum + "/";
        } catch (Exception e) {
            // debug
            NSReporter.getInstance().report(NSReporter.DEBUG,"getEtcPath() failed");
        }
        return etcPath;
    }

    public String getMyNum() {
        try{
            if (Soap4Cluster.whoIsMyFriend(target) == null) {
                myNum = "0";
            } else {
                myNum = (String)session.getAttribute("clusterMyNum");
                if( myNum == null ) {
                    ClusterInfo clusterEtc = ClusterSOAPClient.getCluster(target);
                    myNum = clusterEtc.getMyNo();
                }
                session.setAttribute(SESSION_CLUSTER_NUM, myNum);
            }
        } catch (Exception e) {
            //debug
            NSReporter.getInstance().report(NSReporter.DEBUG,"getMyNum() failed");
        }
        return myNum;
    }


    public void remoteSync(String[] files) {
        try {
            String fnode = Soap4Cluster.whoIsMyFriend(target);
            if (fnode != null){
                myNum = getMyNum();
                ClusterSOAPClient.remoteSync( files, myNum, fnode, target);
            }
        } catch (Exception e) {
            //debug
            NSReporter.getInstance().report(NSReporter.DEBUG,"remoteSync() failed");
        }
        return;
    }

    public void remoteSync(String[] files, String desUrl, String srcUrl) throws Exception {
        remoteSync(files, desUrl, srcUrl, false);
    }

    public void remoteSync(String[] files, String desUrl, String srcUrl, boolean throwEx) throws Exception {
        try {
            ClusterInfo clusterEtc = ClusterSOAPClient.getCluster(srcUrl);
            ClusterSOAPClient.remoteSync( files, desUrl, srcUrl );
        } catch (Exception e) {
            if(throwEx){
                throw e;
            }else{
                //debug
                NSReporter.getInstance().report(NSReporter.ERROR,"remoteSync() failed");
            }
        }
        return;
    }
}

 