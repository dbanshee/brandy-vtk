/*
 * International Union of Pure and Applied Chemistry (IUPAC)
 * International Chemical Identifier (InChI)
 * Version 1
 * Software version 1.01
 * July 21, 2006
 * Developed at NIST
 */

#ifndef __ICHI_IO_H__
#define __ICHI_IO_H__


#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
extern "C" {
#endif
#endif


char* fgets_up_to_lf( char* line, int line_len, FILE* inp );
int my_fgetsUpToLfOrTab( char *szLine, int len, FILE *f );

int e_my_fgetsTab( char *szLine, int len, FILE *f, int *bTooLongLine );
int e_my_fgetsTab1( char *szLine, int len, FILE *f, int *bTooLongLine );

int e_inchi_print( FILE* f, const char* lpszFormat, ... );
int e_my_fprintf( FILE* f, const char* lpszFormat, ... );
void e_PrintFileName( const char *fmt, FILE *output_file, const char *szFname );
unsigned long e_ulMyGetTickCount( int bStart );
unsigned long e_ulMyTickCountDiff( unsigned long ulTickEnd, unsigned long ulTickStart );

#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
}
#endif
#endif


#endif /* __ICHI_IO_H__ */
