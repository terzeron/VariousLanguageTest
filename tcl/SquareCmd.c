#include <tk.h>
#include "Square.h"

extern void SquareEventProc(ClientData clientData, XEvent *eventPtr);
extern int SquareWidgetCmd(ClientData clientData, Tcl_Interp *interp, int argc, char *argv[]);

static int SquareCmd(ClientData clientData, Tcl_Interp *interp, int argc, char *argv[])
{
  Tk_Window main = (Tk_Window) clientData;
  Square *squarePtr;
  Tk_Window tkwin;

  if (argc < 2) {
    Tcl_AppendResult(interp, "wrong # args: should be \"", argv[0], " pathName ?
options?\"", (char *) NULL);
    return TCL_ERROR;
  }
  Tk_SetClass(tkwin, "Square");

  squarePtr = (Square *) malloc(sizeof(Square));
  squarePtr->tkwin = tkwin;
  squarePtr->display = Tk_Display(tkwin);
  squarePtr->interp = interp;
  squarePtr->x = squarePtr->y = 0;
  squarePtr->size = 20;
  squarePtr->borderWidth = 0;
  squarePtr->bgBorder = squarePtr->fgBorder = NULL;
  squarePtr->relief = TK_RELIEF_FLAT;
  squarePtr->gc = None;
  squarePtr->updatePending = 0;
  
  Tk_CreateEventHandler(tkwin, ExposureMask|StructureNotifyMask, (Tk_EventProc *) SquareEventProc, (ClientData) squarePtr);
  Tk_CreateCommand(interp, Tk_PathName(tkwin), SquareWidgetCmd, (ClientData) squarePtr, (Tcl_CmdDeleteProc *) NULL);
  if (SquareConfigure(interp, squarePtr, argc-2, argv+2, 0) != TCL_OK) {
    Tk_DestroyWindow(squarePtr->tkwin);
    return TCL_ERROR;
  }
  interp->result = Tk_PathName(tkwin);
  return TCL_OK;
}
