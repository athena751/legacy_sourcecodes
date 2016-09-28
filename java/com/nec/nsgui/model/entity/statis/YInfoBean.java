/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.statis;

/**
 * @author Administrator
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class YInfoBean {
     private static final String cvsid =
            "@(#) $Id: YInfoBean.java,v 1.2 2005/10/21 01:27:55 pangqr Exp $";   
    String max="";
    String maxunit="-";
    String displaymax="default";
    String min="";
    String minunit="-";
    String displaymin="default";
    /**
     * @return Returns the maxradio.
     */
    public String getMaxradio() {
        return maxradio;
    }
    /**
     * @param maxradio The maxradio to set.
     */
    public void setMaxradio(String maxradio) {
        this.maxradio = maxradio;
    }
    /**
     * @return Returns the minradio.
     */
    public String getMinradio() {
        return minradio;
    }
    /**
     * @param minradio The minradio to set.
     */
    public void setMinradio(String minradio) {
        this.minradio = minradio;
    }
    String maxradio="default";
    String minradio="default";

    /**
     * @return Returns the displaymax.
     */
    public String getDisplaymax() {
        return displaymax;
    }
    /**
     * @param displaymax The displaymax to set.
     */
    public void setDisplaymax(String displaymax) {
        this.displaymax = displaymax;
    }
    /**
     * @return Returns the displaymin.
     */
    public String getDisplaymin() {
        return displaymin;
    }
    /**
     * @param displaymin The displaymin to set.
     */
    public void setDisplaymin(String displaymin) {
        this.displaymin = displaymin;
    }
    /**
     * @return Returns the max.
     */
    public String getMax() {
        return max;
    }
    /**
     * @param max The max to set.
     */
    public void setMax(String max) {
        this.max = max;
    }
    /**
     * @return Returns the maxunit.
     */
    public String getMaxunit() {
        return maxunit;
    }
    /**
     * @param maxunit The maxunit to set.
     */
    public void setMaxunit(String maxunit) {
        this.maxunit = maxunit;
    }
    /**
     * @return Returns the min.
     */
    public String getMin() {
        return min;
    }
    /**
     * @param min The min to set.
     */
    public void setMin(String min) {
        this.min = min;
    }
    /**
     * @return Returns the minunit.
     */
    public String getMinunit() {
        return minunit;
    }
    /**
     * @param minunit The minunit to set.
     */
    public void setMinunit(String minunit) {
        this.minunit = minunit;
    }
}
