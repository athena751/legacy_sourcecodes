/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.base;

public class NSModelUtil{
    public static final String cvsid =
        "@(#) $Id: NSModelUtil.java,v 1.4 2005/10/19 00:50:16 fengmh Exp $";

    public static final String ENGLISH = "English";
    public static final String EUC_JP = "EUC-JP";
    public static final String ISO8859 = "ISO8859-1";
    public static final String UTF8 = "UTF8";
    public static final String SCIRPT_GET_VALUE = "/bin/nsgui_getvalue.pl";
    public static final String SCIRPT_SET_VALUE = "/bin/nsgui_setvalue.pl";
    
    /**
     * change string 's codepge.
     * @param perlStr - string in perl's encoding
     *        encoding - coding to change
     * @return string - changed string
     */
    public static String perl2Page(String perlStr, String encoding)
        throws Exception {
        encoding = encoding.equalsIgnoreCase(ENGLISH) ? EUC_JP : encoding;
        String Unicode_Str =
            new String(
                perlStr.getBytes(System.getProperty("file.encoding")),
                encoding);

        return Unicode_Str;
    }
    
    
    /**
    *@param  month : For example Aug or August
    *@return int  :  Jan -> 0
    *                Feb -> 1
    *                ...
    */
    public static int getMonthInt(String month) {
         String [] allMonth = {"January" , "February" , "March" , "April" ,
                                "May" , "June" , "July" , "August" ,
                                "September" , "October" , "November", "December"};
      
        int monthInt = 0;
        for (int i=0 ; i<allMonth.length; i++) {
            if (allMonth[i].regionMatches(true , 0 , month , 0 , 3)) {
                monthInt = monthInt + i;
                break;
            }
        }
        
        return monthInt;
    }
    /* convert hard bytes string to encode string */
    public static String hStr2Str(String hStr)throws Exception {
        byte[] bytes = hStr2Bytes(hStr);
        String encodedStr = new String(bytes, "UTF-8");
        // if can't convert the str , replace the invalid char with "?"
        if ((hStr != null) && (!hStr.equals("")) && (encodedStr != null)
                && (encodedStr.equals(""))) {
            StringBuffer encodeBuffer = new StringBuffer(bytes.length);
            for (int i = 0; i < bytes.length; i++) {
                if (bytes[i] > 0 && bytes[i] < 128) { // ascii
                    encodeBuffer.append((char) bytes[i]);
                } else {
                    encodeBuffer.append("?");
                }
            }
            encodedStr = encodeBuffer.toString();
        }
        return encodedStr;
    }
//  added by zhangjun 2005-05-12
      public static byte[] hStr2Bytes(String hStr) throws Exception {
          int len = hStr.length() / 4;
          byte[] rstBytes = new byte[len];
          int start = 0;
          for (int i = 0; i < len; i++) {
              rstBytes[i] = Integer.decode(hStr.substring(start, start + 4)).byteValue();
              start += 4;
          }
          return rstBytes;
      }

    public static String getValueByProperty(String filePath, String property) throws Exception {
        //localExecCmd
        return getValueByProperty(filePath, property, -1);
    }
    
    public static String getValueByProperty(String filePath, String property,
            int nodeNo) throws Exception {
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_GET_VALUE, filePath,
                property };
        NSCmdResult cmdResult;
        if(nodeNo == -1) {
            cmdResult = CmdExecBase.localExecCmd(cmds, null);
        } else {
            cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
        }
        String[] results = cmdResult.getStdout();
        return results[0];
    }

    public static void setValueByProperty(String filePath, String property,
            String value, int nodeNo) throws Exception {
        String[] cmds = { CmdExecBase.CMD_SUDO,
                System.getProperty("user.home") + SCIRPT_SET_VALUE, filePath,
                property, value };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
    }
}