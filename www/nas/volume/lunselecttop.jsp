<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: lunselecttop.jsp,v 1.9 2008/02/29 12:37:04 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld"    prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<%@ page buffer="32kb" %>

<%
	String src = (String)(request.getParameter("src"));
	String title = "title.h1";
	if (src.equals("replication")) {
	   title = "replication.h1";
	}else if(src.equals("lvm")) {
	   title = "title.lvm.h1";
	}
%>
<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
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
    if (!(document.forms[0].lunCheckbox.length)) {
        document.forms[0].lunCheckbox.checked = flag;
    } else {
        for(var i = 0; i < document.forms[0].lunCheckbox.length; i++) {
            document.forms[0].lunCheckbox[i].checked = flag;  
        }
    }    
}

function changeButtonStatus() {
    if(parent.bottomframe 
       && parent.bottomframe.loaded == 1) {
		if(!(document.forms[0].lunCheckbox.length)) {
		    if(document.forms[0].lunCheckbox.checked) {
		        parent.bottomframe.document.forms[0].selectBtn.disabled = false;
		        return;
		    }
		}else{
		    for(var i = 0; i < document.forms[0].lunCheckbox.length; i++) {
		        if (document.forms[0].lunCheckbox[i].checked) {
		            parent.bottomframe.document.forms[0].selectBtn.disabled = false;
		            return;
		        }
            }
    	}
    	
    	parent.bottomframe.document.forms[0].selectBtn.disabled = true;
    } 
}

function onLink() {
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    parent.location = "/nsadmin/menu/nas/nashead/luncreate.jsp?src=<%=src%>&nextURL=/nsadmin/volume/lunSelectShow.do"
    return true;
}
function changeOpenerStripeStatus(){
    if(parent.opener){
        var selectLdPath = parent.opener.selectedLdPath.value;
        var gfsLience = parent.opener.gfsLicense;
        var gfsCheckBox = parent.opener.gfsCheckBox;
        var stripingRdo = parent.opener.stripingRdo;
        var notStripingRdo = parent.opener.notStripingRdo;
        
        if(stripingRdo && notStripingRdo){
	        var ldAry = selectLdPath.split(",");
	        if(ldAry.length >= 2 && gfsLience == "true"){
	            if(!gfsCheckBox || gfsCheckBox.checked){
	               stripingRdo.disabled = false;
	               notStripingRdo.disabled = false;
	            }
	        }else{
	            stripingRdo.disabled = true;
	            notStripingRdo.disabled = true;
	        }
        }
    }
}
function onSelect() {
    if (isSubmitted()) {
        return false;
    }

    var tmp;
    var checkboxValue;
    var totalWwnnLun = "";
    var selectedSize;
    var totalLd;
    var totalStorage=""; 
    var selectedLdNum = 0;
    var oldLunNum = 0;
    var totalStorageforHidden="";
    var checkSize = 0;
    var differentSize = 0;
    
    var usedStorageInfo="";
    var extendStorageInfo="";
    if (parent.window.opener){
        if (parent.window.opener.usedStorage){
            usedStorageInfo = parent.window.opener.usedStorage.value;
        }
    }
        
    if (usedStorageInfo!=null && usedStorageInfo!="" && usedStorageInfo!=undefined){
        oldLunNum = usedStorageInfo.split("<BR>").length;
        totalStorage = '<font color="#999999">'+usedStorageInfo+"</font><BR>";
    }
    if (!(document.forms[0].lunCheckbox.length)) {
        if (document.forms[0].lunCheckbox.checked) {
            tmp = document.forms[0].lunCheckbox.value;
            checkboxValue = tmp.split("#");
            totalWwnnLun  = checkboxValue[0] + "(" + checkboxValue[1] + ")";
            selectedSize  = parseFloat(checkboxValue[2]);
            totalLd       = checkboxValue[3];
            totalStorage  += decimal2Hex(4, checkboxValue[1]) + " / " + checkboxValue[4];
            totalStorageforHidden = decimal2Hex(4, checkboxValue[1]) + " / " + checkboxValue[4];
            selectedLdNum++;
        }
    } else {
        for(var i=0; i < document.forms[0].lunCheckbox.length; i++) {
            if (document.forms[0].lunCheckbox[i].checked) {
                tmp = document.forms[0].lunCheckbox[i].value;
                checkboxValue = tmp.split("#");
                
                if (totalWwnnLun == "") {
                    totalWwnnLun  = checkboxValue[0] + "(" + checkboxValue[1] + ")";
                    selectedSize  = parseFloat(checkboxValue[2]);  
                    checkSize = selectedSize;
                    totalLd       = checkboxValue[3];
                    totalStorage  += decimal2Hex(4, checkboxValue[1]) + " / " + checkboxValue[4]; 
                    totalStorageforHidden = decimal2Hex(4, checkboxValue[1]) + " / " + checkboxValue[4];
                    selectedLdNum++;                  
                } else {
                    totalWwnnLun  += "," + checkboxValue[0] + "(" + checkboxValue[1] + ")";
                    selectedSize  += parseFloat(checkboxValue[2]);  
                    if(checkSize != parseFloat(checkboxValue[2])){
                        differentSize = 1;
                    }
                    totalLd       += "," + checkboxValue[3];
                    totalStorage  += "<BR>" + decimal2Hex(4, checkboxValue[1]) + " / " + checkboxValue[4];
                    totalStorageforHidden += "<BR>" + decimal2Hex(4, checkboxValue[1]) + " / " + checkboxValue[4];
                    selectedLdNum++; 
                }    
            }
        }    
    }
    
    setSubmitted(); 
    if (parent.opener) {
	    var tmplunnumber = selectedLdNum+oldLunNum;
	    parent.opener.wwnn.value = totalWwnnLun;
	    parent.opener.selectedLdPath.value = totalLd;
	    parent.opener.differentSize.value = differentSize;
	    
	    parent.opener.document.getElementById("selectedLun").style.height = (tmplunnumber>=3) ? "54px" : "auto";
	    parent.opener.document.getElementById("selectedLun").innerHTML    = totalStorage;
	    
	    var tmpSelectedSize = new String((new Number(selectedSize)).toFixed(1));
	    parent.opener.document.getElementById("selectedLunSize").innerHTML = splitString(tmpSelectedSize);
	    
	    if (parent.window.opener.usedStorage){
            parent.window.opener.usedStorage.value = usedStorageInfo ;
        }
        if(parent.window.opener.storage4Extend){
            parent.window.opener.storage4Extend.value = totalStorageforHidden;
        }
        
        <%if (!src.equals("replication")) {%>
            changeOpenerStripeStatus();
        <%}%>
        <%if (src.equals("volume")) {%>
            if(parent.window.opener && !parent.window.opener.storage4Extend ){
                parent.window.opener.checkStatus();
            }
        <%}%>
	}
    parent.close();
}

