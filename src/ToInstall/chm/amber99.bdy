#######################################
##        BrandyMol 2 AMBER99        ##
##     G. Torres and F. Najera       ##
##        Copyright 2006             ##
#######################################

# forcefield: AMBER-ff99


#J. Wang, P. Cieplak and P. A. Kollman, "How Well Does a Restrained
#Electrostatic Potential (RESP) Model Perform in Calcluating Conformational
#Energies of Organic and Biological Molecules?", J. Comput. Chem., 21,
#1049-1074 (2000)  [PARM99]

#W. D. Cornell, P. Cieplak, C. I. Bayly, I. R. Gould, K. M. Merz, Jr.,
#D. M. Ferguson, D. C. Spellmeyer, T. Fox, J. W. Caldwell and P. A. Kollman,
#"A Second Generation Force Field for the Simulation of Proteins, Nucleic
#Acids, and Organic Molecules", J. Am. Chem. Soc., 117, 5179-5197 (1995)
#[PARM94]

#G. Moyna, H. J. Williams, R. J. Nachman and A. I. Scott, "Conformation in
#Solution and Dynamics of a Structurally Constrained Linear Insect Kinin
#Pentapeptide Analogue", Biopolymers, 49, 403-413 (1999)  [AIB charges]

#W. S. Ross and C. C. Hardin, "Ion-Induced Stabilization of the G-DNA
#Quadruplex: Free Energy Perturbation Studies", J. Am. Chem. Soc.,
#116, 6070-6080 (1994)  [Alkali Metal Ions]

#J. Aqvist, "Ion-Water Interaction Potentials Derived from Free Energy
#Perturbation Simulations", J. Phys. Chem., 94, 8021-8024 (1990)
#[Alkaline Earth Ions, radii adapted for AMBER combining rule]

#Current parameter values are available from the AMBER site, located
#at http://amber.scripps.edu/


#############################
##                         ##
##  Atom Type Definitions  ##
##                         ##
#############################

#####################################################
##                                                 ##
##  TINKER Atom Class Numbers to Amber Atom Types  ##
##                                                 ##
##    1  CT      11  CN      21  OW      31  HO    ##
##    2  C       12  CK      22  OH      32  HS    ##
##    3  CA      13  CQ      23  OS      33  HA    ##
##    4  CM      14  N       24  O       34  HC    ##
##    5  CC      15  NA      25  O2      35  H1    ##
##    6  CV      16  NB      26  S       36  H2    ##
##    7  CW      17  NC      27  SH      37  H3    ##
##    8  CR      18  N*      28  P       38  HP    ##
##    9  CB      19  N2      29  H       39  H4    ##
##   10  C*      20  N3      30  HW      40  H5    ##
##                                                 ##
#####################################################


