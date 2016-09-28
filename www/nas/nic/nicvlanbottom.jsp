<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: nicvlanbottom.jsp,v 1.3 2007/05/09 06:46:23 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%> 
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<html:base/>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javaScript">
		function onSetting(){
		    if (isSubmitted()){
                return false;
            }
		    window.parent.frames[0].document.forms[0].vid.value = trim(window.parent.frames[0].document.forms[0].vid.value);
		    
		    if(  window.parent.frames[0].document.forms[0].vlanCount.value>=64){
			        alert("<bean:message key="alert.message.vlan.toomuch"/>");    
			        return false;
            }     
		    if(!isValidDigit(parent.frames[0].document.forms[0].vid.value,1,4094)){
		          alert("<bean:message key="alert.message.vlan.invalidvid"/>");
		          parent.frames[0].document.forms[0].vid.focus();
		          return false;
		    }
            parent.frames[0].document.forms[0].vid.value=parseInt(parent.frames[0].document.forms[0].vid.value,10);
		    var index = window.parent.frames[0].document.forms[0].nicNameList.options.selectedIndex;  
            if(index == -1){
                return false;
            }
            options = window.parent.frames[0].document.forms[0].nicNameList.options;
            document.forms[0].interfaceName.value = options[index].value+"."+window.parent.frames[0].document.forms[0].vid.value;
            var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
              "<bean:message key="common.confirm.action" bundle="common"/>"+ "<bean:message key="common.button.submit" bundle="common"/>";   
            if(confirm(msg)){
                setSubmitted();               
                return true;
            }
		    return false;
		}		
		
		function changeButtonStatus() {
			if(window.parent.frames[0].document) {
				if(window.parent.frames[0].buttonEnable == 1) {
				    document.forms[0].set.disabled = false;			     
				}
				else {
					document.forms[0].set.disabled = true;
				}
			}
		}
		</script>
</head>
<body onload="changeButtonStatus();">
  <form name="interfaceNameForm" action="../../nic/dispVlanTop.do?Operation=onSet"  target="_parent" method="post" 
        onsubmit="return onSetting()">
     <input type="submit" name="set"
	   value='<bean:message key="common.button.submit" bundle="common"/>' disabled="true" />
	 <input type="hidden" name="interfaceName" />
	 <input type="hidden" name="nic_from4change" value="vlan"/>
  </form>
</body>
</html:html>
