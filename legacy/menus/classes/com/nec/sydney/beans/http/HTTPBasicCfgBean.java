/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.http;

import java.util.Hashtable;
import java.util.Map;

import com.nec.sydney.atom.admin.http.HTTPBasicInfo;
import com.nec.sydney.atom.admin.http.HTTPConstants;
import com.nec.sydney.beans.base.TemplateBean;
import com.nec.sydney.framework.NSException;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.sydney.framework.tools.req2file.ParameterFileMaker;
import com.nec.sydney.net.soap.Soap4Cluster;
import com.nec.sydney.net.soap.SoapResponse;

public class HTTPBasicCfgBean extends TemplateBean implements HTTPConstants{

    private static final String cvsid = "@(#) $Id: HTTPBasicCfgBean.java,v 1.2302 2005/09/27 08:43:58 xingh Exp $";
    private HTTPBasicInfo basicInfo;
    private static final String REDIRECT_URL = "../nas/http/httpinfo.jsp";

    public HTTPBasicCfgBean() {
        basicInfo = new HTTPBasicInfo();
    }

    public HTTPBasicInfo getHTTPBasicInfo(){
        return this.basicInfo;
    }
/*
    public void setDefaultOptions(String functions){
        this.basicInfo.setDefaultOptions(functions);
    }

    public void setSelectableFunctions(String options){
        this.basicInfo.setSelectableFunctions(options);
    }
*/
    public void setServiceStatus(boolean status){
        this.basicInfo.setServiceStatus(status);
    }

    public void setPorts(String ports){
        this.basicInfo.setPorts(ports);
    }

    public void onSend() throws Exception{
        Map dynamicInfo = new Hashtable();
        ParameterFileMaker.makeParameterMap(request, dynamicInfo);
        this.basicInfo.setDynamicInfo(dynamicInfo);
        SoapResponse sr = HTTPSOAPClient.setBasicInfo(getMyNum(), this.basicInfo, target);
        if (sr.isSuccessful()){
            String fnode = Soap4Cluster.whoIsMyFriend(target);
            if (fnode != null) {
                sr = HTTPSOAPClient.setBasicInfo(getMyNum(), this.basicInfo, fnode);
            }
        }
        if (!sr.isSuccessful()){
            if (sr.getErrorCode() == ERRORCODE_PORT_USED){
                super.setMsg(NSMessageDriver.getInstance()
                        .getMessage(session,"common/alert/failed") + "\\r\\n"
                        + NSMessageDriver.getInstance()
                        .getMessage(session,"nas_http/alert/port_been_used"));
            }else{
                throw new NSException(sr.getErrorMessage());
            }
        } else {

        }
        setRedirectUrl(REDIRECT_URL+"?infoLocation=tmp");
    }

    public void onDisplay() throws Exception{        
        this.basicInfo = HTTPSOAPClient.getBasicInfo(session,getMyNum(),target);
    }

}



