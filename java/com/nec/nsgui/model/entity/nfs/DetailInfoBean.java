/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.nfs;

import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class DetailInfoBean {
    private static final String cvsid =
            "@(#) $Id: DetailInfoBean.java,v 1.2 2004/09/09 05:24:36 het Exp $";
    private List nisDomainList = new ArrayList();
    private String seletedNisDomain = "";
    private String seletedNisDomain4Unix = "";
    private String seletedNisDomain4Win = "";
    private boolean isSxfsfw = false;
    private boolean isSubMountPoint = true;
    private boolean needAuthDomain = false;
    private boolean needNativeDomain = false;
    private String clientOptions = "";
    /**
     * @return
     */
    public String getClientOptions() {
        return clientOptions;
    }

    /**
     * @return
     */
    public boolean getIsSubMountPoint() {
        return isSubMountPoint;
    }

    /**
     * @return
     */
    public boolean getIsSxfsfw() {
        return isSxfsfw;
    }

    /**
     * @return
     */
    public boolean getNeedAuthDomain() {
        return needAuthDomain;
    }

    /**
     * @return
     */
    public boolean getNeedNativeDomain() {
        return needNativeDomain;
    }

    /**
     * @return
     */
    public List getNisDomainList() {
        return nisDomainList;
    }

    /**
     * @return
     */
    public String getSeletedNisDomain() {
        return seletedNisDomain;
    }

    /**
     * @param string
     */
    public void setClientOptions(String string) {
        clientOptions = string;
    }

    /**
     * @param b
     */
    public void setIsSubMountPoint(boolean b) {
        isSubMountPoint = b;
    }

    /**
     * @param b
     */
    public void setIsSxfsfw(boolean b) {
        isSxfsfw = b;
    }

    /**
     * @param b
     */
    public void setNeedAuthDomain(boolean b) {
        needAuthDomain = b;
    }

    /**
     * @param b
     */
    public void setNeedNativeDomain(boolean b) {
        needNativeDomain = b;
    }

    /**
     * @param list
     */
    public void setNisDomainList(List list) {
        nisDomainList = list;
    }

    /**
     * @param string
     */
    public void setSeletedNisDomain(String string) {
        seletedNisDomain = string;
    }

    /**
     * @return
     */
    public String getSeletedNisDomain4Win() {
        return seletedNisDomain4Win;
    }

    /**
     * @param string
     */
    public void setSeletedNisDomain4Win(String string) {
        seletedNisDomain4Win = string;
    }

    /**
     * @return
     */
    public String getSeletedNisDomain4Unix() {
        return seletedNisDomain4Unix;
    }

    /**
     * @param string
     */
    public void setSeletedNisDomain4Unix(String string) {
        seletedNisDomain4Unix = string;
    }

}
