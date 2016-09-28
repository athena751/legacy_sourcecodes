<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicbondbottom.jsp,v 1.2 2005/10/24 04:39:19 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-logic" prefix="logic"%>
<html>
<HEAD>
<%@include file="../../common/head.jsp"%>
<html:base />
<script language="javascript">    
 	function onSetting(){
        if (window.parent && window.parent.nicbondtopframe){
        	window.parent.nicbondtopframe.onSubmitSetting();
        }
    }
    
    function displayAlert4parent(){
    	if (parent && parent.nicbondtopframe && parent.nicbondtopframe.displayAlert){
    		parent.nicbondtopframe.displayAlert();
    	}
    }
  function init(){
    if( parent && parent.frames[0].document.forms[0]){
        document.forms[0].set.disabled = false;
    }
  }
</script>
</HEAD>
<body onload="init();displayAlert4parent();">
<form>
<input name="set" type="button"
	value="<bean:message key="common.button.submit" bundle="common"/>"
	onclick="onSetting()" disabled />
</form>
</body>
</html>
