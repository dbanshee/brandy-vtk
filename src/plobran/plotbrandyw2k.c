/* plotbrandyw2k.f -- translated by f2c (version 20060506).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* Common Block Declarations */

struct {
    doublereal ec[40000], eh[40000], evecs[40000], ez1[50], ez2[50], ez3[50], 
	    exyz[150]	/* was [3][50] */;
} densdp_;

#define densdp_1 densdp_

struct {
    real densit[132651]	/* was [51][51][51] */, v[40000]	/* was [200][
	    200] */, c__[150]	/* was [3][50] */;
    integer ian[50];
    real f[40000], h__[40000], z1[50], z2[50], z3[50], u[40000];
} dens_;

#define dens_1 dens_

struct {
    real xmi, ymi, zmi, xinc, yinc, zinc;
    integer mone, molast, natb, ionemo;
} split_;

#define split_1 split_

/* Table of constant values */

static integer c__1 = 1;
static integer c__3 = 3;
static integer c__9 = 9;
static integer c__4 = 4;
static doublereal c_b204 = .75;
static doublereal c_b213 = 1.25;

/* 	PROGRAMA DE LECTURA DE FICHERO GRAPH DE MOPAC Y GENERACION */
/* 	DE ORBITAL MOLECULAR EN FORMATO VTK. LEO DE LINEA DE COMANDOS */
/* 	EL NUMERO DEL ORBITAL DESEADO.EL PROGRAMA LEE EL FICHERO */
/* 	FOR013 GENERADO POR MOPAC CON LA PALABRA 'GRAPH'PARA CREAR EL ORBITAL */

/* 	DEFINO EL NOMBRE DEL PROGRAMA */
/* Main program */ int MAIN__(void)
{
    /* Initialized data */

    static integer iat[26] = { 1,2,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,
	    6,7,8 };
    static real au = .529167f;

    /* System generated locals */
    integer i__1, i__2, i__3, i__4, i__5;
    real r__1, r__2;
    olist o__1;
    cllist cl__1;

    /* Builtin functions */
    integer f_open(olist *), s_rsue(cilist *), do_uio(integer *, char *, 
	    ftnlen), e_rsue(void), s_rsli(icilist *), do_lio(integer *, 
	    integer *, char *, ftnlen), e_rsli(void), s_wsle(cilist *), 
	    e_wsle(void), s_wsfe(cilist *), do_fio(integer *, char *, ftnlen),
	     e_wsfe(void), f_clos(cllist *);
    /* Subroutine */ int s_stop(char *, ftnlen);

    /* Local variables */
    static integer i__, j, k;
    static real o, r__, co[3];
    static integer jj, nx, ny, nz, nat[50], imo, ibeg, iend;
    static real cmin[3], dmin__, cmax[3], dmax__;
    static integer ione, itmp;
    static real xmin, ymin, xmax, ymax, zmin, zmax;
    extern /* Subroutine */ int mult_(doublereal *, doublereal *, doublereal *
	    , integer *);
    static char chbuf[25];
    static real scale;
    static integer ichrg, ihomo, nlast[50];
    static real auinv;
    static integer total, numat, norbs, ilumo, nelecs, linear;
    extern /* Subroutine */ int getarg_(integer *, char *, ftnlen);
    static real spaces;
    extern /* Subroutine */ int dramnp_(real *, integer *, real *, real *, 
	    real *), mosemi_(void);
    static real valmax;
    static integer nfirst[50], maxpts;
    static real densitn[132651]	/* was [51][51][51] */, densitp[132651]	/* 
	    was [51][51][51] */;

    /* Fortran I/O blocks */
    static cilist io___3 = { 0, 13, 0, 0, 0 };
    static cilist io___9 = { 0, 13, 0, 0, 0 };
    static cilist io___12 = { 0, 13, 0, 0, 0 };
    static cilist io___15 = { 0, 13, 0, 0, 0 };
    static cilist io___16 = { 0, 13, 0, 0, 0 };
    static icilist io___24 = { 0, chbuf, 0, 0, 25, 1 };
    static cilist io___49 = { 0, 6, 0, 0, 0 };
    static cilist io___51 = { 0, 6, 0, 0, 0 };
    static cilist io___52 = { 0, 24, 0, "(A)", 0 };
    static cilist io___53 = { 0, 24, 0, "(A)", 0 };
    static cilist io___54 = { 0, 24, 0, "(A)", 0 };
    static cilist io___55 = { 0, 24, 0, "(A)", 0 };
    static cilist io___56 = { 0, 24, 0, 0, 0 };
    static cilist io___57 = { 0, 24, 0, 0, 0 };
    static cilist io___58 = { 0, 24, 0, 0, 0 };
    static cilist io___59 = { 0, 24, 0, "(A)", 0 };
    static cilist io___60 = { 0, 24, 0, 0, 0 };
    static cilist io___61 = { 0, 24, 0, "(A)", 0 };
    static cilist io___62 = { 0, 24, 0, "(A)", 0 };
    static cilist io___63 = { 0, 24, 0, "(4I5)", 0 };
    static cilist io___67 = { 0, 24, 0, "(A)", 0 };
    static cilist io___68 = { 0, 24, 0, "(A)", 0 };
    static cilist io___69 = { 0, 24, 0, "(4I5)", 0 };
    static cilist io___70 = { 0, 24, 0, "(A)", 0 };
    static cilist io___71 = { 0, 24, 0, "(A)", 0 };
    static cilist io___72 = { 0, 24, 0, "(4I5)", 0 };
    static cilist io___73 = { 0, 22, 0, 0, 0 };
    static cilist io___74 = { 0, 22, 0, 0, 0 };
    static cilist io___75 = { 0, 22, 0, 0, 0 };
    static cilist io___76 = { 0, 22, 0, 0, 0 };
    static cilist io___77 = { 0, 22, 0, 0, 0 };
    static cilist io___78 = { 0, 6, 0, 0, 0 };
    static cilist io___79 = { 0, 22, 0, 0, 0 };


/* 	DEFINIMOS LOS PARAMETROS QUE NECESITAMOS POR DEFECTO EN */
/* 	MAXIMO NUMERO DE ATOMOS */
/*      IMPLICIT NONE */
/* 	MAXIMO NUMERO DE PUNTOS DE LA CAJA DEL GRAFICO */
/* 	MAXIMO NUMERO DE ORBITALES */

/* 	VARIABLES RELACIONADAS CON LA DENSIDAD ELECTRONICA */
/* 	EN DOBLE PRECISION PARA LA LECTURA DE GRAPH */


/* 	VARIABLES RELACIONADAS CON LA DENSIDAD ELECTRONICA */

/* 	DENSIT(I,J,K)  DENSIDAD ELECTRONICA EN EL PUNTO I,J,K */
/* 	V(I,J) CONTIENE LOS COEFICIENTES DEL ORBITAL J EN EL OM I */
/* 	C(I,J) CORDENADAS CARTESIANAS J DEL ATOMO I */
/* 	F(I) EIGENVECTORES NO NORMALIZADOS LEIDOS DE FOR013 I VA */
/* 	DE 1 A MAXORB*MAXORB */
/* 	H(I) RAIZ CUADRDA DE LA INVERSA DE LA MATRIZ DE SOLAPAMIENTO */
/* 	ORBITAL. I VA DE 1 A MAXORB*MAXORB */
/* 	U(I) ES LA MATRIZ DE COEFICIENTES DE EIGENVECTOR NORMALIZADA */
/* 	ES EQUIVALENTE A V(I,J) PERO CON UN SOLO SUBSCRIPT */
/* 	IAN(I) NUMERO ATÓMICO DEL ATOMO I */
/* 	Z1(I) EXPONENTE DEL ORBITAL S EN EL ATOMO I */
/* 	Z2(I) EXPONENTE DEL ORBITAL P EN EL ATOMO I */
/* 	Z3(I) EXPONENTE DEL ORBITAL D EN EL ATOMO I */
/* 	VARIABLES RELACIONADAS CON EL ORBITAL MOLECULAR A LEER Y LAS */
/* 	DIMENSIONES DE LA CAJA */
/* 	XMI VALOR MINIMO DE LA COORDENADA X (EN UNIDADES ATOMICAS) */
/* 	YMI VALOR MINIMO DE LA COORDENADA Y (EN UNIDADES ATOMICAS) */
/* 	ZMI VALOR MINIMO DE LA COORDENADA Z (EN UNIDADES ATOMICAS) */
/* 	XINC INCREMENTO DE X POR PUNTO  (EN UNIDADES ATOMICAS) */
/* 	YINC INCREMENTO DE Y POR PUNTO  (EN UNIDADES ATOMICAS) */
/* 	ZINC INCREMENTO DE Z POR PUNTO  (EN UNIDADES ATOMICAS) */
/* 	MONE PRIMER ORBITAL A LEER */
/* 	MOLAST ULTIMO ORBITAL A LEER */
/* 	NATB CONTADOR DE ATOMOS */

/*      REAL XMI,YMI,ZMI,XINC,YINC,ZINC,MONE,MOLAST */
/* 	CO(I) DIMENSION DE LA CAJA LA DIRECCION I (X Y O Z) */
/* 	CMIN(I) VALOR MINIMO DE LA CAJA EN LA COMPONENTE I */
/* 	CMAX(I) VALOR MAXIMO DE LA CAJA EN LA COMPONENTE I */
/*      REAL CO(3),CMIN(3),CMAX(3) */
/* 	IAT(I) NUMERO DE ELECTROPNES DE VALENCIA DE UN ATOMO DE */
/* 	NUMERO ATOMICO I */
/* 	NLAST(I) CONTADOR DE ORBITALES NO SE PA QUE SIRVE */
/* 	NFIRST(I) CONTADOR DE ORBITALES NO SE PA QUE SIRVE */
/* 	NAT(I) NUMERO ATOMICO DE ATOMO I */

/*      CHARACTER*10 SUBTIT */

/* 	INICIALIZO LA MATRIZ IAT QUE POSEE EL NUMERO DE ELECTRONES DE */
/* 	VALENCIA DE UN ATOMO DE NUMERO ATOMICO I */

/* 	CONVIERTO LAS DISTANCIAS LEIDAS EN AMSTRONG EN FOR013 */
/* 	A UNIDADES ATOMICAS PARA HACER EL CALCULO DE LA DENSIDAD */
/* 	1 AU = 5.291670×10-11 m= 0.5291670 */


/* 	VERSION 1.0 DE MOPBRAN */
/* 	LO PRIMERO QUE SE HACE ES LEER EL FICHERO FOR013 Y ASIGNAR */
/* 	LAS VARIABLES OBTENIDAS DE EL: */
/* 	MOPAC ESCRIBE ESTE FICHERO EN LA SUBRUTINA MULLIK */
/* 	Y LO HACE EN EL SIGUIENTE ORDEN */
/* 	NUMERO DE ATOMOS, ORBITALES Y ELECTRONES */
/* 	COORDENADAS CARTESIANAS DE TODOS LOS ATOMOS */
/* 	CONTADOR DE ORBITALES */
/* 	EXPONENTES ORBITALES S, P Y D Y NUMERO ATOMICO */
/* 	EIGENVECTORES NO NORMALIZADOS */
/* 	RAIZ CUADRDA DE LA INVERSA DE LA MATRIZ DE SOLAPAMIENTO */
/* 	ORBITAL. */

/*      NUMBER OF ATOMS, ORBITAL, ELECTRONS */
/*      ALL ATOMIC COORDINATES */
/*      ORBITAL COUNTERS */
/*      ORBITAL EXPONENTS, S, P, AND D, AND ATOMIC NUMBERS */
/*      EIGENVECTORS (M.O.S NOT RE-NORMALISED) */
/*      INVERSE-SQUARE ROOT OF THE OVERLAP MATRIX. */


    o__1.oerr = 0;
    o__1.ounit = 13;
    o__1.ofnmlen = 6;
    o__1.ofnm = "FOR013";
    o__1.orl = 0;
    o__1.osta = "old";
    o__1.oacc = 0;
    o__1.ofm = "UNFORMATTED";
    o__1.oblnk = 0;
    f_open(&o__1);
    s_rsue(&io___3);
    do_uio(&c__1, (char *)&numat, (ftnlen)sizeof(integer));
    do_uio(&c__1, (char *)&norbs, (ftnlen)sizeof(integer));
    do_uio(&c__1, (char *)&nelecs, (ftnlen)sizeof(integer));
    for (i__ = 1; i__ <= 3; ++i__) {
	i__1 = numat;
	for (j = 1; j <= i__1; ++j) {
	    do_uio(&c__1, (char *)&densdp_1.exyz[i__ + j * 3 - 4], (ftnlen)
		    sizeof(doublereal));
	}
    }
    e_rsue();
    split_1.natb = numat;
    s_rsue(&io___9);
    i__1 = numat;
    for (i__ = 1; i__ <= i__1; ++i__) {
	do_uio(&c__1, (char *)&nlast[i__ - 1], (ftnlen)sizeof(integer));
	do_uio(&c__1, (char *)&nfirst[i__ - 1], (ftnlen)sizeof(integer));
    }
    e_rsue();
    s_rsue(&io___12);
    i__1 = numat;
    for (i__ = 1; i__ <= i__1; ++i__) {
	do_uio(&c__1, (char *)&densdp_1.ez1[i__ - 1], (ftnlen)sizeof(
		doublereal));
    }
    i__2 = numat;
    for (i__ = 1; i__ <= i__2; ++i__) {
	do_uio(&c__1, (char *)&densdp_1.ez2[i__ - 1], (ftnlen)sizeof(
		doublereal));
    }
    i__3 = numat;
    for (i__ = 1; i__ <= i__3; ++i__) {
	do_uio(&c__1, (char *)&densdp_1.ez3[i__ - 1], (ftnlen)sizeof(
		doublereal));
    }
    i__4 = numat;
    for (i__ = 1; i__ <= i__4; ++i__) {
	do_uio(&c__1, (char *)&nat[i__ - 1], (ftnlen)sizeof(integer));
    }
    e_rsue();

    i__1 = numat;
    for (i__ = 1; i__ <= i__1; ++i__) {
	dens_1.ian[i__ - 1] = nat[i__ - 1];
/* L4: */
    }
    linear = norbs * norbs;

    s_rsue(&io___15);
    i__1 = linear;
    for (i__ = 1; i__ <= i__1; ++i__) {
	do_uio(&c__1, (char *)&densdp_1.ec[i__ - 1], (ftnlen)sizeof(
		doublereal));
    }
    e_rsue();
    s_rsue(&io___16);
    i__1 = linear;
    for (i__ = 1; i__ <= i__1; ++i__) {
	do_uio(&c__1, (char *)&densdp_1.eh[i__ - 1], (ftnlen)sizeof(
		doublereal));
    }
    e_rsue();
/* 	A PARTIR DE LOS VALORES DE EIGENV NO NORMALIZADOS */
/* 	OBTENGO LA MATRIZ EVECS(I) NORMALIZADA USO LA SUBRUTINA */
/* 	MULT QUE PROVIENE DE MOPAC */
    mult_(densdp_1.ec, densdp_1.eh, densdp_1.evecs, &norbs);

/* 	AHORA CREO LA MATRIZ CORRECTA REAL PARA LA ENTRADA EN MOSEMI */
/* 	DE LOS VALORES DE EIGENV NORMALIZADOS QUE SON DE DOUBLE PRECISION */
/* 	ES LA MATRIZ V(I,J) */
    i__1 = norbs;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i__2 = norbs;
	for (j = 1; j <= i__2; ++j) {
	    jj = j + norbs * (i__ - 1);
	    dens_1.v[j + i__ * 200 - 201] = (real) densdp_1.evecs[jj - 1];
/* L5: */
	}
/* L6: */
    }
