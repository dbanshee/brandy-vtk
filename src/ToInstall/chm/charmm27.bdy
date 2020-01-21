#######################################
##        BrandyMol 2 CHARMM27       ##
##     G. Torres and F. Najera       ##
##        Copyright 2006             ##
#######################################

#forcefield              CHARMM27

#A. D. MacKerrell, Jr., et al., "All-Atom Empirical Potential for
#Molecular Modeling and Dynamics Studies of Proteins", J. Phys. Chem. B,
#102, 3586-3616 (1998)

#N. Foloppe and A. D. MacKerell, Jr., "All-Atom Empirical Force Field
#for Nucleic Acids: I. Parameter Optimization Based on Small Molecule
#and Condensed Phase Macromolecular Target Data", J. Comput. Chem.,
#21, 86-104 (2000)

#Current parameter values are available from the CHARMM parameter site
#in Alex MacKerell's lab at UMBC, http://www.pharmacy.ab.umd.edu/~alex/

#############################
##                         ##
##  Atom Type Definitions  ##
##                         ##
#############################

######################################################
##                                                  ##
##  TINKER Atom Class Numbers to CHARMM Atom Names  ##
##                                                  ##
##     1  HA      11  CA      21  CY      31  NR3   ##
##     2  HP      12  CC      22  CPT     32  NY    ##
##     3  H       13  CT1     23  CT      33  NC2   ##
##     4  HB      14  CT2     24  NH1     34  O     ##
##     5  HC      15  CT3     25  NH2     35  OH1   ##
##     6  HR1     16  CP1     26  NH3     36  OC    ##
##     7  HR2     17  CP2     27  N       37  S     ##
##     8  HR3     18  CP3     28  NP      38  SM    ##
##     9  HS      19  CH1     29  NR1               ##
##    10  C       20  CH2     30  NR2               ##
##                                                  ##
######################################################