#atom      1    14    N       "Glycine N"                 7     14.010     3
#atom      2     1    CT      "Glycine CA"                6     12.010     4
#atom      3     2    C       "Glycine C"                 6     12.010     3
#atom      4    29    H       "Glycine HN"                1      1.008     1
#atom      5    24    O       "Glycine O"                 8     16.000     1
#atom      6    35    H1      "Glycine HA"                1      1.008     1
#atom      7    14    N       "Alanine N"                 7     14.010     3
#atom      8     1    CT      "Alanine CA"                6     12.010     4
#atom      9     2    C       "Alanine C"                 6     12.010     3
#atom     10    29    H       "Alanine HN"                1      1.008     1
#atom     11    24    O       "Alanine O"                 8     16.000     1
#atom     12    35    H1      "Alanine HA"                1      1.008     1
#atom     13     1    CT      "Alanine CB"                6     12.010     4
#atom     14    34    HC      "Alanine HB"                1      1.008     1
#atom     15    14    N       "Valine N"                  7     14.010     3
#atom     16     1    CT      "Valine CA"                 6     12.010     4
#atom     17     2    C       "Valine C"                  6     12.010     3
#atom     18    29    H       "Valine HN"                 1      1.008     1
#atom     19    24    O       "Valine O"                  8     16.000     1
#atom     20    35    H1      "Valine HA"                 1      1.008     1
#atom     21     1    CT      "Valine CB"                 6     12.010     4
#atom     22    34    HC      "Valine HB"                 1      1.008     1
#atom     23     1    CT      "Valine CG1"                6     12.010     4
#atom     24    34    HC      "Valine HG1"                1      1.008     1
#atom     25     1    CT      "Valine CG2"                6     12.010     4
#atom     26    34    HC      "Valine HG2"                1      1.008     1
#atom     27    14    N       "Leucine N"                 7     14.010     3
#atom     28     1    CT      "Leucine CA"                6     12.010     4
#atom     29     2    C       "Leucine C"                 6     12.010     3
#atom     30    29    H       "Leucine HN"                1      1.008     1
#atom     31    24    O       "Leucine O"                 8     16.000     1
#atom     32    35    H1      "Leucine HA"                1      1.008     1
#atom     33     1    CT      "Leucine CB"                6     12.010     4
#atom     34    34    HC      "Leucine HB"                1      1.008     1
#atom     35     1    CT      "Leucine CG"                6     12.010     4
#atom     36    34    HC      "Leucine HG"                1      1.008     1
#atom     37     1    CT      "Leucine CD1"               6     12.010     4
#atom     38    34    HC      "Leucine HD1"               1      1.008     1
#atom     39     1    CT      "Leucine CD2"               6     12.010     4
#atom     40    34    HC      "Leucine HD2"               1      1.008     1
#atom     41    14    N       "Isoleucine N"              7     14.010     3
#atom     42     1    CT      "Isoleucine CA"             6     12.010     4
#atom     43     2    C       "Isoleucine C"              6     12.010     3
#atom     44    29    H       "Isoleucine HN"             1      1.008     1
#atom     45    24    O       "Isoleucine O"              8     16.000     1
#atom     46    35    H1      "Isoleucine HA"             1      1.008     1
#atom     47     1    CT      "Isoleucine CB"             6     12.010     4
#atom     48    34    HC      "Isoleucine HB"             1      1.008     1
#atom     49     1    CT      "Isoleucine CG1"            6     12.010     4
#atom     50    34    HC      "Isoleucine HG1"            1      1.008     1
#atom     51     1    CT      "Isoleucine CG2"            6     12.010     4
#atom     52    34    HC      "Isoleucine HG2"            1      1.008     1
#atom     53     1    CT      "Isoleucine CD"             6     12.010     4
#atom     54    34    HC      "Isoleucine HD"             1      1.008     1
#atom     55    14    N       "Serine N"                  7     14.010     3
#atom     56     1    CT      "Serine CA"                 6     12.010     4
#atom     57     2    C       "Serine C"                  6     12.010     3
#atom     58    29    H       "Serine HN"                 1      1.008     1
#atom     59    24    O       "Serine O"                  8     16.000     1
#atom     60    35    H1      "Serine HA"                 1      1.008     1
#atom     61     1    CT      "Serine CB"                 6     12.010     4
#atom     62    35    H1      "Serine HB"                 1      1.008     1
#atom     63    22    OH      "Serine OG"                 8     16.000     2
#atom     64    31    HO      "Serine HG"                 1      1.008     1
#atom     65    14    N       "Threonine N"               7     14.010     3
#atom     66     1    CT      "Threonine CA"              6     12.010     4
#atom     67     2    C       "Threonine C"               6     12.010     3
#atom     68    29    H       "Threonine HN"              1      1.008     1
#atom     69    24    O       "Threonine O"               8     16.000     1
#atom     70    35    H1      "Threonine HA"              1      1.008     1
#atom     71     1    CT      "Threonine CB"              6     12.010     4
#atom     72    35    H1      "Threonine HB"              1      1.008     1
#atom     73    22    OH      "Threonine OG1"             8     16.000     2
#atom     74    31    HO      "Threonine HG1"             1      1.008     1
#atom     75     1    CT      "Threonine CG2"             6     12.010     4
#atom     76    34    HC      "Threonine HG2"             1      1.008     1
#atom     77    14    N       "Cysteine (-SH) N"          7     14.010     3
#atom     78     1    CT      "Cysteine (-SH) CA"         6     12.010     4
#atom     79     2    C       "Cysteine (-SH) C"          6     12.010     3
#atom     80    29    H       "Cysteine (-SH) HN"         1      1.008     1
#atom     81    24    O       "Cysteine (-SH) O"          8     16.000     1
#atom     82    35    H1      "Cysteine (-SH) HA"         1      1.008     1
#atom     83     1    CT      "Cysteine (-SH) CB"         6     12.010     4
#atom     84    35    H1      "Cysteine (-SH) HB"         1      1.008     1
#atom     85    27    SH      "Cysteine (-SH) SG"        16     32.060     2
#atom     86    32    HS      "Cysteine (-SH) HG"         1      1.008     1
#atom     87    14    N       "Cystine (-SS-) N"          7     14.010     3
#atom     88     1    CT      "Cystine (-SS-) CA"         6     12.010     4
#atom     89     2    C       "Cystine (-SS-) C"          6     12.010     3
#atom     90    29    H       "Cystine (-SS-) HN"         1      1.008     1
#atom     91    24    O       "Cystine (-SS-) O"          8     16.000     1
#atom     92    35    H1      "Cystine (-SS-) HA"         1      1.008     1
#atom     93     1    CT      "Cystine (-SS-) CB"         6     12.010     4
#atom     94    35    H1      "Cystine (-SS-) HB"         1      1.008     1
#atom     95    26    S       "Cystine (-SS-) SG"        16     32.060     2
#atom     96    14    N       "Proline N"                 7     14.010     3
#atom     97     1    CT      "Proline CA"                6     12.010     4
#atom     98     2    C       "Proline C"                 6     12.010     3
#atom     99    24    O       "Proline O"                 8     16.000     1
#atom    100    35    H1      "Proline HA"                1      1.008     1
#atom    101     1    CT      "Proline CB"                6     12.010     4
#atom    102    34    HC      "Proline HB"                1      1.008     1
#atom    103     1    CT      "Proline CG"                6     12.010     4
#atom    104    34    HC      "Proline HG"                1      1.008     1
#atom    105     1    CT      "Proline CD"                6     12.010     4
#atom    106    35    H1      "Proline HD"                1      1.008     1
#atom    107    14    N       "Phenylalanine N"           7     14.010     3
#atom    108     1    CT      "Phenylalanine CA"          6     12.010     4
#atom    109     2    C       "Phenylalanine C"           6     12.010     3
#atom    110    29    H       "Phenylalanine HN"          1      1.008     1
#atom    111    24    O       "Phenylalanine O"           8     16.000     1
#atom    112    35    H1      "Phenylalanine HA"          1      1.008     1
#atom    113     1    CT      "Phenylalanine CB"          6     12.010     4
#atom    114    34    HC      "Phenylalanine HB"          1      1.008     1
#atom    115     3    CA      "Phenylalanine CG"          6     12.010     3
#atom    116     3    CA      "Phenylalanine CD"          6     12.010     3
#atom    117    33    HA      "Phenylalanine HD"          1      1.008     1
#atom    118     3    CA      "Phenylalanine CE"          6     12.010     3
#atom    119    33    HA      "Phenylalanine HE"          1      1.008     1
#atom    120     3    CA      "Phenylalanine CZ"          6     12.010     3
#atom    121    33    HA      "Phenylalanine HZ"          1      1.008     1
#atom    122    14    N       "Tyrosine N"                7     14.010     3
#atom    123     1    CT      "Tyrosine CA"               6     12.010     4
#atom    124     2    C       "Tyrosine C"                6     12.010     3
#atom    125    29    H       "Tyrosine HN"               1      1.008     1
#atom    126    24    O       "Tyrosine O"                8     16.000     1
#atom    127    35    H1      "Tyrosine HA"               1      1.008     1
#atom    128     1    CT      "Tyrosine CB"               6     12.010     4
#atom    129    34    HC      "Tyrosine HB"               1      1.008     1
#atom    130     3    CA      "Tyrosine CG"               6     12.010     3
#atom    131     3    CA      "Tyrosine CD"               6     12.010     3
#atom    132    33    HA      "Tyrosine HD"               1      1.008     1
#atom    133     3    CA      "Tyrosine CE"               6     12.010     3
#atom    134    33    HA      "Tyrosine HE"               1      1.008     1
#atom    135     3    CA      "Tyrosine CZ"               6     12.010     3
#atom    136    22    OH      "Tyrosine OH"               8     16.000     2
#atom    137    31    HO      "Tyrosine HH"               1      1.008     1
#atom    138    14    N       "Tryptophan N"              7     14.010     3
#atom    139     1    CT      "Tryptophan CA"             6     12.010     4
#atom    140     2    C       "Tryptophan C"              6     12.010     3
#atom    141    29    H       "Tryptophan HN"             1      1.008     1
#atom    142    24    O       "Tryptophan O"              8     16.000     1
#atom    143    35    H1      "Tryptophan HA"             1      1.008     1
#atom    144     1    CT      "Tryptophan CB"             6     12.010     4
#atom    145    34    HC      "Tryptophan HB"             1      1.008     1
#atom    146    10    C*      "Tryptophan CG"             6     12.010     3
#atom    147     7    CW      "Tryptophan CD1"            6     12.010     3
#atom    148    39    H4      "Tryptophan HD1"            1      1.008     1
#atom    149     9    CB      "Tryptophan CD2"            6     12.010     3
#atom    150    15    NA      "Tryptophan NE1"            7     14.010     3
#atom    151    29    H       "Tryptophan HE1"            1      1.008     1
#atom    152    11    CN      "Tryptophan CE2"            6     12.010     3
#atom    153     3    CA      "Tryptophan CE3"            6     12.010     3
#atom    154    33    HA      "Tryptophan HE3"            1      1.008     1
#atom    155     3    CA      "Tryptophan CZ2"            6     12.010     3
#atom    156    33    HA      "Tryptophan HZ2"            1      1.008     1
#atom    157     3    CA      "Tryptophan CZ3"            6     12.010     3
#atom    158    33    HA      "Tryptophan HZ3"            1      1.008     1
#atom    159     3    CA      "Tryptophan CH2"            6     12.010     3
#atom    160    33    HA      "Tryptophan HH2"            1      1.008     1
#atom    161    14    N       "Histidine (+) N"           7     14.010     3
#atom    162     1    CT      "Histidine (+) CA"          6     12.010     4
#atom    163     2    C       "Histidine (+) C"           6     12.010     3
#atom    164    29    H       "Histidine (+) HN"          1      1.008     1
#atom    165    24    O       "Histidine (+) O"           8     16.000     1
#atom    166    35    H1      "Histidine (+) HA"          1      1.008     1
#atom    167     1    CT      "Histidine (+) CB"          6     12.010     4
#atom    168    34    HC      "Histidine (+) HB"          1      1.008     1
#atom    169     5    CC      "Histidine (+) CG"          6     12.010     3
#atom    170    15    NA      "Histidine (+) ND1"         7     14.010     3
#atom    171    29    H       "Histidine (+) HD1"         1      1.008     1
#atom    172     7    CW      "Histidine (+) CD2"         6     12.010     3
#atom    173    39    H4      "Histidine (+) HD2"         1      1.008     1
#atom    174     8    CR      "Histidine (+) CE1"         6     12.010     3
#atom    175    40    H5      "Histidine (+) HE1"         1      1.008     1
#atom    176    15    NA      "Histidine (+) NE2"         7     14.010     3
#atom    177    29    H       "Histidine (+) HE2"         1      1.008     1
#atom    178    14    N       "Histidine (HD) N"          7     14.010     3
#atom    179     1    CT      "Histidine (HD) CA"         6     12.010     4
#atom    180     2    C       "Histidine (HD) C"          6     12.010     3
#atom    181    29    H       "Histidine (HD) HN"         1      1.008     1
#atom    182    24    O       "Histidine (HD) O"          8     16.000     1
#atom    183    35    H1      "Histidine (HD) HA"         1      1.008     1
#atom    184     1    CT      "Histidine (HD) CB"         6     12.010     4
#atom    185    34    HC      "Histidine (HD) HB"         1      1.008     1
#atom    186     5    CC      "Histidine (HD) CG"         6     12.010     3
#atom    187    15    NA      "Histidine (HD) ND1"        7     14.010     3
#atom    188    29    H       "Histidine (HD) HD1"        1      1.008     1
#atom    189     6    CV      "Histidine (HD) CD2"        6     12.010     3
#atom    190    39    H4      "Histidine (HD) HD2"        1      1.008     1
#atom    191     8    CR      "Histidine (HD) CE1"        6     12.010     3
#atom    192    40    H5      "Histidine (HD) HE1"        1      1.008     1
#atom    193    16    NB      "Histidine (HD) NE2"        7     14.010     2
#atom    194    14    N       "Histidine (HE) N"          7     14.010     3
#atom    195     1    CT      "Histidine (HE) CA"         6     12.010     4
#atom    196     2    C       "Histidine (HE) C"          6     12.010     3
#atom    197    29    H       "Histidine (HE) HN"         1      1.008     1
#atom    198    24    O       "Histidine (HE) O"          8     16.000     1
#atom    199    35    H1      "Histidine (HE) HA"         1      1.008     1
#atom    200     1    CT      "Histidine (HE) CB"         6     12.010     4
#atom    201    34    HC      "Histidine (HE) HB"         1      1.008     1
#atom    202     5    CC      "Histidine (HE) CG"         6     12.010     3
#atom    203    16    NB      "Histidine (HE) ND1"        7     14.010     2
#atom    204     7    CW      "Histidine (HE) CD2"        6     12.010     3
#atom    205    39    H4      "Histidine (HE) HD2"        1      1.008     1
#atom    206     8    CR      "Histidine (HE) CE1"        6     12.010     3
#atom    207    40    H5      "Histidine (HE) HE1"        1      1.008     1
#atom    208    15    NA      "Histidine (HE) NE2"        7     14.010     3
#atom    209    29    H       "Histidine (HE) HE2"        1      1.008     1
#atom    210    14    N       "Aspartic Acid N"           7     14.010     3
#atom    211     1    CT      "Aspartic Acid CA"          6     12.010     4
#atom    212     2    C       "Aspartic Acid C"           6     12.010     3
#atom    213    29    H       "Aspartic Acid HN"          1      1.008     1
#atom    214    24    O       "Aspartic Acid O"           8     16.000     1
#atom    215    35    H1      "Aspartic Acid HA"          1      1.008     1
#atom    216     1    CT      "Aspartic Acid CB"          6     12.010     4
#atom    217    34    HC      "Aspartic Acid HB"          1      1.008     1
#atom    218     2    C       "Aspartic Acid CG"          6     12.010     3
#atom    219    25    O2      "Aspartic Acid OD"          8     16.000     1
#atom    220    14    N       "Asparagine N"              7     14.010     3
#atom    221     1    CT      "Asparagine CA"             6     12.010     4
#atom    222     2    C       "Asparagine C"              6     12.010     3
#atom    223    29    H       "Asparagine HN"             1      1.008     1
#atom    224    24    O       "Asparagine O"              8     16.000     1
#atom    225    35    H1      "Asparagine HA"             1      1.008     1
#atom    226     1    CT      "Asparagine CB"             6     12.010     4
#atom    227    34    HC      "Asparagine HB"             1      1.008     1
#atom    228     2    C       "Asparagine CG"             6     12.010     3
#atom    229    24    O       "Asparagine OD1"            8     16.000     1
#atom    230    14    N       "Asparagine ND2"            7     14.010     3
#atom    231    29    H       "Asparagine HD2"            1      1.008     1
#atom    232    14    N       "Glutamic Acid N"           7     14.010     3
#atom    233     1    CT      "Glutamic Acid CA"          6     12.010     4
#atom    234     2    C       "Glutamic Acid C"           6     12.010     3
#atom    235    29    H       "Glutamic Acid HN"          1      1.008     1
#atom    236    24    O       "Glutamic Acid O"           8     16.000     1
#atom    237    35    H1      "Glutamic Acid HA"          1      1.008     1
#atom    238     1    CT      "Glutamic Acid CB"          6     12.010     4
#atom    239    34    HC      "Glutamic Acid HB"          1      1.008     1
#atom    240     1    CT      "Glutamic Acid CG"          6     12.010     4
#atom    241    34    HC      "Glutamic Acid HG"          1      1.008     1
#atom    242     2    C       "Glutamic Acid CD"          6     12.010     3
#atom    243    25    O2      "Glutamic Acid OE"          8     16.000     1
#atom    244    14    N       "Glutamine N"               7     14.010     3
#atom    245     1    CT      "Glutamine CA"              6     12.010     4
#atom    246     2    C       "Glutamine C"               6     12.010     3
#atom    247    29    H       "Glutamine HN"              1      1.008     1
#atom    248    24    O       "Glutamine O"               8     16.000     1
#atom    249    35    H1      "Glutamine HA"              1      1.008     1
#atom    250     1    CT      "Glutamine CB"              6     12.010     4
#atom    251    34    HC      "Glutamine HB"              1      1.008     1
#atom    252     1    CT      "Glutamine CG"              6     12.010     4
#atom    253    34    HC      "Glutamine HG"              1      1.008     1
#atom    254     2    C       "Glutamine CD"              6     12.010     3
#atom    255    24    O       "Glutamine OE1"             8     16.000     1
#atom    256    14    N       "Glutamine NE2"             7     14.010     3
#atom    257    29    H       "Glutamine HE2"             1      1.008     1
#atom    258    14    N       "Methionine N"              7     14.010     3
#atom    259     1    CT      "Methionine CA"             6     12.010     4
#atom    260     2    C       "Methionine C"              6     12.010     3
#atom    261    29    H       "Methionine HN"             1      1.008     1
#atom    262    24    O       "Methionine O"              8     16.000     1
#atom    263    35    H1      "Methionine HA"             1      1.008     1
#atom    264     1    CT      "Methionine CB"             6     12.010     4
#atom    265    34    HC      "Methionine HB"             1      1.008     1
#atom    266     1    CT      "Methionine CG"             6     12.010     4
#atom    267    35    H1      "Methionine HG"             1      1.008     1
#atom    268    26    S       "Methionine SD"            16     32.060     2
#atom    269     1    CT      "Methionine CE"             6     12.010     4
#atom    270    35    H1      "Methionine HE"             1      1.008     1
#atom    271    14    N       "Lysine N"                  7     14.010     3
#atom    272     1    CT      "Lysine CA"                 6     12.010     4
#atom    273     2    C       "Lysine C"                  6     12.010     3
#atom    274    29    H       "Lysine HN"                 1      1.008     1
#atom    275    24    O       "Lysine O"                  8     16.000     1
#atom    276    35    H1      "Lysine HA"                 1      1.008     1
#atom    277     1    CT      "Lysine CB"                 6     12.010     4
#atom    278    34    HC      "Lysine HB"                 1      1.008     1
#atom    279     1    CT      "Lysine CG"                 6     12.010     4
#atom    280    34    HC      "Lysine HG"                 1      1.008     1
#atom    281     1    CT      "Lysine CD"                 6     12.010     4
#atom    282    34    HC      "Lysine HD"                 1      1.008     1
#atom    283     1    CT      "Lysine CE"                 6     12.010     4
#atom    284    38    HP      "Lysine HE"                 1      1.008     1
#atom    285    20    N3      "Lysine NZ"                 7     14.010     4
#atom    286    29    H       "Lysine HZ"                 1      1.008     1
#atom    287    14    N       "Arginine N"                7     14.010     3
#atom    288     1    CT      "Arginine CA"               6     12.010     4
#atom    289     2    C       "Arginine C"                6     12.010     3
#atom    290    29    H       "Arginine HN"               1      1.008     1
#atom    291    24    O       "Arginine O"                8     16.000     1
#atom    292    35    H1      "Arginine HA"               1      1.008     1
#atom    293     1    CT      "Arginine CB"               6     12.010     4
#atom    294    34    HC      "Arginine HB"               1      1.008     1
#atom    295     1    CT      "Arginine CG"               6     12.010     4
#atom    296    34    HC      "Arginine HG"               1      1.008     1
#atom    297     1    CT      "Arginine CD"               6     12.010     4
#atom    298    35    H1      "Arginine HD"               1      1.008     1
#atom    299    19    N2      "Arginine NE"               7     14.010     3
#atom    300    29    H       "Arginine HE"               1      1.008     1
#atom    301     3    CA      "Arginine CZ"               6     12.010     3
#atom    302    19    N2      "Arginine NH"               7     14.010     3
#atom    303    29    H       "Arginine HH"               1      1.008     1
#atom    304    14    N       "Ornithine N"               7     14.010     3
#atom    305     1    CT      "Ornithine CA"              6     12.010     4
#atom    306     2    C       "Ornithine C"               6     12.010     3
#atom    307    29    H       "Ornithine HN"              1      1.008     1
#atom    308    24    O       "Ornithine O"               8     16.000     1
#atom    309    35    H1      "Ornithine HA"              1      1.008     1
#atom    310     1    CT      "Ornithine CB"              6     12.010     4
#atom    311    34    HC      "Ornithine HB"              1      1.008     1
#atom    312     1    CT      "Ornithine CG"              6     12.010     4
#atom    313    34    HC      "Ornithine HG"              1      1.008     1
#atom    314     1    CT      "Ornithine CD"              6     12.010     4
#atom    315    38    HP      "Ornithine HD"              1      1.008     1
#atom    316    20    N3      "Ornithine NE"              7     14.010     4
#atom    317    29    H       "Ornithine HE"              1      1.008     1
#atom    318    14    N       "MethylAlanine N"           7     14.010     3
#atom    319     1    CT      "MethylAlanine CA"          6     12.010     4
#atom    320     2    C       "MethylAlanine C"           6     12.010     3
#atom    321    29    H       "MethylAlanine HN"          1      1.008     1
#atom    322    24    O       "MethylAlanine O"           8     16.000     1
#atom    323     1    CT      "MethylAlanine CB"          6     12.010     4
#atom    324    34    HC      "MethylAlanine HB"          1      1.008     1
#atom    325    14    N       "Pyroglutamate N"           7     14.010     3
#atom    326     1    CT      "Pyroglutamate CA"          6     12.010     4
#atom    327     2    C       "Pyroglutamate C"           6     12.010     3
#atom    328    29    H       "Pyroglutamate HN"          1      1.008     1
#atom    329    24    O       "Pyroglutamate O"           8     16.000     1
#atom    330    35    H1      "Pyroglutamate HA"          1      1.008     1
#atom    331     1    CT      "Pyroglutamate CB"          6     12.010     4
#atom    332    34    HC      "Pyroglutamate HB"          1      1.008     1
#atom    333     1    CT      "Pyroglutamate CG"          6     12.010     4
#atom    334    34    HC      "Pyroglutamate HG"          1      1.008     1
#atom    335     2    C       "Pyroglutamate CD"          6     12.010     3
#atom    336    24    O       "Pyroglutamate OE"          8     16.000     1
#atom    337     2    C       "Formyl C"                  6     12.010     3
#atom    338     0    H       "Formyl H"                  1      1.008     1
#atom    339    24    O       "Formyl O"                  8     16.000     1
#atom    340     1    CT      "Acetyl CA"                 6     12.010     4
#atom    341    34    HC      "Acetyl HA"                 1      1.008     1
#atom    342     2    C       "Acetyl C"                  6     12.010     3
#atom    343    24    O       "Acetyl O"                  8     16.000     1
#atom    344    14    N       "C-Term Amide N"            7     14.010     3
#atom    345    29    H       "C-Term Amide HN"           1      1.008     1
#atom    346    14    N       "N-MeAmide N"               7     14.010     3
#atom    347    29    H       "N-MeAmide HN"              1      1.008     1
#atom    348     1    CT      "N-MeAmide C"               6     12.010     4
#atom    349    35    H1      "N-MeAmide HC"              1      1.008     1
#atom    350    20    N3      "N-Term GLY N"              7     14.010     4
#atom    351     1    CT      "N-Term GLY CA"             6     12.010     4
#atom    352     2    C       "N-Term GLY C"              6     12.010     3
#atom    353    29    H       "N-Term GLY HN"             1      1.008     1
#atom    354    24    O       "N-Term GLY O"              8     16.000     1
#atom    355    35    H1      "N-Term GLY HA"             1      1.008     1
#atom    356    20    N3      "N-Term ALA N"              7     14.010     4
#atom    357     1    CT      "N-Term ALA CA"             6     12.010     4
#atom    358     2    C       "N-Term ALA C"              6     12.010     3
#atom    359    29    H       "N-Term ALA HN"             1      1.008     1
#atom    360    24    O       "N-Term ALA O"              8     16.000     1
#atom    361    35    H1      "N-Term ALA HA"             1      1.008     1
#atom    362    20    N3      "N-Term VAL N"              7     14.010     4
#atom    363     1    CT      "N-Term VAL CA"             6     12.010     4
#atom    364     2    C       "N-Term VAL C"              6     12.010     3
#atom    365    29    H       "N-Term VAL HN"             1      1.008     1
#atom    366    24    O       "N-Term VAL O"              8     16.000     1
#atom    367    35    H1      "N-Term VAL HA"             1      1.008     1
#atom    368    20    N3      "N-Term LEU N"              7     14.010     4
#atom    369     1    CT      "N-Term LEU CA"             6     12.010     4
#atom    370     2    C       "N-Term LEU C"              6     12.010     3
#atom    371    29    H       "N-Term LEU HN"             1      1.008     1
#atom    372    24    O       "N-Term LEU O"              8     16.000     1
#atom    373    35    H1      "N-Term LEU HA"             1      1.008     1
#atom    374    20    N3      "N-Term ILE N"              7     14.010     4
#atom    375     1    CT      "N-Term ILE CA"             6     12.010     4
#atom    376     2    C       "N-Term ILE C"              6     12.010     3
#atom    377    29    H       "N-Term ILE HN"             1      1.008     1
#atom    378    24    O       "N-Term ILE O"              8     16.000     1
#atom    379    35    H1      "N-Term ILE HA"             1      1.008     1
#atom    380    20    N3      "N-Term SER N"              7     14.010     4
#atom    381     1    CT      "N-Term SER CA"             6     12.010     4
#atom    382     2    C       "N-Term SER C"              6     12.010     3
#atom    383    29    H       "N-Term SER HN"             1      1.008     1
#atom    384    24    O       "N-Term SER O"              8     16.000     1
#atom    385    35    H1      "N-Term SER HA"             1      1.008     1
#atom    386    20    N3      "N-Term THR N"              7     14.010     4
#atom    387     1    CT      "N-Term THR CA"             6     12.010     4
#atom    388     2    C       "N-Term THR C"              6     12.010     3
#atom    389    29    H       "N-Term THR HN"             1      1.008     1
#atom    390    24    O       "N-Term THR O"              8     16.000     1
#atom    391    35    H1      "N-Term THR HA"             1      1.008     1
#atom    392    20    N3      "N-Term CYS (-SH) N"        7     14.010     4
#atom    393     1    CT      "N-Term CYS (-SH) CA"       6     12.010     4
#atom    394     2    C       "N-Term CYS (-SH) C"        6     12.010     3
#atom    395    29    H       "N-Term CYS (-SH) HN"       1      1.008     1
#atom    396    24    O       "N-Term CYS (-SH) O"        8     16.000     1
#atom    397    35    H1      "N-Term CYS (-SH) HA"       1      1.008     1
#atom    398    20    N3      "N-Term CYS (-SS-) N"       7     14.010     4
#atom    399     1    CT      "N-Term CYS (-SS-) CA"      6     12.010     4
#atom    400     2    C       "N-Term CYS (-SS-) C"       6     12.010     3
#atom    401    29    H       "N-Term CYS (-SS-) HN"      1      1.008     1
#atom    402    24    O       "N-Term CYS (-SS-) O"       8     16.000     1
#atom    403    35    H1      "N-Term CYS (-SS-) HA"      1      1.008     1
#atom    404    20    N3      "N-Term PRO N"              7     14.010     4
#atom    405     1    CT      "N-Term PRO CA"             6     12.010     4
#atom    406     2    C       "N-Term PRO C"              6     12.010     3
#atom    407    29    H       "N-Term PRO HN"             1      1.008     1
#atom    408    24    O       "N-Term PRO O"              8     16.000     1
#atom    409    35    H1      "N-Term PRO HA"             1      1.008     1
#atom    410     1    CT      "N-Term PRO CD"             6     12.010     4
#atom    411    38    HP      "N-Term PRO HD"             1      1.008     1
#atom    412    20    N3      "N-Term PHE N"              7     14.010     4
#atom    413     1    CT      "N-Term PHE CA"             6     12.010     4
#atom    414     2    C       "N-Term PHE C"              6     12.010     3
#atom    415    29    H       "N-Term PHE HN"             1      1.008     1
#atom    416    24    O       "N-Term PHE O"              8     16.000     1
#atom    417    35    H1      "N-Term PHE HA"             1      1.008     1
#atom    418    20    N3      "N-Term TYR N"              7     14.010     4
#atom    419     1    CT      "N-Term TYR CA"             6     12.010     4
#atom    420     2    C       "N-Term TYR C"              6     12.010     3
#atom    421    29    H       "N-Term TYR HN"             1      1.008     1
#atom    422    24    O       "N-Term TYR O"              8     16.000     1
#atom    423    35    H1      "N-Term TYR HA"             1      1.008     1
#atom    424    20    N3      "N-Term TRP N"              7     14.010     4
#atom    425     1    CT      "N-Term TRP CA"             6     12.010     4
#atom    426     2    C       "N-Term TRP C"              6     12.010     3
#atom    427    29    H       "N-Term TRP HN"             1      1.008     1
#atom    428    24    O       "N-Term TRP O"              8     16.000     1
#atom    429    35    H1      "N-Term TRP HA"             1      1.008     1
#atom    430    20    N3      "N-Term HIS (+) N"          7     14.010     4
#atom    431     1    CT      "N-Term HIS (+) CA"         6     12.010     4
#atom    432     2    C       "N-Term HIS (+) C"          6     12.010     3
#atom    433    29    H       "N-Term HIS (+) HN"         1      1.008     1
#atom    434    24    O       "N-Term HIS (+) O"          8     16.000     1
#atom    435    35    H1      "N-Term HIS (+) HA"         1      1.008     1
#atom    436    20    N3      "N-Term HIS (HD) N"         7     14.010     4
#atom    437     1    CT      "N-Term HIS (HD) CA"        6     12.010     4
#atom    438     2    C       "N-Term HIS (HD) C"         6     12.010     3
#atom    439    29    H       "N-Term HIS (HD) HN"        1      1.008     1
#atom    440    24    O       "N-Term HIS (HD) O"         8     16.000     1
#atom    441    35    H1      "N-Term HIS (HD) HA"        1      1.008     1
#atom    442    20    N3      "N-Term HIS (HE) N"         7     14.010     4
#atom    443     1    CT      "N-Term HIS (HE) CA"        6     12.010     4
#atom    444     2    C       "N-Term HIS (HE) C"         6     12.010     3
#atom    445    29    H       "N-Term HIS (HE) HN"        1      1.008     1
#atom    446    24    O       "N-Term HIS (HE) O"         8     16.000     1
#atom    447    35    H1      "N-Term HIS (HE) HA"        1      1.008     1
#atom    448    20    N3      "N-Term ASP N"              7     14.010     4
#atom    449     1    CT      "N-Term ASP CA"             6     12.010     4
#atom    450     2    C       "N-Term ASP C"              6     12.010     3
#atom    451    29    H       "N-Term ASP HN"             1      1.008     1
#atom    452    24    O       "N-Term ASP O"              8     16.000     1
#atom    453    35    H1      "N-Term ASP HA"             1      1.008     1
#atom    454    20    N3      "N-Term ASN N"              7     14.010     4
#atom    455     1    CT      "N-Term ASN CA"             6     12.010     4
#atom    456     2    C       "N-Term ASN C"              6     12.010     3
#atom    457    29    H       "N-Term ASN HN"             1      1.008     1
#atom    458    24    O       "N-Term ASN O"              8     16.000     1
#atom    459    35    H1      "N-Term ASN HA"             1      1.008     1
#atom    460    20    N3      "N-Term GLU N"              7     14.010     4
#atom    461     1    CT      "N-Term GLU CA"             6     12.010     4
#atom    462     2    C       "N-Term GLU C"              6     12.010     3
#atom    463    29    H       "N-Term GLU HN"             1      1.008     1
#atom    464    24    O       "N-Term GLU O"              8     16.000     1
#atom    465    35    H1      "N-Term GLU HA"             1      1.008     1
#atom    466    20    N3      "N-Term GLN N"              7     14.010     4
#atom    467     1    CT      "N-Term GLN CA"             6     12.010     4
#atom    468     2    C       "N-Term GLN C"              6     12.010     3
#atom    469    29    H       "N-Term GLN HN"             1      1.008     1
#atom    470    24    O       "N-Term GLN O"              8     16.000     1
#atom    471    35    H1      "N-Term GLN HA"             1      1.008     1
#atom    472    20    N3      "N-Term MET N"              7     14.010     4
#atom    473     1    CT      "N-Term MET CA"             6     12.010     4
#atom    474     2    C       "N-Term MET C"              6     12.010     3
#atom    475    29    H       "N-Term MET HN"             1      1.008     1
#atom    476    24    O       "N-Term MET O"              8     16.000     1
#atom    477    35    H1      "N-Term MET HA"             1      1.008     1
#atom    478    20    N3      "N-Term LYS N"              7     14.010     4
#atom    479     1    CT      "N-Term LYS CA"             6     12.010     4
#atom    480     2    C       "N-Term LYS C"              6     12.010     3
#atom    481    29    H       "N-Term LYS HN"             1      1.008     1
#atom    482    24    O       "N-Term LYS O"              8     16.000     1
#atom    483    35    H1      "N-Term LYS HA"             1      1.008     1
#atom    484    20    N3      "N-Term ARG N"              7     14.010     4
#atom    485     1    CT      "N-Term ARG CA"             6     12.010     4
#atom    486     2    C       "N-Term ARG C"              6     12.010     3
#atom    487    29    H       "N-Term ARG HN"             1      1.008     1
#atom    488    24    O       "N-Term ARG O"              8     16.000     1
#atom    489    35    H1      "N-Term ARG HA"             1      1.008     1
#atom    490    20    N3      "N-Term ORN N"              7     14.010     4
#atom    491     1    CT      "N-Term ORN CA"             6     12.010     4
#atom    492     2    C       "N-Term ORN C"              6     12.010     3
#atom    493    29    H       "N-Term ORN HN"             1      1.008     1
#atom    494    24    O       "N-Term ORN O"              8     16.000     1
#atom    495    35    H1      "N-Term ORN HA"             1      1.008     1
#atom    496    20    N3      "N-Term AIB N"              7     14.010     4
#atom    497     1    CT      "N-Term AIB CA"             6     12.010     4
#atom    498     2    C       "N-Term AIB C"              6     12.010     3
#atom    499    29    H       "N-Term AIB HN"             1      1.008     1
#atom    500    24    O       "N-Term AIB O"              8     16.000     1
#atom    501    14    N       "C-Term GLY N"              7     14.010     3
#atom    502     1    CT      "C-Term GLY CA"             6     12.010     4
#atom    503     2    C       "C-Term GLY C"              6     12.010     3
#atom    504    29    H       "C-Term GLY HN"             1      1.008     1
#atom    505    25    O2      "C-Term GLY OXT"            8     16.000     1
#atom    506    35    H1      "C-Term GLY HA"             1      1.008     1
#atom    507    14    N       "C-Term ALA N"              7     14.010     3
#atom    508     1    CT      "C-Term ALA CA"             6     12.010     4
#atom    509     2    C       "C-Term ALA C"              6     12.010     3
#atom    510    29    H       "C-Term ALA HN"             1      1.008     1
#atom    511    25    O2      "C-Term ALA OXT"            8     16.000     1
#atom    512    35    H1      "C-Term ALA HA"             1      1.008     1
#atom    513    14    N       "C-Term VAL N"              7     14.010     3
#atom    514     1    CT      "C-Term VAL CA"             6     12.010     4
#atom    515     2    C       "C-Term VAL C"              6     12.010     3
#atom    516    29    H       "C-Term VAL HN"             1      1.008     1
#atom    517    25    O2      "C-Term VAL OXT"            8     16.000     1
#atom    518    35    H1      "C-Term VAL HA"             1      1.008     1
#atom    519    14    N       "C-Term LEU N"              7     14.010     3
#atom    520     1    CT      "C-Term LEU CA"             6     12.010     4
#atom    521     2    C       "C-Term LEU C"              6     12.010     3
#atom    522    29    H       "C-Term LEU HN"             1      1.008     1
#atom    523    25    O2      "C-Term LEU OXT"            8     16.000     1
#atom    524    35    H1      "C-Term LEU HA"             1      1.008     1
#atom    525    14    N       "C-Term ILE N"              7     14.010     3
#atom    526     1    CT      "C-Term ILE CA"             6     12.010     4
#atom    527     2    C       "C-Term ILE C"              6     12.010     3
#atom    528    29    H       "C-Term ILE HN"             1      1.008     1
#atom    529    25    O2      "C-Term ILE OXT"            8     16.000     1
#atom    530    35    H1      "C-Term ILE HA"             1      1.008     1
#atom    531    14    N       "C-Term SER N"              7     14.010     3
#atom    532     1    CT      "C-Term SER CA"             6     12.010     4
#atom    533     2    C       "C-Term SER C"              6     12.010     3
#atom    534    29    H       "C-Term SER HN"             1      1.008     1
#atom    535    25    O2      "C-Term SER OXT"            8     16.000     1
#atom    536    35    H1      "C-Term SER HA"             1      1.008     1
#atom    537    14    N       "C-Term THR N"              7     14.010     3
#atom    538     1    CT      "C-Term THR CA"             6     12.010     4
#atom    539     2    C       "C-Term THR C"              6     12.010     3
#atom    540    29    H       "C-Term THR HN"             1      1.008     1
#atom    541    25    O2      "C-Term THR OXT"            8     16.000     1
#atom    542    35    H1      "C-Term THR HA"             1      1.008     1
#atom    543    14    N       "C-Term CYS (-SH) N"        7     14.010     3
#atom    544     1    CT      "C-Term CYS (-SH) CA"       6     12.010     4
#atom    545     2    C       "C-Term CYS (-SH) C"        6     12.010     3
#atom    546    29    H       "C-Term CYS (-SH) HN"       1      1.008     1
#atom    547    25    O2      "C-Term CYS (-SH) OXT"      8     16.000     1
#atom    548    35    H1      "C-Term CYS (-SH) HA"       1      1.008     1
#atom    549    14    N       "C-Term CYS (-SS-) N"       7     14.010     3
#atom    550     1    CT      "C-Term CYS (-SS-) CA"      6     12.010     4
#atom    551     2    C       "C-Term CYS (-SS-) C"       6     12.010     3
#atom    552    29    H       "C-Term CYS (-SS-) HN"      1      1.008     1
#atom    553    25    O2      "C-Term CYS (-SS-) OXT"     8     16.000     1
#atom    554    35    H1      "C-Term CYS (-SS-) HA"      1      1.008     1
#atom    555    14    N       "C-Term PRO N"              7     14.010     3
#atom    556     1    CT      "C-Term PRO CA"             6     12.010     4
#atom    557     2    C       "C-Term PRO C"              6     12.010     3
#atom    558    25    O2      "C-Term PRO OXT"            8     16.000     1
#atom    559    35    H1      "C-Term PRO HA"             1      1.008     1
#atom    560    14    N       "C-Term PHE N"              7     14.010     3
#atom    561     1    CT      "C-Term PHE CA"             6     12.010     4
#atom    562     2    C       "C-Term PHE C"              6     12.010     3
#atom    563    29    H       "C-Term PHE HN"             1      1.008     1
#atom    564    25    O2      "C-Term PHE OXT"            8     16.000     1
#atom    565    35    H1      "C-Term PHE HA"             1      1.008     1
#atom    566    14    N       "C-Term TYR N"              7     14.010     3
#atom    567     1    CT      "C-Term TYR CA"             6     12.010     4
#atom    568     2    C       "C-Term TYR C"              6     12.010     3
#atom    569    29    H       "C-Term TYR HN"             1      1.008     1
#atom    570    25    O2      "C-Term TYR OXT"            8     16.000     1
#atom    571    35    H1      "C-Term TYR HA"             1      1.008     1
#atom    572    14    N       "C-Term TRP N"              7     14.010     3
#atom    573     1    CT      "C-Term TRP CA"             6     12.010     4
#atom    574     2    C       "C-Term TRP C"              6     12.010     3
#atom    575    29    H       "C-Term TRP HN"             1      1.008     1
#atom    576    25    O2      "C-Term TRP OXT"            8     16.000     1
#atom    577    35    H1      "C-Term TRP HA"             1      1.008     1
#atom    578    14    N       "C-Term HIS (+) N"          7     14.010     3
#atom    579     1    CT      "C-Term HIS (+) CA"         6     12.010     4
#atom    580     2    C       "C-Term HIS (+) C"          6     12.010     3
#atom    581    29    H       "C-Term HIS (+) HN"         1      1.008     1
#atom    582    25    O2      "C-Term HIS (+) OXT"        8     16.000     1
#atom    583    35    H1      "C-Term HIS (+) HA"         1      1.008     1
#atom    584    14    N       "C-Term HIS (HD) N"         7     14.010     3
#atom    585     1    CT      "C-Term HIS (HD) CA"        6     12.010     4
#atom    586     2    C       "C-Term HIS (HD) C"         6     12.010     3
#atom    587    29    H       "C-Term HIS (HD) HN"        1      1.008     1
#atom    588    25    O2      "C-Term HIS (HD) OXT"       8     16.000     1
#atom    589    35    H1      "C-Term HIS (HD) HA"        1      1.008     1
#atom    590    14    N       "C-Term HIS (HE) N"         7     14.010     3
#atom    591     1    CT      "C-Term HIS (HE) CA"        6     12.010     4
#atom    592     2    C       "C-Term HIS (HE) C"         6     12.010     3
#atom    593    29    H       "C-Term HIS (HE) HN"        1      1.008     1
#atom    594    25    O2      "C-Term HIS (HE) OXT"       8     16.000     1
#atom    595    35    H1      "C-Term HIS (HE) HA"        1      1.008     1
#atom    596    14    N       "C-Term ASP N"              7     14.010     3
#atom    597     1    CT      "C-Term ASP CA"             6     12.010     4
#atom    598     2    C       "C-Term ASP C"              6     12.010     3
#atom    599    29    H       "C-Term ASP HN"             1      1.008     1
#atom    600    25    O2      "C-Term ASP OXT"            8     16.000     1
#atom    601    35    H1      "C-Term ASP HA"             1      1.008     1
#atom    602    14    N       "C-Term ASN N"              7     14.010     3
#atom    603     1    CT      "C-Term ASN CA"             6     12.010     4
#atom    604     2    C       "C-Term ASN C"              6     12.010     3
#atom    605    29    H       "C-Term ASN HN"             1      1.008     1
#atom    606    25    O2      "C-Term ASN OXT"            8     16.000     1
#atom    607    35    H1      "C-Term ASN HA"             1      1.008     1
#atom    608    14    N       "C-Term GLU N"              7     14.010     3
#atom    609     1    CT      "C-Term GLU CA"             6     12.010     4
#atom    610     2    C       "C-Term GLU C"              6     12.010     3
#atom    611    29    H       "C-Term GLU HN"             1      1.008     1
#atom    612    25    O2      "C-Term GLU OXT"            8     16.000     1
#atom    613    35    H1      "C-Term GLU HA"             1      1.008     1
#atom    614    14    N       "C-Term GLN N"              7     14.010     3
#atom    615     1    CT      "C-Term GLN CA"             6     12.010     4
#atom    616     2    C       "C-Term GLN C"              6     12.010     3
#atom    617    29    H       "C-Term GLN HN"             1      1.008     1
#atom    618    25    O2      "C-Term GLN OXT"            8     16.000     1
#atom    619    35    H1      "C-Term GLN HA"             1      1.008     1
#atom    620    14    N       "C-Term MET N"              7     14.010     3
#atom    621     1    CT      "C-Term MET CA"             6     12.010     4
#atom    622     2    C       "C-Term MET C"              6     12.010     3
#atom    623    29    H       "C-Term MET HN"             1      1.008     1
#atom    624    25    O2      "C-Term MET OXT"            8     16.000     1
#atom    625    35    H1      "C-Term MET HA"             1      1.008     1
#atom    626    14    N       "C-Term LYS N"              7     14.010     3
#atom    627     1    CT      "C-Term LYS CA"             6     12.010     4
#atom    628     2    C       "C-Term LYS C"              6     12.010     3
#atom    629    29    H       "C-Term LYS HN"             1      1.008     1
#atom    630    25    O2      "C-Term LYS OXT"            8     16.000     1
#atom    631    35    H1      "C-Term LYS HA"             1      1.008     1
#atom    632    14    N       "C-Term ARG N"              7     14.010     3
#atom    633     1    CT      "C-Term ARG CA"             6     12.010     4
#atom    634     2    C       "C-Term ARG C"              6     12.010     3
#atom    635    29    H       "C-Term ARG HN"             1      1.008     1
#atom    636    25    O2      "C-Term ARG OXT"            8     16.000     1
#atom    637    35    H1      "C-Term ARG HA"             1      1.008     1
#atom    638    14    N       "C-Term ORN N"              7     14.010     3
#atom    639     1    CT      "C-Term ORN CA"             6     12.010     4
#atom    640     2    C       "C-Term ORN C"              6     12.010     3
#atom    641    29    H       "C-Term ORN HN"             1      1.008     1
#atom    642    25    O2      "C-Term ORN OXT"            8     16.000     1
#atom    643    35    H1      "C-Term ORN HA"             1      1.008     1
#atom    644    14    N       "C-Term AIB N"              7     14.010     3
#atom    645     1    CT      "C-Term AIB CA"             6     12.010     4
#atom    646     2    C       "C-Term AIB C"              6     12.010     3
#atom    647    29    H       "C-Term AIB HN"             1      1.008     1
#atom    648    25    O2      "C-Term AIB OXT"            8     16.000     1

