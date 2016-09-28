<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logicdiskbindbottom.jsp,v 1.2312 2007/09/07 08:57:32 liq Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.nsgui.action.disk.DiskCommon" %>
<jsp:useBean id="bind" class="com.nec.sydney.beans.fcsan.componentconf.BindUnbindConfBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = bind; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<script src="../../../menu/nas/common/general.js"></script>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<% String arraytype =  request.getParameter("arraytype");%>
<% int diskarraytype = Integer.valueOf(arraytype.substring(0,arraytype.length()-1),16).intValue();%>
<%String ldnumber=bind.getUnUsedLDNum();%>
<%boolean isS=DiskCommon.isSSeries(request);
  boolean isD=DiskCommon.isCondorLiteSeries(request);%>
<%if (!bind.isSuccess()){%>
<body>
<form>
<%=bind.getErrMsg()%>
<center>
<input type="button" name="cancel" value="<nsgui:message key="common/button/close" />" onclick="parent.close();">
</center>
</form>
</body>
<%}else{%>
<script>
//add by caoyh 2002-2002/9/27 for mail: nas 4636
String.prototype.Rtrim = function(){	
	var whitespace = new String(" \t\n\r");
    var s = new String(this);
    var i = s.length - 1;       
    while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
         i--;
     s = s.substring(0, i+1);
     return s;
}
//add end
String.prototype.trim = function()
{
    //return this.replace(/(^\s*)|(\s*$)/g, "");//modified by caoyh 2002/09/05
    return this.replace(/^\s*(\b.*\b|)\s*$/, "$1"); 
}
function checknull()
{
    if (document.forms[0].ldnum.value.trim()=="" || document.forms[0].ldsize.value.trim()=="" || document.forms[0].cancel.disabled || document.forms[0].bltime.value.trim()=="")
    {
        document.forms[0].ok.disabled=true;
        return false;
    }
    document.forms[0].ok.disabled=false;
        return true;
}

//add by hujing for fcsan-defect 188
function fullldno()
{
    var ldnum=document.forms[0].ldnum.value.Rtrim();
    var ldlen=ldnum.length;
    if (ldlen >= 4)
        return;
    for (var i = 0; i < 4 - ldlen; i++){
        ldnum = "0" + ldnum ;
    }
    document.forms[0].ldnum.value = ldnum;
    return;
}
//add end

function check()
{
    if (document.forms[0].ok.disabled||!checknull())
        return false;
    var ldnum=document.forms[0].ldnum.value.Rtrim();
    var avail=/[^A-Fa-f0-9]/g;

/*modified by hujing for fcsan-defect 188*/
    <%if(bind.isFirstArray(request.getParameter("diskarrayid"))){%>
        if((ldnum.search(avail)!=-1 || parseInt(ldnum,16) <= 0x0f || parseInt(ldnum,16) > 0xff )){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/logicdiskbind/incorrect_ldnum"/> ");
            return false;
        }
    <%}else{%>
        if((ldnum.search(avail)!=-1 || parseInt(ldnum,16) < 0x00 || parseInt(ldnum,16) > 0xff )){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/logicdiskbind/incorrect_ldnum_2nd_ary"/> ");
            return false;
        }
    <%}%>    
    fullldno();
    //modify end hujing
    trimSelf(document.forms[0].ldsize);
    var ldsize=document.forms[0].ldsize.value.Rtrim();
    avail=/[^0-9.]/g;
    if (ldsize.search(avail)!=-1 || ldsize.split('.').length>2 || isNaN(parseFloat(ldsize)) || parseFloat(ldsize) < 1 || parseFloat(ldsize) > 2046)
    {
// modified by hujun
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/logicdiskbind/confirm_ldsize_error" />");
        return false;
    }
    ldsize=parseFloat(ldsize);
    if (ldsize>document.forms[0].capacity_GB.value)
    {
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/logicdiskbind/confirm_num_ldsize_error" />");
        return false;
    }  
    <%if (isD){%>
        var isinvalidtime="false";
        if (document.forms[0].bltime.value.match(/[^\d]/)){        
            isinvalidtime="true";
        }
        if (document.forms[0].bltime.value.match(/^0/) && document.forms[0].bltime.value.length>1){
      	    isinvalidtime="true";
        }
        var formattime=parseInt(document.forms[0].bltime.value);
        if (isinvalidtime == "true" || isNaN(formattime)|| formattime <0 || formattime >255 ){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/logicdiskbind/ldbind_time_error" />");
            document.forms[0].bltime.focus();
            return false;
        }
    <%}%>
    return true;
}

