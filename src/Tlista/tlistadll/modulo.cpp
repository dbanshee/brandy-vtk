#include "modulo.h"
#include <windows.h>
#include <tcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//#include "common.h"

 #ifndef DECLSPEC_EXPORT
 #define DECLSPEC_EXPORT __declspec(dllexport)
 #endif // DECLSPEC_EXPORT
int
 Hello_Cmd(ClientData cdata, Tcl_Interp *interp, int objc,  Tcl_Obj * CONST objv[])
 {
     Tcl_SetObjResult(interp, Tcl_NewStringObj("Hello, World!", -1));
     return TCL_OK;
 }