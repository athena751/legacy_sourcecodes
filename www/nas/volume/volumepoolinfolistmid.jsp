<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: volumepoolinfolistmid.jsp,v 1.11 2008/10/15 02:14:41 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="java.lang.Double" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>

<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var loaded=0;
var msgAlert = true;
var selectedPoolNum  = 0;
var availLdNo = new Array();
var maxVolSize = <%=VolumeActionConst.VOLUME_MAX_SIZE%>;

<bean:define id="availLdNo" name="availLdNo" type="java.util.Map"/>
<%
  Iterator it = availLdNo.keySet().iterator();
  String aid;
  while(it.hasNext()) {
      aid = (String)it.next();
      out.println("availLdNo.push(new Array('" + aid + "', " + (String)availLdNo.get(aid) + ", 0));");
  }      
%>

function selectAll(){
    config(false);
    config(true);
}

function config(flag){
    msgAlert=false;
    var allElements = document.forms[0].elements;
    for(var i=0; i<allElements.length; i++){
        if(allElements[i].name=="selectOrNot"){
            if(flag) {
                if(!allElements[i].checked) {
                    allElements[i].click();
                }
            }else{
                if(allElements[i].checked) {
                    allElements[i].click();
                }                
            }
        }
    }
    msgAlert=true;
    if(document.forms[0].kind.value == "max" && flag) {
        var poolNum=0;
        var selectedNum=0;
        if (!(document.forms[0].selectOrNot.length)) {
            poolNum++;
            if(document.forms[0].selectOrNot.checked) {
                selectedNum++;
            }
        } else {
            poolNum = document.forms[0].selectOrNot.length;
            for (var i = 0; i < poolNum; i++) {
                if (document.forms[0].selectOrNot[i].checked) {
                    selectedNum++;
                }
            }
        }
        if(selectedNum < poolNum) {
            alert('<bean:message key="msg.batch.reachmax.all"/>');
        }
    }
}

function unselectAll(){
    config(false);
}

function init() {
    loaded=1;
    if(parent.volumeBatchListBottom
       && parent.volumeBatchListBottom.loaded==1
       && document.forms[0].availablePoolNum) {
        parent.volumeBatchListBottom.document.forms[0].next.disabled=false;
    }

    if(document.forms[0].kind.value == "max" && document.forms[0].selectOrNot) {    
        if (!(document.forms[0].selectOrNot.length)) {
            if(document.forms[0].selectOrNot.checked) {
                selectedPoolNum++;
                initSelectStatus(document.forms[0].selectOrNot, 0);  
            }
        } else {
            for (var j = 0; j < document.forms[0].selectOrNot.length; j++) {
                if (document.forms[0].selectOrNot[j].checked) {
                    selectedPoolNum++;
                    initSelectStatus(document.forms[0].selectOrNot[j], j);
                }
            }
        }
    }    
}

function initSelectStatus(thisBox, j) {
    var needLdNum;
    var availLdNum;    
    var thisAid = eval('document.forms[0].elements["volumes[' + j + '].aid"].value');
    var thisCap = eval('document.forms[0].elements["volumes[' + j + '].capacity"].value');
    thisCap = (parseFloat(thisCap)>maxVolSize)? maxVolSize : parseFloat(thisCap);
    needLdNum = Math.ceil(thisCap/2046);
    for(var i=0; i<availLdNo.length; i++) {
        if(availLdNo[i][0] == thisAid) {
            availLdNum  = availLdNo[i][1];
            needLdNum += availLdNo[i][2];
            if(selectedPoolNum > parseInt(document.forms[0].lvNo.value)
               || availLdNum < needLdNum) {
                thisBox.checked=false;
                selectedPoolNum--;       
            } else {
                availLdNo[i][2] = needLdNum;
            }
        }
    }
}

function checkLdNum(thisBox, thisAid, thisCap, thisAname) {
    if(document.forms[0].kind.value == "max") {
        var needLdNum;
        var availLdNum;
    
        thisCap = (parseFloat(thisCap)>maxVolSize)? maxVolSize : parseFloat(thisCap);
        needLdNum = Math.ceil(thisCap/2046);
        for(var i=0; i<availLdNo.length; i++) {
            if(availLdNo[i][0] == thisAid) {
                availLdNum  = availLdNo[i][1];
                if(thisBox.checked) {
                    selectedPoolNum++;
                    needLdNum += availLdNo[i][2];
                    
                    if(selectedPoolNum > parseInt(document.forms[0].lvNo.value)
                       || availLdNum < needLdNum) {
                        thisBox.checked=false;
                        selectedPoolNum--;       
                        if(msgAlert==true) {
                           alert('<bean:message key="msg.batch.reachmax.one" arg0="\' + thisAname + \'" />');
                        }
                    } else {
                        availLdNo[i][2] = needLdNum;
                    }    
                }else{
                    selectedPoolNum--;
                    if(availLdNo[i][2] >= needLdNum) {
                       availLdNo[i][2] -= needLdNum;
                    }else{
                       availLdNo[i][2] = 0;
                    }
                }
                break;
            }
        }
    }      
}

