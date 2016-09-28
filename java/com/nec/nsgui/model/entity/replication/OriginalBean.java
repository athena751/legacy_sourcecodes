/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.replication;

import com.nec.nsgui.action.replication.ReplicationActionConst;

/**
 *
 */
public class OriginalBean {
    private static final String cvsid =
            "@(#) $Id: OriginalBean.java,v 1.2 2008/05/28 03:24:56 liy Exp $";
    
        protected String filesetName = "";
        protected String mountPoint = "";
        protected String transInterface = "";
        protected String bandWidth = "";
        protected String replicaHost = "";
        protected String connectionAvailable = "";
        protected String hasMounted = "";
        protected String type= "";  // export or local
        protected String volSyncInFileset = "0";
        protected String hour= ReplicationActionConst.DEFAULT_HOUR;
        protected String minute= ReplicationActionConst.DEFAULT_MINUTE;
        protected String repliMethod = ReplicationActionConst.CONST_REPLI_METHOD_SPLIT;
    
        /**
         * @return
         */
        public  void setOriginal(String fileset, String connectionavailable,String interfaceip,String bandwidth,String replicahost,String mountpoint) {
            filesetName = fileset;
            connectionAvailable = connectionavailable;
            transInterface=interfaceip;
            bandWidth = bandwidth;
            replicaHost = replicahost;
            mountPoint =  mountpoint; 
        }

    

   

        /**
         * @return
         */
        public String getBandWidth() {
            return bandWidth;
        }

        /**
         * @return
         */
        public String getConnectionAvailable() {
            return connectionAvailable;
        }

        /**
         * @return
         */
        public String getFilesetName() {
            return filesetName;
        }

        /**
         * @return
         */
        public String getHasMounted() {
            return hasMounted;
        }

        /**
         * @return
         */
        public String getMountPoint() {
            return mountPoint;
        }

        /**
         * @return
         */
        public String getReplicaHost() {
            return replicaHost;
        }

        /**
         * @return
         */
        public String getTransInterface() {
            return transInterface;
        }
        public String getVolSyncInFileset() {
            return volSyncInFileset;
        }
        public String getHour() {
            return hour;
        }
        public String getMinute() {
            return minute;
        }
        public String getRepliMethod() {
            return repliMethod;
        }
        /**
         * @param string
         */
        public void setBandWidth(String string) {
            bandWidth = string;
        }

        /**
         * @param string
         */
        public void setConnectionAvailable(String string) {
            connectionAvailable = string;
        }

        /**
         * @param string
         */
        public void setFilesetName(String string) {
            filesetName = string;
        }

        /**
         * @param string
         */
        public void setHasMounted(String string) {
            hasMounted = string;
        }

        /**
         * @param string
         */
        public void setMountPoint(String string) {
            mountPoint = string;
        }

        /**
         * @param string
         */
        public void setReplicaHost(String string) {
            replicaHost = string;
        }

        /**
         * @param string
         */
        public void setTransInterface(String string) {
            transInterface = string;
        }

        /**
         * @return
         */
        public String getType() {
            return type;
        }

        /**
         * @param string
         */
        public void setType(String string) {
            type = string;
        }

        public void setVolSyncInFileset(String volSyncInFileset) {
            this.volSyncInFileset = volSyncInFileset;
        }
        public void setHour(String hour) {
        	this.hour = hour;
        }
        public void setMinute(String minute) {
        	this.minute = minute;
        }
        public void setRepliMethod(String repliMethod) {
            this.repliMethod = repliMethod;
        }
}
