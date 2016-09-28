<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankbindbottom.jsp,v 1.2302 2005/05/27 00:56:34 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="PDAndRankListBean" class="com.nec.sydney.beans.fcsan.componentconf.PDAndRankListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=PDAndRankListBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<%
String diskarrayname=request.getParameter("diskarrayname");
String pdgroupnumber=request.getParameter("pdgroupnumber");
String diskarrayid = request.getParameter("diskarrayid");
String arraytype = (request.getParameter("arraytype"));

int intArrayType = Integer.parseInt(arraytype.substring(0,arraytype.length()-1),16);
boolean multiMach ; 
if (intArrayType >= 0x50 && intArrayType <= 0x6f ) {
    multiMach = true;
} else {
    multiMach = false;
}
%>
<%
String rankno;

PDAndRankListBean.setRankVec();
Vector rankStringVec=PDAndRankListBean.getRankStringVec();
int size=rankStringVec.size();
String ranknoTmp;
int ranknoTmpInt;

int i, j=0;
if(multiMach && pdgroupnumber.equals("00"))
    i = 2;
else
    i = 0;

while(j<size && i<=0x3f )
{
    ranknoTmp=(String)rankStringVec.get(j);
    ranknoTmpInt=Integer.parseInt(ranknoTmp ,16);
    if (multiMach && pdgroupnumber.equals("00") && ranknoTmpInt < 2){
        j++;
        continue;
    }
    if( i == ranknoTmpInt )
    {
        i++;
        j++;
    }else{
        break;
    }
}
if ( i <= 0x3f){
    rankno=Integer.toHexString(i);
    if(rankno.length()==1)
    {
        rankno="0"+rankno;
    }
}else{
    rankno="&nbsp;";
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

    //add by hujing 2002/10/4, for fcsan-defect 189
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
    
    function onCancel() {
        if(document.forms[0].cancel.disabled)
            return false;
        else
            parent.close();
    }
    
    function decideRaid() {
        var boxCount=0;
        if(parent.frames[0].document.forms[0]) {
            if(!(parent.frames[0].document.forms[0].pdno.length)) {
                if(parent.frames[0].document.forms[0].pdno.checked) {
                    boxCount=boxCount+1;
                }
            } else {
                for(var i=0;i<parent.frames[0].document.forms[0].pdno.length;i++) {
                    if (parent.frames[0].document.forms[0].pdno[i].checked) {
                        boxCount=boxCount+1;
                    }
                }
            }
        }
        
        if(!document.forms[0] || !document.forms[0].raidtype) {
            return;
        }
        
        <% if (!multiMach) { %>
            if (boxCount > 15) {
                document.forms[0].raidtype[0].disabled = raidarray[0][16];
                document.forms[0].raidtype[1].disabled = raidarray[1][16];
                document.forms[0].raidtype[2].disabled = raidarray[2][16];
                document.forms[0].raidtype[3].disabled = raidarray[3][16];
                //document.forms[0].raidtype[4].disabled = raidarray[4][16];
            } else {
                document.forms[0].raidtype[0].disabled = raidarray[0][boxCount];
                document.forms[0].raidtype[1].disabled = raidarray[1][boxCount];
                document.forms[0].raidtype[2].disabled = raidarray[2][boxCount];
                document.forms[0].raidtype[3].disabled = raidarray[3][boxCount];
                //document.forms[0].raidtype[4].disabled = raidarray[4][boxCount];
            }
        <% } else { %>
            if (boxCount > 15) {
                document.forms[0].raidtype[0].disabled = raidarray[1][16];
                //document.forms[0].raidtype[1].disabled = raidarray[3][16];
                //document.forms[0].raidtype[2].disabled = raidarray[4][16];
                document.forms[0].raidtype[1].disabled = raidarray[2][16];
                document.forms[0].raidtype[2].disabled = raidarray[3][16];
                
            } else {
                document.forms[0].raidtype[0].disabled = raidarray[1][boxCount];
                //document.forms[0].raidtype[1].disabled = raidarray[3][boxCount];
                //document.forms[0].raidtype[2].disabled = raidarray[4][boxCount];
                document.forms[0].raidtype[1].disabled = raidarray[2][boxCount];
                document.forms[0].raidtype[2].disabled = raidarray[3][boxCount];
                
            }
        <% } %>
        document.forms[0].bind.focus(); 
    }
    
    function check(str) {
       var avail = /[^0-9a-fA-F]/g;
       ifFind = str.search(avail);
        if(ifFind!=-1)
            return false;         
        else
            return true;
    }
    
    function checkrankno() {
        /*Modify by hujing for fcsan-defect 189
        var rankno=document.forms[0].rankno.value;
        if(!rankno || (rankno.length != 2) || (!check(rankno))) {
        */
        
        var rankno=document.forms[0].rankno.value.Rtrim();   
        if(!rankno || (!check(rankno))) { 
        //modify end
        //modify on 4.17 by maojb
            <% if (multiMach && pdgroupnumber.equals("00")) { %>
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/mmranknoerrormsg"/>");
                return false;
            <% } else { %>
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/ranknoerrormsg"/>");
                return false;
            <% } %>
        }
        return true;
    }
    
    //add by hujing for fcsan-defect 189
    function fullrankno() {
    var rankno=document.forms[0].rankno.value.Rtrim();
    if (rankno.length >= 2)
        return;
    document.forms[0].rankno.value = "0"+ rankno;
    return;
    }
    //add end
    
    function onSubmit(obj) {
        //modify by maojb on 12.18 for hujing and hujun review 
        if (obj.disabled) {
            return false;
        }
        //Add by maojb on May5
        if(!(checkrankno())) {
            return false;
        }
        //add by hujing for fcsan-defect 189
        fullrankno();
        //add end
        var raidtype="";
        var intRankno = parseInt(document.forms[0].rankno.value,16);
        
        <% if (!multiMach) { %>
            if(!(document.forms[0].raidtype[0].checked) 
                    && !(document.forms[0].raidtype[1].checked) 
                    && !(document.forms[0].raidtype[2].checked) 
                    && !(document.forms[0].raidtype[3].checked)) {
                    //&& !(document.forms[0].raidtype[4].checked) ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/raidtypeerrormsg"/>");
                return false;
            }
            if (intRankno > 0x3f ) {
                //not multiUsed,rankno from 00 to 3f 
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/ranknoerrormsg"/>");
                return false;
            }
            for(var i=0;i<document.forms[0].raidtype.length;i++) {
                if(document.forms[0].raidtype[i].checked) {
                    raidtype=document.forms[0].raidtype[i].value;
                }
            }
        <% } 
        if (multiMach) { %>
            if(!(document.forms[0].raidtype[0].checked) 
                    && !(document.forms[0].raidtype[1].checked) 
                    && !(document.forms[0].raidtype[2].checked)) {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/raidtypeerrormsg"/>");
                return false;
            }
            if (parent.frames[0].document.forms[0].equalsPDNum
                    && parent.frames[0].document.forms[0].equalsPDNum.value == "false"){
                if (document.forms[0].raidtype[0].checked 
                    &&!confirm("<nsgui:message key="fcsan_componentconf/alert/mirror_raid1"/>")){
                        return false;
                }
                if (document.forms[0].raidtype[2].checked 
                    &&!confirm("<nsgui:message key="fcsan_componentconf/alert/mirror_raid10"/>")){
                        return false;
                }
            }
                
            if ("<%=pdgroupnumber%>"=="00" && (intRankno > 0x3f || intRankno < 0x02)) {
                //multiUsed,rankno from ** to **, it's not sure, use 00-3f temporally 
                // use 02-3f by maojb on 4.17 
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/mmranknoerrormsg"/>");
                return false;
            }
            if("<%=pdgroupnumber%>"!="00" && intRankno > 0x3f) {
                //multiUsed , pdgroupnumber isn't 00
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/ranknoerrormsg"/>");
                return false;
            }
            for(var i=0;i<document.forms[0].raidtype.length ; i++) {
                if(document.forms[0].raidtype[i].checked) {
                    raidtype=document.forms[0].raidtype[i].value;
                }
            }
        <% } %>
        
        var pdno="";
        if(parent.frames[0].document.forms[0]) {
            if(!(parent.frames[0].document.forms[0].pdno.length)) {
                if(parent.frames[0].document.forms[0].pdno.checked) {
                    pdno=pdno+parent.frames[0].document.forms[0].pdno.value;
                    pdno=pdno+"h,"
                }
            } else {
                for(var i=0;i<parent.frames[0].document.forms[0].pdno.length;i++) {
                    if (parent.frames[0].document.forms[0].pdno[i].checked) {
                        pdno=pdno+parent.frames[0].document.forms[0].pdno[i].value;
                        pdno=pdno+"h,";
                    }
                }
            }
        }
        
        if(!pdno) {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rankbindbottom/pdnoerrormsg"/>");
            return false;
        } else {
            pdno=pdno.substring(0,pdno.length-1);
            document.forms[0].pdno.value=pdno;
        }
        
        var confirmmsg="<nsgui:message key="fcsan_componentconf/rankbindbottom/confirmmsghead"/>"
                +"\n"+"<nsgui:message key="fcsan_componentconf/table/th_dan"/>"+" : "+"<%=diskarrayname%>"+"\n"
                +"<nsgui:message key="fcsan_componentconf/table/th_pdg"/>"+" : "+"<%=pdgroupnumber%>"+"h\n"
                +"<nsgui:message key="fcsan_componentconf/table/th_rn"/>"+" : "+document.forms[0].rankno.value+"h\n"
                +"<nsgui:message key="fcsan_componentconf/table/th_pdn"/>"+" : "+pdno+"\n"
                +"<nsgui:message key="fcsan_componentconf/rankbindbottom/raidtype"/>"+raidtype+"\n"
                +"<nsgui:message key="fcsan_componentconf/common/h3_rt"/>"+document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value;
        
        if(!(obj.disabled)) {
            document.forms[0].cancel.disabled=true;
            document.forms[0].bind.disabled=true;
            return true;
        }// else {
           // return false;
        //}
    }
    
    function selectRadioButton(obj) {
        if (obj.disabled) {
            obj.checked=false;
            var OSinfo=navigator.appVersion;
            //alert(OSinfo);
            if(OSinfo.indexOf("Windows")==-1&&navigator.appName.indexOf("Netscape")>=0&&OSinfo.split(" ")[0]<6.0)
                return false;
            if(OSinfo.indexOf("Windows")>=0&&navigator.appName.indexOf("Netscape")>=0&&OSinfo.split(" ")[0]<6.0)
                return true;
        }
    }
