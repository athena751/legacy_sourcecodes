<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: csnavigatorlist.jsp,v 1.19 2008/12/26 05:46:49 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<%
String contextPath = request.getContextPath();
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>

<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript" src="../nas/cifs/cifscommon.js"></script>
<script language="JavaScript">
function chooseParentDir(str , rootStr) {
    if (parent.frames[1].document.forms[0]) {
	var tmpArray = new Array();
	var reg = /\//g;
	str = str.substring(1);
	
	tmpArray = str.split(reg);
	var parentDir = "/";
	for (var index=0 ; index<tmpArray.length - 2 ; index++) {
		parentDir = parentDir + tmpArray[index] + "/";
	}
	parentDir = parentDir + tmpArray[tmpArray.length-2];
	
	var displaySelectedDir = parentDir.substring(rootStr.length + 1);
	
	document.forms[0].nowDirectory.value = parentDir;
	
	parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedDir;
    }
	
}

function intoParentDir(str , rootStr) {
    if(isSubmitted()){
        return false;
    }
    if (parent.frames[1].document.forms[0]) {
	chooseParentDir(str ,rootStr);
	setSubmitted();
	document.forms[0].submit();
    }
}

function chooseSubDir(displaySelectedPath , wholePath) {
    if (parent.frames[1].document.forms[0]) {
	document.forms[0].nowDirectory.value = wholePath;
	parent.frames[1].document.forms[0].displayedDirectory.value = displaySelectedPath;
    }
}

function intoSubDir(displaySelectedPath , wholePath) {
    if(isSubmitted()){
        return false;
    }
    if (parent.frames[1].document.forms[0]) {
	chooseSubDir(displaySelectedPath , wholePath);
	setSubmitted();
	document.forms[0].submit();
    }
}

//added by chenbc, 2008/02/22
var currentDirectory = "";
function init(){
    lockSubmitBtn(false);
    if(document.forms[0]){
        currentDirectory = document.forms[0].nowDirectory.value;
    }
    <logic:equal name="cifs_canBeModified" value="yes">
        <logic:equal name="cifs_parentHasACL" value="yes">
             var makeButton = document.getElementById("makeDir");
             if(makeButton){
                makeButton.disabled = false;
             }
        </logic:equal>
    </logic:equal>
    if(parent && parent.frames[1] && parent.frames[1].document.forms[0]){
        parent.frames[1].document.forms[0].displayedDirectory.readOnly = false;
        <logic:equal name="deleteSuccess" value="yes">
            var dirName = parent.frames[1].document.forms[0].displayedDirectory.value;
            dirName = dirName.replace(/\/+$/, "");
            var pos = dirName.lastIndexOf('/');
            if(pos != -1){
                dirName = dirName.substring(0, pos);
            }else{
                dirName = "";
            }
            parent.frames[1].document.forms[0].displayedDirectory.value = dirName;
         </logic:equal>
     }
    
    displayAlert();
    <logic:equal name="directoryExists" value="yes">
        showLayerForRefill();
    </logic:equal>
    <logic:equal name="dirNameTooLong" value="yes">
        showLayerForRefill();
    </logic:equal>
    <logic:notEmpty name="errorMessage" scope="request">
        alert('<bean:write name="errorMessage" filter="false"/>');
    </logic:notEmpty>
    
  //added for 0805 cifs limit
    <logic:equal name="nfcLengthOver144" value="yes">
        showLayerForRefill();
        popConfirm();
        //Since fucntion "popConfirm()" maybe submit a form, it is suggested that DO NOT add codes after here any more.
    </logic:equal>
  //
}

