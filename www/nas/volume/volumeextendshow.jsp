<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: volumeextendshow.jsp,v 1.35 2008/05/30 07:33:08 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeDetailAction"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>

<%@ page buffer="32kb" %>

<bean:define id="colSize" value="<%=(NSActionUtil.isNashead(request))? "2" : "2"%>"/>
<html:html lang="true"> 
<head> 
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">
function backToList(){
    if (!isSubmitted()){
        window.location = "/nsadmin/volume/volumeList.do";
        setSubmitted();
        lockMenu();
    }   
}

var heartBeatWin;
var poolWin;
var volume_winhandler;
var selectedLdPath;
var wwnn;
var usedStorage;
var storage4Extend;

<logic:equal name="isNashead" value="true">
	function selectLun(){
	    if (isSubmitted()){
	       return false;
	    }
		if(volume_winhandler==null || volume_winhandler.closed){
			volume_winhandler=window.open("/nsadmin/framework/moduleForward.do?h1=apply.volumn.volumn&msgKey=apply.volume.volume.forward.to.lun.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/lunSelectShow.do?src=volume","nasheadPop","toolbar=no,menubar=no,scrollbars=yes,width=500,height=520,resizable=yes");
		}else{
			volume_winhandler.focus();
		}
	}
</logic:equal>

<logic:notEqual name="isNashead" value="true">
function openSelectPool(){
    if (isSubmitted()){
        return false;
    }
    if (poolWin == null || poolWin.closed){
        poolWin = window.open("/nsadmin/common/commonblank.html", "volume_selectPool", "width=700,height=650,resizable=yes,scrollbars=yes,status=yes");
 
        window.poolName = document.forms[0].elements["volumeInfo.poolName"];
        window.poolNo   = document.forms[0].elements["volumeInfo.poolNo"];
        window.usableCapDiv = document.getElementById("usableCapDiv");

        document.forms[1].submit();
    }else{
        poolWin.focus();
    }
}
</logic:notEqual>


