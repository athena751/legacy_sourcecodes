<!--
        Copyright (c)2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: poolselectmiddle.jsp,v 1.12 2008/05/30 02:56:12 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>

<bean:parameter id="from" name="from" value="volumeCreate"/>
<bean:define id="moduleName" name="moduleName" type="java.lang.String" scope="session"/>
<bean:define id="ldCount" name="availLdCount" type="java.lang.String" scope="request"/>
<bean:define id="poolpdtype" name="poolpdtype" type="java.lang.String" scope="request"/>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">
function selectAll() {
    setCheckboxStatus(true);
    if(parent.bottomframe 
       && parent.bottomframe.loaded == 1) { 
        parent.bottomframe.document.forms[0].selectBtn.disabled = false; 
    }

}

function selectNone() {
    setCheckboxStatus(false);
    if(parent.bottomframe 
       && parent.bottomframe.loaded == 1) {     
        parent.bottomframe.document.forms[0].selectBtn.disabled = true; 
    }
}

function setCheckboxStatus(flag) {
    if (!(document.forms[0].poolCheckbox.length)) {
        document.forms[0].poolCheckbox.checked = flag;
    } else {
        for(var i = 0; i < document.forms[0].poolCheckbox.length; i++) {
            document.forms[0].poolCheckbox[i].checked = flag;  
        }
    }
}

function changeButtonStatus() {
    if (!(document.forms[0].poolCheckbox.length)) {
        if(document.forms[0].poolCheckbox.checked) {
            parent.bottomframe.document.forms[0].selectBtn.disabled = false;
            return;
        }
    } else {
        for (var i = 0; i < document.forms[0].poolCheckbox.length; i++) {
            if (document.forms[0].poolCheckbox[i].checked) {
                parent.bottomframe.document.forms[0].selectBtn.disabled = false;
                return;
            }
        }
    }
    parent.bottomframe.document.forms[0].selectBtn.disabled = true;
}

function selectDiskArray() {
    if (isSubmitted()) {
        return false;
    }

    if(parent.bottomframe 
       && parent.bottomframe.loaded == 1) {     
        parent.bottomframe.document.forms[0].selectBtn.disabled = true;
    }
    
    document.forms[0].action="/nsadmin/volume/moduleForward.do?msgKey=apply.volume.volume.forward.to.pool.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/poolSelectMiddle.do?from=diskArraySelect";
} 