/* 	AHORA CONVIERTO LOS VALORES DE DOBLE PRECISION */
/* 	LEIDOS DE GRAPH A VALORES REALES PARA TODAS LAS */
/* 	VARIABLES AL OBJETO DE ENVIARLAS A */
/* 	MOSEMI SIN ERRORES APROVECHO EL CALCULO DE TOTAL */
/* 	PARA HACER LA CONVERSION */

/* 	DETERMINO EL NUMERO DE ELECTRONES TOTAL */
/* 	DE LA MOLECULA BASANDOME EN EL NUMERO ATOMICO */
/* 	LEIDO EN GRAPH Y EN LA MATRIZ DE DATOS IAT */
/* 	QUE CONTIENE LOS ELECTRONES DE VALENCIA DE CADA */
/* 	NUMERO ATOMICO */
    total = 0;
    i__1 = numat;
    for (i__ = 1; i__ <= i__1; ++i__) {
	dens_1.z1[i__ - 1] = (real) densdp_1.ez1[i__ - 1];
	dens_1.z2[i__ - 1] = (real) densdp_1.ez2[i__ - 1];
	dens_1.z3[i__ - 1] = (real) densdp_1.ez3[i__ - 1];
	itmp = nat[i__ - 1];
	total += iat[itmp - 1];

/* 	PONGO A CERO LOS COEFICIENTES ZETA (D) YA QUE MOPAC */
/* 	ASIGNA 1 A TODOS ESTOS VALORES INCLUSO AUNQUE NO TENGAN */
/* 	ORBITALES D */

	densdp_1.ez3[i__ - 1] = 0.;
/* L10: */
    }
/* 	AHORA CREO LA MATRIZ DE COORDENADAS CARTESIANAS */
/* 	EN FORMATO REAL A PARTIR DE LA DE DOBLE PRECISION */
    i__1 = numat;
    for (i__ = 1; i__ <= i__1; ++i__) {
	for (j = 1; j <= 3; ++j) {
	    dens_1.c__[j + i__ * 3 - 4] = (real) densdp_1.exyz[j + i__ * 3 - 
		    4];
/* L11: */
	}
/* L12: */
    }

/* 	CALCULO LA CARGA ELECTRICA DEL SISTEMA ICHRG */
/* 	CONOCIENDO EL NUMERO DE ELECTRONES TEORICO */
/* 	Y EL REAL QUE HE LEIDO DE GRAPH ADEMAS ESTIMO EL */
/* 	VALOR DEL HOMO Y LUMO IHOMO  ILUMO */
    ichrg = total - nelecs;
    ihomo = (nelecs + 1) / 2;
    ilumo = ihomo + 1;

