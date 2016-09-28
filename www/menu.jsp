<!--
        Copyright (c) 2004-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: menu.jsp,v 1.20 2008/05/09 01:26:08 zhangjun Exp $" -->

<%@ page import="java.util.*,com.nec.nsgui.model.biz.framework.ControllerModel" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link href="../skin/default/menu.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="../common/common.js"></script>
<script language="Javascript">
//curForm cannot be deleted.
//curForm is called by selectModule() in commom.js and used
//by control.jsp
var curForm;
var isFirstLoad = true;
var hasLoad=false;

function configDiv(showId){
    for(var i=0; i<divArray.length; i++){
        if(i == showId){
            showIt(divArray[i]);  
        }else{
            hideIt(divArray[i]);
        }
    }
}
//store the last time's selected category
var curCategory = "";
function showIt(name){
    if(curCategory == name){
        return;
    }    
    curForm = null;
    curCategory = name;
    setControlStatus();
    // Just for IE5,6; NN6; Mozilla
    if (document.getElementById){ 
        document.getElementById(name).style.display='inline';
        //document.getElementById(name).style.visibility='display';
    }
    if (!isFirstLoad) {
    	top.ACTION.location="../action.html";
    }
}
function hideIt(name){
    // Just for IE5,6; NN6; Mozilla
    if (document.getElementById){ 
        //document.getElementById(name).style.visibility='hidden';
        document.getElementById(name).style.display='none';
    } 
}

<bean:define id="allCate" name="menu" property="categoryMap" scope="request" />
var divArray = new Array(<%=((Map)allCate).size()%>);
<bean:define id="prefixDivName" value="cateDiv" />

<logic:iterate id="cate" name="allCate" indexId="i" >
    divArray[<%=i%>] = "<%=prefixDivName+i%>";
</logic:iterate>
</script>
</head>
<body onload="configDiv(0); isFirstLoad=false; hasLoad=true;selectModule('status.system.status');" style="margin: 0px;">
<form name="forwardForm" action="/nsadmin/framework/moduleForward.do" target="ACTION" style="margin: 0px;">
	<input type="hidden" name="h1" value=""> 
	<input type="hidden" name="h2" value="">
	<input type="hidden" name="bundle" value="framework">	
	<input type="hidden" name="msgKey" value="">
	<input type="hidden" name="url" value="">
	<input type="hidden" name="selectExpgrp" value="">
</form>
<table width="100%" class="User" cellspacing="0" cellpadding="0">
    <tr><td valign="middle" height="31">
        <img src="../images/nation/grid.gif" width="22" height="15">
        <span class="User"><b>
        <bean:write name="userinfo" scope="session"/>
        </b></span>
    </td></tr>
</table>
<div class="CategoryTitle">
<table border="0" width="100%" class="CategoryTitle" cellspacing="0" cellPadding=0 >
    <tr>
    <logic:iterate id="cate" name="allCate" indexId="indexId" >
        <td class="CategoryTitle<%=indexId%>" align="center"
            height=16 nowrap 
            onclick="if(isMenuLocked()){return false;};configDiv(<%=indexId%>);return false;" >
            <a href="#" onclick="if(isMenuLocked()){return false;};if (!isIE()){configDiv(<%=indexId%>);return false;}">
               <font class="CategoryTitle<%=indexId%>">
                   <bean:define id="cateObj" name="cate" property="value" />
                   <bean:message name="cateObj" property="msgKey" bundle="menuResource/framework" />
               </font>
            </a>
        </td>
        <td height=16 class="CategoryTitle<%=indexId%>" width="12">
        <img width=12 height=16 src="../images/nation/tail.gif">
        </td>    
    </logic:iterate>        
    </tr>
</table>
</div>

