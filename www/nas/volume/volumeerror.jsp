<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumeerror.jsp,v 1.9 2008/05/21 09:27:47 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<html:html lang="true">
<head>
<bean:parameter id="from" name="from" value="volume"/>
<bean:parameter id="onlyErrMsg" name="onlyErrMsg" value="false"/>

<% 
    String src = (String)request.getParameter("src");
    if(src != null && !src.equals("")){
        from = src;
    }
    String title = "title.h1";
    if(from.equals("replication")){
        title = "replication.h1"; 
    }else if(from.equals("lvm")){
        title = "title.lvm.h1";
    }
%>
<logic:equal name="module4ErrPage" value="replication" scope="session">
	<%title = "replication.h1";%>
</logic:equal>
<logic:equal name="module4ErrPage" value="ddr" scope="session">
	<%title = "ddr.h1";%>
</logic:equal>
<%@include file="/common/head.jsp" %>
<%if (request.getParameter("popup") != null){%>
    <title><bean:message key="<%=title%>"/></title>
<%}%>
</head>
<body onload="displayAlert();" onUnload="closeDetailErrorWin();">
<%if (request.getParameter("popup") != null){%>
    <h1 class="popup"><bean:message key="<%=title%>"/></h1>
<%}else{%>
    <logic:equal name="onlyErrMsg" value="false">
	    <logic:notEqual name="from" value="replication">
        	<h1 class="title"><bean:message key="<%=title%>"/></h1>
	    </logic:notEqual>
	    
	    <logic:equal name="from" value="replication">
	        <html:button property="goBack" onclick="window.location='/nsadmin/replication/replicaList.do?operation=display';">
			    <bean:message key="common.button.back" bundle="common"/>
			</html:button>
	    </logic:equal>
    </logic:equal>
<%}%>
<br><br>
<displayerror:error h1_key="<%=title%>"/>
<br>
<form>
<%if (request.getParameter("popup") != null){%>
    <html:button property="close" onclick="window.close();">
       <bean:message key="common.button.close" bundle="common"/>
    </html:button>
<%}%>
</form>
</body>
</html:html>