function showLayerForRefill(){
    var dirName = "";
    if(document.forms[0]){
        dirName = document.forms[0].directoryName.value;
        var pos = dirName.lastIndexOf('/');
        dirName = dirName.substr(pos + 1);
    }
    showLayer(dirName);
}
function showLayer(dirName){
    if(!dirName){
        dirName = "";
    }
    var layer = document.getElementById('dirNameLayer');
    if(layer){
        layer.style.display = 'inline';
    }
    var newDir = document.getElementById('newDir');
    if(newDir){
        newDir.value = dirName;
        newDir.focus();
    }
}
function closeLayer(){
    document.getElementById('dirNameLayer').style.display = 'none';
    lockSubmitBtn(false);
}
function lockSubmitBtn(disabled){
    if(parent && parent.frames[1]){
        var selectButton = parent.frames[1].document.getElementById("selectDir");
        if(selectButton){
            selectButton.disabled = disabled;
        }
        var deleteButton = parent.frames[1].document.getElementById("deleteDir");
        if(deleteButton){
            deleteButton.disabled = disabled;
        }
    }
}
function onMake(){
    var newDir = document.getElementById('newDir');
    if(newDir && document.forms[0]){
        if(isSubmitted()){
            return false;
        }
        
        var form = document.forms[0];
        var dirName = newDir.value;
        if(!checkEmptyDirectory(dirName)){
            alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n" + 
                  '<bean:message key="cifs.error.directory_make.dirNameEmpty.alert"/>')
            return false;
        }
        
        if(!checkSpaceAndDot(dirName)){
            alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n" + 
                  '<bean:message key="cifs.error.directory_make.trailingSpaceDot.alert"/>')
            return false;
        }
        if(!checkDirectory4Win(dirName)){
            alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n" + 
                  '<bean:message key="cifs.alert.directory_make.invalidDirectory"/>' + "\r\n" +
                  '<bean:message key="cifs.error.directory_make.invalidChar.alert"/>')
            return false;
        }
        if(!checkDOSResv(dirName) || !checkNVResv(dirName)){
            alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n" + 
                  '<bean:message key="cifs.error.directory_make.reservedName.alert"/>')
            return false;
        }
        if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.create" bundle="common"/>')){
            return false;
        }
        setSubmitted();
      // modified for 0805 cifs limit
        var nfcLength = utf8LengthByNFC(dirName);
        form.directoryName.value = currentDirectory + '/' + dirName;
        form.nowDirectory.value = currentDirectory;
        form.action = "CSNavigatorList.do?operation=makeDirectory&nfcLength=" + nfcLength.toString();
        form.submit();
    }
}
function onDelete(dirName){
    if(document.forms[0]){
        if(isSubmitted()){
            return false;
        }
        if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.delete" bundle="common"/>')){
            return false;
        }
        lockSubmitBtn(true);
        setSubmitted();
        if(parent && parent.frames[1] && parent.frames[1].document.forms[0]){
            parent.frames[1].document.forms[0].displayedDirectory.readOnly = true;
        }
        var form = document.forms[0];
        form.directoryName.value = dirName;
        form.nowDirectory.value = currentDirectory;
        form.action = "CSNavigatorList.do?operation=deleteDirectory";
        form.submit();
    }
}
var NVResv = {
                ".snap":true, ".psid_lt":true, ".sync":true, ".datasetinfo":true, ".quotainfo":true,
                ".quotainfo.dir":true
             };
var DOSResv = {
                  "aux" :true, "com1":true, "com2":true, "com3":true, "com4":true, "com5":true, 
                  "com6":true, "com7":true, "com8":true, "com9":true, "lpt1":true, "lpt2":true,
                  "lpt3":true, "lpt4":true, "lpt5":true, "lpt6":true, "lpt7":true, "lpt8":true,
                  "lpt9":true, "con" :true, "nul" :true, "prn":true
              };
function checkNVResv(displayedPath){
    var path = displayedPath.toLowerCase();
    if(NVResv[path]){
        return false;
    }
    var result = path.match(/^lost\+found(\d+)$/);
    if(result && result.length > 1){
        var digit = result[1];
        if(digit.length <= 5 && (digit == "0" || digit.charAt(0) != '0')){
            digit = parseInt(digit, 10);
            if(digit >= 0 && digit <= 65535){
                return false;
            }
        }
    }
    if(path.match(/^\.eainfo-.*/)){
        return false;
    }
    return true;
}

function checkDOSResv(displayedPath){
    var path = displayedPath.toLowerCase();
    var result = path.match(/^(.*?)\..*$/);
    if(result && result.length > 1){
        path = result[1];
    }
    if(DOSResv[path]){
        return false;
    }
    return true;
}

function checkSpaceAndDot(displayedPath){
    var path = displayedPath.toLowerCase();
    if(path.match(/[. ]$/)){
        return false;
    }
    return true;
}