<logic:iterate id="cate" name="allCate" indexId="indexId" >
    <div id="<bean:write name="prefixDivName"/><%=indexId%>" 
         class="Category<%=indexId%>" >
    <table border="0" 
           class="Category<%=indexId%>" 
           width="100%" cellspacing="0">
    <bean:define id="cateObj" name="cate" property="value" />
    <logic:iterate id="subCate" name="cateObj" property="subCategoryMap" indexId="subcateId" >
        <tr>
        <th nowrap align="left">
            <font class="SubCategoryTitle<%=indexId%>" >
            <bean:define id="subCateObj" name="subCate" property="value" />
            <bean:message name="subCateObj" property="msgKey" bundle="menuResource/framework" />
            </font>
        </td>
        </tr>
        <logic:iterate id="item" name="subCateObj" property="itemMap">
            <bean:define id="itemObj" name="item" property="value" />
            <tr>
            <form name="<bean:write name="itemObj" property="msgKey"/>" action="../<bean:write name="itemObj" property="href"/>" target="ACTION" method="POST">
            <logic:equal name="itemObj" property="hasLicense" value="false">
            <td class="NoLicense">
            <input type="hidden" name="hasLicense" 
                        value="<bean:write name="itemObj" property="hasLicense" />" />
            <table border="0" cellspacing="0" cellpadding="1"><tr><td width="10">
            <div width="10" height="10"><img src="../images/menu/bk_<%=indexId%>.jpg" width="10" height="10"/></div>
            </td><td>
            <font class="ItemNolicense">
            <bean:message name="itemObj" property="msgKey" bundle="menuResource/framework" />
            </font>
            </td></tr></table>
            </td>
            </logic:equal>
            
            <logic:equal name="itemObj" property="hasLicense" value="true"> 
            <td nowrap class='OnMoveOut' 
                onmouseover="this.className='OnMoveOver<%=indexId%>';" 
                onmouseout="this.className='OnMoveOut';"
                onclick="if(isMenuLocked()){return false;};selectModule('<bean:write name="itemObj" property="msgKey"/>'); return false;">
                <table border="0" cellspacing="0" cellpadding="1"><tr><td width="10">
                <div width="10" height="10"><img src="../images/menu/bk_<%=indexId%>.jpg" width="10" height="10"/></div>
                <div style="POSITION: absolute;VISIBILITY: hidden;">
                <logic:notEqual name="machineType" value="Single" scope="request">
                    <logic:notEqual name="machineType" value="NasheadSingle" scope="request">
                        <input type="hidden" name="group" value="" />
                    </logic:notEqual>
                </logic:notEqual>
                <input type="hidden" name="changeNode" 
                       value="<bean:write name="itemObj" property="changeNode"/>" />
                <input type="hidden" name="selectExpgrp" 
                       value="<bean:write name="itemObj" property="selectExpgrp"/>" />
                <input type="hidden" name="targetType" 
                       value="<bean:write name="itemObj" property="targetType"/>" />
                <input type="hidden" name="helpAnchor" 
                       value="<bean:write name="itemObj" property="helpAnchor"/>" />
                <input type="hidden" name="itemNameKey" 
                        value="<bean:write name="itemObj" property="msgKey" />" />
                <input type="hidden" name="hasLicense" 
                        value="<bean:write name="itemObj" property="hasLicense" />" />
                <%boolean hasTarget = false;%>
                <logic:iterate id="hidden" name="itemObj" property="hiddenMap">
                    <bean:define id="hiddenName" name="hidden" property="key" />
                      <input type="hidden" 
                           name="<bean:write name="hidden" property="key"/>" 
                           value="<bean:write name="hidden" property="value"/>" />
                      <logic:equal name="hiddenName" value="target">
                          <%hasTarget=true;%>
                      </logic:equal>
                </logic:iterate>
                <%if(!hasTarget){%>
                    <input type="hidden" name="target" value="" />
                <%}%>
                </div>
                </td><td>
                <a href="#" 
                    onclick="if(isMenuLocked()){return false;};if (!isIE()){
                        selectModule('<bean:write name="itemObj" property="msgKey"/>');
                        return false;}">
                    <font class="Item<%=indexId%>">
                    <bean:message name="itemObj" property="msgKey" bundle="menuResource/framework" />
                    </font>
                </a>
                </td></tr></table>
            </td>
            </logic:equal>
            
            </form>
            </tr>
        </logic:iterate>
    </logic:iterate>
    </table>
    </div>
</logic:iterate>

</body>
</html>
