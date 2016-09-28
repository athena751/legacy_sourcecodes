/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


package com.nec.sydney.beans.taglib;

import  java.io.*;
import  javax.servlet.*;
import  javax.servlet.http.*;
import  javax.servlet.jsp.*;
import  javax.servlet.jsp.tagext.*;
import  java.util.*;
//import  com.nec.sydney.framework.*;
//import  com.nec.sydney.beans.base.*;
//import  com.nec.sydney.beans.fcsan.common.*;

public class SortTag extends TagSupport {
    private static final String	cvsid = "@(#) MessageTagLib.java,v 1.1 2002/03/18 07:08:08 matsuoka Exp";

    private List  list; 
    
    private String keyword;  
    private String reverse;
    private String sortTarget;
    private Comparator comparator;
    private String wrap; 
    private String id; 
    private List value;  
    private List name;// the every element's form is "name type"

    public SortTag() {
    	super();
    }


    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public void setSortTarget(String sortTarget) {
        this.sortTarget = sortTarget;
    }
    
    public void setList(List list) {
        this.list = list;
    }
    
    public void setReverse(String reverse) {
        this.reverse = reverse;
    }
      
    public void setValue(List value) {
        this.value = value;
    }
    
    public void setName(List name) {
        this.name = name;
    }

    public void setTaglibID(String id) {
        this.id = id;
    }

    public void setWrap(String wrap) {
        this.wrap = wrap;
    }

    public void setSortComparator(Comparator comparator) {
        this.comparator = comparator;
    }
    public int doStartTag() throws JspException{
        
        String req_reverse;
        String req_keyword;
        String req_id;
        
        String sort_type = null;
    JspWriter out = pageContext.getOut();
        try{
            if(value == null || value.size() <= 0 || name == null || sortTarget == null) {
                throw new JspException("invalid parameter.");
            }
             
             ServletRequest req = pageContext.getRequest();
             req_reverse = req.getParameter("sort_reverse");
             req_keyword = req.getParameter("sort_keyword");
             req_id = req.getParameter("sort_ID");

            String [] reverse_params;
            reverse_params = req.getParameterValues("state_reverse");
            String [] keyword_params;
            keyword_params = req.getParameterValues("state_keyword");

		if(req_id != null && id != null && !req_id.equals(id) ) {
			req_keyword = keyword_params[Integer.parseInt(id)];
			req_reverse = reverse_params[Integer.parseInt(id)];
		}
             
             if (req_keyword != null) {
                keyword = req_keyword;
            } else if ( keyword == null ) {
                keyword = getFirstElement(name);
            }
            
             if (req_reverse != null) {
                reverse = req_reverse;
            } else if ( reverse == null ) {
                reverse = "ascend";
            }
    	    wrap = (wrap == null || wrap.equals("yes"))?"":" nowrap";  
            for (int i = 0; i < name.size() ; i++) {
                String buttonName = null;
                int count;
                if (((String) name.get(i)) != null) {
                    StringTokenizer st = new StringTokenizer((String) name.get(i));
                    count = st.countTokens();
                    buttonName = st.nextToken();
                    if (count==2&&buttonName.equals(keyword)) {
                        sort_type = st.nextToken();
                    }
                }
               
                if (buttonName == null || buttonName.equals("") ) {
                    out.print("<th"+wrap+">"+value.get(i)+"</th>");
                } else {
                    //StringBuffer sb = new StringBuffer();
                    //sb.append("<th><input type=\"button\" value=\"" + (String)value.get(i) );
                    if (sortTarget.endsWith(".jsp")) {
                        out.print("<th><input type=\"button\" value=\"" 
                            + (String)value.get(i) + "\" onclick=\"window.location='"
                            + printParameters(req) + "sort_keyword="+ buttonName + "&sort_reverse=" 
                            + (keyword.equals(buttonName)?(reverse.equals("ascend")? "descend":"ascend"):"ascend") 
                            + "'\"></th>");
                    }else {
                        out.print("<th><input type=\"button\" value=\"" 
                            + (String)value.get(i) + "\" onclick='" + sortTarget 
                            + "(\""+ buttonName + "\",\"" 
                            + (keyword.equals(buttonName)?(reverse.equals("ascend")? "descend":"ascend"):"ascend") 
                            + "\",\""+id+"\")" + "'></th>");
                    }
                    
               }
            }
            out.println("<input type=hidden name=\"state_keyword\" value=\""+keyword+"\"><input type=hidden name=\"state_reverse\" value=\""+reverse+"\">");
            if (comparator != null) {
                ListSorter.sortList(list, comparator, (reverse.equals("ascend")?true:false));
            }else if (keyword != null ) {
                ListSorter.sortList(list, keyword , (reverse.equals("ascend")? true : false) ,sort_type);
            } 

    }catch(Exception e){
           throw new JspException("exception: "+e.getMessage());
        }
        return SKIP_BODY;
    }
/*    public int doEndTag() throws JspException {
        
        return 0;
    }*/
	   
    private String printParameters(ServletRequest request) throws Exception {

        Enumeration e = request.getParameterNames();
        StringBuffer uri = new StringBuffer(sortTarget);

        uri.append("?");
        while (e != null && e.hasMoreElements()) 
        {
            String paraname=(String)e.nextElement();
            String [] params;
            params = request.getParameterValues(paraname);
            for (int i = 0; i<params.length; i++) {
                if ( !paraname.equals("sort_keyword") && !paraname.equals("sort_reverse")){
                    uri.append(paraname).append("=").append(params[i]).append("&");
                }
            }
        }
        return uri.toString();
    }

    private String getFirstElement(List ll) throws Exception{
        ListIterator iter = ll.listIterator();
        String elem = null;
        
        while (iter.hasNext()) {
            elem = (String)iter.next();
            if (elem == null) {
                continue;
            }
            StringTokenizer st = new StringTokenizer(elem);
            elem = st.nextToken();
            if (elem != null) {
                break;
            }
        }
        return elem;
    }
    
}