</script>
</head>
<body onload="init()" onUnload="unLockMenu();">
<html:form action="volumeBatchCreateShow.do?operation=showMaxPOOL" target="ACTION" method="post">     
<html:hidden property="kind"/>
<html:hidden property="diskArray"/>
<html:hidden property="raidType"/>

<input type=hidden name="lvNo" value="<bean:write name="lvNo" scope="request" />">

<logic:present name="volume_error" scope="request">
    <bean:message name="volume_error" scope="request" />
</logic:present>
<logic:notPresent name="volume_error" scope="request">
    <input type=hidden name="availablePoolNum" value="">
    <input type=button 
           name="select" 
           value="<bean:message key="button.select.all"/>" 
           onclick="selectAll();" />
    <input type=button 
           name="unselect" 
           value="<bean:message key="button.unselect.all"/>" 
           onclick="unselectAll();" />
    <br> <br>         
    <table border="1">
        <tr>
            <th>&nbsp;</th>
            <th><bean:message key="pool.th.poolName"/></th>
            <th><bean:message key="pool.th.poolNo"/></th>
            <th><bean:message key="pool.th.pdtype"/></th>
            <th><bean:message key="pool.th.usableCapacity"/></th>
            <th><bean:message key="info.empty.capacity"/></th>
            <logic:equal name="volumeBatchCreateForm" property="kind" value="max">
              <th><bean:message key="pool.th.diskArrayName"/></th>
              <th><bean:message key="pool.th.raidType"/></th>
            </logic:equal>
        </tr>
        <logic:iterate id="pool" name="allAvailablePool" scope="request" indexId="i">
            <bean:define id="said" name="pool" property="aid" type="java.lang.String"/>
            <bean:define id="cap" name="pool" property="maxFreeCap" type="java.lang.String"/>
            <bean:define id="saname" name="pool" property="aname" type="java.lang.String"/>
            <tr><%String label="checkBox" + i; %>
            <td><html:multibox property="selectOrNot" styleId="<%=label%>" onclick="<%="checkLdNum(this, '" + said + "', '" + cap + "', '" + saname + "')"%>" ><%=i%></html:multibox></td>
            <td><label for="<%=label%>"><bean:write name="pool" property="poolName" /></label></td>
            <td><bean:write name="pool" property="poolNo" /></td>
            <td><bean:write name="pool" property="pdtype" /></td>
            <td align="right">
                <bean:define id="showCap" name="pool" property="maxFreeCap" type="java.lang.String"/>
                <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap))%>
            </td>
            <td align="right">
                <bean:define id="showCap2" name="pool" property="totalFreeCap" type="java.lang.String"/>
                <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap2))%>
            </td>
            <logic:equal name="volumeBatchCreateForm" property="kind" value="max">
              <td><bean:write name="pool" property="aname" /></td>
              <td><bean:write name="pool" property="raidType" /></td>
            </logic:equal>
            <input type=hidden name="volumes[<%=i%>].poolName" value="<bean:write name="pool" property="poolName" />"/>
            <input type=hidden name="volumes[<%=i%>].poolNo" value="<bean:write name="pool" property="poolNo" />"/>
            <input type=hidden name="volumes[<%=i%>].capacity" value="<bean:write name="pool" property="maxFreeCap" />"/>
            <input type=hidden name="volumes[<%=i%>].aid" value="<bean:write name="pool" property="aid" />" />
            <input type=hidden name="volumes[<%=i%>].aname" value="<bean:write name="pool" property="aname" />" />
            <input type=hidden name="volumes[<%=i%>].pdtype" value="<bean:write name="pool" property="pdtype" />" />
            <input type=hidden name="volumes[<%=i%>].manageCapOfLD" value="<bean:write name="pool" property="manageCapOfLD" />" />
            </tr>
        </logic:iterate>
    </table>
</logic:notPresent>
</html:form>
</body>
</html:html>