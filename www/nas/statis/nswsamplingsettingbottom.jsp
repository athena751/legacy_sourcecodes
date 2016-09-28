<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingsettingbottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
    <SCRIPT language=JavaScript src="../common/validation.js"></SCRIPT>
    <script language="javascript">
    function OnExecuteBtn(){
        if(!parent.nswsamplingsettingmid){
            return false;
        }
        if(!parent.nswsamplingsettingmid.midLoadFlag||parent.nswsamplingsettingmid.midLoadFlag==0){
            return false;
        }
        if(parent.nswsamplingsettingmid.isSubmitted()){
            return false;
        }
        var tempInterval=parent.nswsamplingsettingmid.document.forms[0].interval.value;
        var tempPeriod=trim(parent.nswsamplingsettingmid.document.forms[0].period.value);
        if(!isValidDigit(tempPeriod,1,366)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>"+"\r\n"+"<bean:message key="statis.nsw_sampling.period_error"/>");
            parent.nswsamplingsettingmid.document.forms[0].period.select();
            return false;
        }
        tempPeriod=parseInt(tempPeriod,10);
        parent.nswsamplingsettingmid.document.forms[0].period.value=tempPeriod;
        if(!confirm("<bean:message key="statis.nsw_sampling.submit_confirm"/>")){
            return false;
        }
        parent.nswsamplingsettingmid.setSubmitted();
        parent.nswsamplingsettingmid.document.forms[0].action="nswsampling.do?operation=modifyData";
        parent.nswsamplingsettingmid.document.forms[0].submit();
    }
    </script>
</head>
<body>
<form>
    <html:button property="executeBtn" onclick="OnExecuteBtn();">
        <bean:message key="common.button.submit" bundle="common"/>
    </html:button>
</form>
</body>
</html>