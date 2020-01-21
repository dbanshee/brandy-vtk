/*
 * International Union of Pure and Applied Chemistry (IUPAC)
 * International Chemical Identifier (InChI)
 * Version 1
 * Software version 1.01
 * July 21, 2006
 * Developed at NIST
 */

#ifndef __READSTRU_H__
#define __READSTRU_H__


#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
extern "C" {
#endif
#endif



int e_ReadStructure( STRUCT_DATA *sd, INPUT_PARMS *ip, FILE *inp_file, FILE *log_file, FILE *output_file, FILE *prb_file,
                   inchi_Input *pInp, long num_inp,  /* for CML:*/ int inp_index, int *out_index );


#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
}
#endif
#endif


#endif /* __READSTRU_H__ */
