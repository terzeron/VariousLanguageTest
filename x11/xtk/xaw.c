#include <X11/StringDefs.h>
#include <X11/Shell.h>

#include <X11/Xaw/List.h>
#include <X11/Xaw/Box.h>

int main ( int argc, char **argv )
{
  XtAppContext app_context;
  Widget topLevel, list, box;
  String *item;
  
  topLevel = XtVaAppInitialize( &app_context, "XMnt", NULL, 0, &argc, argv, NULL, NULL);
  box = XtVaCreateManagedWidget ("box", boxWidgetClass, topLevel, NULL);
  list = XtVaCreateManagedWidget("list", listWidgetClass, box, NULL);
  item = (String *) malloc (16 * (sizeof(String)));
  item[0] = "kidong";
  item[1] = "is";
  item[2] = "Mr. mangchi";
  
  XtVaSetValues (box, XtNheight, 200, NULL);
  XtVaSetValues (box, XtNwidth, 200, NULL);
  
  XtVaSetValues (list, XtNlist, item, NULL);
  XtVaSetValues (list, XtNnumberStrings, 3, NULL);
  XtVaSetValues (list, XtNdefaultColumns, 1, NULL);
  XtVaSetValues (list, XtNverticalList, True, NULL);
  
  XtRealizeWidget(topLevel);
  
  XtAppMainLoop(app_context);
  
  return 0;     /* Impossible to reach here */
  
}
