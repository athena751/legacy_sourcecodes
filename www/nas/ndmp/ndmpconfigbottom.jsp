<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ndmpconfigbottom.jsp,v 1.3 2007/05/09 05:38:27 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>

<script language="javaScript">

	function onSubmit(){
	    if (window.parent.frames[0].document && parent.frames[0].document.forms[0]){
	        return parent.frames[0].onSet();
	    }
	    return false;
	}
    
	function enableBottomButton() {
		if(window.parent.frames[0].document && window.parent.frames[0].document.forms[0]) {
	                if(window.parent.frames[0].buttonEnable == 1) {
				document.forms[0].set.disabled = false;
			}
			else {
				document.forms[0].set.disabled = true;
			}
		}
	}
        
</script>
</head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<body onload="enableBottomButton();">
<form><input type="button" name="set"
	value='<bean:message key="common.button.submit" bundle="common"/>'
	disabled="true" onclick="onSubmit()"></form>
</body>
</html:html>
