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
#include <limits.h>
#include <errno.h>
#include <stdarg.h>

#include "e_mode.h"
#include "ichitime.h"
#include "inchi_api.h"
#include "e_ctl_data.h"

#include "e_comdef.h"
#include "e_ichicomp.h"
#include "e_util.h"
#include "e_ichi_io.h"
#include "e_ichi_parms.h"


#define LtrimRtrim e_LtrimRtrim

/**********************************************
 * output " L=V" or " L missing" or ""
 * The fprintf format string must contain %s%s%s%s
 */
char e_gsMissing[] = "is missing";
char e_gsEmpty[]   = "";
char e_gsSpace[]   = " ";
char e_gsEqual[]   = "=";


/********* from inchimain.c *****************************************/
int e_inchi_print( FILE* f, const char* lpszFormat, ... )
{
    int ret=0, ret2=0;
    /* char *p=NULL; */

    va_list argList;

    if ( f ) {
        my_va_start( argList, lpszFormat );
        ret = vfprintf( f, lpszFormat, argList );
        va_end( argList );
    } else {
        /* printf( "\r" ); */
        my_va_start( argList, lpszFormat );
        ret2 = vfprintf( stdout, lpszFormat, argList );
        /* ret2 = vprintf( lpszFormat, argList ); */
        va_end( argList );
    }

#ifdef INCHI_LIB
    if( FWPRINT )
    {
        my_va_start( argList, lpszFormat );
        FWPRINT( lpszFormat, argList );
        va_end( argList );
    }
#endif
    return ret? ret : ret2;
}

