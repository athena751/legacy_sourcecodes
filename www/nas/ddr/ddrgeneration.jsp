<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrgeneration.jsp,v 1.5 2008/05/24 09:02:30 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
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
	setHelpAnchor('disk_backup_6');
}
function loadBottom(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrGenerationBtn.do"/>' + '"',1);
  	}
}
function checkPoolCapacity(){
    var rvInfoCount = 2;
    var poolSelectCount = 0;
    var capciObj = document.forms[0].elements["mvInfo.capacity"];
    var volumeSize = capciObj.value;
    
    // Check select pool number
    for(var i = 0; i<= rvInfoCount; i++ ){
        var rvInfoName = "rv" + i + "Info.poolName";
        var poolName = document.forms[0].elements[rvInfoName].value;
		if (poolName != ""){
		    poolSelectCount++;
		}else{
			continue;
		}    
        var usableCapDivName = "usableCapDiv" + i;
        var availCapValue = combinateStr(document.getElementById(usableCapDivName).innerHTML);  
	    if (parseFloat(volumeSize) > parseFloat(availCapValue)){
            alert("<bean:message key="msg.add.exceedMaxCapacity"/>");
            return false;
        }
    }
    if(poolSelectCount < 2){
        alert("<bean:message key="msg.add.lessSelectedPool"/>");
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
    // Save in hidden value for submit and rember them when error return
    setRvHiddenVal(0);
    setRvHiddenVal(1);
    setRvHiddenVal(2); 
    document.forms[0].action="ddrCapacityCheck.do";
    setSubmitted();
    lockMenu();
    document.forms[0].submit();
    return true;
}

</script>
</head>
<body onload="init();"
	  onUnload="unLockMenu();closePopupWin(poolWin);unloadBtnFrame();closeDetailErrorWin();">
<html:button property="reloadBtn" onclick="reloadPage();">
   <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<displayerror:error h1_key="ddr.h1"/>
<h3 class="title"><bean:message key="title.add.h3"/></h3>
<html:form action="/ddrPairCreateShow.do?operation=showGeneration" onsubmit="return false;">
<%@ include file="ddrmvinfo.jsp"%>

	<html:hidden property="rv0Info.name"/>
	<html:hidden property="rv0Info.raidType"/>
	<html:hidden property="rv0Info.aid"/>
	<html:hidden property="rv0Info.poolNo"/>
	<html:hidden property="rv0Info.wwnn"/>
	<html:hidden property="rv0Info.usableCap"/>

	<html:hidden property="rv1Info.name"/>
	<html:hidden property="rv1Info.raidType"/>
	<html:hidden property="rv1Info.aid"/>
	<html:hidden property="rv1Info.poolNo"/>
	<html:hidden property="rv1Info.wwnn"/>
	<html:hidden property="rv1Info.usableCap"/>

	<html:hidden property="rv2Info.name"/>
	<html:hidden property="rv2Info.raidType"/>
	<html:hidden property="rv2Info.aid"/>
	<html:hidden property="rv2Info.poolNo"/>
	<html:hidden property="rv2Info.wwnn"/>
	<html:hidden property="rv2Info.usableCap"/>
<h4 class="title"><bean:message key="pair.info.rvname"/></h4>
<table border="1" id="table_rv" nowrap class="Vertical" style="table-layout:fixed;">

   <tr>
     <th width=180px><bean:message key="info.rvName"/></th>
     <td width=220px align=left>
     	<DIV id="rv0Name"><bean:write name="PairCreateShowForm" property="rv0Info.name"/></DIV>
     </td>
     <td width=220px align=left>
     	<DIV id="rv1Name"><bean:write name="PairCreateShowForm" property="rv1Info.name"/></DIV>
     </td>
     <td width=220px align=left>
     	<DIV id="rv2Name"><bean:write name="PairCreateShowForm" property="rv2Info.name"/></DIV>
     </td>
   </tr>

   <tr>
     <th valign="top"><bean:message key="info.pool"/></th>
     <td>
       <html:text property="rv0Info.poolName" size="20" readonly="true"/><br>
       <html:button property="poolSelectBtn" onclick="openSelectPool(0);"> <bean:message key="button.poolSelect"/></html:button>
     </td>
     <td>
       <html:text property="rv1Info.poolName" size="20" readonly="true"/><br>
       <html:button property="poolSelectBtn" onclick="openSelectPool(1);"> <bean:message key="button.poolSelect"/></html:button>
     </td>
     <td>
       <html:text property="rv2Info.poolName" size="20" readonly="true"/><br>
       <html:button property="poolSelectBtn" onclick="openSelectPool(2);"> <bean:message key="button.poolSelect"/></html:button>
     </td>
   </tr>
   <tr>
     <th><bean:message key="info.pool.raidType"/></th>
     <td><DIV id="raidTypeDiv0"><bean:write name="PairCreateShowForm" property="rv0Info.raidType"/></DIV></td>
     <td><DIV id="raidTypeDiv1"><bean:write name="PairCreateShowForm" property="rv1Info.raidType"/></DIV></td>
     <td><DIV id="raidTypeDiv2"><bean:write name="PairCreateShowForm" property="rv2Info.raidType"/></DIV></td>
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
     <td>
	     <bean:define id="showUseableCap1" name="PairCreateShowForm" property="rv1Info.usableCap" type="java.lang.String"/>
	     <logic:notEmpty name="showUseableCap1">
	         <DIV id="usableCapDiv1"><%=(new DecimalFormat("#,##0.0")).format(new Double(showUseableCap1))%></DIV>
	     </logic:notEmpty>
	     <logic:empty name="showUseableCap1" >
	          <DIV id="usableCapDiv1"><bean:message key="info.off"/></DIV>
	     </logic:empty>
     </td>
     <td>
	     <bean:define id="showUseableCap2" name="PairCreateShowForm" property="rv2Info.usableCap" type="java.lang.String"/>
	     <logic:notEmpty name="showUseableCap2">
	         <DIV id="usableCapDiv2"><%=(new DecimalFormat("#,##0.0")).format(new Double(showUseableCap2))%></DIV>
	     </logic:notEmpty>
	     <logic:empty name="showUseableCap2" >
	         <DIV id="usableCapDiv2"><bean:message key="info.off"/></DIV>
	     </logic:empty>
     </td>
   </tr>
 </table>
</html:form>

<form name="rv0PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
<form name="rv1PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
<form name="rv2PoolSelectForm" target="ddr_selectPool" method="post">
	<input type="hidden" name="aid" value="">
	<input type="hidden" name="raidType" value="">
</form>
</body>
</html>