#atom   1001    23    OS      "R-Adenosine O5'"           8     16.000     2
#atom   1002     1    CT      "R-Adenosine C5'"           6     12.010     4
#atom   1003    35    H1      "R-Adenosine H5'1"          1      1.008     1
#atom   1004    35    H1      "R-Adenosine H5'2"          1      1.008     1
#atom   1005     1    CT      "R-Adenosine C4'"           6     12.010     4
#atom   1006    35    H1      "R-Adenosine H4'"           1      1.008     1
#atom   1007    23    OS      "R-Adenosine O4'"           8     16.000     2
#atom   1008     1    CT      "R-Adenosine C1'"           6     12.010     4
#atom   1009    36    H2      "R-Adenosine H1'"           1      1.008     1
#atom   1010     1    CT      "R-Adenosine C3'"           6     12.010     4
#atom   1011    35    H1      "R-Adenosine H3'"           1      1.008     1
#atom   1012     1    CT      "R-Adenosine C2'"           6     12.010     4
#atom   1013    35    H1      "R-Adenosine H2'1"          1      1.008     1
#atom   1014    22    OH      "R-Adenosine O2'"           8     16.000     2
#atom   1015    31    HO      "R-Adenosine HO'2"          1      1.008     1
#atom   1016    23    OS      "R-Adenosine O3'"           8     16.000     2
#atom   1017    18    N*      "R-Adenosine N9"            7     14.010     3
#atom   1018     9    CB      "R-Adenosine C4"            6     12.010     3
#atom   1019     9    CB      "R-Adenosine C5"            6     12.010     3
#atom   1020    16    NB      "R-Adenosine N7"            7     14.010     2
#atom   1021    12    CK      "R-Adenosine C8"            6     12.010     3
#atom   1022    17    NC      "R-Adenosine N3"            7     14.010     2
#atom   1023    13    CQ      "R-Adenosine C2"            6     12.010     3
#atom   1024    17    NC      "R-Adenosine N1"            7     14.010     2
#atom   1025     3    CA      "R-Adenosine C6"            6     12.010     3
#atom   1026    40    H5      "R-Adenosine H2"            1      1.008     1
#atom   1027    19    N2      "R-Adenosine N6"            7     14.010     3
#atom   1028    29    H       "R-Adenosine H61"           1      1.008     1
#atom   1029    29    H       "R-Adenosine H62"           1      1.008     1
#atom   1030    40    H5      "R-Adenosine H8"            1      1.008     1
#atom   1031    23    OS      "R-Guanosine O5'"           8     16.000     2
#atom   1032     1    CT      "R-Guanosine C5'"           6     12.010     4
#atom   1033    35    H1      "R-Guanosine H5'1"          1      1.008     1
#atom   1034    35    H1      "R-Guanosine H5'2"          1      1.008     1
#atom   1035     1    CT      "R-Guanosine C4'"           6     12.010     4
#atom   1036    35    H1      "R-Guanosine H4'"           1      1.008     1
#atom   1037    23    OS      "R-Guanosine O4'"           8     16.000     2
#atom   1038     1    CT      "R-Guanosine C1'"           6     12.010     4
#atom   1039    36    H2      "R-Guanosine H1'"           1      1.008     1
#atom   1040     1    CT      "R-Guanosine C3'"           6     12.010     4
#atom   1041    35    H1      "R-Guanosine H3'"           1      1.008     1
#atom   1042     1    CT      "R-Guanosine C2'"           6     12.010     4
#atom   1043    35    H1      "R-Guanosine H2'1"          1      1.008     1
#atom   1044    22    OH      "R-Guanosine O2'"           8     16.000     2
#atom   1045    31    HO      "R-Guanosine HO'2"          1      1.008     1
#atom   1046    23    OS      "R-Guanosine O3'"           8     16.000     2
#atom   1047    18    N*      "R-Guanosine N9"            7     14.010     3
#atom   1048     9    CB      "R-Guanosine C4"            6     12.010     3
#atom   1049     9    CB      "R-Guanosine C5"            6     12.010     3
#atom   1050    16    NB      "R-Guanosine N7"            7     14.010     2
#atom   1051    12    CK      "R-Guanosine C8"            6     12.010     3
#atom   1052    17    NC      "R-Guanosine N3"            7     14.010     2
#atom   1053     3    CA      "R-Guanosine C2"            6     12.010     3
#atom   1054    15    NA      "R-Guanosine N1"            7     14.010     3
#atom   1055     2    C       "R-Guanosine C6"            6     12.010     3
#atom   1056    29    H       "R-Guanosine H1"            1      1.008     1
#atom   1057    19    N2      "R-Guanosine N2"            7     14.010     3
#atom   1058    29    H       "R-Guanosine H21"           1      1.008     1
#atom   1059    29    H       "R-Guanosine H22"           1      1.008     1
#atom   1060    24    O       "R-Guanosine O6"            8     16.000     1
#atom   1061    40    H5      "R-Guanosine H8"            1      1.008     1
#atom   1062    23    OS      "R-Cytosine O5'"            8     16.000     2
#atom   1063     1    CT      "R-Cytosine C5'"            6     12.010     4
#atom   1064    35    H1      "R-Cytosine H5'1"           1      1.008     1
#atom   1065    35    H1      "R-Cytosine H5'2"           1      1.008     1
#atom   1066     1    CT      "R-Cytosine C4'"            6     12.010     4
#atom   1067    35    H1      "R-Cytosine H4'"            1      1.008     1
#atom   1068    23    OS      "R-Cytosine O4'"            8     16.000     2
#atom   1069     1    CT      "R-Cytosine C1'"            6     12.010     4
#atom   1070    36    H2      "R-Cytosine H1'"            1      1.008     1
#atom   1071     1    CT      "R-Cytosine C3'"            6     12.010     4
#atom   1072    35    H1      "R-Cytosine H3'"            1      1.008     1
#atom   1073     1    CT      "R-Cytosine C2'"            6     12.010     4
#atom   1074    35    H1      "R-Cytosine H2'1"           1      1.008     1
#atom   1075    22    OH      "R-Cytosine O2'"            8     16.000     2
#atom   1076    31    HO      "R-Cytosine HO'2"           1      1.008     1
#atom   1077    23    OS      "R-Cytosine O3'"            8     16.000     2
#atom   1078    18    N*      "R-Cytosine N1"             7     14.010     3
#atom   1079     2    C       "R-Cytosine C2"             6     12.010     3
#atom   1080    17    NC      "R-Cytosine N3"             7     14.010     2
#atom   1081     3    CA      "R-Cytosine C4"             6     12.010     3
#atom   1082     4    CM      "R-Cytosine C5"             6     12.010     3
#atom   1083     4    CM      "R-Cytosine C6"             6     12.010     3
#atom   1084    24    O       "R-Cytosine O2"             8     16.000     1
#atom   1085    19    N2      "R-Cytosine N4"             7     14.010     3
#atom   1086    29    H       "R-Cytosine H41"            1      1.008     1
#atom   1087    29    H       "R-Cytosine H42"            1      1.008     1
#atom   1088    33    HA      "R-Cytosine H5"             1      1.008     1
#atom   1089    39    H4      "R-Cytosine H6"             1      1.008     1
#atom   1090    23    OS      "R-Uracil O5'"              8     16.000     2
#atom   1091     1    CT      "R-Uracil C5'"              6     12.010     4
#atom   1092    35    H1      "R-Uracil H5'1"             1      1.008     1
#atom   1093    35    H1      "R-Uracil H5'2"             1      1.008     1
#atom   1094     1    CT      "R-Uracil C4'"              6     12.010     4
#atom   1095    35    H1      "R-Uracil H4'"              1      1.008     1
#atom   1096    23    OS      "R-Uracil O4'"              8     16.000     2
#atom   1097     1    CT      "R-Uracil C1'"              6     12.010     4
#atom   1098    36    H2      "R-Uracil H1'"              1      1.008     1
#atom   1099     1    CT      "R-Uracil C3'"              6     12.010     4
#atom   1100    35    H1      "R-Uracil H3'"              1      1.008     1
#atom   1101     1    CT      "R-Uracil C2'"              6     12.010     4
#atom   1102    35    H1      "R-Uracil H2'1"             1      1.008     1
#atom   1103    22    OH      "R-Uracil O2'"              8     16.000     2
#atom   1104    31    HO      "R-Uracil HO'2"             1      1.008     1
#atom   1105    23    OS      "R-Uracil O3'"              8     16.000     2
#atom   1106    18    N*      "R-Uracil N1"               7     14.010     3
#atom   1107     2    C       "R-Uracil C2"               6     12.010     3
#atom   1108    15    NA      "R-Uracil N3"               7     14.010     3
#atom   1109     2    C       "R-Uracil C4"               6     12.010     3
#atom   1110     4    CM      "R-Uracil C5"               6     12.010     3
#atom   1111     4    CM      "R-Uracil C6"               6     12.010     3
#atom   1112    24    O       "R-Uracil O2"               8     16.000     1
#atom   1113    29    H       "R-Uracil H3"               1      1.008     1
#atom   1114    24    O       "R-Uracil O4"               8     16.000     1
#atom   1115    33    HA      "R-Uracil H5"               1      1.008     1
#atom   1116    39    H4      "R-Uracil H6"               1      1.008     1
#atom   1117    23    OS      "D-Adenosine O5'"           8     16.000     2
#atom   1118     1    CT      "D-Adenosine C5'"           6     12.010     4
#atom   1119    35    H1      "D-Adenosine H5'1"          1      1.008     1
#atom   1120    35    H1      "D-Adenosine H5'2"          1      1.008     1
#atom   1121     1    CT      "D-Adenosine C4'"           6     12.010     4
#atom   1122    35    H1      "D-Adenosine H4'"           1      1.008     1
#atom   1123    23    OS      "D-Adenosine O4'"           8     16.000     2
#atom   1124     1    CT      "D-Adenosine C1'"           6     12.010     4
#atom   1125    36    H2      "D-Adenosine H1'"           1      1.008     1
#atom   1126     1    CT      "D-Adenosine C3'"           6     12.010     4
#atom   1127    35    H1      "D-Adenosine H3'"           1      1.008     1
#atom   1128     1    CT      "D-Adenosine C2'"           6     12.010     4
#atom   1129    34    HC      "D-Adenosine H2'1"          1      1.008     1
#atom   1130    34    HC      "D-Adenosine H2'2"          1      1.008     1
#atom   1131    23    OS      "D-Adenosine O3'"           8     16.000     2
#atom   1132    18    N*      "D-Adenosine N9"            7     14.010     3
#atom   1133     9    CB      "D-Adenosine C4"            6     12.010     3
#atom   1134     9    CB      "D-Adenosine C5"            6     12.010     3
#atom   1135    16    NB      "D-Adenosine N7"            7     14.010     2
#atom   1136    12    CK      "D-Adenosine C8"            6     12.010     3
#atom   1137    17    NC      "D-Adenosine N3"            7     14.010     2
#atom   1138    13    CQ      "D-Adenosine C2"            6     12.010     3
#atom   1139    17    NC      "D-Adenosine N1"            7     14.010     2
#atom   1140     3    CA      "D-Adenosine C6"            6     12.000     3
#atom   1141    40    H5      "D-Adenosine H2"            1      1.008     1
#atom   1142    19    N2      "D-Adenosine N6"            7     14.010     3
#atom   1143    29    H       "D-Adenosine H61"           1      1.008     1
#atom   1144    29    H       "D-Adenosine H62"           1      1.008     1
#atom   1145    40    H5      "D-Adenosine H8"            1      1.008     1
#atom   1146    23    OS      "D-Guanosine O5'"           8     16.000     2
#atom   1147     1    CT      "D-Guanosine C5'"           6     12.010     4
#atom   1148    35    H1      "D-Guanosine H5'1"          1      1.008     1
#atom   1149    35    H1      "D-Guanosine H5'2"          1      1.008     1
#atom   1150     1    CT      "D-Guanosine C4'"           6     12.010     4
#atom   1151    35    H1      "D-Guanosine H4'"           1      1.008     1
#atom   1152    23    OS      "D-Guanosine O4'"           8     16.000     2
#atom   1153     1    CT      "D-Guanosine C1'"           6     12.010     4
#atom   1154    36    H2      "D-Guanosine H1'"           1      1.008     1
#atom   1155     1    CT      "D-Guanosine C3'"           6     12.010     4
#atom   1156    35    H1      "D-Guanosine H3'"           1      1.008     1
#atom   1157     1    CT      "D-Guanosine C2'"           6     12.010     4
#atom   1158    34    HC      "D-Guanosine H2'1"          1      1.008     1
#atom   1159    34    HC      "D-Guanosine H2'2"          1      1.008     1
#atom   1160    23    OS      "D-Guanosine O3'"           8     16.000     2
#atom   1161    18    N*      "D-Guanosine N9"            7     14.010     3
#atom   1162     9    CB      "D-Guanosine C4"            6     12.010     3
#atom   1163     9    CB      "D-Guanosine C5"            6     12.010     3
#atom   1164    16    NB      "D-Guanosine N7"            7     14.010     2
#atom   1165    12    CK      "D-Guanosine C8"            6     12.010     3
#atom   1166    17    NC      "D-Guanosine N3"            7     14.010     2
#atom   1167     3    CA      "D-Guanosine C2"            6     12.010     3
#atom   1168    15    NA      "D-Guanosine N1"            7     14.010     3
#atom   1169     2    C       "D-Guanosine C6"            6     12.010     3
#atom   1170    29    H       "D-Guanosine H1"            1      1.008     1
#atom   1171    19    N2      "D-Guanosine N2"            7     14.010     3
#atom   1172    29    H       "D-Guanosine H21"           1      1.008     1
#atom   1173    29    H       "D-Guanosine H22"           1      1.008     1
#atom   1174    24    O       "D-Guanosine O6"            8     16.000     1
#atom   1175    40    H5      "D-Guanosine H8"            1      1.008     1
#atom   1176    23    OS      "D-Cytosine O5'"            8     16.000     2
#atom   1177     1    CT      "D-Cytosine C5'"            6     12.010     4
#atom   1178    35    H1      "D-Cytosine H5'1"           1      1.008     1
#atom   1179    35    H1      "D-Cytosine H5'2"           1      1.008     1
#atom   1180     1    CT      "D-Cytosine C4'"            6     12.010     4
#atom   1181    35    H1      "D-Cytosine H4'"            1      1.008     1
#atom   1182    23    OS      "D-Cytosine O4'"            8     16.000     2
#atom   1183     1    CT      "D-Cytosine C1'"            6     12.010     4
#atom   1184    36    H2      "D-Cytosine H1'"            1      1.008     1
#atom   1185     1    CT      "D-Cytosine C3'"            6     12.010     4
#atom   1186    35    H1      "D-Cytosine H3'"            1      1.008     1
#atom   1187     1    CT      "D-Cytosine C2'"            6     12.010     4
#atom   1188    34    HC      "D-Cytosine H2'1"           1      1.008     1
#atom   1189    34    HC      "D-Cytosine H2'2"           1      1.008     1
#atom   1190    23    OS      "D-Cytosine O3'"            8     16.000     2
#atom   1191    18    N*      "D-Cytosine N1"             7     14.010     3
#atom   1192     2    C       "D-Cytosine C2"             6     12.010     3
#atom   1193    17    NC      "D-Cytosine N3"             7     14.010     2
#atom   1194     3    CA      "D-Cytosine C4"             6     12.010     3
#atom   1195     4    CM      "D-Cytosine C5"             6     12.010     3
#atom   1196     4    CM      "D-Cytosine C6"             6     12.010     3
#atom   1197    24    O       "D-Cytosine O2"             8     16.000     1
#atom   1198    19    N2      "D-Cytosine N4"             7     14.010     3
#atom   1199    29    H       "D-Cytosine H41"            1      1.008     1
#atom   1200    29    H       "D-Cytosine H42"            1      1.008     1
#atom   1201    33    HA      "D-Cytosine H5"             1      1.008     1
#atom   1202    39    H4      "D-Cytosine H6"             1      1.008     1
#atom   1203    23    OS      "D-Thymine O5'"             8     16.000     2
#atom   1204     1    CT      "D-Thymine C5'"             6     12.010     4
#atom   1205    35    H1      "D-Thymine H5'1"            1      1.008     1
#atom   1206    35    H1      "D-Thymine H5'2"            1      1.008     1
#atom   1207     1    CT      "D-Thymine C4'"             6     12.010     4
#atom   1208    35    H1      "D-Thymine H4'"             1      1.008     1
#atom   1209    23    OS      "D-Thymine O4'"             8     16.000     2
#atom   1210     1    CT      "D-Thymine C1'"             6     12.010     4
#atom   1211    36    H2      "D-Thymine H1'"             1      1.008     1
#atom   1212     1    CT      "D-Thymine C3'"             6     12.010     4
#atom   1213    35    H1      "D-Thymine H3'"             1      1.008     1
#atom   1214     1    CT      "D-Thymine C2'"             6     12.010     4
#atom   1215    34    HC      "D-Thymine H2'1"            1      1.008     1
#atom   1216    34    HC      "D-Thymine H2'2"            1      1.008     1
#atom   1217    23    OS      "D-Thymine O3'"             8     16.000     2
#atom   1218    18    N*      "D-Thymine N1"              7     14.010     3
#atom   1219     2    C       "D-Thymine C2"              6     12.010     3
#atom   1220    15    NA      "D-Thymine N3"              7     14.010     3
#atom   1221     2    C       "D-Thymine C4"              6     12.010     3
#atom   1222     4    CM      "D-Thymine C5"              6     12.010     3
#atom   1223     4    CM      "D-Thymine C6"              6     12.010     3
#atom   1224    24    O       "D-Thymine O2"              8     16.000     1
#atom   1225    29    H       "D-Thymine H3"              1      1.008     1
#atom   1226    24    O       "D-Thymine O4"              8     16.000     1
#atom   1227     1    CT      "D-Thymine C7"              6     12.010     4
#atom   1228    34    HC      "D-Thymine H7"              1      1.008     1
#atom   1229    39    H4      "D-Thymine H6"              1      1.008     1
#atom   1230    28    P       "R-Phosphodiester P"       15     30.970     4
#atom   1231    25    O2      "R-Phosphodiester OP"       8     16.000     1
#atom   1232    22    OH      "R-5'-Hydroxyl O5'"         8     16.000     2
#atom   1233    31    HO      "R-5'-Hydroxyl H5T"         1      1.008     1
#atom   1234    23    OS      "R-5'-Phosphate O5'"        8     16.000     2
#atom   1235    28    P       "R-5'-Phosphate P"         15     30.970     4
#atom   1236    25    O2      "R-5'-Phosphate OP"         8     16.000     1
#atom   1237    22    OH      "R-3'-Hydroxyl O3'"         8     16.000     2
#atom   1238    31    HO      "R-3'-Hydroxyl H3T"         1      1.008     1
#atom   1239    23    OS      "R-3'-Phosphate O3'"        8     16.000     2
#atom   1240    28    P       "R-3'-Phosphate P"         15     30.970     4
#atom   1241    25    O2      "R-3'-Phosphate OP"         8     16.000     1
#atom   1242    28    P       "D-Phosphodiester P"       15     30.970     4
#atom   1243    25    O2      "D-Phosphodiester OP"       8     16.000     1
#atom   1244    22    OH      "D-5'-Hydroxyl O5'"         8     16.000     2
#atom   1245    31    HO      "D-5'-Hydroxyl H5T"         1      1.008     1
#atom   1246    23    OS      "D-5'-Phosphate O5'"        8     16.000     2
#atom   1247    28    P       "D-5'-Phosphate P"         15     30.970     4
#atom   1248    25    O2      "D-5'-Phosphate OP"         8     16.000     1
#atom   1249    22    OH      "D-3'-Hydroxyl O3'"         8     16.000     2
#atom   1250    31    HO      "D-3'-Hydroxyl H3T"         1      1.008     1
#atom   1251    23    OS      "D-3'-Phosphate O3'"        8     16.000     2
#atom   1252    28    P       "D-3'-Phosphate P"         15     30.970     4
#atom   1253    25    O2      "D-3'-Phosphate OP"         8     16.000     1