/*   20 WRITE(*,*) */
/*      WRITE (*,'(A,I4,A,I4)')' The HOMO is MO number ',IHOMO, */
/*     *  ' The LUMO is MO number ',ILUMO */
/*      WRITE(*,*) */
/*      WRITE (*,'(A,$)') ' WHICH MO DO YOU WISH TO PLOT? ' */
/*      READ (*,*) IMO */
/*     LEO EL ORBITAL DE LA LINEA DE ENTRADA QUE */
/* 	QUE QUIERO CALCULAR */
    getarg_(&c__1, chbuf, (ftnlen)25);
    s_rsli(&io___24);
    do_lio(&c__3, &c__1, (char *)&imo, (ftnlen)sizeof(integer));
    e_rsli();
/*      IF (IMO.LT.0.OR.IMO.GT.TOTAL) GO TO 20 */

/* FIJO EL VALOR DE ESCALA */

    scale = 1.4f;
    ione = 1;
    split_1.mone = imo;
    split_1.molast = imo;
    ibeg = (imo - 1) * norbs + 1;
    iend = ibeg + norbs - 1;

/* 	AHORA DEBO SEGUIR UN  PROTOCOLO */
/* 	SIMILAR AL QUE SIGUE PSI1 */
/* 	COMO TENGO EN MEMORIA TODOS LOS VALKORES NO HE DE LEERLOS */
/* 	LO PRIMERO DETERMINAR LA CAJA DEL SISTEMA */
/* 	ESTO LO HACE LA SUBRUTINA DRAMNP */
/*         WRITE (6,*) ' DIMENSIONES MINIMAS' */
/*         WRITE (6,*) (CMIN(I),I=1,3) */
/*         WRITE (6,*) ' DIMENSIONES MAXIMAS' */
/*         WRITE (6,*) (CMAX(I),I=1,3) */
/*         WRITE (6,*) ' DIMENSIONES CENTRAL' */
/*         WRITE (6,*) (CO(I),I=1,3) */

/* 	CONVIERTO LAS COORDENADAS EN AMSTRONG OBTENIDAS DE GRAPH */
/* 	A UNIDADES ATOMICAS */

    auinv = 1.f / au;
    for (i__ = 1; i__ <= 3; ++i__) {
	i__1 = split_1.natb;
	for (j = 1; j <= i__1; ++j) {
	    dens_1.c__[i__ + j * 3 - 4] *= auinv;
/* L20: */
	}
/* L30: */
    }
/*     AHORA LLAMO A LA SUBRUTINA  QUE DETERMINA LOS VALORES MAXIMOS */
/*     Y MINIOS DE LA CAJA QUE SE DEBEN EVALUAR RECIBE LAS COORDENADAS */
/*     EN UA */
    dramnp_(dens_1.c__, &numat, co, cmin, cmax);

/* 	DEFINO EL NUMERO DE PUNTOS DEFINIDO EN UNIDADES ATOM */

/*      SPACES = FLOAT(MXPTS-1)*AU */
    spaces = 51.f;
/*       SPACES = FLOAT(MXPTS-1) */

/* 	INCREMENTO EL RANGO DEL PLOT */

/*         R = 1.82E+0 */
    r__ = 0.f;
/*          R = 3.0 */
    xmin = cmin[0] - r__;
    xmax = cmax[0] + r__;
    ymin = cmin[1] - r__;
    ymax = cmax[1] + r__;
    zmin = cmin[2] - r__;
    zmax = cmax[2] + r__;
    split_1.xmi = xmin;
    split_1.ymi = ymin;
    split_1.zmi = zmin;
    split_1.xinc = (xmax - xmin) / spaces;
    split_1.yinc = (ymax - ymin) / spaces;
    split_1.zinc = (zmax - zmin) / spaces;

/* 	YA TENGO LOS VALORES NECESARIOS EN MEMORIA */
/* 	EJECUTO MOSEMI QUE DETERMINA EN LA CAJA ANTERIOR LA */
/*     DENSIDAD ELECTRONICA EN CADA PUNTO */

    mosemi_();

/* 	ESCRIBO LA MATRIZ DENSIDAD EN ORBITAL.VTK */

    o__1.oerr = 0;
    o__1.ounit = 24;
    o__1.ofnmlen = 8;
    o__1.ofnm = "BORB.VTK";
    o__1.orl = 0;
    o__1.osta = 0;
    o__1.oacc = 0;
    o__1.ofm = 0;
    o__1.oblnk = 0;
    f_open(&o__1);
    maxpts = 51;

/*     CALCULO LA DENSIDAD ELECTRONICA MAXIMA Y MINIMA */

    dmin__ = 1e3f;
    dmax__ = -1e3f;
    i__1 = maxpts;
    for (k = 1; k <= i__1; ++k) {
	i__2 = maxpts;
	for (j = 1; j <= i__2; ++j) {
	    i__3 = maxpts;
	    for (i__ = 1; i__ <= i__3; ++i__) {
/* Computing MIN */
		r__1 = dmin__, r__2 = dens_1.densit[i__ + (j + k * 51) * 51 - 
			2653];
		dmin__ = dmin(r__1,r__2);
/* Computing MAX */
		r__1 = dmax__, r__2 = dens_1.densit[i__ + (j + k * 51) * 51 - 
			2653];
		dmax__ = dmax(r__1,r__2);
		densitn[i__ + (j + k * 51) * 51 - 2653] = 0.f;
		densitp[i__ + (j + k * 51) * 51 - 2653] = 0.f;
		if (dens_1.densit[i__ + (j + k * 51) * 51 - 2653] <= o) {
		    densitn[i__ + (j + k * 51) * 51 - 2653] = dens_1.densit[
			    i__ + (j + k * 51) * 51 - 2653];
		} else {
		    densitp[i__ + (j + k * 51) * 51 - 2653] = dens_1.densit[
			    i__ + (j + k * 51) * 51 - 2653];
		}
/* L90: */
	    }
/* L100: */
	}
/* L110: */
    }
    s_wsle(&io___49);
    do_lio(&c__9, &c__1, "MIN, MAX DENSITY(VALUE) COMPUTED IS ", (ftnlen)36);
    do_lio(&c__4, &c__1, (char *)&dmin__, (ftnlen)sizeof(real));
    do_lio(&c__4, &c__1, (char *)&dmax__, (ftnlen)sizeof(real));
    e_wsle();
/* 	DECIDO CUAL DE LOS DOS VALORES ABSOLUTOS DMIN O DMAX ES MAYOR */
/*      IF (IMO.LT.0.OR.IMO.GT.TOTAL) GO TO 20 */
/*      WRITE (17,'(2I3)') MAXPTS,NAT */
/* 	DECIDO QUIEN ES MAYOR EN VALOR ABSOLUTO DMIN O DMAX */
    if (dabs(dmin__) > dabs(dmax__)) {
	valmax = dabs(dmin__);
    } else {
	valmax = dabs(dmax__);
    }
    s_wsle(&io___51);
    do_lio(&c__9, &c__1, "NORBS ", (ftnlen)6);
    do_lio(&c__3, &c__1, (char *)&norbs, (ftnlen)sizeof(integer));
    do_lio(&c__9, &c__1, "NATB ", (ftnlen)5);
    do_lio(&c__3, &c__1, (char *)&split_1.natb, (ftnlen)sizeof(integer));
    e_wsle();
/*         SPACES = 51 */
    split_1.xinc = (xmax - xmin) / spaces;
    split_1.yinc = (ymax - ymin) / spaces;
    split_1.zinc = (zmax - zmin) / spaces;
/*       ESCRIBO LOS RESULTADOS EN EL FICHERO VTK */
    s_wsfe(&io___52);
    do_fio(&c__1, "# vtk DataFile Version 2.0", (ftnlen)26);
    e_wsfe();
    s_wsfe(&io___53);
    do_fio(&c__1, "A Simple Matrix of values", (ftnlen)25);
    e_wsfe();
    s_wsfe(&io___54);
    do_fio(&c__1, "ASCII", (ftnlen)5);
    e_wsfe();
    s_wsfe(&io___55);
    do_fio(&c__1, "DATASET STRUCTURED_POINTS", (ftnlen)25);
    e_wsfe();
    s_wsle(&io___56);
    do_lio(&c__9, &c__1, "DIMENSIONS ", (ftnlen)11);
    do_lio(&c__3, &c__1, (char *)&maxpts, (ftnlen)sizeof(integer));
    do_lio(&c__3, &c__1, (char *)&maxpts, (ftnlen)sizeof(integer));
    do_lio(&c__3, &c__1, (char *)&maxpts, (ftnlen)sizeof(integer));
    e_wsle();
    s_wsle(&io___57);
    do_lio(&c__9, &c__1, "ORIGIN ", (ftnlen)7);
    do_lio(&c__4, &c__1, (char *)&xmin, (ftnlen)sizeof(real));
    do_lio(&c__4, &c__1, (char *)&ymin, (ftnlen)sizeof(real));
    do_lio(&c__4, &c__1, (char *)&zmin, (ftnlen)sizeof(real));
    e_wsle();
    s_wsle(&io___58);
    do_lio(&c__9, &c__1, "SPACING ", (ftnlen)8);
    do_lio(&c__4, &c__1, (char *)&split_1.xinc, (ftnlen)sizeof(real));
    do_lio(&c__4, &c__1, (char *)&split_1.yinc, (ftnlen)sizeof(real));
    do_lio(&c__4, &c__1, (char *)&split_1.zinc, (ftnlen)sizeof(real));
    e_wsle();
    s_wsfe(&io___59);
    do_fio(&c__1, " ", (ftnlen)1);
    e_wsfe();
    s_wsle(&io___60);
    do_lio(&c__9, &c__1, "POINT_DATA ", (ftnlen)11);
