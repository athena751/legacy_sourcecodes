<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originalsetcommon.jsp,v 1.3 2008/05/28 05:07:25 liy Exp $" -->
<%@ page import="com.nec.nsgui.action.replication.STDataRender4Original"%>
            <tr>
                <th><bean:message key="original.list.th.bandwidth"/></th>
                <td>
                    <html:checkbox   property="chkBandLimit" styleId="idChkBandLimit" onclick="setBandwidthLimit(this)"/>
                    <label for="idChkBandLimit">
                    <bean:message key="original.bandwidth.limited"/>
                    </label>
                    <html:text property="txtBandWidth"   maxlength="7" size="7" />
                    <nested:hidden property="bandWidth" />
                    <html:select  property="slctBandWidthUnit">                                             
                        <html:option value="k"><bean:message key="original.bandwidth.unit.kbps"/></html:option>
                        <html:option value="M" ><bean:message key="original.bandwidth.unit.mbps"/></html:option>
                        <html:option value="G"><bean:message key="original.bandwidth.unit.gbps"/></html:option>
                    </html:select>
                </td>
            </tr>     
          
             <tr>
                <th><bean:message key="replication.info.interface"/></th>
                <td>
                    
                    <nested:select property="transInterface">            
                        <html:option value="">
                              <bean:message key="replication.info.interface.nospecified"/>
                        </html:option>
                        <html:optionsCollection name="interfaceVec" />                 
                    </nested:select>
                </td>
            </tr>   
        
             <tr>
                <th valign="top"><bean:message key="original.list.th.replicahost"/></th>
                <td>        
                     <table>
                         <tr>
                            <td>
                              <html:checkbox   property="chkPermitExternalHost" styleId="idChkPermitExternalHost" onclick="setPermitExternalHost(this)"/>
                            </td>
                            <td colspan=2>
                              <label for="idChkPermitExternalHost"><bean:message key="original.replicahost.permitexternal" /> </label>
                            </rd>
                         </tr>
                          
                          <tr>
                            <td>&nbsp;</td>
                            <td>
                              <html:radio property="radioHost" value="permitall"  styleId="rdoPermitall" onclick="document.forms[0].txtReplicaHost.disabled=true;"/>
                            </td>
                            <td>
                              <label for="rdoPermitall">
                                <bean:message key="original.replicahost.permitall" /> 
                             </label>
                            <td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
                            <td>
                              <html:radio property="radioHost" value="specifyHost"  styleId="rdoSpecifyHost"    onclick="document.forms[0].txtReplicaHost.disabled=false;" />
                            </td>
                            <td>
                              <label for="rdoSpecifyHost">
                                <bean:message key="original.replicahost.specifyhost" />
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>
                              <html:text property="txtReplicaHost" size="50" />
                            </td>
                           </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>
                             [<font class="advice" ><bean:message key="original.info.replicainput" /></font>]
                             <nested:hidden property="replicaHost" />
                            </td>
                        </tr>
        	</table>                            
               </td>
            </tr>
            <tr id="showCheckpoint" >
            	<th align="left"><bean:message key="original.info.checkpoint.create"/></th>
          		<td><bean:message key="original.info.daily"/>&nbsp;
            		<nested:select property="hour" >      				
						<%for(int i=0;i<24;i++){%>
							<html:option value="<%=String.valueOf(i)%>"><%=STDataRender4Original.to2Digit(String.valueOf(i))%></html:option>
						<%}%>
					</nested:select>&nbsp;
					<bean:message key="original.info.hour"/>&nbsp;
					<nested:select property="minute" >	
						<%for(int i=0;i<60;i=i+10){%>
							<html:option value="<%=String.valueOf(i)%>"><%=STDataRender4Original.to2Digit(String.valueOf(i))%></html:option>
						<%}%>
					</nested:select>&nbsp;
					<bean:message key="original.info.minute"/>
				</td>
        	</tr>