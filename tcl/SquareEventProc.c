#include <tk.h>
#include "Square.h"

extern void SquareDisplay(ClientData clientData);
extern void SquareDestroy(ClientData clientData);

static void SquareEventProc(ClientData clientData, XEvent *eventPtr)
{
  Square *squarePtr = (Square *) clientData;
  if (eventPtr->type == Expose) {
    if (!squarePtr->updatePending) {
      Tk_DoWhenIdle((Tk_IdleProc *) SquareDisplay, (ClientData) squarePtr);
      squarePtr->updatePending = 1;
    }
  } else if (eventPtr->type == ConfigureNotify) {
    KeepInWindow(squarePtr);
    if (!squarePtr->updatePending) {
      Tk_DoWhenIdle((Tk_IdleProc *) SquareDisplay, (ClientData) squarePtr);
      squarePtr->updatePending = 1;
    }
  } else if (eventPtr->type == DestroyNotify) {
    Tcl_DeleteCommand(squarePtr->interp, Tk_PathName(squarePtr->tkwin));
    squarePtr->tkwin = NULL;
    if (squarePtr->updatePending) {
      Tk_CancelIdleCall((Tk_IdleProc *) SquareDisplay, (ClientData) squarePtr);
    }
    Tk_EventuallyFree((ClientData) squarePtr, (Tcl_FreeProc *) SquareDestroy);
  }
}
    