/* Computing 3rd power */
    i__2 = maxpts;
    i__1 = i__2 * (i__2 * i__2);
    do_lio(&c__3, &c__1, (char *)&i__1, (ftnlen)sizeof(integer));
    e_wsle();
/* CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC */
    s_wsfe(&io___61);
    do_fio(&c__1, "SCALARS POS float", (ftnlen)17);
    e_wsfe();
    s_wsfe(&io___62);
    do_fio(&c__1, "LOOKUP_TABLE default", (ftnlen)20);
    e_wsfe();
    s_wsfe(&io___63);
    i__1 = maxpts;
    for (nz = 1; nz <= i__1; ++nz) {
	i__2 = maxpts;
	for (ny = 1; ny <= i__2; ++ny) {
	    i__3 = maxpts;
	    for (nx = 1; nx <= i__3; ++nx) {
		i__5 = (i__4 = (integer) (densitp[nx + (ny + nz * 51) * 51 - 
			2653] * 256 / valmax), abs(i__4));
		do_fio(&c__1, (char *)&i__5, (ftnlen)sizeof(integer));
	    }
	}
    }
    e_wsfe();
    s_wsfe(&io___67);
    do_fio(&c__1, "SCALARS NEG float", (ftnlen)17);
    e_wsfe();
    s_wsfe(&io___68);
    do_fio(&c__1, "LOOKUP_TABLE default", (ftnlen)20);
    e_wsfe();
    s_wsfe(&io___69);
    i__4 = maxpts;
    for (nz = 1; nz <= i__4; ++nz) {
	i__5 = maxpts;
	for (ny = 1; ny <= i__5; ++ny) {
	    i__3 = maxpts;
	    for (nx = 1; nx <= i__3; ++nx) {
		i__1 = (i__2 = (integer) (densitn[nx + (ny + nz * 51) * 51 - 
			2653] * 256 / valmax), abs(i__2));
		do_fio(&c__1, (char *)&i__1, (ftnlen)sizeof(integer));
	    }
	}
    }
    e_wsfe();
    s_wsfe(&io___70);
    do_fio(&c__1, "SCALARS TOT float", (ftnlen)17);
    e_wsfe();
    s_wsfe(&io___71);
    do_fio(&c__1, "LOOKUP_TABLE default", (ftnlen)20);
    e_wsfe();
    s_wsfe(&io___72);
    i__2 = maxpts;
    for (nz = 1; nz <= i__2; ++nz) {
	i__1 = maxpts;
	for (ny = 1; ny <= i__1; ++ny) {
	    i__3 = maxpts;
	    for (nx = 1; nx <= i__3; ++nx) {
		i__4 = (i__5 = (integer) (dens_1.densit[nx + (ny + nz * 51) * 
			51 - 2653] * 256 / valmax), abs(i__5));
		do_fio(&c__1, (char *)&i__4, (ftnlen)sizeof(integer));
	    }
	}
    }
    e_wsfe();
/* CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC */
/*      WRITE (24,'(8F10.6)') ((V(I,J),I=1,NORBS),J=1,NORBS) */
/*      WRITE (24,'(8F10.6)') (((DENSIT(NX,NY,NZ), */
/*     *   NX=1,MAXPTS),NY=1,MAXPTS),NZ=1,MAXPTS) */
/* CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC */
/*     GENERO UN FICHERO CON LAS COORDENADAS DE LA MOLECULA */
/*     SEGUN LO QUE CONTIENE EL GPT */
    o__1.oerr = 0;
    o__1.ounit = 22;
    o__1.ofnmlen = 10;
    o__1.ofnm = "CGRAPH.COR";
    o__1.orl = 0;
    o__1.osta = 0;
    o__1.oacc = 0;
    o__1.ofm = 0;
    o__1.oblnk = 0;
    f_open(&o__1);
/*      DO 40 I = 1,NUMAT */
    s_wsle(&io___73);
    do_lio(&c__9, &c__1, "COORDENADAS DE FOR013 EN FORMATO GPT", (ftnlen)36);
    e_wsle();
    s_wsle(&io___74);
    do_lio(&c__9, &c__1, "powered by BANSHEE&GT&FN", (ftnlen)24);
    e_wsle();
    s_wsle(&io___75);
    do_lio(&c__9, &c__1, "", (ftnlen)0);
    e_wsle();
    s_wsle(&io___76);
    do_lio(&c__9, &c__1, "NUMATOM COORX COORY COORZ", (ftnlen)25);
    e_wsle();
    i__5 = numat;
    for (i__ = 1; i__ <= i__5; ++i__) {
/*             WRITE (22,*) IAN(I), ' ', (EXYZ(1,I) *AUINV), */
/*     *       (EXYZ(2,I)*AUINV) , ((EXYZ(3,I) +R) *AUINV) */
	s_wsle(&io___77);
	do_lio(&c__3, &c__1, (char *)&dens_1.ian[i__ - 1], (ftnlen)sizeof(
		integer));
	do_lio(&c__9, &c__1, " ", (ftnlen)1);
	do_lio(&c__4, &c__1, (char *)&dens_1.c__[i__ * 3 - 3], (ftnlen)sizeof(
		real));
	do_lio(&c__4, &c__1, (char *)&dens_1.c__[i__ * 3 - 2], (ftnlen)sizeof(
		real));
	do_lio(&c__4, &c__1, (char *)&dens_1.c__[i__ * 3 - 1], (ftnlen)sizeof(
		real));
	e_wsle();
	s_wsle(&io___78);
	do_lio(&c__3, &c__1, (char *)&dens_1.ian[i__ - 1], (ftnlen)sizeof(
		integer));
	do_lio(&c__9, &c__1, " ", (ftnlen)1);
	do_lio(&c__4, &c__1, (char *)&dens_1.c__[i__ * 3 - 3], (ftnlen)sizeof(
		real));
	do_lio(&c__4, &c__1, (char *)&dens_1.c__[i__ * 3 - 2], (ftnlen)sizeof(
		real));
	do_lio(&c__4, &c__1, (char *)&dens_1.c__[i__ * 3 - 1], (ftnlen)sizeof(
		real));
	e_wsle();
/*             WRITE (22,*) IAN(I), ' ', (EXYZ(1,I) + CMIN(1) + R), */
/*     *       (EXYZ(2,I) + CMIN(2) + R), (EXYZ(3,I) + CMIN(3) + R) */
/* L111: */
    }
/*      WRITE (22,*) 'NUMATOM'        ,(IAN(I),I=1,NUMAT) */
/*      WRITE (22,*) 'COORDENADAS X ',(EXYZ(1,J),J=1,NUMAT) */
/*      WRITE (22,*) 'COORDENADAS Y ',(EXYZ(2,J),J=1,NUMAT) */
/*      WRITE (22,*) 'COORDENADAS Z ',(EXYZ(3,J),J=1,NUMAT) */
    s_wsle(&io___79);
    do_lio(&c__4, &c__1, (char *)&spaces, (ftnlen)sizeof(real));
    e_wsle();
    cl__1.cerr = 0;
    cl__1.cunit = 22;
    cl__1.csta = 0;
    f_clos(&cl__1);
/*   40  CONTINUE */
/* CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC */
/* 	FIN DE PLOTBRAN */

    s_stop("", (ftnlen)0);
    return 0;
} /* MAIN__ */



/* Subroutine */ int mult_(doublereal *eg, doublereal *es, doublereal *evecs, 
	integer *n)
{
    /* System generated locals */
    integer eg_dim1, eg_offset, es_dim1, es_offset, evecs_dim1, evecs_offset, 
	    i__1, i__2, i__3;

    /* Local variables */
    static integer i__, j, k;
    static doublereal esum;


/* ********************************************************************** */

/*   THIS ROUTINE TAKEN FROM MOPAC BY J.S. STEWART */

/*   MULT IS USED IN THE MULLIKEN ANALYSIS ONLY. IT PERFORMS THE */
/*        OPERATION:- */
/*                                   VECS=BACK-TRANSFORMED EIGENVECTORS */
/*        VECS  =  C*S               C   =UN-BACK-TRANSFORMED VECTORS */
/*                                   S   =1/SQRT(OVERLAP MATRIX) */

/* ********************************************************************** */

    /* Parameter adjustments */
    evecs_dim1 = *n;
    evecs_offset = 1 + evecs_dim1;
    evecs -= evecs_offset;
    es_dim1 = *n;
    es_offset = 1 + es_dim1;
    es -= es_offset;
    eg_dim1 = *n;
    eg_offset = 1 + eg_dim1;
    eg -= eg_offset;

    /* Function Body */
    i__1 = *n;
    for (i__ = 1; i__ <= i__1; ++i__) {
	i__2 = *n;
	for (j = 1; j <= i__2; ++j) {

/* COMPUTE FIRST ELEMENT HERE (K=1) TO INITIALIZE SUM */

	    evecs[j + i__ * evecs_dim1] = eg[i__ * eg_dim1 + 1] * es[j + 
		    es_dim1];
	    i__3 = *n;
	    for (k = 2; k <= i__3; ++k) {
		evecs[j + i__ * evecs_dim1] += eg[k + i__ * eg_dim1] * es[j + 
			k * es_dim1];
/* L10: */
	    }
	    esum = evecs[j + i__ * evecs_dim1];
/* L20: */
	}
/* L30: */
    }
    return 0;
} /* mult_ */