function onSelectPool() {

    var tmp;
    var poolInfo;
    var poolNameList = "";
    var poolNoList = "";
    var availCap = 0;
    var maxLdSize = 2046;
    var pdtype="<%=poolpdtype%>";
    var flag="";
	
	// ldCount can not be 0, because only diskarray that LD can be created been shown 
    var ldCount = <%=ldCount%>;
     
        
    var selectPoolNum = 0;
    if (!document.forms[0].poolCheckbox.length) {
        if (document.forms[0].poolCheckbox.checked) {
            tmp = document.forms[0].poolCheckbox.value;
            selectPoolNum++;
        }
    } else {   
	    for (var i = 0; i < document.forms[0].poolCheckbox.length; i++) {
	        if (document.forms[0].poolCheckbox[i].checked) {
	            tmp = document.forms[0].poolCheckbox[i].value;
	            selectPoolNum++;
	        }
   	    }
    }
    
    if (selectPoolNum < 1) {
        return;
    } else if (selectPoolNum == 1) {
            poolInfo = tmp.split("#");
            poolNameList = poolInfo[0];
            poolNoList   = poolInfo[1];
            
            if (parseFloat(ldCount) * maxLdSize > parseFloat(poolInfo[2])) {
                availCap = parseFloat(poolInfo[2]);
            } else {
                availCap = parseFloat(ldCount) * maxLdSize;
            }
            if (pdtype!="MIX" && pdtype!=""){
            	if (pdtype !=poolInfo[3]){
    	        	flag="false";
    	        }
            }
    } else {
        for (var i = 0; i < document.forms[0].poolCheckbox.length; i++) {
            if (document.forms[0].poolCheckbox[i].checked) {
                tmp = document.forms[0].poolCheckbox[i].value;
                poolInfo = tmp.split("#");
                if (poolNameList == "") {
                    poolNameList = poolInfo[0];
                    poolNoList   = poolInfo[1];
                } else {
                    poolNameList += "," + poolInfo[0];
                    poolNoList   += "," + poolInfo[1];
                }
                if (pdtype!="MIX" && flag!="false"){
                	if (pdtype == ""){//volume bind
						pdtype=poolInfo[3];
	                }else {
    	                if (pdtype !=poolInfo[3]){
    	                    flag="false";
    	                }
                	}
                }
                var poolSizeFloor = Math.floor(parseFloat(poolInfo[2]));
                if (ldCount > 0) {
                    if (ldCount * maxLdSize > poolSizeFloor) {
                        availCap = availCap + poolSizeFloor;
                        ldCount -= Math.ceil(poolSizeFloor / maxLdSize);
                    } else {
                        availCap = availCap + ldCount * maxLdSize;
                        ldCount  = 0;
                    }
                }
            } 
        }
    }
    if (flag=="false"){
    	if (!confirm("<bean:message key="msg.pool.pdtype.diff" />")){
    	    return;
    	}
    }
    if (parent.window.opener && !parent.window.opener.closed) {
        if (parent.window.opener.document.forms[0]) {
            parent.window.opener.poolName.value = poolNameList;
            parent.window.opener.poolNo.value   = poolNoList;
         
            <%if (moduleName.startsWith("ddr")) {%>
            	var usableCap4Ddr = new String((new Number(availCap)).toFixed(1));
            	parent.window.opener.usableCapDiv.innerHTML = splitString(usableCap4Ddr);
            <%} else {%>
	            if (((parseFloat(availCap) *10) % (1024 * 10)) == 0 ) {
	                parent.window.opener.usableCapDiv.innerHTML = (new Number(parseFloat(availCap) / 1024)).toFixed(0) + "TB";    
	            } else {
	                var tmpUsableCap = new String((new Number(availCap)).toFixed(1));
	                parent.window.opener.usableCapDiv.innerHTML = splitString(tmpUsableCap) + "GB";
	            }
            <%}%>
            
            <%if (!from.equals("volumeExtend") && !from.equals("ddrExtend")) { %>
                var selectedRaidType = document.forms[0].selectedRaidType.value;
                
	            if (selectedRaidType == "64") {
	            	parent.window.opener.raidTypeDiv.innerHTML = "6(4+PQ)";
	            } else if (selectedRaidType == "68") {
	            	parent.window.opener.raidTypeDiv.innerHTML = "6(8+PQ)";
	            } else {
	            	parent.window.opener.raidTypeDiv.innerHTML = selectedRaidType;
	            }
                
                parent.window.opener.aid.value      = document.forms[0].selectedAid.value;
                parent.window.opener.raidType.value = selectedRaidType;
            <%}%>
            
        }
    }

    parent.close();
}

