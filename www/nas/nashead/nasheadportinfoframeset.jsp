<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#):$Id: nasheadportinfoframeset.jsp,v 1.2 2007/05/09 05:17:44 yangxj Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<bean:define id="isCluster" value="<%=(NSActionUtil.isCluster(request))? "true":"false"%>"/>
</head>

<Frameset rows="20%,*">
	<frame name="topFrame" src="<%=request.getContextPath()%>/volume/nasheadPortInfoTopShow.do">  
	<logic:notEqual name="isCluster" value="true">
 		<frame name="bottomFrame" src="<%=request.getContextPath()%>/volume/nasheadPortInfoShow.do?nodeNo=0">  
   	</logic:notEqual>
	<logic:equal name="isCluster" value="true">
       	<Frameset rows="50%,*">  
           	<frame name="node0Frame" src="<%=request.getContextPath()%>/volume/nasheadPortInfoShow.do?nodeNo=0">  
           	<frame name="node1Frame" src="<%=request.getContextPath()%>/volume/nasheadPortInfoShow.do?nodeNo=1">  
       	</Frameset>  
    </logic:equal>
</Frameset> 
</html:html>

