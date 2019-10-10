/*
 * xhello.c
 */

#include <Xm/Xm.h>
#include <Xm/Label.h>

/*
 * #include <X11/Intrinsic.h>
 * #include <X11/StringDefs.h>
 */

void main(int argc, char **argv) 
{
  XtAppContext app_context;
  Widget topLevel, hello;
  
  char text[] = "ÇÑ±Û";
  XmString str;
  
  XtSetLanguageProc(NULL, (XtLanguageProc)NULL, NULL);
  str = XmStringCreateLocalized(text);
  topLevel = XtVaAppInitialize(&app_context, "XHello", NULL, 0, &argc, argv, NULL, NULL);
  
  
  hello = XtVaCreateManagedWidget(str, xmLabelWidgetClass, topLevel, NULL);
  
  XtRealizeWidget(topLevel);
  XtAppMainLoop(app_context);
}