/* ********************************************************************** */

/*   RUTINA TOMADA DE PSI1 DE  DANIEL L. SEVERANCE Y */
/*      WILLIAM L. JORGENSEN */
/* 	RECIBE COMO ENTRADA */
/* 	C(I,J) SON LAS COORDENADAS J (1-3=X-Z) DEL ATOMO I */
/* 	NAT NUMERO DE ATOMOS */
/* 	Y CALCULA EL VALOR DE */
/* 	CO(I) COMPOPNENTE I (1-3=X-Z) DEL VECTOR DEL CENTRO DE LA CAJA */
/* 	CMIN(I) VALOR MIN EN AMSTRONG DE LA COMPONENTE I DE LA CAJA */
/* 	CMAX(I) VALOR MAX EN AMSTRONG DE LA COMPONENTE I DE LA CAJA */
/* ********************************************************************** */

/* Subroutine */ int dramnp_(real *c__, integer *nat, real *co, real *cmin, 
	real *cmax)
{
    /* System generated locals */
    integer i__1;

    /* Local variables */
    static integer i__, j;
    static real p, cm, cma, cmi;

/*      REAL C(MAXATM,3),CO(3),CMIN(3),CMAX(3) */

/*       THIS ROUTINE DETERMINES CO AND CM WHICH ARE USED */
/*       FOR AUTOMATIC SCALING OF PLOTTING AREAS */

/*       THE ROUTINE WAS ADAPTED FROM THE ROUTINE CALLED */
/*       DRAMOL WHICH IS USED IN THE HIDDEN LINE PART OF */
/*       THE PROGRAM */

    /* Parameter adjustments */
    --cmax;
    --cmin;
    --co;
    c__ -= 4;

    /* Function Body */
    cm = -100.f;
    for (i__ = 1; i__ <= 3; ++i__) {
	cmi = 100.f;
	cma = -100.f;
	i__1 = *nat;
	for (j = 1; j <= i__1; ++j) {
	    p = c__[i__ + j * 3];
	    cmi = dmin(cmi,p);
	    cma = dmax(cma,p);
/* L10: */
	}
	co[i__] = (cma + cmi) * .5f;
	cmin[i__] = cmi;
	cmax[i__] = cma;
	p = cma - cmi;
	if (p > cm) {
/*            ICM = I */
	    cm = p;
	}
/* L20: */
    }
    return 0;
} /* dramnp_ */


/* ********************************************************************** */

/*   RUTINA MOSEMI TOMADA DE PSI1 DE  DANIEL L. SEVERANCE Y */
/*      WILLIAM L. JORGENSEN */
/* 	RECIBE COMO ENTRADA */
/* 	C(I,J) SON LAS COORDENADAS J (1-3=X-Z) DEL ATOMO I */
/* 	NATB NUMERO DE ATOMOS */
/* 	Y CALCULA EL VALOR DE */
/* 	CO(I) COMPOPNENTE I (1-3=X-Z) DEL VECTOR DEL CENTRO DE LA CAJA */
/* 	CMIN(I) VALOR MIN EN AMSTRONG DE LA COMPONENTE I DE LA CAJA */
/* 	CMAX(I) VALOR MAX EN AMSTRONG DE LA COMPONENTE I DE LA CAJA */
/* ********************************************************************** */



