/*
 * International Union of Pure and Applied Chemistry (IUPAC)
 * International Chemical Identifier (InChI)
 * Version 1
 * Software version 1.01
 * July 21, 2006
 * Developed at NIST
 */

#ifndef __0DSTEREO_H__
#define __0DSTEREO_H__


#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
extern "C" {
#endif
#endif


int Clear3D2Dstereo(inchi_Input *pInp);
int set_0D_stereo_parities( inchi_Input *pInp, int bPointedEdgeStereo );

#ifndef INCHI_ALL_CPP
#ifdef __cplusplus
}
#endif
#endif


#endif /* __0DSTEREO_H__ */
