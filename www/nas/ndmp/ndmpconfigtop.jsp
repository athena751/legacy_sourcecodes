<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ndmpconfigtop.jsp,v 1.7 2007/05/09 05:38:39 wanghui Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>

<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>

<script language="javaScript">
var buttonEnable = 0;
var oldCheckPassword = "no";
<bean:define id="ndmp_running_version" name="ndmpConfigInfoForm" property="ndmpConfig.defaultVersion"/>
var lastSelectVersion = "<bean:write name='ndmp_running_version'/>";
    
    function enableSet() {
        buttonEnable = 1;
        if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
            window.parent.frames[1].enableBottomButton();
        }
    }
    
    function init() {
        setHelpAnchor("backup_ndmp_4");
        initPassword();       
        displayAlert();
        <logic:equal name="ndmp_set_needToAlert" value="true" scope="session">
            alert("<bean:message key="ndmp.setting.haveSession"/>");            
        </logic:equal>
        <logic:notEmpty name="control_interfaces">
            <logic:notEqual name="needToAlert" value="true" scope="session">
                enableSet();
            </logic:notEqual>
            <logic:empty name="ndmpConfigInfoForm" property="ndmpConfig.ctrlConnectionIP">
                document.forms[0].elements["ndmpConfig.ctrlConnectionIP"].selectedIndex=0;
            </logic:empty>
            <logic:empty name="ndmpConfigInfoForm" property="ndmpConfig.dataConnectionIP">
            	document.forms[0].elements["ndmpConfig.dataConnectionIP"].selectedIndex=0;
            </logic:empty>
        </logic:notEmpty>
        <% session.setAttribute("ndmp_set_needToAlert", "false");%>
        <logic:equal name="ndmpConfigInfoForm" property="ndmpConfig.hasSetPassword" value="yes">
            oldCheckPassword = "yes";
        </logic:equal>
        <logic:notEqual name="ndmpConfigInfoForm" property="ndmpConfig.hasSetPassword" value="yes">    
            <logic:empty name="ndmpConfigInfoForm" property="ndmpConfig.ctrlConnectionIP">
                oldCheckPassword = "yes";
            </logic:empty>
        </logic:notEqual>
        <logic:empty name="control_interfaces">
            alert("<bean:message key="ndmp.setting.no_interfaces"/>");
        </logic:empty>
    }

    function onSet() {
        if(isSubmitted()) {
            return false;
        }
        
        if (lastSelectVersion != "2") {
            if(!checkAll()) {
                return false;
            }
        }
        
        if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
            '<bean:message key="common.confirm.action" bundle="common"/>'+
            '<bean:message key="common.button.submit" bundle="common"/>')){
            return false;
        }
        setSubmitted();
        document.forms[0].elements["ndmpConfig.defaultVersion"].value = document.forms[0].elements["ndmpConfig.objectVersion"].value;
        if (document.forms[0].elements["ndmpConfig.objectVersion"].value != lastSelectVersion &&
            (document.forms[0].elements["ndmpConfig.objectVersion"].value == "2" || 
            lastSelectVersion == "2")) {
            document.forms[0].elements["ndmpConfig.defaultVersion"].value = lastSelectVersion;
            document.forms[0].elements["ndmpConfig.objectVersion"].value = lastSelectVersion;
        }
        document.forms[0].submit();
    }
    
    function onReload() {
        if (isSubmitted()) {
            return false;
        }
        setSubmitted();
        window.parent.location="ndmpConfigFrame.do";
        return true; 
    }
    
    function changePasswdStatus() {
        if (document.forms[0].elements["ndmpConfig.hasSetPassword"].checked){
            document.forms[0].elements["ndmpConfig.password_"].disabled=false;
            document.forms[0].repeatpassword_.disabled=false;
        }else{
            document.forms[0].elements["ndmpConfig.password_"].disabled=true;
            document.forms[0].repeatpassword_.disabled=true;
        }
        return true;
    }
    
    function modifyPassShow() {
        if((document.forms[0].elements["ndmpConfig.password_"].value == document.forms[0].defaultValueForPass.value)
            ||(document.forms[0].repeatpassword_.value==document.forms[0].defaultValueForPass.value)){
            document.forms[0].elements["ndmpConfig.password_"].value="";
            document.forms[0].repeatpassword_.value="";
        }
    }
    
    function initPassword() {
        <logic:notEqual name="ndmpConfigInfoForm" property="ndmpConfig.hasSetPassword" value="yes">
            <logic:empty name="ndmpConfigInfoForm" property="ndmpConfig.ctrlConnectionIP">
                document.forms[0].elements["ndmpConfig.hasSetPassword"].checked = true;
                changePasswdStatus();
                return;
            </logic:empty>
        </logic:notEqual>
        <logic:equal name="ndmpConfigInfoForm" property="ndmpConfig.hasSetPassword" value="yes">
            <logic:empty name="ndmpConfigInfoForm" property="ndmpConfig.password_">
                document.forms[0].elements["ndmpConfig.password_"].value=document.forms[0].defaultValueForPass.value;
                document.forms[0].repeatpassword_.value=document.forms[0].elements["ndmpConfig.password_"].value;
            </logic:empty>
        </logic:equal>
        changePasswdStatus();
    }
    
    function checkPassword() {
        var invalidChar = /[^\x00-\x7f]/g;
        if((document.forms[0].elements["ndmpConfig.password_"].value == "") || 
            (document.forms[0].elements["ndmpConfig.password_"].value.search(invalidChar) != -1)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="ndmp.setting.invalidPassword"/>");
            document.forms[0].elements["ndmpConfig.password_"].value = "";
            document.forms[0].repeatpassword_.value = "";
            document.forms[0].elements["ndmpConfig.password_"].focus();
            return false;
        }
        if(document.forms[0].elements["ndmpConfig.password_"].value != document.forms[0].repeatpassword_.value) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="ndmp.setting.passwordDiff"/>");
            document.forms[0].elements["ndmpConfig.password_"].value = "";
            document.forms[0].repeatpassword_.value = "";
            document.forms[0].elements["ndmpConfig.password_"].focus();
            return false;
        }
        return true;
    }
    
    function checkAuthorizedDMAIP(){
        var tmpDMA = trim(document.forms[0].elements["ndmpConfig.authorizedDMAIP"].value);
        document.forms[0].elements["ndmpConfig.authorizedDMAIP"].value = tmpDMA.replace(/[\s]+/g, " ");
        if(tmpDMA == "") {
            return true;
        }
        var IPArray = tmpDMA.split(/[\s]+/g);
        if(IPArray.length > 10) {
            return false;
        }
        for(var i = 0; i < IPArray.length; i ++) {
            if(!checkIP(IPArray[i])) {
                return false;
            }
        }
        return true;
    }
    
    function checkAll() {
        document.forms[0].elements["ndmpConfig.changePassword"].value = "yes";
        
        if (!checkAuthorizedDMAIP()) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="ndmp.setting.invalidHostsAllow"/>");
            document.forms[0].elements["ndmpConfig.authorizedDMAIP"].focus();
            return false;
        }
        
        if (document.forms[0].elements["ndmpConfig.ctrlConnectionIP"]){
            if(document.forms[0].elements["ndmpConfig.ctrlConnectionIP"].selectedIndex
                && document.forms[0].elements["ndmpConfig.ctrlConnectionIP"].selectedIndex == -1){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                      + "<bean:message key="ndmp.setting.ctrlInterfaceNotSpecify"/>");
                document.forms[0].elements["ndmpConfig.ctrlConnectionIP"].focus();
                return false;
            }
        }
        if(document.forms[0].elements["ndmpConfig.dataConnectionIP"]) {
            if(document.forms[0].elements["ndmpConfig.dataConnectionIP"].selectedIndex
                && document.forms[0].elements["ndmpConfig.dataConnectionIP"].selectedIndex == -1){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                      + "<bean:message key="ndmp.setting.dataInterfaceNotSpecify"/>");
                document.forms[0].elements["ndmpConfig.dataConnectionIP"].focus();
                return false;
            }
        }
        
        if(oldCheckPassword == "no" && !document.forms[0].elements["ndmpConfig.hasSetPassword"].checked) {
            document.forms[0].elements["ndmpConfig.changePassword"].value = "no";
        }
        
        if(document.forms[0].elements["ndmpConfig.hasSetPassword"].checked) {
            if(document.forms[0].elements["ndmpConfig.password_"].value == document.forms[0].defaultValueForPass.value) {
                document.forms[0].elements["ndmpConfig.changePassword"].value = "no";
            } else {
                if(!checkPassword()) {
                    return false;
                }
            }
        }
        
        return true;
    }
    function versionChange(){    
        if (document.forms[0].elements["ndmpConfig.objectVersion"]&&
           document.forms[0].elements["ndmpConfig.objectVersion"].value=="2"){           
	        document.getElementById("version4_table").style.display = "none";
		    document.getElementById("version2_table").style.display = "block";	
	    } else {	    
	        document.getElementById("version2_table").style.display = "none";
		    document.getElementById("version4_table").style.display = "block";
	    }	       
	    lastSelectVersion = document.forms[0].elements["ndmpConfig.objectVersion"].value;
    }