/*****************************************************************/
int e_my_fprintf( FILE* f, const char* lpszFormat, ... )
{
    int ret=0, ret2=0;
    va_list argList;

#ifndef INCHI_LIB
    if ( f ) {
        if ( f == stderr && lpszFormat && lpszFormat[0] && '\r' == lpszFormat[strlen(lpszFormat)-1] ) {
#define CONSOLE_LINE_LEN 80
#ifndef INCHI_ANSI_ONLY
            char szLine[CONSOLE_LINE_LEN];
            my_va_start( argList, lpszFormat );
            ret = _vsnprintf( szLine, CONSOLE_LINE_LEN-1, lpszFormat, argList );
            va_end( argList );
            if ( ret < 0 ) {
                /*  output is longer than the console line */
                strcpy(szLine+CONSOLE_LINE_LEN-4, "...\r");
            }
            fputs( szLine, f );
#else
            my_va_start( argList, lpszFormat );
            ret = vfprintf( f, lpszFormat, argList );
            va_end( argList );
#endif
#undef CONSOLE_LINE_LEN
        } else {
            my_va_start( argList, lpszFormat );
            ret = vfprintf( f, lpszFormat, argList );
            va_end( argList );
        }
    }
    if ( f != stderr ) {
        my_va_start( argList, lpszFormat );
        ret2 = vfprintf( stderr, lpszFormat, argList );
        va_end( argList );
    }
#else
    if ( f ) {
        my_va_start( argList, lpszFormat );
        ret = vfprintf( f, lpszFormat, argList );
        va_end( argList );
    }
#endif

    return ret? ret : ret2;
}
/*******************************************************************/
void e_PrintFileName( const char *fmt, FILE *output_file, const char *szFname )
{
    fprintf( output_file, fmt, szFname );
}
/************** copied from util.c *********************************/
char *e_fgetsTab( char *szLine, int len, FILE *f );
/*******************************************************************/
/* read up to len or tab or LF; if empty read next until finds non-empty line   */
/* remove leading and trailing white spaces; keep zero termination */
/*******************************************************************/
char *e_fgetsTab( char *szLine, int len, FILE *f )
{
    int  length=0, c=0;
    if ( --len < 0 ) {
        return NULL;
    }
    while ( length < len && EOF != (c = fgetc( f )) ) {
        if ( c == '\t' )
            c = '\n';
        szLine[length++] = (char)c;
        if ( c == '\n' )
            break;
    }
    if ( !length && EOF == c ) {
        return NULL;
    }
    szLine[length] = '\0';
    return szLine;
}
/*******************************************************************/
/* read up to len or tab or LF; if empty read next until finds non-empty line   */
/* remove leading and trailing white spaces; keep zero termination */
/*******************************************************************/
int e_my_fgetsTab( char *szLine, int len, FILE *f, int *bTooLongLine )
{
    int  length;
    char *p;
    do {
        p = e_fgetsTab( szLine, len-1, f );
        if ( !p ) {
            *bTooLongLine = 0;
            return -1; /* end of file or cannot read */
        }
        szLine[len-1] = '\0';
        /*
        *bTooLongLine = !strchr( szLine, '\n' );
        */
        p = strchr( szLine, '\n' );
        *bTooLongLine = ( !p && ((int)strlen(szLine)) == len-2 );
        LtrimRtrim( szLine, &length );
    } while ( !length );
    return length;
}
/*******************************************************************/
int e_my_fgetsTab1( char *szLine, int len, FILE *f, int *bTooLongLine )
{
    int  length;
    char *p;
    /*do {*/
        p = e_fgetsTab( szLine, len-1, f );
        if ( !p ) {
            *bTooLongLine = 0;
            return -1; /* end of file or cannot read */
        }
        szLine[len-1] = '\0';
        /*
        *bTooLongLine = !strchr( szLine, '\n' );
        */
        p = strchr( szLine, '\n' );
        *bTooLongLine = ( !p && ((int)strlen(szLine)) == len-2 );
        LtrimRtrim( szLine, &length );
    /*} while ( !length );*/
    return length;
}
/******************************************************************/
/* read not more than line_len bytes from an lf-terminated line   */
/* if input line is too long quietly ignore the rest of the line  */
char* fgets_up_to_lf( char* line, int line_len, FILE* inp )
{
    char *p, *q;
    memset( line, 0, line_len );
    if ( NULL != (p = fgets( line, line_len, inp ) ) && NULL == strchr(p, '\n' ) ){
        char temp[64]; /* bypass up to '\n' or up to end of file whichever comes first*/
        while ( NULL != fgets( temp, sizeof(temp), inp ) && NULL == strchr(temp,'\n') )
            ;
    }
    if ( p && (q = strchr(line, '\r')) ) { /*  fix CR CR LF line terminator. */
        q[0] = '\n';
        q[1] = '\0';
    }    
    return p;
}
#if ( FIX_READ_LONG_LINE_BUG == 1 )
/********************************************************************/
int my_fgetsUpToLfOrTab( char *szLine, int len, FILE *f )
{
    int  length;
    char *p;
    char szSkip[256];
    int  bTooLongLine = 0;
    do {
        p = e_fgetsTab( szLine, len, f );
        if ( !p ) {
            return -1; /* end of file or cannot read */
        }
        bTooLongLine = ( (int)strlen(szLine) == len-1 && szLine[len-2] != '\n' );
        LtrimRtrim( szLine, &length );
    } while ( !length );
    if ( bTooLongLine ) {
        while ( p = e_fgetsTab( szSkip, sizeof(szSkip)-1, f ) ) {
            if ( strchr( szSkip, '\n' ) )
                break;
        }
    }
    return length;
}
#else
/********************************************************************/
int my_fgetsUpToLfOrTab( char *szLine, int len, FILE *f )
{
    int  length, cur_len;
    char *p;
    char szSkip[256];
    int  bTooLongLine = 0;
    do {
        p = e_fgetsTab( szLine, len-1, f );
        if ( !p ) {
            return -1; /* end of file or cannot read */
        }
        szLine[len-1] = '\0';
        /*
        bTooLongLine = !strchr( szLine, '\n' );
        */
        bTooLongLine = ( !p && (cur_len=(int)strlen(szLine)) == len-2 );
        LtrimRtrim( szLine, &length );
    } while ( !length );
    if ( bTooLongLine ) {
        while ( p = e_fgetsTab( szSkip, sizeof(szSkip)-1, f ) ) {
            szSkip[sizeof(szSkip)-1] = '\0';
            if ( strchr( szSkip, '\n' ) )
                break;
        }
    }
    return length;
}
#endif

#ifdef INCHI_ANSI_ONLY

static clock_t InchiClock(void);

#ifdef INCHI_USETIMES
static clock_t InchiClock(void)
{
    struct tms buf;
    clock_t c = times( &buf );
    if ( c != (clock_t)-1 ) {
        return buf.tms_utime;
    }
    return 0;
}
#else
static clock_t InchiClock(void)
{
    clock_t c = clock();
    if ( c != (clock_t)-1 ) {
        return c;
    }
    return 0;
}
#endif

#define INCHI_MSEC(X)    (long)((1000.0/(double)CLOCKS_PER_SEC)*(X))
#define INCHI_CLOCK_T(X) (clock_t)( (double)(X) / 1000.0 * (double)CLOCKS_PER_SEC )
const clock_t FullMaxClock = (clock_t)(-1);
const clock_t HalfMaxClock = (clock_t)(-1) / 2;
clock_t MaxPositiveClock = 0;
clock_t MinNegativeClock = 0;
clock_t HalfMaxPositiveClock = 0;
clock_t HalfMinNegativeClock = 0;

