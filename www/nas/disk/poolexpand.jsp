<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: poolexpand.jsp,v 1.14 2008/04/19 13:00:44 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.model.entity.disk.DiskConstant"%>
<%@ page buffer="32kb" %>
<%@ taglib uri="struts-bean"   prefix="bean" %>
<%@ taglib uri="struts-html"   prefix="html" %>
<%@ taglib uri="struts-logic"  prefix="logic"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="/nsadmin/nas/disk/disk.js"></script>
<script language="JavaScript">
var poolpdnumber = parseInt("<bean:write name="poolpdnumber"/>");
var poolpdcapacity =parseInt("<bean:write name="<%=DiskConstant.SESSION_SMALL_POOL_PD_CAPACITY%>"/>");
var realpool="";

function setbuttonstatus(){
    var usepdquantity = document.forms[0].elements["usedpd"].options.length; 
    var notusepdquantity = document.forms[0].elements["notusedpd"].options.length; 
    document.forms[0].add.disabled=false;
    document.forms[0].addall.disabled=false;
    document.forms[0].del.disabled=false;
    document.forms[0].delall.disabled=false;
    
    if ((usepdquantity-poolpdnumber)==0){
        document.forms[0].del.disabled=true;
        document.forms[0].delall.disabled=true;
        
    }
    if (notusepdquantity==0){
	    document.forms[0].add.disabled=true;
        document.forms[0].addall.disabled=true;
    }    
}

function countcapacity(){
    var usepdquantity = document.forms[0].elements["usedpd"].options.length;
    var existc = parseFloat(document.getElementById('capacity').innerHTML);
    existc = existc*1024*1024*1024;
    var addc=0;
    for(var i=poolpdnumber;i<usepdquantity;i++){
    	var onepd =parseInt((document.forms[0].elements["usedpd"].options[i].value).split(",")[1]);
    	if(onepd>poolpdcapacity){
    		onepd = poolpdcapacity;
    	}
    	addc = addc + onepd;
    }
    if (usepdquantity>poolpdnumber){
        <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_6" scope="request">
            addc =addc*2/3;
	    </logic:equal>
	    <logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_10" scope="request">
    		addc =addc*0.8;
	    </logic:equal>
	    existc = (existc + addc)/1024/1024/1024;
	    if(existc>0.05){
	        existc=existc-0.05;
        } 
    }else{
    	existc = existc/1024/1024/1024;
    }
      
    var ca = new Number(existc);
    var capacity = ca.toFixed(1)+"GB";
    document.getElementById('expandcapacity').innerHTML=capacity;
}

function haveSmallpd(){
    var pd = document.forms[0].elements["usedpd"];
    for(var i=poolpdnumber;i<pd.length;i++){
        var thispdca = parseInt(pd.options[i].value.split(",")[1]);
        if (thispdca < poolpdcapacity){
    	    return true;
        }
    }
    return false;
}

function movepd(action,quantity){
    var from, to,j,end;
    if (action == "add"){
		from = document.forms[0].elements["notusedpd"];
		to =  document.forms[0].elements["usedpd"];
		j = 0;
		end = 0;
	}else{
		from = document.forms[0].elements["usedpd"];
		to = document.forms[0].elements["notusedpd"];
		j = poolpdnumber;
		end = poolpdnumber;
	} 

    if (quantity=="select"){
        var index = from.length -1;
        for(; index>=end; index--){
            if (from.options[index].selected){
                to.length++;
    	        to.options[to.length-1].value = from.options[index].value;
        	    to.options[to.length-1].text = from.options[index].text;
            	for (var i= index;i<from.length-1;i++){
                    from[i].value = from[i+1].value;
                    from[i].text = from[i+1].text;
	            }
    	        from.length--;
            }
        }
    }else{
        var index = from.length -1;
        for(;j<index+1;j++){
        	to.length++;
	        to.options[to.length-1].value = from.options[j].value;
    	    to.options[to.length-1].text = from.options[j].text;
        }
        from.options.length=end;
    }
    blurold();
    selectone();  
    countcapacity();
}


function selectone(){
	var usepd = document.forms[0].elements["usedpd"];
    var notusepd = document.forms[0].elements["notusedpd"];
    
    if (usepd.options.length>poolpdnumber){
    	usepd.options[poolpdnumber].selected=true;
    	for(var i=poolpdnumber+1;i<usepd.options.length;i++){
    		usepd.options[i].selected=false;
    	}
    }
    if (notusepd.options.length>0){
    	notusepd.options[0].selected=true;
    	for(var j=1;j<notusepd.options.length;j++){
    		notusepd.options[j].selected=false;
    	}
    }
}

