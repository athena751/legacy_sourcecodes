/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base;


import java.util.*;
import java.util.regex.*;


public class NSUtil {

    private static final String     cvsid = "@(#) $Id: NSUtil.java,v 1.2304 2007/06/28 01:26:55 zhangjx Exp $";
    public static final String ENGLISH = "English";
    public static final String EUC_JP = "EUC-JP";
    public static final String ISO8859 = "ISO8859-1";
    public static final String UTF8 = "UTF-8";
    public static final String UTF8_NFC = "UTF8-NFC";
    

    /* convert the hard bytes string to byte array,the format of the hard bytes string is "0xnn0xnn..." */ 
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

    /* convert the bytes array to hard hex String ,the format of the hard bytes string is "0xnn0xnn..." */ 
    public static String bytes2hStr(byte[] byteArray) throws Exception {
    
        StringBuffer hexBuffer = new StringBuffer(byteArray.length * 4);

        for (int i = 0; i < byteArray.length; i++) {
            hexBuffer.append("0x");
            int byteValue = (int) byteArray[i] & 0xff;
            String hexStr = Integer.toHexString(byteValue);

            if (hexStr.length() < 2) {
                hexBuffer.append("0").append(hexStr);
            } else {
                hexBuffer.append(hexStr);
            }
        }
        
        return hexBuffer.toString();
    }
    
    /* convert String to hard hex String */
    public static String str2hStr(String srcStr, String encoding) throws Exception {
        encoding = encoding.equalsIgnoreCase(ENGLISH) ? EUC_JP : encoding;
        return bytes2hStr(srcStr.getBytes(encoding));
    }
    
    /* convert the bytes to encode string,  */
    public static String bytes2EncodeStr(byte[] srcBytes, String srcEncode, String destEncode)throws Exception {
        
        srcEncode = srcEncode.equalsIgnoreCase(ENGLISH) ? EUC_JP : srcEncode;
        srcEncode = srcEncode.equalsIgnoreCase(UTF8_NFC) ? UTF8 : srcEncode;
        destEncode = destEncode.equalsIgnoreCase(ENGLISH) ? EUC_JP : destEncode;
        String srcStr = new String(srcBytes, srcEncode);
        String destStr;

        if (srcEncode.equalsIgnoreCase(destEncode)) {
            destStr = srcStr;
        } else {
            destStr = new String(srcStr.getBytes(destEncode), destEncode);
        }
        return destStr;
    }
    