static void FillMaxMinClock(void); /* keep compiler happy */

static void FillMaxMinClock(void)
{ /* assume clock_t is a signed integral value */
    if ( !MaxPositiveClock ) {
        clock_t valPos=0, val1 = 1;
        while ( 0 < ((val1 <<= 1), (val1 |= 1)) ) {
            valPos = val1;
        }
        MaxPositiveClock =  valPos;
        MinNegativeClock = -valPos;
        HalfMaxPositiveClock = MaxPositiveClock / 2;
        HalfMinNegativeClock = MinNegativeClock / 2;
    }
}


/******** get current process time ****************************************/
void InchiTimeGet( inchiTime *TickEnd )
{
    TickEnd->clockTime = InchiClock();
}
/******** returns difference TickEnd - TickStart in milliseconds **********/
long InchiTimeMsecDiff( inchiTime *TickEnd, inchiTime *TickStart )
{
    if ( FullMaxClock > 0 ) {
        clock_t delta;
        if ( !TickEnd || !TickStart )
            return 0;
        /* clock_t is unsigned */
        if ( TickEnd->clockTime > TickStart->clockTime ) {
            if ( TickEnd->clockTime > HalfMaxClock &&
                 TickEnd->clockTime - TickStart->clockTime > HalfMaxClock ) {
                /* overflow in TickStart->clockTime, actually TickStart->clockTime was later */
                delta = (FullMaxClock - TickEnd->clockTime) + TickStart->clockTime;
                return -INCHI_MSEC(delta);
            }
            delta = TickEnd->clockTime - TickStart->clockTime;
            return INCHI_MSEC(delta);
        } else
        if ( TickEnd->clockTime < TickStart->clockTime ) {
            if ( TickStart->clockTime > HalfMaxClock &&
                 TickStart->clockTime - TickEnd->clockTime > HalfMaxClock ) {
                /* overflow in TickEnd->clockTime, actually TickEnd->clockTime was later */
                delta = (FullMaxClock - TickStart->clockTime) + TickEnd->clockTime;
                return INCHI_MSEC(delta);
            }
            delta = TickStart->clockTime - TickEnd->clockTime;
            return -INCHI_MSEC(delta);
        }
        return 0; /* TickEnd->clockTime == TickStart->clockTime */
    } else {
        /* may happen under Win32 only where clock_t is SIGNED long */
        clock_t delta;
        FillMaxMinClock( );
        if ( !TickEnd || !TickStart )
            return 0;
        if ( TickEnd->clockTime >= 0 && TickStart->clockTime >= 0 ||
             TickEnd->clockTime <= 0 && TickStart->clockTime <= 0) {
            delta = TickEnd->clockTime - TickStart->clockTime;
        } else
        if ( TickEnd->clockTime >= HalfMaxPositiveClock &&
             TickStart->clockTime <= HalfMinNegativeClock ) {
            /* end is earlier than start */
            delta = (MaxPositiveClock - TickEnd->clockTime) + (TickStart->clockTime - MinNegativeClock);
            delta = -delta;
        } else
        if ( TickEnd->clockTime <= HalfMinNegativeClock &&
             TickStart->clockTime >= HalfMaxPositiveClock ) {
            /* start was earlier than end */
            delta = (MaxPositiveClock - TickStart->clockTime) + (TickEnd->clockTime - MinNegativeClock);
        } else {
            /* there was no overflow, clock passed zero */
            delta = TickEnd->clockTime - TickStart->clockTime;
        }
        return INCHI_MSEC(delta);
    }
}
/******************* get elapsed time from TickStart ************************/
long InchiTimeElapsed( inchiTime *TickStart )
{
    inchiTime TickEnd;
    if ( !TickStart )
        return 0;
    InchiTimeGet( &TickEnd );
    return InchiTimeMsecDiff( &TickEnd, TickStart );
}
/******************* add number of milliseconds to time *********************/
void InchiTimeAddMsec( inchiTime *TickEnd, unsigned long nNumMsec )
{
    clock_t delta;
    if ( !TickEnd )
        return;
    if ( FullMaxClock > 0 ) {
        /* clock_t is unsigned */
        delta = INCHI_CLOCK_T(nNumMsec);
        TickEnd->clockTime += delta;
    } else {
        /* may happen under Win32 only where clock_t is SIGNED long */
        /* clock_t is unsigned */
        FillMaxMinClock( );
        delta = INCHI_CLOCK_T(nNumMsec);
        TickEnd->clockTime += delta;
    }
}
/******************* check whether time has expired *********************/
int bInchiTimeIsOver( inchiTime *TickStart )
{
    if ( FullMaxClock > 0 ) {
        clock_t clockCurrTime;
        if ( !TickStart )
            return 0;
        clockCurrTime = InchiClock();
        /* clock_t is unsigned */
        if ( TickStart->clockTime > clockCurrTime ) {
            if ( TickStart->clockTime > HalfMaxClock &&
                 TickStart->clockTime - clockCurrTime > HalfMaxClock ) {
                /* overflow in clockCurrTime, actually clockCurrTime was later */
                return 1;
            }
            return 0;
        } else
        if ( TickStart->clockTime < clockCurrTime ) {
            if ( clockCurrTime > HalfMaxClock &&
                 clockCurrTime - TickStart->clockTime > HalfMaxClock ) {
                /* overflow in TickStart->clockTime, actually TickStart->clockTime was later */
                return 0;
            }
            return 1;
        }
        return 0; /* TickStart->clockTime == clockCurrTime */
    } else {
        /* may happen under Win32 only where clock_t is SIGNED long */
        clock_t clockCurrTime;
        FillMaxMinClock( );
        if ( !TickStart )
            return 0;
        clockCurrTime = InchiClock();
        if ( clockCurrTime >= 0 && TickStart->clockTime >= 0 ||
             clockCurrTime <= 0 && TickStart->clockTime <= 0) {
            return (clockCurrTime > TickStart->clockTime);
        } else
        if ( clockCurrTime >= HalfMaxPositiveClock &&
             TickStart->clockTime <= HalfMinNegativeClock ) {
            /* curr is earlier than start */
            return 0;
        } else
        if ( clockCurrTime <= HalfMinNegativeClock &&
             TickStart->clockTime >= HalfMaxPositiveClock ) {
            /* start was earlier than curr */
            return 1;
        } else {
            /* there was no overflow, clock passed zero */
            return (clockCurrTime > TickStart->clockTime);
        }
    }
}

