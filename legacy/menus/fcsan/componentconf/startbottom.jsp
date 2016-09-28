<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: startbottom.jsp,v 1.2301 2004/07/14 08:42:44 nsadmin Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,java.lang.*,java.util.*,com.nec.sydney.framework.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="bottomBean" class="com.nec.sydney.beans.fcsan.componentconf.StratbottomBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = bottomBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<script src="../../../menu/nas/common/general.js"></script>
<%
  String diskarrayname = request.getParameter("diskarrayname");
  String pdgroupnumber = request.getParameter("pdgroupnumber");
  String ranknumber = request.getParameter("ranknumber");
  String rebuildingtime = request.getParameter("rebuildingtime");
  Vector sparenumbers = bottomBean.getSparenumbers();
  Vector pdnumbers = bottomBean.getPdnumbers();
%>
<html>
<head>
<title><nsgui:message key="fcsan_componentconf/rebuildingstart/title_rsi"/></title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<script language="JavaScript">
function defaultstate()
{
    document.forms[0].ok.focus()
    if(<%=(sparenumbers.size())%>==0)
    {
        document.forms[0].radiobutton[1].disabled=true;
        document.forms[0].radiobutton[2].disabled=true;
        document.forms[0].radiobutton[0].disabled=false;
        document.forms[0].radiobutton[0].checked=true;
        document.forms[0].pdnumber.disabled=false;
        document.forms[0].sparenum.disabled=true;
        document.forms[0].autosparenum.disabled=true;
        document.forms[0].commandid.value="rp1"
        onTarget(document.forms[0].radiobutton[0])
    }
    else{
        document.forms[0].radiobutton[2].checked=true;
        document.forms[0].pdnumber.disabled=true;
        document.forms[0].sparenum.disabled=true;
        document.forms[0].autosparenum.disabled=false;
        document.forms[0].commandid.value="rs"
        onTarget(document.forms[0].radiobutton[2])
    }
    //onTarget()
}

function disableselect0()
{
        if(document.forms[0].radiobutton[1].checked){
                document.forms[0].pdnumber.blur();
        }
        if(document.forms[0].radiobutton[2].checked){
                document.forms[0].pdnumber.blur();
        }
}
function disableselect1()
{
        if(document.forms[0].radiobutton[0].checked){
                document.forms[0].sparenum.blur();
        }
        if(document.forms[0].radiobutton[2].checked){
                document.forms[0].sparenum.blur();
        }
}


function disableselect2()
{
        if(document.forms[0].radiobutton[0].checked){
                document.forms[0].autosparenum.blur();
        }
        if(document.forms[0].radiobutton[1].checked){
                document.forms[0].autosparenum.blur();
        }
}

function onTarget(radio)
{

    if(radio.disabled){
        radio.checked=false;
        return false;
    }
    if(document.forms[0].radiobutton[0].checked)
     {
        document.forms[0].pdnumber.disabled=false;
        document.forms[0].sparenum.disabled=true;
        document.forms[0].autosparenum.disabled=true;
        document.forms[0].commandid.value="rp1";
    }
    if(document.forms[0].radiobutton[1].checked)
     {
        document.forms[0].autosparenum.disabled=true;
        document.forms[0].pdnumber.disabled=true;
        document.forms[0].sparenum.disabled=false;
        document.forms[0].commandid.value="rp2";
    }
    if(document.forms[0].radiobutton[2].checked)
     {
        document.forms[0].sparenum.disabled=true;
        document.forms[0].pdnumber.disabled=true;
        document.forms[0].autosparenum.disabled=false;
        document.forms[0].commandid.value="rs"
    }
    
}