function decimal2Hex(dispLength, decimalStr) {
    var hexStr = (new Number(decimalStr)).toString(16); 
    var len = hexStr.length;   
    if (len < dispLength) {
        for (var i = 0; i < dispLength - len; i++) {
            hexStr = "0" + hexStr;
        }
    }
    
    hexStr += "h";
    return hexStr;
}

function init(){
	if (parent.bottomframe) {
        parent.bottomframe.location = "<%=request.getContextPath()%>/volume/loadBottomFrame.do";
    }
    
    var selectedLdPath = parent.window.opener.selectedLdPath.value;
     
    if ((selectedLdPath != null) && (selectedLdPath != "")) {
        var ldPathArr = selectedLdPath.split(",");
        var tmp;
        var lunInfo;

        for (var i = 0; i < ldPathArr.length; i++) {
            if (!document.forms[0].lunCheckbox.length) {
                tmp = document.forms[0].lunCheckbox.value;
                lunInfo = tmp.split("#");
                if (lunInfo[3] == ldPathArr[i]) {
                    document.forms[0].lunCheckbox.checked = true;
                    break;
                }
            } else {
                for (var j = 0; j < document.forms[0].lunCheckbox.length; j++) {
                    tmp = document.forms[0].lunCheckbox[j].value;
                    lunInfo = tmp.split("#");
                    if (lunInfo[3] == ldPathArr[i]) {
                        document.forms[0].lunCheckbox[j].checked = true;
                        break;
                    } 
                } 
            }  
        }
    }    
}
</script>
</head> 
<body onload="init();displayAlert();">
<form>
    <h1 class="popup"><bean:message key="<%=title%>"/></h1>
    <h2 class="popup"><bean:message key="volume.h2.lunLink"/></h2>
    <displayerror:error h1_key="<%=title%>"/>
    <table>
    <tr><td class="wrapTD"><bean:message key="lun.create.message"/></td><tr>
    </table>
    <p>
    <html:button property="selectAllBtn" onclick="return onLink();">
        <bean:message key="volume.h2.lunLink"/><bean:message key="button.dot"/>
    </html:button>
    
    <h2 class="popup"><bean:message key="volume.h2.lunSelect"/></h2>
    
    <logic:empty name="lunInfoTable" scope="session">
        <bean:message key="volume.msg.noLun"/>
    </logic:empty>
    
    
    <logic:notEmpty name="lunInfoTable" scope="session">
        <html:button property="selectAllBtn" onclick="return selectAll();">
            <bean:message key="volume.lunSelect.selectAll"/>
        </html:button>
        <html:button property="selectNoneBtn" onclick="return selectNone();">
            <bean:message key="volume.lunSelect.selectNone"/>
        </html:button>
        
        <br><br>
        <bean:define id="tableModel" name="lunInfoTable" scope="session"/>
        <nssorttab:table  tablemodel="<%=(SortTableModel)tableModel%>" 
                          id="list1"
                          table="border=1" 
                          sortonload="storage:ascend" >
                      
            <nssorttab:column name="checkbox" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              sortable="no">
            </nssorttab:column>
         
            <nssorttab:column name="lun" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.lun"/>
            </nssorttab:column>
            
            <nssorttab:column name="storage" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              sortable="yes"
                              sidesort="lun">
                <bean:message key="info.storage"/>
            </nssorttab:column>
          
            <nssorttab:column name="size" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.batchcreateshow.size"/>
            </nssorttab:column>
        </nssorttab:table>
    </logic:notEmpty>
</form>
</body>
</html:html>