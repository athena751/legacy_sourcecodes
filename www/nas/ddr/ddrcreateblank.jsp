<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrcreateblank.jsp,v 1.3 2008/05/04 02:15:48 pizb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ page import="com.nec.nsgui.action.base.NSActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<html>
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="ddrcreatecommon.jsp"%>
<%@ include file="ddrcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function initblank(){
    loadBottom();
    displayAlert();
    parent.topframe.ontab('0','/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairList.do?operation=display');
}
function loadBottom(){
	if (parent.btnframe){
           // load empty btn frame
           unloadBtnFrame();
  	}
}

</script>
</head>
<body onload="initblank();">
<displayerror:error h1_key="ddr.h1"/>
</body>
</html>