<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

 
<!-- "@(#) $Id: diskarraylistbottom.jsp,v 1.2304 2005/09/21 04:53:50 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%boolean isNotNsview = !(NSActionUtil.isNsview(request));%>

<html>
<head>
<link rel="stylesheet" href="<%=NSConstant.DefaultCSS%>" type="text/css">
</head>
<script language=javascript>
function detl(button)
{
    if(!button.disabled&& parent.frames[1].document.forms[0].diskid.value!=""){
        win=window.open("<%= response.encodeURL("diskarraydetailinfo.jsp")%>?diskid="+parent.frames[1].document.forms[0].diskid.value + "&arraytype=" + parent.frames[1].document.forms[0].arraytype.value,"detaildiskarray", "scrollbars=yes,toolbar=no,menubar=no,resizable=yes,width=600,height=500");
        win.focus();
    }
}
function consti(button)
{
    if(!button.disabled&&parent.frames[1].document.forms[0].diskid.value!=""&&parent.frames[1].document.forms[0].diskname.value!=""){
        parent.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid="+parent.frames[1].document.forms[0].diskid.value+"&diskname="+parent.frames[1].document.forms[0].diskname.value+ "&arraytype=" + parent.frames[1].document.forms[0].arraytype.value;
    }
}
function modName(button)
{
    if(!button.disabled&&parent.frames[1].document.forms[0].diskname.value!=""&&parent.frames[1].document.forms[0].diskid.value!="")
    {
        modname=window.open("<%=response.encodeURL("diskarraynamesetshow.jsp")%>?diskid="+parent.frames[1].document.forms[0].diskid.value+"&diskname="+parent.frames[1].document.forms[0].diskname.value, "modname","scrollbars=yes,toolbar=no,menubar=no,width=400,height=210,resizable=yes");
        modname.focus();
    }
}
function modPort(button)
{
if(!button.disabled&&parent.frames[1].document.forms[0].diskid.value!="") 
    {    
    modport=window.open("<%=response.encodeURL("diskarrayportsetshow.jsp")%>?diskid="+parent.frames[1].document.forms[0].diskid.value,"modport","scrollbars=yes,toolbar=no,menubar=no,width=400,height=210,resizable=yes");
    modport.focus();
    }
}
function checkradio()
{
     document.forms[0].detail.disabled=true;
     document.forms[0].constitution.disabled=true;
     <%if (isNotNsview){%>
     document.forms[0].modifyName.disabled=true;
     <%}%>
     document.forms[0].modifyPort.disabled=true;
     
     if (parent.frames[1].document.forms[0]
         &&parent.frames[1].document.forms[0].hassamename){
        alert("<nsgui:message key="fcsan_common/specialmessage/same_name"/>"); 
     }
     if(parent.frames[1].document.forms[0]
        &&parent.frames[1].document.forms[0].diskid
        &&parent.frames[1].document.forms[0].diskname
        &&parent.frames[1].document.forms[0].observation
        &&parent.frames[1].document.forms[0].arraytype) {
        document.forms[0].detail.disabled=false;
        var observation = parent.frames[1].document.forms[0].observation.value ;
        if (observation!="<%=FCSANConstants.FCSAN_STATE_NO_MONITORING%>") {            
            document.forms[0].constitution.disabled=false;
            if (observation=="<%=FCSANConstants.FCSAN_STATE_RUNNING%>") {
                <%if (isNotNsview){%>
                    document.forms[0].modifyName.disabled=false;
                <%}%>
                var intType = parseInt(parent.frames[1].document.forms[0].arraytype.value,16);
                //if (intType < 0x50 || intType > 0x6f) {
                //    document.forms[0].modifyPort.disabled=false;  
                //} else {
                    document.forms[0].modifyPort.disabled=true;
                //}  
            }
        }
    }
}
</script>

<body onload="checkradio()">
<form>
    <input type="button"  name="detail" value="<nsgui:message key="fcsan_common/button/button_detail"/>" onclick="detl(this)">
    <input type="button"  name="constitution" value="<nsgui:message key="fcsan_componentdisp/diskarray/button_constitution"/>" onclick="consti(this)">
     <%if (isNotNsview){%>
        <input type="button" name="modifyName" value="<nsgui:message key="fcsan_componentdisp/diskarray/button_modifyname"/>" onclick="modName(this)">
    <%}%>
    <input type="hidden"  name="modifyPort" value="<nsgui:message key="fcsan_componentdisp/diskarray/button_modifyportname"/>" onclick="modPort(this)">
    
</form>
</body>
</html>