/* Subroutine */ int mosemi_(void)
{
    /* Initialized data */

    static real a[9]	/* was [3][3] */ = { .109818f,.0751386f,.0527266f,
	    .405771f,.231031f,.134715f,2.22766f,.994203f,.482854f };
    static real d__[9]	/* was [3][3] */ = { .444635f,.700115f,.900398f,
	    .535328f,.399513f,.225595f,.154329f,-.0999672f,-.21962f };
    static real d2p[3] = { .391957f,.607684f,.155916f };
    static real d3p[3] = { .462001f,.595167f,.0105876f };

    /* System generated locals */
    integer i__1;
    real r__1;
    doublereal d__1;

    /* Builtin functions */
    integer s_wsle(cilist *), do_lio(integer *, integer *, char *, ftnlen), 
	    e_wsle(void), s_wsfe(cilist *), do_fio(integer *, char *, ftnlen),
	     e_wsfe(void);
    double pow_dd(doublereal *, doublereal *), sqrt(doublereal);

    /* Local variables */
    static integer i__, j, m;
    static real x[51], y[51], z__[51];
    static integer ig, mo, ix, iy, iz;
    static real zn;
    static integer nao;
    static real zsq[3], xyz[150]	/* was [3][50] */, aop1, aop2, aop3, 
	    aneg[6];
    static integer iatb;
    static real xdel[51], ydel[51], zdel[51];
    extern doublereal gexp_(real *);
    static integer ixyz;
    static real aexpp[459]	/* was [51][9] */, aexps[459]	/* was [51][9]
	     */, rnorm, cnstx[153]	/* was [51][3] */, cnsty[153]	/* 
	    was [51][3] */, vnorm[12], cnstz[153]	/* was [51][3] */, 
	    zsqrt, xdelsq[51], ydelsq[51], zdelsq[51], cnstnp[9]	/* 
	    was [3][3] */, cnstns[9]	/* was [3][3] */;

    /* Fortran I/O blocks */
    static cilist io___94 = { 0, 6, 0, 0, 0 };
    static cilist io___97 = { 0, 6, 0, 0, 0 };
    static cilist io___98 = { 0, 6, 0, 0, 0 };
    static cilist io___102 = { 0, 6, 0, "(8F10.6)", 0 };
    static cilist io___120 = { 0, 6, 0, "(2(A,I5))", 0 };



/*       REEPLACES ORIGINAL ROUTINE TO EVALUATE RADIAL PARTS OF STO-3G */
/*       WAVEFUNCTIONS AS WELL AS THE MAINLINE CODE FOR THE REST. */
/*       REF FROM ORIGINAL CODE (FUNCTION AO): */

/*       ATOMS H TO AR ARE HANDLED ACCORDING TO J CHEM PHYS 51, 2657 */
/*       (1969), 52, 2769 (1970). */
/*       W.L. JORGENSEN - MARCH,1976, JULY, 1977. */

/*       REWRITTEN INTO A STAND-ALONE SUBROUTINE FOR CALCULATING ORBITAL */
/*       VALUES. REWORKED TO REDUCE REDUNDANT COMPUTATION OF POWERS AND */
/*       SQUARE ROOTS, AS WELL AS PUTTING INTO AN EASILY VECTORIZABLE */
/*       FORM FOR VECTOR MACHINES ( WE HAVE A CYBER 205 AT PURDUE, IT */
/*       WILL ALSO WORK AS WELL ON OTHER MACHINES). */

/*       DAN SEVERANCE 12/10/87 */

/*       AFTER DISCUSSION WITH JIM BRIGGS WHO HAS BEEN USING THIS PROGRAM */
/*       ON DR. JORGENSEN'S GOULD FOR THE LAST FEW WEEKS; THE AO */
/*       COMPUTATION AND WAVEFUNCTION READ WAS MOVED FROM THE MAIN LINE */
/*       TO THE RESPECTIVE SUBROUTINES.  WHEN A WAVEFUNCTION IS ADDED, */
/*       ONLY THE SUBROUTINE SHOULD NEED SIGNIFICANT MODIFICATION, THE */
/*       MAINLINE SHOULD ONLY NEED TO HAVE THE CALL ADDED. */
/*       DAN SEVERANCE 1/17/88 */

/*      REAL XMI,YMI,ZMI,XINC,YINC,ZINC */
/*      REAL C(MAXATM,3) */
/*      COMMON /IO/ IRD,ILST */

/*       12/10/87 DAN SEVERANCE */


/*       NOW INITIALIZE ALL OF THE NON-"R" DEPENDANT VALUES RATHER THAN */
/*       RECOMPUTING THEM MXPTS**3 TIMES IN THE Z,Y,X LOOP OVER THE */
/*       ORBITAL VALUE MATRIX (DENSIT) */

/*       THESE VALUES ARE ALSO INDEPENDANT OF ATOM TYPE, ONLY DEPENDANT */
/*       ON THE ROW OF THE PERIODIC TABLE AND WHETHER IT IS "S" OR "P" */
/*       INITIALIZE THEM HERE AND ACCESS THEM WITHIN THE NAT LOOP, BEFORE */
/*       ENTERING THE LOOP OVER THE GRID (CUBE) POINTS. */

    s_wsle(&io___94);
    do_lio(&c__9, &c__1, " EVALUATING THE SEMIEMPIRICAL WAVEFUNCTION", (
	    ftnlen)42);
    e_wsle();
    nao = 0;
    i__1 = split_1.natb;
    for (i__ = 1; i__ <= i__1; ++i__) {
	++nao;
	if (dens_1.ian[i__ - 1] > 2) {
	    nao += 3;
	    if (dens_1.ian[i__ - 1] > 18) {
		s_wsle(&io___97);
		do_lio(&c__9, &c__1, " ATOMIC NUMBERS > 18 NOT YET IMPLEMENT"
			"ED", (ftnlen)40);
		e_wsle();
	    }
	}
/* L10: */
    }
    s_wsle(&io___98);
    do_lio(&c__3, &c__1, (char *)&nao, (ftnlen)sizeof(integer));
    do_lio(&c__9, &c__1, " WAVEFUNCTIONS TO BE PROCESSED ", (ftnlen)31);
    e_wsle();

/*       READ IN EIGENVECTORS */
/*       IT IS ASSUMED THAT THE EIGENVECTORS HAVE BEEN NORMALIZED TO 1 */
/*       ELECTRON WITH THE OVERLAP MATRIX INCLUDED. FOR SEMI-EMPIRICAL */
/*       WAVEFUNCTIONS, THIS REQUIRES THE LOWDIN TRANSFORMATION AS */
/*       IMPLEMENTED IN THE MOPAC ROUTINE MULT. */

/*       THE ZETA VALUES ARE ASSUMED TO BE AT THE END OF THE DATA, ONE */
/*       FOR EACH ATOM NUMBER. (8F10.6) */

/*      IF (IONEMO.NE.0) THEN */
/*         READ (IRD,40) (V(I,1),I=1,NAO) */
/*         DO 20 I = 1, NAT */
/*               WRITE (ILST,*) 'ESTOY EN IONEMO NO ES CEROOOO' */
/*            READ (IRD,40) Z1(I),Z2(I),Z3(I) */
/*   20    CONTINUE */
/*      ELSE */
/*         READ (IRD,40,END=50) ((V(I,J),I=1,NAO),J=1,NAO) */
/*               WRITE (6,*) 'HE LEIDO' */
/*               WRITE (6,*) ((I,J,V(I,J),I=1,NAO),J=1,NAO) */
/*               WRITE (6,*) 'ESTOY EN IONEMO ES CEROOOO y NAO es', NAO */
/*         DO 30 I = 1, NAT */
/*            READ (IRD,40) Z1(I),Z2(I),Z3(I) */
/*   30    CONTINUE */
/*   40    FORMAT (8F10.6) */
/*      ENDIF */
/*   50 CONTINUE */
    mo = split_1.mone;
    i__1 = split_1.natb;
    for (j = 1; j <= i__1; ++j) {
	xyz[j * 3 - 3] = dens_1.c__[j * 3 - 3];
	xyz[j * 3 - 2] = dens_1.c__[j * 3 - 2];
	xyz[j * 3 - 1] = dens_1.c__[j * 3 - 1];
/* L60: */
    }
/*           XDEL */
    s_wsfe(&io___102);
    do_fio(&c__1, "XYZ", (ftnlen)3);
    i__1 = split_1.natb;
    for (i__ = 1; i__ <= i__1; ++i__) {
	for (j = 1; j <= 3; ++j) {
	    do_fio(&c__1, (char *)&xyz[j + i__ * 3 - 4], (ftnlen)sizeof(real))
		    ;
	}
    }
    e_wsfe();
/*        FINALIZO LA ESCRITURA DE DENSIDAD */
    x[0] = split_1.xmi;
    y[0] = split_1.ymi;
    z__[0] = split_1.zmi;
    for (i__ = 2; i__ <= 51; ++i__) {
	x[i__ - 1] = split_1.xinc + x[i__ - 2];
	y[i__ - 1] = split_1.yinc + y[i__ - 2];
	z__[i__ - 1] = split_1.zinc + z__[i__ - 2];
/* L70: */
    }

/*       THESE ARE THE FIRST PART OF THE EQUATIONS FOR 1S->3P, CALCULATE */
/*       THEM ONCE AND ONCE ONLY, REAL POWERS (**X.XX) ARE VERY SLOW */
/*       COMPUTATIONS.  THESE "CONTANTS" NS AND NP WILL BE MULTIPLIED */
/*       BY THE ATOM DEPENDANT - R INDEPENDANT VALUES TO FORM ONE SINGLE */
/*       CONSTANT FOR MULTIPLICATION WITHIN THE CUBE LOOP.  THIS WILL */
/*       SPEED COMPUTATION CONSIDERABLY RATHER THAN DOING ALL OF THIS IN */
/*       THE LOOP. */

/*       FIRST THE "NS" ORBITAL "CONSTANTS" */

    d__1 = (doublereal) a[0];
    cnstns[0] = pow_dd(&d__1, &c_b204) * d__[0];
    d__1 = (doublereal) a[3];
    cnstns[1] = pow_dd(&d__1, &c_b204) * d__[3];
    d__1 = (doublereal) a[6];
    cnstns[2] = pow_dd(&d__1, &c_b204) * d__[6];
    d__1 = (doublereal) a[1];
    cnstns[3] = pow_dd(&d__1, &c_b204) * d__[1];
    d__1 = (doublereal) a[4];
    cnstns[4] = pow_dd(&d__1, &c_b204) * d__[4];
    d__1 = (doublereal) a[7];
    cnstns[5] = pow_dd(&d__1, &c_b204) * d__[7];
    d__1 = (doublereal) a[2];
    cnstns[6] = pow_dd(&d__1, &c_b204) * d__[2];
    d__1 = (doublereal) a[5];
    cnstns[7] = pow_dd(&d__1, &c_b204) * d__[5];
    d__1 = (doublereal) a[8];
    cnstns[8] = pow_dd(&d__1, &c_b204) * d__[8];

/*       NOW FOR THE "NP" ORBITALS (THE SECOND ARG IS THE QUANTUM NUMBER) */
/*       THE QUANTUM NUMBER RANGES FROM 2,3 SINCE THERE IS NO 1P ORBITAL */

    d__1 = (doublereal) a[1];
    cnstnp[3] = pow_dd(&d__1, &c_b213) * d2p[0];
    d__1 = (doublereal) a[4];
    cnstnp[4] = pow_dd(&d__1, &c_b213) * d2p[1];
    d__1 = (doublereal) a[7];
    cnstnp[5] = pow_dd(&d__1, &c_b213) * d2p[2];
    d__1 = (doublereal) a[2];
    cnstnp[6] = pow_dd(&d__1, &c_b213) * d3p[0];
    d__1 = (doublereal) a[5];
    cnstnp[7] = pow_dd(&d__1, &c_b213) * d3p[1];
    d__1 = (doublereal) a[8];
    cnstnp[8] = pow_dd(&d__1, &c_b213) * d3p[2];

/*       ZERO THE ORBITAL VALUE ARRAY */

    for (iz = 1; iz <= 51; ++iz) {
	for (iy = 1; iy <= 51; ++iy) {
	    for (ix = 1; ix <= 51; ++ix) {
		dens_1.densit[ix + (iy + iz * 51) * 51 - 2653] = 0.f;
/* L80: */
	    }
/* L90: */
	}
/* L100: */
    }

/*       INITIALIZE THE AO COUNTER AND LOOP OVER ATOMS, IATB IS THE ATOMIC */
/*       NUMBER */

    m = 1;
    i__1 = split_1.natb;
    for (i__ = 1; i__ <= i__1; ++i__) {
	iatb = dens_1.ian[i__ - 1];

/*       COMPUTE XDEL,YDEL,AND ZDEL (I.E. DELTA X,Y, AND Z FROM THE ATOM */
/*       TO EACH POINT ON THE GRID.  ONLY MXPTS VALUES FOR EACH SINCE, */
/*       FOR INSTANCE, EVERY POINT ON A PARTICULAR XY PLANE IS THE SAME */
/*       DELTA Z VALUE FROM THE POINT.  THEREFORE YOU HAVE ONLY ONE VALUE */
/*       FOR THE ENTIRE PLANE FOR DELTA Z, INSTEAD OF (FOR MXPTS=51) */
/*       2601.  AGAIN, BY COMPUTING THIS HERE, RATHER THAN INSIDE THE */
/*       LOOP WE CUT DOWN THESE SUBTRACTIONS AND MULTIPLICATIONS BY */
/*       A FACTOR OF 2601 TO 1. THIS HAS A SUBSTANTIAL EFFECT ON THE */
/*       SPEED OF THE COMPUTATIONS. */

	for (ixyz = 1; ixyz <= 51; ++ixyz) {
	    xdel[ixyz - 1] = x[ixyz - 1] - xyz[i__ * 3 - 3];
	    xdelsq[ixyz - 1] = xdel[ixyz - 1] * xdel[ixyz - 1];
/* L110: */
	}
	for (ixyz = 1; ixyz <= 51; ++ixyz) {
	    ydel[ixyz - 1] = y[ixyz - 1] - xyz[i__ * 3 - 2];
	    ydelsq[ixyz - 1] = ydel[ixyz - 1] * ydel[ixyz - 1];
/* L120: */
	}
	for (ixyz = 1; ixyz <= 51; ++ixyz) {
	    zdel[ixyz - 1] = z__[ixyz - 1] - xyz[i__ * 3 - 1];
	    zdelsq[ixyz - 1] = zdel[ixyz - 1] * zdel[ixyz - 1];
/* L130: */
	}
/*           XDEL */
/*      WRITE (6,'(8F10.6)') 'XDEL ',(XDEL(IXYZ),IXYZ=1,MXPTS) */
/*        FINALIZO LA ESCRITURA DE DENSIDAD */

/*       FIRST THE H, HE ATOMS */

	s_wsfe(&io___120);
	do_fio(&c__1, "PROCESSING ATOM NUMBER ", (ftnlen)23);
	do_fio(&c__1, (char *)&i__, (ftnlen)sizeof(integer));
	do_fio(&c__1, " ATOMIC NUMBER ", (ftnlen)15);
	do_fio(&c__1, (char *)&iatb, (ftnlen)sizeof(integer));
	e_wsfe();
	if (iatb <= 2) {

/*       NOW CALCULATE THE NORMALIZATION FACTORS WHICH ARE ATOM TYPE AND */
/*       QUANTUM NUMBER DEPENDANT.  MULTIPLY BY THE "CONSTANTS" FOR THE */
/*       PARTICULAR A.O. AND THE EIGENVECTOR FOR THAT A.O. IN THE M.O. */
/*       SINCE IT IS ALSO POSITION INDEPENDANT.  THE R*COS(THETA) (XDEL, */
/*       YDEL,AND ZDEL) WILL HAVE TO BE DONE INSIDE THE X,Y,AND Z LOOPS */
/*       RESPECTIVELY FOR ATOMS WHICH HAVE "P" ORBITALS, HERE WE DON'T */
/*       NEED TO WORRY. */

	    zn = dens_1.z1[i__ - 1];
	    zsqrt = sqrt(zn);
	    zsq[0] = zn * zn;

/*       ZN * SQRT(ZN) * (2.0E+0/PI)**0.750E+0 */

	    rnorm = zn * zsqrt * .71270547f;
	    vnorm[0] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[0];
	    vnorm[1] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[1];
	    vnorm[2] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[2];

/*       THERE IS ONLY THE 1S TO EVALUATE */

	    aneg[0] = -a[0] * zsq[0];
	    aneg[1] = -a[3] * zsq[0];
	    aneg[2] = -a[6] * zsq[0];

/*       THE EXPONENTIATIONS RELATED TO XDEL,YDEL,AND ZDEL */
/*       THEY WILL BE MULTIPLIED IN THE LOOP, RATHER THAN */
/*       MAXPTS**3 SEPARATE EXPONENTIATIONS OVER R.  THESE */
/*       9*MXPTS MAKE THE UNIQUE ONES FOR 1S. (3 GAUSSIANS* */
/*       3 CARTESIAN COORDS * MXPTS PLANES ) */

	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		r__1 = xdelsq[ixyz - 1] * aneg[0];
		aexps[ixyz - 1] = gexp_(&r__1) * vnorm[0];
		r__1 = xdelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 50] = gexp_(&r__1) * vnorm[1];
		r__1 = xdelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 101] = gexp_(&r__1) * vnorm[2];
		r__1 = ydelsq[ixyz - 1] * aneg[0];
		aexps[ixyz + 152] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 203] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 254] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[0];
		aexps[ixyz + 305] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 356] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 407] = gexp_(&r__1);
