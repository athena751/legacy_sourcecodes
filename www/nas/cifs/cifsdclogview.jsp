<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsdclogview.jsp,v 1.3 2006/07/07 06:49:20 fengmh Exp $" -->

<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8"  buffer="128kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link rel="stylesheet" href="/nsadmin/skin/default/errorpage.css" type="text/css">
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
<bean:define id="pageCount" name="logviewForm" property="viewInfo.pageCount" type="java.lang.String"/>
<bean:define id="pageCountLength" value="<%=String.valueOf(pageCount.length())%>" type="java.lang.String"/>
<bean:define id="currentPage" name="logviewForm" property="viewInfo.currentPage" type="java.lang.String"/>

<logic:notEqual name="logviewForm" property="viewInfo.logContents" value="">
    var curPage = <%=currentPage%>;
	function onRefresh(){
		if (isSubmitted()){
    	    return false;
	    }
    	if(document.forms[0].elements["viewInfo.currentPage"]){
    	    document.forms[0].elements["viewInfo.currentPage"].value = 1;
	 	}
	 	document.forms[0].elements["viewInfo.logContents"].value="";
	 	document.forms[0].operation.value = "displayDCLog";
	 	setSubmitted();
	 	document.forms[0].submit();
	 	return true;
	}
	
	function onChgPage(){
	    if (isSubmitted()){
        	return false;
    	}
    	var page = trim(document.forms[0].elements["viewInfo.currentPage"].value);
	    if(!checkPage(page)){
            alert("<bean:message key="cifs.dclog.alert.invalidPage"/>");
            document.forms[0].elements["viewInfo.currentPage"].focus();
            return false;
        }
        page = parseInt(page, 10);
        document.forms[0].elements["viewInfo.currentPage"].value = page;
        return onSelectPage(page);
	}
	
	function onSelectPage(page) {
        if (isSubmitted()){
            return false;
        }   
        if(page == curPage){
            return false;
        }
        document.forms[0].elements["viewInfo.logContents"].value="";
        document.forms[0].operation.value = "redisplay";
        document.forms[0].elements["viewInfo.currentPage"].value = page;
        setSubmitted();
        document.forms[0].submit();
        return true;
	}
	
	function checkPage(targetPage){
        var invalidCharSet  = /[^0-9]/g;
	    if(targetPage == "" || targetPage.search(invalidCharSet) != -1){
            return false;
        }
        if(targetPage == 0 || parseInt(targetPage, 10) > <%=pageCount%>){
        	return false;
        }
        return true;
	}
	
</logic:notEqual>    
function checkEnterKey(){
    <logic:notEqual name="logviewForm" property="viewInfo.logContents" value="">
        if(document.forms[0].operation.value == ""){
            return false;
        }else{
            return true;
        }
    </logic:notEqual> 
}

function init(){
    <logic:notEmpty name="<%=CifsActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request">
        <bean:define id="errorMsg" name="<%=CifsActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request" type="java.lang.String" />
        alert("<bean:message key="<%=errorMsg%>" />");
        parent.close();
    </logic:notEmpty>
    <logic:empty name="<%=CifsActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request">
        <logic:notEqual name="logviewForm" property="viewInfo.logContents" value="">
            <logic:greaterThan name="logviewForm" property="viewInfo.pageCount" value="1">
        	 	if(<%=currentPage%> == 1){
        	 		document.forms[0].first.disabled = 1;
        	 		document.forms[0].previous.disabled = 1;	
        	 		return;
        	 	}
        	 	if(<%=currentPage%> == <%=pageCount%>){
        	 		document.forms[0].next.disabled = 1;
        	 		document.forms[0].last.disabled = 1;	
        	 		return;
        	 	}
           </logic:greaterThan>
        </logic:notEqual>
    </logic:empty>
}
</script>
</head>
<body onload="init();setHelpAnchor('network_cifs_16');" onUnload="setHelpAnchor('network_cifs_15');">
<logic:empty name="<%=CifsActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request">
<html:form action="cifsDCLog.do" method="post" onsubmit="return checkEnterKey();">
<h1 class="title"><bean:message key="cifs.common.h1"/></h1>
<h2 class="title"><bean:message key="cifs.dclog.h2"/></h2>

<logic:equal name="logviewForm" property="viewInfo.logContents" value="">
    <bean:define id="domainName" name="<%=CifsActionConst.SESSION_DOMAIN_NAME%>" scope="session" type="java.lang.String"/>
    <bean:message key="cifs.dclog.msg.fileSize_zero" arg0="<%=domainName%>"/>
	<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
	<input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()"/>