function onExtend(){
    if (isSubmitted()){
        return false;
    }
    var maxSize = <%=VolumeActionConst.VOLUME_MAX_SIZE%>;
    var alertMsg = "<bean:message key="msg.exceedMaxSize"/>";
    var hasSnapshot = "<bean:write name="hasSnapshot" scope="request"/>";
    var hasReplication = "<bean:write name="hasReplication" scope="request"/>";
    if (hasSnapshot == "yes" && hasReplication == "yes"){
        maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
        alertMsg = "<bean:message key="msg.exceed20TB.snapshotMVDSync"/>";
    }else if(hasSnapshot == "yes"){
        maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
        alertMsg = "<bean:message key="msg.exceed20TB.snapshot"/>";        
    }else if(hasReplication == "yes"){
        maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
        alertMsg = "<bean:message key="msg.exceed20TB.MVDSync"/>";        
    }
    <logic:notEqual name="isNashead" value="true">
        if (document.forms[0].elements["volumeInfo.poolName"].value == ""){
            alert('<bean:message key="msg.add.noSelectedPool"/>');
            return false;
        }
        
        var poolName = document.forms[0].elements["volumeInfo.poolName"].value;
        var selectedPoolNum = (poolName.split(",")).length;
        
        var extendSizeObj = document.forms[0].elements["volumeInfo.extendSize"];
        
        if (selectedPoolNum == 1) {
	        if (extendSizeObj.value==""
	           || checkCapacity(extendSizeObj.value) != true){
	            alert('<bean:message key="msg.extend.lessthan02"/>');
	            extendSizeObj.focus();
	            return false;
	        }
        } else {
            if (extendSizeObj.value==""
               || checkCapacity(extendSizeObj.value, 1) != true){
                alert('<bean:message key="msg.extend.morethan1"/>');
                extendSizeObj.focus();
                return false; 
            }        
        }
        
        var availCap = document.getElementById("usableCapDiv").innerHTML;
       
        var availCapUnit = availCap.substring(availCap.length-2, availCap.length);
        var availCapValue = combinateStr(availCap.substring(0, availCap.length-2));
        if (availCapUnit == "TB") {
            availCapValue = (new Number(parseFloat(availCapValue) * 1024)).toFixed(1);     
        }
        
        var extendSize = extendSizeObj.value;
        if (document.forms[0].elements["volumeInfo.capacityUnit"].value == "TB") {
            extendSize = (new Number(parseFloat(extendSizeObj.value) * 1024)).toFixed(1); 
        }

        if (parseFloat(extendSize) < 1){
            if (selectedPoolNum == 1) {
                alert("<bean:message key="msg.extend.lessthan02"/>");
            } else {                
                alert('<bean:message key="msg.extend.morethan1"/>');
            }
            extendSizeObj.focus();
            return false; 
        }
        if (parseFloat(extendSize) > parseFloat(availCapValue)){
            alert("<bean:message key="msg.add.exceedMaxCapacity"/>");
            extendSizeObj.focus();
            return false;
        }
        
        var sizeHidden = document.forms[0].elements["volumeInfo.capacity"];
        if (parseFloat(extendSize) + parseFloat(sizeHidden.value) > maxSize){
            alert(alertMsg);
            extendSizeObj.focus();
            return false;
        }

        <logic:equal name="<%=VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES%>" value="true" scope="session">
		    var bltime = document.forms[0].elements["volumeInfo.bltime"].value;
		    if(!isBlTimeValid(bltime, 0, 255)){
		    	alert("<bean:message key="info.bltime.invalid.alert"/>");
		    	document.forms[0].elements["volumeInfo.bltime"].focus();
		    	return false;
		    }
        </logic:equal>
        document.forms[0].usableCap.value = document.getElementById("usableCapDiv").innerHTML;
        
    </logic:notEqual>
    
    <logic:equal name="isNashead" value="true">
        var sizeHidden = document.forms[0].elements["volumeInfo.capacity"];
        var extendSize = document.getElementById("selectedLunSize").innerHTML;
        extendSize = combinateStr(extendSize);
        if(selectedLdPath.value == ""){
	        alert("<bean:message key="msg.add.noLUN"/>");
	        return false;
        }

        if (parseFloat(extendSize) + parseFloat(sizeHidden.value) > maxSize){
            alert(alertMsg);
            return false;
        }
        <logic:equal name="isGfsVolume" scope="request" value="true">
        if (stripingRdo && !stripingRdo.disabled 
           && stripingRdo.checked && window.differentSize.value == "1"){
            alert("<bean:message key="msg.alert.extend.striping.different.size"/>");
            return false;
        }
        </logic:equal>
        document.forms[0].elements["volumeInfo.extendSize"].value = document.getElementById("selectedLunSize").innerHTML;
    </logic:equal>
    
    // add for volume license by jiangfx, 2007.7.5
    var licenseAlert = "";
    <logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
        // get license capacity and total created volume capacity
        var licenseCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session"/>';
        var totalFSCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session"/>';

        // get cofirm message for exceed license capacity
    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
    	    && (parseFloat(extendSize) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
    		licenseAlert = "<bean:message key="volumeLicense.exceed.volExtend"/>" + "\r\n\r\n";
    	}
    </logic:equal>
    
    if (!confirm(licenseAlert + "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common" />" 
            + "<bean:message key="button.extend"/>" + "\r\n"
            + "<bean:message key="msg.longTimeWait"/>")){
        return false;
    }
    setSubmitted();
    document.forms[0].action="/nsadmin/volume/volumeExtend.do";
    heartBeatWin = openHeartBeatWin();
    lockMenu();
    return true;
}
function init() {
<logic:notEqual name="isNashead" value="true">
    var volAidArr = document.forms[0].elements["volumeInfo.aid"].value.split(",");
    document.forms[1].aid.value = volAidArr[0];

    /* forms[0].elements["volumeInfo.raidType"] is 1|5|10|50|6(4+PQ)|6(8+PQ),
        but forms[1].raidType is  1|5|10|50|64|68 */
    var volRaidType = document.forms[0].elements["volumeInfo.raidType"].value;
    if (volRaidType == "6(4+PQ)") {
        document.forms[1].raidType.value = "64";    
    } else if (volRaidType == "6(8+PQ)") {
        document.forms[1].raidType.value = "68"; 
    } else {
        document.forms[1].raidType.value = volRaidType; 
    }
    
    var usableCapVal = document.forms[0].usableCap.value;
    if (usableCapVal != null && usableCapVal != "") {
        document.getElementById("usableCapDiv").innerHTML = usableCapVal;
    }
    var tmpinfo=document.forms[0].elements["volumeInfo.poolNameAndNo"].value;
    tmpinfo=tmpinfo.replace(/<br>/g,"#");
    document.forms[1].poolinfonameno.value=tmpinfo;
</logic:notEqual>  
<logic:equal name="isNashead" value="true">
    var extendSize = document.forms[0].elements["volumeInfo.extendSize"].value;
    if(extendSize == ""){
        document.getElementById("selectedLunSize").innerHTML = "--";
    }else{
        document.getElementById("selectedLunSize").innerHTML = extendSize; 
    }
    window.selectedLdPath = document.forms[0].elements["selectedLdPath"];
    window.wwnn = document.forms[0].elements["volumeInfo.wwnn"];
    window.usedStorage = document.forms[0].elements["volumeInfo.lunStorage"];
    window.storage4Extend = document.forms[0].elements["volumeInfo.storage4Extend"];
    window.differentSize = document.forms[0].elements["differentSize"];;
    
    <logic:equal name="isGfsVolume" scope="request" value="true">
    window.stripingRdo = document.getElementById("striping");
    window.notStripingRdo = document.getElementById("notStriping");
    window.gfsLicense = "<bean:write name="hasGfsLicense" scope="request"/>";
    
    if(stripingRdo && notStripingRdo){
	    var lunArray = selectedLdPath.value.split(",");
	    if(lunArray.length >=2 ){
	        stripingRdo.disabled = false;
	        notStripingRdo.disabled = false;
	    }else{
	        stripingRdo.disabled = true;
	        notStripingRdo.disabled = true;
	    }
	}
    </logic:equal>
</logic:equal>  
}
</script>
</head>
<body onLoad="init();displayAlert();"
onUnload="unLockMenu();closePopupWin(heartBeatWin);closePopupWin(poolWin);closePopupWin(volume_winhandler);closeDetailErrorWin();">
<h1 class="title"><bean:message key="title.h1"/></h1>
<html:button property="backBtn" onclick="backToList();">
   <bean:message key="common.button.back" bundle="common"/>
