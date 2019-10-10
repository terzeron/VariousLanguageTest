#include <tk.h>
#include "Square.h"

extern void SquareDisplay(ClientData clientData);
extern Tk_ConfigSpec configSpecs[];

static int SquareConfigure(Tcl_Interp *interp, Square *squarePtr, int argc, char *argv[], int flags) 
{
  if (Tk_ConfigureWidget(interp, squarePtr->tkwin, configSpecs, argc, argv, (char *) squarePtr, flags) != TCL_OK) {
    return TCL_ERROR;
  }
  Tk_SetWindowBackground(squarePtr->tkwin, Tk_3DBorderColor(squarePtr->bgBorder)->pixel);
  if (squarePtr->gc == None) {
    XGCValues gcValues;
    gcValues.function = GXcopy;
    gcValues.graphics_exposures = False;
    squarePtr->gc = Tk_GetGC(squarePtr->tkwin, GCFunction|GCGraphicsExposures, &gcValues);
  }
  Tk_GeometryRequest(squarePtr->tkwin, 200, 150);
  Tk_SetInternalBorder(squarePtr->tkwin, squarePtr->borderWidth);
  if (!squarePtr->updatePending) {
    Tk_DoWhenIdle((Tk_IdleProc *) SquareDisplay, (ClientData) squarePtr);
    squarePtr->updatePending = 1;
  }
  return TCL_OK;
}
