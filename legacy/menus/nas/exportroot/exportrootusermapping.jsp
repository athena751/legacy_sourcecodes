<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: exportrootusermapping.jsp,v 1.2307 2005/11/22 03:19:22 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.system.*" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.atom.admin.mapd.*
                 ,com.nec.sydney.framework.*" %>  
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="bean" class="com.nec.sydney.beans.exportroot.EGUMListBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%
String fsType = request.getParameter("fsType");
DomainInfo domainInfo = bean.getDomainInfo();

String ldapMode = "";
String tls = "";
if (domainInfo!=null){
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
<head>
<title><nsgui:message key="nas_mapd/common/h1_mapd"/></title>
<%@include file="../../../menu/common/meta.jsp" %>
<script language="JavaScript">
</script>
</head>

<body>
<h1 class="popup"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<h2 class="popup"><nsgui:message key="nas_mapd/common/h1_mapd"/>[<%=bean.getMountPoint()%>]</h2>
<%if (domainInfo == null){%>
    <p>
    <nsgui:message key="nas_exportroot/exportroot/msg_info_fail"/>
    </p>
    <BR>   
    <HR>
    <BR>
    <FORM name="EGum" method="post">
    <center><INPUT TYPE="button" NAME="close" value="<nsgui:message key="common/button/close"/>" OnClick="window.close();"/></center>
    </FORM>
    </body>
    </HTML>    
<%return;
}
%>

<%if (fsType.equals("sxfs")){
    if(domainInfo.getDomainType().equals("")){%>
        <p><nsgui:message key="nas_exportroot/exportroot/domain_notset"/></p>
    <%}else{%>
        <table border="1">
	<%if(domainInfo.getDomainType().equals("nis")){%>
        	<tr>
        	<th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
        	<td><nsgui:message key="nas_mapd/unix/radio_nis"/></td>
        	</tr>
        	<tr>
        	<th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
        	</tr>
        	<tr>
        	<th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th><td>
        	<%=domainInfo.getNisdomain()%></td>
        	</tr>
        	<tr>
        	<th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th>
        	<td><%=domainInfo.getNisserver().replaceAll("\\s+","<br>")%></td>
        	</tr>	
        <%}else if(domainInfo.getDomainType().equals("pwd")){%>
		<tr>
		<th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
		<td><nsgui:message key="nas_mapd/unix/radio_pwd"/></td>
		</tr>
        	<tr>
        	<th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
        	</tr>
		<tr>
		<th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
		<td><%=domainInfo.getLudb()%></td>
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
                <td><%=domainInfo.getLdapserver()%></td>
                </tr>
                <tr>
                <th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
                <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getBasedn()))%></td>
                </tr>  
                <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
        	<td><%=ldapMode%></td>
    	        </tr>  
              <%if (!(domainInfo.getAuthname()).equals("")){ %>
              <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></th>
                  <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getAuthname()))%></td>
              </tr>
              <%}%>
                <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
                <td><%=tls%></td>
                </tr>

              <%if (!(domainInfo.getCa()).equals("")){ %>
              <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
                  <td>
                        <%=NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getCa()))%>
                  </td>
        	  </tr>
              <%}%>    
            <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
                <td>
                <% if ((domainInfo.getUfilter()).equals("")){ %>
                    <nsgui:message key="nas_mapd/common/not_set"/>
                <%}else{%>
                    <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getUfilter()))%>
                <%}%>    
                </td>
            </tr>
            <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
                <td>
                <% if ((domainInfo.getGfilter()).equals("")){ %>
                    <nsgui:message key="nas_mapd/common/not_set"/>
                <%}else{%>
                    <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getGfilter()))%>
                <%}%>    
                </td>
            </tr>
        <%}%>
	</table>
    <%}%>
