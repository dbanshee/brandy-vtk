
/******************************************************************************\
*       This is a part of the Microsoft Source Code Samples. 
*       Copyright (C) 1994-1998 Microsoft Corporation.
*       All rights reserved. 
*       This source code is only intended as a supplement to 
*       Microsoft Development Tools and/or WinHelp documentation.
*       See these sources for detailed information regarding the 
*       Microsoft samples programs.
\******************************************************************************/

/*++

Module Name:

    kill.c

Abstract:

    This module implements a task killer application.

--*/
#include <tcl.h>
#include "common.h"


#define MAX_TASKS           256

BOOL        ForceKill;
DWORD       pid;
CHAR        pname[MAX_PATH];
TASK_LIST   tlist[MAX_TASKS];


VOID GetCommandLineArgs(VOID);
VOID Usage(VOID);



int matoproc(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[])
{
    DWORD             i;
    DWORD             numTasks;
    TASK_LIST_ENUM    te;
    int               rval = 0;
    char              tname[PROCESS_SIZE];
    LPSTR             p;
    DWORD             ThisPid;
    OSVERSIONINFO     verInfo = {0};
    LPGetTaskList     GetTaskList;
    LPEnableDebugPriv EnableDebugPriv;

//    GetCommandLineArgs();


  if (argc > 2) {
      Tcl_SetObjResult(interp, Tcl_NewStringObj("Parametros Incorrectos", -1));
      return TCL_ERROR;
   }

   pid = atoi(argv[1]);
   ForceKill = TRUE;
 //Tcl_SetObjResult(interp, Tcl_NewStringObj(argv[1], -1));


 //Tcl_SetObjResult(interp, Tcl_NewIntObj(3));

//return 1;

/*
	//
	//	Determino si me mandan el numero correcto de parametros
	//
   if (argc > 2) {
      interp->result = "Faltan parametros";
      return TCL_ERROR;
   }

//    GetCommandLineArgs();
//
//	Miro si el valor enviado es correcto (es un entero)
//	si no lo es devuelvo error
//	en caso contrario lo acumulo en rango

   if (argc == 2) {
      if (Tcl_GetInt(interp, argv[1], &rango) != TCL_OK) {
         return TCL_ERROR;
      }
    }
    pid = rango;
    ForceKill = TRUE;

	*/


    //
    // Determine what system we're on and do the right thing
    //
    verInfo.dwOSVersionInfoSize = sizeof (verInfo);
    GetVersionEx(&verInfo);

    switch (verInfo.dwPlatformId)
    {
    case VER_PLATFORM_WIN32_NT:
       GetTaskList     = GetTaskListNT;
       EnableDebugPriv = EnableDebugPrivNT;
       break;

    case VER_PLATFORM_WIN32_WINDOWS:
       GetTaskList = GetTaskList95;
       EnableDebugPriv = EnableDebugPriv95;
       break;

    default:
       printf ("tlist requires Windows NT or Windows 95\n");
	   Tcl_SetObjResult(interp, Tcl_NewIntObj(-1));
       return 1;
    }


    //
    // Obtain the ability to manipulate other processes
    //
    EnableDebugPriv();

    if (pid) {
        tlist[0].dwProcessId = pid;
        if (KillProcess( tlist, TRUE )) {
            printf( "process #%d killed\n", pid );
			Tcl_SetObjResult(interp, Tcl_NewIntObj(1));
            return 0;
        } else {
            printf( "process #%d could not be killed\n", pid );
			Tcl_SetObjResult(interp, Tcl_NewIntObj(-1));
            return 1;
        }
    }

    //
    // get the task list for the system
    //
    numTasks = GetTaskList( tlist, MAX_TASKS );

    //
    // enumerate all windows and try to get the window
    // titles for each task
    //
    te.tlist = tlist;
    te.numtasks = numTasks;
    GetWindowTitles( &te );

    ThisPid = GetCurrentProcessId();

    for (i=0; i<numTasks; i++) {
        //
        // this prevents the user from killing KILL.EXE and
        // it's parent cmd window too
        //
        if (ThisPid == tlist[i].dwProcessId) {
            continue;
        }
        if (MatchPattern( (unsigned char *)tlist[i].WindowTitle, (unsigned char *)"*KILL*" )) {
            continue;
        }

        tname[0] = 0;
        strcpy( tname, tlist[i].ProcessName );
        p = strchr( tname, '.' );
        if (p) {
            p[0] = '\0';
        }
        if (MatchPattern( (unsigned char *)tname, (unsigned char *)pname )) {
            tlist[i].flags = TRUE;
        } else if (MatchPattern( (unsigned char *)tlist[i].ProcessName, (unsigned char *)pname )) {
            tlist[i].flags = TRUE;
        } else if (MatchPattern( (unsigned char *)tlist[i].WindowTitle, (unsigned char *)pname )) {
            tlist[i].flags = TRUE;
        }
    }

    for (i=0; i<numTasks; i++) {
        if (tlist[i].flags) {
            if (KillProcess( &tlist[i], ForceKill )) {
                printf( "process #%d [%s] killed\n", tlist[i].dwProcessId, tlist[i].ProcessName );
            } else {
                printf( "process #%d [%s] could not be killed\n", tlist[i].dwProcessId, tlist[i].ProcessName );
                rval = 1;
            }
        }
    }
	Tcl_SetObjResult(interp, Tcl_NewIntObj(rval));
    return rval;
}