</html:button>
<h2 class="title"><bean:message key="title.extend.h2"/></h2>
<displayerror:error h1_key="title.h1"/>
<br>
<jsp:include page="volumelicensecommon.jsp" flush="true"/>
<html:form action="volumeExtend.do" onsubmit="return onExtend();">
	<input type="hidden" name="selfURL" value="/nsadmin/volume/volumeExtendShow.do">
	<html:hidden property="differentSize"/>
	<html:hidden property="usableCap"/>
    <nested:nest property="volumeInfo"> 
    <nested:hidden property="volumeName"/>
    <nested:hidden property="mountPoint"/>    
    <nested:hidden property="capacity"/>

	<table border="1" nowrap class="Vertical">
      <tr>
        <th align=left><bean:message key="info.volumeName"/></th>
        <td align=left colspan=<%=colSize%>>
            <nested:define id="volumeName4Show" property="volumeName"/>
        	<%=volumeName4Show.toString().replaceFirst("NV_LVM_" , "")%>
        </td>
      </tr>
      <tr>
        <th align=left><bean:message key="info.volumeSize"/></th>
        <td align=left colspan=<%=colSize%>>
            <nested:define id="showCap" property="capacity" type="java.lang.String"/>
            <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap))%>
            <bean:message key="info.GB"/>
        </td>
      </tr>
      <tr>
        <th align=left><bean:message key="info.mountpoint"/></th>
        <td align=left colspan=<%=colSize%>>
            <nested:write property="mountPoint"/>
        </td>
      </tr>
      
      <logic:equal name="isNashead" value="true">
        <tr>
            <th aling="left" valign="top"><bean:message key="info.selected.lun"/></th>
            <td width="330px">
                <nested:define id="lunStorage" property="lunStorage" type="java.lang.String"/>
                <nested:define id="storage4Extend" property="storage4Extend" type="java.lang.String"/>
                <%
                    String showStorage =  lunStorage + "<BR>" + storage4Extend;
                    String divHeight = (showStorage.split("<BR>").length >=3) ? "54px" : "auto";
                %>
                <DIV id="selectedLun" style="overflow: auto; width: auto; height: <%=divHeight%>;">
                    <font color="#999999"><nested:write property="lunStorage" filter="false"/></font><br>    
                    <nested:write property="storage4Extend" filter="false"/>
                </DIV>
                <nested:hidden property="lunStorage"/>
                <nested:hidden property="storage4Extend"/>
                <nested:hidden property="wwnn"/>
                <html:hidden property="selectedLdPath"/>
                <nested:hidden property="lun"/>
                <nested:hidden property="storage"/>
            </td>
            <td align="right" valign="top"> 
                <html:button property="selectLunBtn" onclick="selectLun();">
                    <bean:message key="button.selectLun"/><bean:message key="button.dot"/>
                </html:button>
            </td>
          </tr>
          <tr>
            <th><bean:message key="info.extend.size.lun"/></th>
            <td colspan=<%=colSize%>>
                <DIV id="selectedLunSize">--</DIV>
                <nested:hidden property="extendSize"/>
            </td>
          </tr>
          <logic:equal name="hasGfsLicense" scope="request" value="true">
          <logic:equal name="isGfsVolume" scope="request" value="true">
	          <tr>
	            <th valign="top" rowspan="2"><bean:message key="info.gfs"/></th>
                <td colspan=2>
	               <nested:radio property="striping" styleId="striping" value="true"/>
	               <label for="striping"><bean:message key="info.striping"/></label>
	               &nbsp;&nbsp;
	               <nested:radio property="striping" styleId="notStriping" value="false"/>
	               <label for="notStriping"><bean:message key="info.not.striping"/></label>
	            </td>
	          </tr>
	      </logic:equal>
          </logic:equal>
        </tr>
      </logic:equal>
      
      <logic:notEqual name="isNashead" value="true">
        <nested:hidden property="aid"/>
        <nested:hidden property="raidType"/>
        <nested:hidden property="poolNo"/>
        <nested:hidden property="aname"/>
        <nested:hidden property="poolNameAndNo"/>

		<tr>
		  <th><bean:message key="info.diskarrayName"/></th>
		  <td colspan=2>
		      <nested:define id="aname" property="aname" type="java.lang.String"/>
		      <%=VolumeDetailAction.compactAndSort(aname)%>
		  </td>
		</tr>
		
        <tr>
          <th valign="top"><bean:message key="info.poolNameAndNo"/></th>
          <td colspan=2>
              <nested:define id="pool" property="poolNameAndNo" type="java.lang.String"/>
              <%String divHeight = (pool.split("<br>").length >=3) ? "54px" : "auto";%>
              <div id="poolNameAndNo" style="overflow: auto; width: auto; height: <%=divHeight%>">
                  <nested:write property="poolNameAndNo" filter="false"/>    
              </div>
          </td>          
        </tr>
          
        <tr>
          <th><bean:message key="info.selectedPool"/></th>
          <td>
              <nested:text property="poolName" size="20" readonly="true"/>
          </td>
          <td align="right"> 
              <html:button property="poolSelectBtn" onclick="openSelectPool();">
                  <bean:message key="button.poolSelect"/><bean:message key="button.dot"/>
              </html:button>
          </td>
        </tr>
               
        <tr>
          <th><bean:message key="info.raidType"/></th>
          <td colspan=2><nested:write property="raidType"/></td>
        </tr>
        
        <tr>
          <th><bean:message key="info.availCapacity"/></th>
          <td colspan=2>
              <DIV id="usableCapDiv"><bean:message key="info.off"/></DIV>
          </td>
        </tr>                      

        <tr>
          <th><bean:message key="info.extend.size"/></th>
          <td colspan=2>
             <nested:text property="extendSize" size="10" maxlength="10" style="text-align:right"/>                          
             <nested:select property="capacityUnit">
                 <html:option value="GB">GB</html:option>
                 <html:option value="TB">TB</html:option>
             </nested:select>
          </td>
        </tr>
        <logic:equal name="<%=VolumeActionConst.SESSION_DISKIARRAY_CONDORSERIES%>" value="true" scope="session">
	        <tr>
	    		<th><bean:message key="info.bltime.th"/><bean:message key="info.bltime.scale"/></th>
			    <td colspan=2><nested:text property="bltime" size="10" maxlength="3" style="text-align:right" />
	        		&nbsp;<bean:message key="info.bltime.td"/>&nbsp;&nbsp;<font class="advice"><bean:message key="info.bltime.tip"/></font></td>
			</tr>
        </logic:equal>
      </logic:notEqual>
    </table>
    </nested:nest>
    <br>
    <html:submit property="submitBtn"><bean:message key="common.button.submit" bundle="common"/></html:submit>
</html:form>

<logic:notEqual name="isNashead" value="true">  
	<html:form target="volume_selectPool" action="volumePoolSelect.do?from=volumeExtend&flag=notFromDisk">
		<html:hidden property="aid" value=""/>
		<html:hidden property="raidType" value=""/>
		<input type="hidden" name="poolinfonameno" value=""/>
	</html:form>
</logic:notEqual>
</body>
</html:html>