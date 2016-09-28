<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsshareaccesslog4nsview.jsp,v 1.3 2005/09/08 00:24:42 key Exp $" -->

<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<title><bean:message key="cifs.shareAccessLog.h3_4nsview"/></title>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function onReload(){
	if (isSubmitted()){
	  	return false;
	}
	setSubmitted();
	window.location="setAccessLog4nsview.do?operation=display";
}

function onClose(){
    window.close();
}

</script>
</head>
<body onload="setHelpAnchor('network_cifs_5');" onUnload="setHelpAnchor('network_cifs_1');">
<html:form action="setAccessLog4nsview.do">
<nested:define id="shareName" property="shareName" type="java.lang.String"/>
<nested:nest property="info">
<h1 class="popup"><bean:message key="cifs.common.h1"/></h1>
<nested:equal property="shareExist" value="yes" >
 <html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
 </html:button>
</nested:equal>
<h3 class="popup"><bean:message key="cifs.shareAccessLog.h3_4nsview"/></h3>
<nested:equal property="shareExist" value="yes" >
<p class="domain"><bean:message key="cifs.th.logging"/></p>

<displayerror:error h1_key="cifs.common.h1"/>
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="cifs.shareOption.th_sharename"/></th>
    <td>
        <%=NSActionUtil.sanitize(shareName)%>
        <html:hidden property="shareName"/>
    </td>
  </tr>
  <tr>
    <th><bean:message key="cifs.shareAccessLog.th_logging"/></th>
    <td>
        <nested:equal  property="alogEnable" value="yes">
	          <bean:message key="cifs.td.valid"/>
		</nested:equal> 
		<nested:notEqual  property="alogEnable" value="yes">
	          <bean:message key="cifs.td.invalid"/>
		</nested:notEqual> 		
    </td>
  </tr>
</table> 
<nested:equal  property="alogEnable" value="yes">

<p class="domain"><bean:message key="cifs.shareAccessLog.th_loggingitems"/></p>
     <logic:equal name="shareAccessLogForm" property="logType" value="all">
		<table border="1" class="Vertical">
            <tr>
            	<td>&nbsp;</td>
                <td align="center"><bean:message key="cifs.common.success"/></td>
                <td align="center"><bean:message key="cifs.common.error"/></td>
            </tr>
            <tr>
            	<td align="center"><bean:message key="cifs.shareAccessLog.allsmbcmd"/></td>
                <td align="center">
                	&nbsp;
	                <nested:notEmpty  property="successLoggingItems">
	                    <nested:iterate id="succ"  property="successLoggingItems">
	                        <logic:equal name="succ" value="COLLECTALL">
	                            <img src="/nsadmin/images/nation/check.gif"/>
	                    	</logic:equal>
                        </nested:iterate>
                    </nested:notEmpty>
	                &nbsp;
                </td>
                <td align="center">
                	&nbsp;
	                <nested:notEmpty  property="errorLoggingItems">
	                    <nested:iterate id="error" property="errorLoggingItems">
	                        <logic:equal  name="error"  value="COLLECTALL">
	                                <img src="/nsadmin/images/nation/check.gif">
	                        </logic:equal>
	                    </nested:iterate>
	                </nested:notEmpty>
	                &nbsp;
                </td>
                
            </tr>
        </table>
	 </logic:equal> 
	 <logic:notEqual name="shareAccessLogForm" property="logType" value="all">
	   <table border="1" class="Vertical">
		   <tr>
	    	<th align="center"><bean:message key="cifs.common.command"/></th>
	        <th align="center"><bean:message key="cifs.common.success"/></td>
	        <th align="center"><bean:message key="cifs.common.error"/></td>
	  	  </tr>
	       <logic:iterate name="shareLoggingItems" id="item">
            <tr>
	            <td><bean:message name="item" property="value"/></td>
	            <bean:define id="keyValue" name="item" property="key" type="String"/>
	            <td align="center">
	                &nbsp;
	                <nested:notEmpty  property="successLoggingItems">
	                    <nested:iterate id="succ"  property="successLoggingItems">
	                        <logic:equal name="succ" value="<%=keyValue%>">
	                            <img src="/nsadmin/images/nation/check.gif"/>
	                    	</logic:equal>
                        </nested:iterate>
                    </nested:notEmpty>
	                &nbsp;
	            </td>
	            <td align="center">
	                &nbsp;
	                <nested:notEmpty  property="errorLoggingItems">
	                    <nested:iterate id="error" property="errorLoggingItems">
	                        <logic:equal  name="error"  value="<%=keyValue%>">
	                                <img src="/nsadmin/images/nation/check.gif">
	                        </logic:equal>
	                    </nested:iterate>
	                </nested:notEmpty>
	                &nbsp;
	            </td>
            </tr>

        </logic:iterate>
	 </logic:notEqual> 
    
       
     
</table>
	</nested:equal> 
	<nested:notEqual  property="alogEnable" value="yes">
	</nested:notEqual> 	
</nested:equal>
<nested:notEqual property="shareExist" value="yes" >
 <table><tr><td style='width:100%;'> <bean:message key="cifs.common.shareNotExist"/></td></tr></table>
</nested:notEqual>

</nested:nest>
<br>
<br>
<center>
 <html:button property="close" onclick="onClose()">
        <bean:message key="common.button.close" bundle="common"/>
 </html:button>
 </center>
</html:form>
</body>
</html>