</logic:equal>

<logic:notEqual name="logviewForm" property="viewInfo.logContents" value="">
	<html:hidden  property="viewInfo.pageCount"/>
	<table width="100%">
		<tr><td>
			<table border="0" table width="100%" align="right">
				<tr>
				<td>
        				<html:button property="refresh" onclick="onRefresh()">
        					  <bean:message key="common.button.reload" bundle="common"/>
        				</html:button>
				</tr>
			</table>
	      </td></tr>
		  <tr><td>
			<table border="1" class="Vertical" width="85%">
			</table>
		</td></tr>
		<tr><td>
			<table width="100%"  border="0">
				<tr><td colspan="0"> 
				<html:textarea property="viewInfo.logContents" readonly="true" style='width:100%;' rows="25">
				</html:textarea>			
				</td></tr>
			</table>
		</td></tr>
		<tr><td><table width="100%" align="right">
			<tr>
			<td>
			<table>
		            <logic:greaterThan name="logviewForm" property="viewInfo.pageCount" value="1">
				<td><html:button property="first" onclick="onSelectPage(1)">
		    			<bean:message key="cifs.dclog.button_first"/>
					</html:button>
				</td>
				<td><html:button property="previous" onclick="onSelectPage(curPage-1)">
		    			<bean:message key="cifs.dclog.button_previous"/>
					</html:button>
				</td>
				<td><html:button property="next" onclick="onSelectPage(curPage+1)">
		    			<bean:message key="cifs.dclog.button_next"/>
					</html:button>
				</td>
				<td><html:button property="last" onclick="onSelectPage(document.forms[0].elements['viewInfo.pageCount'].value)">
		    			<bean:message key="cifs.dclog.button_last"/>
					</html:button>
				</td>
				<td>&nbsp;
				    <%String spaces="";%>
				    <logic:equal name="pageCountLength" value="1">
				        <%spaces="&nbsp;&nbsp;&nbsp;";%>
				     </logic:equal>
				     <logic:equal name="pageCountLength" value="2">
				        <%spaces="&nbsp;&nbsp;";%>
				     </logic:equal>
				     <logic:equal name="pageCountLength" value="3">
				        <%spaces="&nbsp;";%>
				     </logic:equal>
				    <html:text property="viewInfo.currentPage" size="<%=pageCountLength%>"
				     maxlength="<%=pageCountLength%>"/>/<%=spaces+pageCount%><bean:message key="cifs.dclog.td_page"/>
				</td>
				<td><html:button property="selectPage" onclick="onChgPage()">
		    			<bean:message key="cifs.dclog.button_selectpage"/>
					</html:button>
				</td>
			   </logic:greaterThan>
			    <logic:equal name="logviewForm" property="viewInfo.pageCount" value="1">
				<td><html:button property="first" disabled="true">
		    			<bean:message key="cifs.dclog.button_first"/>
					</html:button>
				</td>
				<td><html:button property="previous" disabled="true">
		    			<bean:message key="cifs.dclog.button_previous"/>
					</html:button>
				</td>
				<td><html:button property="next" disabled="true">
		    			<bean:message key="cifs.dclog.button_next"/>
					</html:button>
				</td>
				<td><html:button property="last" disabled="true">
		    			<bean:message key="cifs.dclog.button_last"/>
					</html:button>
				</td>
				<td>&nbsp;
				    <%String spaces="";%>
				    <logic:equal name="pageCountLength" value="1">
				        <%spaces="&nbsp;&nbsp;&nbsp;";%>
				     </logic:equal>
				     <logic:equal name="pageCountLength" value="2">
				        <%spaces="&nbsp;&nbsp;";%>
				     </logic:equal>
				     <logic:equal name="pageCountLength" value="3">
				        <%spaces="&nbsp;";%>
				     </logic:equal>
				    <html:text property="viewInfo.currentPage" size="<%=pageCountLength%>"
				     maxlength="<%=pageCountLength%>"/>/<%=spaces+pageCount%><bean:message key="cifs.dclog.td_page"/>
				</td>
				<td><html:button property="selectPage" disabled="true">
		    			<bean:message key="cifs.dclog.button_selectpage"/>
					</html:button>
				</td>
			   </logic:equal>
				
			</table>
			</td>
			<td>
			<input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="parent.close()"/>
			</td>
			</tr>
		</table>
		</td></tr>
	</table>
	<input type="hidden" name="operation" value=""/>
</logic:notEqual>

</html:form>
</logic:empty>
</body>
</html>