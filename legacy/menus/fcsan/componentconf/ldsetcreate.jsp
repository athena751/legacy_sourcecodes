<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ldsetcreate.jsp,v 1.2300 2003/11/24 00:55:03 nsadmin Exp $" -->

<html>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<head>
<title><nsgui:message key="fcsan_componentconf/newldset/msg_new"/></title>
<script>
    var ie4 = (document.all) ? true : false;
    var ns4 = (document.layers) ? true : false;
    var ns6 = (document.getElementById && !document.all) ? true : false;
    
    function writetolayer() {
        var ww;
        if (document.forms[0].iscsi.checked){
            ww = "iSCSI/";
        } else {
            ww = "NAS/";
        }
        if (ie4) document.all["mxh"].innerHTML = ww;
        if (ns4) {
            document.forms[0].action = "<%=response.encodeURL("ldsetcreate.jsp")%>";
            document.forms[0].target = "";
            document.forms[0].submit();
        }
        if (ns6) document.getElementById("mxh").innerHTML=ww;
    }
    
    function onOk() {
        buttonState();//for ns4.76 del key about onKeyUp events  
        if (document.forms[0].ok.disabled||document.forms[0].cancel.disabled)
            return false;
        var typeandname;
        if (document.forms[0].iscsi.checked) {
            if (check(document.forms[0].ldsetname_temp.value,10)) {
                typeandname=document.forms[0].ldsettype.options[document.forms[0].ldsettype.selectedIndex].value+":"+"iSCSI/"+document.forms[0].ldsetname_temp.value;
                if (confirm(<nsgui:message key="fcsan_componentconf/newldset/confirm_ldset_new" firstReplace="typeandname" separate="true"/>)) {
                    document.forms[0].ldsetname.value="iSCSI/"+document.forms[0].ldsetname_temp.value;
                    document.forms[0].ok.disabled=true;
                    document.forms[0].cancel.disabled=true;
	                document.forms[0].range.value="<nsgui:message key="fcsan_accesscontrol/newldset/msg_ip"/>";
                    return true;
                }
            } else {
                alertErr(10);
                return false;
            }
        } else {
            if (check(document.forms[0].ldsetname_temp.value,12)) {
                typeandname=document.forms[0].ldsettype.options[document.forms[0].ldsettype.selectedIndex].value+":"+"NAS/"+document.forms[0].ldsetname_temp.value;
                if (confirm(<nsgui:message key="fcsan_componentconf/newldset/confirm_ldset_new" firstReplace="typeandname" separate="true"/>)) {
                    document.forms[0].ldsetname.value="NAS/"+document.forms[0].ldsetname_temp.value;
                    document.forms[0].ok.disabled=true;
                    document.forms[0].cancel.disabled=true;
                    document.forms[0].range.value="<nsgui:message key="fcsan_accesscontrol/newldset/msg_fc"/>";
                    return true;
                }
            } else {
                alertErr(12);
                return false;
            }
        }
        return false
    }
    
    function alertErr(num) {
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+<nsgui:message key="fcsan_componentconf/newldset/confirm_ldsetname_error1" firstReplace="num" separate="true"/>)
    }
    
    function check(value,l) {
        var namerule=document.forms[0].ldsetname_temp.value;
        var avail=/[^0-9a-zA-Z\/_]/g;
        if (namerule.search(avail)!=-1||namerule.length>l) {
            return false;
        }
        return true;
    }
    
    function buttonState() {
        if (document.forms[0].cancel.disabled || document.forms[0].ldsettype.options[document.forms[0].ldsettype.selectedIndex].value==""||document.forms[0].ldsetname_temp.value=="") {
            document.forms[0].ok.disabled=true;
        } else {
            document.forms[0].ok.disabled=false;
            //document.forms[0].cancel.disabled=false;
        }
    }
    
    function submitForm() {
        document.forms[0].action='<%=response.encodeURL("../common/fcsanwait.jsp")%>';
        document.forms[0].target="createLDSET";
        win=window.open('','createLDSET','width=600,height=200,toolbar=no,menubar=no,resizable=yes,scrollbars=yes'); 
        win.focus();
        return true;
    }
</script>
</head>

<body onload="document.forms[0].ok.disabled=true;document.forms[0].cancel.disabled=false;"> 
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/newldset/msg_new"/></h2>
<br>
<form action="<%=response.encodeURL("../common/fcsanwait.jsp")%>" onsubmit="if(onOk()){return submitForm();} return false" >
    <table>
        <tr>
            <th align="left"><nsgui:message key="fcsan_common/label/h2_aname"/></th><td>:</td><td><%=request.getParameter("diskarrayname")%></td>  
        </tr>
        <tr>
            <th align="left"><label for="iscsiID"><nsgui:message key="fcsan_componentconf/table/th_purpose"/></label></th>
            <td>:</td>
            <td><input type="checkbox" name="iscsi" id="iscsiID" onclick="writetolayer()" <%=request.getParameter("iscsi")==null?"":"checked"%>></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="fcsan_componentconf/table/th_plat"/></th><td>:</td>
            <td>
            <select name="ldsettype" onchange='buttonState()'>
                <option value=""></option>
                <option value="A4">A4</option>
                <option value="A2">A2</option>
                <option value="NX">NX</option>
                <option value="WN">WN</option>
                <option value="CX">CX</option>
                <option value="LX">LX</option>
                <option value="AX">AX</option>
            </select>
            </td>  
        </tr>
        <tr>
            <th align="left"><nsgui:message key="fcsan_componentconf/table/msg_ld"/></th><td>:</td>
            <td>
            <SPAN ID="mxh" style="position:relative"><%=request.getParameter("iscsi")==null?"NAS/":"iSCSI/"%></SPAN>
           <input type="text" name="ldsetname_temp" value="" size=12 maxlength=12 onKeyUp="buttonState()"><input type="hidden" name="ldsetname" value=""></td>  
        </tr>
    </table>
    <br>
    <br>
    <center>
    <input type="submit" name="ok" value="<nsgui:message key="common/button/submit"/>" disabled >
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onclick="if (!this.disabled) window.close()">
    <input type="hidden" name="diskarrayname" value="<%=request.getParameter("diskarrayname")%>">
    <input type="hidden" name="target_jsp" value="../accesscontrol/ldsetnew.jsp">
    <input type="hidden" name="range" value="">
    </center>
</form>

</body>
</html>