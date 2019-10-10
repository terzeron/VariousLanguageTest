#include <tk.h>

typedef struct {
  Tk_Window tkwin;
  Display *display;
  Tcl_Interp *interp;
  int x, y;
  int size;
  int borderWidth;
  Tk_3DBorder bgBorder;
  Tk_3DBorder fgBorder;
  int relief;
  GC gc;
  int updatePending;
} Square;

