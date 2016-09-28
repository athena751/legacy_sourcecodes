<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: surveymodifybottom.jsp,v 1.3 2005/10/20 15:05:58 zhangj Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<script language="javascript">
function submitModify(){
	if(!parent.surveymodifytop){
		return false;
	}
	if(!parent.surveymodifytop.frameloadflag){
		return false;
	}
    if((parent.surveymodifytop.frameloadflag)!=1){
        return false;
    }	
    if(isSubmitted()){
        return false;
    }
    if(!confirm("<bean:message key="statis.nsw_sampling.submit_confirm"/>")){
        return false;
    }        
    setSubmitted();
    parent.surveymodifytop.document.forms[0].submit();
}
</script>
</head>
<body>
<form>
    <html:button property="modify" onclick="submitModify()">
    <bean:message key="common.button.submit" bundle="common"/>
    </html:button>
</form>
</html>