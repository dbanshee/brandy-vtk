/*
 * International Union of Pure and Applied Chemistry (IUPAC)
 * International Chemical Identifier (InChI)
 * Version 1
 * Software version 1.01
 * July 21, 2006
 * Developed at NIST
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>

#include "e_mode.h"
#include "inchi_api.h"
#include "e_ctl_data.h"
#include "e_ichi_io.h"
#include "e_ichi_parms.h"
#include "e_util.h"
#include "e_ichicomp.h"

#define DetectInputINChIFileType e_DetectInputINChIFileType
#define ReadCommandLineParms     e_ReadCommandLineParms
#define mystrncpy                e_mystrncpy
#define my_fprintf               e_my_fprintf
#define LtrimRtrim               e_LtrimRtrim
#define PrintInputParms          e_PrintInputParms
#define OpenFiles                e_OpenFiles
#define PrintFileName            e_PrintFileName
#define HelpCommandLineParms     e_HelpCommandLineParms
#define inchi_print_nodisplay    fprintf

#include "../INCHI_DLL/ichiparm.h"

