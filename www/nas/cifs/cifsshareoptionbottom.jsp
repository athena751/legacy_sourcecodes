<!--
        Copyright (c) 2005 NEC Corporation
 
        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsshareoptionbottom.jsp,v 1.1 2005/06/19 06:49:49 key Exp $" -->

<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function onSubmit(){
 if(window.parent.frames[0] && window.parent.frames[0].document.forms[0] && window.parent.frames[0].document.forms[0].operation){
        return window.parent.frames[0].createOrSave();
    }
}

function init(){
 if(window.parent.frames[0] && window.parent.frames[0].document.forms[0]&& window.parent.frames[0].document.forms[0].operation){
  	  window.parent.frames[0].enableBottomButton();
    }
}
</script>
</head>
<body onload="init();" style="margin: 10px;">
<form method="POST"  name="shareOptionBottomForm">
    <input type="button" name="button_submit" onclick="onSubmit()"
        value="<bean:message key="common.button.submit" bundle="common"/>" disabled />
</form>
</body>
</html>
