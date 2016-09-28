<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsSetDirAccessControlBottom.jsp,v 1.2 2005/06/20 04:40:44 changhs Exp $" -->

<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function onSubmit(){
 if(window.parent.frames[0] && window.parent.frames[0].document.forms[0]&& window.parent.frames[0].document.forms[0].helpLocation){
  	return window.parent.frames[0].onSet();
    }
  
}
function init(){
 if(window.parent.frames[0] && window.parent.frames[0].document.forms[0] && window.parent.frames[0].document.forms[0].helpLocation){
  	  window.parent.frames[0].enableBottomButton();
    }
}
</script>
</head>
<body onload="init();" style="margin: 10px;">
<form method="POST"  name="dirAccesBottomForm">
    <input type="button" name="button_submit" onclick="onSubmit()"
        value="<bean:message key="common.button.submit" bundle="common"/>" disabled />
</form>
</body>
</html>
