<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: accounttablistbottom.jsp,v 1.2 2007/05/09 07:40:53 chenbc Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>

<script language="javaScript">

		function onSubmit(){
		    if (parent.frames[0].document.forms[0]){
		        return parent.frames[0].onNsviewOut();
		    }
		    return false;
		}
		
		function changeButtonStatus() {
			if(window.parent.frames[0].document) {
				if(window.parent.frames[0].buttonEnable == 1) {
					document.forms[0].nsviewOut.disabled = false;
				}
				else {
					document.forms[0].nsviewOut.disabled = true;
				}
			}
		}
		</script>
</head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<body onload="changeButtonStatus();">
<form><input type="button" name="nsviewOut"
	value='<bean:message key="account.button.nsviewOut" />' disabled="true"
	onclick="onSubmit()"></form>
</body>
</html:html>
