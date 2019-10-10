CC = gcc
XRDB = xrdb
RM = rm

CCFLAGS = -g 
WARNINGFLAGS = -Wall
XHDR = -I/usr/include -I/usr/local/include -I/usr/X11R6/include -I/usr/local/motif/include
XLIB = -L/usr/lib -L/usr/X11R6/lib -lXm -lXt -lX11 

INCFLAGS = $(XHDR)
LIBFLAGS = $(XLIB) $(REGLIB)

.c.o:
	$(CC) $(CCFLAGS) -c $< $(WARNINGFLAGS) $(INCFLAGS)

all:	xmainwindow xhello xgoodbye xbox1 xrdb 
xrdb:
	$(XRDB) -merge *.ad
xmainwindow:	xmainwindow.o
	$(CC) -o $@ $? $(LIBFLAGS) 
xhello:	xhello.o
	$(CC) -o $@ $? $(LIBFLAGS) 
xgoodbye:	xgoodbye.o
	$(CC) -o $@ $? $(LIBFLAGS)
xbox1:	xbox1.o
	$(CC) -o $@ $? $(LIBFLAGS)
clean:
	$(RM) -f *.o *.c~ core *.h~ xmainwindow xhello xgoodbye xbox1 xrdb
