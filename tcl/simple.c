#include <stdio.h>
#include <stdlib.h>
#include <tcl.h>

int main(int argc, char *argv[])
{
  Tcl_Interp *interp;
  int code;
  
  if (argc != 2) {
    fprintf(stderr, "Wrong # arguments: ");
    fprintf(stderr, "sould be \"%s fileName\"\n", argv[0]);
    exit(0);
  }
    
  interp = Tcl_CreateInterp();
  code - Tcl_EvalFile(interp, argv[1]);
  if (*interp->result != 0) {
    printf("%s\n", interp->result);
  }
  if (code != TCL_OK) {
    exit(-1);
  }
  exit(0);
}



  
  
