<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumepoolinfolistbottom.jsp,v 1.4 2007/08/23 06:15:43 xingyh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var loaded=0;

function init() {
    loaded=1;
    if(parent.volumeBatchListMid
       && parent.volumeBatchListMid.loaded==1
       && parent.volumeBatchListMid.document.forms[0]
       && parent.volumeBatchListMid.document.forms[0].availablePoolNum) {
        document.forms[0].next.disabled=false;
    }
}

function submitForm(){
    if( !parent.volumeBatchListTop
        || parent.volumeBatchListTop.loaded!=1
        ||!parent.volumeBatchListMid 
        || parent.volumeBatchListMid.loaded!=1){
        //when top page exception throwed, availablePoolNum is not existed
        return;
    }
    var all = parent.volumeBatchListMid.document.forms[0].elements;
    var selectedPoolNum = 0;
    for(var i=0; i<all.length; i++){
        if(all[i].name=="selectOrNot"){
            if(all[i].checked){
                selectedPoolNum++;
            }
        }
    }

    if(selectedPoolNum == 0){
        alert("<bean:message key="warning.select.num"/> ");
        return;
    }

    if( parent.volumeBatchListMid.document.forms[0].kind.value == "max") {
        if(selectedPoolNum > parseInt(parent.volumeBatchListMid.document.forms[0].lvNo.value)){
            alert('<bean:message key="warning.select.maxnum" arg0="\'+ parent.volumeBatchListMid.document.forms[0].lvNo.value +\'" /> ');
            return;
        }
        parent.volumeBatchListMid.document.forms[0].action="volumeBatchCreateShow.do?operation=showMaxPOOL";
    }else {
        if (!issamepdtype(selectedPoolNum)){
            if (!confirm("<bean:message key="msg.pool.pdtype.diff" />")) {
			    return ;
			}
        }
        parent.volumeBatchListMid.document.forms[0].action="volumeBatchCreateShow.do?operation=showSpecifyPOOL";            
    }
    lockMenu();
    parent.volumeBatchListMid.document.forms[0].submit();
    parent.frames[0].lockElement();
}
function issamepdtype(poolnumber){
    if (poolnumber == 1){return true;}
	var i=0;
	var poolinfoform = parent.volumeBatchListMid.document.forms[0];
	var pdtype= eval('poolinfoform.elements["volumes[' + i + '].pdtype"].value');
	var selectpdnumber = poolinfoform.elements["selectOrNot"].length;
    for(var i=1; i<selectpdnumber; i++){
    	if (poolinfoform.elements["selectOrNot"][i].checked){
        	var tmppdtype= eval('poolinfoform.elements["volumes[' +i + '].pdtype"].value')
           	if (pdtype!=tmppdtype){
	    		return false;
	    	}
        }
    }
	return true;
}

</script>
</head>
<body onload="init()">
<form>
<input type=button name="next" disabled value="<bean:message key="button.next"/>" onclick="submitForm()" />
</form>
</body>
</html:html>