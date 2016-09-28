<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: userdblist.jsp,v 1.5 2007/05/09 06:45:16 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.model.entity.mapd.MapdConstant"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="struts-html" prefix="html"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-logic"  prefix="logic"%>
    
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>

<bean:define id="is_nsview" value="<%=(NSActionUtil.isNsview(request))? "true":"false"%>"/>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function getSelectedDmount(){
    var tmpInfo = new Array();
    if (document.fslist){
        if (document.fslist.fsradio){
            if (document.fslist.fsradio.length==undefined){
                tmpInfo= document.fslist.fsradio.value.split(",");
            }else{
                for(var i=0;i<document.fslist.fsradio.length;i++){
                    if(document.fslist.fsradio[i].checked){
                        tmpInfo= document.fslist.fsradio[i].value.split(",");
                        break;
                    }
                }
            }
        }
    }
    return tmpInfo;
}


function goToChangeRule(){
    var tmp = getSelectedDmount();
    window.location="/nsadmin/mapdrule/dispMaintenance.do?mountPoint="+tmp[0];
}


<logic:notEqual name="is_nsview" value="true">
function setButtonStatus(){
    if (document.fslist){
        if (document.fslist.changerule){
            var tmp = getSelectedDmount();
            if (tmp[2]=="n"){
                document.fslist.changerule.disabled=1;
            }else{
                document.fslist.changerule.disabled=0;
            }
        }
    }
}
</logic:notEqual>

<logic:equal name="is_nsview" value="true">
function setButtonStatus(){
    if (document.fslist){
        if (document.fslist.changerule){
            var tmp = getSelectedDmount();
            if (tmp[2]=="n"){
                document.fslist.changerule.disabled=1;
                document.fslist.selectDM.disabled=1;
            }else{
                document.fslist.changerule.disabled=0;
                document.fslist.selectDM.disabled=0;
            }
        }
    }
}
</logic:equal>

function goToSet(){
    var tmp = getSelectedDmount();
    document.fslist.mp.value = tmp[0];
    document.fslist.fstype.value = tmp[1];
    document.fslist.hasauth.value = tmp[2];
    document.fslist.action="getOneAuth.do?meth=getOneAuth";
    document.fslist.submit();
}

</script>
</head>
<body onload="setButtonStatus();displayAlert();setHelpAnchor('usermap_database');">
<h1 class="title"><bean:message key="udb.list.title.h1"/></h1>


    <html:button property="reload" onclick="window.location='getMPList.do?meth=getMPList'">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>

	
<h2 class="title"><bean:message key="udb.list.title.h2"/></h2>	
<displayerror:error h1_key="udb.list.title.h1"/>

<logic:equal name="<%=MapdConstant.ISSUCCESS%>" value="false" scope="request">
    <bean:message key="udb.pageshow.failed.getvolume"/>
</logic:equal>

<logic:notEqual name="<%=MapdConstant.ISSUCCESS%>" value="false" scope="request">
    <logic:empty name="<%=MapdConstant.DMP%>" scope="request">
        <bean:message key="udb.pageshow.novolume"/>
    </logic:empty>
    
    <logic:notEmpty name="<%=MapdConstant.DMP%>" scope="request">
        <form name="fslist" method="post" >
            <input type="hidden" name="mp" value="">
            <input type="hidden" name="fstype" value="">
            <input type="hidden" name="hasauth" value="">

            <bean:define id="tableMode" name="<%=MapdConstant.DMP%>" scope="request"/>
            <nssorttab:table tablemodel="<%=((SortTableModel)tableMode)%>"
                      id="list1"
                      table="border=1" 
                      sortonload="mp:ascend" >
                  
            <nssorttab:column name="radio" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.mapd.UdbTDRender"
                              sortable="no">
            </nssorttab:column>
	        
	        <nssorttab:column name="mp" 
	                          th="STHeaderRender" 
	                          td="com.nec.nsgui.action.mapd.UdbTDRender"
	                          sortable="yes">
	            <bean:message key="udb.table.th.volume"/>
	        </nssorttab:column>
	        
	        <nssorttab:column name="domainType" 
	                          th="STHeaderRender" 
	                          td="com.nec.nsgui.action.mapd.UdbTDRender"
	                          sortable="yes">
	            <bean:message key="udb.table.th.udbType"/>
	        </nssorttab:column>   
	        
	        <nssorttab:column name="domainresource" 
	                          th="STHeaderRender" 
	                          td="com.nec.nsgui.action.mapd.UdbTDRender"
	                          sortable="no">
	            <bean:message key="udb.table.th.resource"/>
	        </nssorttab:column>       
	        </nssorttab:table> 
	        
	        <p>
	        <html:button property="selectDM" onclick="goToSet();">
		<logic:equal name="is_nsview" value="true">
	            <bean:message key="common.button.detail2" bundle="common"/>
		</logic:equal>

		<logic:notEqual name="is_nsview" value="true">
	            <bean:message key="common.button.modify2" bundle="common"/>
		</logic:notEqual>

	        </html:button>
            <html:button property="changerule" onclick="goToChangeRule();">
                <bean:message key="udb.button.changerule"/>
            </html:button>
        </form>
    </logic:notEmpty>
</logic:notEqual>
</body>
</html:html>
