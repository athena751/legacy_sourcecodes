/*      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.base;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class NSProcess extends Process {
    private static final String cvsid = "@(#) $Id: NSProcess.java,v 1.5 2007/09/21 01:35:16 liy Exp $";

    private Process process;

    private InputStream inputStream;

    private InputStream errroStream;

    private int exitValue;

    private boolean called_waitFor = false;

    public NSProcess(Process proc) {
        process = proc;
    }

    public int waitFor() throws InterruptedException {
        called_waitFor = true;
        InputStream std = process.getInputStream();
        InputStream err = process.getErrorStream();

        // Modified by changhs , for J2SDK1.4.2's bug at 2005-08-23.
        // To avoid the block Bug of J2SDK1.4.2, call the NSProcess's waitfor to
        // read all the STDOUT and STDERR before;
        int BUFSIZE = 1024;
        StringBuffer stdsb = new StringBuffer(BUFSIZE);
        StringBuffer errsb = new StringBuffer(BUFSIZE);
        boolean done = false;
        int bytes_read = 0;
        byte buffer[] = new byte[BUFSIZE];
        try {
            while (!done) {
                try {
                    exitValue = process.exitValue();
                    done = true;
                } catch (IllegalThreadStateException e) {
                	try{
                		Thread.sleep(100);
            		}
            		catch(InterruptedException ex){
                    }
                }

                while (err.available() > 0) {
                    bytes_read = err.read(buffer, 0, BUFSIZE);
                    errsb.append(new String(buffer, 0, bytes_read));
                }

                while (std.available() > 0) {
                    bytes_read = std.read(buffer, 0, BUFSIZE);
                    stdsb.append(new String(buffer, 0, bytes_read));
                }
            }

            while ((bytes_read = err.read(buffer, 0, BUFSIZE)) > 0) {
                errsb.append(new String(buffer, 0, bytes_read));
            }
            while ((bytes_read = std.read(buffer, 0, BUFSIZE)) > 0) {
                stdsb.append(new String(buffer, 0, bytes_read));
            }
        } catch (IOException e) {
            InterruptedException ee = new InterruptedException(e.getMessage());
            ee.initCause(e.getCause());
            throw ee;
        }

        inputStream = new ByteArrayInputStream(stdsb.toString().getBytes());
        errroStream = new ByteArrayInputStream(errsb.toString().getBytes());

        return exitValue;
    }

    public int exitValue() {
        if (called_waitFor) {
            return exitValue;
        } else {
            return process.exitValue();
        }
    }

    public InputStream getErrorStream() {
        if (called_waitFor) {
            return errroStream;
        } else {
            return process.getErrorStream();
        }
    }

    public InputStream getInputStream() {
        if (called_waitFor) {
            return inputStream;
        } else {
            return process.getInputStream();
        }
    }

    public OutputStream getOutputStream() {
        return process.getOutputStream();
    }

    public void destroy() {
        process.destroy();
    }

}
