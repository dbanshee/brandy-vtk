/*
 * International Union of Pure and Applied Chemistry (IUPAC)
 * International Chemical Identifier (InChI)
 * Version 1
 * Software version 1.01
 * July 21, 2006
 * Developed at NIST
 */

#ifndef __ICHI_PARMS_H__
#define __ICHI_PARMS_H__



#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
extern "C" {
#endif
#endif


int e_ReadCommandLineParms( int argc, const char *argv[], INPUT_PARMS *ip, char *szSdfDataValue,
                          unsigned long *ulDisplTime, int bReleaseVersion, INCHI_FILE *log_file );

int e_PrintInputParms( INCHI_FILE *log_file, INPUT_PARMS *ip );
int e_OpenFiles( FILE **inp_file, FILE **output_file, FILE **log_file, FILE **prb_file, INPUT_PARMS *ip );
void e_HelpCommandLineParms( INCHI_FILE *f );







#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
}
#endif
#endif

#endif /* __ICHI_PARMS_H__ */