function trimSelf(content)
{
    checknull();
    content.value = content.value.Rtrim();
    if (content.name == "ldsize"){
        if(!isNaN(parseFloat(document.forms[0].ldsize.value))){
                if (!isNaN(Math.round(content.value*10)/10)){
                    content.value=Math.round(content.value*10)/10 ;
                    if (content.value < 0.1)
                        content.value = 0.1;
                }
        }
     }


}

function setDefaultRankMsg() {
	document.forms[0].ok.disabled=true;
	document.forms[0].cancel.disabled=false;
    if (parent.frames[1].document.forms[0]) {
        if (parent.frames[1].document.forms[0].pdgroupNo && parent.frames[1].document.forms[0].radio) {                  
            document.forms[0].rankNo.value = parent.frames[1].document.forms[0].rankNo.value;
            document.forms[0].poolName.value = parent.frames[1].document.forms[0].poolName.value;
            document.forms[0].raid.value = parent.frames[1].document.forms[0].raid.value;
            document.forms[0].capacity.value = parent.frames[1].document.forms[0].capacity.value;
            document.forms[0].capacity_GB.value = parent.frames[1].document.forms[0].capacity_GB.value;
            <%if (isS){%>        
                var raid = document.forms[0].raid.value;
                if (raid == "6(4+PQ)" || raid == "6(8+PQ)"){
                    document.forms[0].bltime.disabled=true;
                }else{
                    document.forms[0].bltime.disabled=false;
                }
            <%}%>
        }
    }
}

</script>
<body onload="setDefaultRankMsg();" onResize="resize()">

<form onsubmit='if(check()){ popupBindWin=window.open("/nsadmin/common/commonblank.html","popupBindWin","width=550,height=380,toolbar=no,menubar=no,resizable=yes,scrollbars=yes");popupBindWin.focus();document.forms[0].ok.disabled=true;document.forms[0].cancel.disabled=true;} else return false;' target="popupBindWin" action="<%=response.encodeURL("logicdiskbindconfirm.jsp")%>" method="post">
<table>

<tr>
    <th align="left"><nsgui:message key="fcsan_componentconf/table/th_ld_no" /></th>
    <td align="left">:</td>
    <td align="left"><input type="text" name="ldnum" value="<%=ldnumber%>" maxlength="4" onKeyUp="checknull()" onblur="trimSelf(this)">h</td>
    <input type="hidden" name="ldtype" value="LX">
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="fcsan_componentconf/table/th_ld_capacity" /></th>
    <td align="left">:</td>
    <td align="left"><input type="text" name="ldsize" value="" maxlength="15" onKeyUp="checknull();" onblur="trimSelf(this)" style="text-align:right" ><nsgui:message key="fcsan_common/label/unit_GB" /></td>
</tr>
<tr>
    <th align="left">
    <%if (isD){%>
        <nsgui:message key="fcsan_componentconf/table/th_format_time_procyon"/>
    <%}else if (isS){%>
        <nsgui:message key="fcsan_componentconf/table/th_format_time"/>
    <%}%>
    </th>
    <td align="left">:</td>
    <td align="left" colspan="2">
    <%if (isD){%>
        <input type="text" name="bltime" value="24" maxlength="3" size="5" onKeyUp="checknull();" style="text-align:right">
        <nsgui:message key="fcsan_componentconf/common/hour"/>&nbsp;&nbsp;
        <I><nsgui:message key="fcsan_componentconf/table/th_time_fast"/></I>
    <%}else if (isS){%>
        <select name="bltime">
        <%for(int i=0;i<=24;i++){
            if (i == 0){
                out.println("<option value=\""+i+"\">"+i+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/fastest")+"</option>");
            } else if (i!=10){
                out.println("<option value=\""+i+"\">"+i+"</option>");
            } else {
                out.println("<option value=\""+i+"\" selected>"+i+"</option>");
            }
        }%>
        </select><nsgui:message key="fcsan_componentconf/common/hour"/>
    <%}%>
    </td>
</tr>
</table>
<br>
<center>
<input type="submit" name="ok" disabled value="<nsgui:message key="common/button/submit"/>">
<input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onclick="if (!this.disabled) parent.close()">
<input type="hidden" name="raid" value="">
</center>
<!--<input type="hidden" name="raid" value="0">-->
<input type="hidden" name="pdnum" value="<%=request.getParameter("pdnum")+"h"%>">
<input type="hidden" name="diskarrayid" value="<%=request.getParameter("diskarrayid")%>">
<input type="hidden" name="diskarrayname" value="<%=request.getParameter("diskarrayname")%>">
<input type="hidden" name="arraytype" value="<%=arraytype%>">

<input type="hidden" name="rankNo" value="">
<input type="hidden" name="poolName" value="">
<input type="hidden" name="capacity" value="">
<input type="hidden" name="capacity_GB" value="">
<input type="hidden" name="operation" value="bind">

</form>
</body>
    <%}%>

</html>