function init(){
    if (document.forms[0].elements["poolinfo.poolname"].value=="--------"){
    	disabledbutton();
    	document.forms[0].selectpoolbutton.disabled=true;
    	document.forms[0].set.disabled=true;
    }else{
	    realpool=document.forms[0].elements["poolinfo.poolname"].value;
		blurold();
	    setraidtype();
	    setcapacityforshow();
	    setbuttonstatus();
	    selectone();
	    countcapacity();
	    <logic:equal name="pdq" value="0" scope="request">
			cannotset();
		</logic:equal>
	}
	setetime();
}

function setcapacityforshow(){
	var tmp = <bean:write name ="<%=DiskConstant.SESSION_OLD_POOL_CAPACITY%>"/>;
	tmp =tmp/1024/1024/1024;
	tmp =tmp *10;
	tmp = parseInt(tmp);
	tmp = tmp /10;
    var ca = new Number(tmp);
    var capacity = ca.toFixed(1)+"GB";
    //document.getElementById('expandcapacity').innerHTML=capacity;
    document.getElementById('capacity').innerHTML=capacity;
}

function setraidtype(){
	<logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_6">
        document.getElementById('raidtypeforshow').innerHTML= "6(4+PQ)";
	</logic:equal>
	<logic:equal name="poolInfoForm" property="poolinfo.raidtype" value="6_10">
        document.getElementById('raidtypeforshow').innerHTML= "6(8+PQ)";
	</logic:equal>

}

function onset(){
	if (isSubmitted()){
        return false;
    }
    document.forms[0].elements["poolinfo.poolname"].value= realpool;
    
    var raidtype = document.getElementById('raidtypeforshow').innerHTML;
    var basepd = (raidtype=="6(4+PQ)"?"6":"10");
    var addpd = getaddpdnum();
    
    if (addpd==0){
    	alert('<bean:message key="disk.pool.invalid.expand.pdnumber"/>');
	   	return false;
    }
    if (document.forms[0].elements["poolinfo.expandmode"][0].checked){
    	if (addpd<basepd){
        	alert('<bean:message key="disk.pool.expand.mode.alert"/>');
            return false;
    	}
    }else if (document.forms[0].elements["poolinfo.expandmode"][1].checked){
        document.forms[0].elements["poolinfo.expandtime"].value=trim(document.forms[0].elements["poolinfo.expandtime"].value);
        var isvalidtime="false";
        if (document.forms[0].elements["poolinfo.expandtime"].value.match(/[^\d]/)){
            isvalidtime="true";
        }
        if (document.forms[0].elements["poolinfo.expandtime"].value.match(/^0/) 
            && document.forms[0].elements["poolinfo.expandtime"].value.length>1){
        	isvalidtime="true";
        }
        var expandtime=parseInt(document.forms[0].elements["poolinfo.expandtime"].value);
     	if (isvalidtime == "true" ||isNaN(expandtime)|| expandtime <0 || expandtime >255 ) {
	   	    alert ('<bean:message key="disk.pool.invalid.expand.time"/>');
	   	    document.forms[0].elements["poolinfo.expandtime"].focus();
  	   	    return false;
       	}
    }
    if (addpd>60){
        alert('<bean:message key="disk.pool.pd.exceed"/>');
        return false;
    }
	if(haveSmallpd()){
		alert('<bean:message key="disk.pool.invalid.expand.pdcapacity"/>');
        return false;
	}
    
    if(!isSameTypePD("usedpd",poolpdnumber)){
        var pdtypeold = (document.forms[0].elements["usedpd"].options[0].value).split(",")[2];
        if (pdtypeold=="SAS"){
            alert('<bean:message key="disk.pool.invalid.pdtype.create.sas"/>');
        }else if(pdtypeold=="SATA") {
            alert('<bean:message key="disk.pool.invalid.pdtype.create.sata"/>');
        }else if (pdtypeold=="FC") {
            alert('<bean:message key="disk.pool.invalid.pdtype.create.fc"/>');
        }
        return false;
    }
    
    document.forms[0].elements["poolinfo.usedpd"].value = gatherlist("usedpd",poolpdnumber);
    document.forms[0].elements["poolinfo.notusedpd"].value = gatherlist("notusedpd",0);
    var pname = document.forms[0].elements["poolinfo.poolname"].value;
    
    var expandca = document.getElementById('expandcapacity').innerHTML;
    
    if (!isPDCapacitySame()){
        if (!confirm('<bean:message key="disk.pd.different"/>\r\n'+
                     '<bean:message key="disk.pd.different.expand.comfirm"/>')){
            return false;   
        }
    }
    
    setSubmitted();
    disabledbutton();
    document.forms[0].action = "showexpandpoolinfo.do";
    return true;
}

