/*
 * xbox1.c - simple button box
 */

/*
 * So that we can use frpintf;
 */

#include <stdio.h>
/* 
 * Standard Motif include file:
 */
#include <Xm/Xm.h>
/* 
 * Public include files for widgets used in this file.
 */
#include <Xm/RowColumn.h>
#include <Xm/PushB.h>

/* 
 * quit button callback function
 */
/* ARGUSED */
void Quit(Widget w, XtPointer client_data, XtPointer call_data)
{
  exit(0);
}

/* 
 * "Press me!" button callback function
 */
void PressMe(Widget w, XtPointer client_data, XtPointer call_data)
{
  fprintf(stderr, "Thank you!\n");
}

void main(int argc, char **argv)
{
  XtAppContext app_context;
  Widget rowColumn, quit, pressme, topLevel;
  
  topLevel = XtVaAppInitialize(&app_context, "XRowColumn", NULL, 0, &argc, argv, NULL, NULL);
  rowColumn = XtVaCreateManagedWidget("rowColumn", xmRowColumnWidgetClass, topLevel, NULL);
  quit = XtVaCreateManagedWidget("quit", xmPushButtonWidgetClass, rowColumn, NULL);
  pressme = XtVaCreateManagedWidget("pressme", xmPushButtonWidgetClass, rowColumn, NULL);
  
  XtAddCallback(quit, XmNactivateCallback, Quit, 0);
  XtAddCallback(pressme, XmNactivateCallback, PressMe, 0);
  XtRealizeWidget(topLevel);
  XtAppMainLoop(app_context);
}
       



