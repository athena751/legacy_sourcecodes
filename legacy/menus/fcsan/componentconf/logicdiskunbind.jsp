<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: logicdiskunbind.jsp,v 1.2307 2005/12/22 01:25:55 wangli Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%@ page contentType="text/html;charset=EUC-JP"%>
<title><nsgui:message key="fcsan_componentconf/logicdiskunbind/ldunbind_title" /></title>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="http://jakarta.apache.org/taglibs/input-1.0" prefix="RankNo" %>
<jsp:useBean id="unbindBean" class="com.nec.sydney.beans.fcsan.componentconf.BindUnbindConfBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = unbindBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<% String arraytype =  request.getParameter("arraytype");%>
<%
Map all_ld=unbindBean.getLDNo();
Map ld = null;
int diskarraytype = Integer.valueOf(arraytype.substring(0,arraytype.length()-1),16).intValue();

if (unbindBean.isSuccess() && (all_ld == null || all_ld.size() == 0)){
   unbindBean.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskunbind/nold")+"</h1>");
}
if (unbindBean.getErrMsg()!=null){%>
<body>
    <%out.println(unbindBean.getErrMsg());%>
<form>
<center>
<input type="button" name="cancel" value="<nsgui:message key="common/button/close" />" onclick="parent.close();">
</center>
</form>
</body>
<%}else{//normal case
boolean isGetAllLD = !unbindBean.isFirstArray(request.getParameter("diskarrayid"));//!(diskarraytype >= 0x50 && diskarraytype <= 0x6f);
if (isGetAllLD){
    ld = all_ld;
}else{
    ld = new TreeMap();
    Iterator  allLD = all_ld.keySet().iterator() ;
    while(allLD.hasNext()){
        String key = (String)allLD.next();
        String ld_num = (String)all_ld.get(key);
        int tmp_ldNo = Integer.valueOf(ld_num.substring(0,ld_num.length()-1),16).intValue();
         if (tmp_ldNo > 0xf) {
                    ld.put(key,ld_num);
          }
    }
}
if (ld.size() == 0){
    ld.put("","");
}
%>
<script>

String.prototype.trim = function()
{
    //return this.replace(/(^\s*)|(\s*$)/g, "");//modified by caoyh 2002/09/05
    return this.replace(/^\s*(\b.*\b|)\s*$/, "$1"); 
}
function confirmInfo()
{
    var ldnumber=document.forms[0].LDNo.options[document.forms[0].LDNo.selectedIndex].text;
    if (document.forms[0].ok.disabled)
        return false;
    if (ldnumber==null||ldnumber.trim()=="")
        return false;

    return true;
}
function initPage(){
    document.forms[0].ok.focus();
    var ldnumber=document.forms[0].LDNo.options[document.forms[0].LDNo.selectedIndex].text;
    if (ldnumber==null||ldnumber.trim()==""){
        
        document.forms[0].ok.disabled=true;
    }else{
        document.forms[0].ok.disabled=false;
    }
    document.forms[0].cancel.disabled=false;
}
</script>
<body onload="initPage();">

<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/logicdiskunbind/h2_ldunbind"/></h2>

<form method="post" onsubmit='if(confirmInfo()) {
   document.forms[0].action="<%=response.encodeURL("ldunbindconfirm.jsp")%>"; popup=window.open("/nsadmin/common/commonblank.html","popup","width=460,height=240,toolbar=no,menubar=no,resizable=yes,scrollbars=yes"); popup.focus(); document.forms[0].ok.disabled=true; document.forms[0].cancel.disabled=true;}else return false;' target="popup">
<table>

<tr>
<th align="left"><nsgui:message key="fcsan_componentconf/table/th_dan" /></th>
<td>:</td>
<td align="left"><%=request.getParameter("diskarrayname")%></td>
</tr>
<tr>
<th align="left"><nsgui:message key="fcsan_componentconf/logicdiskunbind/ldunbind_number" /></th>
<td>:</td>
<td align="left"><RankNo:select name="LDNo" options="<%=ld%>" /></td>
</tr>
</table>
<br>
<center>
<td><input type="submit"  name="ok" value="<nsgui:message key="common/button/submit" />" ></td>
<td><input type="button" name="cancel" value="<nsgui:message key="common/button/close" />" onclick="if (!this.disabled) window.close()"></td>
<input type="hidden" name="diskarrayid" value="<%=request.getParameter("diskarrayid")%>">
<input type="hidden" name="operation" value="unbind">
<input type="hidden" name="diskarrayname" value="<%=request.getParameter("diskarrayname")%>">
<input type="hidden" name="arraytype" value="<%=request.getParameter("arraytype")%>">
</center>
<input type="hidden" name="pdnum" value="<%=request.getParameter("pdnum")%>">
</form>
</body>
<%}%>
</html>