function onOk()
{
    var win;
    if(document.forms[0].ok.disabled==true)
                return false;
    if(document.forms[0].commandid.value=="rp1"){
        if(confirm("<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_confirm"/>"+"\n\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_dan"/>"+" : <%=diskarrayname%>\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_pdg"/>"+" : <%=pdgroupnumber%>h\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_rn"/>"+" : <%=ranknumber%>\n"+
                   "<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_rx"/>"+" : "+document.forms[0].pdnumber.options[document.forms[0].pdnumber.selectedIndex].value+"\n"+
                   "<nsgui:message key="fcsan_componentconf/common/h3_rt"/>"+" : "+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value))
        {            document.forms[0].ok.disabled=true;
            document.forms[0].cancel.disabled=true;
            parent.frames[0].document.forms[0].Button.disabled=true;
            win=parent.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&ranknumber=<%=ranknumber%>&pdnumber="+document.forms[0].pdnumber.options[document.forms[0].pdnumber.selectedIndex].value+"&rebuildingtime="+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value+"&commandid="+document.forms[0].commandid.value+"&target_jsp="+document.forms[0].target_jsp.value,"rebuildingstart","toolbar=no,menubar=no,resizable=yes,width=600,height=200")
            win.focus();
        }
    }else if(document.forms[0].commandid.value=="rp2"){
        if(confirm("<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_confirm"/>"+"\n\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_dan"/>"+" : <%=diskarrayname%>\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_pdg"/>"+" : <%=pdgroupnumber%>h\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_rn"/>"+" : <%=ranknumber%>\n"+
"<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_rx"/>"+" : "+<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_spare" firstReplace="document.forms[0].sparenum.options[document.forms[0].sparenum.selectedIndex].value" separate="true"/>+"\n"+
                   "<nsgui:message key="fcsan_componentconf/common/h3_rt"/>"+" : "+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value))    
        {
            document.forms[0].ok.disabled=true;
            document.forms[0].cancel.disabled=true;
            parent.frames[0].document.forms[0].Button.disabled=true;
           win= parent.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&ranknumber=<%=ranknumber%>&pdnumber="+document.forms[0].sparenum.options[document.forms[0].sparenum.selectedIndex].value+"&rebuildingtime="+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value+"&commandid="+document.forms[0].commandid.value+"&target_jsp="+document.forms[0].target_jsp.value,"rebuildingstart","toolbar=no,menubar=no,resizable=yes,width=600,height=200")
           win.focus();
        }
    }else if(document.forms[0].commandid.value=="rs"){
        if(confirm("<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_confirm"/>"+"\n\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_dan"/>"+" : <%=diskarrayname%>\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_pdg"/>"+" : <%=pdgroupnumber%>h\n"+
                   "<nsgui:message key="fcsan_componentconf/table/th_rn"/>"+" : <%=ranknumber%>\n"+
                   "<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_ry"/>"+" : "+document.forms[0].autosparenum.options[document.forms[0].autosparenum.selectedIndex].value+"\n"+
                   "<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_rx"/>"+" : "+"<nsgui:message key="fcsan_componentconf/rebuildingstart/msg_auto"/>"+"\n"+
                   "<nsgui:message key="fcsan_componentconf/common/h3_rt"/>"+" : "+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value))    
        {
            
            document.forms[0].ok.disabled=true;
            document.forms[0].cancel.disabled=true;            
            parent.frames[0].document.forms[0].Button.disabled=true;
            
           win=parent.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&ranknumber=<%=ranknumber%>&pdnumber="+document.forms[0].autosparenum.options[document.forms[0].autosparenum.selectedIndex].value+"&rebuildingtime="+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value+"&commandid="+document.forms[0].commandid.value+"&target_jsp="+document.forms[0].target_jsp.value,"rebuildingstart","toolbar=no,menubar=no,resizable=yes,width=600,height=200")
           win.focus();
        }
    }

}
</script>
</head>
<%
  int i = 0;
  if(bottomBean.getResult()!=0){
%>
<body>
    <form>
    <%if(bottomBean.setSpecialErrMsg()) {%>
        <h2 class="popup"><%=bottomBean.getErrMsg()%></h2>       
    <%}else{%>
        <h1 class="popupError"><nsgui:message key="fcsan_componentconf/rebuildingstart/msg_rankerr"/></h1>
        <h2 class="popupError"><%=bottomBean.getErrMsg()%></h2>
    <%}%>
<center> 
<input type="button" name="close" value="<nsgui:message key="common/button/close"/>" onClick="parent.close()">
</center> 
    </form>
</body>
<%}else{%>
<body onload="defaultstate()" onResize="resize()">
<form method="post">
<input type="hidden" name="commandid">
  <h3 class="popup"><nsgui:message key="fcsan_componentconf/rebuildingstart/h3_info"/></h3>
  
<table border="0">
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_dan"/></th>
      <td>:</td>
      <td><%=diskarrayname%></td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_pdg"/></th>
      <td>:</td>
      <td><%=pdgroupnumber%>h</td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="fcsan_componentconf/table/th_rn"/></th>
      <td>:</td>
      <td><%=ranknumber%></td>
    </tr>
  </table>
  <br>
  <h3 class="popup"><nsgui:message key="fcsan_componentconf/table/td_tpd"/></h3>
 
  <table border="0">
    <tr> 
      <td> 
        <input id="radio1" type="radio" name="radiobutton" value="radiobutton" onclick="return onTarget(this)">
      </td>
      <th align="left"><label for="radio1"><nsgui:message key="fcsan_componentconf/table/td_pdr"/></th></label>
      <td>:</td>
      <td>
        <select name="pdnumber" onfocus="disableselect0()">
        <%
          for(i=0;i<pdnumbers.size();i++){%>
          <option value="<%=(String)pdnumbers.get(i)%>"><%=(String)pdnumbers.get(i)%></option>
        <%}%>
        </select>
      </td>
    </tr>
    <tr> 
      <td> 
        <input id="radio2" type="radio" name="radiobutton" value="radiobutton" onclick="return onTarget(this)">
      </td>
      <th align="left"><label for="radio2"><nsgui:message key="fcsan_componentconf/table/td_sdr"/></label></th>
      <td>:</td>
      <td> 
        <select name="sparenum" onfocus="disableselect1()">
        <%if(sparenumbers.size()!=0){
          for(i=0;i<sparenumbers.size();i++){%>
          <option value="<%=(String)sparenumbers.get(i)%>"><%=(String)sparenumbers.get(i)%></option>
        <%}
        }%>
        </select>
      </td>
    </tr>
    <tr> 
          <td> 
        <input id="radio3" type="radio" name="radiobutton" value="radiobutton" onclick="return onTarget(this)">
      </td>
      <th colspan="3"><label for="radio3"><nsgui:message key="fcsan_componentconf/table/td_ar"/></label></th>
    </tr>
    <tr> 
      <td></td>
      <th>&nbsp;<nsgui:message key="fcsan_componentconf/table/td_bpd"/></th>
      <td>:</td>
      <td> 
        <select name="autosparenum" onfocus="disableselect2()">
          <%
          for(i=0;i<pdnumbers.size();i++){%>
          <option value="<%=(String)pdnumbers.get(i)%>"><%=(String)pdnumbers.get(i)%></option>
        <%}%>
        </select>
      </td>
    </tr>
  </table>
  
  <h3 class="popup"><nsgui:message key="fcsan_componentconf/common/h3_rt"/></h3>
    <nsgui:message key="fcsan_componentconf/rebuildingstart/msg_specify"/>
  <table>
  <tr>
  <th align="left">
  <nsgui:message key="fcsan_componentconf/common/msg_rt"/>
  </th>
      <td>:</td>
  <td>
  <select name="rebuildingtime">
    <%for(i=0;i<=24;i++){
        Integer rtime = new Integer(i);
        if(rtime.toString().equals(rebuildingtime)){%>
    <option selected value=<%=i%>><%=i%></option>
      <%}else{%>
    <option value=<%=i%>><%=i%></option>
    <%}}%>
  </select>
  <nsgui:message key="fcsan_componentconf/common/hour"/>
  </td>
  </tr>
  </table>
            <br>
  <center> 
    <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onClick="onOk()">
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="if(!this.disabled) parent.close()">
      <input type="hidden" name="target_jsp" value="../componentconf/rebuildingstart.jsp">
  </center>
</form>
</body>
<%}%>
</html>
