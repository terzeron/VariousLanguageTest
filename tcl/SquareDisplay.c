#include <tk.h>
#include "Square.h"

static void SquareDisplay(ClientData clientData)
{
  Square *squarePtr = (Square *) clientData;
  Tk_Window tkwin = squarePtr->tkwin;
  Display *display = Tk_Display(tkwin);
  Pixmap pm;
  squarePtr->updatePending = 0;
  if (!Tk_IsMapped(tkwin)) {
    return;
  }
  pm = XCreatePixmap(display, Tk_WindowId(tkwin), Tk_Width(tkwin), Tk_Height(tkwin), Tk_Depth(tkwin));
  Tk_Fill3DRectangle(tkwin, pm, squarePtr->bgBorder, 0, 0, Tk_Width(tkwin), Tk_Height(tkwin), squarePtr->borderWidth, squarePtr->relief);
  Tk_Fill3DRectangle(tkwin, pm, squarePtr->fgBorder, squarePtr->x, squarePtr->y, squarePtr->size, squarePtr->size, squarePtr->borderWidth, squarePtr->relief);
  XCopyArea(display, pm, Tk_WindowId(tkwin), squarePtr->gc, 0, 0, Tk_Width(tkwin), Tk_Height(tkwin), 0, 0);
  XFreePixmap(Tk_Display(tkwin), pm);
}