var loaded = 0;
function init() {
    loaded = 1;    
    <%if (moduleName.equals("ddrCreate")) {%>
    	document.forms[0].aid.value = parent.window.opener.aid.value;
    <%}%>
    <% if (!from.equals("volumeExtend") && !from.equals("ddrExtend")) { %>
	    document.forms[0].selectedAid.value = document.forms[0].aid.options[document.forms[0].aid.selectedIndex].value;
	    document.forms[0].selectedRaidType.value = document.forms[0].raidType.options[document.forms[0].raidType.selectedIndex].value;
    <%}%>
  
    <logic:notEmpty name="poolList" scope="request">
        <%if (!from.equals("diskArraySelect")) { %>
         
            var poolNameList = parent.window.opener.poolName.value;
	        if (poolNameList != "") {
	            var poolNameArr = poolNameList.split(",");
	            var tmp;
	            var poolInfo;
	            for (var i = 0; i < poolNameArr.length; i++) {
	                if (!document.forms[0].poolCheckbox.length) {
	                    tmp = document.forms[0].poolCheckbox.value;
	                    poolInfo = tmp.split("#");
	                    if (poolInfo[0] == poolNameArr[i]) {
	                        document.forms[0].poolCheckbox.checked = true;
	                        break;
	                    }
	                } else {
	                    for (var j = 0; j < document.forms[0].poolCheckbox.length; j++) {
	                        tmp = document.forms[0].poolCheckbox[j].value;
	                        poolInfo = tmp.split("#");
	                        if (poolInfo[0] == poolNameArr[i]) {
	                            document.forms[0].poolCheckbox[j].checked = true;
	                            break;
	                        } 
	                    } 
	                }    
	            }
	        }
        <%}%>
        
       if(parent.bottomframe 
          && parent.bottomframe.loaded == 1) { 
            changeButtonStatus();
       }
    </logic:notEmpty>
    
    <logic:empty name="poolList" scope="request">
        if(parent.bottomframe 
           && parent.bottomframe.loaded == 1) {     
            parent.bottomframe.document.forms[0].selectBtn.disabled = true;
        }    
    </logic:empty>    
}
</script>
</head> 
<body onload="init();">
    <h2 class="title"><bean:message key="pool.h2.select"/></h2>
    <html:form action="poolSelectMiddle.do?from=diskArraySelect">
       <% if (!((String)from).equals("volumeExtend")&&!((String)from).equals("ddrExtend")) {%>
            <input type="hidden" name="selectedAid" value=""/>
            <input type="hidden" name="selectedRaidType" value=""/>
      
	        <table border="1" nowrap>
	            <tr>
	                <th><bean:message key="pool.th.diskArrayName"/></th>
	                <td>
                    <% boolean flagValue = false;
                     if (((String)moduleName).equals("ddrCreate")) {
                     	flagValue = true; 
                     } %>	                
	                    <html:select name="diskArrayInfoForm" property="aid" disabled="<%=flagValue%>">
	                        <html:optionsCollection name="diskArrayVector"/>
	                    </html:select>  
	               </td>
	                <th><bean:message key="info.raidType"/></th>
	                <td>
	                    <html:select name="diskArrayInfoForm" property="raidType">
	                        <html:option value="68">6(8+PQ)</html:option>
                            <html:option value="64">6(4+PQ)</html:option>
                            <logic:notEqual name="moduleName" value="ddrCreate" scope="session">
	                            <html:option value="1">1</html:option>
	                            <html:option value="10">10</html:option>
	                            <html:option value="5">5</html:option>
	                            <html:option value="50">50</html:option>
                            </logic:notEqual>
	                    </html:select>           
	                </td>
	                <td>
	                    <html:submit property="selectBtn" onclick="selectDiskArray();">
	                        <bean:message key="common.button.select" bundle="common"/>
	                    </html:submit>
	                </td>
	            </tr>
	        </table>
	        <br><br>
       <%}%>

        <logic:empty name="poolList" scope="request">
            <bean:message key="info.noPool"/>
        </logic:empty>
        
        <logic:notEmpty name="poolList" scope="request">
            <html:button property="selectAllBtn" onclick="return selectAll();">
                <bean:message key="btn.poolSelect.selectAll"/>
            </html:button>
            <html:button property="selectNoneBtn" onclick="return selectNone();">
                <bean:message key="btn.poolSelect.selectNone"/>
            </html:button>
            <br><br>
            <bean:define id="poolList" name="poolList" scope="request" type="java.util.ArrayList"/>
            <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)poolList)%>" 
                             id="poolListId" 
                             table="border=1"
                             sortonload="poolName:ascend">
                                                   
                <nssorttab:column name="checkbox"
                                  th="STHeaderRender"
                                  td="com.nec.nsgui.action.volume.STDataRender4Pool"
                                  sortable="no">
                </nssorttab:column>                                                              
                
                <nssorttab:column name="poolName"
                                  th="STHeaderRender"
                                  td="com.nec.nsgui.action.volume.STDataRender4Pool"
                                  sortable="yes">
                    <bean:message key="pool.th.poolName"/>                                  
                </nssorttab:column>
                
                <nssorttab:column name="poolNo"
                                  th="STHeaderRender"
                                  td="STDataRender"
                                  sortable="yes">
                    <bean:message key="pool.th.poolNo"/>                                  
                </nssorttab:column>
                
                <nssorttab:column name="pdtype"
                                  th="STHeaderRender"
                                  td="STDataRender"
                                  sortable="yes">
                    <bean:message key="pool.th.pdtype"/>                                  
                </nssorttab:column>
                
                <nssorttab:column name="totalCap"
                                  th="STHeaderRender"
                                  td="com.nec.nsgui.action.volume.STDataRender4Pool"
                                  sortable="no">
                    <bean:message key="info.pool.capacity"/>
                </nssorttab:column>
                
                <nssorttab:column name="usedCap"
                                  th="STHeaderRender"
                                  td="com.nec.nsgui.action.volume.STDataRender4Pool"
                                  sortable="no">
                    <bean:message key="pool.th.usedCapacity"/>
                </nssorttab:column>
                
                <nssorttab:column name="maxFreeCap"
                                  th="STHeaderRender"
                                  td="com.nec.nsgui.action.volume.STDataRender4Pool"
                                  sortable="no">
                    <bean:message key="pool.th.usableCapacity"/>
                </nssorttab:column> 
                
                <nssorttab:column name="vgList"
                                  th="STHeaderRender"
                                  td="STDataRender"
                                  sortable="no">
                    <bean:message key="title.list.h2"/>                                  
                </nssorttab:column>        
            </nssorttab:table>                         
        </logic:notEmpty>
    </html:form>
</body>
</html:html>