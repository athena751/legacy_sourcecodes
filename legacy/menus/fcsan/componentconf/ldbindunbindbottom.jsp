<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldbindunbindbottom.jsp,v 1.2305 2008/11/26 09:20:34 chenb Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.nsgui.action.base.NSActionUtil" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<script>
String.prototype.trim = function()
{
    //return this.replace(/(^\s*)|(\s*$)/g, "");//modified by caoyh 2002/09/05
    return this.replace(/^\s*(\b.*\b|)\s*$/, "$1"); 
}
function disableAllButton(){
        document.forms[0].unbindbutton.disabled=true;
        document.forms[0].bindbutton.disabled=true;
        document.forms[0].timechangingbutton.disabled=true;	
}
function initbutton()
{
    if ("<%=request.getParameter("pdnum")%>"=="null") {
        document.forms[0].ldlistbutton.disabled=true;
    }
    if("<%=request.getParameter("diskarrayid")%>"=="null"
         ||"<%=request.getParameter("diskarrayid")%>"==""
         ||("<%=request.getParameter("monitoringstate")%>"!="<%=FCSANConstants.FCSAN_STATE_RUNNING%>"
        &&"<%=request.getParameter("monitoringstate")%>"!="<%=FCSANConstants.FCSAN_STATE_STOP%>")) {
	    disableAllButton();
        return;
    }
    if(parent.frames[0].document.forms[0]&&parent.frames[0].document.forms[0].PDGroups){
        document.forms[0].pdnum.value=parent.frames[0].document.forms[0].PDGroups.value;
    }  else {
	    disableAllButton();
        return;
    }

    var type="<%=request.getParameter("arraytype")%>" 
    //translate the type into lower case and trim it.
    type=type.trim().toLowerCase();
    if (type>="30h"&&type<="3fh")    {
	disableAllButton();
    }    
    if (!parent.frames[1].document.forms[0]){
        return;
    }
    if (parent.frames[1].document.forms[0].alldisabled) {
	disableAllButton();
    }
    if (parent.frames[1].document.forms[0].binddisabled) {
        document.forms[0].bindbutton.disabled=true;
        //alert(document.forms[0].bind.disabled)
    }
    if (parent.frames[1].document.forms[0].unbinddisabled) {
        document.forms[0].unbindbutton.disabled=true;
    }
    if (parent.frames[1].document.forms[0].timedisabled) {
        document.forms[0].timechangingbutton.disabled=true;
    } 
}
    var behaveUnbindWin;
    var behaveBindWin;
    var behaveTimeSetWin;
    var behaveLDListWin;
function go(button){
    if(!button.disabled&&button.name=="unbindbutton") {
        // check whether volume is batch created, pair is created or pair is extended
        <%if (NSActionUtil.hasActiveBatchVolume(request)){%>
            alert("<nsgui:message key="fcsan_componentconf/logicdiskunbind/hasActiveBatchCreate"/>");
            return false;
        <%}else if (NSActionUtil.hasActiveAsyncPair(request)){%>
            alert("<nsgui:message key="fcsan_componentconf/logicdiskunbind/hasActiveAsyncPair"/>");
            return false;
        <%}%>
       
        document.forms[0].action="<%=response.encodeURL("logicdiskunbind.jsp")%>";    
        behaveUnbindWin=window.open("/nsadmin/common/commonblank.html","behaveUnbindWin","width=450,height=260,toolbar=no,menubar=no,resizable=yes,scrollbars=yes");
        document.forms[0].target="behaveUnbindWin";
        document.forms[0].submit();
        behaveUnbindWin.focus();     
    }
    if(!button.disabled&&button.name=="bindbutton") {
        document.forms[0].action="<%=response.encodeURL("logicdiskbind.jsp")%>";
        behaveBindWin=window.open("/nsadmin/common/commonblank.html","behaveBindWin","width=600,height=510,toolbar=no,menubar=no,resizable=yes,scrollbars=yes");
        document.forms[0].target="behaveBindWin";
        document.forms[0].submit();
            behaveBindWin.focus();
    }
    if(!button.disabled&&button.name=="timechangingbutton")  {
	    behaveTimeSetWin=window.open("/nsadmin/common/commonblank.html","behaveTimeSetWin","width=470,height=320,toolbar=no,menubar=no,resizable=yes,scrollbars=yes");
        document.forms[0].action="<%=response.encodeURL("ldbindtimeset.jsp")%>";
        document.forms[0].target="behaveTimeSetWin";
        document.forms[0].submit();
        behaveTimeSetWin.focus();
    }
    if(!button.disabled&&button.name=="ldlistbutton")  {
	    behaveLDListWin=window.open("/nsadmin/common/commonblank.html","behaveLDListWin","width=600,height=500,toolbar=no,menubar=no,resizable=yes,scrollbars=yes");
        document.forms[0].action="<%=response.encodeURL("logicaldisklist.jsp")%>";
        document.forms[0].target="behaveLDListWin";
        document.forms[0].submit();
        behaveLDListWin.focus();
    }
    
    return false;
}
</script>

<body onload="initbutton()">
<form method="post">
<input type="submit" name="bindbutton"   value="<nsgui:message key="fcsan_componentconf/ldbindunbind/submit_ldbind" />" onclick="return go(this)">
<input type="submit" name="unbindbutton"  value="<nsgui:message key="fcsan_componentconf/ldbindunbind/submit_ldunbind" />" onclick="return go(this)">
<input type="submit" name="timechangingbutton"   value="<nsgui:message key="fcsan_componentconf/ldbindunbind/submit_changFormatTime" />" onclick="return go(this)">
<input type="submit" name="ldlistbutton"  value="<nsgui:message key="fcsan_componentconf/ldbindunbind/submit_ldlist" />" onclick="return go(this)">

<input type="hidden" name="arraytype" value="<%=request.getParameter ("arraytype")%>">
<input type="hidden" name="diskarrayname" value="<%=request.getParameter("diskarrayname")%>" >
<input type="hidden" name="diskarrayid" value="<%=request.getParameter("diskarrayid")%>" >
<input type="hidden" name="pdnum" value="<%=request.getParameter("pdnum")%>"> 

</form>
</body>
</html>