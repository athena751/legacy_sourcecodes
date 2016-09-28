<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: loginmaxsession.jsp,v 1.4 2007/05/09 05:20:09 liul Exp $" -->

<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="myname"/><bean:write name="titleHost"/></title>
</head>
<body>
<table border="0">
    <tr>
      <td class="ErrorInfo"><img border=0 src="/nsadmin/images/icon/png/icon_alert.png"></td>
      <td class="ErrorInfo"><bean:message key="error.td_error" bundle="errorDisplay"/>&nbsp;&nbsp;</td>
      <td class="ErrorInfo">
            <logic:equal name="username" value="nsview" scope="request">
                <bean:define id="maxsession" name="maxsession" scope="request" type="java.lang.String"/>
                <bean:message key="login.maxsession.nsview.info" arg0="<%=maxsession%>"/>
            </logic:equal>
            <logic:equal name="username" value="nsadmin" scope="request">
                <bean:message key="login.maxsession.nsadmin.info"/>
            </logic:equal>
        </td>
     </tr>
</table>
<br>
<h3>
<logic:equal name="username" value="nsview" scope="request">
    <bean:message key="login.maxsession.nsview.h3"/>
</logic:equal>
<logic:equal name="username" value="nsadmin" scope="request">
    <bean:message key="login.maxsession.nsadmin.h3"/>
</logic:equal>
</h3>
<br>
<logic:notEmpty name="loginUsers" scope="request">
	<bean:define id="tableMode" name="loginUsers" scope="request"/>
	<nssorttab:table  tablemodel="<%=(SortTableModel)tableMode%>" 
								id="list1"
								table="border=1" 
								sortonload="from:ascend" >
	  
	           <nssorttab:column name="from" 
	                  th="STHeaderRender" 
	                  td="STDataRender"
	                  sortable="no">
	                  <bean:message key="login.maxsession.table.th.from"/>
            	</nssorttab:column>
            	
            	<nssorttab:column name="loginTime" 
                      th="STHeaderRender" 
                      td="STDataRender"
                      sortable="no">
                      <bean:message key="login.maxsession.table.th.login"/>
                </nssorttab:column>
                
                <nssorttab:column name="lastAccessTime" 
                      th="STHeaderRender" 
                      td="STDataRender"
                      sortable="no">
                      <bean:message key="login.maxsession.table.th.lastaccess"/>
                </nssorttab:column>
	</nssorttab:table>            
</logic:notEmpty>
<logic:equal name="username" value="nsadmin" scope="request">
<ul>
    <bean:define id="remainder" name="remainder" scope="request" type="java.lang.String"/>
    <li><bean:message key="login.maxsession.relogin.tip" arg0="<%=remainder%>"/><BR>
    <logic:equal name="versionType" value="<%= NSActionConst.VERSION_TYPE_JAPAN%>" scope="request" >
    	<bean:message key="login.maxsession.japan.suggestion" />
    </logic:equal>
    <logic:notEqual name="versionType" value="<%= NSActionConst.VERSION_TYPE_JAPAN%>" scope="request" >
    	<bean:message key="login.maxsession.abroad.suggestion" />
    </logic:notEqual>
    </li>
</ul>
</logic:equal>
<br><br>
&nbsp;&nbsp;<html:button property="back" onclick="window.location='/nsadmin/framework/loginShow.do';">
<bean:message key="common.button.back" bundle="common"/>
</html:button>
</body>
</html:html>
