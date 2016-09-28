/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.gfs;
import java.util.ArrayList;
/**
 *
 */

public class GfsVolumeInfoBean {
    private static final String cvsid =
                "@(#) $Id: GfsVolumeInfoBean.java,v 1.1 2005/11/04 01:27:08 zhangj Exp $";
        private String volumeName = "";
        private String volumeSize = "";
        private String volumeMountPoint = "";
        private ArrayList deviceList;
        /**
        * @return
        */
        public String getVolumeName() {
           return volumeName;
        }
       /**
        * @return
        */
        public ArrayList getDeviceList() {
            return deviceList;
        }
       /**
        * @return
        */
        public String getVolumeSize() {
            return volumeSize;
        }

        /**
         * @return
         */
        public String getVolumeMountPoint() {
            return volumeMountPoint;
        }
        /**
         * @param string
         */
        public void setVolumeName(String string) {
            volumeName = string;
        }
        /**
         * @param ArrayList
         */
        public void setDeviceList(ArrayList list) {
            deviceList = list;
        }
      /**
         * @param string
         */
        public void setVolumeSize(String string) {
            volumeSize = string;
        }
        /**
         * @param string
         */
        public void setVolumeMountPoint(String string) {
            volumeMountPoint = string;
        }
}