/* L140: */
	    }
	    for (iz = 1; iz <= 51; ++iz) {
		for (iy = 1; iy <= 51; ++iy) {
		    for (ig = 1; ig <= 3; ++ig) {
			for (ix = 1; ix <= 51; ++ix) {

/*       CONTR IS THE SUM OF CONTRIBUTIONS OVER THIS YZ PLANE FOR THIS */
/*       ATOM.   WHEN FINISHED, SUM INTO THE ORBITAL VALUE ARRAY. */

			    dens_1.densit[ix + (iy + iz * 51) * 51 - 2653] += 
				    aexps[iy + (ig + 3) * 51 - 52] * aexps[iz 
				    + (ig + 6) * 51 - 52] * aexps[ix + ig * 
				    51 - 52];
/* L150: */
			}
/* L160: */
		    }
/* L170: */
		}
/* L180: */
	    }
	    ++m;
/*           ESCRIBO LA DENSIDAD DE S */
/*      WRITE (6,'(8F10.6)') (((DENSIT(NX,NY,NZ), */
/*     *   NX=1,MXPTS),NY=1,MXPTS),NZ=1,MXPTS) */
/*        FINALIZO LA ESCRITURA DE DENSIDAD */
	} else if (iatb <= 10) {

/*       CALC ZETA(2S) SQUARED AND SQRT FOR CONSTANTS. */

	    zn = dens_1.z1[i__ - 1];
	    zsqrt = sqrt(zn);
	    zsq[0] = zn * zn;

/*       ZN * SQRT(ZN) * (2.0E+0/PI)**0.750E+0 */

/*       VNORM(1-3) THE THE THREE GAUSSION "CONSTANTS" FOR THE 2S */
/*       ORBITAL, EVERYTHING THAT IS INDEPENDANT OF R IS IN THERE. */

	    rnorm = zn * zsqrt * .71270547f;
	    vnorm[0] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[3];
	    vnorm[1] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[4];
	    vnorm[2] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[5];

/*       CALC ZETA(2P) SQUARED AND SQRT FOR CONSTANTS. */

	    zn = dens_1.z2[i__ - 1];
	    zsqrt = sqrt(zn);
	    zsq[1] = zn * zn;

/*       ZN*ZN * SQRT(ZN) * ((128.0E+0/PI**3)**0.250E+0) */

/*       VNORM(1-3) CORRESPONDS TO THE 3 GAUSSIANS FOR THE 2S ORBITAL */
/*       VNORM(4-6) "                            " FOR THE 2PX "" */
/*       VNORM(7-9) "" FOR THE 2PY "" */
/*       VNORM(10-12) "" FOR THE 2PZ "" */
/*       YOU NEED DIFFERENT "CONSTANTS" FOR EACH DUE TO THE DIFFERENT */
/*       VALUE OF THE WAVEFUNCTION FOR EACH ORBITAL. AT THE END WE WILL */
/*       HAVE A 3 SETS OF NUMBERS ALL MULTIPLIED BY THE EXPONENTIAL, */
/*       WE CAN ADD THEM FIRST, THEN CALC. AND MULT. BY THE EXP. */

	    rnorm = zsq[1] * zsqrt * 1.42541094f;
	    aop1 = rnorm * cnstnp[3];
	    aop2 = rnorm * cnstnp[4];
	    aop3 = rnorm * cnstnp[5];
	    vnorm[3] = aop1 * dens_1.v[m + 1 + mo * 200 - 201];
	    vnorm[4] = aop2 * dens_1.v[m + 1 + mo * 200 - 201];
	    vnorm[5] = aop3 * dens_1.v[m + 1 + mo * 200 - 201];
	    vnorm[6] = aop1 * dens_1.v[m + 2 + mo * 200 - 201];
	    vnorm[7] = aop2 * dens_1.v[m + 2 + mo * 200 - 201];
	    vnorm[8] = aop3 * dens_1.v[m + 2 + mo * 200 - 201];
	    vnorm[9] = aop1 * dens_1.v[m + 3 + mo * 200 - 201];
	    vnorm[10] = aop2 * dens_1.v[m + 3 + mo * 200 - 201];
	    vnorm[11] = aop3 * dens_1.v[m + 3 + mo * 200 - 201];
	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		cnstx[ixyz - 1] = vnorm[3] * xdel[ixyz - 1];
		cnstx[ixyz + 50] = vnorm[4] * xdel[ixyz - 1];
		cnstx[ixyz + 101] = vnorm[5] * xdel[ixyz - 1];
		cnsty[ixyz - 1] = vnorm[6] * ydel[ixyz - 1];
		cnsty[ixyz + 50] = vnorm[7] * ydel[ixyz - 1];
		cnsty[ixyz + 101] = vnorm[8] * ydel[ixyz - 1];
		cnstz[ixyz - 1] = vnorm[9] * zdel[ixyz - 1];
		cnstz[ixyz + 50] = vnorm[10] * zdel[ixyz - 1];
		cnstz[ixyz + 101] = vnorm[11] * zdel[ixyz - 1];
/* L190: */
	    }

/*       EVALUATE 2S AND 2P */

/*       MINUS ALPHA FOR 2S: */

	    aneg[0] = -a[1] * zsq[0];
	    aneg[1] = -a[4] * zsq[0];
	    aneg[2] = -a[7] * zsq[0];

/*       MINUS ALPHA FOR 2P: */

	    aneg[3] = -a[1] * zsq[1];
	    aneg[4] = -a[4] * zsq[1];
	    aneg[5] = -a[7] * zsq[1];

/*       PRECOMPUTE EXP(-A*Z**2*DELO**2) WHERE DELO**2 IS */
/*       DELTA-X**2, DELTA-Y**2, AND DELTA-Z**2 */

	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		r__1 = xdelsq[ixyz - 1] * aneg[0];
		aexps[ixyz - 1] = gexp_(&r__1) * vnorm[0];
		r__1 = xdelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 50] = gexp_(&r__1) * vnorm[1];
		r__1 = xdelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 101] = gexp_(&r__1) * vnorm[2];
		r__1 = ydelsq[ixyz - 1] * aneg[0];
		aexps[ixyz + 152] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 203] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 254] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[0];
		aexps[ixyz + 305] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 356] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 407] = gexp_(&r__1);
/* L200: */
	    }
	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		r__1 = xdelsq[ixyz - 1] * aneg[3];
		aexpp[ixyz - 1] = gexp_(&r__1);
		r__1 = xdelsq[ixyz - 1] * aneg[4];
		aexpp[ixyz + 50] = gexp_(&r__1);
		r__1 = xdelsq[ixyz - 1] * aneg[5];
		aexpp[ixyz + 101] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[3];
		aexpp[ixyz + 152] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[4];
		aexpp[ixyz + 203] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[5];
		aexpp[ixyz + 254] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[3];
		aexpp[ixyz + 305] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[4];
		aexpp[ixyz + 356] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[5];
		aexpp[ixyz + 407] = gexp_(&r__1);
/* L210: */
	    }