DWORD numTasks;

VOID Usage(VOID);


int listaprocesos(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[])
/*++

Routine Description:

    Main entrypoint for the TLIST application.  This app prints
    a task list to stdout.  The task list include the process id,
    task name, ant the window title.

Arguments:

    argc             - argument count
    argv             - array of pointers to arguments

Return Value:

    0                - success

--*/

{
    DWORD             i;
    TASK_LIST_ENUM    te;
    BOOL              fTree;
    OSVERSIONINFO     verInfo = {0};
    LPGetTaskList     GetTaskList;
    LPEnableDebugPriv EnableDebugPriv;

	//creo un objeto string para acumular la salida del proceso
	Tcl_DString	      resultadoTotal;
    char infoProceso[1024];
	strcpy(infoProceso,"woweirowe");

	//Tcl_Obj *resultado;


    if (argc > 1 && (argv[1][0] == '-' || argv[1][0] == '/') && argv[1][1] == '?') {
        Usage();
    }

    //
    // Determine what system we're on and do the right thing
    //

    verInfo.dwOSVersionInfoSize = sizeof (verInfo);
    GetVersionEx(&verInfo);

    switch (verInfo.dwPlatformId)
    {
    case VER_PLATFORM_WIN32_NT:
       GetTaskList     = GetTaskListNT;
       EnableDebugPriv = EnableDebugPrivNT;
       break;

    case VER_PLATFORM_WIN32_WINDOWS:
       GetTaskList = GetTaskList95;
       EnableDebugPriv = EnableDebugPriv95;
       break;

    default:
       printf ("tlist requires Windows NT or Windows 95\n");
       return 1;
    }



    fTree = FALSE;

    //
    // Obtain the ability to manipulate other processes
    //
    EnableDebugPriv();

    //
    // get the task list for the system
    //
    numTasks = GetTaskList( tlist, MAX_TASKS );

    //
    // enumerate all windows and try to get the window
    // titles for each task
    //
    te.tlist = tlist;
    te.numtasks = numTasks;
    GetWindowTitles( &te );

    //
    // print the task list
    //
    for (i=0; i<numTasks; i++) {
		//PrintTask( i );

    }


	Tcl_DStringInit(&resultadoTotal);
    for (i=0; i<numTasks; i++) {
        sprintf(infoProceso, "{%i %s} ", tlist[i].dwProcessId, tlist[i].ProcessName);
		Tcl_DStringAppend(&resultadoTotal, infoProceso, -1);
		itoa(tlist[i].dwProcessId,infoProceso,10);
    }
	 Tcl_DStringResult(interp, &resultadoTotal);
    //
    // end of program
    //
    return 0;
}

