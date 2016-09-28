#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: makefile,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $"

RM = rm -f

CC=gcc



COMMON_DIR=../../general



SOURCES_STATEMON=$(wildcard *.c) $(COMMON_DIR)/general.c

OBJS=$(SOURCES_STATEMON:.c=.o)



INCLUDE_API_DIR=/opt/iSMSM/include

LIB_API_DIR=/opt/iSMSM/lib



CFLAGS=-I $(INCLUDE_API_DIR) -I$(COMMON_DIR)



all: iSAsetmon

iSAsetmon: $(OBJS)

	gcc -o $@ $^ -L$(LIB_API_DIR) -liSMSMApi -liSMSMCfgApi -liSMSM 

	

clean::

	$(RM) $(OBJS) iSAsetmon



