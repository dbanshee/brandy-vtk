/*
 * International Union of Pure and Applied Chemistry (IUPAC)
 * International Chemical Identifier (InChI)
 * Version 1
 * Software version 1.01
 * July 21, 2006
 * Developed at NIST
 */

/* input/output format */
#ifndef __INPDEF_H__
#define __INPDEF_H__


/* BILLY 8/6/04 */
#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
extern "C" {
#endif
#endif

int e_MolfileToInchi_Input( FILE *inp_molfile, inchi_Input *orig_at_data, int bMergeAllInputStructures,
                       int bDoNotAddH, int bAllowEmptyStructure,
                       const char *pSdfLabel, char *pSdfValue, long *lSdfId,
                       long *lMolfileNumber, INCHI_MODE *pInpAtomFlags, int *err, char *pStrErr );
int e_INChIToInchi_Input( FILE *inp_molfile, inchi_Input *orig_at_data, int bMergeAllInputStructures,
                       int bDoNotAddH, INPUT_TYPE nInputType,
                       char *pSdfLabel, char *pSdfValue, long *lSdfId, INCHI_MODE *pInpAtomFlags,
                       int *err, char *pStrErr );

int e_CopyMOLfile(FILE *inp_file, long fPtrStart, long fPtrEnd, FILE *prb_file, long nNumb);


/* BILLY 8/6/04 */
#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
}
#endif
#endif

#endif  /* __INPDEF_H__ */
