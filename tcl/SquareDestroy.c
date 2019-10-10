#include <tk.h>
#include "Square.h"

extern Tk_ConfigSpec configSpecs[];

static void SquareDestroy(ClientData clientData)
{
  Square *squarePtr = (Square *) clientData;
  Tk_FreeOptions(configSpecs, (char *) squarePtr, squarePtr->display, 0);
  if (squarePtr->gc != None) {
    Tk_FreeGC(squarePtr->display, squarePtr->gc);
  }
  free((char *) squarePtr);
}