    /* convert hard bytes string to encode string */
    public static String hStr2EncodeStr(String hStr, String srcEncode, String destEncode)throws Exception {
        
        byte[] bytes = hStr2Bytes(hStr);
        String encodedStr = bytes2EncodeStr(bytes, srcEncode, destEncode);
            
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
    
    /* convert the request string to encode String */
    public static String reqStr2EncodeStr(String reqStr, String destEncode)throws Exception {

        destEncode = destEncode.equalsIgnoreCase(ENGLISH) ? EUC_JP : destEncode;

        String systemEncode = System.getProperty("file.encoding");

        if (systemEncode.equalsIgnoreCase(destEncode)) {
            return reqStr;
        }
        
        return new String(reqStr.getBytes(systemEncode), destEncode);
    }
    
    /* convert the ascii string to hard bytes string */
    public static String ascii2hStr(String asciiStr)throws Exception {
        
        StringBuffer destBuffer = new StringBuffer(asciiStr.length() * 4);
        byte[] asciiBytes = asciiStr.getBytes();

        for (int i = 0; i < asciiBytes.length; i++) {
            destBuffer.append("0x").append(Integer.toHexString(asciiBytes[i]));             
        }
        
        return destBuffer.toString();
    }
    
    /** convert space to &nbsp; */
    public static String space2nbsp(String srcStr)throws Exception {
        return srcStr.replaceAll("\\s", "&nbsp;");
    }
    
    /* Check whether the hstr is direct mount point */
    public static final int DIRECT_MOUNT_POINT = 3;
    public static final int SUB_MOUNT_POINT = 4;
    public static final int INVALID_MOUNT_POINT = 0;
    
    public static int hStrIsDirectMP(String hStr) {
        
        String tokenStr = "0x2f"; // 0x2f
        String lowStr = hStr.toLowerCase();
        int iCnt = 0;
        int i = lowStr.indexOf(tokenStr);

        while (i != -1) {
            iCnt++;
            i = lowStr.indexOf(tokenStr, i + tokenStr.length());
        }
        
        if (iCnt == 3) {
            return DIRECT_MOUNT_POINT;
        } else if (iCnt > 3) {
            return SUB_MOUNT_POINT;
        }
        
        return INVALID_MOUNT_POINT;
    }    

    public static int bytesIsDirectMP(byte[] bMP) {

        int iCnt = 0;
        byte token = (byte) '/';

        for (int i = 0; i < bMP.length; i++) {
            if (bMP[i] == token) {
                iCnt++;
            }
        }        
        
        if (iCnt == 3) {
            return DIRECT_MOUNT_POINT;
        } else if (iCnt > 3) {
            return SUB_MOUNT_POINT;
        }
        
        return INVALID_MOUNT_POINT;
    }    

    public static String trimExport(String exportRoot) {
        String tokenStr = "/"; 
        int i1 = exportRoot.indexOf(tokenStr);
        int i2 = exportRoot.indexOf(tokenStr, i1 + 1);
        String result = exportRoot.substring(i2 + 1);

        return result;
    }// trim export root 

    /*
     public static void main(String[] args){
     String hStr = "0x2f0x840x820xCD0x920x690x8E0x2f0x8B0xB50x820xC50x2f0xB70x810x420x820xE60x820xEB0x820xB50x820xAD0x820xA80x8A0xE80x820xA20x820xB50x820xDC0x820xB70x810x42";
     try{
     //        byte a = Integer.paresInt("0x8e").byteValue();
     //        System.out.println("Byte = " + a + "Integer = " + Integer.toHexString(a) );
     System.out.println(getExportRootByHexMmountPoint(hStr));
     }catch(Exception e){
     e.printStackTrace();
     }
     
     }
     */
    // encoding is the exportroot code.
    public static String page2Perl(String pageStr, String encoding, String browseCoding) throws Exception {
        encoding = encoding.equalsIgnoreCase(ENGLISH) ? EUC_JP : encoding;
        browseCoding = browseCoding.equalsIgnoreCase(ENGLISH)
                ? EUC_JP
                : browseCoding;

        if (encoding.equalsIgnoreCase(browseCoding)) {
            return new String(pageStr);
        }
        String euc_str = NSUtil.reqStr2EncodeStr(pageStr, browseCoding);
        String perl_str = new String(euc_str.getBytes(encoding),
                System.getProperty("file.encoding"));

        return perl_str;
    }
    
    public static String perl2Page(String perlStr, String encoding) throws Exception {
        encoding = encoding.equalsIgnoreCase(ENGLISH) ? EUC_JP : encoding;
        String Unicode_Str = new String(
                perlStr.getBytes(System.getProperty("file.encoding")), encoding);

        return Unicode_Str;
    }
    
    private static String getHexExportRootByHexMmountPoint(String hexMountPoint)throws Exception {
        String tokenStr = "0x2f"; // 0x2f
        String lowStr = hexMountPoint.toLowerCase();
        int i = 0;
        boolean isMountPoint = false;

        i = lowStr.indexOf(tokenStr); // get the index of "0x2f" first time
        if (i != -1) {
            i = lowStr.indexOf(tokenStr, i + tokenStr.length()); // get the index of "0x2f" second time
        }
        if (i != -1) {
            i = lowStr.indexOf(tokenStr, i + tokenStr.length()); // get the index of "0x2f" third time
        }
        if (i != -1) {
            isMountPoint = true;
        }
        if (isMountPoint) {
            return (lowStr.substring(0, i));
        } else {
            return lowStr;
        }
    }
    
    public static String hStr2ascii(String hexString)throws Exception {
        byte[] bytes = hStr2Bytes(hexString);
        
        return (new String(bytes));
    }
    
    public static String getExportRootByHexMmountPoint(String hexMountPoint) throws Exception {
        return hStr2ascii(getHexExportRootByHexMmountPoint(hexMountPoint));
    }
    
    public static boolean checkValid(String str, String[] invalidChars) {
        boolean foundInvalid = false;

        for (int t = 0; t < invalidChars.length; t++) {
            if (str.indexOf(invalidChars[t]) != -1) {
                foundInvalid = true;
                break;
            }
        }
        return !foundInvalid;
    }

    /**
     * The function do the same work as GetDouble(double dvalue, int precision, int mode = 0 ), except that 
     * the first parameter which is the String to convert to Double
     */
    public static String getDouble(String doubleString, int precision) throws Exception {
        return getDouble(doubleString, precision, 0);
    }

    /**
     * The function do the same work as GetDouble(double dvalue, int precision, int mode ), except that 
     * the first parameter which is the String to convert to Double
     */
    public static String getDouble(String doubleString, int precision, int mode) throws Exception {
        double dvalue = (new Double(doubleString)).doubleValue();

        return getDouble(dvalue, precision, mode);
    }

    /**
     * The function do the same work as GetDouble(double dvalue, int precision, int mode = 0)
     */
    public static String getDouble(double dvalue, int precision) throws Exception {
        return getDouble(dvalue, precision, 0);
    }

    /**
     * The function formats a double value as the specified precision; The formated double value is rounded.
     * 
     * @param dvalue    : the double value which need to change 
     *        precision : the specified precision ( the digit number after the point)
     *        mode      : =0, use numeric part "#,##0"
     *                    !=0, not use numeric part but use "#0" 
     * @return the changed double valule string. If the changed double value is equal to 0, then retusn "0".
     */
    public static String getDouble(double dvalue, int precision, int mode) throws Exception {
        if (dvalue == 0) {
            return "0";
        }

        /* The DecimalFormat's rounding mode is ROUND_HALF_EVEN; but we expect the rounding mode is 
         *  ROUND_HALF_UP(l??j. 
         *  In the following source code, I added the process to make the rounding mode is ROUND_HALF_UP
         */
        
        // get the non-scientic format double value 
        String doubleString = changeScienticDouble(dvalue);
        // cut the double string at the position precision+1;
        StringTokenizer st = new StringTokenizer(doubleString, ".");
        String stleft = st.nextToken();
        String strright = st.nextToken();

        if (strright.length() > precision) {
            strright = strright.substring(0, precision + 1);
        }
        StringBuffer strBuf = new StringBuffer(stleft);

        strBuf.append(".");
        strBuf.append(strright);

        dvalue = (new Double(strBuf.toString())).doubleValue();
        // start to change the double to the specified format
        StringBuffer buf = new StringBuffer("#0."); 
        java.text.DecimalFormat form = new java.text.DecimalFormat();  
        StringBuffer resultBuf;
       
        /* The DecimalFormat's rounding mode is ROUND_HALF_EVEN; but we expect the rounding mode is 
         *  ROUND_HALF_UP(l??j. 
         *  In the following source code, I added the process to make the rounding mode is ROUND_HALF_UP
         */
        
        for (int i = 0; i <= precision; i++) {
            buf.append("0");
        }
        form.applyPattern(buf.toString());
   
        resultBuf = new StringBuffer(form.format(dvalue));
        
        int strLen = resultBuf.length();
        char decideChar;
        int location = (precision == 0 ? strLen - 3 : strLen - 2);
        
        decideChar = resultBuf.charAt(location);

        if (decideChar == '0' || decideChar == '2' || decideChar == '4' 
                || decideChar == '6' || decideChar == '8') {
            if ((resultBuf.charAt(strLen - 1)) == '5') { //
                decideChar = (char) (decideChar + 1);
                resultBuf.setCharAt(location, decideChar);
                resultBuf.setCharAt(strLen - 1, '4');
            }
        }

        /* To compare the formatted value with 0, get the formatted value 
         * which is not formatted by "#,###". 
         * Reason: If the format is "#,###", the doubleValue() will throws exception         
         */
        strLen = buf.length();
        buf = buf.delete(strLen - 1, strLen);
        form.applyPattern(buf.toString());
        
        String result = form.format(
                (new Double(resultBuf.toString())).doubleValue());
        
        if (((new Double(result)).doubleValue()) == 0) {
            return "0";
        }

        // If the double vaule is not equal to 0, get the final result.     
        if (mode == 0) {    
            buf = (precision != 0
                    ? new StringBuffer("#,##0.")
                    : new StringBuffer("#,##0"));
        } else {
            buf = (precision != 0
                    ? new StringBuffer("#0.")
                    : new StringBuffer("#0"));
        }
            
        for (int i = 0; i < precision; i++) {
            buf.append("0");
        }
    
        form.applyPattern(buf.toString());
        
        result = form.format((new Double(resultBuf.toString())).doubleValue());
        return result;
    }
    
    // This function change the double value with scientic format to with non-scientic format
    public static String changeScienticDouble(double dvalue) {
        String str = (new Double(dvalue)).toString();        
        StringTokenizer st = new StringTokenizer(str, "E");
        String strleft = st.nextToken();

        if (!st.hasMoreTokens()) {
            st = new StringTokenizer(str, "e");
            strleft = st.nextToken();
            if (!st.hasMoreTokens()) {
                return str;
            }
        }
        int numAfterE = (new Integer(st.nextToken())).intValue();
        StringTokenizer ptToken = new StringTokenizer(strleft, ".");
        String beforePoint = ptToken.nextToken();
        String afterPoint = ptToken.nextToken();
        StringBuffer strbuf = new StringBuffer();

        if (numAfterE > 0) {
            strbuf.append(beforePoint);
            int length = afterPoint.length();

            if (length > numAfterE) {
                strbuf.append(afterPoint.substring(0, numAfterE));
                strbuf.append(".");
                strbuf.append(afterPoint.substring(numAfterE, length));
            } else {
                strbuf.append(afterPoint);
                for (int j = 0; j < numAfterE - length; j++) {
                    strbuf.append("0");
                }
                strbuf.append(".0");
            }
        } else {
            int bpValue = (new Integer(beforePoint)).intValue();

            if (bpValue >= 0) {
                strbuf.append("0.");
            } else {
                strbuf.append("-0.");
                beforePoint = (new Integer(bpValue * -1)).toString();
            }
            for (int j = 0; j < numAfterE * (-1) - 1; j++) {
                strbuf.append("0");
            }
            strbuf.append(beforePoint);
            strbuf.append(afterPoint);
        }

        String result = strbuf.toString();

        return result;

    }

    public static boolean matches(String objStr, String pattern) {
        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(objStr);

        return m.find();
    }
    
    public static String getHexString(int dispLength, String str) throws Exception {
        String hexStr = Integer.toHexString((new Integer(str)).intValue());   
        StringBuffer sb = new StringBuffer();

        if (hexStr.length() < dispLength) {
            for (int i = 0; i < dispLength - hexStr.length(); i++) {
                sb.append("0");
            }
        }
        sb.append(hexStr);
        sb.append("h");
        return sb.toString();
    }    
    
}
