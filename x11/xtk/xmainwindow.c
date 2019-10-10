/*
 * xmainwindow.c - main window with help and quit
 *
 */

/* Standard Motif include files: */
#include <Xm/Xm.h>
#include <Xm/RepType.h>

#include <stdio.h>
#include <signal.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <wait.h>

/* 
 * Public header files for widgets used in this file.
 */
#include <Xm/MainW.h>  /* Main window */
#include <Xm/RowColumn.h>  /* for MenuBar (actually a RowColumn) */
#include <Xm/Frame.h>  /* Frame (simulated custom widget) */
#include <Xm/PushB.h>  /* PushButton (for menu buttons) */
#include <Xm/CascadeB.h>  /* CascadeButton (for menubar labels) */
#include <Xm/MessageB.h>  /* MessageBox dialog (for help) */
/* callback functions defined here */

void 
catch_func (int signum)
{
  write (2, &signum, sizeof (int));
  printf ("%d\n", signum);
  fflush (stdout);
}


void
reapchild (int signum)
{
  pid_t pid;
  int status;

  while ((pid = waitpid (-1, &status, WNOHANG)) > 0)
    ;
  return;
}


/* quit button callback function */
/*ARGSUSED*/
void Quit(Widget w, XtPointer client_data, XtPointer call_data)
{
  exit(0);
}

/* callback to pop up help dialog widget (or any other dialog) */
/*ARGSUSED*/
void ShowHelp(Widget w, XtPointer client_data, XtPointer call_data)
{
  Widget dialog = (Widget) client_data;
  XtManageChild(dialog);
}


int main(int argc, char **argv)
{
  XtAppContext app_context;
  Widget topLevel, mainWindow, menuBar, frame;
  Widget fileButton, fileMenu, quit, help, helpButton, helpMenu, helpBox;
  Widget temp;
  pid_t pid;
  int i;

  signal (SIGCHLD, reapchild);

  pid = fork ();
  if (pid > 0) 
    {
      // parent
    }
  else if (pid == 0) 
    {
      // child
      if (execl ("/home/terzeron/a.out", "a.out", NULL) < 0)
	{
	  fprintf (stderr, "can't execute new program, %d: %s\n",
		   errno, strerror (errno));
	  exit (-1);
	}
    }
  else
    {
      // errro
    }
  
  XtSetLanguageProc(NULL, (XtLanguageProc)NULL, NULL);
  
  topLevel = XtVaAppInitialize(&app_context, "XMainWindow", NULL, 0, &argc, argv, NULL, NULL);
  
  /* create main window */
  mainWindow = XtVaCreateManagedWidget("mainwindow", xmMainWindowWidgetClass, topLevel, NULL);
  
  /* register converter for setting tearoff menus from resource files */
  XmRepTypeInstallTearOffModelConverter();
  
  /* create menubar along top inside of main window */
  menuBar = XmCreateMenuBar(mainWindow, "menubar", NULL, 0);
  XtManageChild(menuBar);
  
  frame = XtVaCreateManagedWidget("frame", xmFrameWidgetClass, mainWindow, NULL);
  
  /* Set MainWindow areas */
  XmMainWindowSetAreas(mainWindow, menuBar, NULL, NULL, NULL, frame);
  
  
  /* create file menu and children */
  
  /* create the file button in the menubar */
  fileButton = XtVaCreateManagedWidget("fileButton", xmCascadeButtonWidgetClass, menuBar, NULL);
  /* create menu (really a Shell widget and RowColumn widget combo) */
  fileMenu = XmCreatePulldownMenu(menuBar, "filemenu", NULL, 0);
  
  /* Notice that fileMenu is intentionally NOT managed here */
  
  /* create button in menu that exits application */
  quit = XtVaCreateManagedWidget("quit", xmPushButtonWidgetClass, fileMenu, NULL);
  
  /* specify which menu the fileButton will pop up */
  XtVaSetValues(fileButton, XmNsubMenuId, fileMenu, NULL);
  /* arrange for quit button to call function that exits. */
  XtAddCallback(quit, XmNactivateCallback, Quit, 0);
  
  
  /* create help button and box */
  
  /* create button that will bring up help popup */
  helpButton = XtVaCreateManagedWidget("helpButton", xmCascadeButtonWidgetClass, menuBar, NULL);
  /* tell menuBar which is the Help button (will be specially positioned) */
  XtVaSetValues(menuBar, XmNmenuHelpWidget, helpButton, NULL);
  /* create menu (really a Shell widget with a RowColumn child)*/
  helpMenu = XmCreatePulldownMenu(menuBar, "helpMenu", NULL, 0);
  /* create help button in the menu */

  help = XtVaCreateManagedWidget("helpMenu", xmPushButtonWidgetClass, helpMenu, NULL);

  /* specify which menu helpButton will pop up */
  XtVaSetValues(helpButton, XmNsubMenuId, helpMenu, NULL);
  /* create popup that will contain help */
  helpBox = XmCreateMessageDialog(help, "helpBox", NULL, 0);
  
  temp = XmMessageBoxGetChild(helpBox, XmDIALOG_CANCEL_BUTTON);
  XtUnmanageChild(temp);
  temp = XmMessageBoxGetChild(helpBox, XmDIALOG_HELP_BUTTON);
  XtUnmanageChild(temp);
  
  /* arrange for help button to pop up helpBox */
  XtAddCallback(help, XmNactivateCallback, ShowHelp, helpBox);

  XtRealizeWidget(topLevel);
  XtAppMainLoop(app_context);
}







