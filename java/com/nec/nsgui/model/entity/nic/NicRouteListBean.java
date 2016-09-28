/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicRouteListBean.java,v 1.1 2005/10/24 04:56:14 dengyp Exp $
 */


package com.nec.nsgui.model.entity.nic;
import java.util.Vector;

public class NicRouteListBean {

    private Vector routes;
    private String source ;   
    
    public String getRouteCount(){   
        return Integer.toString(routes.size());
    }
    
    public NicRouteListBean(){
        source ="";
        routes = new Vector();
    }
    /**
     * @return
     */
    public String getSource() {
        return source;
    }

    /**
     * @param string
     */
    public void setSource(String string) {
        source = string;
    }

    /**
     * @return
     */
    public Vector getRoutes() {
        return routes;
    }

    /**
     * @param vector
     */
    public void setRoutes(Vector vector) {
        routes = vector;
    }

}