</script>
</head>
<body onLoad="decideRaid()">
<!--form name="form" target="rankbindWin" action="../common/fcsanwait.jsp" onsubmit="return onSubmit(document.forms[0].bind)"-->

<form name="rbBottomForm"  method="post" target="rankbindWin" action="<%=response.encodeURL("rankbindconfirm.jsp")%>" onsubmit='if(onSubmit(document.forms[0].bind)){var win_rankbindWin = window.open("/nsadmin/common/commonblank.html","rankbindWin","width=600,height=350,toolbar=no,menubar=no,resizable=yes,scrollbars=yes"); win_rankbindWin.focus(); } else return false;'>

<table>
<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/table/th_rn"/>
</th>
<td>:</td>
<td>
<input type="edit" size="2" maxlength="2" name="rankno" value="<%=rankno%>">h
</td>
</tr>

<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/rankbindbottom/raidtype"/>
</th>
<td>:</td>
<td>
<%if (!multiMach) {%>
<input id="rd1" type="radio" name="raidtype" value="0"  onclick="return selectRadioButton(this)" >
<label for="rd1"><nsgui:message key="fcsan_componentconf/rankbindbottom/raid0"/></label>
<%}%>

<input id="rd2" type="radio" name="raidtype" value="1"  onclick="return selectRadioButton(this)">
<label for="rd2"><nsgui:message key="fcsan_componentconf/rankbindbottom/raid1"/></label>

