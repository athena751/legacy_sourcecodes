<!--
        Copyright (c) 2401 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankbindtopmirror.jsp,v 1.2303 2004/08/14 11:01:23 changhs Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP" buffer="64kb"%>
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
    var raid1array = new Array (true , true , false , true , true , true , true , true , true , true , true , true , true , true , true , true , true);
    var raid5array = new Array (true , true , true , false , false , false , false , false , false , false , false , false ,false , false , false , false , true);
    var raid10array = new Array (true , true , true , true , false , true , false , true , false , true , false , true , false , true , false , true , true );
    var raidarray = new Array (raid1array , raid5array , raid10array ) ;
    
    function loadBottomframe() {
        parent.bottomframe.location="<%=response.encodeURL("rankbindbottom.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&arraytype=<%=arraytype%>";
    }
    
    function changeRaid(obj) {
        var boxCount = 0;
        var isEqualsPDNum = false;
        if(!(document.forms[0].pdno.length)) {
            if(document.forms[0].pdno.checked) {
                boxCount=boxCount+1;
            }
        }else{
        	var FC1PDNum = 0;
        	var FC2PDNum = 0;
            for(var i=0;i<document.forms[0].pdno.length;i++) {
                if (document.forms[0].pdno[i].checked) {
                	if (i < document.forms[0].firFCPDnum.value){
                		FC1PDNum++;
                	}else{
                		FC2PDNum++;
                	}
                    boxCount=boxCount+1;
                }
            }
            if (FC1PDNum == FC2PDNum){
            	isEqualsPDNum = true;
            }
        }
        
        if(!parent.frames[1].document.forms[0] || !parent.frames[1].document.forms[0].raidtype) {
            return;
        }
        
        if (boxCount > 15) {
            alert("<nsgui:message key="fcsan_componentconf/rankbind/msg_maxpd"/>") ; 
            obj.checked = false ;
        } else {
        	if(isEqualsPDNum){
        		document.forms[0].equalsPDNum.value="true";
        	}else{
        	    document.forms[0].equalsPDNum.value="false";
        	}
        	parent.frames[1].document.forms[0].raidtype[0].disabled = raidarray[0][boxCount];
            parent.frames[1].document.forms[0].raidtype[2].disabled = raidarray[2][boxCount];
            parent.frames[1].document.forms[0].raidtype[1].disabled = raidarray[1][boxCount];
        }
        
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

boolean inFirstFc = true; 
int firFCPDnum = 0;
int	firFCDENum = 0;
int lastDENum = 0;
int size=PDStringVec.size();
int firstDENum = Integer.parseInt(pdgroupnumber)*2;

//find the First FC's last DE number
String tmpFirFCLastPDNum = "00";
String tmpPDNum = "00";
for(int i = 0; i < PDStringVec.size(); i++){
	tmpPDNum = (String)PDStringVec.get(i);
	if (!tmpPDNum.equals("##") && Integer.parseInt(tmpPDNum, 16) < 0x70){
		tmpFirFCLastPDNum = tmpPDNum;
	}
}

firFCDENum = Integer.parseInt(tmpFirFCLastPDNum.substring(0,1));
int loop=size/15;
int position;
%>

<table cellspacing="0" cellpadding="0">
<tr><td valign=top>
	<table cellspacing="0" cellpadding="0" border="0">
	<tr><td colspan=7>&nbsp;<nsgui:message key="fcsan_componentconf/ranksparemiddleleft/fc_loop0"/><br></td></tr>
<%
String displayValue;
String displayColor;
String DENum = "00";
int secFCDENum = (loop-1) - 8;
for(int i=0;i<loop;i++){
	if (i > firFCDENum && i < 8 ){
		continue;
	}
	if(inFirstFc && i >= 8){
	    //for (int k = 0; k < secFCDENum - firFCDENum; k++){
	    //fill the excess rows in first FC
		%><!--
		 <tr>
		 <td>&nbsp;</td>
		 <td>
    		    <table cellspacing="0" cellpadding="0" border="0">
    		    <tr><td>
    		        <table border=0 height=63>
    		        <tr><td width=22></td></tr>
    		        <tr><td width=22></td></tr>
    		        </table>
    		    </td></tr>
    		    <tr><td>
        		    <table border=0 height=63>
        		    <tr><td width=22></td></tr>
        		    <tr><td width=22></td></tr>
        		    </table>
    		    </td></tr>
    		    </table>
		 </td>
		 </tr>-->
		<%//}%>
		</table>
		</td><td>&nbsp;&nbsp;</td><td  valign=top>
		<table cellspacing="0" cellpadding="0" border="0">
		<tr><td colspan=7><nsgui:message key="fcsan_componentconf/ranksparemiddleleft/fc_loop1"/><br></td></tr>
		<%inFirstFc = false;
		lastDENum = 0;
		firstDENum++;
	}
	DENum =Integer.toHexString(firstDENum) 
		+  Integer.toHexString(lastDENum);
	lastDENum++;
%>
<tr>
<td><%=DENum%>&nbsp;</td>
<td valing=top><table cellspacing="0" cellpadding="0" border="1"><tr>
<%
    for(int j=0;j<15;j++)
    {
        if(j == 8){%>
        </tr></table><table cellspacing="0" cellpadding="0" border="1"><tr>
        <%}
        position=i*15+j;
        displayValue=(String)(PDStringVec.get(position));
        displayColor=(String)(PDColorVec.get(position));
        if(displayValue.equals("##"))
        {
            displayColor="#CCCCCC";
            displayValue="&nbsp;";
%>
        <td>
            <table height=50>
                <tr><td width=22>&nbsp;&nbsp;&nbsp;</td></tr>
                <tr><td width=22><%=displayValue%></td></tr>
            </table>
        </td>
<%
        } else if(!(displayColor.equals("#FFFFFF"))){
        	if(inFirstFc)
	        	firFCPDnum++;
            displayColor="#CCCCCC";
%>
            <td>
                <table height=50>
                <tr><td bgcolor=<%=displayColor%> width=22><input type="checkbox"  disabled name="pdno" value="<%=displayValue%>" onClick="disableCheckbox(this)"></td></tr>
                <tr><td bgcolor=<%=displayColor%> width=22><%=displayValue%></td></tr>
                </table>
           </td>
<%
        }else{
        	if(inFirstFc)
        		firFCPDnum++;
            displayColor="white";
%>
        <td>
            <table height=50>
            <tr><td bgcolor=<%=displayColor%> width=22><input type="checkbox" name="pdno" id=<%=displayValue%> value=<%=displayValue%> onClick="changeRaid(this)"></td></tr>
            <tr><td bgcolor=<%=displayColor%> width=22><label for=<%=displayValue%>><%=displayValue%></label></td></tr>
            </table>
        </td>
<%
        }
        //if (j == 14){
        //fill the excess cell.
        %>
        <!--<td>
            <table height=35>
            <tr><td width=22>&nbsp;</td></tr>
            <tr><td width=22>&nbsp;</td></tr>
            </table>
        </td>-->
        <%
       //}
    }//end for 2
%>
</tr></table></td>
</tr>
<%
} //end for 1
%>
<%
//for (int k = 0; k < firFCDENum - secFCDENum; k++){
  //fill the excess rows in second FC
		%><!--
		 <tr>
		 <td>&nbsp;</td>
		 <td>
    		    <table cellspacing="0" cellpadding="0" border="0">
    		    <tr><td>
    		        <table border=0 height=63>
    		        <tr><td width=22></td></tr>
    		        <tr><td width=22></td></tr>
    		        </table>
    		    </td></tr>
    		    <tr><td>
        		    <table border=0 height=63>
        		    <tr><td width=22></td></tr>
        		    <tr><td width=22></td></tr>
        		    </table>
    		    </td></tr>
    		    </table>
		 </td>
		 </tr>-->
<%//}%>
</table>
</td></tr>
</table>
	<input type=hidden name=firFCPDnum value=<%=firFCPDnum%>>
	<input type=hidden name=equalsPDNum value="">
	
</form>
</body>
</html>

