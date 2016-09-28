/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.gfs;
/**
 *
 */

public class GfsLDInfoBean {
    private static final String cvsid =
                "@(#) $Id: GfsLDInfoBean.java,v 1.2 2005/12/01 01:57:19 zhangjun Exp $";
        private String deviceName = "";
        private String deviceSize = "";
        private String deviceLun = "";
        private String deviceWwnn = "";
        private String gfsType = "";
        //add by zhangjun
        private String serialNo = "";

        /**
         * @return
         */
        public String getDeviceLun() {
            return deviceLun;
        }

        /**
         * @return
         */
        public String getDeviceName() {
            return deviceName;
        }

        /**
         * @return
         */
        public String getDeviceSize() {
            return deviceSize;
        }

        /**
         * @return
         */
        public String getDeviceWwnn() {
            return deviceWwnn;
        }

        /**
         * @return
         */
        public String getGfsType() {
            return gfsType;
        }

        /**
         * @return
         */
        public String getSerialNo() {
            return serialNo;
        }

        /**
         * @param string
         */
        public void setDeviceLun(String string) {
            deviceLun = string;
        }

        /**
         * @param string
         */
        public void setDeviceName(String string) {
            deviceName = string;
        }

        /**
         * @param string
         */
        public void setDeviceSize(String string) {
            deviceSize = string;
        }

        /**
         * @param string
         */
        public void setDeviceWwnn(String string) {
            deviceWwnn = string;
        }

        /**
         * @param string
         */
        public void setGfsType(String string) {
            gfsType = string;
        }

        /**
         * @param string
         */
        public void setSerialNo(String string) {
            serialNo = string;
        }

}