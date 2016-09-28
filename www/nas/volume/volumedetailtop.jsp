<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumedetailtop.jsp,v 1.18 2007/09/20 13:02:21 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeDetailAction"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>

<bean:define id="isNashead" value='<%=NSActionUtil.isNashead(request)?"true":"false"%>'/>
<%  
    VolumeDetailAction detailAction = new VolumeDetailAction();
    String from  = (String)(request.getParameter("from"));
    String title = from.equals("volume")? "title.h1" : "h1.filesystem";
%> 
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
</head>
<body>
    <h1 class="title"><bean:message key="<%=title%>"/></h1>
    <h2 class="title"><bean:message key="volume.detail.h2"/></h2>

    <form>
        <bean:define id="volumeInfo" name="volumeInfo" scope="session"/>
        <nested:root name="volumeInfo">
        <table border="1" class="Vertical" nowrap>
            <tr>
                <th><bean:message key="info.volumeName"/></th>
                <td>
			        <nested:define id="volumeName4Show" property="volumeName"/>
			    	<%=volumeName4Show.toString().replaceFirst("NV_LVM_" , "")%>
				</td>			    	                
            </tr>
            
            <tr>
                <th><bean:message key="info.mountpoint"/></th>
                <td><nested:write property="mountPoint"/></td>
            </tr>
            
            <tr>
                <th><bean:message key="info.mountStatus"/></th>
                <td>
                    <nested:equal property="mountStatus" value="mount">
                        <img src="/nsadmin/images/nation/check.gif">
                    </nested:equal>
                    <nested:notEqual property="mountStatus" value="mount">
                        &nbsp;
                    </nested:notEqual>
                </td>
            </tr>
            
            <tr>    
                <th><bean:message key="info.fsType"/></th>
                <td><nested:write property="fsType"/></td>
            </tr>
            
            <logic:notEqual name="isNashead" value="true" scope="page">
	            <tr>
	                <th><bean:message key="info.diskarrayName"/></th>
	                <td><nested:write property="aname" filter="false"/></td>
	            </tr>
	            
	            <tr>
	                <th><bean:message key="info.raidType"/></th>
	                <td><nested:write property="raidType"/></td>
	            </tr>
	            
	            <tr>
	                <th valign="top"><bean:message key="info.poolNameAndNo"/></th>
	                <td>
	                    <nested:define id="pool" property="poolNameAndNo" type="java.lang.String"/>
	                    <%String divHeight = (pool.split("<br>").length >=3) ? "54px" : "auto";%>
	                    <DIV id="poolNameAndNo" style="overflow: auto; width: auto; height: <%=divHeight%>">
	                        <nested:write property="poolNameAndNo" filter="false"/>    
	                    </DIV>
	                </td>
             
	            </tr>  
            </logic:notEqual>

            <logic:equal name="isNashead" value="true" scope="page">
                <logic:equal name="hasGfsLicense" value="true" scope="session">
                <tr>
                    <th valign="top" align="left"><bean:message key="info.gfs"/></th>
                    <td>
	                    <nested:equal property="useGfs" value="true">
	                        <img src="/nsadmin/images/nation/check.gif">
	                    </nested:equal>
	                    <nested:notEqual property="useGfs" value="true">
	                        &nbsp;
	                    </nested:notEqual>
                    </td>
                </tr>
                </logic:equal>
                <tr>
                    <th valign="top"><bean:message key="info.extend.lunAndStorage"/></th>
                    <td>
                        <nested:define id="lunStorage4Show" property="lunStorage" type="java.lang.String"/>
                        <%String divHeight = (lunStorage4Show.split("<BR>").length >=3) ? "54px" : "auto";%>
                        <DIV id="lunStorage" style="overflow:auto; width:auto; height:<%=divHeight%>">
                            <nested:write property="lunStorage" filter="false"/>
                        </DIV>
                    </td>
                    
                </tr>  
            </logic:equal>
            
            <tr>
                <th><bean:message key="info.capacity"/></th>
                <td><nested:write property="capacity"/></td>
            </tr>
            
            <tr>
                <th><bean:message key="info.filesystem.capacity"/></th>
                <td><nested:write property="fsSize"/></td>
            </tr>
              
            <tr>    
                <th><bean:message key="info.useRate"/></th>
                <td><nested:write property="useRate"/></td>                            
            </tr>
            
            <tr>
                <th><bean:message key="info.access"/></th>
                <td>
                    <nested:equal property="accessMode" value="ro">
                        <bean:message key="info.access.ro"/>
                    </nested:equal>
                    <nested:equal property="accessMode" value="rw">
                        <bean:message key="info.access.rw"/>
                    </nested:equal>
                </td>
            </tr>
            
            <tr>
                <th><bean:message key="info.quota"/></th>
                <td>
                    <nested:equal property="quota" value="true">
                        <img src="/nsadmin/images/nation/check.gif"/>
                    </nested:equal>
                    <nested:notEqual property="quota" value="true">
                        &nbsp;
                    </nested:notEqual>
                </td>
            </tr>
            
            <tr>
                <th><bean:message key="info.noatime"/></th>
                <td>
                    <nested:equal property="noatime" value="true">
                        <img src="/nsadmin/images/nation/check.gif"/>
                    </nested:equal>
                    <nested:notEqual property="noatime" value="true">
                        &nbsp;
                    </nested:notEqual>
                </td>
            </tr>
            
            <tr>
                <th><bean:message key="info.replication"/></th>
                <td>
                    <nested:equal property="replication4Show" value="--">
                        <bean:message key="info.off"/>
                    </nested:equal>
                    <nested:equal property="replication4Show" value="notset">
                        <bean:message key="info.replication.notSet"/>
                    </nested:equal>
                    <nested:equal property="replication4Show" value="replic">
                        <bean:message key="info.replication.replic"/>
                    </nested:equal>
                    <nested:equal property="replication4Show" value="original">
                        <bean:message key="info.replication.original"/>
                    </nested:equal>
                </td>
            </tr>
            <tr>
                <th><bean:message key="info.writeprotected"/></th>
                <td>
                    <nested:equal property="wpPeriod" value="--">
                        <bean:message key="info.off"/>
                    </nested:equal>
                    <nested:equal property="wpPeriod" value="-1">
                        <bean:message key="info.writeprotected.unset"/>
                    </nested:equal>
                    <nested:notEqual property="wpPeriod" value="--">
                    	<nested:notEqual property="wpPeriod" value="-1">
                        	<bean:message key="info.writeprotected.set"/>
                        	(<nested:write property="wpPeriod"/><bean:message key="info.writeprotected.set.days.detail"/>)
	                    </nested:notEqual>
                    </nested:notEqual>
                </td>
            </tr>
            
            <logic:notEqual name="isNashead" value="true" scope="page">
	            <nested:notEqual property="asyncStatus" value="normal">
	                <tr>
	                    <th><bean:message key="info.asyncStatus"/></th>
	                    <td>
		                   <nested:equal property="errCode" value="<%=VolumeActionConst.ASYNC_NO_ERROR%>">
	                           <nested:equal property="asyncStatus" value="extend">
	                               <bean:message key="async.extend"/>
	                           </nested:equal>
	                           <nested:notEqual property="asyncStatus" value="extend">
	                               <bean:message key="async.create"/>
	                           </nested:notEqual>	                           
                           </nested:equal>     

                           <nested:notEqual property="errCode" value="<%=VolumeActionConst.ASYNC_NO_ERROR%>">
                               <nested:equal property="asyncStatus" value="extend">
                                   <bean:message key="async.extend.error"/>
                               </nested:equal> 
                               <nested:notEqual property="asyncStatus" value="extend">
                                   <bean:message key="async.create.error"/>
                               </nested:notEqual>                                                                 
                           </nested:notEqual>                                            	                       
	                    </td>
	                </tr>
	                <nested:notEqual property="errCode" value="<%=VolumeActionConst.ASYNC_NO_ERROR%>">
	                    <tr>
	                        <th><bean:message key="info.errCode"/></th>
	                        <td><nested:write property="errCode"/></td>
	                    </tr>
	                    <tr valign="top">
	                        <th><bean:message key="info.errMsg"/></th>
	                        <nested:define id="errCode4Show" property="errCode" type="java.lang.String"/>
	                        <nested:define id="status" property="asyncStatus" type="java.lang.String"/>
                            <td class="wrapTD"><%=detailAction.getMessageByErrCode(errCode4Show, status, request)%></td>
	                    </tr>
	                </nested:notEqual>
	            </nested:notEqual>         
            </logic:notEqual>          
        </table>
        </nested:root>
    </form>    
</body>
</html:html>