<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ftpinfo.jsp,v 1.2310 2008/12/23 05:19:18 gaozf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="java.lang.Object
                 ,com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*" %>  
<%@ page import="com.nec.nsgui.model.biz.license.LicenseInfo"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<%LicenseInfo license=LicenseInfo.getInstance();
  int nodeNo = NSActionUtil.getCurrentNodeNo(request);
  if ((license.checkAvailable(nodeNo,"ftp"))==0){ //no license
%>
    <jsp:forward page='../../../framework/noLicense.do'>
        <jsp:param name="licenseKey" value="ftp"/>
    </jsp:forward>
<%}else{ //has license %>

<%if (request.getParameter("group")!=null){
        session.setAttribute("group",request.getParameter("group"));
    }
%>
<jsp:useBean id="bean" class="com.nec.sydney.beans.ftp.FTPSetBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<TITLE><nsgui:message key="nas_ftp/common/h1"/></TITLE>
<script LANGUAGE="JavaScript">
function goToSet()
{
    window.location="<%=response.encodeURL("ftpset.jsp")%>";
}

function onReload(){
    window.location ="<%=response.encodeURL("ftpinfo.jsp")%>";
}
</script>
</HEAD>

<BODY onload="displayAlert();">

<h1 class="title"><nsgui:message key="nas_ftp/common/h1"/></h1>
<input type="button" name="reloadBtn" value="<nsgui:message key="nas_ftp/ftp_info/reload"/>" onclick="onReload()">
<h2 class="title"><nsgui:message key="nas_ftp/ftp_info/h2"/></h2>

<P>

<%boolean isFtpConfFileExist=bean.isFtpConfFileExist();
if(isFtpConfFileExist){%>

<h3 class="title"><nsgui:message key="nas_ftp/ftp_info/basic_h3"/></h3>
<table border=1>
<!-- (nas 13408) [nsgui-necas-sv4 1299]
    <%//String portn=bean.getPortNumber();%>
    <tr>
	<th align="left"><nsgui:message key="nas_ftp/general_settings/port_number"/></th>
	<td>
	<%//if(portn.equals("21")){%>
	    <nsgui:message key="nas_ftp/general_settings/default_port"/>
	<%/*}else{
	    out.print(portn);
	}*/%>
	</td>
    </tr>
-->
   
    <%String passivestart=bean.getPassivePortStartNumber();
    String passiveend=bean.getPassivePortEndNumber();
    %>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/general_settings/passiveport"/></th>
        <td>
        <%if(passivestart.equals("36864")&&passiveend.equals("40960")){%>
            <nsgui:message key="nas_ftp/general_settings/default_passiveport"/>
        <%}else{
            out.print(passivestart);%>
            <nsgui:message key="nas_ftp/general_settings/connect_signal"/>
            <%out.print(passiveend);
        }%>
        </td>
    </tr>
    <%String basmaxc=bean.getBasMaxConnections();%>
    <tr>
	<th align="left"><nsgui:message key="nas_ftp/general_settings/maxclients"/></th>
	<td>
	<%if(basmaxc.equals("none")||basmaxc.equals("0")||basmaxc.equals("")){%>
	    <nsgui:message key="nas_ftp/general_settings/maxconnect"/>
	<%}else{
	    out.print(basmaxc);
	}%>
	</td>
    </tr>
    <%String basAccessMode=bean.getBasAccessMode();%>
    <tr>
	<th align="left"><nsgui:message key="nas_ftp/general_settings/write_protect"/></th>
	<td>
	<%if(basAccessMode.equals("ReadOnly")){%>
	    <nsgui:message key="nas_ftp/general_settings/read_only"/>
	<%}else if(basAccessMode.equals("ReadWrite")){%>
	    <nsgui:message key="nas_ftp/general_settings/read_write"/>
	<%}%>
	</td>
    </tr>
    <%String basClientMode=bean.getBasClientMode();%>
    <tr>
	<th align="left"><nsgui:message key="nas_ftp/general_settings/allow_deny_client"/></th>
        <td>
        <%if(basClientMode.equals("Allow")){%>
	    <nsgui:message key="nas_ftp/general_settings/client_allow"/>
	<%}else if(basClientMode.equals("Deny")){%>
	    <nsgui:message key="nas_ftp/general_settings/client_deny"/>
	<%}%>
        </td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/general_settings/client_list"/></th>
        <td><%=bean.getDottedBasClientList()%>&nbsp;</td>
    </tr>
    
<!-- shench 2008.12.3 start -->
    <% String basIdentdMode=bean.getBasIdentdMode();%>
    <tr>
		<th align="left"><nsgui:message key="nas_ftp/general_settings/user_identd"/></th>
	    <td>
	        <%if(basIdentdMode.equals("on")){%>
		      <nsgui:message key="nas_ftp/general_settings/identd_use"/>
		    <%}else if(!basIdentdMode.equals("on")){%>
		      <nsgui:message key="nas_ftp/general_settings/identd_not_use"/>
		    <%} %>
        </td>
    </tr>
<!-- end shench-->
</table>

<h3 class="title"><nsgui:message key="nas_ftp/ftp_info/auth_h3"/></h3>
<table border="1">
    <%String authdb=bean.getAuthDBType();%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/auth_settings/auth_db"/></th>
        <td>
        <%if(authdb.equals("nis")){%>
            NIS
        <%}else if(authdb.equals("pwd")){%>
            PWD
        <%}else if(authdb.equals("dmc")){%>
            PDC
        <%}else if(authdb.equals("ldu")){%>
            LDAP
        <%}%>&nbsp;
        </td>
    </tr>
    <%if(authdb.equals("nis")){%>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/nis_doamin"/></th>
        <td><%=bean.getNisDomain()%></td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/nis_server"/></th>
        <%String nisserverall=(bean.getNisServer()).replaceAll("\\s+","<br>");%>
        <td><%=nisserverall%></td>
    </tr>
    <%}else if(authdb.equals("pwd")){%>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/pwd"/></th>
        <td><%=bean.getLudbName()%></td>
    </tr>
    <%}else if(authdb.equals("dmc")){%>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/dmc_domain"/></th>
        <td><%=bean.getPdcDomain()%></td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/dmc_pdc"/></th>
        <td><%=bean.getPdcName()%>&nbsp;</td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/dmc_bdc"/></th>
        <td><%=bean.getBdcName()%>&nbsp;</td>
    </tr>
    <%}else if(authdb.equals("ldu")){%>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/ldap_server"/></th>
        <td><%=NSUtil.space2nbsp(bean.getLdapServer())%></td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/ldap_basedn"/></th>
        <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(bean.getLdapBaseDN()))%></td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_info/ldap_authtype"/></th>
        <td>
        <%String ldapMethod=bean.getLdapMethod();
        if (ldapMethod.equals("CRAM-MD5")){
            out.print(NSMessageDriver.getInstance().getMessage(session, "nas_ftp/auth_set/CRAM-MD5"));
        }else if(ldapMethod.equals("DIGEST-MD5")){
            out.print(NSMessageDriver.getInstance().getMessage(session, "nas_ftp/auth_set/DIGEST-MD5"));
        }else if(ldapMethod.equals("SIMPLE")&& !bean.getLdapBindName().equals("")){
            out.print(NSMessageDriver.getInstance().getMessage(session, "nas_ftp/auth_set/SIMPLE"));
        }else{
            out.println(NSMessageDriver.getInstance().getMessage(session, "nas_ftp/auth_set/Anonymous"));
        } %>
        </td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_mapd/nt/th_TLS"/></th>
        <td>
        <%if(bean.getLdapUseTls().equals("yes")){%>
            <nsgui:message key="nas_mapd/nt/td_useSSL_TLS"/>
        <%}else if(bean.getLdapUseTls().equals("start_tls")){%>
            <nsgui:message key="nas_mapd/nt/td_useStartTLS"/>
        <%}else{%>
            <nsgui:message key="nas_mapd/nt/td_no_useTLS"/>
        <%}%>
        </td>
    </tr>
    <tr>
        <th align="left">
            &nbsp;&nbsp;<nsgui:message key="nas_mapd/nt/th_userFilter"/>
        </th>
        <td>
        <% if ((bean.getLdapUserFilter()).equals("")){ %>
            &nbsp;
        <%}else{%>
            <%= NSUtil.space2nbsp(HTMLUtil.sanitize(bean.getLdapUserFilter()))%>
        <%}%>    
        </td>
    </tr>
    <tr>
        <th align="left">
            &nbsp;&nbsp;<nsgui:message key="nas_mapd/nt/th_groupFilter"/>
        </th>
        <td>
            <% if ((bean.getLdapGroupFilter()).equals("")){ %>
                &nbsp;
            <%}else{%>
                <%= NSUtil.space2nbsp(HTMLUtil.sanitize(bean.getLdapGroupFilter()))%>
            <%}%>    
        </td>
    </tr>
    
    <%if ((ldapMethod.equals("CRAM-MD5"))||(ldapMethod.equals("DIGEST-MD5"))){%>   
    <tr>
        <th align="left">
            &nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_set/ldap_clientUA"/>
        </th>
        <td>
            <% if ((bean.getUtoa()).equals("y")){ %>
                <nsgui:message key="nas_ftp/auth_set/ldap_utoa"/>
            <%}else{%>
                <nsgui:message key="nas_ftp/auth_set/ldap_utoa_not"/>
            <%}%>    
        </td>
    </tr>
    <%}%>
    
    <%}%>
    <%String authAccessType=bean.getAuthAccessType();%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/auth_settings/allow_deny_user"/></th>
        <td>
        <%if(authAccessType.equals("allow")){%>
            <nsgui:message key="nas_ftp/auth_settings/user_allow"/>
        <%}%>
        <%if(authAccessType.equals("deny")){%>
            <nsgui:message key="nas_ftp/auth_settings/user_deny"/>
        <%}%>
        </td>
    </tr>
    <tr>
        <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/auth_settings/user_list"/></th>
        <td><%=NSUtil.space2nbsp(bean.getDottedAuthUserList())%>&nbsp;</td>
    </tr>
    <%String usermappingtype=bean.getAuthUserMappingMode();%>
    <tr>
        <th valign="top" align="left"><nsgui:message key="nas_ftp/auth_settings/user_mapping_mode"/></th>
        <td>
        <%if(usermappingtype.equals("Normal")){%>
            <nsgui:message key="nas_ftp/auth_settings/user_mapping_available"/>
        <%}else if(usermappingtype.equals("Anonymous")){%>
            <nsgui:message key="nas_ftp/auth_settings/user_mapping_anonymous"/>
        <%}
        out.print("("+NSUtil.space2nbsp(bean.getAuthAnonUserName())+")");%>
        </td>
    </tr>
    <%String homedirmod=bean.getHomeDirMode();%>
    <tr>
        <th valign="top" align="left"><nsgui:message key="nas_ftp/auth_settings/home_dir"/></th>
        <td>
        <%if(homedirmod.equals("AuthDB")){%>
            <nsgui:message key="nas_ftp/auth_settings/use_auth_db"/>
        <%}else if(homedirmod.equals("FSSpecify")){%>
                <nsgui:message key="nas_ftp/auth_settings/use_fs_specify"/>
            <%out.print("("+NSUtil.space2nbsp(bean.getHomeDirName())+")");}%>
      	</td>
    </tr>
</table>


<h3 class="title"><nsgui:message key="nas_ftp/ftp_info/anon_h3"/></h3> 		
<table border="1">
    <%boolean anonuse=bean.isUseAnonFTP();%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/use_anonymous"/></th>
        <td>
        <%if(anonuse){%>
            <nsgui:message key="nas_ftp/anonymous_settings/use"/>
        <%}else{%>
            <nsgui:message key="nas_ftp/anonymous_settings/nouse"/>
        <%}%>
        </td>
    </tr>
    <%if(anonuse){%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/directory"/></th>
        <td><%=NSUtil.space2nbsp(bean.getAnonFTPDir())%></td>
    </tr>
    <%String anonmaxc=bean.getAnonMaxConnections();%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/max_connections"/></th>
        <td>
        <%if(anonmaxc.equals("none")||anonmaxc.equals("0")||anonmaxc.equals("")){%>
	    <nsgui:message key="nas_ftp/general_settings/maxconnect"/>
	    <%}else{%>    
	        <%=anonmaxc%>
	    <%}%>
	    </td>
    </tr>
    <%String anonAccessMode=bean.getAnonAccessMode();%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/write_protect"/></th>
        <td>
        <%if(anonAccessMode.equals("DownloadOnly")){%>
            <nsgui:message key="nas_ftp/anonymous_settings/download_only"/>
        <%}else if(anonAccessMode.equals("UploadOnly")){%>
            <nsgui:message key="nas_ftp/anonymous_settings/upload_only"/>
        <%}else if(anonAccessMode.equals("ReadWrite")){%>
            <nsgui:message key="nas_ftp/anonymous_settings/read_write"/>
        <%}%>
        </td>
    </tr>
    <%String anonClientMode=bean.getAnonClientMode();%>
    <tr>
        <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/allow_deny_client"/></th>
        <td>
        <%if(anonClientMode.equals("Allow")){%>
	    <nsgui:message key="nas_ftp/general_settings/client_allow"/>
	    <%}else if(anonClientMode.equals("Deny")){%>
	    <nsgui:message key="nas_ftp/general_settings/client_deny"/>
	    <%}%>
        </td>
    </tr>
    <tr>
      <th align="left">&nbsp;&nbsp;<nsgui:message key="nas_ftp/anonymous_settings/client_list"/></th>
      <td><%=bean.getDottedAnonClientList()%>&nbsp;</td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/user_name"/></th>
      <td><%=NSUtil.space2nbsp(bean.getAnonUserName())%></td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="nas_ftp/anonymous_settings/group_name"/></th>
      <td><%=NSUtil.space2nbsp(bean.getAnonGroupName())%></td>
    </tr>
    <%}%>
</table>
<br>
<%}else{%>
    <nsgui:message key="nas_ftp/alert/noconffile"/>
<%}%>
<form name="ftpset" method="post" action="../../../menu/common/forward.jsp">
<input type="hidden" name="alertFlag" value="enable">
<input type="button" name="set" value="<nsgui:message key="nas_ftp/common/button_modify"/>" onClick="goToSet();">
</form>
</BODY>
<%} //end for has license%>
</HTML>