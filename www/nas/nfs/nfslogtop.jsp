<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfslogtop.jsp,v 1.5 2008/09/25 01:52:16 penghe Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.nec.nsgui.model.entity.nfs.*"%>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript">
var loaded=0;

var orgAccessFilePath = '' ;
var orgAccessUnit = '';
var accesslog_win = '<%=NFSConstant.NFS_ACCESSLOG_WIN%>';
var navigatorWin = new Array();
function init(){
    loaded=1;
    <logic:equal name="failedGetLogInfo" value="true">
        alert('<bean:message key="nfslog.alert.failed.get.loginfo"/>');
    </logic:equal>
    orgAccessFilePath = document.forms[0].elements["accessLogInfo.fileName"].value ;
    orgAccessUnit = document.forms[0].elements["accessLogInfo.fileSizeUnit"].value ;
    if(orgAccessFilePath =='<%=NFSConstant.NFS_DEFAULT_ACCESSLOG_FILE_PATH%>' ||
        orgAccessFilePath == ''){
        document.forms[0].accessFilePath[0].checked = true;
        document.forms[0].elements["accessLogInfo.userAuth"].checked = false;            
    }else{
        document.forms[0].accessFullFileName.value = document.forms[0].elements["accessLogInfo.fileName"].value;
        document.forms[0].accessFilePath[1].checked = true;
    }
    changeAccessTextStatus();

    if(parent.frames[1] && parent.frames[1].loaded==1) {
        parent.frames[1].document.forms[0].set.disabled=false;
    }
}

function isValidDirectory(str){
    if(str == ""){
        return false;
    }
    if(str.charAt(0) != '/'){
        return false;
    }
    var avail=/[^A-Za-z0-9\!\#\$\%\&\'\(\)\+\-\.\/\=\@\^\_\`\~]/g;
    var ifFind = str.search(avail);
    if(ifFind !=-1){
        return false;
    }
    if(str.length > 254){
        return false;
    }
    return true;
}

function onLogSet(){
    if (isSubmitted()){
        return false;
    }
    if(document.forms[0].accessFilePath[0].checked == true){
        document.forms[0].elements["accessLogInfo.fileName"].value = document.forms[0].accessFilePath[0].value;
    }else{
        document.forms[0].elements["accessLogInfo.fileName"].value = getRealPath(document.forms[0].accessFullFileName.value);
        document.forms[0].accessFullFileName.value = document.forms[0].elements["accessLogInfo.fileName"].value;
    }
    if(document.forms[0].elements["accessLogInfo.fileName"].value == '<%=NFSConstant.NFS_ACCESSLOG_CONF_FILE_PATH%>'){
        alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
            '<bean:message key="nfslog.alert.invalid.access.log.file"/>');
        document.forms[0].accessFullFileName.select();
        return false;
    }
    if(!isValidDirectory(document.forms[0].elements["accessLogInfo.fileName"].value)){
        alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
            '<bean:message key="nfslog.invalid.accesslog.dir.start"/>' +
            '<%=NFSConstant.NFS_VALID_FILE_NAME_CHAR%>' +
            '<bean:message key="nfslog.invalid.accesslog.dir.end"/>'
        );
        document.forms[0].accessFullFileName.select();
        return false;
    }
    if(!isValidDigit(document.forms[0].elements["accessLogInfo.fileSize"].value, 1, 2000)){
        alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
            '<bean:message key="nfslog.invalid.accesslog.size.number"/>');
        document.forms[0].elements["accessLogInfo.fileSize"].select();
        return false;
    }
    document.forms[0].elements["accessLogInfo.fileSize"].value = 
    parseInt(document.forms[0].elements["accessLogInfo.fileSize"].value, 10);
    if(!isValidDigit(document.forms[0].elements["accessLogInfo.generationNum"].value, 1, 10)){
        alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
            '<bean:message key="nfslog.invalid.accesslog.generation.number"/>');
        document.forms[0].elements["accessLogInfo.generationNum"].select();
        return false;
    }
    document.forms[0].elements["accessLogInfo.generationNum"].value = 
    parseInt(document.forms[0].elements["accessLogInfo.generationNum"].value, 10);
   
    var orgAccessUnitCount = (orgAccessUnit == 'M')?1024:1;
    var nowAccessUnitCount = (document.forms[0].elements["accessLogInfo.fileSizeUnit"].value == 'M')?1024:1;
    
    if(document.forms[0].accessFilePath[0].checked == true){
        if(parseInt(document.forms[0].elements["accessLogInfo.fileSize"].value, 10)*nowAccessUnitCount > 1024*10) {
            alert('<bean:message key="nfslog.alert.type.accesslog"/>' + '\r\n' +
                '<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n' +
                '<bean:message key="nfslog.alert.size.over.limit"/>');
            document.forms[0].elements["accessLogInfo.fileSize"].select();
            return false;
        }
    }
            
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
        '<bean:message key="common.confirm.action" bundle="common"/>'+
        '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    if(!(parseInt(document.forms[0].elements["accessLogInfo.fileSize"].value, 10)*nowAccessUnitCount <=
         '<bean:write name="NfsLogForm" property="accessLogInfo.fileSize" />'*orgAccessUnitCount)){
        if(!confirm('<bean:message key="nfslog.alert.type.accesslog"/>' + '\r\n' +
            '<bean:message key="nfslog.confirm.bigger.file.size"/>')){
            document.forms[0].elements["accessLogInfo.fileSize"].select();
            return false;
        }
    }
    if(!(parseInt(document.forms[0].elements["accessLogInfo.generationNum"].value, 10) <=
         '<bean:write name="NfsLogForm" property="accessLogInfo.generationNum" />')){
        if(!confirm('<bean:message key="nfslog.alert.type.accesslog"/>' + '\r\n' +
            '<bean:message key="nfslog.confirm.bigger.generation.number"/>')){
            document.forms[0].elements["accessLogInfo.generationNum"].select();
            return false;
        };
    }

    setSubmitted();
    document.forms[0].submit();
    return true;
}
function changeAccessTextStatus(){
    if(document.forms[0].accessFilePath[0].checked == true){
        document.forms[0].accessFullFileName.disabled = true;
        document.forms[0].accessBrowse.disabled = true;
        document.forms[0].elements["accessLogInfo.userAuth"].disabled = true;
    }else{
        document.forms[0].accessFullFileName.disabled = false;
        document.forms[0].accessBrowse.disabled = false;
        document.forms[0].elements["accessLogInfo.userAuth"].disabled = false;
    }
}

