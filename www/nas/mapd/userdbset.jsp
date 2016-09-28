<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 
<!-- "@(#) $Id: userdbset.jsp,v 1.5 2007/05/09 06:45:16 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.model.entity.mapd.MapdConstant"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="struts-bean"   prefix="bean" %>
<%@ taglib uri="struts-html"   prefix="html" %>
<%@ taglib uri="struts-logic"  prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<html:html lang="true">

<bean:define id="is_nsview" value="<%=(NSActionUtil.isNsview(request))? "true":"false"%>"/>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function setButtonStatus(){
	<logic:notEqual name="is_nsview" value="true">
	    <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="" scope="request">
		document.udbset.set_auth.disabled=1;
		document.udbset.delete_auth.disabled=1;
	    </logic:equal>

	    <logic:notEqual name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="" scope="request">
		<logic:equal name="<%=MapdConstant.DMOUNT_HAS_AUTH%>" value="y" scope="request">
		    document.udbset.set_auth.disabled=1;
		    document.udbset.delete_auth.disabled=0;
		</logic:equal>

		<logic:equal name="<%=MapdConstant.DMOUNT_HAS_AUTH%>" value="n" scope="request">
		    document.udbset.set_auth.disabled=0;
		    document.udbset.delete_auth.disabled=1;
		</logic:equal>
	    </logic:notEqual>
	</logic:notEqual>

}

function udbSet(){
    if(isSubmitted()){
        return false;
    }
    if(confirm("<bean:message key="common.confirm" bundle="common"/>"+ "\r\n"
                 + "<bean:message key="common.confirm.action" bundle="common"/>"
                 + "<bean:message key="common.button.submit" bundle="common"/>")){
        document.udbset.action="setAuth.do?meth=setAuth";
        document.udbset.submit();
        setSubmitted();
        return true;
     }
     return false;
}

function udbDelete(){
    if(isSubmitted()){
        return false;
    }
    if(confirm("<bean:message key="common.confirm" bundle="common"/>"+ "\r\n"
                 + "<bean:message key="common.confirm.action" bundle="common"/>"
                 + "<bean:message key="common.button.delete" bundle="common"/>")){
        document.udbset.action="deleteAuth.do?meth=deleteAuth";
        document.udbset.submit();
        setSubmitted();
        return true;
     }
    return false;
   
}

function sethelp(){
    <logic:equal name="<%=MapdConstant.DMOUNT_FSTYPE%>" value="sxfsfw" scope="request">
        setHelpAnchor('usermap_wdatabase');
    </logic:equal>

    <logic:equal name="<%=MapdConstant.DMOUNT_FSTYPE%>" value="sxfs" scope="request">
        setHelpAnchor('usermap_udatabase');
    </logic:equal>
}
</script>
</head>

<BODY onload="setButtonStatus();sethelp();">
<h1 class="title"><bean:message key="udb.list.title.h1"/></h1>
<displayerror:error h1_key="udb.list.title.h1"/>
<form name="udbset" method="post" >
<input type="hidden" name="region" value="<bean:write name="<%=MapdConstant.ONE_AUTH%>" property="region"/>">
<input type="hidden" name="mp" value="<bean:write name="<%=MapdConstant.DMOUNT_NAME%>"/>">
<input type="button" value="<bean:message bundle="common" key="common.button.back"/>"  onClick="window.location='getMPList.do?meth=getMPList'"/>  
<P>
<table border=1 >
    <tr>
        <th><bean:message key="udb.table.th.volume"/></th>
        <td><bean:write name="<%=MapdConstant.DMOUNT_NAME%>" scope="request" filter="false"/></td>
    </tr>
</table>
<p>
<logic:equal name="<%=MapdConstant.DMOUNT_FSTYPE%>" value="sxfsfw" scope="request">
    <h2 class="title"><bean:message key="udb.set.title.h2.win"/></h2>
</logic:equal>

<logic:equal name="<%=MapdConstant.DMOUNT_FSTYPE%>" value="sxfs" scope="request">
    <h2 class="title"><bean:message key="udb.set.title.h2.unix"/></h2>
</logic:equal>

<logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="" scope="request">
    <bean:define id="fstype" name="<%=MapdConstant.DMOUNT_FSTYPE%>" scope="request"/>
    <br><bean:message key="udb.pageshow.hasNotSetDomain"/>
    <br><bean:message key="udb.pageshow.addDomain4E"/>
    <A href ="<%=response.encodeURL("/nsadmin/menu/nas/mapd/userdbdomainconf.jsp")%>?fromWhere=userdb&dispMode=<%=fstype%>">
    <bean:message key="udb.pageshow.addDomain"/></A>
    <bean:message key="udb.pageshow.addDomain4J"/>
    <br>
</logic:equal>

<logic:notEqual name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="" scope="request">
    <table border=1>
    <tr>
        <th align="left"><bean:message key="udb.table.th.udbType"/></th>
        <td>
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="nis" scope="request">
            <bean:message key="udb.nis"/>
        </logic:equal>
        
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="pwd" scope="request">
            <bean:message key="udb.pwd"/>
        </logic:equal>
        
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="ldu" scope="request">
            <bean:message key="udb.ldap"/>
        </logic:equal>
        
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="ads" scope="request">
            <bean:message key="udb.ads"/>
        </logic:equal>
        
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="shr" scope="request">
            <bean:message key="udb.shr"/>
        </logic:equal>
        
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="dmc" scope="request">
            <bean:message key="udb.nt"/>
        </logic:equal>
        </td>
    </tr>
    <logic:equal name="<%=MapdConstant.DMOUNT_FSTYPE%>" value="sxfsfw" scope="request">
        <tr>
            <th align="left"><bean:message key="udb.domain"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="ntdomain" scope="request" filter="false"/></td>
        </tr>
        <tr>
            <th align="left"><bean:message key="udb.netbios"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="netbios" scope="request" filter="false"/></td>
        </tr>
    </logic:equal>
    
    <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="nis" scope="request">
        <tr>
            <th align="left"><bean:message key="udb.nis.nisDomain"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="nisdomain" scope="request" filter="false"/></td>
        </tr>
        <tr>
            <th align="left"><bean:message key="udb.nis.nisServer"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="nisserver" scope="request" filter="false"/></td>
        </tr>
    </logic:equal>

    <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="pwd" scope="request">
        <tr>
            <th align="left"><bean:message key="udb.pwd.ludb"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="ludb" scope="request" filter="false"/></td>
        </tr>
    </logic:equal>

    <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="ldu" scope="request">
        <tr>
            <th align="left"><bean:message key="udb.ldap.ldapServer"/></th>
            <bean:define id="ldapserver" name="<%=MapdConstant.ONE_AUTH%>" property="ldapserver" scope="request"/>
            <td><%=NSActionUtil.sanitize(ldapserver.toString(),true)%></td>
        </tr>
        <tr>
            <th align="left"><bean:message key="udb.ldap.baseDn"/></th>
            <bean:define id="basedn" name="<%=MapdConstant.ONE_AUTH%>" property="basedn" scope="request"/>
            <td><%=NSActionUtil.sanitize(basedn.toString(),true)%></td>
        </tr>
        <tr>
            <th align="left"><bean:message key="udb.ldap.authtype"/></th>
            <td>
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="mech" value="CRAM-MD5" scope="request">
                <bean:message key="udb.ldap.cram-md5"/>
            </logic:equal>
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="mech" value="DIGEST-MD5" scope="request">
                <bean:message key="udb.ldap.digest-md5"/>
            </logic:equal>
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="mech" value="SIMPLE" scope="request">
                <bean:message key="udb.ldap.simple"/>    
            </logic:equal>  
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="mech" value="Anonymous" scope="request">
                <bean:message key="udb.ldap.anon"/>    
            </logic:equal>
            </td>
        </tr>

        <bean:define id="authname" name="<%=MapdConstant.ONE_AUTH%>" property="authname" scope="request"/>
        <logic:notEqual name="<%=MapdConstant.ONE_AUTH%>" property="authname" value="" scope="request">
            <tr>
                <th align="left"><bean:message key="udb.ldap.ldapAuthName"/></th>
                <td><%=NSActionUtil.sanitize(authname.toString(),true)%></td>
            </tr>   
        </logic:notEqual>
        
        <tr>
            <th align="left"><bean:message key="udb.ldap.TLS"/></th>
            <td>
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="tls" value="yes" scope="request">
                <bean:message key="udb.ldap.SSL_TLS"/>
            </logic:equal>
            
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="tls" value="start_tls" scope="request">
                <bean:message key="udb.ldap.startTLS"/>
            </logic:equal>
            
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="tls" value="no" scope="request">
                <bean:message key="udb.ldap.noTLS"/>
            </logic:equal>
            </td>
        </tr>
        
        <bean:define id="ca" name="<%=MapdConstant.ONE_AUTH%>" property="ca" scope="request"/>
        <logic:notEqual name="<%=MapdConstant.ONE_AUTH%>" property="ca" value="" scope="request">
            <tr>
                <th align="left"><bean:message key="udb.ldap.ldapCa"/></th>
                <td><%=NSActionUtil.sanitize(ca.toString(),true)%></td>
            </tr>   
        </logic:notEqual>
        
                
        <tr>
            <th align="left"><bean:message key="udb.ldap.userFilter"/></th>
            <td>
            <bean:define id="uf" name="<%=MapdConstant.ONE_AUTH%>" property="ufilter" scope="request"/>
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="ufilter" value="" scope="request">
                <bean:message key="udb.common.notset"/>
            </logic:equal>
            <logic:notEqual name="<%=MapdConstant.ONE_AUTH%>" property="ufilter" value="" scope="request">
                <%=NSActionUtil.sanitize(uf.toString(),true)%>
            </logic:notEqual>
            </td>
        </tr>
        <tr>
            <th align="left"><bean:message key="udb.ldap.groupFilter"/></th>
            <td>
            <bean:define id="gf" name="<%=MapdConstant.ONE_AUTH%>" property="gfilter" scope="request"/>
            <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="gfilter" value="" scope="request">
                <bean:message key="udb.common.notset"/>
            </logic:equal>
            <logic:notEqual name="<%=MapdConstant.ONE_AUTH%>" property="gfilter" value="" scope="request">
                <%=NSActionUtil.sanitize(gf.toString(),true)%>
            </logic:notEqual>
            </td>
        </tr>
        
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="mech" value="CRAM-MD5" scope="request">
            <tr>
                <th align="left"><bean:message key="udb.ldap.clientUa"/></th>
                <td>
                <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="un2dn" value="y" scope="request">
                    <bean:message key="udb.ldap.utoa"/>
                </logic:equal>
                <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="un2dn" value="n" scope="request">
                    <bean:message key="udb.ldap.utoa_not"/>
                </logic:equal>
                </td>
            </tr>
        </logic:equal>
        <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="mech" value="DIGEST-MD5" scope="request">
            <tr>
                <th align="left"><bean:message key="udb.ldap.clientUa"/></th>
                <td>
                <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="un2dn" value="y" scope="request">
                    <bean:message key="udb.ldap.utoa"/>
                </logic:equal>
                <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="un2dn" value="n" scope="request">
                    <bean:message key="udb.ldap.utoa_not"/>
                </logic:equal>
                </td>
            </tr>
        </logic:equal>
    </logic:equal>

    <logic:equal name="<%=MapdConstant.ONE_AUTH%>" property="domaintype" value="ads" scope="request">
        <tr>
            <th align="left"><bean:message key="udb.ads.dns"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="dns" scope="request" filter="false"/></td>
        </tr>
        <tr>
            <th align="left"><bean:message key="udb.ads.kdc"/></th>
            <td><bean:write name="<%=MapdConstant.ONE_AUTH%>" property="kdcserver" scope="request" filter="false"/></td>
        </tr>
    </logic:equal>

    </table>
</logic:notEqual>

<br>
<logic:notEqual name="is_nsview" value="true">
<input type="button" name="set_auth" value ="<bean:message key="common.button.submit" bundle="common"/>" onclick="udbSet()">
<input type="button" name="delete_auth" value ="<bean:message key="common.button.delete" bundle="common"/>" onclick="udbDelete()">
</logic:notEqual> 
</form>
</BODY>
</html:html>
