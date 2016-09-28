<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsotheroptionsbottom.jsp,v 1.3 2006/11/09 05:41:11 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="javascript">

    function init() {
        if(parent.frames[0].document && parent.frames[0].document.forms[0]
           && parent.frames[0].document.forms[0].elements["otherOptions.directHosting"]) {
            parent.frames[0].onChangeDH();
        }
    }
    
    function onSubmit() {
        if(parent.frames[0].document && parent.frames[0].document.forms[0]
           && parent.frames[0].document.forms[0].elements["otherOptions.directHosting"]){
	        if(parent.frames[0].onSet()) {
                document.forms[0].set.disabled = true;
                return true;
            }
	    }
	    return false;
    }
    
</script>
</head>
<body onload="init();">
<form target="_parent" method="post">
	<input name="set" type="button" value='<bean:message key="common.button.submit" bundle="common"/>'
		onclick="return onSubmit();" disabled />
</form>
</body>
</html>