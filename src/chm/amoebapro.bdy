#######################################
##        BrandyMol 2 AMOEBAPRO      ##
##     G. Torres and F. Najera       ##
##        Copyright 2006             ##
#######################################

# forcefield: AMOEBA-PROTEIN

#P. Ren and J. W. Ponder, "Polarizable Atomic Multipole-based Potential
#for Proteins: Model and Parameterization", in preparation.

#J. W. Ponder and D. A. Case, "Force Fields for Protein Simulation",
#Adv. Prot. Chem., 66, 27-85 (2003)

#P. Ren and J. W. Ponder, "Polarizable Atomic Multipole Water Model for
#Molecular Mechanics Simulation", J. Phys. Chem. B, 107, 5933-5947 (2003)

#P. Ren and J. W. Ponder, "A Consistent Treatment of Inter- and
#Intramolecular Polarization in Molecular Mechanics Calculations",
#J. Comput. Chem., 23, 1497-1506 (2002)


###############################################
##                                           ##
##  AMOEBA Protein Force Field Atom Classes  ##
##                                           ##
##   1  Backbone Amide Nitrogen              ##
##   2  Glycine Alpha Carbon                 ##
##   3  Backbone Carbonyl Carbon             ##
##   4  Amide or Guanidinium Hydrogen        ##
##   5  Amide Carbonyl Oxygen                ##
##   6  Methine Hydrogen                     ##
##   7  Methine Carbon                       ##
##   8  Methyl or Methylene Carbon           ##
##   9  Methyl or Methylene Hydrogen         ##
##  10  Hydroxyl Oxygen                      ##
##  11  Hydroxyl Hydrogen                    ##
##  12  Sulfide or Disulfide Sulfur          ##
##  13  Sulfhydryl Hydrogen                  ##
##  14  Proline Backbone Nitrogen            ##
##  15  Proline Ring Methylene Carbon        ##
##  16  Phenyl Carbon                        ##
##  17  Phenyl Hydrogen                      ##
##  18  Phenolic Oxygen                      ##
##  19  Phenolic Hydrogen                    ##
##  20  Indole Carbon                        ##
##  21  Indole CH Hydrogen                   ##
##  22  Imidazole or Indole NH Nitrogen      ##
##  23  Imidazole or Indole NH Hydrogen      ##
##  24  Imidazole C=C Carbon                 ##
##  25  Imidazole CH Hydrogen                ##
##  26  Imidazole N=C-N Carbon               ##
##  27  Imidazole C=N Nitrogen               ##
##  28  Carboxylate Carbon                   ##
##  29  Carboxylate Oxygen                   ##
##  30  Carboxylic Acid Carbonyl Oxygen      ##
##  31  Carboxylic Acid Hydroxyl Oxygen      ##
##  32  Carboxylic Acid Hydrogen             ##
##  33  Ammonium Nitrogen                    ##
##  34  Ammonium Hydrogen                    ##
##  35  Guanidinium Carbon                   ##
##  36  Acetyl or NMe Methyl Carbon          ##
##  37  N-Terminal Ammonium Nitrogen         ##
##  38  N-Terminal Ammonium Hydrogen         ##
##                                           ##
###############################################


#############################
##                         ##
##  Atom Type Definitions  ##
##                         ##
#############################