<%if (!multiMach) {%>
<!--<input id="rd3" type="radio" name="raidtype" value="3"  onclick="return selectRadioButton(this)">
<label for="rd3"><nsgui:message key="fcsan_componentconf/rankbindbottom/raid3"/></label>-->
<%}%>

<input id="rd4" type="radio" name="raidtype" value="5"  onclick="return selectRadioButton(this)">
<label for="rd4"><nsgui:message key="fcsan_componentconf/rankbindbottom/raid5"/></label>
<input id="rd5" type="radio" name="raidtype" value="10"  onclick="return selectRadioButton(this)">
<label for="rd5"><nsgui:message key="fcsan_componentconf/rankbindbottom/raid10"/></label>
</td>
</tr>

<tr>
<th align="left">
<nsgui:message key="fcsan_componentconf/common/h3_rt"/>
</th>
<td>:</td>
<td>
<select name="rebuildingtime">
<option value="0" selected>0<nsgui:message key="fcsan_componentconf/common/fastest"/>
<% // modified by zhangjx Sep. 6
for(i=1; i<25 ;i++) {%>
<option value="<%=i%>"><%=i%></option>
<%}%>
</select>
<nsgui:message key="fcsan_componentconf/common/hour"/>
</td>
</table>

<input type="hidden" name="pdno">
<input type="hidden" name="diskarrayname" value="<%=diskarrayname%>">
<input type="hidden" name="pdgroupnumber" value="<%=pdgroupnumber%>">
<input type="hidden" name="diskarrayid" value="<%=diskarrayid%>">
<input type="hidden" name="arraytype" value="<%=request.getParameter("arraytype")%>">
<input type="hidden" name="target_jsp" value="../componentconf/rankbindresult.jsp">
<!--  add by maojb on 5.21 for waiting message -->
<br>
<center>
<input type="submit" name="bind" value="<nsgui:message key="common/button/submit"/>" >
<input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="return onCancel()">
</center>
</form>
</body>
</html>

<script language="javaScript">
    parent.frames[1].document.forms[0].raidtype[0].disabled=true;
    parent.frames[1].document.forms[0].raidtype[1].disabled=true;
    parent.frames[1].document.forms[0].raidtype[2].disabled=true;

    <% if (!multiMach) { %>
        parent.frames[1].document.forms[0].raidtype[3].disabled=true;
        //parent.frames[1].document.forms[0].raidtype[4].disabled=true;
    <% } %>
</script>