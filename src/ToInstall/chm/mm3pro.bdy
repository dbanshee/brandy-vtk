#######################################
##        BrandyMol 2 MM3PRO         ##
##     G. Torres and F. Najera       ##
##        Copyright 2006             ##
#######################################

# forcefield: MM3-PROTEIN

# J.-H. Lii and N. L. Allinger, "The MM3 Force Field for Amides, Polypeptides and Proteins", J. Comput. Chem., 12, 186-199 (1991)
# All parameters in this file are from the "MM3 PARAMETERS (2000)", as provided by Prof. N. L. Allinger, University of Georgia


#############################
##                         ##
##  Atom Type Definitions  ##
##                         ##
#############################

#atom      1    C     "Alkane (Csp3)"           6     12.000     4
#atom      2    C     "Amide"                   6     12.000     3
#atom      3    C     "Carboxyl"                6     12.000     3
#atom      4    C     "Phenyl"                  6     12.000     3
#atom      5    C+    "Guanidinium"             6     12.000     3
#atom      6    C     "Alkene (His/Trp C=C)"    6     12.000     3
#atom      7    C     "Imidazolium (N-C-N)"     6     12.000     3
#atom      8    N     "Amide"                   7     14.003     3
#atom      9    N+    "Ammonium"                7     14.003     4
#atom     10    N     "Guanidinium"             7     14.003     3
#atom     11    N     "Pyrrole"                 7     14.003     3
#atom     12    N     "Imidazolium"             7     14.003     3
#atom     13    O     "Amide"                   8     15.995     1
#atom     14    O-    "Carboxylate"             8     15.995     1
#atom     15    O     "Alcohol & Phenol"        8     15.995     2
#atom     16    S     "Sulfide"                16     31.972     2
#atom     17    H     "Hydrogen (C-H)"          1      1.008     1
#atom     18    H     "Amide"                   1      1.008     1
#atom     19    H     "Ammonium"                1      1.008     1
#atom     20    H     "Guanidinium"             1      1.008     1
#atom     21    H     "Pyrrole"                 1      1.008     1
#atom     22    H     "Imidazolium"             1      1.008     1
#atom     23    H     "Alcohol & Phenol"        1      1.008     1
#atom     24    H     "Thiol (S-H)"             1      1.008     1

#####################################################################
## General atom types:                                             ##
## ID =  Symbol(xx)Valence(x)Charge(x)Cycle(x)                     ##
## Valence = from 1 to 4                                           ##
## Charge = 0, 3 (+1), 2 (radical), 5 (-1)                         ##
## Cycle = from 3 to 6                                             ##
## Bonded atoms = ID sphere1-*(sphere2)-*(sphere3):IDsphere1'..... ##
#####################################################################

#	ID	BONDED ATOMS	TIPO	Simb	Natm	Patm	Val	Descrip
C_300		2		C	6	12.000	3	Amide
C_300	O_150-*-*	3		C	6	12.000	3	Carboxyl
C_305		6		C	6	12.000	3	Alkene(His/TrpC=C)
C_305	#2#:N_305-C_305-C_305	7		C	6	12.000	3	Imidazolium(N-C-N)
C_305	C_306-C_306-C_306	4		C	6	12.000	3	Csp2 quat trp
C_306		4		C	6	12.000	3	Phenyl
C_330		5		C+	6	12.000	3	Guanidinium
C_40?		1		C	6	12.000	4	Alkane(Csp3)
H_100		17		H	1	1.008	1	Hydrogen(C-H)
H_100	S_200-*-*	24		H	1	1.008	1	Thiol(S-H)
H_100	O_200-*-*	23		H	1	1.008	1	Alcohol&Phenol
H_100	N_430-*-*	19		H	1	1.008	1	Ammonium
H_100	N_300-C_330-*	20		H	1	1.008	1	Guanidinium
H_100	N_300-C_300-O_100	18		H	1	1.008	1	Amide
H_100	N_300-C_300-C_300	21		H	1	1.008	1	Pyrrol
H_100	N_305-C_305-N_305	22		H	1	1.008	1	Imidazolium
N_305		11		N	7	14.003	3	Pyrrole
N_305	C_305-N_305-*:C_305-C_305-*	12		N	7	14.003	2	Imidazolium
N_305	C_300-O_100-*	8		N	7	14.003	2	Amide Proline
N_30?		8		N	7	14.003	3	Amide
N_30?	C_330-*-*	10		N	7	14.003	3	Guanidinium
N_43?		9		N+	7	14.003	4	Ammonium
O_100		13		O	8	15.995	1	Amide
O_100	C_300-O_150-*	14		O-	8	15.995	1	Carboxylate (O=C)
O_150		14		O-	8	15.995	1	Carboxylate (O=C)
O_200		15		O	8	15.995	2	Alcohol&Phenol
S_200		16		S	6	31.972	2	Sulfide

