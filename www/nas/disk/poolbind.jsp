<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: poolbind.jsp,v 1.17 2008/04/19 12:50:47 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.disk.DiskCommon"%>
<%@ page buffer="32kb" %>
<%@ taglib uri="struts-bean"   prefix="bean" %>
<%@ taglib uri="struts-html"   prefix="html" %>
<%@ taglib uri="struts-logic"  prefix="logic"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<%boolean isS=DiskCommon.isSSeries(request);
  boolean isD=DiskCommon.isCondorLiteSeries(request);%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="/nsadmin/nas/disk/disk.js"></script>
<script language="JavaScript">
function settype(){
    var value;
    if(document.forms[0].elements["poolinfo.raidtype"][2].checked){ //raid1
        value = document.forms[0].elements["poolinfo.raidtype"][2].value;
    }else if(document.forms[0].elements["poolinfo.raidtype"][4].checked){//raid5
        value = document.forms[0].elements["poolinfo.raidtype"][4].value;
    }else if(document.forms[0].elements["poolinfo.raidtype"][3].checked){//raid10
 	    value = document.forms[0].elements["poolinfo.raidtype"][3].value;
    }else if(document.forms[0].elements["poolinfo.raidtype"][5].checked){//raid50
        value = document.forms[0].elements["poolinfo.raidtype"][5].value;
    }else if(document.forms[0].elements["poolinfo.raidtype"][1].checked){//raid6(4+PQ)
		value = document.forms[0].elements["poolinfo.raidtype"][1].value;
    }else if(document.forms[0].elements["poolinfo.raidtype"][0].checked){//raid6(8+PQ)
        value = document.forms[0].elements["poolinfo.raidtype"][0].value;
    }
    switch(value){
    	case "1": return "RAID1";
    	break;
    	case "5": return "RAID5";
    	break;
    	case "10": return "RAID10";
    	break;
    	case "50": return "RAID50";
    	break;
    	case "6_6": return "RAID6(4+PQ)";
    	break;
    	case "6_10": return "RAID6(8+PQ)";
    	break;
    }
}

function checkPoolname(){
    var poolname = document.forms[0].elements["poolinfo.poolname"].value;
    if(poolname=="" || poolname.length>32 ){
        return false;
    }
    var illegal=/[^A-Za-z0-9\/\_]/g;
    var ifFind = poolname.search(illegal);
    return (ifFind==-1);
    
}

function checkpd(){
    var pdquantity = document.forms[0].elements["usedpd"].options.length; 
    if(document.forms[0].elements["poolinfo.raidtype"][2].checked && pdquantity==2){ //raid1
        return true;
    }else if(document.forms[0].elements["poolinfo.raidtype"][4].checked && pdquantity==5){//raid5
        return true;
    }else if(document.forms[0].elements["poolinfo.raidtype"][3].checked){//raid10
        if (pdquantity==4 || pdquantity==6 || pdquantity==8 || pdquantity==10 || pdquantity==12 || pdquantity==14|| pdquantity==16){
            return true;
        }
    }else if(document.forms[0].elements["poolinfo.raidtype"][5].checked){//raid50
        if (pdquantity==10 || pdquantity==20){
            return true;
        }
    }else if(document.forms[0].elements["poolinfo.raidtype"][1].checked && pdquantity>=6){//raid6(4+PQ)
        return true;
    }else if(document.forms[0].elements["poolinfo.raidtype"][0].checked && pdquantity>=10 ){//raid6(8+PQ)
        return true;
    }
    return false;
}

function isOverMaxPdQuantity(){
    var pdquantity = document.forms[0].elements["usedpd"].options.length; 
    if (pdquantity>60){
        return true;
    }
    return false;
}