#atom      1     1    HA      "Nonpolar Hydrogen"         1      1.008     1
#atom      2     2    HP      "Aromatic Hydrogen"         1      1.008     1
#atom      3     3    H       "Peptide Amide HN"          1      1.008     1
#atom      4     4    HB      "Peptide HCA"               1      1.008     1
#atom      5     4    HB      "N-Terminal HCA"            1      1.008     1
#atom      6     5    HC      "N-Terminal Hydrogen"       1      1.008     1
#atom      7     5    HC      "N-Terminal PRO HN"         1      1.008     1
#atom      8     3    H       "Hydroxyl Hydrogen"         1      1.008     1
#atom      9     3    H       "TRP Indole HE1"            1      1.008     1
#atom     10     3    H       "HIS+ Ring NH"              1      1.008     1
#atom     11     3    H       "HISDE Ring NH"             1      1.008     1
#atom     12     6    HR1     "HIS+ HD2/HISDE HE1"        1      1.008     1
#atom     13     7    HR2     "HIS+ HE1"                  1      1.008     1
#atom     14     8    HR3     "HISD HD2"                  1      1.008     1
#atom     15     8    HR3     "HISE HD2"                  1      1.008     1
#atom     16     9    HS      "Thiol Hydrogen"            1      1.008     1
#atom     17     1    HA      "LYS HCE/ORN HCD"           1      1.008     1
#atom     18     5    HC      "ARG HE Hydrogen"           1      1.008     1
#atom     19     5    HC      "ARG HZ Hydrogen"           1      1.008     1
#atom     20    10    C       "Peptide Carbonyl"          6     12.011     3
#atom     21    11    CA      "Aromatic Carbon"           6     12.011     3
#atom     22    12    CC      "C-Term Carboxylate"        6     12.011     3
#atom     23    13    CT1     "Peptide Alpha Carbon"      6     12.011     4
#atom     24    13    CT1     "N-Term Alpha Carbon"       6     12.011     4
#atom     25    13    CT1     "Methine Carbon"            6     12.011     4
#atom     26    14    CT2     "Methylene Carbon"          6     12.011     4
#atom     27    15    CT3     "Methyl Carbon"             6     12.011     4
#atom     28    14    CT2     "GLY Alpha Carbon"          6     12.011     4
#atom     29    14    CT2     "N-Terminal GLY CA"         6     12.011     4
#atom     30    16    CP1     "PRO CA Carbon"             6     12.011     4
#atom     31    17    CP2     "PRO CB and CG"             6     12.011     4
#atom     32    18    CP3     "PRO CD Carbon"             6     12.011     4
#atom     33    16    CP1     "N-Terminal PRO CA"         6     12.011     4
#atom     34    18    CP3     "N-Terminal PRO CD"         6     12.011     4
#atom     35    14    CT2     "SER CB Carbon"             6     12.011     4
#atom     36    13    CT1     "THR CB Carbon"             6     12.011     4
#atom     37    14    CT2     "Cysteine CB Carbon"        6     12.011     4
#atom     38    14    CT2     "Cystine CB Carbon"         6     12.011     4
#atom     39    14    CT2     "HIS+ CB Carbon"            6     12.011     4
#atom     40    14    CT2     "HISD CB Carbon"            6     12.011     4
#atom     41    14    CT2     "HISE CB Carbon"            6     12.011     4
#atom     42    19    CH1     "HIS+ CG and CD2"           6     12.011     3
#atom     43    19    CH1     "HISD CG/HISE CD2"          6     12.011     3
#atom     44    19    CH1     "HISE CG/HISD CD2"          6     12.011     3
#atom     45    20    CH2     "HIS+ CE1 Carbon"           6     12.011     3
#atom     46    20    CH2     "HISDE CE1 Carbon"          6     12.011     3
#atom     47    11    CA      "PHE/TYR CG Carbon"         6     12.011     3
#atom     48    11    CA      "TYR CZ Carbon"             6     12.011     3
#atom     49    12    CC      "ASN/GLN Carbonyl"          6     12.011     3
#atom     50    21    CY      "TRP CG Carbon"             6     12.011     3
#atom     51    11    CA      "TRP CD1 Carbon"            6     12.011     3
#atom     52    22    CPT     "TRP CD2 Carbon"            6     12.011     3
#atom     53    22    CPT     "TRP CE2 Carbon"            6     12.011     3
#atom     54    14    CT2     "ASP CB/GLU CG"             6     12.011     4
#atom     55    12    CC      "ASP/GLU Carboxylate"       6     12.011     3
#atom     56    14    CT2     "MET CG Carbon"             6     12.011     4
#atom     57    15    CT3     "MET CE Carbon"             6     12.011     4
#atom     58    14    CT2     "LYS CE/ORN CD"             6     12.011     4
#atom     59    14    CT2     "ARG CD Carbon"             6     12.011     4
#atom     60    10    C       "ARG CZ Carbon"             6     12.011     3
#atom     61    15    CT3     "N-Methyl Amide CH3"        6     12.011     4
#atom     62    23    CT      "AIB Alpha Carbon"          6     12.011     4
#atom     63    24    NH1     "Peptide Nitrogen"          7     14.007     3
#atom     64    25    NH2     "Amide Nitrogen"            7     14.007     3
#atom     65    26    NH3     "Ammonium Nitrogen"         7     14.007     4
#atom     66    27    N       "PRO Nitrogen"              7     14.007     3
#atom     67    28    NP      "N-Terminal PRO N"          7     14.007     4
#atom     68    29    NR1     "HIS Ring NH"               7     14.007     3
#atom     69    30    NR2     "HIS Ring N"                7     14.007     2
#atom     70    31    NR3     "HIS+ Ring NH"              7     14.007     3
#atom     71    32    NY      "TRP Pyrrole NE1"           7     14.007     3
#atom     72    33    NC2     "ARG NE Nitrogen"           7     14.007     3
#atom     73    33    NC2     "ARG NZ Nitrogen"           7     14.007     3
#atom     74    34    O       "Peptide Oxygen"            8     15.999     1
#atom     75    34    O       "ASN/GLN Carbonyl"          8     15.999     1
#atom     76    35    OH1     "Hydroxyl Oxygen"           8     15.999     2
#atom     77    35    OH1     "Phenol Oxygen"             8     15.999     2
#atom     78    36    OC      "ASP/GLU Carboxylate"       8     15.999     1
#atom     79    36    OC      "C-Term Carboxylate"        8     15.999     1
#atom     80    37    S       "Thiol Sulfur"             16     32.060     2
#atom     81    37    S       "Sulfide Sulfur"           16     32.060     2
#atom     82    38    SM      "Disulfide Sulfur"         16     32.060     2

#S. E. Feller, D. Yin, R. W. Pastor and A. D. MacKerell, Jr., "Molecular
#Dynamics Simulation of Unsaturated Lipids at Low Hydration: Parametrization
#and Comparison with Diffraction Studies", Biophysical Journal, 73,
#2269-2279 (1997)  [alkenes]

