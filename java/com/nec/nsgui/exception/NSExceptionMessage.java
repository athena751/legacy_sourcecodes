/*
 *      Copyright (c) 2004-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.nsgui.exception;

import com.nec.nsgui.model.biz.base.NSException;

public class NSExceptionMessage {

    private static final String cvsid =
        "@(#) $Id: NSExceptionMessage.java,v 1.7 2008/02/15 06:18:11 wanghui Exp $";
    private StringBuffer generalInfo = new StringBuffer();
    private StringBuffer generalDeal = new StringBuffer();
    private StringBuffer detailInfo = new StringBuffer();
    private StringBuffer detailDeal = new StringBuffer();
    private String displayDetail="";
    private String level="";
    private NSException causeException;

    public String getGeneralInfo() {
        return generalInfo.toString();
    }
    
    public String getGeneralDeal() {
        return generalDeal.toString();
    }

    public String getDetailInfo() {
        return detailInfo.toString();
    }
    
    public String getDetailDeal() {
        return detailDeal.toString();
    }
    
    public void appendGeneralInfo(String str) {
        generalInfo.append(str);
    }
    
    public void appendGeneralDeal(String str) {
        generalDeal.append(str);
    }

    public void appendDetailInfo(String str) {
        detailInfo.append(str);
    }

    public void appendDetailDeal(String str) {
        detailDeal.append(str);
    }

    //start----
    //add by wanghui for reset info and deal
    public void setGeneralInfo(String str){
        StringBuffer sb = new StringBuffer();
        sb.append(str);
        generalInfo = sb;
    }
    
    public void setGeneralDeal(String str){
        StringBuffer sb = new StringBuffer();
        sb.append(str);
        generalDeal = sb;
    }
    
    public void setDetailInfo(String str) {
        StringBuffer sb = new StringBuffer();
        sb.append(str);
        detailInfo = sb;
    }
    
    public void setDetailDeal(String str) {
        StringBuffer sb = new StringBuffer();
        sb.append(str);
        detailDeal = sb;
    }
    //---end

    public NSException getCauseException() {
        return causeException;
    }

    public void setCauseException(NSException exception) {
        causeException = exception;
    }
    
          /**
           * @return
           */ 
          public String getDisplayDetail() {
              return displayDetail;
          }
 
           /**
           * @param string
           */ 
          public void setDisplayDetail(String string) {
              displayDetail = string;
          }
          /**
           * @return
           */ 
          public String getLevel() {
              return level;
          }
 
           /**
           * @param string
           */ 
          public void setLevel(String string) {
              level = string;
          }
}