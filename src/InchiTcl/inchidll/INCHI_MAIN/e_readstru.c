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
#include <stdarg.h>
#include <errno.h>
#include <limits.h>
#include <float.h>

#include "e_mode.h"
#include "ichitime.h"
#include "inchi_api.h"
#include "e_ctl_data.h"
#include "e_readstru.h"
#include "e_ichi_io.h"
#include "e_util.h"
#include "e_ichierr.h"
#include "e_inpdef.h"

int e_TreatReadTheStructureErrors(  STRUCT_DATA *sd, INPUT_PARMS *ip,
                                  FILE *inp_file, FILE *log_file, FILE *output_file, FILE *prb_file,
                                  inchi_Input *pInp, long *num_inp );
int e_GetInpStructErrorType( INPUT_PARMS *ip, int err, char *pStrErrStruct, int num_inp_atoms );

/*********************************************************************************************************/
int e_ReadStructure( STRUCT_DATA *sd, INPUT_PARMS *ip,
                     FILE *inp_file, FILE *log_file, FILE *output_file, FILE *prb_file,
                     inchi_Input *pInp, long num_inp,  /* for CML:*/ int inp_index, int *out_index )
{
    inchiTime     ulTStart;
    int           nRet = 0, nRet2 = 0;
#if( ADD_CMLPP == 1 )
    int           bGetOrigCoord = 0;
#endif
    INCHI_MODE    InpAtomFlags = 0;

    memset( sd, 0, sizeof(*sd) );
    switch ( ip->nInputType ) {
    case INPUT_MOLFILE:
    case INPUT_SDFILE:
        if ( pInp ) {
            if ( ip->pSdfValue && ip->pSdfValue[0] ) {
                /* Added 07-29-2003 to avoid inheriting exact value from prev. structure
                   and to make reference to a (bad) structure with unknown ID Value */
                char *p, *q;  /* q shadows prev declaration of const char *q */
                int  n;
                if ( (p = strrchr( ip->pSdfValue, '+' )) &&
                     '[' == *(p-1) && 0 < (n=strtol(p+1,&q,10)) && q[0] && ']'==q[0] && !q[1] ) {
                    sprintf( p+1, "%d]", n+1 );
                } else {
                    strcat( ip->pSdfValue, " [+1]" );
                }
            }
            e_InchiTimeGet( &ulTStart );
            sd->fPtrStart = (inp_file == stdin || prb_file == NULL)? -1 : ftell( inp_file );
            /*  read the original structure */
            nRet2 = e_MolfileToInchi_Input( inp_file, pInp, ip->bMergeAllInputStructures,
                               ip->bDoNotAddH, ip->bAllowEmptyStructure,
                               ip->pSdfLabel, ip->pSdfValue, &ip->lSdfId, &ip->lMolfileNumber,
                               &InpAtomFlags, &sd->nStructReadError, sd->pStrErrStruct );

            sd->bChiralFlag |= InpAtomFlags;
            if ( !ip->bGetSdfileId || ip->lSdfId == 999999) ip->lSdfId = 0;
            if ( !ip->bGetMolfileNumber || ip->lMolfileNumber < 0 ) ip->lMolfileNumber = 0;
            sd->fPtrEnd = (inp_file == stdin || prb_file == NULL)? -1 : ftell( inp_file );
            sd->ulStructTime += e_InchiTimeElapsed( &ulTStart );
        } else {
            /*  read the next original structure */
            int nStructReadError=0;
            if ( !ip->bMergeAllInputStructures ) {
                nRet2 = e_MolfileToInchi_Input( inp_file, NULL, 0, 0, 0,
                                       NULL, NULL, NULL, NULL, NULL, &nStructReadError, NULL );
                if ( nRet2 <= 0 && 10 < nStructReadError && nStructReadError < 20 ) {
                    return _IS_EOF;
                }
            } else {
                return _IS_EOF;
            }
        }
        break;
    case INPUT_INCHI_XML:
    case INPUT_INCHI_PLAIN:
        if ( pInp ) {
            if ( ip->pSdfValue && ip->pSdfValue[0] ) {
                /* Added 07-29-2003 to avoid inheriting exact value from prev. structure
                   and to make reference to a (bad) structure with unknown ID Value */
                char *p, *q;
                int  n;
                if ( (p = strrchr( ip->pSdfValue, '+' )) &&
                     '[' == *(p-1) && 0 < (n=strtol(p+1,&q,10)) && q[0] && ']'==q[0] && !q[1] ) {
                    sprintf( p+1, "%d]", n+1 );
                } else {
                    strcat( ip->pSdfValue, " [+1]" );
                }
            }
            e_InchiTimeGet( &ulTStart );
            sd->fPtrStart = (inp_file == stdin)? -1 : ftell( inp_file );
            /*  read the original structure */
            nRet2 = e_INChIToInchi_Input( inp_file, pInp, ip->bMergeAllInputStructures, ip->bDoNotAddH,
                               ip->nInputType, ip->pSdfLabel, ip->pSdfValue, &ip->lMolfileNumber,
                               &InpAtomFlags, &sd->nStructReadError, sd->pStrErrStruct );
            /*if ( !ip->bGetSdfileId || ip->lSdfId == 999999) ip->lSdfId = 0;*/
            sd->bChiralFlag |= InpAtomFlags;
            sd->fPtrEnd = (inp_file == stdin)? -1 : ftell( inp_file );
            sd->ulStructTime += e_InchiTimeElapsed( &ulTStart );
        } else {
            /*  read the next original structure */
            int           nStructReadError=0;
            if ( !ip->bMergeAllInputStructures ) {
                nRet2 = e_INChIToInchi_Input( inp_file, NULL, 0, 0,
                                    ip->nInputType, NULL, NULL, NULL, NULL, &nStructReadError, NULL );
                if ( nRet2 <= 0 && 10 < nStructReadError && nStructReadError < 20 ) {
                    return _IS_EOF;
                }
            } else {
                return _IS_EOF;
            }
        }
        break;

#if( ADD_CMLPP == 1 )
    /* BILLY 8/6/04 */
    case INPUT_CMLFILE:
        if ( pInp ) {

            e_InchiTimeGet( &ulTStart );
            /*
            if ( inp_index >= 0 ) {
                sd->fPtrStart = inp_index;
            } else {
                sd->fPtrStart = GetCmlStructIndex();
            }
            */
            sd->fPtrStart = -1; /* disable "e_CopyMOLfile() for CML input files */
            sd->fPtrEnd = -1;
            /*  read the original structure */
            nRet = CmlfileToOrigAtom( inp_file, pInp, ip->bMergeAllInputStructures,
                               bGetOrigCoord, ip->bDoNotAddH, inp_index, out_index,
                               ip->pSdfLabel, ip->pSdfValue, &ip->lSdfId,
                               &sd->nStructReadError, sd->pStrErrStruct );


            sd->ulStructTime += e_InchiTimeElapsed( &ulTStart );
#if( bRELEASE_VERSION == 0 )
            sd->bExtract |= pInp->bExtract;
#endif
        } else {
            /*  read the next original structure */
            int nStructReadError=0;
            if ( !ip->bMergeAllInputStructures ) {
                nRet2 = CmlfileToOrigAtom( inp_file, NULL, 0, 0, 0, inp_index, out_index,
                                       NULL, NULL, NULL, &nStructReadError, NULL );

                if ( nRet2 <= 0 && 10 < nStructReadError && nStructReadError < 20 ) {
                    return _IS_EOF;
                }
            } else {
                return _IS_EOF;
            }
        }
        break;
#endif

    default:
        nRet = _IS_FATAL; /*  wrong file type */
    }
    nRet2 = e_TreatReadTheStructureErrors( sd, ip, inp_file, log_file, output_file, prb_file,
                                         pInp, &num_inp );
    if ( (!nRet || nRet == _IS_WARNING) && nRet2 )
        nRet = nRet2;

    return nRet;
}
/*****************************************************************************************************/
int e_TreatReadTheStructureErrors(  STRUCT_DATA *sd, INPUT_PARMS *ip,
                                  FILE *inp_file, FILE *log_file, FILE *output_file, FILE *prb_file,
                                  inchi_Input *pInp, long *num_inp )
{
    int nRet = _IS_OKAY;
    /*  End of file */
    if ( 10 < sd->nStructReadError && sd->nStructReadError < 20 ) {
        nRet = _IS_EOF;
        goto exit_function; /*  end of file */
    }
    /*  Skipping the structures */
    if ( *num_inp < ip->first_struct_number ) {
        if ( log_file != stderr ) {
            e_my_fprintf( stderr, "\rSkipping structure #%ld.%s%s%s%s...\r", *num_inp, SDF_LBL_VAL(ip->pSdfLabel,ip->pSdfValue));
        }
        nRet = sd->nErrorType = _IS_SKIP;
        goto exit_function;
    }

    sd->nErrorType = e_GetInpStructErrorType( ip, sd->nStructReadError, sd->pStrErrStruct, pInp->num_atoms );

    /*  Fatal error */
    if ( sd->nErrorType == _IS_FATAL ) {
        e_my_fprintf( log_file, "Fatal Error %d (aborted; %s) inp structure #%ld.%s%s%s%s\n",
                    sd->nStructReadError, sd->pStrErrStruct, *num_inp, SDF_LBL_VAL(ip->pSdfLabel,ip->pSdfValue) );
#if( bRELEASE_VERSION == 1 || EXTR_FLAGS == 0 )
        if ( prb_file && 0L <= sd->fPtrStart && sd->fPtrStart < sd->fPtrEnd && !ip->bSaveAllGoodStructsAsProblem ) {
            e_CopyMOLfile(inp_file, sd->fPtrStart, sd->fPtrEnd, prb_file, *num_inp);
        }
#endif
        /* goto exit_function; */
    }
    /*  Non-fatal errors: do not produce INChI */
    if ( sd->nErrorType == _IS_ERROR ) {  /*  70 => too many atoms */
        e_my_fprintf( log_file, "Error %d (no INChI; %s) inp structure #%ld.%s%s%s%s\n",
                    sd->nStructReadError, sd->pStrErrStruct, *num_inp, SDF_LBL_VAL(ip->pSdfLabel,ip->pSdfValue) );
#if( bRELEASE_VERSION == 1 || EXTR_FLAGS == 0 )
        if ( prb_file && 0L <= sd->fPtrStart && sd->fPtrStart < sd->fPtrEnd && !ip->bSaveAllGoodStructsAsProblem) {
            e_CopyMOLfile(inp_file, sd->fPtrStart, sd->fPtrEnd, prb_file, *num_inp);
        }
#endif
    }
    /*  Warnings: try to produce INChI */
    if ( sd->nErrorType == _IS_WARNING ) {
        e_my_fprintf( log_file, "Warning: (%s) inp structure #%ld.%s%s%s%s\n",
                    sd->pStrErrStruct, *num_inp, SDF_LBL_VAL(ip->pSdfLabel,ip->pSdfValue) );
    }
exit_function:
    if ( nRet <= _IS_OKAY && sd->nErrorType > 0 ) {
        nRet = sd->nErrorType;
    }
    return nRet;
}
/**********************************************************************************************/
int e_GetInpStructErrorType( INPUT_PARMS *ip, int err, char *pStrErrStruct, int num_inp_atoms )
{
    if ( err && err == 9 )
        return _IS_ERROR; /*  sdfile bypassed to $$$$ */
    if ( err && err < 30 )
        return _IS_FATAL;
    if ( num_inp_atoms <= 0 || err ) {
        if ( 98 == err && 0 == num_inp_atoms && ip->bAllowEmptyStructure )
            return _IS_OKAY /* _IS_WARNING*/; /* the warning will be issued by the dll */
        return _IS_ERROR;
    }
    if ( pStrErrStruct[0] )
        return _IS_WARNING;
    return _IS_OKAY;
}
