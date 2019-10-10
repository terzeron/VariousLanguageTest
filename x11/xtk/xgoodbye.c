/* 
 * xgoodbye.c
 */

#include <stdio.h>
#include <Xm/Xm.h>
/* 
 * #include <Xm/Label.h>
 */
#include <Xm/PushB.h>

/* #include <X11/Intrinsic.h>
 * #include <X11/StringDefs.h>
 */
void Quit(Widget w, XtPointer client_data, XtPointer call_data)
{
  fprintf(stderr, "It was nice knowing you.\n");
  exit(0);
}

void main(int argc, char **argv) 
{
  XtAppContext app_context;
  Widget topLevel, goodbye;

  XtSetLanguageProc(NULL, (XtLanguageProc)NULL, NULL);
  topLevel = XtVaAppInitialize(&app_context,"XGoodbye", NULL, 0, &argc, argv, NULL, NULL);
  
  goodbye = XtVaCreateManagedWidget("goodbye", xmPushButtonWidgetClass, topLevel, NULL);
  XtAddCallback(goodbye, XmNactivateCallback, Quit, 0);
  
  XtRealizeWidget(topLevel);
  XtAppMainLoop(app_context);
}
			       


