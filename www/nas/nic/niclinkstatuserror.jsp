<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: niclinkstatuserror.jsp,v 1.3 2007/05/09 06:46:23 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
    
    var thisExist = "1";          
    function onRefresh(){
       if(isSubmitted()){
           return false;
       }
       setSubmitted();
       if(parent.frames[0].thisExist == "1"){
           parent.location="/nsadmin/nic/linkStatus.do";
                    
        }else{
           window.location="/nsadmin/nic/linkStatus.do";   
        }
    }
        </script>
</head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<body onUnload="closeDetailErrorWin();">
    <html:button property="refreshBtn" onclick="onRefresh();">
       <bean:message key="common.button.reload" bundle="common"/>
    </html:button> 
    <h3><bean:message key="nic.h3.linkStatus" /></h3>
    <displayerror:error h1_key="nic.h1.adminnetwork" /><br>
</body>
</html:html>
