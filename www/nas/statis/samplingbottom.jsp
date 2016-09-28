<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: samplingbottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="javascript">
var bottomLoadFlag=0;
function setBottomLoadFlag(){
    bottomLoadFlag=1;
    if((parent.samplingtop)&&(parent.samplingtop.frameloadflag)&&(parent.samplingtop.frameloadflag==1)){
        parent.samplingtop.document.forms[0].itemRadio[0].onclick();
    }
}
function buttonCommon(){
	if(!parent.samplingtop){
		return false;
	}
	if(!parent.samplingtop.frameloadflag){
		return false;
	}
    if((parent.samplingtop.frameloadflag)!=1){
        return false;
    }
    if(parent.samplingtop.isSubmitted()){
        return false;
    }    
    setModifyInfo();
    return true;
}
function itemModify(){
    if(buttonCommon()){
        parent.samplingtop.document.forms[0].action="sampling.do?operation=forwardModify";
        parent.samplingtop.document.forms[0].submit();
        parent.samplingtop.setSubmitted();
    }
}
function dataDelete(){
    if(buttonCommon()){
        var str=parent.samplingtop.document.forms[0].elements["itemKey"].value;
        if(confirm(parent.samplingtop.creatAlertMsg(str))){
            parent.samplingtop.document.forms[0].action="sampling.do?operation=deleteData";
            parent.samplingtop.document.forms[0].submit();
            parent.samplingtop.setSubmitted();
        }
    }
}
function setModifyInfo(){
    var radioBtn=parent.samplingtop.document.forms[0].elements["itemRadio"];
    
    for(var i=0;i<radioBtn.length;i++){
        if(radioBtn[i].checked){
            var temp=radioBtn[i].value.split("#");
            parent.samplingtop.document.forms[0].elements["id"].value=temp[0];
            parent.samplingtop.document.forms[0].elements["stockPeriod"].value=temp[1];
            parent.samplingtop.document.forms[0].elements["itemKey"].value=temp[2];
        }
    }
    
}
</script>
</head>
<body onload="setBottomLoadFlag();">
<form>
    <html:button property="modify" onclick="itemModify()">
        <bean:message key="common.button.modify2" bundle="common"/>
    </html:button>
    <html:button property="deleteDataBtn" onclick="dataDelete()">
        <bean:message key="statis.sampling.button.delete"/>
    </html:button>
</form>
</body>
</html>