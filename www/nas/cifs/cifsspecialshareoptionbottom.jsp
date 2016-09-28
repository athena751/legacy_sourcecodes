<!--
        Copyright (c) 2007 NEC Corporation
 
        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsspecialshareoptionbottom.jsp,v 1.1 2007/03/23 08:01:09 chenbc Exp $" -->

<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function onSubmit(){
 if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0] && window.parent.frames[0].document.forms[0].operation){
        return window.parent.frames[0].createOrSave();
    }
}

function init(){
 if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]&& window.parent.frames[0].document.forms[0].operation){
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