function cannotset(){
	alert('<bean:message key="disk.pool.notexpand.enouthpd"/>');
	<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
        window.close();
    </logic:equal>
	
}

function selectpool(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    disabledbutton();
    document.forms[0].action = "expandpooldisplay.do";
    document.forms[0].submit();
	return true;
}

function setgray(){
	for (var i=0;i<poolpdnumber;i++){
		document.forms[0].elements["usedpd"].options[i].style.color='gray';
	}
}

function blurold(){
    var usepdlist = document.forms[0].elements["usedpd"];
    if (usepdlist.length==poolpdnumber){
		usepdlist.disabled=true;
	}else{
		if (usepdlist.disabled){
    		usepdlist.disabled=false;
    	}
		setgray();
		if(usepdlist.selectedIndex<poolpdnumber&&usepdlist.selectedIndex>=0){
		    for(var i =0;i<poolpdnumber;i++){
		        if (usepdlist.options[i].selected){
                    usepdlist.options[i].selected=false;
                }
            }
            usepdlist.blur();
        }
        if(usepdlist.length>poolpdnumber&&usepdlist.selectedIndex<poolpdnumber){
            usepdlist.options[poolpdnumber].selected=true;
        }
	} 
}

function getaddpdnum(){
	var allusepdnum = document.forms[0].elements["usedpd"].length;
	var addnumber = allusepdnum-poolpdnumber
	return addnumber;
}

function disabledbutton(){
    document.forms[0].add.disabled=true;
    document.forms[0].addall.disabled=true;
    document.forms[0].del.disabled=true;
    document.forms[0].delall.disabled=true;
}

function isPDCapacitySame(){
    var usepdquantity = document.forms[0].elements["usedpd"].options.length;
    var isSame = true;
    var c = parseInt((document.forms[0].elements["usedpd"].options[0].value).split(",")[1]);
    for(var i=1;i<usepdquantity;i++){
    	var onepd =parseInt((document.forms[0].elements["usedpd"].options[i].value).split(",")[1]);
    	if (onepd!=c){
    		isSame = false;
    		break;
    	}
    }
    return isSame;
}
function setetime(){
    if (document.forms[0].elements["poolinfo.expandmode"][0].checked){
		document.forms[0].elements["poolinfo.expandtime"].disabled=true;
    }else if (document.forms[0].elements["poolinfo.expandmode"][1].checked){
		document.forms[0].elements["poolinfo.expandtime"].disabled=false;
	}
}
function setmode(){
    setetime();
    if (document.forms[0].elements["poolinfo.expandmode"][0].checked){
		var raidtype = document.getElementById('raidtypeforshow').innerHTML;
        var basepd = (raidtype=="6(4+PQ)"?"6":"10");
        var addpd = getaddpdnum();	
        if (addpd<basepd){
            alert('<bean:message key="disk.pool.expand.mode.alert"/>');
            return false;
        }
	}
}

</script>
<title><bean:message key="disk.pool.h2.expand"/></title>
</head>

<body onload="init();">
<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
    <h1 class="title"><bean:message key="disk.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeExtend" scope="request"> 
    <h1 class="title"><bean:message key="volume.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=volumeExtend'">
    <p>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeCreate" scope="request"> 
    <h1 class="title"><bean:message key="volume.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=volumeCreate'">
    <p>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="replication" scope="request"> 
    <h1 class="title"><bean:message key="replication.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=replication'">
    <p>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrCreate" scope="request"> 
    <h1 class="title"><bean:message key="ddr.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=ddrCreate'">
    <p>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrExtend" scope="request"> 
    <h1 class="title"><bean:message key="ddr.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=ddrExtend'">
    <p>
</logic:equal>

<h2 class="title"><bean:message key="disk.pool.h2.expand"/></h2>
<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
    <displayerror:error h1_key="disk.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeExtend" scope="request"> 
    <displayerror:error h1_key="volume.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeCreate" scope="request"> 
    <displayerror:error h1_key="volume.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="replication" scope="request"> 
   <displayerror:error h1_key="replication.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrCreate" scope="request"> 
   <displayerror:error h1_key="ddr.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="ddrExtend" scope="request"> 
   <displayerror:error h1_key="ddr.h1"/>
