/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.http;

import java.util.Iterator;
import java.util.Map;
import java.util.Vector;

import com.nec.sydney.atom.admin.base.NSUtil;
import com.nec.sydney.atom.admin.base.api.ExportRoot;
import com.nec.sydney.beans.base.APISOAPClient;
import com.nec.sydney.beans.base.TemplateBean;
import com.nec.sydney.framework.NSException;

public class HttpNavigatorBean extends TemplateBean{
    private static final String cvsid = "@(#) $Id: HttpNavigatorBean.java,v 1.2304 2007/04/27 01:37:59 zhangjx Exp $";
    private static final String DIR = "nfs";
    private static final String FILE_AND_DIR = "getall";
    private static final String DEFAULT_PATH = "/export";

    /**
     * assii format file or dirctory name
     */
    private String exportRoot;

    /**
     * hex format path, indicate "/export/" or below it.
     */
    private String path = "";

    /**
     * assii format path, indicate "/export" or below it.
     */
    private String pathShow;

    /**
     * DIR or FILE_AND_DIR.
     */
    private String act = DIR;

    /**
     * The vector to store the directorys and files.
     */
    private Vector subDir;

    /**
     * This method is invoked before "onDisplay", "onNormal", "onAlert" and "onThrow".
     */
    public void init() throws Exception{}


    public void onDisplay() throws Exception{
        this.path = NSUtil.ascii2hStr(this.DEFAULT_PATH);
        //Nas nas = NasManager.getInstance().getServerById(target);
        //Map exportRootMap = nas.getExportRootMap();
        Map exportRootMap = APISOAPClient.getExportGroups(target);
        Vector vExportRoot = new Vector();
        if (exportRootMap == null || exportRootMap.size() == 0){
        }else{
            Iterator itr = exportRootMap.keySet().iterator();
            while(itr.hasNext()){
                //ExportRoot exportRoot = (ExportRoot)itr.next();
                String exportRootPath = (String)itr.next();
                //vExportRoot.add(NSUtil.ascii2hStr(exportRootPath.split("/")[2]));
                vExportRoot.add(exportRootPath);
            }
        }        
        try {
            // get files and dirs into subDir;
            this.subDir = HTTPSOAPClient.getDir(target, path,"5");
        }catch(NSException e){
            if (e.getErrorCode() == NAS_EXCEP_NO_NFS_NAVIGATOR_DIR_NOT_EXISTS){
                this.subDir = null;
                return;
            }else {
                throw e;
            }
        }
        StringBuffer test = new StringBuffer();
        for (int i = this.subDir.size()-1; i >= 0; i--){
            String hexExport = (String)this.subDir.get(i);
            //if it is not directory, delete it from subDir.
            //The 10th is file name.
            
            if (hexExport.charAt(0) != 'd'){
                subDir.remove(i);
                continue;
            }
            String asiExport = NSUtil.hStr2ascii(hexExport.split(" ")[10]);
            test.append(DEFAULT_PATH+"/"+asiExport);
            if (!vExportRoot.contains(DEFAULT_PATH+"/"+asiExport)){
                test.append(" removed");
                subDir.remove(i);    
            }
            test.append("<br>");
        }
        //throw new Exception(test.toString()+"###"+getExportRootList() +"##"+subDir.toString());
    }

    /**
     * According to the path and act to get the fitting directorys or files.
     * and set these into subDir.
     */
    public void onFindPath() throws Exception{
        if (this.path.equals(NSUtil.ascii2hStr(this.DEFAULT_PATH))){
            this.onDisplay();
            return ;
        }

        try {
            if (this.path.split("0x2f").length == 3){
                this.subDir = HTTPSOAPClient.getDir(target,path, "1");
                return;
            }
            if (this.act.equals(this.DIR)){
                this.subDir = HTTPSOAPClient.getDir(target,path, "5");
                for (int i = this.subDir.size()-1; i >= 0; i--){
                    if (((String)this.subDir.get(i)).charAt(0) != 'd'){
                        this.subDir.remove(i);
                    }
                }
            }else if(this.act.equals(this.FILE_AND_DIR)){
                //get dirs and files
                this.subDir = HTTPSOAPClient
                            .getDir(target, path, "5");
            }
        }catch(NSException e){
            if (e.getErrorCode() == NAS_EXCEP_NO_NFS_NAVIGATOR_DIR_NOT_EXISTS){
                this.subDir = null;
                return;
            }else {
                throw e;
            }
        }

    }