</script>
</head>
    <body onload="init();" onUnload="closeDetailErrorWin();">
        <html:form action="ndmpConfig.do?operation=setNdmpConfigInfo"  target="_parent">
            <displayerror:error h1_key="ndmp.common.h1"/>
            <nested:nest property="ndmpConfig">
            <html:button property="reload" onclick="onReload()">
                <bean:message key="common.button.reload" bundle="common"/>
            </html:button><br><br>
            <table border="1" class="VerticalTop">
              <tr>
                <th><bean:message key="ndmp.info.table.defaultVersion" /></th>
                <td>
                  <nested:hidden property="defaultVersion"/>
                  <nested:select property="objectVersion">
                      <html:option value="4"><bean:message key="ndmp.setting.version4"/>&nbsp;&nbsp;&nbsp;</html:option>
                      <html:option value="3"><bean:message key="ndmp.setting.version3"/>&nbsp;&nbsp;&nbsp;</html:option>
                      <html:option value="2"><bean:message key="ndmp.setting.version2"/>&nbsp;&nbsp;&nbsp;</html:option>
                  </nested:select>
                  <html:button property="choose" onclick="versionChange();">
                    <bean:message key="ndmp.setting.version.select"/>
                  </html:button>
                </td>
              </tr>  
            </table>
            <br>
            <hr>
            <% String displayStyleV4 = "display:none;";
               String displayStyleV2 = "display:none;";
            %>
            <logic:equal name="ndmpConfigInfoForm" property="ndmpConfig.defaultVersion" value="2">
            <% displayStyleV4 = "display:none;";
               displayStyleV2 = "display:block;";  
            %>
            </logic:equal>               
            <logic:notEqual name="ndmpConfigInfoForm" property="ndmpConfig.defaultVersion" value="2">
            <% displayStyleV2 = "display:none;";
               displayStyleV4 = "display:block;";
            %>
            </logic:notEqual>  
        <div id="version4_table" style="<%=displayStyleV4%>"> 
        <table border="1" class="VerticalTop">
            <tr>
              <th><bean:message key="ndmp.info.table.DMAIP" /></th>
              <td>
                <nested:text property="authorizedDMAIP" size="64" maxlength="200"/><br>
                [<font class="advice"><bean:message key="ndmp.setting.DMAIP_note"/></font>]
              </td>
            </tr>
            <tr>
                <th><bean:message key="ndmp.info.table.ctrlConnectionIP" /></th>
                <td>
                  <logic:notEmpty name="control_interfaces">
                    <table border="0">
                      <tr>
                        <td>
                          <nested:select property="ctrlConnectionIP" multiple="true" size="4">
                            <nested:options name="control_interfaces" labelName="control_interfacesLabel"/>
                          </nested:select>
                        </td>
                        <td valign="top"><bean:message key="ndmp.setting.currentsetting"/></td>
                        <td valign="top">
                          <nested:empty property="ctrlConnectionIP">
                            <bean:message key="ndmp.setting.nic_not_specified"/>
                          </nested:empty>
                          <nested:notEmpty property="ctrlConnectionIP">
                            <nested:iterate id="nic" property="ctrlConnectionIP">
                              <bean:write name="nic"/><br>
                            </nested:iterate>
                          </nested:notEmpty>
                        </td>
                      </tr>
                    </table>
                    [<font class="advice"><bean:message key="ndmp.setting.nic_note"/></font>]
                  </logic:notEmpty>
                  <logic:empty name="control_interfaces">
                    <table border="0">
                      <tr>
                        <td valign="top"><bean:message key="ndmp.setting.currentsetting"/></td>
                        <td valign="top">
                          <nested:empty property="ctrlConnectionIP">
                            <bean:message key="ndmp.setting.nic_not_specified"/>
                          </nested:empty>
                          <nested:notEmpty property="ctrlConnectionIP">
                            <nested:iterate id="nic" property="ctrlConnectionIP">
                              <bean:write name="nic"/><br>
                            </nested:iterate>
                          </nested:notEmpty>
                        </td>
                      </tr>
                    </table>
                  </logic:empty>
                </td>
            </tr>
            <tr>
                <th><bean:message key="ndmp.info.table.dataConnectionIP" /></th>
                <td>
                  <logic:notEmpty name="data_interfaces">
                    <table border="0">
                      <tr>
                        <td>
                          <nested:select property="dataConnectionIP" multiple="true" size="4">
                            <nested:options name="data_interfaces" labelName="data_interfacesLabel"/>
                          </nested:select>
                        </td>
                        <td valign="top"><bean:message key="ndmp.setting.currentsetting"/></td>
                        <td valign="top">
                          <nested:empty property="dataConnectionIP">
                            <bean:message key="ndmp.setting.nic_not_specified"/>
                          </nested:empty>
                          <nested:notEmpty property="dataConnectionIP">
                            <nested:iterate id="nic" property="dataConnectionIP">
                              <bean:write name="nic"/><br>
                            </nested:iterate>
                          </nested:notEmpty>
                        </td>
                      </tr>
                    </table>
                    [<font class="advice"><bean:message key="ndmp.setting.nic_note"/></font>]
                  </logic:notEmpty>
                  <logic:empty name="data_interfaces">
                    <table border="0">
                      <tr>
                        <td valign="top"><bean:message key="ndmp.setting.currentsetting"/></td>
                        <td valign="top">
                          <nested:empty property="dataConnectionIP">
                            <bean:message key="ndmp.setting.nic_not_specified"/>
                          </nested:empty>
                          <nested:notEmpty property="dataConnectionIP">
                            <nested:iterate id="nic" property="dataConnectionIP">
                              <bean:write name="nic"/><br>
                            </nested:iterate>
                          </nested:notEmpty>
                        </td>
                      </tr>
                    </table>
                  </logic:empty>
                </td>
            </tr>            
            <tr>
              <th><bean:message key="ndmp.setting.password" /></th>
              <td>
                <table border="0">
                  <tr>
                    <td nowrap colspan="2">
                      <nested:checkbox property="hasSetPassword" styleId="usePasswdID1" value="yes" onclick="changePasswdStatus()"/>
                      <label for="usePasswdID1"><bean:message key="ndmp.setting.checkbox_setPass"/></label>
                      <input type="hidden" name="defaultValueForPass" value="&#127;&#127;&#127;&#127;&#127;&#127;">
                      <nested:hidden property="changePassword"/>
                    </td>
                    <td></td>
                  </tr>
                  <tr>
                    <td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="ndmp.setting.td_pass1"/></td>
                    <td><nested:password property="password_" size="32" maxlength="32"
                        onfocus="modifyPassShow();if(this.disabled) this.blur();"/></td>
                  </tr>
                  <tr>
                    <td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<bean:message key="ndmp.setting.td_pass2"/></td>
                    <td><input type="password" name="repeatpassword_" value="" size="32" maxlength="32"
                           onfocus="modifyPassShow();if (this.disabled) this.blur();" ></td>
                  </tr>
                </table>
              </td>
            </tr>
            
        </table>
        </div>
        <div id="version2_table" style="<%=displayStyleV2%>">
        <table border="1" class="VerticalTop">
            <tr>
                <th><bean:message key="ndmp.info.table.dataConnectionIP" /></th>
                <td>                 
                    <nested:select property="dataConnectionIPV2">
                       <html:option value=""><bean:message key="ndmp.setting.dataInfterface.option.notSpecify"/></html:option>
                       <logic:notEmpty name="data_interfaces">
                          <html:options name="data_interfaces" labelName="data_interfacesLabel"/>
                       </logic:notEmpty>
                    </nested:select>     
                </td>
            </tr>
            <tr>
                <th><bean:message key="ndmp.info.table.backupSoftware" /></th>
                <td>
                  <nested:select property="backupSoftware">
                      <html:option value="NetBackup"><bean:message key="ndmp.setting.backupSoftware.netBackup"/></html:option>
                      <html:option value="NetWorker"><bean:message key="ndmp.setting.backupSoftware.netWorker"/></html:option>                      
                  </nested:select>                  
                </td>
            </tr>
        </table>
        </div>
            </nested:nest>          
        </html:form>
    </body>
</html:html>