#atom          1    1    N      "Glycine N"                7     14.003    3
#atom          2    2    CA     "Glycine CA"               6     12.000    4
#atom          3    3    C      "Glycine C"                6     12.000    3
#atom          4    4    HN     "Glycine HN"               1      1.008    1
#atom          5    5    O      "Glycine O"                8     15.995    1
#atom          6    6    H      "Glycine HA"               1      1.008    1
#atom          7    1    N      "Alanine N"                7     14.003    3
#atom          8    7    CA     "Alanine CA"               6     12.000    4
#atom          9    3    C      "Alanine C"                6     12.000    3
#atom         10    4    HN     "Alanine HN"               1      1.008    1
#atom         11    5    O      "Alanine O"                8     15.995    1
#atom         12    6    H      "Alanine HA"               1      1.008    1
#atom         13    8    C      "Alanine CB"               6     12.000    4
#atom         14    9    H      "Alanine HB"               1      1.008    1
#atom         15    7    C      "Valine CB"                6     12.000    4
#atom         16    6    H      "Valine HB"                1      1.008    1
#atom         17    8    C      "Valine CG"                6     12.000    4
#atom         18    9    H      "Valine HG"                1      1.008    1
#atom         19    8    C      "Leucine CB"               6     12.000    4
#atom         20    9    H      "Leucine HB"               1      1.008    1
#atom         21    7    C      "Leucine CG"               6     12.000    4
#atom         22    6    H      "Leucine HG"               1      1.008    1
#atom         23    8    C      "Leucine CD"               6     12.000    4
#atom         24    9    H      "Leucine HD"               1      1.008    1
#atom         25    7    C      "Isoleucine CB"            6     12.000    4
#atom         26    6    H      "Isoleucine HB"            1      1.008    1
#atom         27    8    C      "Isoleucine CG"            6     12.000    4
#atom         28    9    H      "Isoleucine HG"            1      1.008    1
#atom         29    8    C      "Isoleucine CG"            6     12.000    4
#atom         30    9    H      "Isoleucine HG"            1      1.008    1
#atom         31    8    C      "Isoleucine CD"            6     12.000    4
#atom         32    9    H      "Isoleucine HD"            1      1.008    1
#atom         33    7    CA     "Serine CA"                6     12.000    4
#atom         34    8    C      "Serine CB"                6     12.000    4
#atom         35    9    H      "Serine HB"                1      1.008    1
#atom         36   10    OH     "Serine OG"                8     15.995    2
#atom         37   11    HO     "Serine HG"                1      1.008    1
#atom         38    7    C      "Threonine CB"             6     12.000    4
#atom         39    6    H      "Threonine HB"             1      1.008    1
#atom         40    8    C      "Threonine CG"             6     12.000    4
#atom         41    9    H      "Threonine HG"             1      1.008    1
#atom         42   10    OH     "Threonine O"              8     15.995    2
#atom         43   11    HO     "Threonine H"              1      1.008    1
#atom         44    7    CA     "Cysteine CA"              6     12.000    4
#atom         45    8    C      "Cysteine CB"              6     12.000    4
#atom         46    9    H      "Cysteine HB"              1      1.008    1
#atom         47   12    SH     "Cysteine SG"             16     31.972    2
#atom         48   13    HS     "Cysteine HG"              1      1.008    1
#atom         49   12    SS     "Cystine SG"              16     31.972    2
#atom         50   14    N      "Proline N"                7     14.003    3
#atom         51    7    CA     "Proline CA"               6     12.000    4
#atom         52    3    C      "Proline C"                6     12.000    3
#atom         53    5    O      "Proline O"                8     15.995    1
#atom         54    6    H      "Proline HA"               1      1.008    1
#atom         55   15    C      "Proline CB"               6     12.000    4
#atom         56    9    H      "Proline HB"               1      1.008    1
#atom         57   15    C      "Proline CG"               6     12.000    4
#atom         58    9    H      "Proline HG"               1      1.008    1
#atom         59   15    C      "Proline CD"               6     12.000    4
#atom         60    6    H      "Proline HD"               1      1.008    1
#atom         61    8    C      "Phenylalanine CB"         6     12.000    4
#atom         62    9    H      "Phenylalanine HB"         1      1.008    1
#atom         63   16    C      "Phenylalanine CG"         6     12.000    3
#atom         64   16    C      "Phenylalanine CD"         6     12.000    3
#atom         65   17    H      "Phenylalanine HD"         1      1.008    1
#atom         66   16    C      "Phenylalanine CE"         6     12.000    3
#atom         67   17    H      "Phenylalanine HE"         1      1.008    1
#atom         68   16    C      "Phenylalanine CZ"         6     12.000    3
#atom         69   17    H      "Phenylalanine HZ"         1      1.008    1
#atom         70    8    C      "Tyrosine CB"              6     12.000    4
#atom         71    9    H      "Tyrosine HB"              1      1.008    1
#atom         72   16    C      "Tyrosine CG"              6     12.000    3
#atom         73   16    C      "Tyrosine CD"              6     12.000    3
#atom         74   17    H      "Tyrosine HD"              1      1.008    1
#atom         75   16    C      "Tyrosine CE"              6     12.000    3
#atom         76   17    H      "Tyrosine HE"              1      1.008    1
#atom         77   16    C      "Tyrosine CZ"              6     12.000    3
#atom         78   18    OH     "Tyrosine OH"              8     15.995    2
#atom         79   19    HO     "Tyrosine HH"              1      1.008    1
#atom         80    8    C      "Tryptophan CB"            6     12.000    4
#atom         81    9    H      "Tryptophan HB"            1      1.008    1
#atom         82   20    C      "Tryptophan CG"            6     12.000    3
#atom         83   20    C      "Tryptophan CD1"           6     12.000    3
#atom         84   21    H      "Tryptophan HD1"           1      1.008    1
#atom         85   20    C      "Tryptophan CD2"           6     12.000    3
#atom         86   22    N      "Tryptophan NE1"           7     14.003    3
#atom         87   23    HN     "Tryptophan HE1"           1      1.008    1
#atom         88   20    C      "Tryptophan CE2"           6     12.000    3
#atom         89   20    C      "Tryptophan CE3"           6     12.000    3
#atom         90   21    H      "Tryptophan HE3"           1      1.008    1
#atom         91   20    C      "Tryptophan CZ2"           6     12.000    3
#atom         92   21    H      "Tryptophan HZ2"           1      1.008    1
#atom         93   20    C      "Tryptophan CZ3"           6     12.000    3
#atom         94   21    H      "Tryptophan HZ3"           1      1.008    1
#atom         95   20    C      "Tryptophan CH2"           6     12.000    3
#atom         96   21    H      "Tryptophan HH2"           1      1.008    1
#atom         97    8    C      "Histidine(+) CB"          6     12.000    4
#atom         98    9    H      "Histidine(+) HB"          1      1.008    1
#atom         99   24    C      "Histidine(+) CG"          6     12.000    3
#atom        100   22    N      "Histidine(+) ND1"         7     14.003    3
#atom        101   23    HN     "Histidine(+) HD1"         1      1.008    1
#atom        102   24    C      "Histidine(+) CD2"         6     12.000    3
#atom        103   25    H      "Histidine(+) HD2"         1      1.008    1
#atom        104   26    C      "Histidine(+) CE1"         6     12.000    3
#atom        105   25    H      "Histidine(+) HE1"         1      1.008    1
#atom        106   22    N      "Histidine(+) NE2"         7     14.003    3
#atom        107   23    HN     "Histidine(+) HE2"         1      1.008    1
#atom        108    8    C      "Histidine/HID CB"         6     12.000    4
#atom        109    9    H      "Histidine/HID HB"         1      1.008    1
#atom        110   24    C      "Histidine/HID CG"         6     12.000    3
#atom        111   22    N      "Histidine/HID ND1"        7     14.003    3
#atom        112   23    HN     "Histidine/HID HD1"        1      1.008    1
#atom        113   24    C      "Histidine/HID CD2"        6     12.000    3
#atom        114   25    H      "Histidine/HID HD2"        1      1.008    1
#atom        115   26    C      "Histidine/HID CE1"        6     12.000    3
#atom        116   25    H      "Histidine/HID HE1"        1      1.008    1
#atom        117   27    N      "Histidine/HID NE2"        7     14.003    2
#atom        118    8    C      "Histidine/HIE CB"         6     12.000    4
#atom        119    9    H      "Histidine/HIE HB"         1      1.008    1
#atom        120   24    C      "Histidine/HIE CG"         6     12.000    3
#atom        121   27    N      "Histidine/HIE ND1"        7     14.003    2
#atom        122   24    C      "Histidine/HIE CD2"        6     12.000    3
#atom        123   25    H      "Histidine/HIE HD2"        1      1.008    1
#atom        124   26    C      "Histidine/HIE CE1"        6     12.000    3
#atom        125   25    H      "Histidine/HIE HE1"        1      1.008    1
#atom        126   22    N      "Histidine/HIE NE2"        7     14.003    3
#atom        127   23    HN     "Histidine/HIE HE2"        1      1.008    1
#atom        128    8    C      "Aspartate CB"             6     12.000    4
#atom        129    9    H      "Aspartate HB"             1      1.008    1
#atom        130   28    C      "Aspartate CG"             6     12.000    3
#atom        131   29    O      "Aspartate OG"             8     15.995    1
#atom        132    8    C      "Aspartic Acid CB"         6     12.000    4
#atom        133    9    H      "Aspartic Acid HB"         1      1.008    1
#atom        134   28    C      "Aspartic Acid CG"         6     12.000    3
#atom        135   30    O      "Aspartic Acid OG"         8     15.995    1
#atom        136   31    OH     "Aspartic Acid OH"         8     15.995    2
#atom        137   32    HO     "Aspartic Acid HO"         1      1.008    1
#atom        138    8    C      "Asparagine CB"            6     12.000    4
#atom        139    9    H      "Asparagine HB"            1      1.008    1
#atom        140    3    C      "Asparagine CG"            6     12.000    3
#atom        141    5    O      "Asparagine OD1"           8     15.995    1
#atom        142    1    N      "Asparagine ND2"           7     14.003    3
#atom        143    4    HN     "Asparagine HD2"           1      1.008    1
#atom        144    8    C      "Glutamate CB"             6     12.000    4
#atom        145    9    H      "Glutamate HB"             1      1.008    1
#atom        146    8    C      "Glutamate CG"             6     12.000    4
#atom        147    9    H      "Glutamate HG"             1      1.008    1
#atom        148   28    C      "Glutamate CD"             6     12.000    3
#atom        149   29    O      "Glutamate OD"             8     15.995    1
#atom        150    8    C      "Glutamine CB"             6     12.000    4
#atom        151    9    H      "Glutamine HB"             1      1.008    1
#atom        152    8    C      "Methionine CB"            6     12.000    4
#atom        153    9    H      "Methionine HB"            1      1.008    1
#atom        154    8    C      "Methionine CG"            6     12.000    4
#atom        155    9    H      "Methionine HG"            1      1.008    1
#atom        156   12    S      "Methionine SD"           16     31.972    2
#atom        157    8    C      "Methionine CE"            6     12.000    4
#atom        158    9    H      "Methionine HE"            1      1.008    1
#atom        159    8    C      "Lysine CB"                6     12.000    4
#atom        160    9    H      "Lysine HB"                1      1.008    1
#atom        161    8    C      "Lysine CG"                6     12.000    4
#atom        162    9    H      "Lysine HG"                1      1.008    1
#atom        163    8    C      "Lysine CD"                6     12.000    4
#atom        164    9    H      "Lysine HD"                1      1.008    1
#atom        165    8    C      "Lysine CE"                6     12.000    4
#atom        166    9    H      "Lysine HE"                1      1.008    1
#atom        167   33    N      "Lysine NZ"                7     14.003    4
#atom        168   34    HN     "Lysine HN"                1      1.008    1
#atom        169    8    C      "Arginine CB"              6     12.000    4
#atom        170    9    H      "Arginine HB"              1      1.008    1
#atom        171    8    C      "Arginine CG"              6     12.000    4
#atom        172    9    H      "Arginine HG"              1      1.008    1
#atom        173    8    C      "Arginine CD"              6     12.000    4
#atom        174    9    H      "Arginine HD"              1      1.008    1
#atom        175    1    N      "Arginine NE"              7     14.003    3
#atom        176    4    HN     "Arginine HE"              1      1.008    1
#atom        177   35    C      "Arginine CZ"              6     12.000    3
#atom        178    1    N      "Arginine NH"              7     14.003    3
#atom        179    4    HN     "Arginine HH"              1      1.008    1
#atom        180   36    C      "Acetyl CH3"               6     12.000    4
#atom        181    6    H      "Acetyl H3C"               1      1.008    1
#atom        182    3    C      "Acetyl C"                 6     12.000    3
#atom        183    5    O      "Acetyl O"                 8     15.995    1
#atom        184    1    N      "N-MeAmide N"              7     14.003    3
#atom        185    4    HN     "N-MeAmide HN"             1      1.008    1
#atom        186   36    C      "N-MeAmide CH3"            6     12.000    4
#atom        187    6    H      "N-MeAmide H3C"            1      1.008    1
#atom        188    1    N      "Amide NH2"                7     14.003    3
#atom        189    4    HN     "Amide H2N"                1      1.008    1
#atom        190   37    N      "N-Terminal NH3+"          7     14.003    4
#atom        191   38    H      "N-Terminal H3N+"          1      1.008    1
#atom        192   28    C      "C-Terminal COO-"          6     12.000    3
#atom        193   29    O      "C-Terminal COO-"          8     15.995    1
#atom        194   37    N      "N-Terminal PRO NH2+"      7     14.003    4
#atom        195   38    HN     "N-Terminal PRO H2N+"      1      1.008    1
#atom        196    7    CA     "N-Terminal PRO CA"        6     12.000    4
#atom        197    3    C      "N-Terminal PRO C"         6     12.000    3
#atom        198    5    O      "N-Terminal PRO O"         8     15.995    1
#atom        199    6    H      "N-Terminal PRO HA"        1      1.008    1
#atom        200   15    C      "N-Terminal PRO CD"        6     12.000    4
#atom        201    6    H      "N-Terminal PRO HD"        1      1.008    1