    /**
     * Set method.
     * @param s DIR or FILE_AND_DIR.
     */
    public void setAct(String s){
        this.act = s;
    }
    
    /**
     * Get method.
     * @return act.
     */
    public String getAct(){
        return this.act;
    }

    /**
     * Set method
     * @param s the path below DEFAULT_PATH.
     */
    public void setPath(String s){
        this.path = s;
    }

    /**
     * Get method1
     * @return subDir
     */
    public Vector getSubDir(){
        return this.subDir;
    }

    /**
     * Get method
     * @return exportRoot
     */
    public String getExportRoot(){
        return exportRoot;
    }

    /**
     * Get method
     * @return subDir
     */
    public Vector getDir(){
        return subDir;
    }

    public HttpNavigatorBean(){}

    public Map getExportMap() throws Exception {
        return APISOAPClient.getExportGroups(target);
    }

    /**
     * translate the hex String to browse string.
     * @param path the hex String
     * @return the browse string
     * @throws Exception exception
     */
    public String encoding(String sPath, Map exportmap)throws Exception{
        //path = NSUtil.hStr2EncodeStr(path, NSUtil.EUC_JP, BROWSER_ENCODE);
        //return path;
        
        //Nas  nas  =  NasManager.getInstance().getServerById(target);  
        //Map exportmap = nas.getExportRootMap();
        //Map exportmap = APISOAPClient.getExportGroups(target);
        String[] paths = sPath.split("0x2f");
        if (paths.length < 3){
            //throw new Exception("##"+"size="+paths.length+"##");
            return DEFAULT_PATH;
        }
        String asiExportRootPath 
            = NSUtil.hStr2EncodeStr("0x2f"+paths[1]+"0x2f"+paths[2], 
                                    NSUtil.EUC_JP, 
                                    BROWSER_ENCODE);
        //ExportRoot export = (ExportRoot)exportmap.get(asiExportRootPath);
        String srcCode = NSUtil.EUC_JP;
        if (exportmap == null || !exportmap.containsKey(asiExportRootPath) ){
        }else{
            srcCode = ((ExportRoot)exportmap.get(asiExportRootPath)).getCodePage();
                  
        }
        
        return NSUtil.hStr2EncodeStr(sPath, srcCode, BROWSER_ENCODE);
        //path = NSUtil.hStr2EncodeStr(paths,
        //                     MapdCommon.getEncoding(target,asiExportRootPath),
        //                     BROWSER_ENCODE);
        //return path;
        
    }

public String getExportRootList() throws Exception{
    //Nas  nas  =  NasManager.getInstance().getServerById(target);  
    //Map exportmap = nas.getExportRootMap();
    Map exportmap = APISOAPClient.getExportGroups(target);
    if (exportmap == null || exportmap.size() == 0 ) {
        return("");
    }
    StringBuffer sb = new StringBuffer();
    Iterator ite = exportmap.keySet().iterator();
    while(ite.hasNext()){
        sb.append(ite.next().toString()+" ");
    }
    return sb.toString();
}

    /**
     * Get method
     * @return pathShow
     */
    public String getPathShow(){
        return pathShow;
    }

    /**
     * Get method
     * @return path
     */
    public String getPath(){
        return path;
    }
    
    /**
     * Get method
     * @return DEFAULT_PATH
     */
    public String getDefaultPath(){
        return DEFAULT_PATH;
    }
}
