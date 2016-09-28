<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicroutelisttop.jsp,v 1.5 2005/10/24 10:02:58 changhs Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>
 
<html>
<head>
<%@include file="../../common/head.jsp" %>	
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javascript">

function onRefresh(){
    window.location = "/nsadmin/nic/routeListTop.do";
}
</script>
</head>
<body onload="setHelpAnchor('routing_1');"> 
	<form name="routeListForm" method="post">	
        <html:button property="refreshBtn" onclick="onRefresh();">
           <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br><br>   
        <logic:present name="display4maintain" scope="request">
          <div class="Warning"><bean:message key="nic.list.display4maintain"/></div><br>
        </logic:present>
	    <logic:empty name="routeList" scope="request">
              <br><bean:message key="nic.routelist.noroute"/>
        </logic:empty>	    
	    <logic:notEmpty name="routeList">
	     <bean:define id="routeList" name="routeList" scope="request"/>	     
	     <table border="1">
	     <tr>
	     <th><bean:message key="nic.routelist.from" /></th>
	     <th><bean:message key="nic.route.table.head.destination" /></th>
	     <th><bean:message key="nic.list.table.head.gateway" /></th>
	     <th><bean:message key="nic.route.table.head.nicname" /></th>
	     </tr>	     
	     <logic:iterate id="routeList" name = "routeList">
	     <bean:define id="routeDetail" name="routeList" property="routes"/>
	         <logic:iterate name="routeDetail" id="routeDetail" indexId="i">
	         <tr>
	            <logic:equal name="i" value="0" >
	                   <td rowspan="<bean:write name="routeList" property="routeCount" />">
	                       <logic:equal name="routeList" property="source" value="main">
	                           <bean:message key="nic.routelist.all"/>
	                       </logic:equal>
	                       <logic:notEqual name="routeList" property="source" value="main">
    	                       <bean:write name="routeList" property="source"/>
	                       </logic:notEqual>
	                   </td>
	            </logic:equal>
	            <td><bean:write name="routeDetail" property="destination" /></td>
	            <td <logic:equal name="routeDetail" property="gateway" value="--">align="center"</logic:equal>><bean:write name="routeDetail" property="gateway" /></td>
	            <td><bean:write name="routeDetail" property="nicName" /></td>
	         </tr>
	         </logic:iterate>        
	     </logic:iterate>   	     
	     </table>
   	   </logic:notEmpty>
		</form>
</body>
</html>