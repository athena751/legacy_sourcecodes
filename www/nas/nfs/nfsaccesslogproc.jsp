<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: nfsaccesslogproc.jsp,v 1.2 2005/01/21 01:10:45 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<title><bean:message key="title.nfs.accesslogproc.h2" /></title>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">

function changeItemStatus(disable){
    for(var i = 0;i<4;i++){
        document.accesslogproc.specificItem[i].disabled = disable;
    }
}
var parentHelpAnchor="";
function init(){
    if(window.opener && !window.opener.closed && window.opener.document.forms[0]){
        parentHelpAnchor = window.opener.NFS_DETAIL_LICENSE;
    
        var procAry = window.opener.selectedProc;
        var selectCreate = procAry && procAry[0] && procAry[1]&& procAry[2] && procAry[3]&& procAry[4] && procAry[5];
        var selectRemove = procAry && procAry[6] && procAry[7]&& procAry[8];
        var selectWrite  = procAry && procAry[9];
        var selectRead   = procAry && procAry[10];                        
        if(!procAry){
            document.accesslogproc.itemType[0].checked=true;
            document.accesslogproc.itemType[1].checked=false;
            changeItemStatus(true);
        }else{
            document.accesslogproc.itemType[0].checked=false;
            document.accesslogproc.itemType[1].checked=true;
            changeItemStatus(false);
            if(selectCreate){
                document.accesslogproc.specificItem[0].checked = true;
            }
            if(selectRemove){
                document.accesslogproc.specificItem[1].checked = true;
            }
            if(selectWrite){
                document.accesslogproc.specificItem[2].checked = true;
            }
            if(selectRead){
                document.accesslogproc.specificItem[3].checked = true;
            }
        }
    }
}

function onSet(){
    if(window.opener && !window.opener.closed && window.opener.document.forms[0] && window.opener.allprocedures){
        if(document.accesslogproc.itemType[0].checked){
            window.opener.selectedProc = null;
        }else{
            window.opener.selectedProc = window.opener.getArray();
            var procAry = window.opener.selectedProc;
            var createChecked = document.accesslogproc.specificItem[0].checked;
            var removeChecked = document.accesslogproc.specificItem[1].checked;
            var writeChecked = document.accesslogproc.specificItem[2].checked;
            var readChecked = document.accesslogproc.specificItem[3].checked;
            var noChecked = !createChecked && !removeChecked && !writeChecked && !readChecked;
            if(noChecked){
                if(confirm('<bean:message key="nfs.accesslogproc.no.loggingitems"/>')){
                    window.opener.selectedProc = null;
                    window.opener.document.forms[0].accesslog.checked = false;
                    window.opener.document.forms[0].accesslog.onclick();
                }else{
	                return false;
	            }
            }else{
                var procCons = window.opener.allprocedures;
	            if(createChecked){
	                procAry[0] = procCons[0];
	                procAry[1] = procCons[1];
	                procAry[2] = procCons[2];
	                procAry[3] = procCons[3];
	                procAry[4] = procCons[4];
	                procAry[5] = procCons[5];
	            }else{
	                procAry[0] = null;
	                procAry[1] = null;
	                procAry[2] = null;
	                procAry[3] = null;
	                procAry[4] = null;
	                procAry[5] = null;
	            }
	            if(removeChecked){
	                procAry[6] = procCons[6];
	                procAry[7] = procCons[7];
	                procAry[8] = procCons[8];
	            }else{
	                procAry[6] = null;
	                procAry[7] = null;
	                procAry[8] = null;
	            }
	            
	            if(writeChecked){
	                procAry[9] = procCons[9];
	            }else{
	                procAry[9] = null;
	            }
	            
	            if(readChecked){
	                procAry[10] = procCons[10];
	            }else{
	                procAry[10] = null;
	            }
	       }
        }
        window.opener.setHelp();
    }
    window.close();
}

</script>
</head>
<body onload="init();setHelpAnchor('network_nfs_8');" onUnload="setHelpAnchor(parentHelpAnchor);">
<h1 class="title"><bean:message key="title.nfs" /></h1>
<h2 class="title"><bean:message key="title.nfs.accesslogproc.h2" /></h2>
<form name="accesslogproc" onsubmit="return onSet()">
<br>
<table border=1>
    <tr>
        <th><bean:message key="nfs.accesslogproc.loggingitems.title" /></th>
        <td>
            <input type="radio" name="itemType" value="all" id="all" onclick="changeItemStatus(this.checked)"/><label for="all">
                <bean:message key="nfs.radio.accesslogproc.all"/></label><br>
            <input type="radio" name="itemType" value="specific"id="specific" onclick="changeItemStatus(!this.checked)"/><label for="specific">
                <bean:message key="nfs.radio.accesslogproc.specific" /></label><br>
            &nbsp&nbsp<input type="checkbox" name="specificItem" id="create"/>
                <label for="create"><bean:message key="nfs.checkbox.accesslogproc.specific.create" /></label><br/>
            &nbsp&nbsp<input type="checkbox" name="specificItem" id="remove"/>
                <label for="remove"><bean:message key="nfs.checkbox.accesslogproc.specific.remove"/></label><br/>
            &nbsp&nbsp<input type="checkbox" name="specificItem" id="write"/>
                <label for="write"><bean:message key="nfs.checkbox.accesslogproc.specific.write"/></label><br/>
            &nbsp&nbsp<input type="checkbox" name="specificItem" id="read"/>
                <label for="read"><bean:message key="nfs.checkbox.accesslogproc.specific.read"/></label>    
        </td>
    </tr>
</table>
<br>
<input type="submit" value='<bean:message key="common.button.submit" bundle="common"/>'/>&nbsp&nbsp
<input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onclick="window.close();setHelpAnchor(parentHelpAnchor);"/>
</form>
</body>
</html>