function setbuttonstatus(){
    var usepdquantity = document.forms[0].elements["usedpd"].options.length; 
    var notusepdquantity = document.forms[0].elements["notusedpd"].options.length; 
    document.forms[0].add.disabled=false;
    document.forms[0].addall.disabled=false;
    document.forms[0].del.disabled=false;
    document.forms[0].delall.disabled=false;
    
    if (usepdquantity==0){
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
    var c =0;
    if (usepdquantity>0){
	    c = parseInt((document.forms[0].elements["usedpd"].options[0].value).split(",")[1]);
    }
    for(var i=0;i<usepdquantity;i++){
    	var onepd =parseInt((document.forms[0].elements["usedpd"].options[i].value).split(",")[1]);
    	if (onepd<c){
    		c = onepd;
    	}
    }
    c = c*usepdquantity;
     
    if(document.forms[0].elements["poolinfo.raidtype"][2].checked){ //raid1
        c = c/2;
    }else if(document.forms[0].elements["poolinfo.raidtype"][4].checked){//raid5
        c = c*0.8;
    }else if(document.forms[0].elements["poolinfo.raidtype"][3].checked){//raid10
        c = c/2;
    }else if(document.forms[0].elements["poolinfo.raidtype"][5].checked){//raid50
        c = c*0.8;
    }else if(document.forms[0].elements["poolinfo.raidtype"][1].checked){//raid6(4+PQ)
        c = c*2/3;
    }else if(document.forms[0].elements["poolinfo.raidtype"][0].checked){//raid6(8+PQ)
        c = c*0.8;
    }
    document.forms[0].pagecountcapacity.value = c;
    c = c/1024/1024/1024;
    c =c*10;
	c = parseInt(c);
	c = c /10; 
    var ca = new Number(c);
    var capacity = ca.toFixed(1)+"GB";
    document.getElementById('capacity').innerHTML=capacity;
}

function movepd(action,quantity){
	var from, to;
	if (action == "add"){
		from = document.forms[0].elements["notusedpd"];
		to =  document.forms[0].elements["usedpd"];
	}else{
		from = document.forms[0].elements["usedpd"];
		to = document.forms[0].elements["notusedpd"];
	} 

    if (quantity=="select"){
        var index = from.length -1;
        for(; index>=0; index--){
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
        for(var j=0;j<index+1;j++){
            to.length++;
            to.options[to.length-1].value = from.options[j].value;
            to.options[to.length-1].text = from.options[j].text;
        }
        from.options.length=0;
    }
    selectone();  
    countcapacity();
   
    
}


function selectone(){
	var usepd = document.forms[0].elements["usedpd"];
    var notusepd = document.forms[0].elements["notusedpd"];
    
    if (usepd.options.length>0){
    	usepd.options[0].selected=true;
    	for(var i=1;i<usepd.options.length;i++){
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
    document.forms[0].elements["poolinfo.poolname"].focus();
    setbuttonstatus();
    selectone();
    countcapacity();
	<logic:equal name="pdq" value="0" scope="request">
		cannotset();
	</logic:equal>

	<logic:equal name="pdq" value="1" scope="request">
		cannotset();
	</logic:equal>
}

function onset(){
	if (isSubmitted()){
        return false;
    }
	if (!checkPoolname()){
        alert('<bean:message key="disk.pool.invalid.poolname" />');
        document.forms[0].elements["poolinfo.poolname"].focus();
        return false;
    }
    <%if (isD){%>
        var isinvalidtime="false";
        if (document.forms[0].elements["poolinfo.rbtime"].value.match(/[^\d]/)){
            isinvalidtime="true";
        }
        if (document.forms[0].elements["poolinfo.rbtime"].value.match(/^0/) && document.forms[0].elements["poolinfo.rbtime"].value.length>1){
            isinvalidtime="true";
        }
        var rbt=parseInt(document.forms[0].elements["poolinfo.rbtime"].value);
        if (isinvalidtime == "true" || isNaN(rbt)|| rbt <0 || rbt >255){
	        alert('<bean:message key="disk.pool.invalid.rebuildtime" />');
            document.forms[0].elements["poolinfo.rbtime"].focus();
            return false;
        }
    <%}%>  
    if (!checkpd()){
        if(document.forms[0].elements["poolinfo.raidtype"][2].checked ){ //raid1
            alert('<bean:message key="disk.pool.invalid.disk.1"/>');
            return false;
        }else if(document.forms[0].elements["poolinfo.raidtype"][4].checked){//raid5
            alert('<bean:message key="disk.pool.invalid.disk.5"/>');
            return false;
        }else if(document.forms[0].elements["poolinfo.raidtype"][3].checked){//raid10
            alert('<bean:message key="disk.pool.invalid.disk.10"/>');
            return false;
        }else if(document.forms[0].elements["poolinfo.raidtype"][5].checked){//raid50
            alert('<bean:message key="disk.pool.invalid.disk.50"/>');
            return false;
        }else if(document.forms[0].elements["poolinfo.raidtype"][1].checked){//raid6(4+PQ)
            alert('<bean:message key="disk.pool.invalid.disk.6_6"/>');
            return false;
        }else if(document.forms[0].elements["poolinfo.raidtype"][0].checked){//raid6(8+PQ)
            alert('<bean:message key="disk.pool.invalid.disk.6_10"/>');
            return false;
        }
    }
    if(isOverMaxPdQuantity()){
        alert('<bean:message key="disk.pool.pd.exceed"/>');
        return false;
    }
    if(!isSameTypePD("usedpd",1)){
        <%if (isS){%>
            alert('<bean:message key="disk.pool.invalid.pdtype.callisto"/>');
        <%}else if (isD){%>
            alert('<bean:message key="disk.pool.invalid.pdtype"/>');
        <%}%>
        return false;
    }
    if (isBasicPoolwithSATA()){
        alert('<bean:message key="disk.pool.sata.basicpool"/>');
        return false;
    }
    document.forms[0].elements["poolinfo.usedpd"].value = gatherlist("usedpd",0);
	document.forms[0].elements["poolinfo.notusedpd"].value = gatherlist("notusedpd",0);
	
    var pname = document.forms[0].elements["poolinfo.poolname"].value;
    var raidtype = settype();
    var ca = document.getElementById('capacity').innerHTML;
    if (!isPDCapacitySame()){
        if (!confirm('<bean:message key="disk.pd.different"/>\r\n'+
                     '<bean:message key="disk.pd.different.create.comfirm"/>')){
            return false;   
        }
    }
    
    setSubmitted();
    disabledbutton();
    return true;
}

function cannotset(){
    alert('<bean:message key="disk.pool.notcreate.enouthpd"/>');
	<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
        window.close();
    </logic:equal>
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

function isBasicPoolwithSATA(){
    var allpd = document.forms[0].elements["usedpd"];
    var pdtype = (allpd.options[0].value).split(",")[2];
    if (pdtype=="SATA"){
        if(document.forms[0].elements["poolinfo.raidtype"][2].checked ||
           document.forms[0].elements["poolinfo.raidtype"][4].checked ||
           document.forms[0].elements["poolinfo.raidtype"][3].checked ||
           document.forms[0].elements["poolinfo.raidtype"][5].checked){
            return true;
        }
    }
    return false;
}
</script>
<title><bean:message key="disk.pool.h2.create"/></title>
</head>

<body onload="init();" onUnload="closeDetailErrorWin();">
<logic:equal name="poolInfoForm" property="from" value="disk" scope="request"> 
    <h1 class="title"><bean:message key="disk.h1"/></h1>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeCreate" scope="request"> 
    <h1 class="title"><bean:message key="volume.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=volumeCreate'">
    <p>
</logic:equal>
<logic:equal name="poolInfoForm" property="from" value="volumeExtend" scope="request"> 
    <h1 class="title"><bean:message key="volume.h1"/></h1>
    <input type="button" value="<bean:message key="common.button.back" bundle="common"/>" onclick="window.location = '/nsadmin/volume/volumePoolSelect.do?from=volumeExtend'">
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

<h2 class="title"><bean:message key="disk.pool.h2.create"/></h2>
<logic:equal name="poolInfoForm" property="from"  value="disk" scope="request"> 
    <displayerror:error h1_key="disk.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="volumeCreate" scope="request"> 
    <displayerror:error h1_key="volume.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="volumeExtend" scope="request"> 
    <displayerror:error h1_key="volume.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="replication" scope="request"> 
   <displayerror:error h1_key="replication.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="ddrCreate" scope="request"> 
   <displayerror:error h1_key="ddr.h1"/>
</logic:equal>
<logic:equal name="poolInfoForm" property="from"  value="ddrExtend" scope="request"> 
   <displayerror:error h1_key="ddr.h1"/>
</logic:equal>


<html:form action="showbindpoolinfo.do" onsubmit="return onset();">

<html:hidden property="diskarrayid"/>
<html:hidden property="arraytype"/>
<html:hidden property="from"/>
<html:hidden property="diskarrayname"/>
<html:hidden property="pdgroupnumber"/>
<html:hidden property="poolinfo.usedpd"/>
<html:hidden property="poolinfo.notusedpd"/>
<input type="hidden" name="pagecountcapacity"/>
<table>
<tr>
    <th align="left"><bean:message key="disk.pool.name"/></th>
    <td>:</td>
    <td><html:text property="poolinfo.poolname" size="47" maxlength="32"/></td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.number"/></th>
    <td>:</td>
    <td><html:hidden property="poolinfo.poolnum" write="true"/>h</td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.raid.type"/></th>
    <td>:</td>
    <td>
    <html:radio styleId="raid6_10" property="poolinfo.raidtype" value="6_10" onclick="countcapacity();"/>
        <label for="raid6_10"><bean:message key="disk.pool.raid.type6_10"/></label>
    <html:radio styleId="raid6_6" property="poolinfo.raidtype" value="6_6" onclick="countcapacity();"/>
        <label for="raid6_6"><bean:message key="disk.pool.raid.type6_6"/></label>
    <br>
    <html:radio styleId="raid1" property="poolinfo.raidtype" value="1" onclick="countcapacity();"/>
        <label for="raid1"><bean:message key="disk.pool.raid.type1"/></label>
    <html:radio styleId="raid10" property="poolinfo.raidtype" value="10" onclick="countcapacity();"/>
        <label for="raid10"><bean:message key="disk.pool.raid.type10"/></label>
    <html:radio styleId="raid5" property="poolinfo.raidtype" value="5" onclick="countcapacity();"/>
        <label for="raid5"><bean:message key="disk.pool.raid.type5"/></label>
    <html:radio styleId="raid50" property="poolinfo.raidtype" value="50" onclick="countcapacity();"/>
        <label for="raid50"><bean:message key="disk.pool.raid.type50"/></label>
    </td>
</tr>

<tr>
<th align="left"><bean:message key="disk.pool.rebuildtime"/>
<%if (isD){%>
    <bean:message key="disk.pool.rebuildtime.detail"/>
<%}%></th>
<td>:</td>
<td>
<%if (isS){%>
    <html:select property="poolinfo.rbtime">
        <html:option value="0">0<bean:message key="disk.pool.rebuildtime.fast"/></html:option>
        <html:option value="1"></html:option>
        <html:option value="2"></html:option>
        <html:option value="3"></html:option>
        <html:option value="4"></html:option>
        <html:option value="5"></html:option>
        <html:option value="6"></html:option>
        <html:option value="7"></html:option>
        <html:option value="8"></html:option>
        <html:option value="9"></html:option>
        <html:option value="10"></html:option>
        <html:option value="11"></html:option>
        <html:option value="12"></html:option>
        <html:option value="13"></html:option>
        <html:option value="14"></html:option>
        <html:option value="15"></html:option>
        <html:option value="16"></html:option>
        <html:option value="17"></html:option>
        <html:option value="18"></html:option>
        <html:option value="19"></html:option>
        <html:option value="20"></html:option>
        <html:option value="21"></html:option>
        <html:option value="22"></html:option>
        <html:option value="23"></html:option>
        <html:option value="24"></html:option>
    </html:select>&nbsp;<bean:message key="disk.pool.rebuildtime.time"/>
<%}else if (isD){%>
    <html:text property="poolinfo.rbtime" size="20" maxlength="3" style="text-align:right" />
        &nbsp;<bean:message key="disk.pool.rebuildtime.time"/>&nbsp;&nbsp;<font class="advice"><bean:message key="disk.pool.expand.time.comment"/></font>
<%}%>
</td>
</tr>

<tr>
    <th align="left"><bean:message key="disk.pool.capacity"/></th>
    <td>:</td>
    <td><span id="capacity">0.0GB</span></td>
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
    <html:select property="usedpd" multiple="true" size="10" style="width:250px">
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