#else

/******** get current process time ****************************************/
void InchiTimeGet( inchiTime *TickEnd )
{
    if ( TickEnd ) {
        struct _timeb timeb;
        _ftime( &timeb );
        TickEnd->clockTime = (unsigned long)timeb.time;
        TickEnd->millitime = (long)timeb.millitm;
    }
}
/******** returns difference TickEnd - TickStart in milliseconds **********/
long InchiTimeMsecDiff( inchiTime *TickEnd, inchiTime *TickStart )
{
    long delta;
    if ( !TickEnd || !TickStart ) {
        return 0;
    }
    if ( TickEnd->clockTime >= TickStart->clockTime ) {
        delta = (long)(TickEnd->clockTime - TickStart->clockTime);
        delta *= 1000;
        delta += TickEnd->millitime - TickStart->millitime;
    } else {
        delta = -(long)(TickStart->clockTime - TickEnd->clockTime);
        delta *= 1000;
        delta += TickEnd->millitime - TickStart->millitime;
    }
    return delta;
}
/******************* get elapsed time from TickStart ************************/
long InchiTimeElapsed( inchiTime *TickStart )
{
    inchiTime TickEnd;
    if ( !TickStart )
        return 0;
    InchiTimeGet( &TickEnd );
    return InchiTimeMsecDiff( &TickEnd, TickStart );
}
/******************* add number of milliseconds to time *********************/
void InchiTimeAddMsec( inchiTime *TickEnd, unsigned long nNumMsec )
{
    long delta;
    if ( !TickEnd )
        return;
    TickEnd->clockTime += nNumMsec / 1000;
    delta = nNumMsec % 1000 + TickEnd->millitime;
    TickEnd->clockTime += delta / 1000;
    TickEnd->millitime = delta % 1000;
}
/******************* check whether time has expired *********************/
int bInchiTimeIsOver( inchiTime *TickEnd )
{
    struct _timeb timeb;
    if ( !TickEnd )
        return 0;
    _ftime( &timeb );
    if ( TickEnd->clockTime > (unsigned long)timeb.time )
        return 0;
    if ( TickEnd->clockTime < (unsigned long)timeb.time ||
         TickEnd->millitime < (long)timeb.millitm ) {
        return 1;
    }
    return 0;
}
#endif
