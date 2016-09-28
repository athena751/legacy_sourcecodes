<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsglobaloption4nsview.jsp,v 1.8 2007/06/28 01:56:57 fengmh Exp $" -->

<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<bean:define id="isCluster" value="<%=Boolean.toString(NSActionUtil.isCluster(request))%>"/>

<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">

function init(){
    elements = document.forms[0].elements;
    setHelpAnchor('network_cifs_2');
}

function onReload(){

    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    window.location="setGlobal4nsview.do?operation=display";
    return true; 
	
}
</script>
</head>
<body onload="init();">
<html:form action="setGlobal4nsview.do" >
<nested:nest property="info">
<html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
 </html:button>
<h3 class="title"><bean:message key="cifs.globalOption.h3_basic"/></h3>
    <table border="1" class="Vertical">
      <tr>
        <th><bean:message key="cifs.globalOption.th_encoding"/></th>
        <td><%String encodingKey = "cifs.encoding.";
              String encode = NSActionUtil.getExportGroupEncoding(request);
              if(encode.equals(NSActionConst.ENCODING_UTF_8)){
                  encodingKey += encode + "." + NSActionUtil.getSessionAttribute(request, "machineSeries");
              }else{
                  encodingKey += encode;
              }%>
            <bean:message key="<%=encodingKey%>"/>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_security"/></th>
        <td>
            <bean:define id="secMode" name="cifs_securityMode"/>
            <%String secModeKey = "cifs.security." + secMode;%>
            <bean:message key="<%=secModeKey%>"/>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_encryptpasswd"/></th>
        <td>
            <nested:equal property="encryptPasswords" value="yes">
            	<bean:message key="cifs.globalOption.use"/>
            </nested:equal>
            <nested:notEqual property="encryptPasswords" value="yes">
            	<bean:message key="cifs.globalOption.nouse"/>
            </nested:notEqual>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_interfaces"/></th>
        <td>
              <nested:empty property="interfaces">
                <bean:message key="cifs.globalOption.nic_not_specified"/>
              </nested:empty>
              <nested:notEmpty property="interfaces">            
                <nested:iterate id="nic" property="interfaces">
                  <bean:write name="nic"/><br>                 
                </nested:iterate>
              </nested:notEmpty>                   
         </td>
      <tr>
        <th><bean:message key="cifs.globalOption.th_comment"/></th>
        <td>
	        <nested:empty property="serverString">
	   	<bean:message key="cifs.shareDetial.nocontent"/>
	        
			  </nested:empty>
	         <nested:notEmpty property="serverString">
               <nested:define id="serverString_td" property="serverString" type="java.lang.String"/>
               <%=NSActionUtil.htmlSanitize(serverString_td)%>
	        </nested:notEmpty>
        </td>
      </tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_deadtime"/></th>
        <td>
        	<nested:empty property="deadtime">
	   			<bean:message key="cifs.shareDetial.nocontent"/>
	        </nested:empty>
	        <nested:notEmpty property="deadtime">
	        <nested:write property="deadtime" /> <bean:message key="cifs.globalOption.minutes_fornsview"/>
	        </nested:notEmpty>
        </td>
      </tr>
      <logic:notEqual name="cifs_securityMode" value="Share">
	      <tr>
	        <th><bean:message key="cifs.globalOption.th_validusers"/></th>
	        <td>
		        <nested:empty property="validUsers">
		   			<bean:message key="cifs.shareDetial.nocontent"/>
		        </nested:empty>
		        <nested:notEmpty property="validUsers">
                  <nested:define id="validUsers_td" property="validUsers" type="java.lang.String"/>
                  <%=NSActionUtil.htmlSanitize(validUsers_td)%>
		        </nested:notEmpty>
	        </td>
	      </tr>
	      <tr>
	        <th><bean:message key="cifs.globalOption.th_invalidusers"/></th>
	        <td> 
	        	<nested:empty property="invalidUsers">
		   			<bean:message key="cifs.shareDetial.nocontent"/>
		        </nested:empty>
		        <nested:notEmpty property="invalidUsers">
                  <nested:define id="invalidUsers_td" property="invalidUsers" type="java.lang.String"/>
                  <%=NSActionUtil.htmlSanitize(invalidUsers_td)%>
		        </nested:notEmpty>
	        </td>
	      </tr>
      </logic:notEqual>      
      <tr>
        <th><bean:message key="cifs.globalOption.th_hostsallow"/></th>
        <td>
         <nested:empty property="hostsAllow">
			<bean:message key="cifs.shareDetial.nocontent"/>
		 </nested:empty>
		 <nested:notEmpty property="hostsAllow">
		 <nested:write property="hostsAllow" />
		 </nested:notEmpty>
        </td>
      </tr>
      <tr>
		<th><bean:message key="cifs.globalOption.th_hostsdeny"/></th>
		<td>
		<nested:empty property="hostsDeny">
			<bean:message key="cifs.shareDetial.nocontent"/>
		</nested:empty>
		<nested:notEmpty property="hostsDeny">
		<nested:write property="hostsDeny" />
		</nested:notEmpty>
		</td>
      </tr>
      <logic:equal name="<%=CifsActionConst.SESSION_HASANTIVIRUSSCAN_LICENSE%>" value="yes">
        <logic:equal name="<%=CifsActionConst.SESSION_SECURITY_MODE%>" value="<%=CifsActionConst.SECURITYMODE_ADS%>">
          <tr>
            <th><bean:message key="cifs.antiVirus"/></th>
            <td>
              <nested:equal property="antiVirusForGlobal" value="yes">
                <bean:message key="cifs.antiVirus.enabled" />
              </nested:equal>
              <nested:notEqual property="antiVirusForGlobal" value="yes">
                <bean:message key="cifs.antiVirus.disabled" />
              </nested:notEqual>
            </td>
          </tr>
        </logic:equal>
      </logic:equal>
      <tr>
      <th><bean:message key="cifs.common.th_otherOption"/></th>
      <td>
      	<nested:equal property="dirAccessControlAvailable" value="yes" >
			<bean:message key="cifs.globalOption.dirAccessControlAvailable_use"/>
		</nested:equal>
		<nested:notEqual property="dirAccessControlAvailable" value="yes">
			<bean:message key="cifs.globalOption.dirAccessControlAvailable_notuse"/>
		</nested:notEqual>
      </td>
    </tr>
    </table>
