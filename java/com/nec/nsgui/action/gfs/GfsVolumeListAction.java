/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.gfs;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.gfs.GfsCmdHandler;
import com.nec.nsgui.model.entity.gfs.GfsVolumeInfoBean;

/**
 *Actions for volume
 */
public class GfsVolumeListAction extends Action implements GfsActionConst {
    private static final String cvsid =
        "@(#) $Id: GfsVolumeListAction.java,v 1.2 2005/11/22 02:24:31 zhangj Exp $";
    public ActionForward execute(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        String sortTypeOfNode = request.getParameter("SORT_TYPE_NODE");
        if (sortTypeOfNode == null) {
            sortTypeOfNode = SORT_TYPE_VOLUME_UP;
        }
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        ArrayList volumeList = GfsCmdHandler.getVolumeList(nodeNo);
        sortVolumeListByType(volumeList, sortTypeOfNode);
        request.setAttribute(SESSION_GFS_VOLUMELIST, volumeList);
        request.setAttribute("SORT_TYPE_NODE", sortTypeOfNode);
        return mapping.findForward("displayList");
    }

    /*
     * Private Function
     */
    private static void sortVolumeListByType(ArrayList volumeList, String type)
        throws Exception {
        if (type == null) {
            type = SORT_TYPE_VOLUME_UP;
        }
        if (type.equals(SORT_TYPE_VOLUME_UP)) {
            Collections.sort(volumeList, new Comparator() {
                public int compare(Object a, Object b) {
                    GfsVolumeInfoBean info_a = (GfsVolumeInfoBean) a;
                    GfsVolumeInfoBean info_b = (GfsVolumeInfoBean) b;
                    return info_a.getVolumeName().compareTo(
                        info_b.getVolumeName());
                }
            });
        } else if (type.equals(SORT_TYPE_VOLUME_DOWN)) {
            Collections.sort(volumeList, new Comparator() {
                public int compare(Object a, Object b) {
                    GfsVolumeInfoBean info_a = (GfsVolumeInfoBean) a;
                    GfsVolumeInfoBean info_b = (GfsVolumeInfoBean) b;
                    return info_b.getVolumeName().compareTo(
                        info_a.getVolumeName());
                }
            });
        } else if (type.equals(SORT_TYPE_MOUNTPOINT_UP)) {
            Collections.sort(volumeList, new Comparator() {
                public int compare(Object a, Object b) {
                    GfsVolumeInfoBean info_a = (GfsVolumeInfoBean) a;
                    GfsVolumeInfoBean info_b = (GfsVolumeInfoBean) b;
                    return info_a.getVolumeMountPoint().compareTo(
                        info_b.getVolumeMountPoint());
                }
            });
        } else if (type.equals(SORT_TYPE_MOUNTPOINT_DOWN)) {
            Collections.sort(volumeList, new Comparator() {
                public int compare(Object a, Object b) {
                    GfsVolumeInfoBean info_a = (GfsVolumeInfoBean) a;
                    GfsVolumeInfoBean info_b = (GfsVolumeInfoBean) b;
                    return info_b.getVolumeMountPoint().compareTo(
                        info_a.getVolumeMountPoint());
                }
            });
        }
    }
}