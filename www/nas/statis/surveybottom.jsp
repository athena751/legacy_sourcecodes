<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: surveybottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
<script language="javascript">
var modBtmLoadFlag=0;
function setModBtmLoadFlag(){
    modBtmLoadFlag=1;
    if((parent.survey)&&(parent.survey.frameloadflag)&&(parent.survey.frameloadflag==1)){
        parent.survey.document.forms[0].surveyRadio[0].onclick();
    }
}
function surveyModify(){
    if(buttonCommon()){
        parent.survey.document.forms[0].action="survey.do?operation=forwardModify";
        parent.survey.document.forms[0].submit();
        setSubmitted();
    } 
}
function dataDelete(){
    if(buttonCommon()){
        var str=parent.survey.document.forms[0].itemKey.value;
        if(confirm(parent.survey.creatAlertMsg(str))){
            parent.survey.document.forms[0].action="survey.do?operation=deleteData";
            parent.survey.document.forms[0].submit();
            setSubmitted();
        }        
    }
}
function setModifyInfo(){
    var radioBtn=parent.survey.document.forms[0].elements["surveyRadio"];
    for(var i=0;i<radioBtn.length;i++){
        if(radioBtn[i].checked){
            var temp=radioBtn[i].value.split("#");
            parent.survey.document.forms[0].elements["itemKey"].value=temp[0];
            parent.survey.document.forms[0].elements["status"].value=temp[1];
            parent.survey.document.forms[0].elements["interval"].value=temp[2];
            parent.survey.document.forms[0].elements["stockPeriod"].value=temp[3];
            parent.survey.document.forms[0].elements["id"].value=temp[4];
        }
    }
}
function buttonCommon(){
    if(isSubmitted()){
        return false;
    }
    if((parent.survey.frameloadflag)!=1){
        return false;
    }    
    setModifyInfo();
    return true;
}
</script>
</head>
<body onload="setModBtmLoadFlag();">
<form>
    <html:button property="modify" onclick="surveyModify()">
        <bean:message key="common.button.modify2" bundle="common"/>
    </html:button>
    <html:button property="deleteDataBtn" onclick="dataDelete()">
        <bean:message key="statis.sampling.button.delete"/>
    </html:button>
</form>
</body>
</html>