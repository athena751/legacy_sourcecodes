<!--
        Copyright (c) 2004-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: main.jsp,v 1.17 2007/06/25 01:30:52 liul Exp $" -->
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.nsgui.model.biz.syslog.SyslogCmdHandler" %>
<%@ page import="com.nec.nsgui.action.cifs.CommonUtil" %>
<%
    String sids=CommonUtil.getCurSessionsID(request);
    SyslogCmdHandler.cleanTmpFile4login(sids);
%>

<html>
 <head>
  <title><bean:message key="myname"/>
         <logic:present name="titleHost" scope="session">
             <bean:write name="titleHost"/>
         </logic:present>
  </title>
  
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="robots" content="noindex,nofollow" >
  </head>
    <frameset rows="85,**" cols="*" frameborder="NO" border="0" framespacing="0">
        <frameset rows="50,*" cols="*" frameborder="NO" border="0" framespacing="0">
            <frame name="TITLE" src="/nsadmin/title.jsp" scrolling="no"/>
            <frame name="CONTROLL" src="/nsadmin/framework/control.do?operation=display" scrolling="no"/>
        </frameset>
        <frameset cols="230,*" frameborder="1" border="1" framespacing="1">
            <frame name="MENU" src="/nsadmin/common/commonblank.html" scrolling="yes"/>
            <frame name="ACTION" src="/nsadmin/action.html"/>
        </frameset>
    </frameset>
</html>