#####################################################################
## General atom types:                                             ##
## ID =  Symbol(xx)Valence(x)Charge(x)Cycle(x)                     ##
## Valence = from 1 to 4                                           ##
## Charge = 0, 3 (+1), 2 (radical), 5 (-1)                         ##
## Cycle = from 3 to 6                                             ##
## Bonded atoms = ID sphere1-*(sphere2)-*(sphere3):IDsphere1'..... ##
#####################################################################


#ID	Bonded Atom	Amoebapro	Tinker	Simb	Natm	Patm	Val	Descripcion
C_300		3	3	 C	6	12.000	3	Backbone Carbonyl Carbon
C_300	O_150	130	28	 C	6	12.000	3	Carboxylate Carbon
C_300	O_200-H_100	134	28	 C	6	12.000	3	Aspartic Acid CG
C_3?0	#5#:N_300-H_100	177	35	 C	6	12.000	3	Guanidinium Carbon
C_305		99	24	 C	6	12.000	3	Imidazole C=C Carbon
C_305	C_306-C_306-C_306	83	20	 C	6	12.000	3	Indole Carbon
C_305	C_305-C_305-C_306	82	20	 C	6	12.000	3	Indole Carbon
C_305	#2#:N_?05-C_305-C_305	104	26	 C	6	12.000	3	Imidazole N=C-N Carbon
C_306		63	16	 C	6	12.000	3	Phenyl Carbon
C_306	C_305-*-*	85	20	 C	6	12.000	3	Indole Carbon
C_306	C_306-C_305-*	85	20	 C	6	12.000	3	Indole Carbon
C_400		13	8	 C	6	12.000	4	Methyl or Methylene Carbon
C_400	C_300-O_100:#3#:H_100	180	36	 C	6	12.000	4	Acetyl CH3
C_400	C_300-*-*:N_???-*-*	15	7	 C	6	12.000	4	Methine Carbon
C_400	#3#:C_400-H_100:O_200-*-*	15	7	 C	6	12.000	4	Methine Carbon
C_400	#2#:H_100:C_300-*-*:N_???-*-*	2	2	 CA	6	12.000	4	Glycine Alpha Carbon
C_400	#3#:H_100:N_300-C_300-O_100	186	36	 C	6	12.000	4	N-MeAmide CH3
C_400	#6#:C_400-H_100	15	7	 C	6	12.000	4	Methine Carbon
C_405		55	15	 C	6	12.000	4	Proline Ring Methylene Carbon 
C_405	C_300-*-*:N_???-*-*	15	7	 C	6	12.000	4	Methine Carbon
H_100		14	9	 H	1	1.008	1	Methyl or Methylene Hydrogen
H_100	C_305-C_305-C_305	84	21	 H	1	1.008	1	Indole CH Hydrogen
H_100	C_305-C_305-N_205	116	25	 H	1	1.008	1	Imidazole CH Hydrogen
H_100	C_305-N_205-C_305	114	25	 H	1	1.008	1	Imidazole CH Hydrogen
H_100	C_305-N_335-*	103	25	 H	1	1.008	1	Imidazole CH Hydrogen
H_100	C_306-C_305-C_305	90	21	 H	1	1.008	1	Indole CH Hydrogen
H_100	C_306-C_306-C_305	92	21	 H	1	1.008	1	Indole CH Hydrogen
H_100	#2#:C_306-C_306-C_306	65	17	 H	1	1.008	1	Phenyl Hydrogen
H_100	C_40?-C_300-*:C_40?-N_???-*	6	6	 H	1	1.008	1	Methine Hydrogen
H_100	C_40?-C_400-*:C_40?-O_200-*	14	9	 H	1	1.008	1	Methyl or Methylene Hydrogen
H_100	#3#:C_40?-C_400-H_100:C_40?-C_400-*:C_40?-O_200-*	6	6	 H	1	1.008	1	Methine Hydrogen
H_100	#6#:C_400-C_400-H_100	16	6	 H	1	1.008	1	Methine Hydrogen
H_100	#7#:C_400-H_100	16	6	 H	1	1.008	1	Methine Hydrogen
H_100	C_405-N_??5	60	6	 H	1	1.008	1	Methine Hydrogen
H_100	C_400-N_300-C_300	6	6	 H	1	1.008	1	Methine Hydrogen
H_100	C_400-N_300-C_300:#2#:C_400-H_100	187	6	 H	1	1.008	1	N-MeAmide H3C(Methine Hydrogen)
H_100	N_300	4	4	 HN	1	1.008	1	Amide or Guanidinium Hydrogen
H_100	N_305-*-*	87	23	 HN	1	1.008	1	Imidazole or Indole NH Hydrogen
H_100	N_305-C305-N_305	101	23	 HN	1	1.008	1	Imidazole or Indole NH Hydrogen
H_100	N_430-*-*	191	38	 H	1	1.008	1	N-Terminal Ammonium Hydrogen
H_100	#2#:N_430-C_400-H_100:N_430-C_400-C_400	168	34	 HN	1	1.008	1	Ammonium Hydrogen
H_100	N_435-*-*	195	38	 HN	1	1.008	1	N-Terminal PRO H2N+
H_100	O_200	37	11	 HO	1	1.008	1	Hydroxyl Hydrogen
H_100	O_200-C_300-O_100	137	32	 HO	1	1.008	1	Carboxylic Acid Hydrogen
H_100	O_200-C_306-*	79	19	 HO	1	1.008	1	Phenolic Hydrogen
H_100	S_200-*	48	13	 HS	1	1.008	1	Sulfhydryl Hydrogen
N_205		117	27	 N	7	14.003	2	Imidazole C=N Nitrogen
N_300		1	1	 N	7	14.003	3	Backbone Amide Nitrogen
N_305		50	14	 N	7	14.003	3	Proline Backbone Nitrogen
N_305	H_100	86	22	 N	7	14.003	3	Imidazole or Indole NH Nitrogen
N_43?		167	33	 N	7	14.003	4	Ammonium Nitrogen (LYS)
N_43?	C_40?-C_300-O_100	190	37	 N	7	14.003	4	N-Terminal Ammonium Nitrogen
O_100		5	5	 O	8	15.995	1	Amide Carbonyl Oxygen
O_100	C_300-C_405-N_435	198	5	 O	8	15.995	1	N-Terminal PRO O
O_100	C_300-O_200-H_100	135	30	 O	8	15.995	1	Carboxylic Acid Carbonyl Oxygen
O_150		131	29	 O	8	15.995	1	Carboxylate Oxygen
O_200	H_100	36	10	 OH	8	15.995	2	Hydroxyl Oxygen
O_200	C_300-O_100:H_100	136	31	 OH	8	15.995	2	Carboxylic Acid Hydroxyl Oxygen
O_200	C_306-*-*:H_100	78	18	 OH	8	15.995	2	Phenolic Oxygen  
S_200		156	12	 S	16	31.972	2	Sulfide or Disulfide Sulfur (MET)
S_200	H_100	47	12	 SH	16	31.972	2	Sulfide or Disulfide Sulfur (CYS)
S_200	S_200-*-*	49	12	 SS	16	31.972	2	Sulfide or Disulfide Sulfur