#D. Beglov and B. Roux, Finite Representation of an Infinite Bulk System:
#Solvent Boundary Potential for Computer Simulations, Journal of Chemical
#Physics, 100, 9050-9063 (1994)  [sodium ion]

#R. H. Stote and M. Karplus, "Zinc Binding in Proteins and Solution - A
#Simple but Accurate Nonbonded Representation", Proteins, 23, 12-31 (1995)
#[zinc ion]


#############################
##                         ##
##  Atom Type Definitions  ##
##                         ##
#############################


######################################################
##                                                  ##
##  TINKER Atom Class Numbers to CHARMM Atom Names  ##
##                                                  ##
##    39  HT      46  CM      53  OS      60  MG    ##
##    40  HA1     47  CS      54  OM      61  CLA   ##
##    41  HA2     48  CE1     55  SS      62  K     ##
##    42  CD      49  CE2     56  FE      63  CAL   ##
##    43  CPA     50  NPH     57  HE      64  ZN    ##
##    44  CPB     51  OT      58  NE                ##
##    45  CPM     52  OB      59  SOD               ##
##                                                  ##
######################################################


#atom     83     1    HA      "Heme Meso Hydrogen"        1      1.008     1
#atom     84     1    HA      "Heme H2C= Hydrogen"        1      1.008     1
#atom     85     1    HA      "Heme RHC= Hydrogen"        1      1.008     1
#atom     86    39    HA1     "Alkene RHC= Hydrogen"      1      1.008     1
#atom     87    40    HA2     "Alkene H2C= Hydrogen"      1      1.008     1
#atom     88    41    HT      "TIP3P Hydrogen"            1      1.008     1
#atom     89     3    H       "COOH Hydrogen"             1      1.008     1
#atom     90    42    CD      "ASP+/GLU+ Carboxyl"        6     12.011     3
#atom     91    14    CT2     "ASP+ CB/GLU+ CG"           6     12.011     4
#atom     92    43    CPA     "Heme Alpha Carbon"         6     12.011     3
#atom     93    44    CPB     "Heme Beta Carbon"          6     12.011     3
#atom     94    45    CPM     "Heme Meso Carbon"          6     12.011     3
#atom     95    10    C       "Heme Alkene Carbon"        6     12.011     3
#atom     96    46    CM      "Heme CO Carbon"            6     12.011     1
#atom     97    47    CS      "Thiolate Carbon"           6     12.011     4
#atom     98    48    CE1     "Alkene RHC= Carbon"        6     12.011     3
#atom     99    49    CE2     "Alkene H2C= Carbon"        6     12.011     3
#atom    100    50    NPH     "Heme Pyrrole N"            7     14.007     3
#atom    101    51    OT      "TIP3P Water Oxygen"        8     15.999     2
#atom    102    35    OH1     "COOH Hydroxyl Oxygen"      8     15.999     2
#atom    103    52    OB      "COOH Carbonyl Oxygen"      8     15.999     1
#atom    104    53    OS      "Ester Oxygen"              8     15.999     2
#atom    105    54    OM      "Heme CO/O2 Oxygen"         8     15.999     1
#atom    106    55    SS      "Thiolate Sulfur"          16     32.060     1
#atom    107    56    FE      "Heme Group Iron"          26     55.847     6
#atom    108    57    HE      "Helium Atom"               2      4.003     0
#atom    109    58    NE      "Neon Atom"                10     20.183     0
#atom    110    59    SOD     "Sodium Ion"               11     22.990     0
#atom    111    60    MG      "Magnesium Ion"            12     24.305     0
#atom    112    61    CLA     "Chloride Ion"             17     35.453     0
#atom    113    62    POT     "Potassium Ion"            19     39.098     0
#atom    114    63    CAL     "Calcium Ion"              20     40.080     0
#atom    115    64    ZN      "Zinc Ion"                 30     65.370     0

#M. Schlenkrich, J. Brickmann, A. D. MacKerell, Jr. and M. Karplus,
#"Empirical Potential Energy Function for Phospholipids: Criteria for
#Parameter Optimization and Applications", in Biological Membranes: A
#Molecular Perspective from Computation and Experiment, K. M. Merz and
#B. Roux, Editors. Birkhauser, Boston, pages 31-81, 1996


#############################
##                         ##
##  Atom Type Definitions  ##
##                         ##
#############################