VOID
Usage(
    VOID
   )

{
    fprintf( stderr, "Microsoft (R) Windows NT (TM) Version 3.5 TLIST\n" );
    fprintf( stderr, "Copyright (C) 1994-1995 Microsoft Corp. All rights reserved\n\n" );
    fprintf( stderr, "usage: TLIST\n" );
    ExitProcess(0);
}



int processFG(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[])
/*++

Routine Description:

    Main entrypoint for the TLIST application.  This app prints
    a task list to stdout.  The task list include the process id,
    task name, ant the window title.

Arguments:

    argc             - argument count
    argv             - array of pointers to arguments

Return Value:

    0                - success

--*/

{
    DWORD             i;
    TASK_LIST_ENUM    te;
    BOOL              fTree;
    OSVERSIONINFO     verInfo = {0};
    LPGetTaskList     GetTaskList;
    LPEnableDebugPriv EnableDebugPriv;

	//creo un objeto string para acumular la salida del proceso
	//Tcl_DString	      resultadoTotal;
    char infoProceso[1024];
	strcpy(infoProceso,"woweirowe");

	//Tcl_Obj *resultado;


    if (argc > 1 && (argv[1][0] == '-' || argv[1][0] == '/') && argv[1][1] == '?') {
        Usage();
    }
	int pid = atoi(argv[1]);
	//int opcion = atoi(argv[2]);
	/*
	if (argc > 2) {
      Tcl_SetObjResult(interp, Tcl_NewStringObj("Parametros Incorrectos", -1));
      return TCL_ERROR;
    }*/


    //
    // Determine what system we're on and do the right thing
    //

    verInfo.dwOSVersionInfoSize = sizeof (verInfo);
    GetVersionEx(&verInfo);

    switch (verInfo.dwPlatformId)
    {
    case VER_PLATFORM_WIN32_NT:
       GetTaskList     = GetTaskListNT;
       EnableDebugPriv = EnableDebugPrivNT;
       break;

    case VER_PLATFORM_WIN32_WINDOWS:
       GetTaskList = GetTaskList95;
       EnableDebugPriv = EnableDebugPriv95;
       break;

    default:
       printf ("tlist requires Windows NT or Windows 95\n");
       return 1;
    }



    fTree = FALSE;

    //
    // Obtain the ability to manipulate other processes
    //
    EnableDebugPriv();

    //
    // get the task list for the system
    //
    numTasks = GetTaskList( tlist, MAX_TASKS );

    //
    // enumerate all windows and try to get the window
    // titles for each task
    //
    te.tlist = tlist;
    te.numtasks = numTasks;
    GetWindowTitles( &te );

    //
    // print the task list
    //
    for (i=0; i<numTasks; i++) {
		//PrintTask( i );

    }


	//Tcl_DStringInit(&resultadoTotal);
    //for (i=0; i<numTasks; i++) {
      //  if(pid == (int)tlist[i].dwProcessId){
			HWND hWnd2 = FindWindow(NULL, "*Sin*");
			SetWindowText(hWnd2, "M4573R M0U53");
			//ShowWindow(hWnd2,opcion);	
			//ShowWindow((struct HWND__ *)tlist[i].hwnd,opcion);	
			
				
		//}
	
		//sprintf(infoProceso, "{%i %s} ", tlist[i].dwProcessId, tlist[i].ProcessName);
		//Tcl_DStringAppend(&resultadoTotal, infoProceso, -1);
		//itoa(tlist[i].dwProcessId,infoProceso,10);
    //}
	//Tcl_DStringResult(interp, &resultadoTotal);
    //
    // end of program
    //
    return 0;
	
}