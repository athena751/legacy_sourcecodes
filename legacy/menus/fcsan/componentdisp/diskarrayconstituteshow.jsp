<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
 

<!-- "@(#) $Id: diskarrayconstituteshow.jsp,v 1.2305 2005/12/26 11:33:45 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.framework.*,com.nec.sydney.atom.admin.base.*,java.util.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="constituteBean" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayConstituteBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = constituteBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@ include file="../common/displaycharstylejs.jsp"%>
<%
      String diskid=request.getParameter("diskid");
      String diskname=request.getParameter("diskname");
      String diskarraytype = request.getParameter("arraytype");
      if (diskarraytype != null)
          session.setAttribute("diskarraytype",diskarraytype);
%>
<HTML>
<HEAD>
<!--TITLE><nsgui:message key="fcsan_ctrlandencl/common/page_title"/></TITLE-->
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javascript">
var diskarrayname="<%=diskname%>";
function onRefresh()
{
    if(document.forms[0].diskarrayname)
        diskarrayname=document.forms[0].diskarrayname.value;
  window.location='<%=response.encodeURL("diskarrayconstituterefresh.jsp")%>?diskArrayID=<%=diskid%>&diskname='+diskarrayname;
}

function disableButton()
{
 var n=4;
 for(var i=0; i<4 && n==4; i++)
 {
   if(document.constituteform.radiobutton && document.constituteform.radiobutton[i].checked)
      n=i;
 }
   if(n==4)
   {
     document.constituteform.constitute.disabled=true;
   }else{
       document.constituteform.constitute.disabled=false;
        }
}
function onBack()
{
    window.location="<%=response.encodeURL("diskarraylist.jsp")%>";
}

function onConstitute()
{
   var n=4;
   for(var i=0; i<n && n==4; i++)
   {
   if(document.constituteform.radiobutton[i].checked)
      n=i;
   } 
    if(document.forms[0].diskarrayname)
        diskarrayname=document.forms[0].diskarrayname.value;

   if(n==0){
   window.location='<%=response.encodeURL("ldconstitute.jsp")%>?diskArrayID=<%=diskid%>&diskname='+diskarrayname;
   }
   if(n==1){   
   window.location='<%=response.encodeURL("diskarraypdlist.jsp")%>?diskArrayID=<%=diskid%>&diskname='+diskarrayname;
   }
   if(n==2){
   window.location='<%=response.encodeURL("controllerlist.jsp")%>?diskArrayID=<%=diskid%>&diskname='+diskarrayname;
   }
   if(n==3){
   window.location='<%=response.encodeURL("enclosurelist.jsp")%>?diskArrayID=<%=diskid%>&diskname='+diskarrayname; 
   }
   if(n==4){
        return false;
   }
}
</script>
</HEAD>

<body onLoad="disableButton()">
<form name="constituteform">
<h1 class="title"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<input type="button" name="Button" value="<nsgui:message key="common/button/reload"/>" onclick="onRefresh()">
<h2 class="title"><nsgui:message key="fcsan_componentdisp/constitute/constitution"/></h2>

<%
if(constituteBean.getResult()!=0){
%>
<h3 class="title"><nsgui:message key="fcsan_componentdisp/table/table_diskarrayname" />&nbsp;:&nbsp;<%=diskname%></h3>
<hr>
<%
    int errorCode=constituteBean.getErrorCode();
    if(constituteBean.setSpecialErrMsg()) {
%>
   	
<h2 class="title"><%=constituteBean.getErrMsg()%></h2> 
    <%} else { %>
<h1 class="Error"><nsgui:message key="fcsan_componentdisp/constitute/msg_failed"/></h1>
<h2 class="Error"><%=constituteBean.getErrMsg()%></h2>

<%}
%>
       <br><br><br><br><br><br><br>
<%
}else{
      DiskArrayInfo diskarrayinfo = constituteBean.getDiskArrayinfo();
      diskname = constituteBean.getDiskArrayName();
%>
<input type="hidden" name="diskarrayname" value="<%=diskname%>">
<h3 class="title"><nsgui:message key="fcsan_componentdisp/table/table_diskarrayname" />&nbsp;:&nbsp;<%=diskname%></h3>
<hr>
<%     if(diskarrayinfo != null) {
        Vector type = diskarrayinfo.getComponentTypes();
        Vector portstate = diskarrayinfo.getComponentStates();
        Vector cnt = diskarrayinfo.getEntryCounts();
%>


<table border="1">
    <tr> 
      <th>&nbsp;</th>
      <th ><nsgui:message key="fcsan_componentdisp/table/table_type"/></th>
      <th ><nsgui:message key="fcsan_componentdisp/table/table_state"/></th>
      <th ><nsgui:message key="fcsan_componentdisp/table/table_count"/></th>
    </tr>
    <%for(int i=0;i<type.size();i++){%>
    <tr align="center"> 
      <td> 
        <!--<input type="radio" name="radiobutton" value="radiobutton"  OnClick="enablebutton()">-->
        <input type="radio" name="radiobutton" value="radiobutton" <%if(i==0) out.print("checked");%> <%if(((String)cnt.get(i)).equals("0") && i!=0) out.print("disabled");%> >
      </td>
      <td ><%=(String)type.get(i)%></td>
      <td >
                        <script>
            display("<%=(String)portstate.get(i)%>","<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+(String)portstate.get(i))%>")
                        </script>
            
      </td>
      <td ><%=(String)cnt.get(i)%></td>
    </tr>
    <%}%>
  </table>
  <%} else {%>
       <h2 class="title"><nsgui:message key="fcsan_componentdisp/constitute/msg_failed" /></h2>
       <br><br><br><br><br><br><br>
  <%}
}%>
  <br>
  <br>
  <hr>
    <input type="button" name="constitute" value="<nsgui:message key="fcsan_common/button/button_go"/>" onClick="onConstitute()">
</form>
</body>

</html>

