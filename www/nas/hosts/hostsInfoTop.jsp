<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: hostsInfoTop.jsp,v 1.5 2007/05/30 02:18:34 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%> 

<html>
<head>
<%@include file="../../common/head.jsp" %>  
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javascript">
var buttonEnable = 0;
function init(){ 
    <logic:notEmpty name="hostsInfoNode0" scope="session">
         buttonEnable = 1;
         if(window.parent.hostsinfobottom){
             if((window.parent.hostsinfobottom.document)
                    &&(window.parent.hostsinfobottom.document.forms[0]) ){
                window.parent.hostsinfobottom.changeButtonStatus();
            }    
         }
    </logic:notEmpty>
    <logic:notEmpty name="hostsInfoNode1" scope="session">
         buttonEnable = 1;
         if(window.parent.hostsinfobottom){
             if((window.parent.hostsinfobottom.document)
                    &&(window.parent.hostsinfobottom.document.forms[0]) ){
                window.parent.hostsinfobottom.changeButtonStatus();
            }    
         }
    </logic:notEmpty>
}

function onRefresh(){
    if(window.parent.hostsinfobottom){
        if(window.parent.hostsinfobottom.isSubmitted()){            
            return false;
        }
        window.parent.hostsinfobottom.setSubmitted();
    }
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    <logic:present name="isHostsRecovery" scope="session"> 
        <logic:equal name="isHostsRecovery" value="yes" scope="session">
            <logic:present name="userinfo" >  
                <logic:equal name="userinfo" value="nsadmin">     
                    parent.location="/nsadmin/hosts/hostsInfoAction.do?Operation=getHostsInformation";
                </logic:equal>   
                <logic:notEqual name="userinfo" value="nsadmin">     
                    window.location="/nsadmin/hosts/hostsInfoAction.do?Operation=getHostsInformation";
                </logic:notEqual>                
            </logic:present>
        </logic:equal>
        
        <logic:equal name="isHostsRecovery" value="no" scope="session">
            window.location="/nsadmin/hosts/hostsInfoAction.do?Operation=getHostsInformation";
        </logic:equal>
    </logic:present>
}

</script>
</head>
<body onload="displayAlert();init();setHelpAnchor('network_hosts_1');" onUnload="closeDetailErrorWin();">         
    <form name="hostsForm" target="_parent" method="post" >   
        <html:button property="refreshBtn" onclick="onRefresh();">
            <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br><br>
        <displayerror:error h1_key="hosts.title.h1"/> 
        <br>
        <logic:present name="isHostsRecovery" scope="session">        
            <bean:define id="hostsInfoNode0" name="hostsInfoNode0" scope="session"/>      
            <bean:define id="hostsInfoNode1" name="hostsInfoNode1" scope="session"/> 
            <logic:equal name="isHostsRecovery" value="yes" scope="session">
            
                <h3 class="title"><bean:message key="hosts.title.h4.node0"/></h3>
                
                <logic:empty name="hostsInfoNode0">            
                    <bean:message key="hosts.message.nohosts"/>
                </logic:empty>
                
                <logic:notEmpty name="hostsInfoNode0">
                    <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)hostsInfoNode0)%>" 
                        id="list1"
                        table="border=1"  >
                      
                        <nssorttab:column name="ipAddress" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.ip"/>
                        </nssorttab:column>
            
                        <nssorttab:column name="host" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.hosts"/> 
                        </nssorttab:column> 
            
                        <nssorttab:column name="alias" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.alias"/> 
                        </nssorttab:column> 
            
                    </nssorttab:table> 
                 </logic:notEmpty>   
                 
                <h3 class="title"><bean:message key="hosts.title.h4.node1"/></h3>
                
                <logic:empty name="hostsInfoNode1">            
                    <bean:message key="hosts.message.nohosts"/>
                </logic:empty>
                
                <logic:notEmpty name="hostsInfoNode1">
                    <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)hostsInfoNode1)%>" 
                        id="list2"
                        table="border=1"  >
                      
                        <nssorttab:column name="ipAddress" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.ip"/>
                        </nssorttab:column>
            
                        <nssorttab:column name="host" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.hosts"/> 
                        </nssorttab:column> 
            
                        <nssorttab:column name="alias" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.alias"/> 
                        </nssorttab:column> 
            
                    </nssorttab:table> 
                </logic:notEmpty>
           </logic:equal>   
           
           <logic:equal name="isHostsRecovery" value="no" scope="session">  
                <logic:empty name="hostsInfoNode0">            
                    <bean:message key="hosts.message.nohosts"/>
                </logic:empty>
                
                <logic:notEmpty name="hostsInfoNode0">
                    <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)hostsInfoNode0)%>" 
                        id="list3"
                        table="border=1"  >
                      
                        <nssorttab:column name="ipAddress" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.ip"/>
                        </nssorttab:column>
            
                        <nssorttab:column name="host" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.hosts"/> 
                        </nssorttab:column> 
            
                        <nssorttab:column name="alias" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                        <bean:message key="hosts.info.table.alias"/> 
                        </nssorttab:column> 
            
                    </nssorttab:table> 
                 </logic:notEmpty>              
           </logic:equal>                
     
     </logic:present>   
        </form>
</body>
</html>