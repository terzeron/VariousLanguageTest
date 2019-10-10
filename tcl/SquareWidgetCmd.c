#include <tk.h>
#include "Square.h"

extern Tk_ConfigSpec configSpecs[];
extern void SquareDisplay(ClientData clientData);

static int SquareWidgetCmd(ClientData clientData, Tcl_Interp *interp, int argc, char *argv[])
{
  Square *squarePtr = (Square *) clientData;
  int result = TCL_OK;
  
  if (argc < 2) {
    Tcl_AppendResult(interp, "wrong # args: should be \"", argv[0], " option ?arg arg ...?\"", (char *) NULL);
    return TCL_ERROR;
  }

  Tk_Preserve((ClientData) squarePtr);
  if (strcmp(argv[1], "configure") == 0) {
    if (argc == 2) {
      result = Tk_ConfigureInfo(interp, squarePtr->tkwin, configSpecs, (char *) squarePtr, (char *) NULL, 0);
    } else if (argc == 3) {
      result = Tk_ConfigureInfo(interp, squarePtr->tkwin, configSpecs, (char *) squarePtr, argv[2], 0);
    } else {
      result = Squareconfigure(interp, squarePtr, argc-2, argv+2, TK_CONFIG_ARGV_ONLY);
    }
  } else if (strcmp(argv[1], "position") == 0) {
    if ((argc != 2) && (argc != 4)) {
      Tcl_AppendResult(interp, "wrong # args: should be \"", argv[0], " position ?x y?\"", (char *) NULL);
      goto error;
    }
    if (argc == 4) {
      if ((Tk_GetPixels(interp, squarePtr->tkwin, argv[2], &squarePtr->x) != TCL_OK) || (Tk_GetPixels(interp, squarePtr->tkwin, argv[3], &squarePtr->y) != TCL_OK)) {
	goto error;
      }
      KeepInWindow(squarePtr);
    }
    sprintf(interp->result, "%d %d", squarePtr->x, squarePtr->y);
  } else if (strcmp(argv[1], "size") == 0) {
    if ((argc != 2) && (argc != 3)) {
      Tcl_AppendResult(interp, "wrong # args: should be \"", argv[0], " size ?amount?\"", (char *) NULL);
      goto error;
    }
    if (argc == 3) {
      int i;
      if (Tk_GetPixels(interp, squarePtr->tkwin, argv[2], &i) != TCL_OK) {
	goto error;
      }
      if ((i <= 0) || (i > 100)) {
	Tcl_AppendResult(interp, "bad size \"", argv[2], "\"", (char *) NULL);
	goto error;
      }
      squarePtr->size = i;
      KeepInWindow(squarePtr);
    }
    sprintf(interp->result, "%d", squarePtr->size);
  } else {
    Tcl_AppendResult(interp, "bad option \"", argv[1], "\": must be configure, position, or size", (char *) NULL);
    goto error;
  }
  if (!squarePtr->updatePending) {
    Tk_DoWhenIdle(SquareDisplay, (ClientData) squarePtr);
    squarePtr->updatePending = 1;
  }
  Tk_Release((ClientData) squarePtr);
  return result;

error:
  Tk_Release((ClientData)  squarePtr);
  return TCL_ERROR;
}

    
