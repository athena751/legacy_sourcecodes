<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankbindtop.jsp,v 1.2302 2004/08/14 11:01:23 changhs Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="PDAndRankListBean" class="com.nec.sydney.beans.fcsan.componentconf.PDAndRankListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=PDAndRankListBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<%PDAndRankListBean.setPDVec();%>
<%
String diskarrayname=request.getParameter("diskarrayname");
String diskarrayid = request.getParameter("diskarrayid");
String pdgroupnumber=request.getParameter("pdgroupnumber");
String arraytype = request.getParameter("arraytype");
int intArrayType = Integer.parseInt(arraytype.substring(0,2),16);
boolean multiMach ; 
if (intArrayType >= 0x50 && intArrayType <= 0x6f ) {
    multiMach = true;
} else {
    multiMach = false;
}
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
    var raid0array = new Array (true , false , true , false , true , false , true ,true , true , true , false , true , true , true , true , false , true);
    var raid1array = new Array (true , true , false , true , true , true , true , true , true , true , true , true , true , true , true , true , true);
    var raid3array = new Array (true , true , true , false , true , false , true , true , true , false , true , true , true , true , true , true , true);
    var raid5array = new Array (true , true , true , false , false , false , false , false , false , false , false , false ,false , false , false , false , true);
    var raid10array = new Array (true , true , true , true , false , true , false , true , false , true , false , true , false , true , false , true , true );
    //var raidarray = new Array ( raid0array , raid1array , raid3array , raid5array , raid10array ) ;  
    var raidarray = new Array ( raid0array , raid1array , raid5array , raid10array ) ;
    
    function loadBottomframe() {
        parent.bottomframe.location="<%=response.encodeURL("rankbindbottom.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&arraytype=<%=arraytype%>";
    }
    
    function changeRaid(obj) {
        var boxCount=0;
        
        if(!(document.forms[0].pdno.length)) {
            if(document.forms[0].pdno.checked) {
                boxCount=boxCount+1;
            }
        }else{
            for(var i=0;i<document.forms[0].pdno.length;i++) {
                if (document.forms[0].pdno[i].checked) {
                    boxCount=boxCount+1;
                }
            }
        }
        
        if(!parent.frames[1].document.forms[0] || !parent.frames[1].document.forms[0].raidtype) {
            return;
        }
        
        <% if (!multiMach) { %>
            if (boxCount > 15) {
                alert("<nsgui:message key="fcsan_componentconf/rankbind/msg_maxpd"/>") ; 
                obj.checked = false ;
            } else {
                parent.frames[1].document.forms[0].raidtype[0].disabled = raidarray[0][boxCount];
                parent.frames[1].document.forms[0].raidtype[1].disabled = raidarray[1][boxCount];
                parent.frames[1].document.forms[0].raidtype[2].disabled = raidarray[2][boxCount];
                parent.frames[1].document.forms[0].raidtype[3].disabled = raidarray[3][boxCount];
                //parent.frames[1].document.forms[0].raidtype[4].disabled = raidarray[4][boxCount];
            }
        <% } else { %>
            if (boxCount > 15) {
                alert("<nsgui:message key="fcsan_componentconf/rankbind/msg_maxpd"/>") ; 
                obj.checked = false ;
            } else {
                parent.frames[1].document.forms[0].raidtype[1].disabled = raidarray[2][boxCount];
                <%if(session.getAttribute(FCSANConstants.SESSION_DISK_MODEL).equals("0")){%>
                    parent.frames[1].document.forms[0].raidtype[0].disabled = raidarray[1][boxCount];
                    parent.frames[1].document.forms[0].raidtype[2].disabled = raidarray[3][boxCount];
                <%}else{%>
                    parent.frames[1].document.forms[0].raidtype[0].disabled = true;
                    parent.frames[1].document.forms[0].raidtype[2].disabled = true;
                <%}%>
            }
            
        <% } %>
        for (var i=0 ; i<parent.frames[1].document.forms[0].raidtype.length ; i++) {
            if (parent.frames[1].document.forms[0].raidtype[i].disabled) {
                parent.frames[1].document.forms[0].raidtype[i].checked = false;
            }
        }
    }
    
    function disableCheckbox(obj) {
        obj.disabled=true;
        if(obj.disabled) {
            obj.checked=false;
            //return false;
        }
    }
</script>
</head>

<body onLoad="loadBottomframe()">
<% if (((String)session.getAttribute(FCSANConstants.SESSION_RANK_BIND_FROM)).equals("fcsan")){%>
    <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<%}else{%>
    <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_volume"/></h1>
<%}%>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rankbindtop/h2_rankbind"/></h2>

<h3 class="popup"><nsgui:message key="fcsan_componentconf/rankbindtop/pd"/></h3>
<form method="post">
<%
Vector PDStringVec=PDAndRankListBean.getPDStringVec();

Vector PDColorVec=PDAndRankListBean.getPDColorVec();
int size=PDStringVec.size();
int loop=size/15;
int position;
%>

<table cellspacing="0" cellpadding="0">
<tr>

<td>
<table cellspacing="0" >
<%
for (int i=0;i<loop;i++)
{
%>
<tr><td>
<table cellspacing="0" cellpadding="3">
<tr><td>&nbsp;</td></tr>
<%
int firDENum = 0;
if(session.getAttribute(FCSANConstants.SESSION_DISK_MODEL).equals("0")){
    firDENum = Integer.parseInt(pdgroupnumber.substring(1,2));
}else{
    firDENum = Integer.parseInt(pdgroupnumber.substring(1,2))*2;
}
%>
<tr><td><%=(Integer.toHexString(firDENum) + Integer.toHexString(i))%></td></tr>
</table>
</td></tr>
<%
}
%>
</table>
</td>

<td>
<table cellspacing="0" cellpadding="0" border="1">
<%
String displayValue;
String displayColor;
for(int i=0;i<loop;i++)
{
%>

<tr>
<%
    for(int j=0;j<15;j++)
    {
        position=i*15+j;
        displayValue=(String)(PDStringVec.get(position));
        displayColor=(String)(PDColorVec.get(position));
        if(displayValue.equals("##"))
        {
            //displayColor="gray";
            displayColor="#CCCCCC";
            displayValue="&nbsp;";
%>
        <td><table ><tr><td >&nbsp;</td></tr><tr><td  ><%=displayValue%></td></tr></table></td>
<%
        }
        else
        {
            if(!(displayColor.equals("#FFFFFF")))
            {
                //displayColor="gray";
                displayColor="#CCCCCC";
%>
            <td><table  ><tr><td bgcolor=<%=displayColor%> ><input type="checkbox"  disabled name="pdno" value="<%=displayValue%>" onClick="disableCheckbox(this)"></td></tr><tr><td bgcolor=<%=displayColor%>><%=displayValue%></td></tr></table></td>
<%
            }
            else
            {
                displayColor="white";

%>
            <td><table><tr><td bgcolor=<%=displayColor%> ><input type="checkbox" name="pdno" id=<%=displayValue%> value=<%=displayValue%> onClick="changeRaid(this)"></td></tr><tr><td bgcolor=<%=displayColor%> ><label for=<%=displayValue%>><%=displayValue%></label></td></tr></table></td>
<%
            }
                    
%>
<%
        }//end else
%>
<%
    }//end for 2
%>
</tr>
<%
} //end for 1
%>
</table>
</td>

</tr>
</table>
</form>
</body>
</html>

