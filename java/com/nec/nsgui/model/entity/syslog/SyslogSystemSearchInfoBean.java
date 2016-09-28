/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.syslog;

/**
 *
 */

public class SyslogSystemSearchInfoBean {
    private static final String cvsid =
            "@(#) $Id: SyslogSystemSearchInfoBean.java,v 1.2 2004/11/26 10:56:06 maojb Exp $";

    private String[] searchKeyword;
    private String allKeywords = ""; 
    /**
     * @return
     */
    public String[] getSearchKeyword() {
        return searchKeyword;
    }

    /**
     * @param strings
     */
    public void setSearchKeyword(String[] strings) {
        searchKeyword = strings;
    }

    public String getKeywords_forSearch(boolean isAll) {
        String  keywords_forSearch = "";
        String tmpSearchKeyword[] = null;
        if(isAll){
            return allKeywords;
        }else{
            tmpSearchKeyword = searchKeyword;
        }
        if(tmpSearchKeyword != null){
            for(int i=0; i<searchKeyword.length; i++){
                keywords_forSearch = keywords_forSearch
                                 + tmpSearchKeyword[i]
                                 + "|";
            }
        }
        if(keywords_forSearch.endsWith("|")){
            keywords_forSearch = keywords_forSearch.substring(0, keywords_forSearch.length()-1);
        }
        
        return keywords_forSearch;
    }

    /**
     * @return
     */
    public String getAllKeywords() {
        return allKeywords;
    }

    /**
     * @param string
     */
    public void setAllKeywords(String string) {
        allKeywords = string;
    }

}

