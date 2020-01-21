#ifndef _tclextension_h_
#define _tclextension_h_

	int matoproc(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);
	int listaprocesos(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);
	int processFG(ClientData clientData, Tcl_Interp *interp, int argc, CONST char *argv[]);

#endif