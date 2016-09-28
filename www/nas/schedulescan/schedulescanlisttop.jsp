<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: schedulescanlisttop.jsp,v 1.2 2008/05/14 08:36:31 hanh Exp $" -->

<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.ListSTModel"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.base.NSActionConst"%>
<%@ page import="com.nec.nsgui.action.schedulescan.ScheduleScanActionConst"%>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-logic" prefix="logic"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab"%>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onReload(){
    if (!setSubmit()){
        return false;
    }    

    <logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
        value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
        if(window.parent.frames[1]&&window.parent.frames[1].document.forms[0]){
            window.parent.frames[1].document.forms[0].settingDelete.disabled=true;
        }else{
            return false;
        }
    </logic:equal>
    document.forms[0].action = "scheduleScanListOperation.do?operation=display";  
    document.forms[0].submit();
    return true;
}

function setSubmit(){
    if (isSubmitted()){
        return false;
    }else{
        if(document.forms[0]){
            setSubmitted();
            return true;
        }else{
            return false;
        }
    }
}

function init(){
    setHelpAnchor('nvavs_schedulescan_1');
<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
        value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
    document.forms[0].deleteConfirm.value="no";
    <logic:equal name="<%=ScheduleScanActionConst.SESSION_SCHEDULESCAN_HAVE_CONNECTION%>" 
            value="<%=ScheduleScanActionConst.CONST_SCHEDULESCAN_YES%>" scope="session">
        <%NSActionUtil.setSessionAttribute(request,ScheduleScanActionConst.SESSION_SCHEDULESCAN_HAVE_CONNECTION,
            null);%>
        if(confirm('<bean:message key="schedulescan.alert.connection.delete"/>')){
           document.forms[0].deleteConfirm.value="yes";
           onDelete();
           return true;
        }
    </logic:equal>
    displayAlert();    
    enableDelButton();   
    return true;
</logic:equal>    
}

<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
        value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
        
var buttonEnable=0;       
function enableDelButton(){
<logic:notEmpty name="<%=ScheduleScanActionConst.SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME%>" scope="session">
    buttonEnable = 1;
</logic:notEmpty>
    if(window.parent.frames[1].document) {
        if(window.parent.frames[1].document.forms[0]) {
            window.parent.frames[1].changeButtonStatus();
        }
    }
}
        
function setDelete(){
     if(isSubmitted()){
         return false;
     }
     if (!document.forms[0]){
         return false;
     }
     if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
          '<bean:message key="common.button.delete" bundle="common"/>')){
        return false;
    }
     return true;
}

function onDelete(){
    if(setSubmit()){
        document.forms[0].action="scheduleScanListOperation.do?operation=delete";
        document.forms[0].target="_parent";
        document.forms[0].submit();
        buttonEnable = 0;
	    if(window.parent.frames[1].document) {
	        if(window.parent.frames[1].document.forms[0]) {
	            window.parent.frames[1].changeButtonStatus();
	        }
	    }
    }
}

</logic:equal>

</script>
</head>
<body onload="init();" onUnload="closeDetailErrorWin();">
<button name="reload" onclick="onReload()">
    <bean:message key="common.button.reload" bundle="common" />
</button>
<displayerror:error h1_key="schedulescan.common.h1"/>
<logic:empty name="<%=ScheduleScanActionConst.SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME%>" scope="session">
    <br><br><bean:message key="schedulescan.message.computernoset" /> 
</logic:empty>
<form action="scheduleScanListOperation.do?operation=display" method="post">
<logic:notEmpty name="<%=ScheduleScanActionConst.SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME%>" scope="session">
    <h3><bean:message key="schedulescan.h3.computername" /></h3>
        <table border="1" class="Vertical" nowrap>
            <tr>
                <th valign="top"><bean:message key="schedulescan.th.antivirus.computer" /></th>
                <td>
                <bean:write name="<%=ScheduleScanActionConst.SESSION_SCHEDULESCAN_VIRTUAL_COMPUTERNAME%>" scope="session"/>
                </td>
            </tr>
        </table>
    <h3><bean:message key="schedulescan.h3.scanserver" /></h3>
<logic:equal name="noScanServer" value="yes" scope="request">
    <bean:message key="schedulescan.message.scanservernoset" />
    <h3><bean:message key="schedulescan.h3.scanshare" /></h3>
	        <bean:message key="schedulescan.message.scansharenoset" />
</logic:equal>
<logic:notEqual name="noScanServer" value="yes" scope="request">
        <table border="1" class="Vertical" nowrap>
            <tr>
                <th valign="top"><bean:message key="schedulescan.th.scanserver" /></th>
                <td>
                <table frame="void" rules="all" width="100%" border="1">
                    <logic:iterate id="element" name="scanServers" scope="request">
                        <tr><td><bean:write name="element"/></td></tr>
                    </logic:iterate>
                </table>
                </td>
            </tr>
            <tr>
                <th valign="top"><bean:message key="schedulescan.th.interface" /></th>
                <td>
                <table frame="void" rules="all" width="100%" border="1">
                    <logic:iterate id="element" name="interfaceNames" scope="request">
                        <tr><td><bean:write name="element"/></td></tr>
                    </logic:iterate>
                </table>
                </td>
            </tr>
            <tr>
                <th valign="top"><bean:message key="schedulescan.th.scanuser" /></th>
                <td>
                <table frame="void" rules="all" width="100%" border="1">
                    <logic:iterate id="element" name="scanUsers" scope="request">
                        <tr><td><bean:write name="element" filter="false"/></td></tr>
                    </logic:iterate>
                </table>
                </td>
            </tr>
        </table>
	    <h3><bean:message key="schedulescan.h3.scanshare" /></h3>
	    <logic:empty name="scanShare">
	        <bean:message key="schedulescan.message.scansharenoset" />
	    </logic:empty>
	    <logic:notEmpty name="scanShare" >
	        <bean:define id="scanShare" name="scanShare"
	            type="java.util.ArrayList" />
	        <nssorttab:table
	            tablemodel="<%=new ListSTModel((ArrayList)scanShare)%>"
	            id="schedulescan_scanShare" table="border=\" 1\"" sortonload="shareName">
	            <nssorttab:column name="shareName"
	                th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
	                td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
	                <bean:message key="schedulescan.th.sharename" />
	            </nssorttab:column>
	            <nssorttab:column name="sharePath"
	                th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
	                td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="yes">
	                <bean:message key="schedulescan.th.sharedirectory" />
	            </nssorttab:column>
            </nssorttab:table>
        </logic:notEmpty>
    </logic:notEqual>
</logic:notEmpty>
<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
        value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
<input type="hidden" name="deleteConfirm" value="no"/>
</logic:equal>
</form>
</body>
</html>
