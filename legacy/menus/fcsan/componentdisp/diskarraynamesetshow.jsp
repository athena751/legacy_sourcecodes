<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraynamesetshow.jsp,v 1.2302 2005/12/21 04:09:39 liyb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<HTML>
<HEAD>
<TITLE><nsgui:message key="fcsan_componentdisp/mod_diskarrayname/page_title"/></TITLE>
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
    if(!document.forms[0].ok.disabled){
        //delete by caoyh 2002-2002/9/27 for mail: nas 4636
        /*if (document.forms[0].diskname.value=="<%=request.getParameter("diskname")%>")
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/common/err_same_name"/>");
            return false;
        }*/
        //delete end
        // added by "yangah"
        //add by caoyh 2002-2002/9/27 for mail: nas 4636
        document.forms[0].diskname.value = document.forms[0].diskname.value.Rtrim();
        //add end 
        
        var diskoldname = "<%=request.getParameter("diskname")%>";
        var disknewname = document.forms[0].diskname.value;
        
        if(check(disknewname)==false || disknewname.length>32)
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/common/err_invalid_name"/>");
            return false;
        }else{
             
             var msg=<nsgui:message key="fcsan_componentdisp/mod_diskarrayname/msg_diskarraynamechangeconfirm" separate="true">
                        <nsgui:replacement value="diskoldname"/>
                        <nsgui:replacement value="disknewname"/>
                     </nsgui:message>;
             if(!confirm(msg)){ 
               return false;   
             } 
                  
             document.forms[0].ok.disabled = true;
             document.forms[0].cancel.disabled = true;

             return true;
        }
        return false;
    }
}

function check(str)
{
    var avail;
    if(str == "")
         return false;
    avail = /[^A-Za-z0-9_\/]/gi;
    ifFind = str.search(avail);
    return (ifFind==-1);
}

</script>

</HEAD>

<body onload="document.forms[0].ok.disabled = false;document.forms[0].cancel.disabled = false;">
<form method="post" onsubmit='if(onOk()) { popup=window.open("/nsadmin/common/commonblank.html","changename","width=600,height=200,toolbar=no,menubar=no,resizable=yes,scrollbars=yes"); popup.focus();}else return false;' target="changename" action="<%=response.encodeURL("diskarraynameset.jsp")%>">
 <h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
 <h2 class="popup"><nsgui:message key="fcsan_componentdisp/mod_diskarrayname/h2_name"/></h2>
 <%String diskid=request.getParameter("diskid");%> <%String diskname=request.getParameter("diskname");%> 
<table border="0">
      <tr align="left"> 
            <th><nsgui:message key="fcsan_componentdisp/table/table_id"/></th>
            <td>:</td>
            <td><%=diskid%></td>
      </tr>
      <tr align="left"> 
            <th> <nsgui:message key="fcsan_componentdisp/table/table_name"/></th>
            <td>:</td>
            <td> 
              <input type="text" name="diskname" value="<%=diskname%>" maxlength="32" >
            </td>
      </tr>
</table>
<br>
<input type="hidden" name="diskid" value="<%=diskid%>">
<center>
    <input type="submit" name="ok" value="<nsgui:message key="common/button/submit"/>"> 
    &nbsp;&nbsp;&nbsp;
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick='if(!this.disabled) window.close()'>
</center>
</form>
</body>
</html>

