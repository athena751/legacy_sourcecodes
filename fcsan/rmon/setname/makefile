#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: makefile,v 1.2300 2003/11/24 00:54:30 nsadmin Exp $"

RM = rm -f

CC=gcc



COMMON_DIR=../../general



SOURCES_SETNAME=$(wildcard *.c) $(COMMON_DIR)/general.c

OBJS=$(SOURCES_SETNAME:.c=.o)



INCLUDE_API_DIR=/opt/iSMSM/include

LIB_API_DIR=/opt/iSMSM/lib



CFLAGS=-I $(INCLUDE_API_DIR) -I$(COMMON_DIR)



all: iSAsetname

iSAsetname: $(OBJS)

	gcc -o $@ $^ -L$(LIB_API_DIR) -liSMSMApi -liSMSMCfgApi -liSMSM 

	

clean::

	$(RM) $(OBJS) iSAsetname