######################################################
##                                                  ##
##  TINKER Atom Class Numbers to CHARMM Atom Names  ##
##                                                  ##
##    66  HL      70  HEL1    74  CTL3    78  OSL   ##
##    67  HAL1    71  CL      75  CTL5    79  OBL   ##
##    68  HAL2    72  CTL1    76  CEL1    80  O2L   ##
##    69  HAL3    73  CTL2    77  NTL     81  PL    ##
##                                                  ##
######################################################


#atom    116    66    HL      ">CH-N+ Hydrogen"              1      1.008     1
#atom    117    67    HL1     "Methine Hydrogen"             1      1.008     1
#atom    118    68    HL2     "Methylene Hydrogen"           1      1.008     1
#atom    119    69    HL3     "Methyl Hydrogen"              1      1.008     1
#atom    120    70    HEL     "-CH=CR2 Hydrogen"             1      1.008     1
#atom    121    71    CL      "Ester Carbonyl"               6     12.011     3
#atom    122    72    CL1     "Ester RCOO-CH<"               6     12.011     4
#atom    123    73    CL2     "Ester RCOO-CH2-"              6     12.011     4
#atom    124    73    CL2     "Ester -CH2-COOR"              6     12.011     4
#atom    125    73    CL2     "Methylene Carbon"             6     12.011     4
#atom    126    74    CL3     "Methyl Carbon"                6     12.011     4
#atom    127    73    CL2     "Phosphate -CH2-PO4-"          6     12.011     4
#atom    128    73    CL2     "R4N+ Methylene"               6     12.011     4
#atom    129    75    CL5     "R4N+ Methyl"                  6     12.011     4
#atom    130    76    CEL     "-CH=CR2 Carbon"               6     12.011     3
#atom    131    77    NTL     "R4N+ Nitrogen"                7     14.007     4
#atom    132    78    OSL     "Ester -O-"                    8     15.999     2
#atom    133    79    OBL     "Ester Carbonyl"               8     15.999     1
#atom    134    78    OSL     "Phosphate -O-"                8     15.999     2
#atom    135    80    O2L     "Phosphate =O"                 8     15.999     1
#atom    136    81    PL      "Phosphate >P<"               15     30.974     4

#####################################################################
## General atom types:                                             ##
## ID =  Symbol(xx)Valence(x)Charge(x)Cycle(x)                     ##
## Valence = from 1 to 4                                           ##
## Charge = 0, 3 (+1), 2 (radical), 5 (-1)                         ##
## Cycle = from 3 to 6                                             ##
## Bonded atoms = ID sphere1-*(sphere2)-*(sphere3):IDsphere1'..... ##
#####################################################################