/*       LOOP OVER THE "CUBE" Z,Y, AND X */

	    for (iz = 1; iz <= 51; ++iz) {
		for (iy = 1; iy <= 51; ++iy) {
		    for (ig = 1; ig <= 3; ++ig) {
			for (ix = 1; ix <= 51; ++ix) {

/*       SUM THE ORBITAL CONTRIBUTIONS INTO THE ORBITAL VALUE ARRAY */

/*       FIRST THE 3 GAUSSIANS FOR THE 2S: */

			    dens_1.densit[ix + (iy + iz * 51) * 51 - 2653] += 
				    aexps[iy + (ig + 3) * 51 - 52] * aexps[iz 
				    + (ig + 6) * 51 - 52] * aexps[ix + ig * 
				    51 - 52];

/*       NEXT, THE 3 FOR THE 2P: */

			    dens_1.densit[ix + (iy + iz * 51) * 51 - 2653] += 
				    (cnsty[iy + ig * 51 - 52] + cnstz[iz + ig 
				    * 51 - 52] + cnstx[ix + ig * 51 - 52]) * 
				    aexpp[ix + ig * 51 - 52] * aexpp[iy + (ig 
				    + 3) * 51 - 52] * aexpp[iz + (ig + 6) * 
				    51 - 52];
/* L220: */
			}
/* L230: */
		    }
/* L240: */
		}
/* L250: */
	    }
	    m += 4;
	} else if (iatb <= 18) {

/*       CALC ZETA(3S) SQUARED AND SQRT FOR CONSTANTS. */

	    zn = dens_1.z1[i__ - 1];
	    zsqrt = sqrt(zn);
	    zsq[0] = zn * zn;

/*       ZN * SQRT(ZN) * (2.0E+0/PI)**0.750E+0 */

/*       VNORM(1-3) THE THE THREE GAUSSION "CONSTANTS" FOR THE 3S */
/*       ORBITAL, EVERYTHING THAT IS INDEPENDANT OF R IS IN THERE. */

	    rnorm = zn * zsqrt * .71270547f;
	    vnorm[0] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[6];
	    vnorm[1] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[7];
	    vnorm[2] = rnorm * dens_1.v[m + mo * 200 - 201] * cnstns[8];

/*       CALC ZETA(2P) SQUARED AND SQRT FOR CONSTANTS. */

	    zn = dens_1.z2[i__ - 1];
	    zsqrt = sqrt(zn);
	    zsq[1] = zn * zn;

/*       ZN*ZN * SQRT(ZN) * ((128.0E+0/PI**3)**0.250E+0) */

/*       VNORM(1-3) CORRESPONDS TO THE 3 GAUSSIANS FOR THE 3S ORBITAL */
/*       VNORM(4-6) "                            " FOR THE 3PX "" */
/*       VNORM(7-9) "" FOR THE 3PY "" */
/*       VNORM(10-12) "" FOR THE 3PZ "" */
/*       YOU NEED DIFFERENT "CONSTANTS" FOR EACH DUE TO THE DIFFERENT */
/*       VALUE OF THE WAVEFUNCTION FOR EACH ORBITAL. AT THE END WE WILL */
/*       HAVE A 3 SETS OF NUMBERS ALL MULTIPLIED BY THE EXPONENTIAL, */
/*       WE CAN ADD THEM FIRST, THEN CALC. AND MULT. BY THE EXP. */

	    rnorm = zsq[1] * zsqrt * 1.42541094f;
	    aop1 = rnorm * cnstnp[6];
	    aop2 = rnorm * cnstnp[7];
	    aop3 = rnorm * cnstnp[8];
	    vnorm[3] = aop1 * dens_1.v[m + 1 + mo * 200 - 201];
	    vnorm[4] = aop2 * dens_1.v[m + 1 + mo * 200 - 201];
	    vnorm[5] = aop3 * dens_1.v[m + 1 + mo * 200 - 201];
	    vnorm[6] = aop1 * dens_1.v[m + 2 + mo * 200 - 201];
	    vnorm[7] = aop2 * dens_1.v[m + 2 + mo * 200 - 201];
	    vnorm[8] = aop3 * dens_1.v[m + 2 + mo * 200 - 201];
	    vnorm[9] = aop1 * dens_1.v[m + 3 + mo * 200 - 201];
	    vnorm[10] = aop2 * dens_1.v[m + 3 + mo * 200 - 201];
	    vnorm[11] = aop3 * dens_1.v[m + 3 + mo * 200 - 201];
	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		cnstx[ixyz - 1] = vnorm[3] * xdel[ixyz - 1];
		cnstx[ixyz + 50] = vnorm[4] * xdel[ixyz - 1];
		cnstx[ixyz + 101] = vnorm[5] * xdel[ixyz - 1];
		cnsty[ixyz - 1] = vnorm[6] * ydel[ixyz - 1];
		cnsty[ixyz + 50] = vnorm[7] * ydel[ixyz - 1];
		cnsty[ixyz + 101] = vnorm[8] * ydel[ixyz - 1];
		cnstz[ixyz - 1] = vnorm[9] * zdel[ixyz - 1];
		cnstz[ixyz + 50] = vnorm[10] * zdel[ixyz - 1];
		cnstz[ixyz + 101] = vnorm[11] * zdel[ixyz - 1];
/* L260: */
	    }

/*       EVALUATE 3S AND 3P */

/*       MINUS ALPHA FOR 3S: */

	    aneg[0] = -a[2] * zsq[0];
	    aneg[1] = -a[5] * zsq[0];
	    aneg[2] = -a[8] * zsq[0];

/*       MINUS ALPHA FOR 3P: */

	    aneg[3] = -a[2] * zsq[1];
	    aneg[4] = -a[5] * zsq[1];
	    aneg[5] = -a[8] * zsq[1];

/*       PRECOMPUTE EXP(-A*Z**2*DELO**2) WHERE DELO**2 IS */
/*       DELTA-X**2, DELTA-Y**2, AND DELTA-Z**2 */

	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		r__1 = xdelsq[ixyz - 1] * aneg[0];
		aexps[ixyz - 1] = gexp_(&r__1) * vnorm[0];
		r__1 = xdelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 50] = gexp_(&r__1) * vnorm[1];
		r__1 = xdelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 101] = gexp_(&r__1) * vnorm[2];
		r__1 = ydelsq[ixyz - 1] * aneg[0];
		aexps[ixyz + 152] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 203] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 254] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[0];
		aexps[ixyz + 305] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[1];
		aexps[ixyz + 356] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[2];
		aexps[ixyz + 407] = gexp_(&r__1);
/* L270: */
	    }
	    for (ixyz = 1; ixyz <= 51; ++ixyz) {
		r__1 = xdelsq[ixyz - 1] * aneg[3];
		aexpp[ixyz - 1] = gexp_(&r__1);
		r__1 = xdelsq[ixyz - 1] * aneg[4];
		aexpp[ixyz + 50] = gexp_(&r__1);
		r__1 = xdelsq[ixyz - 1] * aneg[5];
		aexpp[ixyz + 101] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[3];
		aexpp[ixyz + 152] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[4];
		aexpp[ixyz + 203] = gexp_(&r__1);
		r__1 = ydelsq[ixyz - 1] * aneg[5];
		aexpp[ixyz + 254] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[3];
		aexpp[ixyz + 305] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[4];
		aexpp[ixyz + 356] = gexp_(&r__1);
		r__1 = zdelsq[ixyz - 1] * aneg[5];
		aexpp[ixyz + 407] = gexp_(&r__1);
/* L280: */
	    }

/*       LOOP OVER THE "CUBE" Z,Y, AND X */

	    for (iz = 1; iz <= 51; ++iz) {
		for (iy = 1; iy <= 51; ++iy) {
		    for (ig = 1; ig <= 3; ++ig) {
			for (ix = 1; ix <= 51; ++ix) {

/*       SUM THE ORBITAL CONTRIBUTIONS INTO THE ORBITAL VALUE ARRAY */

/*       FIRST THE 3 GAUSSIANS FOR THE 3S: */

			    dens_1.densit[ix + (iy + iz * 51) * 51 - 2653] += 
				    aexps[iy + (ig + 3) * 51 - 52] * aexps[iz 
				    + (ig + 6) * 51 - 52] * aexps[ix + ig * 
				    51 - 52];

/*       NEXT, THE 3 FOR THE 3P: */

			    dens_1.densit[ix + (iy + iz * 51) * 51 - 2653] += 
				    (cnsty[iy + ig * 51 - 52] + cnstz[iz + ig 
				    * 51 - 52] + cnstx[ix + ig * 51 - 52]) * 
				    aexpp[ix + ig * 51 - 52] * aexpp[iy + (ig 
				    + 3) * 51 - 52] * aexpp[iz + (ig + 6) * 
				    51 - 52];
/* L290: */
			}
/* L300: */
		    }
/* L310: */
		}
/* L320: */
	    }
	    m += 4;
	}
/* L330: */
    }
    return 0;
} /* mosemi_ */

doublereal gexp_(real *x)
{
    /* System generated locals */
    real ret_val;

    /* Builtin functions */
    double exp(doublereal);

/*      DOUBLE PRECISION X */
    if (*x >= -19.f) {
	ret_val = exp(*x);
    } else {
	ret_val = 0.f;
    }
    return ret_val;
} /* gexp_ */

/* Main program alias */ int mopbran_ () { MAIN__ (); return 0; }
