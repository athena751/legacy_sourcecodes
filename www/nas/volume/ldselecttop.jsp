<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ldselecttop.jsp,v 1.4 2008/02/29 12:32:33 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.filesystem.LdPathComparator"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld"    prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<%@ page buffer="32kb" %>
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

function onSelect() {
    var useld ="";
    if (parent.window.opener){
        if (parent.window.opener.usedLdList){
    	    useld = parent.window.opener.usedLdList.value;//dev/ld16<BR>/dev/ld17
    	}
    }
    if (useld==undefined){
    	useld="";
    }
    var ldoldnumber = 0;
    if(useld!="" &&useld!=null){
    	ldoldnumber = useld.split("<BR>").length;
    }
    var selectedLdNum = 0;
    var tmpld;
    var allLdPathforHidden="";
    var allLdPathforShow='<font color="#999999">'+useld+"</font><BR>";
    if (useld==""){
  	    allLdPathforShow="";
    }
    var allLdSize;
    if (!(document.forms[0].lunCheckbox.length)) {
        if (document.forms[0].lunCheckbox.checked) {
            tmpld = document.forms[0].lunCheckbox.value.split("#");
            allLdPathforHidden = tmpld[0];
            allLdPathforShow += tmpld[0];
            allLdSize = parseFloat(tmpld[1]);
            selectedLdNum++;
        }
    }else{
        for(var i=0; i < document.forms[0].lunCheckbox.length; i++) {
            if (document.forms[0].lunCheckbox[i].checked) {
                tmpld = document.forms[0].lunCheckbox[i].value.split("#");
                if (allLdPathforHidden == "") {
                    allLdPathforHidden = tmpld[0];
                    allLdPathforShow += tmpld[0];
                    allLdSize = parseFloat(tmpld[1]);
                    selectedLdNum++;                  
                }else{
                    allLdPathforHidden +=","+tmpld[0];
                    allLdPathforShow +="<BR>"+tmpld[0];
                    allLdSize += parseFloat(tmpld[1]);
                    selectedLdNum++;   
                }    
            }
        }    
    }
    if (parseFloat(allLdSize) > <%=VolumeActionConst.VOLUME_MAX_SIZE%>) {
        alert("<bean:message key="msg.exceedMaxSize"/>");
        return false;
    }
  
    if (parent.window.opener) {
	    parent.window.opener.selectedLdPath.value = allLdPathforHidden;
	    parent.window.opener.document.getElementById("selectedLun").style.height = (selectedLdNum+ldoldnumber>=3) ? "54px" : "auto";
	    parent.window.opener.document.getElementById("selectedLun").innerHTML = allLdPathforShow;
	    
	    var tmpSelectedSize = new String((new Number(allLdSize)).toFixed(1));
	    parent.window.opener.document.getElementById("selectedLunSize").innerHTML = splitString(tmpSelectedSize);
    }
    parent.close();
}

function init(){
    if (parent.bottomframe) {
        parent.bottomframe.location = "<%=request.getContextPath()%>/volume/loadBottomFrame.do";
    }
    var selectedLdPath="";
    if (parent.window.opener){
        selectedLdPath = parent.window.opener.selectedLdPath.value;
    }
    var tmpld;
    if ((selectedLdPath != null) && (selectedLdPath != "")) {
        var oneLdPath = selectedLdPath.split(",");
        for (var i = 0; i < oneLdPath.length; i++) {
            if (!document.forms[0].lunCheckbox.length) {
                tmpld = document.forms[0].lunCheckbox.value.split("#");
                if (oneLdPath[i] == tmpld[0]){
                    document.forms[0].lunCheckbox.checked = true;
                    break;
                }
            }else{
                for (var j = 0; j < document.forms[0].lunCheckbox.length; j++) {
                    tmpld = document.forms[0].lunCheckbox[j].value.split("#");
                    if (oneLdPath[i] == tmpld[0]) {
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
<body onload="init();">
<form>
    <h1 class="popup"><bean:message key="title.lvm.h1"/></h1>
    <h2 class="popup"><bean:message key="title.ld.h2"/></h2>
    <displayerror:error h1_key="title.lvm.h1"/>
      
    <logic:empty name="lunInfoTable" scope="session">
        <bean:message key="volume.msg.noLd"/>
    </logic:empty>
    
    
    <logic:notEmpty name="lunInfoTable" scope="session">
        <html:button property="selectAllBtn" onclick="return selectAll();">
            <bean:message key="lvm.ldSelect.selectAll"/>
        </html:button>
        <html:button property="selectNoneBtn" onclick="return selectNone();">
            <bean:message key="lvm.ldSelect.selectNone"/>
        </html:button>
        
        <br><br>
        <bean:define id="tableModel" name="lunInfoTable" scope="session"/>
        <nssorttab:table  tablemodel="<%=(SortTableModel)tableModel%>" 
                          id="list1"
                          table="border=1" 
                          sortonload="lun:ascend" >
                      
            <nssorttab:column name="ldcheckbox" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              sortable="no">
            </nssorttab:column>
            
            <nssorttab:column name="lun" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="button.ldnumber"/>
            </nssorttab:column>
            
            <nssorttab:column name="ldPath" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4LunSelect"
                              comparator="com.nec.nsgui.action.filesystem.LdPathComparator"
                              sortable="yes">
                <bean:message key="button.ld"/>
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