<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddralways.jsp,v 1.7 2008/05/24 09:01:47 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<html>
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="ddrcreatecommon.jsp"%>
<%@ include file="ddrcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>

<script language="JavaScript">
var heartBeatWin;

function init(){
    loadBottom();
    var selectedMv =  document.forms[0].elements["mvInfo.name"].value;
    if(selectedMv == "" || !isMvExist(selectedMv)){
	    selectMv();
	}
	setHelpAnchor('disk_backup_5');
}
function loadBottom(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrAlwaysBtn.do"/>' + '"',1);
  	}
}
function checkPoolCapacity(){
	var poolName = document.forms[0].elements["rv0Info.poolName"].value;
	if (poolName == ""){
	    alert('<bean:message key="msg.add.noSelectedPool"/>');
	    return false;
	}
    var capciObj = document.forms[0].elements["mvInfo.capacity"];
    var availCapValue = combinateStr(document.getElementById("usableCapDiv0").innerHTML);  
    var volumeSize = capciObj.value;
    if (parseFloat(volumeSize) > parseFloat(availCapValue)){
	    alert("<bean:message key="msg.add.exceedMaxCapacity"/>");
	    return false;
    }
    return true;
}
function onAdd(){
    if (isSubmitted()){
        return false;
    }
    if(!checkPoolCapacity()){
        return false;
    }
    var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
            "<bean:message key="common.confirm.action" bundle="common"/>"+ 
            "<bean:message key="common.button.create" bundle="common"/>"
    if(!confirm(msg)){
    	return false;
    }
    setRvHiddenVal(0);   
    document.forms[0].action="/nsadmin/ddr/ddrPairCreate.do?operation=alwaysRepl";
    setSubmitted();
    heartBeatWin = openHeartBeatWin();
    lockMenu();
    document.forms[0].submit();
    return true;
}

</script>
</head>

<body onload="init();"
	  onUnload="unLockMenu();closePopupWin(heartBeatWin);closePopupWin(poolWin);unloadBtnFrame();closeDetailErrorWin();">
<html:button property="reloadBtn" onclick="reloadPage();">
   <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<displayerror:error h1_key="ddr.h1"/>
<h3 class="title"><bean:message key="title.add.h3"/></h3>
<html:form action="/ddrPairCreate.do?operation=alwaysRepl" onsubmit="return false;">
<%@ include file="ddrmvinfo.jsp"%>
<nested:nest property="rv0Info">
    <nested:hidden property="name"/>
    <nested:hidden property="aid"/>
    <nested:hidden property="raidType"/>
    <nested:hidden property="poolNo"/>
    <nested:hidden property="wwnn"/>
    <nested:hidden property="usableCap"/>
<h4 class="title"><bean:message key="pair.info.rvname"/></h4>
	  <table border="1" id="table_rv" nowrap class="Vertical" style="table-layout:fixed;">
	    <tr>
	      <th width=180px><bean:message key="info.rvName"/></th>
	      <td width=220px>		    
	      	 <DIV id="rv0Name"><nested:write property="name"/></DIV>
	      </td>
	    </tr>
	
	    <tr>
	      <th valign="top"><bean:message key="info.pool"/></th>
	      <td>
	        <nested:text property="poolName" size="20" readonly="true"/>
	        <br>
	        <html:button property="poolSelectBtn" onclick="openSelectPool(0);">
	        	<bean:message key="button.poolSelect"/>
	        </html:button>
	      </td>
	    </tr>
	    <tr>
	      <th><bean:message key="info.pool.raidType"/></th>
	      <td>
	      	<DIV id="raidTypeDiv0"><nested:write property="raidType"/></DIV>
	      </td>
	    </tr>
	    <tr>
	      <th><bean:message key="info.pool.empty.capacity"/></th>
	      <td>
		     <bean:define id="showUseableCap0" name="PairCreateShowForm" property="rv0Info.usableCap" type="java.lang.String"/>
		     <logic:notEmpty name="showUseableCap0">
		         <DIV id="usableCapDiv0"><%=(new DecimalFormat("#,##0.0")).format(new Double(showUseableCap0))%></DIV>
		     </logic:notEmpty>
		     <logic:empty name="showUseableCap0" >
		          <DIV id="usableCapDiv0"><bean:message key="info.off"/></DIV>
		     </logic:empty>
		  </td>
	    </tr>
	  </table>
</nested:nest>
</html:form>

<form name="rv0PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
  
</body>
</html>
