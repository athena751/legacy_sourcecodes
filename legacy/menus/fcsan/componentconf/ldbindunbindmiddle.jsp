<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldbindunbindmiddle.jsp,v 1.2309 2005/12/22 01:24:20 wangli Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<title><nsgui:message key="fcsan_componentconf/ldbindunbind/ldbindunbind_title" /></title>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.text.*,java.math.*" %>
<jsp:useBean id="pdInfo" class="com.nec.sydney.beans.fcsan.componentconf.LDBindUnbindBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = pdInfo; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
    <%    if (pdInfo.getErrMsg()!=null){%>
    <script>
     parent.bottomframe.location="<%=response.encodeURL("ldbindunbindbottom.jsp")%>?diskarrayname=<%=request.getParameter("diskarrayname")%>&diskarrayid=<%=request.getParameter("diskarrayid")%>&pdnum=<%=request.getParameter("PDNo")%>";
    </script>
    <body>
    <%if (request.getParameter("ErrMsgForMiddle")!=null){
         out.println(new String(pdInfo.getErrMsg().getBytes(),"EUC-JP"));
    }else{
         out.println(pdInfo.getErrMsg());
    }%>
     </body>
     <%}else{%>    
<script>
function loadBottomPage() {
parent.bottomframe.location="<%=response.encodeURL("ldbindunbindbottom.jsp")%>?diskarrayname=<%=request.getParameter("diskarrayname")%>&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>&monitoringstate=<%=request.getParameter("monitoringstate")%>&pdnum=<%=request.getParameter("PDNo")%>";
}
</script>
<body onload="loadBottomPage();">
<form>
<%if(pdInfo.getNetError()) {%>
<script>
    alert("<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/alert_network_err")%>");
</script>
<%}%>


<% List pd=pdInfo.getAllLDInfo();%>
<% if(pd == null || pd.size()==0){
        out.println("<input type=\"hidden\" name=\"alldisabled\" value=\"\">");%>
        <nsgui:message key="fcsan_componentconf/ldbindunbind/norank" />
 <%}else{
    boolean binddisabled=true;
    boolean unbinddisabled=true;
    int total_length=600;
    int unit=12;
    List oneRankInfo;
    DiskArrayRankInfo rankInfo;
    List ldInfo;
    List ldInfoM;
    String ld_No;
    String ld_Name;
    String ld_Capacity;
    String ld_Type;
    String ld_lvm;
    //modify caoyh 7.16 because of super's GetDouble
    String s_ldCapacity;
    //String free_capacity;
    String color;
    StringTokenizer st;
    String rankSize;%>
<h3 class="title"><nsgui:message key="fcsan_componentconf/ldbindunbind/h3_ld" />&nbsp;(<nsgui:message key="fcsan_componentconf/ldbindunbind/msg_numberofld"/>&nbsp;:&nbsp;<%=pdInfo.getNumberOfLD()%>)</h3>
<table><tr><td>(<nsgui:message key="fcsan_componentconf/common/legend" />&nbsp;&nbsp;</td>
<td>
    <table border="1" cellspacing="0" cellpadding="0"> <tr><td  width=20  bgcolor="#0000FF">&nbsp; </td> </tr></table>
</td>
<td>:</td>
<td>
    <nsgui:message key="fcsan_componentconf/ldbindunbind/ld_lvm" />
</td>
<td>
    <table border="1" cellspacing="0" cellpadding="0"><tr><td bgcolor="#cccccc"  width=20 >&nbsp;</td> </tr></table>
</td>
<td>:</td>
<td>
    <nsgui:message key="fcsan_componentconf/ldbindunbind/bound" />
</td>
<td>
    <table border="1" cellspacing="0" cellpadding="0"> <tr><td  width=20  bgcolor="#FFFFFF">&nbsp; </td> </tr></table>
</td>
<td>:</td>
<td>
    <nsgui:message key="fcsan_componentconf/ldbindunbind/freeSpace" />)
</td>
</tr>
</table><br>
    <%
    for(int i=0;i<pd.size();i++) {

    %>

<table width=<%=total_length+110%> border="1" cellspacing="0" cellpadding="0">
    <tr>
        <td width="110">
        <%
        oneRankInfo=(List)pd.get(i);
        rankInfo=(DiskArrayRankInfo)oneRankInfo.get(0);
        double total_capci=(new Double(rankInfo.getCapacity())).doubleValue();
        //rankSize = rankInfo.getCapacity();
        rankSize = pdInfo.GetDouble(total_capci/1024/1024/1024-0.05,1);
        ldInfo=(List)oneRankInfo.get(1);
        ldInfoM=(List)oneRankInfo.get(2);
        %><%=rankInfo.getPoolName()%><br>
        <%=rankSize%><nsgui:message key="fcsan_common/label/unit_GB" /><br> 
        <nsgui:message key="fcsan_componentconf/ldbindunbind/raid" /><%=rankInfo.getRaidType()%><br>
        <% String numberOfLogicalDisk = NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/ldbindunbind/msg_ldnum");
           boolean isJa = !numberOfLogicalDisk.equals("LD");%>
         <%=isJa?"<font size='2'>":""%>
        	<%=numberOfLogicalDisk%>&nbsp;<%=ldInfo.size()+ldInfoM.size()%>
         <%=isJa?"</font>":""%>
        </td>
        <%
        //display ld without MutiRank and ld with MutiRank;
        for (int count=0;count<ldInfo.size()+ldInfoM.size();count++)
        {    
            
            if(count<ldInfo.size())
            {
                color=new String("bgcolor=\"#cccccc\"");
                st=new StringTokenizer((String)ldInfo.get(count));
            }
            else
            {
                color=new String("bgcolor=\"#99ffff\"");
                st=new StringTokenizer((String)ldInfoM.get(count-ldInfo.size()));
            }

            ld_No=st.nextToken();

            ld_Name=st.nextToken();
            ld_Capacity=st.nextToken();
            ld_Type=st.nextToken();
            ld_lvm = "";
            boolean isLVM = false;
            if(st.hasMoreTokens()){
                isLVM = true;
                ld_lvm = st.nextToken();
                if(st.hasMoreTokens()){
                	ld_lvm = ld_lvm + " " + st.nextToken();
                }
                color=new String("bgcolor=\"#0000ff\"");
            }
            int ldNo_int = Integer.valueOf(ld_No.substring(0,ld_No.length()-1),16).intValue();
            if(ldNo_int>0xf && !isLVM) {
               unbinddisabled=false;
            }
            //according to the capacity ,distribute the length of table.
            //ratio is a length that should be distributed.
            double ld_capci=(new Double(ld_Capacity)).doubleValue();
            ld_Capacity = pdInfo.GetDouble(ld_capci/1024/1024/1024-0.05,1);
            ld_Capacity=ld_Capacity+"GB";
            double ratio=ld_capci/total_capci*total_length;
            int leng=(int)ratio/unit;
        %>
        <td width="<%=ratio < 1 ? 1:ratio%>" <%=color%> title="<%=ld_No+" \n"+ld_Capacity%><%if(!ld_lvm.equals("")) out.print("\n"+ld_lvm);%>">
        <%=isLVM?"<font color='#FFFFFF'>":""%><%=ld_No.length()<leng?ld_No:ld_No.substring(0,leng)+"..."%>
        <br>
        <%
        
        if(ld_Capacity.length()<leng){
            out.print(ld_Capacity);
         }else{
            out.print(ld_Capacity.substring(0,leng)+"...");
        }
        %>
        <%=isLVM?"</font>":""%></td>
        <%}//end of displaying all ldInfo %>
        <%
            double d_freecapacity=((BigInteger)oneRankInfo.get(3)).doubleValue();
        
            double freeCapacity_GB = d_freecapacity/1024/1024/1024;
            List spare_rank=(List)session.getAttribute(FCSANConstants.SESSION_RANK_SUMMARY);
            int maxLD = pdInfo.isFirstArray(request.getParameter("diskarrayid")) ? 240 : 256;
           if (spare_rank!=null && spare_rank.size() > 0 && pdInfo.getTotalNumberOfLD() < maxLD) {
                binddisabled=false;
            }
            if ((ldInfo.size() + ldInfoM.size()) > 0) {
                unbinddisabled=false;
            }
            if (freeCapacity_GB >= 1) {
                double width = (new Double((String)oneRankInfo.get(4))).doubleValue()/total_capci*total_length;
            %>
            <td width="<%=width < 1 ? 1:width%>" bgcolor="#FFFFFF" title="<%=(new java.text.DecimalFormat("#,###")).format(d_freecapacity)%> <nsgui:message key="fcsan_common/label/unit_bytes" />">
            <nsgui:message key="fcsan_componentconf/ldbindunbind/available" /><br>
            <br>
            <%
            out.println(pdInfo.GetDouble(freeCapacity_GB-0.05,1));
        %>
            <nsgui:message key="fcsan_common/label/unit_GB" />
        </td>
            <%}%>
    </tr>
    <tr>
    <% double d_totalcapacity=(new Double((String)oneRankInfo.get(4))).doubleValue();%>
        <td title="<%=(new java.text.DecimalFormat("#,###")).format(d_totalcapacity)%><nsgui:message key="fcsan_common/label/unit_bytes" />">
        <nsgui:message key="fcsan_componentconf/ldbindunbind/unused"/><br>
        <%
            String s_totalcapacity = pdInfo.GetDouble(d_totalcapacity/1024/1024/1024-0.05,1);
            s_totalcapacity = d_totalcapacity <= 0?"0":s_totalcapacity;
        %>
        <%=s_totalcapacity%>
        <%//=pdInfo.GetDouble(d_totalcapacity/1024/1024/1024-0.05,1)%>
        <nsgui:message key="fcsan_common/label/unit_GB" />
        </td>
        <td colspan="<%=ldInfo.size()+ldInfoM.size()+ ((freeCapacity_GB > 0.1)? 1 : 0)%>">
        
        <nsgui:message key="fcsan_componentconf/ldbindunbind/pd" /><%
        //display the PD.
        out.println((String)oneRankInfo.get(5));
        %>
        </td>
    </tr>
</table>
<br>
<%}//end of for%>
        <%
        if(pdInfo.getNetError()) {
            unbinddisabled = true;
        }
        if(binddisabled)
            out.println("<input type=\"hidden\" name=\"binddisabled\" value=\"\">");
        if(unbinddisabled){
            out.println("<input type=\"hidden\" name=\"unbinddisabled\" value=\"\">");
        }
        if(pdInfo.getNumberOfLD()==0) {
            out.println("<input type=\"hidden\" name=\"timedisabled\" value=\"\">");
        }   
  }//end of else     %>
</form>
</body>
<%}%>
</html>