#include <tk.h>

extern int SquareCmd(ClientData clientData, Tcl_Interp *interp, int argc, char *argv[]);

int Square_Init(Tcl_Interp *interp) 
{ 
  Tcl_CreateCommand(interp, "square", SquareCmd, (ClientData) Tk_MainWindow(interp), (Tcl_CmdDeleteProc *) NULL);
  return TCL_OK;
}

