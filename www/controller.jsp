<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: controller.jsp,v 1.22 2007/08/23 04:58:47 liul Exp $" -->
<%@ page import="com.nec.nsgui.action.base.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<script language="JavaScript" src="../common/common.js"></script>
<%
    String targetExpgrp = (String)request.getAttribute("targetExpgrp");
%>
<script language="JavaScript">
var first = 1;

function init() {
    first = 1;
    setControlStatus();
    var curForm = parent.MENU.curForm;
    if (parent.MENU && !parent.MENU.hasLoad){
    	parent.MENU.location = "/nsadmin/framework/menuDisplay.do?operation=display";
    }
    if(curForm != null){
        if(document.forms[0].operation.value == 'changeNode'){
            selectModule(curForm.name);
        }else if(document.forms[0].operation.value == 'selectExpgrp'){
            <logic:present name="targetExpgrp">
                alert('<bean:message key="error.expgrp.not.exist" arg0='<%=targetExpgrp%>'/>');
            </logic:present>
            <logic:notPresent name="maintainActionFrame">
                selectModule(curForm.name);
            </logic:notPresent>
        }else if(document.forms[0].operation.value == 'refresh'){
            //do nothing.
        }
    }
}

function help(){
    var curForm = parent.MENU.curForm;
    var anchor = "/help.html#initialize";
    if(curForm != null){
        anchor = curForm.helpAnchor.value;  
    }
    WO = window.open(
        '../help/<%=NSActionUtil.getCurrentLang(request)%>'+anchor, "HELP",
        "width=800,height=640,resizable=yes,scrollbars=yes");
    WO.focus();
}

function logout(){
    if (first == 1) {
        if (confirm("<bean:message key="submit.confirm.logout"/>")){
            first = 0;
            parent.TITLE.window.logout = 1;
            parent.location.href='/nsadmin/framework/logout.do?href=/nsadmin/framework/loginShow.do';
        }
    }
}
function onDisplaySiteMap(){
    parent.ACTION.location = 'menuDisplay.do?operation=siteMapDisplay';
    parent.MENU.window.curForm = null;
    setControlStatus();
}
function restoreDefault() {
   var found = 0;
   for (var i = 0; i < document.forms[0].exportGroup.length; i++) {
      if (document.forms[0].exportGroup.options[i].defaultSelected == true) {
         document.forms[0].exportGroup.options[i].selected=true
         found = 1;
      }
   }
   if(!found){
      document.forms[0].exportGroup.options[0].selected=true;
   }
}
function onChangeExpgrp(){
    if(isSubmitted()){
        return false;
    }
    if(confirm('<bean:message key="submit.confirm.selectExpgrp" />')){
        setSubmitted();  
        onSelectExpgrp(); 
    }else{
        restoreDefault();
    }
    window.focus();//blur from the selectbox
}

function onSelectExpgrp(){
    document.forms[0].operation.value = "selectExpgrp";
   document.forms[0].submit();
}

function onChangeNode(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].operation.value = "changeNode";
    document.forms[0].submit();
}
</script>
</head>
<body background="../images/nation/bk_head0.gif" leftmargin="0" topmargin="0" marginwidth="0"
 marginheight="0" onLoad="init()">
<html:form method="POST" action="control.do" >
<table>
    <tr>
        <td width='225'>
            <a href="#" onClick="logout(0); return false;">
                <html:img src="../images/nation/btn_logout.gif" border="0" /></a>
            <a href="#" onClick="help();return false;">
                <html:img src="../images/nation/btn_help.gif" border="0" /></a>
            <a href="#" onClick="if(isMenuLocked()){return false;};onDisplaySiteMap();return false">
                <html:img src="../images/nation/btn_allmenu.gif" border="0" /></a>
        </td>
        <td>
            <html:hidden property="operation"/>
            <html:hidden property="machineType"/>
            <html:hidden property="nodeInfo.group"/>
            <html:hidden property="nodeInfo.adminTarget"/>
            <html:hidden property="nodeInfo.target"/>
            <html:hidden property="nodeInfo.nodeId"/>
            <table bgcolor=#FFFFFF bordercolor="#000080" border="1" cellpadding="1" cellspacing="0">
                <tr>
                    <nested:equal property="nodeInfo.group" value="0">
                         <th bgcolor=#B0C4DE nowrap  style="font-size: 10pt;  height: 26"><bean:message key="control.display.current.nodeid"/></th>
                    </nested:equal>
                    <nested:notEqual property="nodeInfo.group" value="0">
                         <th bgcolor=#FFA07A nowrap  style="font-size: 10pt;  height: 26"><bean:message key="control.display.current.nodeid"/></th>
                    </nested:notEqual>
                    <nested:equal property="nodeInfo.nodeId" value="">
                        <td nowrap  style="font-size: 10pt;  height: 26">
                        &nbsp;&nbsp;<bean:message key="control.display.nosuch.node" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    </nested:equal>
                    <nested:notEqual property="nodeInfo.nodeId" value="">
                        <td align="center" title="<nested:write property="nodeInfo.nodeId" />" nowrap  
                          style=" width:170 ; font-size:10pt ; height: 26; font-family: monospace">
                        <script>
                        var nodeId = '<nested:write property="nodeInfo.nodeId" />';
                          if(nodeId.length > 10){
                            nodeId='('+nodeId.substring(0,10)+'...'+')';
                          }else{
                            nodeId='('+nodeId+')';
                          }
                          nodeId = '<bean:message key="control.display.node"/>'
                                + '<nested:write property="nodeInfo.group" />'
                                + nodeId;
                          document.write(nodeId);
                        </script>
                        </td>
                    </nested:notEqual>
                    <nested:notEqual property="machineType" value="Single">
                        <nested:notEqual property="machineType" value="NasheadSingle">
	                        <td>
	                        <html:submit property="changeNode" onclick="onChangeNode()" style="font-size:10pt; height:22" >
	                            <bean:message key="control.button.changenode"/>
	                        </html:submit>
	                        </td>
	                    </nested:notEqual>
                    </nested:notEqual>
                        </tr>
                    </table> 
                </td>
                <nested:equal property="machineType" value="Single">
                    <td width="30"></td>
                </nested:equal>    
                <nested:equal property="machineType" value="NasheadSingle">
                    <td width="30"></td>
                </nested:equal>       
            <td>
            <table bgcolor=#FFFFFF bordercolor="#000080" border="1" cellpadding="1" cellspacing="0">
                <tr>
                    <th bgcolor=#B0C4DE nowrap  style="font-size: 10pt;  height: 26"><bean:message key="control.display.current.expgrp"/></th>
                    <td>
                        <html:select property="exportGroup" disabled="true" onchange="return onChangeExpgrp()"
                            style="width: 145; font-size:10pt ; font-family: monospace" >
                        <logic:notEmpty name="exportGroupList">
                            <html:options name="exportGroupList"/>
                        </logic:notEmpty>
                        <logic:empty name="exportGroupList">
                            <html:option value="">-----</html:option>
                        </logic:empty>
                        </html:select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>  
</html:form>  
</body>
</html>