</logic:equal>


<html:form action="showexpandpoolinfo.do" onsubmit="return onset();">

<html:hidden property="diskarrayid"/>
<html:hidden property="arraytype"/>
<html:hidden property="from"/>
<html:hidden property="diskarrayname"/>
<html:hidden property="pdgroupnumber"/>
<html:hidden property="poolinfo.usedpd"/>
<html:hidden property="poolinfo.raidtype"/>
<html:hidden property="poolinfo.notusedpd"/>
<table>
<tr>
    <th align="left"><bean:message key="disk.pool.namenumber"/></th>
    <td>:</td>
    <td>
    <html:select property="poolinfo.poolname">
        <html:optionsCollection name="<%=DiskConstant.SESSION_RAID6_POOL_LIST%>" />
    </html:select>
    &nbsp;
    <input type="button" name="selectpoolbutton" value="<bean:message key="common.button.select" bundle="common"/>" onclick="selectpool();">
    </td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.raid.type"/></th>
    <td>:</td>
    <td><span id="raidtypeforshow"></span></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.before.expand.capacity"/></th>
    <td>:</td>
    <td><span id="capacity"></span></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.after.expand.capacity"/></th>
    <td>:</td>
    <td><span id="expandcapacity"></span></td>
</tr>

</table>

<h3 class="title"><bean:message key="disk.pool.h3.expandmodeselect"/></h3>
<table>
<tr>
<td>
    <b><html:radio styleId="emodeoff" property="poolinfo.expandmode" value="off" onclick="setmode();"/>
    <label for="emodeoff"><bean:message key="disk.pool.expand.mode.off"/></label></b>
</td>
</tr>

<tr>
<td>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font class="advice"><bean:message key="disk.pool.expand.mode.off.comment"/></font>
</td>
</tr>

<tr>
<td>
    <b><html:radio styleId="emodeon" property="poolinfo.expandmode" value="on" onclick="setmode();"/>
    <label for="emodeon"><bean:message key="disk.pool.expand.mode.on"/></label></b>
    &nbsp;&nbsp;&nbsp;&nbsp;<font class="advice"><bean:message key="disk.pool.expand.mode.on.comment"/></font>
</td>
</tr>

<tr>
<td>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="disk.pool.expand.time.fordisplay"/>&nbsp;&nbsp;<html:text property="poolinfo.expandtime" size="3" maxlength="3" style="text-align:right"/>
    &nbsp;<bean:message key="disk.pool.expand.time.denomination"/>&nbsp;&nbsp;&nbsp;&nbsp;<font class="advice"><bean:message key="disk.pool.expand.time.comment"/></font>
</td>
</tr>
</table>

<h3 class="title"><bean:message key="disk.pool.h3.diskselect"/></h3>
<table> 
<tr>
<td style="font-size:9pt"><bean:message key="disk.pool.pd.notuse"/><br>
    <html:select property="notusedpd" multiple="true" size="10" style="width:250px">
        <html:optionsCollection name="notusepdlist" />
    </html:select>
    
</td>

<td align="center">
<html:button property="add" onclick="movepd('add','select');setbuttonstatus();"><bean:message key="disk.pool.button.add"/></html:button><br><br>
<html:button property="del" onclick="movepd('del','select');setbuttonstatus();"><bean:message key="disk.pool.button.del"/></html:button>
</td>
<td style="font-size:9pt"><bean:message key="disk.pool.pd.use"/><br>
    <html:select property="usedpd" multiple="true" size="10" style="width:250px" onchange="blurold();">
        <html:optionsCollection name="<%=DiskConstant.SESSION_OLD_POOL_PD%>" />
        <html:optionsCollection name="usepdlist" />
    </html:select>
</td>
</tr>
<tr>
<td align="center"><html:button property="addall" onclick="movepd('add','all');setbuttonstatus();"><bean:message key="disk.pool.button.addall"/></html:button></td>
<td></td>
<td align="center"><html:button property="delall" onclick="movepd('del','all');setbuttonstatus();"><bean:message key="disk.pool.button.delall"/></html:button></td>
</tr>
</table>
<hr><br>
<center>
<input type="submit" name="set" value="<bean:message key="common.button.submit" bundle="common"/>" >
<input type="button" name="close" value="<bean:message key="common.button.close" bundle="common"/>" onclick ="window.close();">
</center>
 
</html:form>
</body>
</html:html>