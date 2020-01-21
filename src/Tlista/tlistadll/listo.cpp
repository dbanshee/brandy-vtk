/******************************************************************************************************

	Libreria Dinamica DLL para interpretes TCL/TK

		Incorpora 2 nuevos comandos a TCL
			
			  listaproc : muestra un listado <pid> <nombreProceso> , de los procesos del sistema
			  matoproc <pid> : termina el proceso pid

    Desarrollado para BrandyMol 1.0

		Funciones de Interaccion con el core de Windows, cortesia de MSDN

  Autores : 
				OSCAR NOEL AMAYA GARCIA
				GREGORIO TORRES GARCIA
				FRANCISCO NAJERA ALBENDIN

********************************************************************************************************/

#include <windows.h>
#include <tcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "modulo.h"
#include "common.h"
#include "tclextension.h"



//#include "common.h"

 #ifndef DECLSPEC_EXPORT
 #define DECLSPEC_EXPORT __declspec(dllexport)
 #endif // DECLSPEC_EXPORT
/*
static int
 Hello_Cmd(ClientData cdata, Tcl_Interp *interp, int objc,  Tcl_Obj * CONST objv[])
 {
     Tcl_SetObjResult(interp, Tcl_NewStringObj("Hello, World!", -1));
     return TCL_OK;
 }
*/
//int matoproc(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);

 BOOL APIENTRY
 DllMain(HANDLE hModule, DWORD dwReason, LPVOID lpReserved)
 {
     return TRUE;
 }

 EXTERN_C int DECLSPEC_EXPORT
 Tlistadll_Init(Tcl_Interp* interp)
 {
 #ifdef USE_TCL_STUBS
     Tcl_InitStubs(interp, "8.4", 0);
 #endif
     Tcl_Obj *version = Tcl_SetVar2Ex(interp, "Tlistadll_version", NULL,
                                      Tcl_NewDoubleObj(0.1), TCL_LEAVE_ERR_MSG);
     if (version == NULL)
         return TCL_ERROR;
     int r = Tcl_PkgProvide(interp, "Tlistadll", Tcl_GetString(version));
	//int i = func();
     // Call Tcl_CreateObjCommand etc.
     Tcl_CreateObjCommand(interp, "hello", Hello_Cmd, NULL, NULL);
	//Tcl_CreateCommand(interp, "matoproc", matoproc, NULL, NULL);
	 Tcl_CreateCommand(interp, "matoproc", matoproc, NULL, NULL);
	 Tcl_CreateCommand(interp, "listaprocesos", listaprocesos, NULL, NULL);
	 Tcl_CreateCommand(interp, "processFG", processFG, NULL, NULL);
     return r;
 }

 EXTERN_C int DECLSPEC_EXPORT
Tlistadll_SafeInit(Tcl_Interp* interp)
 {
     // We don't need to be specially safe so...
     return Tlistadll_Init(interp);
 }

 