#ID	Bonded Atom	Charmm	Tinker	Simb	Natm	Patm	Val	Descripcion
#C_300		121	71	CL	6	12.011	3	"Ester Carbonyl"
#C_400		122	72	CL1	6	12.011	4	"Ester RCOO-CH<"
#C_400		123	73	CL2	6	12.011	4	"Ester RCOO-CH2-"
#C_400		124	73	CL2	6	12.011	4	"Ester -CH2-COOR"
#C_400		125	73	CL2	6	12.011	4	"Methylene Carbon"
#C_400		126	74	CL3	6	12.011	4	"Methyl Carbon"
#C_400		127	73	CL2	6	12.011	4	"Phosphate -CH2-PO4-"
#C_400		128	73	CL2	6	12.011	4	"R4N+ Methylene"
#C_300		130	76	CEL	6	12.011	3	"-CH=CR2 Carbon"
#O_200		132	78	OSL	8	15.999	2	"Ester -O-"
#O_200		133	79	OBL	8	15.999	1	"Ester Carbonyl"
#C_400		62	23	CT	6	12.011	4	"AIB Alpha Carbon"
#H_100		117	67	HL1	1	1.008	1	"Methine Hydrogen"
#H_100		118	68	HL2	1	1.008	1	"Methylene Hydrogen"
#H_100		119	69	HL3	1	1.008	1	"Methyl Hydrogen"
#H_100		120	70	HEL	1	1.008	1	"-CH=CR2 Hydrogen"
C_100		96	46	CM	6	12.011	1	"Heme CO Carbon"
C_300		98	48	CE1	6	12.011	3	"Alkene RHC= Carbon"
C_300	#2#:H_100:C_300-C_305-C_305	95	10	C	6	12.011	3	"Heme Alkene Carbon"
C_300	C_305-C_305-N_305	95	10	C	6	12.011	3	"Heme Alkene Carbon"
C_300	#2#:H_100:C_300-C_40?-*	99	49	CE2	6	12.011	3	"Alkene H2C= Carbon"
C_300	O_100	20	10	C	6	12.011	3	"Peptide Carbonyl"
C_300	O_100:O_200-H_100	90	42	CD	6	12.011	3	"ASP+/GLU+ Carboxyl"
C_300	O_150	22	12	CC	6	12.011	3	"C-Term Carboxylate"
C_300	#2#:N_300-H_100:O_100	22	12	CC	6	12.011	3	"ASN/GLN Carbonyl"
C_305		42	19	CH1	6	12.011	3	"HIS+ CG and CD2"
C_305	C_305-C_305-C_306:C_400-*-*	50	21	CY	6	12.011	3	"TRP CG Carbon"
C_305	C_305-C_400-*:N_305-C_305-C_306	51	11	CA	6	12.011	3	"TRP CD1 Carbon"
C_305	C_305-N_305-Fe??6	93	44	CPB	6	12.011	3	"Heme Beta Carbon"
C_305	C_306-C_306-C_306	52	22	CPT	6	12.011	3	"TRP CD2 Carbon (BETWEEN RINGS)"
C_305	N_205-*-*:N_3?5-*-*	45	20	CH2	6	12.011	3	"HIS+ CE1 Carbon"
C_305	N_305-Fe??6-*	92	43	CPA	6	12.011	3	"Heme Alpha Carbon"
C_306		21	11	CA	6	12.011	3	"Aromatic Carbon"
C_306	#2#:C_305-N_305-Fe??6	94	45	CPM	6	12.011	3	"Heme Meso Carbon"
C_330		60	10	C	6	12.011	3	"ARG CZ Carbon"
C_405		31	17	CP2	6	12.011	4	"PRO CB and CG"
C_405	C_300-*-*:C_405-*-*:N_305-*-*	30	16	CP1	6	12.011	4	"PRO CA Carbon"
C_405	C_300-*-*:N_435-*-*	33	16	CP1	6	12.011	4	"N-Terminal PRO CA"
C_405	N_305-C_405-C_300	32	18	CP3	6	12.011	4	"PRO CD Carbon"
C_405	N_435-C_405-C_300	34	18	CP3	6	12.011	4	"N-Terminal PRO CD"
C_40?		25	13	CT1	6	12.011	4	"Methine Carbon"
C_40?	C_300-*-*:N_300-*	23	13	CT1	6	12.011	4	"Peptide Alpha Carbon"
C_40?	C_300-*-*:N_300-*:#2#:H_100	28	14	CT2	6	12.011	4	"GLY Alpha Carbon"
C_40?	C_300-*-*:N_330-*-*	24	13	CT1	6	12.011	4	"N-Term Alpha Carbon"
C_40?	C_300-*-*:N_330-*:#2#:H_100	29	14	CT2	6	12.011	4	"N-Terminal GLY CA"
#C_40?	C_300-O_100:#2#:C_400-*-*:N_300-*-*	62	23	CT	6	12.011	4	"AIB Alpha Carbon"
C_40?	C_400-N_300-*:O_200-*	36	13	CT1	6	12.011	4	"THR CB Carbon"
C_40?	#2#:H_100	26	14	CT2	6	12.011	4	"Methylene Carbon"
C_40?	#3#:H_100	27	15	CT3	6	12.011	4	"Methyl Carbon"
C_40?	#3#:H_100:N_430-*-*	129	75	CL5	6	12.011	4	"R4N+ Methyl"
C_40?	S_250-*-*	97	47	CS	6	12.011	4	"Thiolate Carbon"
Ca020		114	63	CAL	20	40.080	0	"Calcium Ion"
Cl050		112	61	CLA	17	35.453	0	"Chloride Ion"
Fe?06		107	56	FE	26	55.847	6	"Heme Group Iron"
H_100		1	1	HA	1	1.008	1	"Nonpolar Hydrogen"
H_100	C_30?-C_40?-*:C_30?-C_30?-*	86	39	HA1	1	1.008	1	"Alkene RHC= Hydrogen"
H_100	C_300-H_100:C_300-C_305-C_305	84	1	HA	1	1.008	1	"Heme H2C= Hydrogen"
H_100	C_300-H_100:C_300-C_40?-*	87	40	HA2	1	1.008	1	"Alkene H2C= Hydrogen"
H_100	C_300-C_305-N_305	85	1	HA	1	1.008	1	"Heme RHC= Hydrogen"
H_100	C_305-N_205-*	12	6	HR1	1	1.008	1	"HIS+ HD2/HISDE HE1"
H_100	C_305-C_305-N_335:C_305-N_305-C_305	12	6	HR1	1	1.008	1	"HIS+ HD2/HISDE HE1"
H_100	C_305-N_335-*	13	7	HR2	1	1.008	1	"HIS+ HE1"
H_100	C_305-C_305-N_205:C_305-N_305-C_305	14	8	HR3	1	1.008	1	"HISD HD2"
H_100	C_306-C_305-N_305	83	1	HA	1	1.008	1	"Heme Meso Hydrogen"
H_100	C_306-C_306-C_306	2	2	HP	1	1.008	1	"Aromatic Hydrogen"
H_100	C_40?-N_30?-*:C_40?-C_300-O_1?0	4	4	HB	1	1.008	1	"Peptide Hidrogen on C-alpha"
H_100	C_40?-N_43?-*:C_40?-C_300-O_100	5	4	HB	1	1.008	1	"N-Terminal Hidrogen on C-alpha"
#H_100	C_40?-N_43?-*	116	66	HL	1	1.008	1	">CH-N+ Hydrogen"
H_100	N_30?-*-*	3	3	H	1	1.008	1	"Peptide Amide HN"
H_100	N_300-C_330-*	18	5	HC	1	1.008	1	"ARG HE Hydrogen"
H_100	N_43?-*-*	6	5	HC	1	1.008	1	"N-Terminal Hydrogen"
H_100	O_200-C_???-*	8	3	H	1	1.008	1	"Hydroxyl Hydrogen"
H_100	O_200-H_100	88	41	HT	1	1.008	1	"TIP3P Hydrogen"
H_100	S_200-*-*	16	9	HS	1	1.008	1	"Thiol Hydrogen"
He000		108	57	HE	2	4.003	0	"Helium Atom"
K_030		113	62	POT	19	39.098	0	"Potassium Ion"
Mg020		111	60	MG	12	24.305	0	"Magnesium Ion"
N_205		69	30	NR2	7	14.007	2	"HIS Ring N"
N_300		63	24	NH1	7	14.007	3	"Peptide Nitrogen"
N_300	C_300:#2#:H_100	64	25	NH2	7	14.007	3	"Amide Nitrogen"
N_300	C_330-*-*	72	33	NC2	7	14.007	3	"ARG NE Nitrogen"
N_305		66	27	N	7	14.007	3	"PRO Nitrogen"
N_305	C_305-N_205-*:H_100	68	29	NR1	7	14.007	3	"HIS Ring NH"
N_305	C_305-C_306-C_306	71	32	NY	7	14.007	3	"TRP Pyrrole NE1"
N_305	Fe???	100	50	NPH	7	14.007	3	"Heme Pyrrole N"
N_335		70	31	NR3	7	14.007	3	"HIS+ Ring NH"
N_430		65	26	NH3	7	14.007	4	"Ammonium Nitrogen"
N_430	#4#:C_400-H_100	131	77	NTL	7	14.007	4	"R4N+ Nitrogen"
N_435		67	28	NP	7	14.007	4	"N-Terminal PRO N"
Na030		110	59	SOD	11	22.990	0	"Sodium Ion"
Ne000		109	58	NE	10	20.183	0	"Neon Atom"
O_100		74	34	O	8	15.999	1	"Peptide Oxygen"
O_100	C_100	105	54	OM	8	15.999	1	"Heme CO/O2 Oxygen"
O_100	C_300-O_200-H_100	103	52	OB	8	15.999	1	"COOH Carbonyl Oxygen"
O_100	P_400-*-*	135	80	O2L	8	15.999	1	"Phosphate =O"
O_150		79	36	OC	8	15.999	1	"C-Term Carboxylate"
O_200		76	35	OH1	8	15.999	2	"Hydroxyl Oxygen"
O_200	C_300-O_100:C_???-*-*	104	53	OS	8	15.999	2	"Ester Oxygen"
O_200	H_100:H_100	101	51	OT	8	15.999	2	"TIP3P Water Oxygen"
O_200	P_400-*-*	134	78	OSL	8	15.999	2	"Phosphate -O-"
P_400		136	81	PL	15	30.974	4	 "Phosphate >P<"
S_150		106	55	SS	16	32.060	1	"Thiolate Sulfur"
S_200		80	37	S	16	32.060	2	"Thiol Sulfur"
S_200	S_200-*-*	82	38	SM	16	32.060	2	"Disulfide Sulfur"
Zn020		115	64	ZN	30	65.370	0	"Zinc Ion"
