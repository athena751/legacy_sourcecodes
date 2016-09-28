<!--
        Copyright (c) 2001-2005 NEC Corporation
 
        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
 

<!-- "@(#) $Id: ldtypeandnameshow.jsp,v 1.2302 2005/09/21 04:53:50 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<HTML>
<HEAD>
<TITLE><nsgui:message key="fcsan_componentdisp/mod_ldname/page_title"/></TITLE>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="JavaScript">
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
var win;
function onOk()
{
    if(!document.forms[0].ok.disabled)
        var confirmok=1;
    //delete by caoyh 2002-2002/9/27 for mail: nas 4636
       /* if (document.ldtypeandnameform.name.value=="<%=request.getParameter("ldName")%>" && document.ldtypeandnameform.type.options[document.ldtypeandnameform.type.selectedIndex].value=="<%=request.getParameter("ldType")%>")
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/mod_ldname/newname"/>");
            return false;
        } */
        //delete end
        //add by caoyh 2002-2002/9/27 for mail: nas 4636
        document.ldtypeandnameform.name.value = document.ldtypeandnameform.name.value.Rtrim();
        //add end        
        if((check(document.ldtypeandnameform.name.value)==false) || (document.ldtypeandnameform.name.value.length>24))
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/mod_ldname/invalidname"/>");
            return false;
//        }else if(document.ldtypeandnameform.name.value.length>24){
//            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/mod_ldname/invalidname"/>");
//            return false;
        }else {
             if(!(document.ldtypeandnameform.type.options[document.ldtypeandnameform.type.selectedIndex].value=="<%=request.getParameter("ldType")%>")){
                  if(!(confirm("<nsgui:message key="fcsan_componentdisp/mod_ldname/confirm"/>"))){
                        confirmok=0;
                  }
             }
             if (confirmok==1){
                    document.forms[0].ok.disabled = true;
                    document.forms[0].cancel.disabled = true;

                    return true;
            }
         }
}

function changeLength()
{
    document.forms[0].type.options[document.forms[0].type.selectedIndex].text = document.forms[0].type.options[document.forms[0].type.selectedIndex].text + "    ";
}

function check(str)
{
 var avail
    if(str == "")
         return false;
    avail = /[^A-Za-z0-9_\/]/gi;
    ifFind = str.search(avail);
    return (ifFind==-1);
}

</script>
</HEAD>

<body onLoad="changeLength()">
<!--form name="ldtypeandnameform" onsubmit="return false;"-->
<form  name="ldtypeandnameform" method="post" onsubmit='if(onOk()) { popup=window.open("/nsadmin/common/commonblank.html","changeldname","width=600,height=200,toolbar=no,menubar=no,resizable=yes,scrollbars=yes"); popup.focus();}else return false;' target="changeldname" action="<%=response.encodeURL("ldtypeandnameset.jsp")%>">

<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentdisp/mod_ldname/ldtypeandnameshow"/></h2>
  <%String diskArrayID=request.getParameter("diskArrayID");%>
  <%String ldID=request.getParameter("ldID");%>
  <%String ldName=request.getParameter("ldName");%>
  <%String ldType=request.getParameter("ldType");%>
  <%
        String diskArrayType = (String)session.getAttribute("diskarraytype");
        int diskarraytype = Integer.valueOf(
            diskArrayType.substring(0,diskArrayType.length()-1),16).intValue();
        String[] type;
        //if (diskarraytype >= 0x50 && diskarraytype <= 0x6f ){
                String[] typeComplex = {"LX"};
                type = typeComplex;
         //}else{
         //       String[] typeCommon = {"LX","AX","A4","A2","NX","WN","CX"};
         //       type = typeCommon;
         //}
  %>
<table border="0" >
      <tr align="left"> 
        <th><nsgui:message key="fcsan_componentdisp/table/table_ldnum"/></th>
        <td>:</td>
        <td><%=ldID%></td>
      </tr>
      <tr align="left"> 
        <th><nsgui:message key="fcsan_componentdisp/table/table_ostype"/></th>
        <td>:</td>
        <td>
          <select name="type">
          <%
            boolean isListType = false;
            for(int i=0;i<type.length;i++) {
                if(type[i].equals(ldType)) {
                    isListType = true;
          %>
            <option value="<%=type[i]%>" selected><%=type[i]%></option> 
          <%   } else {%>                 
            <option value="<%=type[i]%>"><%=type[i]%></option>
            <%}%>
          <%}
           if(!isListType) {%>
          <script>
                document.forms[0].type.options[0].selected = true;
          </script> 
          <%}%>
          </select>
        </td>
      </tr>
      <tr align="left"> 
      <th><nsgui:message key="fcsan_componentdisp/table/table_ldn"/></th>
        <td>:</td>
        <td>
          <input type="text" name="name" value="<%=ldName%>" maxlength="24">
        </td>
      </tr>
</table>
<br>
<input type="hidden" name="diskid" value="<%=diskArrayID%>">
<input type="hidden" name="ldID" value="<%=ldID%>">
<center>        
   <input type="submit" name="ok" value="<nsgui:message key="common/button/submit"/>"> 
    &nbsp;&nbsp;&nbsp;
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick='if(!this.disabled) window.close()'>
</center>
</form>
</body>
</html>