function popupNavigator(value, type) {
    if (isSubmitted()){
        return false;
    }
    if(value == ''){
        document.forms[1].nowDirectory.value = document.forms[1].rootDirectory.value;
    }else{
        document.forms[1].nowDirectory.value = value;
    }
    if(navigatorWin[type] == null || navigatorWin[type].closed){
        navigatorWin[type] = window.open("/nsadmin/common/commonblank.html", type, "resizable=yes,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=460,height=400");
        document.forms[1].target = type;
        document.forms[1].type.value = type;
        document.forms[1].submit();
    }else{
        navigatorWin[type].focus();
    }
    return true;
}

function closePopupWin(){
    if (navigatorWin[accesslog_win] != null
        && !navigatorWin[accesslog_win].closed){
        if(navigatorWin[accesslog_win].window.frames[0].document.body.onunload){
            navigatorWin[accesslog_win].window.frames[0].document.body.onunload="";
        }else{
            navigatorWin[accesslog_win].window.frames[0].onunload="";
        }
        navigatorWin[accesslog_win].close();
    }
}

function reloadPage(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="<html:rewrite page='/nfsLog.do?operation=display'/>";
}
</script>
</head>
<body onload="displayAlert();init();setHelpAnchor('network_nfs_6');" onUnload="closePopupWin();closeDetailErrorWin();">
<displayerror:error h1_key="title.nfs"/>
<html:form action="nfsLog.do?operation=set" method="POST">
<input type="button" name="refresh" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="reloadPage()"/>
<h3 class="title"><bean:message key="nfslog.h3.access.set"/></h3>
    <html:hidden property="accessLogInfo.fileName"/>
    <table border=1>
        <tbody>
        <tr>
           <th align="left">
                <bean:message key="nfslog.th.logfile.name"/>    
           </th>
           <td>
                <input type="radio" name="accessFilePath" value="<%=NFSConstant.NFS_DEFAULT_ACCESSLOG_FILE_PATH%>" id="accessFilePath1" onclick="changeAccessTextStatus()" checked/>
                <label for="accessFilePath1">
                    <bean:message key="nfslog.text.defult.set" /><br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="nfslog.default.accesslog.file.path" /><br/>
                </label>
                <input type="radio" name="accessFilePath" value="" id="accessFilePath2" onclick="changeAccessTextStatus()" />
                <label for="accessFilePath2">
                    <bean:message key="nfslog.text.user.set.dir" />
                </label>
                <br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="accessFullFileName" value="" size="40" maxlength="254"/>
                <html:button property="accessBrowse" onclick="return popupNavigator(document.forms[0].accessFullFileName.value,accesslog_win);">
                    <bean:message key="common.button.browse2" bundle="common"/>
                </html:button>
                <br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<html:checkbox property="accessLogInfo.userAuth" styleId="accessUserAuth" value="yes"/>
                <label for="accessUserAuth">
                    <bean:message key="nfslog.checkbox.secure"/><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[<font class="advice"><bean:message key="nfslog.checkbox.secure2"/></font>]
                </label>
            </td>
        </tr>
        <tr>
            <th align="left">
                <bean:message key="nfslog.th.rotation.size"/>             
            </th>
            <td>
                <html:text property="accessLogInfo.fileSize" size="4" maxlength="4"/>
                <html:select property="accessLogInfo.fileSizeUnit">
                    <html:option value="<%=NFSConstant.NFS_LOG_FILE_SIZE_MB%>">
                        <bean:message key="nfslog.option.size.mb"/>
                    </html:option>
                    <html:option value="<%=NFSConstant.NFS_LOG_FILE_SIZE_KB%>">
                        <bean:message key="nfslog.option.size.kb"/>
                    </html:option>
                </html:select>
            </td>
        </tr>
        <tr>
            <th align="left">
                <bean:message key="nfslog.th.generations"/>             
            </th>
            <td>
                <html:text property="accessLogInfo.generationNum" size="2" maxlength="2"/>
            </td>
        </tr>
        </tbody>
    </table>
</html:form>
<html:form action="NfsLogNavigatorList.do">
    <html:hidden property="operation" value="callLog"/>
    <html:hidden property="rootDirectory" value="/export"/> 
    <html:hidden property="nowDirectory" value=""/>  
    <html:hidden property="type" value=""/>
</html:form>

</body>
</html>