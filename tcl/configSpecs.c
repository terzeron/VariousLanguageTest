#include <tk.h>
#include "Square.h"

static Tk_ConfigSpec configSpecs[] = {
  {TK_CONFIG_BORDER, "-background", "background", "Background", "#cdb79e", Tk_Offset(Square, bgBorder), TK_CONFIG_COLOR_ONLY, (Tk_CustomOption *) NULL},
  {TK_CONFIG_BORDER, "-background", "background", "Background", "white", Tk_Offset(Square, bgBorder), TK_CONFIG_MONO_ONLY, (Tk_CustomOption *) NULL},
  {TK_CONFIG_SYNONYM, "-bd", "borderWidth", (char *) NULL, (char *) NULL, 0, 0, (Tk_CustomOption *) NULL},
  {TK_CONFIG_SYNONYM, "-bg", "background", (char *) NULL, (char *) NULL, 0, 0, (Tk_CustomOption *) NULL},
  {TK_CONFIG_PIXELS, "-borderwidth", "borderWidth", "BorderWidth", "1m", Tk_Offset(Square, borderWidth), 0, (Tk_CustomOption *) NULL},
  {TK_CONFIG_SYNONYM, "-fg", "foreground", (char *) NULL, (char *) NULL, 0, 0, (Tk_CustomOption *) NULL},
  {TK_CONFIG_BORDER, "-foreground", "foreground", "Foreground", "#b03060", Tk_Offset(Square, fgBorder), TK_CONFIG_COLOR_ONLY, (Tk_CustomOption *) NULL},
  {TK_CONFIG_BORDER, "-foreground", "foreground", "Foreground", "black", Tk_Offset(Square, fgBorder), TK_CONFIG_MONO_ONLY, (Tk_CustomOption *) NULL},
  {TK_CONFIG_RELIEF, "-relief", "relief", "Relief", "raised", Tk_Offset(Square, relief), 0, (Tk_CustomOption *) NULL},
  {TK_CONFIG_END, (char *) NULL, (char *) NULL, (char *) NULL, (char *) NULL, 0, 0, (Tk_CustomOption *) NULL}
};
