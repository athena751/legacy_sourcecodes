<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: logview.jsp,v 1.19 2008/09/23 09:59:13 penghe Exp $" -->

<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.model.entity.syslog.*" %>

<%@ page contentType="text/html;charset=UTF-8"  buffer="128kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<html>
<head>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
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
	 	if(document.forms[0].needAutoDownload.value != "true"){
	 	    //click the [Reload]
	 	    document.forms[0].elements["viewInfo.logContents"].value="";
	 	}
	 	document.forms[0].operation.value = "display";
	 	setSubmitted();
	 	document.forms[0].submit();
	 	return true;
	}
	function alertForNoTmpFile(){
		alert('<bean:message key="syslog.logview.notempfile"/>');
	}
	function onChgPage(){
	    if (isSubmitted()){
        	return false;
    	}
    	var page = trim(document.forms[0].elements["viewInfo.currentPage"].value);
	    if(!checkPage(page)){
            alert("<bean:message key="syslog.logview.alert.invalidPage"/>");
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
        <logic:notEqual name="<%=SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION%>"
        			     property="commonInfo.logType" value="<%=SyslogActionConst.LOG_TYPE_SYSTEM_LOG%>">
            <bean:define id="displayEncoding" name="logviewForm" property="viewInfo.displayEncoding" type="java.lang.String"/>
            document.forms[0].elements["viewInfo.displayEncoding"].value = "<%=displayEncoding%>";
        </logic:notEqual>
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
    <logic:notEmpty name="<%=SyslogActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request">
        <bean:define id="errorMsg" name="<%=SyslogActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request" type="java.lang.String" />
        alert("<bean:message key="<%=errorMsg%>"/>");
        window.parent.opener.parent.bottomframe.closePopupWin();
    </logic:notEmpty>
    
    <%SyslogSearchConditions condition = (SyslogSearchConditions)request.getSession().getAttribute(SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION);%>
    <%String logType = (String)condition.getCommonInfo().getLogType();%>
    <%String encoding = (String)condition.getCommonInfo().getDisplayEncoding();%>
    
    <logic:empty name="<%=SyslogActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request">
        window.parent.opener.parent.bottomframe.closeHearbeatWin();
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

function onDownloadButton(){
	
    window.parent.downloadframe.window.location="/nsadmin/nas/logview/logdownload.jsp?logType=<%=logType%>&from=logview";
}
</script>
</head>
<body onload="init()">
<logic:empty name="<%=SyslogActionConst.REQUEST_LOGVIEW_ERRORTYPE%>" scope="request">
<html:form action="logview.do" method="post" onsubmit="return checkEnterKey();">
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
<bean:define id="h2_Value" name="<%=SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION%>" property="commonInfo.logName" type="java.lang.String"/>
<h2 class="title"><%=NSActionUtil.sanitize(h2_Value)%></h2>
<logic:equal name="logviewForm" property="viewInfo.logContents" value="">
	<logic:notEqual name="<%=SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION%>"
        			     property="commonInfo.searchAction" value="<%=SyslogActionConst.SEARCCH_ACTION_DISPLAY_ALL%>">
        <bean:message key="syslog.logview.msg.resultnull"/>
    </logic:notEqual>
	<logic:equal name="<%=SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION%>"
        			     property="commonInfo.searchAction" value="<%=SyslogActionConst.SEARCCH_ACTION_DISPLAY_ALL%>">
        <bean:message key="syslog.logview.msg.fileSize_zero"/>
    </logic:equal>
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
        				<logic:notEqual name="<%=SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION%>"
        				     property="commonInfo.logType" value="<%=SyslogActionConst.LOG_TYPE_SYSTEM_LOG%>">
        					<table border="1">
        						<tr>
        							<td><html:button property="refresh" onclick="onRefresh()">
        								    <bean:message key="syslog.logview.button_refresh"/>
        								</html:button >
        							</td>
        							<td><bean:message key="syslog.logview.td_encoding"/>
        								<html:select property="viewInfo.displayEncoding">   
                    						<html:optionsCollection name="displayEncodingSet" />
        								</html:select> 
        							</td>
        						</tr>
        					</table>
        				</logic:notEqual>
        				<logic:equal name="<%=SyslogActionConst.SESSION_LOGVIEW_SEARCHCONDTION%>"
        				     property="commonInfo.logType" value="<%=SyslogActionConst.LOG_TYPE_SYSTEM_LOG%>">
        					    <html:button property="refresh" onclick="onRefresh()">
        						    <bean:message key="syslog.logview.button_refresh"/>
        						</html:button >
        				</logic:equal>
				</td>
				<td align="right">
        		  <input type="button" value="<bean:message key="syslog.logview.button_download"/>" onclick="onDownloadButton();">
				</td>
				</tr>
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
		    			<bean:message key="syslog.logview.button_first"/>
					</html:button>
				</td>
				<td><html:button property="previous" onclick="onSelectPage(curPage-1)">
		    			<bean:message key="syslog.logview.button_previous"/>
					</html:button>
				</td>
				<td><html:button property="next" onclick="onSelectPage(curPage+1)">
		    			<bean:message key="syslog.logview.button_next"/>
					</html:button>
				</td>
				<td><html:button property="last" onclick="onSelectPage(document.forms[0].elements['viewInfo.pageCount'].value)">
		    			<bean:message key="syslog.logview.button_last"/>
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
				     maxlength="<%=pageCountLength%>"/>/<%=spaces+pageCount%><bean:message key="syslog.logview.td_page"/>
				</td>
				<td><html:button property="selectPage" onclick="onChgPage()">
		    			<bean:message key="syslog.logview.button_selectpage"/>
					</html:button>
				</td>
			   </logic:greaterThan>
			    <logic:equal name="logviewForm" property="viewInfo.pageCount" value="1">
				<td><html:button property="first" disabled="true">
		    			<bean:message key="syslog.logview.button_first"/>
					</html:button>
				</td>
				<td><html:button property="previous" disabled="true">
		    			<bean:message key="syslog.logview.button_previous"/>
					</html:button>
				</td>
				<td><html:button property="next" disabled="true">
		    			<bean:message key="syslog.logview.button_next"/>
					</html:button>
				</td>
				<td><html:button property="last" disabled="true">
		    			<bean:message key="syslog.logview.button_last"/>
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
				     maxlength="<%=pageCountLength%>"/>/<%=spaces+pageCount%><bean:message key="syslog.logview.td_page"/>
				</td>
				<td><html:button property="selectPage" disabled="true">
		    			<bean:message key="syslog.logview.button_selectpage"/>
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
	<input type="hidden" name="needAutoDownload" value="" >
</logic:notEqual>

</html:form>
</logic:empty>
</body>
</html>