function checkDirectory4Win(str){
    var invalidChar = /[\\:,;\*\?\"<>|\/]/g;
    return ( str.search(invalidChar) == -1);
}

function checkEmptyDirectory(str){
    return !str.match(/^[ ]*$/);
}
function popNotice(){
    alert('<bean:message key="cifs.navigator.directory_make.notice.alert"/>');
    return false;
}

//added for 0805 cifs limit
function popConfirm(){
    if(isSubmitted()){
        return false;
    }
    if(!confirm('<bean:message key="cifs.confirm.invalidLength.utf8nfc_over144"/>')){
        return false;
    }
    setSubmitted();
    var form = document.forms[0];
    form.action = "CSNavigatorList.do?operation=makeDirectory&nfcLength=0";
    form.submit();
}

</script>
</head>

<body onload="init();" onunload="closeDetailErrorWin();">
<h1 class="popup"><bean:message key="cifs.common.h1"/></h1>
<h2 class="popup"><bean:message key="title.navigator.h2"/></h2>

<displayerror:error h1_key="cifs.common.h1"/>


    <br/>
    <input type = "button" onclick = "showLayer();" id = "makeDir" disabled = "true"
         value = '<bean:message key="cifs.navigator.directory_make.button"/>'/>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <a href="#" onclick="return popNotice();">
        <u><bean:message key="cifs.navigator.directory_make.notice"/></u>
    </a>
    <br/><br/>
    <div id = "dirNameLayer" style = "display:none;">
        <table>
            <tr><td>
                <input type = "text" value = "" id = "newDir" onfocus="this.formerValue = this.value; lockSubmitBtn(true);" maxlength="240"/>
            </td></tr>
            <tr></tr>
            <tr><td>
                <input type = "button" value = '<bean:message key="common.button.create" bundle="common"/>' onclick = "onMake();"/>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input type = "button" value = '<bean:message key="cifs.navigator.directory_make.cancel"/>' onclick = "closeLayer();"/>
            </td></tr>
        </table><br/>
    </div>




<html:form action="CSNavigatorList.do?operation=listShare">

<bean:size id="dirSize" name="CIFSShareAllDirectoryInfo"/>

<bean:define id="nowDirTrue" name="CIFSNavigatorListForm" property="nowDirectory"/>
<bean:define id="rootDir" name="CIFSNavigatorListForm" property="rootDirectory"/>

<logic:equal name="dirSize" value="0">
	<logic:equal name="CIFSNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
		<bean:message key="msg.navigator.none"/>
	</logic:equal>
	
	<logic:notEqual name="CIFSNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
		<table>
		<tr>
		<th><bean:message key="info.navigator.th_status"/></th>
		<th><bean:message key="info.navigator.th_name"/></th>
		<th><bean:message key="info.navigator.th_date"/></th>
		<th><bean:message key="info.navigator.th_time"/></th>
		</tr>		
		
		<tr>
		<td><a href="#" onclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
			<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
		<td><a href="#" onclick='chooseParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'
		                ondblclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
			<bean:message key="info.navigator.parent_dir"/></a></td>	
		<td></td>
		<td></td>
		</tr>	
		</table>
	</logic:notEqual>
</logic:equal>


<logic:notEqual name="dirSize" value="0">	
	<table>
		<tr>
		<th><bean:message key="info.navigator.th_status"/></th>
		<th><bean:message key="info.navigator.th_name"/></th>
		<th><bean:message key="info.navigator.th_date"/></th>
		<th><bean:message key="info.navigator.th_time"/></th>
		</tr>		
		
		<logic:notEqual name="CIFSNavigatorListForm" property="rootDirectory" value="<%=(String)nowDirTrue%>">
			<tr>
			<td><a href="#" onclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
				<img border="0" src="<%=contextPath%>/images/back.gif"></a></td>
			<td><a href="#" onclick='chooseParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'
			                ondblclick='intoParentDir("<%=nowDirTrue%>" , "<%=rootDir%>"); return false;'>
				<bean:message key="info.navigator.parent_dir"/></a></td>
			<td></td>
			<td></td>
			</tr>
		</logic:notEqual>
		<logic:iterate id="oneDir" name="CIFSShareAllDirectoryInfo">
			<bean:define id="displaySelectedPath" name="oneDir" property="displaySelectedPath"/>
			<bean:define id="wholePath" name="oneDir" property="wholePath"/>
			<tr>	
			<td><a href="#"
				onclick='intoSubDir("<%=displaySelectedPath%>" , "<%=wholePath%>"); return false;'>
				<logic:equal name="oneDir" property="mountStatus" value="mount">	
					<img border="0" src="<%=contextPath%>/images/folder.open.gif">
				</logic:equal>	
				<logic:notEqual name="oneDir" property="mountStatus" value="mount">
				        <img border="0" src="<%=contextPath%>/images/folder.gif">
				</logic:notEqual>	
				</a></td>	
			<td><a href="#"
				onclick='chooseSubDir("<%=displaySelectedPath%>", "<%=wholePath%>"); return false'
				ondblclick='intoSubDir("<%=displaySelectedPath%>" , "<%=wholePath%>"); return false;'>
				<bean:define id="displayedPath" name="oneDir" property="displayedPath"/>
				<%=(String)displayedPath%>
				</a></td>
			<td><bean:write name="oneDir" property="dateString"/></td>
			<td><bean:write name="oneDir" property="timeString"/></td>	
			</tr>
		</logic:iterate>
	</table>
</logic:notEqual>

<html:hidden property="rootDirectory"/>
<html:hidden property="nowDirectory"/>
<html:hidden property="directoryName"/>

</html:form>

</body>
</html:html>