#include <Xm/Xm.h>
#include <Xm/Label.h>
#include <Xm/RepType.h>

#include <Xm/MainW.h>  /* Main window */
#include <Xm/RowColumn.h>  /* for MenuBar (actually a RowColumn) */
#include <Xm/Frame.h>  /* Frame (simulated custom widget) */
#include <Xm/PushB.h>  /* PushButton (for menu buttons) */
#include <Xm/CascadeB.h>  /* CascadeButton (for menubar labels) */
#include <Xm/MessageB.h>  /* MessageBox dialog (for help) */

Widget m_TopLevel, m_TextShell;

void create_window(Widget wid)
{

}

void create_textShell(Widget m_TextShell, char *str) 
{
    XmString st;

    st = XmStringCreateLocalized(str);
    m_TextShell = XtVaCreateManagedWidget(st, xmLabelWidgetClass, m_TopLevel, NULL);
}

int main(int argc, char *argv[])
{
      XtAppContext app;

    m_TopLevel = XtVaAppInitialize(&app, "XDWT", (XrmOptionDescList) NULL, 
				   0, (int*) &argc, argv, NULL, 
				   NULL, 0);
    create_window(m_TopLevel);
    
    m_TextShell = XtVaAppCreateShell(NULL, "XDWT-MESSAGE", 
				     topLevelShellWidgetClass, 
				     XtDisplay(m_TopLevel), 
				     XmNallowResize, True, NULL);   
    create_textShell(m_TextShell, "output message");
    
    XtRealizeWidget(m_TopLevel);
    XtRealizeWidget(m_TextShell);
    
    XtAppMainLoop(app);
    
    return 0;   /* ANSI C requires main to return int. */
}


