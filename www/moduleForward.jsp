<!--
        Copyright (c) 2004-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: moduleForward.jsp,v 1.5 2008/05/30 02:58:50 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.nec.nsgui.action.base.*" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>

<bean:parameter id="doNotClear" name="doNotClear" value="no"/>
<bean:parameter id="doNotLock" name="doNotLock" value="no"/>
<logic:equal name="doNotClear" value="no">
<% 
    NSActionUtil.clearSession4NAS(request);
%>
</logic:equal>

<head>
    <%@include file="common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript">
    	function forwardToTarget(){
    		<logic:notEqual parameter="url" value="">
    		    var url=window.location.search;
    		    url = url.replace(/^.*[\?\&]url=/,"");
    		    window.location = url;
    		</logic:notEqual>
    		<logic:equal parameter="url" value="">
    			top.MENU.curForm.submit();	
    		</logic:equal>
    	}
    </script>
</head>
<body onload="
        <logic:notEqual parameter="doNotLock" value="yes">
             lockMenu();    
        </logic:notEqual>
        
        forwardToTarget();" 
      onUnload="
        <logic:notEqual parameter="doNotLock" value="yes">
            unLockMenu();
        </logic:notEqual>
        <logic:notEqual parameter="func" value="">
            <bean:parameter id="func" name="func"/>
            <bean:write name="func"/>
        </logic:notEqual>
    ">
    <logic:notEqual parameter="h1" value="">
        <bean:parameter id="h1" name="h1"/>
        <h1><bean:message bundle="menuResource" name="h1"/></h1>
    </logic:notEqual>
    <logic:notEqual parameter="h2" value="">
        <bean:parameter id="h2" name="h2"/>
        <h2><bean:message bundle="menuResource" name="h2"/></h2>
    </logic:notEqual>
    <logic:notEqual parameter="msgKey" value="">
    	<bean:parameter id="msgKey" name="msgKey" />
    	<font size="5"><b><bean:message bundle="menuResource" name="msgKey" /></b></font>
   	</logic:notEqual>
</body>
</html>
