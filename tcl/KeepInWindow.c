#include <tk.h>
#include "Square.h"

static void KeepInWindow(Square *squarePtr)
{
  int gap, bd;
  bd = 0;

  if (squarePtr->relief != TK_RELIEF_FLAT) {
    bd = squarePtr->borderWidth;
  }
  gap = (Tk_Width(squarePtr->tkwin) - bd) - (squarePtr->x + squarePtr->size);
  if (gap < 0) {
    squarePtr->x += gap;
  }
  gap = (Tk_Height(squarePtr->tkwin) - bd) - (squarePtr->y + squarePtr->size);
  if (gap < 0) {
    squarePtr->y += gap;
  }
  if (squarePtr->x < bd) {
    squarePtr->x = bd;
  }
  if (squarePtr->y < bd) {
    squarePtr->y = bd;
  }
}  

    