#atom   2001    21    OW      "TIP3P Oxygen"              8     16.000     2
#atom   2002    30    HW      "TIP3P Hydrogen"            1      1.008     1
#atom   2003    41    Li+     "Li+ Lithium Ion"           3      6.940     0
#atom   2004    42    Na+     "Na+ Sodium Ion"           11     22.990     0
#atom   2005    43    K+      "K+ Potassium Ion"         19     39.100     0
#atom   2006    44    Rb+     "Rb+ Rubidium Ion"         37     85.470     0
#atom   2007    45    Cs+     "Cs+ Cesium Ion"           55    132.910     0
#atom   2008    46    Mg+     "Mg+2 Magnesium Ion"       12     24.305     0
#atom   2009    47    Ca+     "Ca+2 Calcium Ion"         20     40.080     0
#atom   2010    48    Zn+     "Zn+2 Zinc Ion"            30     65.400     0
#atom   2011    49    Cl-     "Cl- Chloride Ion"         17     35.450     0

#####################################################################
## General atom types:                                             ##
## ID =  Symbol(xx)Valence(x)Charge(x)Cycle(x)                     ##
## Valence = from 1 to 4                                           ##
## Charge = 0, 3 (+1), 2 (radical), 5 (-1)                         ##
## Cycle = from 3 to 6                                             ##
## Bonded atoms = ID sphere1-*(sphere2)-*(sphere3):IDsphere1'..... ##
#####################################################################

