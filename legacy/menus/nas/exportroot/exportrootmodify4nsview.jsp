<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportrootmodify4nsview.jsp,v 1.3 2006/05/16 01:16:20 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.exportroot.*
                    ,com.nec.sydney.atom.admin.mapd.*
            	    ,com.nec.sydney.framework.*
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.base.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="egmodifyBean" class="com.nec.sydney.beans.exportroot.ExportRootModifyBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean =egmodifyBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%
String exportGroupName = request.getParameter("exportgroup");
String codePage = request.getParameter("codepage");
DomainInfo domain4Unix = egmodifyBean.getDomain4Unix();
DomainInfo domain4Win = egmodifyBean.getDomain4Win();

boolean notdispdbinfo_U = false;
boolean notdispdbinfo_W = false;

if (domain4Unix!=null && domain4Unix.getDomainType().trim().equals("")){
    notdispdbinfo_U = true;
}
if (domain4Win!=null && domain4Win.getDomainType().trim().equals("")){
    notdispdbinfo_W = true;
}
String ldapMode = "";
String tls = "";
if (domain4Unix!=null || domain4Win!=null){
        DomainInfo domainInfo = (domain4Win==null)?domain4Unix:domain4Win;
        ldapMode = domainInfo.getMech().trim();
        if (ldapMode.equals("Anonymous")){
            ldapMode = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/Anonymous");
        }else if(ldapMode.equals("SIMPLE")){
            ldapMode = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/SIMPLE");
        }else if(ldapMode.equals("DIGEST-MD5")){
            ldapMode = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/DIGEST-MD5");
        }else if(ldapMode.equals("CRAM-MD5")){
            ldapMode = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/CRAM-MD5");
        }
        tls = domainInfo.getTls();
        if(tls.equals("yes")){
            tls = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/td_useSSL_TLS");
        }else if(tls.equals("start_tls")){
            tls = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/td_useStartTLS");
        }else{
            tls = NSMessageDriver.getInstance().getMessage(session, "nas_mapd/nt/td_no_useTLS");
        }
}
%>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<!-- for displaying the waitting page -->
<script src="../../../common/common.js"></script>

<script language="JavaScript">
    function onBack(){
        if( isSubmitted() ){
            return false;
        }
        setSubmitted();  
        window.location = "<%=response.encodeURL("exportRoot4nsview.jsp")%>";
        return false;
    }
    
    function reloadPage(){
        if( isSubmitted() ){
            return false;
        }
        setSubmitted();         
        window.location="<%= response.encodeURL("exportrootmodify4nsview.jsp?exportgroup=" + exportGroupName + "&codepage=" + codePage) %>";
    }
