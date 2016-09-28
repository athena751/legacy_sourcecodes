/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.mapd;

import java.util.AbstractList;
import javax.servlet.jsp.PageContext;
import org.apache.struts.taglib.TagUtils;

import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;
import com.nec.nsgui.model.entity.mapd.*;

public class UdbTDRender extends STAbstractRender implements MapdConstant{
    public static final String cvsid ="@(#) $Id: ";

    public String getCellRender(int rowIndex, String colName)throws Exception {
        if(colName.equals("domainresource") || colName.equals("domainType") ){
            return getCellContent(rowIndex, colName);
        }
        return "<td>" + getCellContent(rowIndex, colName) + "</td>";
    }

    private String getCellContent(int rowIndex, String colName)throws Exception {
        PageContext context = getSortTagInfo().getPageContext();
        AbstractList DmountList = ((ListSTModel) getTableModel()).getDataList();
        DMountInfoBean oneDM = (DMountInfoBean) DmountList.get(rowIndex);
        StringBuffer cellStr = new StringBuffer();
        if (colName.equals("radio")) {
            cellStr.append(
                "<input name=\"fsradio\" type=\"radio\" "
                + "onclick=\"setButtonStatus();\" value=\"");
            cellStr.append(oneDM.getMp()).append(",");
            cellStr.append(oneDM.getFsType()).append(",");
            cellStr.append(oneDM.getHasAuth());
            cellStr.append("\" ");
            
            if (rowIndex == 0) {
                cellStr.append("checked");
            }
            cellStr.append(" id=\"fsradio" + rowIndex);
            cellStr.append("\">");
            
        }else if (colName.equals("mp")){
            cellStr.append("<label for=\"fsradio" + rowIndex);
            cellStr.append("\">");
            cellStr.append(oneDM.getMp());
            cellStr.append("</label>");
        }else if (colName.equals("domainType")) {
            String domaintype = (oneDM.getDinfo()).getDomaintype();
            if(domaintype.equals("")){
                 cellStr.append("<td align=center>");
                 cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.common.notset"));
            }else{
                cellStr.append("<td>");
            }
            if(domaintype.equals("nis")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.nis"));
            }else if(domaintype.equals("pwd")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.pwd"));
            }else if(domaintype.equals("ldu")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.ldap"));
            }else if(domaintype.equals("ads")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.ads"));
            }else if(domaintype.equals("shr")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.shr"));
            }else if(domaintype.equals("dmc")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.nt"));
            }
            cellStr.append("</td>");
        }else if (colName.equals("domainresource")) {
            DomainInfoBean dminfo = oneDM.getDinfo();
            String domaintype = dminfo.getDomaintype();
            if(domaintype.equals("")){
                 cellStr.append("<td align=center>");
                 cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.common.notset"));
            }else{
                cellStr.append("<td>");
            }
            
            if(domaintype.equals("nis")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.nis.nisDomain"));
                cellStr.append(" : ");
                cellStr.append(dminfo.getNisdomain());
                cellStr.append("<br>");
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.nis.nisServer"));
                cellStr.append(" : <br>&nbsp;&nbsp;");
                cellStr.append(dminfo.getNisserver().replaceAll("\\s+","<br>&nbsp;&nbsp;"));
            }else if(domaintype.equals("pwd")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.pwd.ludb"));
                cellStr.append(" : <br>&nbsp;&nbsp;");
                cellStr.append(dminfo.getLudb());
            }else if(domaintype.equals("ldu")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.ldap.ldapServer"));
                cellStr.append(" : <br>&nbsp;&nbsp;");
                cellStr.append(dminfo.getLdapserver().replaceAll("\\s+","<br>&nbsp;&nbsp;"));
            }else if(domaintype.equals("ads")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.domain"));
                cellStr.append(" : ");
                cellStr.append(dminfo.getNtdomain());
                cellStr.append("<br>");
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.ads.dns"));
                cellStr.append(" : <br>&nbsp;&nbsp;");
                cellStr.append(dminfo.getDns());
                cellStr.append("<br>");
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.ads.kdc"));
                cellStr.append(" : <br>&nbsp;&nbsp;");
                cellStr.append(dminfo.getKdcserver());
            }else if(domaintype.equals("shr")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.domain"));
                cellStr.append(" : ");
                cellStr.append(dminfo.getNtdomain());
            }else if(domaintype.equals("dmc")){
                cellStr.append(TagUtils.getInstance().message(context, null, null,"udb.domain"));
                cellStr.append(" : ");
                cellStr.append(dminfo.getNtdomain());
            }
            cellStr.append("</td>");
        }
        return cellStr.toString();
    }
}