#ID	Bonded Atom	Tipo Amber	Tipo Tinker	Simb	Patm	Descripcion
#Br100				BR	79.90	bromine
C_305		149	9	CB	12.01	sp2 aromatic C, 5&6 membered ring junction
C_305	C_305-C_305-C_306:C_400-*-*	146	10	C*	12.01	sp2 arom. 5 memb. ring w/1 subst. (TRP)
C_305	C_305-C_400	147	7	CW	12.01	sp2 arom. 5 memb. ring w/1 N-H and 1 H (HIS)
C_305	C_305-C_400-*:C_306-C_306-C_306	149	9	CB	12.01	sp2 aromatic C, 5&6 membered ring junction
C_305	C_306-C_306-C_306:N_305-C_305-*	152	11	CN	12.01	sp2 C aromatic 5&6 memb. ring junct. (TRP)
C_305	N_205-*-*:C_400-*-*	169	5	CC	12.01	sp2 aromatic C, 5 memb. ring HIS
C_305	N_205-*-*:N_305-C_305-C_305	174	12	CK	12.01	sp2 C 5 memb. ring in purines
C_305	N_205-C_305-C_306:N_305-C_305-N_206	1021	8	CR	12.01	sp2 arom as CQ but in HIS
C_306		115	3	CA	12.01	sp2 C pure aromatic (benzene)
C_306	C_306-N_306-*:C_306-N_?06-*	1082	4	CM	12.01	sp2 C pyrimidines in pos. 5&6
C_306	#4#:N_206-*-*	1023	13	CQ	12.01	sp2 C in 6 mem. ring of purines between 2 N
C_306	N_306-C_40?-*:C_306-C_306-N_?06	1082	4	CM	12.01	sp2 C pyrimidines in pos. 5&6
C_306	O_100	3	2	C	12.01	sp2 C carbonyl group
C_30?	O_100	3	2	C	12.01	sp2 C carbonyl group
C_330		115	3	CA	12.01	sp2 C pure aromatic (benzene)
C_40?		2	1	CT	12.01	sp3 aliphatic C
Ca?2?		2009	47	C0	40.08	calcium
#F 				F	19.00	fluorine
H_100		14	34	HC	1.008	H aliph. bond. to C without electrwd. group
H_100	C_306-*-*	117	33	HA	1.008	H arom. bond. to C without elctrwd. groups
H_100	C_30?-N_30?-*	148	39	H4	1.008	H arom. bond. to C with 1 electrwd. group
H_100	C_30?-N_30?-*:C_30?-N_20?-*	175	40	H5	1.008	H arom. bond. to C with 2 electrwd. groups
H_100	C_306-N_206-*:C_306-N_206-*	175	40	H5	1.008	H arom. bond. to C with 2 electrwd. groups
H_100	C_40?-N_43?-*	284	38	HP	1.008	H bonded to C next to positively charged gr
H_100	C_40?-N_???-*	6	35	H1	1.008	H aliph. bond. to C with 1 electrwd. group
H_100	C_40?-O_???-*	6	35	H1	1.008	H aliph. bond. to C with 1 electrwd. group
H_100	C_40?-S_???-*	6	35	H1	1.008	H aliph. bond. to C with 1 electrwd. group
H_100	C_40?-O_20?-*:C_40?-N_30?-*	1009	36	H2	1.008	H aliph. bond. to C with 2 electrwd. groups
H_100	N_???-*-*	4	29	H	1.008	H bonded to nitrogen atoms
H_100	N_40?		37	H3	1.008	H aliph. bond. to C with 3 eletrwd. groups
H_100	O_200-*-*	64	31	HO	1.008	hydroxyl group
H_100	O_200-H_100	2002	30	HW	1.008	H in TIP3P water
H_100	S_200-*-*	86	32	HS	1.008	hydrogen bonded to sulphur
#I				I	126.9	iodine
#Cl				IM	35.45	assumed to be Cl-
Na?3?		2004	42	IP	22.99	assumed to be Na+
#				IB	131.0	big ion w/waters' for vacuum (Na+, 6H2O)
Mg?2?		2008	46	MG	24.305	magnesium
N_205		193	16	NB	14.01	sp2 N in 5 memb. ring w/LP (HIS, ADE, GUA)
N_206		1022	17	NC	14.01	sp2 N in 6 memb. ring w/LP (ADE, GUA)
N_305		1017	18	N*	14.01	sp2 N in 5 memb. ring w/H atom
N_305	C_305-*-*:C_305-*-*:H_100	150	15	NA	14.01	sp2 N in 5 memb. ring w/H atom (HIS)
N_305	C_30?-O_100-*	1	14	N	14.01	sp2 nitrogen in amide groups
N_306		1017	18	N*	14.01	sp2 N
N_306	C_30?-*-*:C_30?-*-*:H_100	150	15	NA	14.01	sp2 N in 5 memb. ring w/H atom (HIS)
N_30?		299	19	N2	14.01	sp2 N in amino groups
N_30?	C_30?-O_100-*	1	14	N	14.01	sp2 nitrogen in amide groups
N_43?		285	20	N3	14.01	sp3 N for charged amino groups (Lys, etc)
O_100		5	24	O	16.00	carbonyl group oxygen
O_100	P_40?-*-*	1231	25	O2	16.00	carboxyl and phosphate group oxygen
O_150		219	25	O2	16.00	carboxyl and phosphate group oxygen
O_200		1001	23	OS	16.00	ether and ester oxygen
O_200	H_100	63	22	OH	16.00	oxygen in hydroxyl group
O_200	#2#:H_100	2001	21	OW	16.00	oxygen in TIP3P water
O_20?		1001	23	OS	16.00	ether and ester oxygen
P_40?		1230	28	P	30.97	phosphate
S_200		95	26	S	32.06	sulphur in disulfide linkage
S_200	H_100	85	27	SH	32.06	sulphur in cystine
#Cu				CU	63.55	copper
#Fe				FE	55.00	iron
Li?3?		2003	41	Li	6.94	lithium
K_?3?		2005	43	K	39.10	potassium
Rb?3?		2006	44	Rb	85.47	rubidium
Cs?3?		2007	45	Cs	132.91	cesium

