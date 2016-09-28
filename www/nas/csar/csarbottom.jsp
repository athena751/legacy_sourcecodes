<!--
        Copyright (c) 2008-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: csarbottom.jsp,v 1.2 2009/02/11 02:52:23 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="struts-logic" prefix="logic" %>
<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="javaScript">
function enableButton() {
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
        if(window.parent.frames[0].buttonEnable == 1) {
		    document.forms[0].collect.disabled = false;
		    document.forms[0].recollect.disabled = false;
		    document.forms[0].partdownload.disabled = false;
		}else {
            document.forms[0].collect.disabled = true;
            document.forms[0].recollect.disabled = true;
            document.forms[0].partdownload.disabled = true;
        }
        <logic:equal name="csar_exception_occured" value="yes"> 
          document.getElementById("normal_button").style.display = "none";
          document.getElementById("exception_button").style.display = "inline";
          <%com.nec.nsgui.action.base.NSActionUtil.setSessionAttribute(request,"csar_exception_occured","no");%>
          <logic:empty name="csar_filename" scope="session"> 
            document.forms[0].partdownload.style.display = "none";
          </logic:empty>
        </logic:equal> 
    }
}

function onCollect(){
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
        window.parent.frames[0].onCollectInfo();
    }
}

function onReCollect(){
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
        if(window.parent.frames[0].onCollectInfo()){
            window.parent.frames[0].document.getElementById("exception_message").style.display="none";
            document.getElementById("normal_button").style.display = "block";
            document.getElementById("exception_button").style.display = "none";
        }
    }
}

function onDownload(){
    if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
        window.parent.frames[0].onDownloadPart();
        document.forms[0].partdownload.disabled = true;
    }
}
</script>
</head>
<body onload="enableButton();">
<form>
<div id="normal_button" style="display:block;">
<input type="button" name="collect"
	value='<bean:message key="csar.button.collect"/>'
	disabled="true" onclick="onCollect()">
</div>
<div id="exception_button" style="display:none;">
<input type="button" name="recollect"
	value='<bean:message key="csar.button.recollect"/>'
	disabled="true" onclick="onReCollect()">
<input type="button" name="partdownload"
	value='<bean:message key="csar.button.part.download"/>'
	disabled="true" onclick="onDownload()">
</div>
</form>
</body>
</html>