<h3 class="title"><bean:message key="cifs.globalOption.h3_accesslog"/></h3>
<p class="domain"><bean:message key="cifs.th.logging"/></p>
    <html:hidden property="useAccessLog"/>
    <table border="1" class="Vertical">
		<tr>
		<th><bean:message key="cifs.shareAccessLog.th_logging"/></th>
		<td>
		<nested:equal property="alogFile" value="" >
			<bean:message key="cifs.td.invalid"/>
		</nested:equal>
		<nested:notEqual property="alogFile" value="" >
			<bean:message key="cifs.td.valid"/>
		</nested:notEqual>
		</td>
		</tr>
      <tr>
        <th><bean:message key="cifs.globalOption.th_logfile"/></th>
        <td>
			<nested:equal property="alogFile" value="" >
				<bean:message key="cifs.shareDetial.nocontent"/>
			</nested:equal>
			<nested:notEqual property="alogFile" value="">
				<nested:write property="alogFile"/>
				<br>
	            <nested:equal property="canReadLog" value="yes">
					<bean:message key="cifs.globalOption.canread"/>
				</nested:equal>
				<nested:notEqual property="canReadLog" value="yes">
					<bean:message key="cifs.globalOption.cannotread"/>
				</nested:notEqual>  
			</nested:notEqual>    	
            
     	  
        </td>
      </tr>
      </table>
      <nested:notEqual property="alogFile" value="" >
      <p class="domain"><bean:message key="cifs.globalOption.th_logitem"/></p>
       <table border="1" class="Vertical">
                <tr>
                                <th align="center"><bean:message key="cifs.common.command"/></th>
                                <th align="center"><bean:message key="cifs.common.success"/></td>
                                <th align="center"><bean:message key="cifs.common.error"/></td>
                        </tr>
                        <tr>
                <logic:iterate name="cifs_globalLogItemMap" id="item">
                    <tr>
                        <td><bean:message name="item" property="value"/></td>
                        <bean:define id="keyValue" name="item" property="key" type="String"/>
                        <td align="center">
                                            &nbsp;
                                            <nested:notEmpty  property="successLoggingItems">
                                <nested:iterate id="succ"  property="successLoggingItems">
                                    <logic:equal name="succ" value="<%=keyValue%>">
                                        <img src="/nsadmin/images/nation/check.gif"/>
                                    </logic:equal>
                                </nested:iterate>
                        </nested:notEmpty>
                                                &nbsp;

                        </td>
                        <td align="center">
                                            &nbsp;
                            <nested:notEmpty  property="errorLoggingItems">
                                    <nested:iterate id="error" property="errorLoggingItems">
                                        <logic:equal  name="error"  value="<%=keyValue%>">
                                                <img src="/nsadmin/images/nation/check.gif">
                                        </logic:equal>
                                </nested:iterate>
                        </nested:notEmpty>
                                                &nbsp;
                        </td>
                    </tr>
                </logic:iterate>
            </tr>
    </table>
</nested:notEqual>
    <nested:equal property="alogFile" value="" >
    </nested:equal>

</nested:nest>
</html:form>

</body>
</html> 