</script>
</HEAD>
<BODY>
<h1 class="title"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<form  method="post" name="modifyForm" action="">
    <input type="button" name="btnBack" value="<nsgui:message key="common/button/back"/>" onclick="return onBack();">
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
    <h2 class="title"><nsgui:message key="nas_exportroot/exportroot/h2_modify4nsview"/></h2> 
    <table border="1">
        <tr>
            <th align="left"><nsgui:message key="nas_exportroot/exportroot/th_path"/></th>
            <td><%=exportGroupName%></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_exportroot/exportroot/th_codepage"/></th>
            <td><%=egmodifyBean.codepageToDisplay(codePage)%></td>
        </tr>
    </table>
   
    <%if (domain4Unix == null){%>
    <p>
	<nsgui:message key="nas_mapd/unix/msg_info_fail"/>
    </p>
    <%}else{%>
    <h3 class="title"><nsgui:message key="nas_mapd/common/h3_unix"/></h3>
        <%if (notdispdbinfo_U){%>
        <p><nsgui:message key="nas_exportroot/exportroot/domain_unixnotset"/></p>
        <%}else{%>
        <table border="1">			
	<%if(domain4Unix.getDomainType().equals("nis")){%>
        	<tr>
        	<th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
        	<td><nsgui:message key="nas_mapd/unix/radio_nis"/></td>
        	</tr>
        	<tr>
        	<th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
        	</tr>
        	<tr>
        	<th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th><td>
        	<%=domain4Unix.getNisdomain()%></td>
        	</tr>
        	<tr>
        	<th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th>
        	<td><%=domain4Unix.getNisserver().replaceAll("\\s+","<br>")%></td>
        	</tr>	
        <%}else if(domain4Unix.getDomainType().equals("pwd")){%>
		<tr>
		<th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
		<td><nsgui:message key="nas_mapd/unix/radio_pwd"/></td>
		</tr>
        	<tr>
        	<th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
        	</tr>
		<tr>
		<th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
		<td><%=domain4Unix.getLudb()%></td>
		<tr>
       <%}else{%>
		<tr>
		<th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
		<td><nsgui:message key="nas_mapd/nt/h3_ldap"/></option></td>
		</tr>
        	<tr>
        	<th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
        	</tr>
		<tr>
		<th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>           
                <td><%=domain4Unix.getLdapserver()%></td>
                </tr>
                <tr>
                <th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
                <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Unix.getBasedn()))%></td>
                </tr>  
                <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
        	<td><%=ldapMode%></td>
    	        </tr>  

              <%if (!(domain4Unix.getAuthname()).equals("")){ %>
              <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></th>
                  <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Unix.getAuthname()))%></td>
              </tr>
              	  
              <%}%>

               <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
               <td><%=tls%></td>
               </tr>
              	  
              <%if (!(domain4Unix.getCa()).equals("")){ %>
              <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
                  <td>
                        <%=NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Unix.getCa()))%>
                  </td>
        	  </tr>
              <%}%>    
            <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
                <td>
                <% if ((domain4Unix.getUfilter()).equals("")){ %>
                    <nsgui:message key="nas_mapd/common/not_set"/>
                <%}else{%>
                    <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Unix.getUfilter()))%>
                <%}%>    
                </td>
            </tr>
            <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
                <td>
                <% if ((domain4Unix.getGfilter()).equals("")){ %>
                    <nsgui:message key="nas_mapd/common/not_set"/>
                <%}else{%>
                    <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Unix.getGfilter()))%>
                <%}%>    
                </td>
            </tr>
        <%}%>
	</table>
	<br>
      <%}%>
    <%}%>

    <%if (domain4Win == null){%>
    <p>
    	<nsgui:message key="nas_mapd/nt/msg_info_fail"/>
    </p>
    <%}else{%>
    <h3 class="title"><nsgui:message key="nas_mapd/common/h3_win"/></h3>
      <%if (notdispdbinfo_W){%>
        <p><nsgui:message key="nas_exportroot/exportroot/domain_winnotset"/></p>
      <%}else{%>
      <%String netBios=(domain4Win.getNetbios().equals(""))?NSMessageDriver.getInstance().getMessage(session, "nas_common/common/msg_no"):domain4Win.getNetbios();%>
      <table border="1">
      <%if (domain4Win.getDomainType().equals("ads")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_ads"/></td></tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domain4Win.getNtdomain()%></td></tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td></tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_dnsdomain"/></th>
    	  <td><%=domain4Win.getDns()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/dc"/></th>
    	  <td>
    	      <%if (egmodifyBean.getDc().equals("") || egmodifyBean.getDc().equals("*")){%>
    	          <nsgui:message key="nas_mapd/nt/dcfromdns"/>
    	      <%} else {%>
    	      	  <%=egmodifyBean.getDc()%>
    	      <%}%>
    	  </td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_kdcserver"/></th>
    	  <td><%=domain4Win.getKdcserver()%></td>
    	  </tr>
      <%} else if (domain4Win.getDomainType().equals("dmc")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_auth"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domain4Win.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
      <%} else if (domain4Win.getDomainType().equals("shr")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_shr"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domain4Win.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
      <%} else if (domain4Win.getDomainType().equals("nis")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/unix/radio_nis"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domain4Win.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
          <tr>
          <th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th>
          <td><%=domain4Win.getNisdomain()%></td>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th>
    	  <td><%=domain4Win.getNisserver().replaceAll("\\s+","<br>")%></td>
    	  </tr>
      <%} else if (domain4Win.getDomainType().equals("pwd")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/unix/radio_pwd"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domain4Win.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
          <tr>
          <th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
          <td><%=domain4Win.getLudb()%></td>
          <tr>
      <%} else{%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_ldap"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domain4Win.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
          <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>           
          <td><%=domain4Win.getLdapserver()%></td>
          </tr>
          <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
          <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Win.getBasedn()))%></td>
          </tr>  
          <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
              <td><%=ldapMode%></td>
    	  </tr>
          <%if (!(domain4Win.getAuthname()).equals("")){ %>
          <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></th>
              <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Win.getAuthname()))%></td>
          </tr>
          <%}%>
          <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
              <td><%=tls%></td>
          </tr>

          <%if (!(domain4Win.getCa()).equals("")){ %>
          <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
              <td>
                    <%=NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Win.getCa()))%>
              </td>
    	  </tr>
          <%}%>    
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
            <td>
            <% if ((domain4Win.getUfilter()).equals("")){ %>
                <nsgui:message key="nas_mapd/common/not_set"/>
            <%}else{%>
                <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Win.getUfilter()))%>
            <%}%>    
            </td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
            <td>
            <% if ((domain4Win.getGfilter()).equals("")){ %>
                <nsgui:message key="nas_mapd/common/not_set"/>
            <%}else{%>
                <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domain4Win.getGfilter()))%>
            <%}%>    
            </td>
        </tr>
      <%}%>
      </table>
     <%}%>
    <%}%>    
</form>

</BODY>
</HTML>