<%}else{%>
      <%if (domainInfo.getDomainType().trim().equals("")){%>
        <p><nsgui:message key="nas_exportroot/exportroot/domain_notset"/></p>
      <%}else{%>

      <%String netBios=(domainInfo.getNetbios().equals(""))?NSMessageDriver.getInstance().getMessage(session, "nas_common/common/msg_no"):domainInfo.getNetbios();%>
      <table border="1">
      <%if (domainInfo.getDomainType().equals("ads")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_ads"/></td></tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domainInfo.getNtdomain()%></td></tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td></tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_dnsdomain"/></th>
    	  <td><%=domainInfo.getDns()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/text_kdcserver"/></th>
    	  <td><%=domainInfo.getKdcserver()%></td>
    	  </tr>
      <%} else if (domainInfo.getDomainType().equals("dmc")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_auth"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domainInfo.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
      <%} else if (domainInfo.getDomainType().equals("shr")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/nt/h3_shr"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domainInfo.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
      <%} else if (domainInfo.getDomainType().equals("nis")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/unix/radio_nis"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domainInfo.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
          <tr>
          <th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisDomain"/></th>
          <td><%=domainInfo.getNisdomain()%></td>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/nisServer"/></th>
    	  <td><%=domainInfo.getNisserver().replaceAll("\\s+","<br>")%></td>
    	  </tr>
      <%} else if (domainInfo.getDomainType().equals("pwd")){%>
      	  <tr>
      	  <th nowrap align="left"><nsgui:message key="nas_mapd/common/udb"/></th>
      	  <td><nsgui:message key="nas_mapd/unix/radio_pwd"/></td>
      	  </tr>
          <tr>
          <th colspan="2" align="left"><nsgui:message key="nas_exportroot/exportroot/h3_modifyexport"/></th>
          </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/domain_name"/></th>
    	  <td><%=domainInfo.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
          <tr>
          <th nowrap align="left"><nsgui:message key="nas_mapd/nt/ludb_name"/></th>
          <td><%=domainInfo.getLudb()%></td>
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
    	  <td><%=domainInfo.getNtdomain()%></td>
    	  </tr>
    	  <tr>
    	  <th nowrap align="left"><nsgui:message key="nas_mapd/nt/netbios"/></th>
    	  <td><%=netBios%></td>
    	  </tr>
          <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/ldap_server"/></th>           
          <td><%=domainInfo.getLdapserver()%></td>
          </tr>
          <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/distinguashName"/></th>
          <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getBasedn()))%></td>
          </tr>  
          <tr>
          <th align="left"><nsgui:message key="nas_mapd/nt/ldapSASL"/></th>
              <td><%=ldapMode%></td>
    	  </tr>
          <%if (!(domainInfo.getAuthname()).equals("")){ %>
          <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapAuthName"/></th>
              <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getAuthname()))%></td>
          </tr>
          <%}%>
          <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_TLS"/></th>
              <td><%=tls%></td>
          </tr>

          <%if (!(domainInfo.getCa()).equals("")){ %>
          <tr><th align="left"><nsgui:message key="nas_mapd/nt/ldapCA"/></th>
              <td>
                    <%=NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getCa()))%>
              </td>
    	  </tr>
          <%}%>    
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_userFilter"/></th>
            <td>
            <% if ((domainInfo.getUfilter()).equals("")){ %>
                <nsgui:message key="nas_mapd/common/not_set"/>
            <%}else{%>
                <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getUfilter()))%>
            <%}%>    
            </td>
        </tr>
        <tr><th align="left"><nsgui:message key="nas_mapd/nt/th_groupFilter"/></th>
            <td>
            <% if ((domainInfo.getGfilter()).equals("")){ %>
                <nsgui:message key="nas_mapd/common/not_set"/>
            <%}else{%>
                <%= NSUtil.space2nbsp(HTMLUtil.sanitize(domainInfo.getGfilter()))%>
            <%}%>    
            </td>
        </tr>
      <%}%>
      </table>
     <%}%>
<%}%>

<BR>   
<HR>
<BR>
<FORM name="EGum" method="post">
<center><INPUT TYPE="button" NAME="close" value="<nsgui:message key="common/button/close"/>" OnClick="window.close();"/></center>
</FORM>
</body>
</HTML>