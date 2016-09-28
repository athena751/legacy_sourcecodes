/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DisplayTab.java,v 1.3 2005/08/29 01:08:10 wangw Exp $
 *
 *
 */

package com.nec.nsgui.taglib.nstab;
import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

public class DisplayTab extends BodyTagSupport  {
    private JspWriter   out         = null;
    private TabTagInfo  tabtaginfo  = null;
    private String displayonload    = "0";
    private String divoptions       = "";
    public DisplayTab(){
    }

    public void setPageContext(PageContext pageContext) {
        super.setPageContext(pageContext);
        out = pageContext.getOut();
    }
    // Handle the tag
    public int doStartTag() throws JspException {
        return super.doStartTag();
    }

    public int doEndTag() throws JspException {
        int tab_count = tabtaginfo.getSubTabCount();
        if(tab_count == 0){
            tabtaginfo = null;
            return EVAL_PAGE;
        }
        StringBuffer bf = new StringBuffer();
        //output the table start tag
        bf.append("<div class=\"tab\" "+divoptions+" >\n");
        bf.append("<table class=\"tab\" cellpadding=0 cellspacing=0>\n<tr>\n");
        bf.append("<td class=\"spacehead\"><div style=\"width:10px\">&nbsp;</div></td>\n");
        String firstloadurl = "";
        String[] tabstate = new String[tab_count];
        for(int i=0 ; i<tab_count; i++){
            if(i==(Integer.parseInt(displayonload.equals("")?"0":displayonload))){
                tabstate[i] = "selected";
            }else{
                tabstate[i] = "unselected";
            }
        }
        for(int i=0 ; i<tab_count; i++){
            SubTabTagInfo st = tabtaginfo.getSubTabTagInfo(i);
            if(i==(Integer.parseInt(displayonload.equals("")?"0":displayonload))){
                firstloadurl = st.getUrlString();
            }
            bf.append("<td><img id=\"img" + i + "\"");
            if(i==0){
                bf.append(" src=\"/nsadmin/images/tab/_"+tabstate[i]+".jpg\" height=\"30\" width=\"10\"></img></td>\n");
            }else{
                bf.append(" src=\"/nsadmin/images/tab/"
                            +tabstate[i-1]+"_"+tabstate[i]+".jpg\" height=\"30\" width=\"18\"></img></td>\n");
            }
            bf.append("<td id=\"tab" + i + "\" class=\""+tabstate[i]+"\">");
            bf.append("<div id=\"div" + i + "\" class=\""+tabstate[i]+"\" ");
            bf.append("onclick=\"ontab('" + i + "','" + st.getUrlString() + "');");
            bf.append((st.getEnableExportGroup()!=null)?("ontabExpGrpButtonStatus('" + st.getEnableExportGroup() + "');"):"");
            bf.append((st.getEnableNode()!=null)?("ontabNodeButtonStatus('" + st.getEnableNode() + "');"):"");
            bf.append("\" onmouseover=\"changeCursor('" + i + "')\">" + st.getTabMessage() + "</div>");
            bf.append("<div id=\"div" + i + "hidden\" class=\"hidden\">" + st.getTabMessage() + "</div></td>\n");
        }
        bf.append("<td><img id=\"img" + tab_count + "\"");
        bf.append(" src=\"/nsadmin/images/tab/"+tabstate[tab_count-1]+"_.jpg\" height=\"30\" width=\"18\"></img></td>\n");
        bf.append("<td class=\"spacetail\">&nbsp;</td></tr></table>");
        //close table
        bf.append("<div>\n");
        if(tab_count>0){
            bf.append("<script language=\"javascript\">\n");
            bf.append("tabTXTLength = " + tab_count + ";\n");
            for(int i=0; i<tab_count; i++){
                if(i==(Integer.parseInt(displayonload.equals("")?"0":displayonload))){
                    bf.append("tabState[" + i + "] = 'selected';\n");
                    SubTabTagInfo st = tabtaginfo.getSubTabTagInfo(i);
                    bf.append((st.getEnableExportGroup()!=null)?("ontabExpGrpButtonStatus('" + st.getEnableExportGroup() + "');\n"):"");
                    bf.append((st.getEnableNode()!=null)?("ontabNodeButtonStatus('" + st.getEnableNode() + "');\n"):"");
                }else{
                    bf.append("tabState[" + i + "] = 'unselected';\n");
                }
            }
            bf.append("top.ACTION.bottomframe.location = \"" + firstloadurl + "\";\n");
            bf.append("changeCursor('" + displayonload + "');");
            bf.append("</script>");
        }
        try{
            out.println(bf.toString());
        }catch(IOException ex){}
        tabtaginfo = null;
        return EVAL_PAGE;
    }

    protected void addSubTabTagInfos(SubTabTagInfo tab) throws JspException{
        if(tabtaginfo==null){
            tabtaginfo = new TabTagInfo();
        }
        tabtaginfo.addSubTabTagInfo(tab);
    }
    /**
     * @return
     */
    public String getDisplayonload() {
        return this.displayonload;
    }

    /**
     * @param string
     */
    public void setDisplayonload(String displayonload) {
        this.displayonload = displayonload;
    }

    /**
     * @return
     */
    public String getDivoptions() {
        return this.divoptions;
    }

    /**
     * @param string
     */
    public void setDivoptions(String divoptions) {
        this.divoptions = divoptions;
    }
}
