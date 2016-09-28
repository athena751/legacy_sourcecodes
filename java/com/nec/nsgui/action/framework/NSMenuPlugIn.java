/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.framework;


import java.io.InputStream;

import javax.servlet.ServletException;

import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.biz.framework.menu.NSMenuFactory;

/**
 *
 */
public class NSMenuPlugIn implements PlugIn, NSActionConst {
    private static final String cvsid = "@(#) $Id: NSMenuPlugIn.java,v 1.2 2004/07/14 14:07:26 het Exp $";
    private String defaultMachineType = "";
    private String confFile = "";
    /* (non-Javadoc)
     * @see org.apache.struts.action.PlugIn#destroy()
     */
    public void destroy() {

    }

    /* (non-Javadoc)
     * @see org.apache.struts.action.PlugIn#init(org.apache.struts.action.ActionServlet, org.apache.struts.config.ModuleConfig)
     */
    public void init(ActionServlet servlet, ModuleConfig config)
        throws ServletException {
        if (confFile == null
            || confFile.equals("")
            || defaultMachineType == null
            || defaultMachineType.equals("")) {
            throw new ServletException("The parameters of NSMenuPlugIn has not been specified.");
        }
        try {
            String[] configFiles = confFile.split(CONFIG_FILE_SEPARATER);
            InputStream[] inputs = new InputStream[configFiles.length];
            for (int i = 0; i < configFiles.length; i++) {
                inputs[i] =
                servlet.getServletContext().getResourceAsStream(
                        configFiles[i].trim());
            }
            NSMenuFactory.init(defaultMachineType, inputs);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    /**
     * @return
     */
    public String getConfFile() {
        return confFile;
    }

    /**
     * @return
     */
    public String getDefaultMachineType() {
        return defaultMachineType;
    }

    /**
     * @param string
     */
    public void setConfFile(String string) {
        confFile = string;
    }

    /**
     * @param string
     */
    public void setDefaultMachineType(String string) {
        defaultMachineType = string;
    }

}
