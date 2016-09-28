<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: volumepoolinfolisttop.jsp,v 1.9 2007/08/29 12:34:11 xingyh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var loaded=0;

function chgKind() {
    var kind = document.forms[0].kind;
    document.forms[0].diskArray.disabled = kind[0].checked;
    document.forms[0].raidType.disabled = kind[0].checked;
    document.forms[0].select.disabled = kind[0].checked;
    if(document.forms[0].diskArray.options[document.forms[0].diskArray.selectedIndex].value == "") {
        document.forms[0].select.disabled = true;
    }
}

function init(){
    loaded=1;
    chgKind();
    reloadPools('');
}

function reloadPools(sel) {
    if(parent.volumeBatchListBottom
       && parent.volumeBatchListBottom.loaded==1) {
        parent.volumeBatchListBottom.document.forms[0].next.disabled=true;
    }

    if(parent.volumeBatchListMid
       && parent.volumeBatchListMid.loaded==1) {
	    var kind=document.forms[0].kind[0].value;
	    var diskArray="";
	    var raidType="";
	    if(document.forms[0].kind[1].checked) {
	        kind = document.forms[0].kind[1].value;
	        diskArray = document.forms[0].diskArray.options[document.forms[0].diskArray.selectedIndex].value;
	        raidType = document.forms[0].raidType.options[document.forms[0].raidType.selectedIndex].value;
	    }
	    var gotoUrl="../volume/volumepoolinfolist.do?operation=midDisplay&diskArray=" + diskArray + "&raidType=" + raidType + "&kind=" + kind + "&from=" + sel+ "&onlyErrMsg=true";
	    parent.volumeBatchListMid.location="/nsadmin/framework/moduleForward.do?&msgKey=apply.volume.volume.forward.to.pool.choose&func=parent.frames[0].unLockElement();&doNotClear=yes&url="+gotoUrl;
	    lockElement();
    }
}

function reloadPage() {
    if (isSubmitted()) {
        return false;
    }
    
    setSubmitted();
    parent.location='/nsadmin/volume/volumeBatchDispatch.do?operation=display';
    lockMenu();
    return true;
}

function lockElement(){
	parent.volumeBatchListTop.document.forms[0].reloadBtn.disabled = true;
	parent.volumeBatchListTop.document.forms[0].back.disabled = true;
	parent.volumeBatchListTop.document.forms[0].kindID0.disabled = true;
	parent.volumeBatchListTop.document.forms[0].kindID1.disabled = true;
	
	document.forms[0].diskArray.disabled = true;
    document.forms[0].raidType.disabled  = true;
    document.forms[0].select.disabled    = true;
    parent.volumeBatchListBottom.document.forms[0].next.disabled=true;
}

function unLockElement(){
	parent.volumeBatchListTop.document.forms[0].reloadBtn.disabled = false;
	parent.volumeBatchListTop.document.forms[0].back.disabled = false;
	parent.volumeBatchListTop.document.forms[0].kindID0.disabled = false;
	parent.volumeBatchListTop.document.forms[0].kindID1.disabled = false;
	
	var kind = document.forms[0].kind;
	document.forms[0].diskArray.disabled = kind[0].checked;
    document.forms[0].raidType.disabled  = kind[0].checked;
    document.forms[0].select.disabled    = kind[0].checked;
    //parent.volumeBatchListBottom.document.forms[0].next.disabled=false is done by middle frame
}

</script>
</head>
<body onload="init();" onUnload="unLockMenu();">
<h1><bean:message key="title.h1"/></h1>
<html:form action="volumepoolinfolist.do" method="post">
<input type=button 
       name="back" 
       value="<bean:message key="common.button.back" bundle="common"/>"
       onclick="lockMenu();lockElement();parent.location='volumeList.do'"/>
<html:button property="reloadBtn" onclick="return reloadPage();">
   <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<h2><bean:message key="title.batchcreateshow.h2"/></h2>
<jsp:include page="volumelicensecommon.jsp" flush="true"/>
<br>
<table>
  <tr><td><html:radio property="kind" value="max" styleId="kindID0" onclick="chgKind();reloadPools('select');"/><label for="kindID0"><bean:message key="msg.batch.kind.max"/></label></td></tr>
  <tr>
    <td><html:radio property="kind" value="specify" styleId="kindID1" onclick="chgKind();reloadPools('select');"/><label for="kindID1"><bean:message key="msg.batch.kind.specify"/></label><br>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <bean:message key="msg.batch.diskarray.name"/><bean:message key="msg.batch.colon"/>
        <html:select property="diskArray"><html:optionsCollection name="diskArrayList"/></html:select>
        <bean:message key="msg.batch.raid.type"/><bean:message key="msg.batch.colon"/>
        <html:select property="raidType">
          <html:option value="68">6(8+PQ)</html:option>
          <html:option value="64">6(4+PQ)</html:option>
          <html:option value="1">1</html:option>
          <html:option value="10">10</html:option>
          <html:option value="5">5</html:option>
          <html:option value="50">50</html:option>
        </html:select>
        <input type="button" name="select" value="<bean:message key="common.button.select" bundle="common"/>" onclick="reloadPools('select');">
    </td>
  </tr>
</table>
</html:form>
</body>
</html:html>