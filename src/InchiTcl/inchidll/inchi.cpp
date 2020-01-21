/******************************************************************************************************

	Libreria Dinamica DLL para interpretes TCL/TK
		
		  Incorpora un nuevo comando a TCL

			infoinchi <fichero mol> : devuelve una cadena vacia si hay algun problema, de lo contrario
							devolvera una lista de dos componentes, la primera con la informacion INCHI
							y la segunda con la informacion auxiliar.

    Desarrollado para BrandyMol 1.0

		Esta libreria ha sido creada modificando libinchi.dll(ichiparm.h), para evitar q genere los ficheros
		de info, log y error, y el ejecutable InChI_MAIN.exe convirtiendolo en una funcion ofertada
		a TCL.

			Los ficheros creados para esta libreria son los originales de inchi y:
				- inchi.cpp
				- tclextension.h
				- tclextension.h


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
#include "tclextension.h"

 #ifndef DECLSPEC_EXPORT
 #define DECLSPEC_EXPORT __declspec(dllexport)
 #endif // DECLSPEC_EXPORT


static int
 Hello_Cmd(ClientData cdata, Tcl_Interp *interp, int objc,  Tcl_Obj * CONST objv[])
 {
     Tcl_SetObjResult(interp, Tcl_NewStringObj("Hello, World!", -1));
     return TCL_OK;
 }


//int matoproc(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);

 BOOL APIENTRY
 DllMain(HANDLE hModule, DWORD dwReason, LPVOID lpReserved)
 {
     return TRUE;
 }

 EXTERN_C int DECLSPEC_EXPORT
 Inchidll_Init(Tcl_Interp* interp)
 {
 #ifdef USE_TCL_STUBS
     Tcl_InitStubs(interp, "8.4", 0);
 #endif
     Tcl_Obj *version = Tcl_SetVar2Ex(interp, "Inchidll_version", NULL,
                                      Tcl_NewDoubleObj(0.1), TCL_LEAVE_ERR_MSG);
     if (version == NULL)
         return TCL_ERROR;
     int r = Tcl_PkgProvide(interp, "Inchidll", Tcl_GetString(version));
	//int i = func();
    //Call Tcl_CreateObjCommand etc.
    //Tcl_CreateObjCommand(interp, "hello", Hello_Cmd, NULL, NULL);
	//Tcl_CreateCommand(interp, "matoproc", matoproc, NULL, NULL);
	//Tcl_CreateCommand(interp, "matoproc", matoproc, NULL, NULL);
	//Tcl_CreateCommand(interp, "listaprocesos", listaprocesos, NULL, NULL);
	  Tcl_CreateCommand(interp, "infoinchi", infoinchi, NULL, NULL);
     return r;
 }

 EXTERN_C int DECLSPEC_EXPORT
Inchidll_SafeInit(Tcl_Interp* interp)
 {
     // We don't need to be specially safe so...
     return Inchidll_Init(interp);
 }
