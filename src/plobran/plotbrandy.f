C	PROGRAMA DE LECTURA DE FICHERO GRAPH DE MOPAC Y GENERACION
C	DE ORBITAL MOLECULAR EN FORMATO VTK. LEO DE LINEA DE COMANDOS
C	EL NUMERO DEL ORBITAL DESEADO.EL PROGRAMA LEE EL FICHERO
C	FOR013 GENERADO POR MOPAC CON LA PALABRA 'GRAPH'PARA CREAR EL ORBITAL
C
C	DEFINO EL NOMBRE DEL PROGRAMA
      PROGRAM MOPBRAN
C	DEFINIMOS LOS PARAMETROS QUE NECESITAMOS POR DEFECTO EN
C	MAXIMO NUMERO DE ATOMOS
C      IMPLICIT NONE
      PARAMETER (MAXATM=50)
C	MAXIMO NUMERO DE PUNTOS DE LA CAJA DEL GRAFICO	
      PARAMETER (MXPTS=51)
C	MAXIMO NUMERO DE ORBITALES
      PARAMETER (MAXORB=200)
      IMPLICIT REAL (A-D,F-H,O-Z)
      IMPLICIT DOUBLE PRECISION (E)
C
C	VARIABLES RELACIONADAS CON LA DENSIDAD ELECTRONICA
C	EN DOBLE PRECISION PARA LA LECTURA DE GRAPH
C
	COMMON /DENSDP/ EC(40000),EH(40000),EVECS(40000),
     *  EZ1(MAXATM),EZ2(MAXATM),EZ3(MAXATM),EXYZ(3,MAXATM)
C
C	VARIABLES RELACIONADAS CON LA DENSIDAD ELECTRONICA
C
C	DENSIT(I,J,K)  DENSIDAD ELECTRONICA EN EL PUNTO I,J,K
C	V(I,J) CONTIENE LOS COEFICIENTES DEL ORBITAL J EN EL OM I
C	C(I,J) CORDENADAS CARTESIANAS J DEL ATOMO I
C	F(I) EIGENVECTORES NO NORMALIZADOS LEIDOS DE FOR013 I VA
C	DE 1 A MAXORB*MAXORB
C	H(I) RAIZ CUADRDA DE LA INVERSA DE LA MATRIZ DE SOLAPAMIENTO 
C	ORBITAL. I VA DE 1 A MAXORB*MAXORB
C	U(I) ES LA MATRIZ DE COEFICIENTES DE EIGENVECTOR NORMALIZADA 
C	ES EQUIVALENTE A V(I,J) PERO CON UN SOLO SUBSCRIPT 
C	IAN(I) NUMERO AT�MICO DEL ATOMO I
C	Z1(I) EXPONENTE DEL ORBITAL S EN EL ATOMO I
C	Z2(I) EXPONENTE DEL ORBITAL P EN EL ATOMO I
C	Z3(I) EXPONENTE DEL ORBITAL D EN EL ATOMO I
      COMMON /DENS/ DENSIT(MXPTS,MXPTS,MXPTS),V(MAXORB,MAXORB),C(3,
     *   MAXATM),IAN(MAXATM),F(40000),H(40000),Z1(MAXATM),
     *   Z2(MAXATM),Z3(MAXATM),U(40000)
C	VARIABLES RELACIONADAS CON EL ORBITAL MOLECULAR A LEER Y LAS
C	DIMENSIONES DE LA CAJA 
C	XMI VALOR MINIMO DE LA COORDENADA X (EN UNIDADES ATOMICAS)
C	YMI VALOR MINIMO DE LA COORDENADA Y (EN UNIDADES ATOMICAS)
C	ZMI VALOR MINIMO DE LA COORDENADA Z (EN UNIDADES ATOMICAS)
C	XINC INCREMENTO DE X POR PUNTO  (EN UNIDADES ATOMICAS)
C	YINC INCREMENTO DE Y POR PUNTO  (EN UNIDADES ATOMICAS)
C	ZINC INCREMENTO DE Z POR PUNTO  (EN UNIDADES ATOMICAS)
C	MONE PRIMER ORBITAL A LEER
C	MOLAST ULTIMO ORBITAL A LEER
C	NATB CONTADOR DE ATOMOS 
C	
      COMMON /SPLIT/ XMI,YMI,ZMI,XINC,YINC,ZINC,MONE,MOLAST,
     *   NATB,IONEMO
C      REAL XMI,YMI,ZMI,XINC,YINC,ZINC,MONE,MOLAST
C	CO(I) DIMENSION DE LA CAJA LA DIRECCION I (X Y O Z)
C	CMIN(I) VALOR MINIMO DE LA CAJA EN LA COMPONENTE I
C	CMAX(I) VALOR MAXIMO DE LA CAJA EN LA COMPONENTE I
      DIMENSION CO(3),CMIN(3),CMAX(3),DENSITN(MXPTS,MXPTS,MXPTS),
     *    DENSITP(MXPTS,MXPTS,MXPTS)
C      REAL CO(3),CMIN(3),CMAX(3)
C	IAT(I) NUMERO DE ELECTROPNES DE VALENCIA DE UN ATOMO DE 
C	NUMERO ATOMICO I
C	NLAST(I) CONTADOR DE ORBITALES NO SE PA QUE SIRVE
C	NFIRST(I) CONTADOR DE ORBITALES NO SE PA QUE SIRVE
C	NAT(I) NUMERO ATOMICO DE ATOMO I
C	
      INTEGER TOTAL,NLAST(MAXATM),NFIRST(MAXATM),IAT(26),
     *        NAT(MAXATM)
C      CHARACTER*10 SUBTIT
      CHARACTER*25 CHBUF

C
C	INICIALIZO LA MATRIZ IAT QUE POSEE EL NUMERO DE ELECTRONES DE
C	VALENCIA DE UN ATOMO DE NUMERO ATOMICO I
C
      DATA IAT / 1,2,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8 /
C	CONVIERTO LAS DISTANCIAS LEIDAS EN AMSTRONG EN FOR013
C	A UNIDADES ATOMICAS PARA HACER EL CALCULO DE LA DENSIDAD
C	1 AU = 5.291670�10-11 m= 0.5291670
      DATA AU / 0.5291670E+0 /
C
C
C	VERSION 1.0 DE MOPBRAN
C	LO PRIMERO QUE SE HACE ES LEER EL FICHERO FOR013 Y ASIGNAR
C	LAS VARIABLES OBTENIDAS DE EL:
C	MOPAC ESCRIBE ESTE FICHERO EN LA SUBRUTINA MULLIK
C	Y LO HACE EN EL SIGUIENTE ORDEN
C	NUMERO DE ATOMOS, ORBITALES Y ELECTRONES
C	COORDENADAS CARTESIANAS DE TODOS LOS ATOMOS
C	CONTADOR DE ORBITALES
C	EXPONENTES ORBITALES S, P Y D Y NUMERO ATOMICO
C	EIGENVECTORES NO NORMALIZADOS 
C	RAIZ CUADRDA DE LA INVERSA DE LA MATRIZ DE SOLAPAMIENTO 
C	ORBITAL. 
C	
C      NUMBER OF ATOMS, ORBITAL, ELECTRONS
C      ALL ATOMIC COORDINATES
C      ORBITAL COUNTERS
C      ORBITAL EXPONENTS, S, P, AND D, AND ATOMIC NUMBERS
C      EIGENVECTORS (M.O.S NOT RE-NORMALISED)
C      INVERSE-SQUARE ROOT OF THE OVERLAP MATRIX.
C
C
      OPEN (UNIT=13,FILE='FOR013',STATUS='old',FORM='UNFORMATTED')
      READ (13) NUMAT,NORBS,NELECS,((EXYZ(I,J),J=1,NUMAT),I=1,3)
      NATB = NUMAT

      READ (13) (NLAST(I),NFIRST(I),I=1,NUMAT)
      READ (13) (EZ1(I),I=1,NUMAT),(EZ2(I),I=1,NUMAT),(EZ3(I),
     *   I=1,NUMAT),(NAT(I),I=1,NUMAT)
C
      DO 4 I = 1,NUMAT
	IAN(I) = NAT(I)
   4  CONTINUE

      LINEAR = NORBS*NORBS
C
      READ (13) (EC(I),I=1,LINEAR)
      READ (13) (EH(I),I=1,LINEAR)
C	A PARTIR DE LOS VALORES DE EIGENV NO NORMALIZADOS
C	OBTENGO LA MATRIZ EVECS(I) NORMALIZADA USO LA SUBRUTINA
C	MULT QUE PROVIENE DE MOPAC
      CALL MULT (EC,EH,EVECS,NORBS)
C
C	AHORA CREO LA MATRIZ CORRECTA REAL PARA LA ENTRADA EN MOSEMI
C	DE LOS VALORES DE EIGENV NORMALIZADOS QUE SON DE DOUBLE PRECISION 
C	ES LA MATRIZ V(I,J)
         DO 6 I = 1, NORBS
            DO 5 J = 1, NORBS
		JJ = J + (NORBS*(I-1))
               V(J,I) = REAL(EVECS(JJ))
   5       CONTINUE
   6    CONTINUE
C	AHORA CONVIERTO LOS VALORES DE DOBLE PRECISION 
C	LEIDOS DE GRAPH A VALORES REALES PARA TODAS LAS 
C	VARIABLES AL OBJETO DE ENVIARLAS A 
C	MOSEMI SIN ERRORES APROVECHO EL CALCULO DE TOTAL 
C	PARA HACER LA CONVERSION
C
C	DETERMINO EL NUMERO DE ELECTRONES TOTAL
C	DE LA MOLECULA BASANDOME EN EL NUMERO ATOMICO
C	LEIDO EN GRAPH Y EN LA MATRIZ DE DATOS IAT
C	QUE CONTIENE LOS ELECTRONES DE VALENCIA DE CADA
C	NUMERO ATOMICO
      TOTAL = 0
      DO 10 I = 1, NUMAT
	 Z1(I) = REAL(EZ1(I))
	 Z2(I) = REAL(EZ2(I))
	 Z3(I) = REAL(EZ3(I))
         ITMP = NAT(I)
         TOTAL = TOTAL+IAT(ITMP)
C
C	PONGO A CERO LOS COEFICIENTES ZETA (D) YA QUE MOPAC
C	ASIGNA 1 A TODOS ESTOS VALORES INCLUSO AUNQUE NO TENGAN
C	ORBITALES D
C
         EZ3(I) = 0.0D+0
   10 CONTINUE
C	AHORA CREO LA MATRIZ DE COORDENADAS CARTESIANAS
C	EN FORMATO REAL A PARTIR DE LA DE DOBLE PRECISION
         DO 12 I = 1, NUMAT
            DO 11 J = 1, 3
               C(J,I) = REAL(EXYZ(J,I))
   11       CONTINUE
   12    CONTINUE
C
C	CALCULO LA CARGA ELECTRICA DEL SISTEMA ICHRG
C	CONOCIENDO EL NUMERO DE ELECTRONES TEORICO
C	Y EL REAL QUE HE LEIDO DE GRAPH ADEMAS ESTIMO EL 
C	VALOR DEL HOMO Y LUMO IHOMO  ILUMO
      ICHRG = TOTAL-NELECS
      IHOMO = (NELECS+1)/2
      ILUMO = IHOMO+1
C
C   20 WRITE(*,*)
C      WRITE (*,'(A,I4,A,I4)')' The HOMO is MO number ',IHOMO,
C     *  ' The LUMO is MO number ',ILUMO
C      WRITE(*,*)
C      WRITE (*,'(A,$)') ' WHICH MO DO YOU WISH TO PLOT? '
C      READ (*,*) IMO
C     LEO EL ORBITAL DE LA LINEA DE ENTRADA QUE 
C	QUE QUIERO CALCULAR 
      CALL GETARG(1,CHBUF)
      READ (CHBUF,*) IMO
C      IF (IMO.LT.0.OR.IMO.GT.TOTAL) GO TO 20
C
C FIJO EL VALOR DE ESCALA
C
      SCALE = 1.4E+0
      IONE = 1
      MONE = IMO
      MOLAST = IMO
      IBEG = (IMO-1)*NORBS+1
      IEND = IBEG+NORBS-1
C
C	AHORA DEBO SEGUIR UN  PROTOCOLO 
C	SIMILAR AL QUE SIGUE PSI1
C	COMO TENGO EN MEMORIA TODOS LOS VALKORES NO HE DE LEERLOS
C	LO PRIMERO DETERMINAR LA CAJA DEL SISTEMA 
C	ESTO LO HACE LA SUBRUTINA DRAMNP
      CALL DRAMNP (C,NUMAT,CO,CMIN,CMAX)
C         WRITE (6,*) ' DIMENSIONES MINIMAS'	
C         WRITE (6,*) (CMIN(I),I=1,3)
C         WRITE (6,*) ' DIMENSIONES MAXIMAS'	
C         WRITE (6,*) (CMAX(I),I=1,3)
C         WRITE (6,*) ' DIMENSIONES CENTRAL'	
C         WRITE (6,*) (CO(I),I=1,3)
C
C	CONVIERTO LAS COORDENADAS EN AMSTRONG OBTENIDAS DE GRAPH
C	A UNIDADES ATOMICAS 
C
      AUINV = 1.0E+0/AU
      DO 30 I = 1, 3
         DO 20 J = 1, NATB
            C(I,J) = C(I,J)*AUINV
   20    CONTINUE
   30 CONTINUE
C
C	DEFINO EL NUMERO DE PUNTOS DEFINIDO EN UNIDADES ATOM
C
      SPACES = FLOAT(MXPTS-1)*AU
C       SPACES = FLOAT(MXPTS-1)
C
C	INCREMENTO EL RANGO DEL PLOT
C
C         R = 1.82E+0
          R = 3.0
         XMIN = CMIN(1)-R
         XMAX = CMAX(1)+R
         YMIN = CMIN(2)-R
         YMAX = CMAX(2)+R
         ZMIN = CMIN(3)-R
         ZMAX = CMAX(3)+R
      XMI = XMIN/AU
      YMI = YMIN/AU
      ZMI = ZMIN/AU
      XINC = (XMAX-XMIN)/SPACES
      YINC = (YMAX-YMIN)/SPACES
      ZINC = (ZMAX-ZMIN)/SPACES
C
C	YA TENGO LOS VALORES NECESARIOS EN MEMORIA
C	EJECUTO MOSEMI
C
      CALL MOSEMI


C     GENERO UN FICHERO CON LAS COORDENADAS DE LA MOLECULA
C     SEGUN LO QUE CONTIENE EL GPT
      OPEN (UNIT=22,FILE='CGRAPH.COR')
C      DO 40 I = 1,NUMAT
      WRITE (22,*) 'COORDENADAS DE FOR013 EN FORMATO GPT'
      WRITE (22,*) 'powered by BANSHEE&GT&FN'
      WRITE (22,*) ''
      WRITE (22,*) 'NUMATOM COORX COORY COORZ'


      DO 57 I = 1, NUMAT
C             WRITE (22,*) IAN(I), ' ', (EXYZ(1,I) *AUINV),
C     *       (EXYZ(2,I)*AUINV) , ((EXYZ(3,I) +R) *AUINV)
            WRITE (22,*) IAN(I), ' ',
     *       (C(1,I))*AU,
     *       (C(2,I))*AU,
     *       (C(3,I))*AU
            WRITE (*,*) IAN(I), ' ',
     *       (C(1,I))*AU,
     *       (C(2,I))*AU,
     *       (C(3,I))*AU

C             WRITE (22,*) IAN(I), ' ', (EXYZ(1,I) + CMIN(1) + R),
C     *       (EXYZ(2,I) + CMIN(2) + R), (EXYZ(3,I) + CMIN(3) + R)
   57 CONTINUE

C      WRITE (22,*) 'NUMATOM'        ,(IAN(I),I=1,NUMAT)
C      WRITE (22,*) 'COORDENADAS X ',(EXYZ(1,J),J=1,NUMAT)
C      WRITE (22,*) 'COORDENADAS Y ',(EXYZ(2,J),J=1,NUMAT)
C      WRITE (22,*) 'COORDENADAS Z ',(EXYZ(3,J),J=1,NUMAT)
        WRITE (22,*) SPACES
      CLOSE (22)
C   40  CONTINUE
C
C	ESCRIBO LA MATRIZ DENSIDAD EN ORBITAL.VTK
C
      OPEN (UNIT=24,FILE='BORB.VTK')
      MAXPTS = MXPTS
C
C     CALCULO LA DENSIDAD ELECTRONICA MAXIMA Y MINIMA
C
      DMIN = 1000.0E+0
      DMAX = -1000.0E+0
      DO 110 K = 1, MAXPTS
         DO 100 J = 1, MAXPTS
            DO 90 I = 1, MAXPTS
               DMIN = MIN(DMIN,DENSIT(I,J,K))
               DMAX = MAX(DMAX,DENSIT(I,J,K))
	       DENSITN(I,J,K) = 0.0E+0
	       DENSITP(I,J,K) = 0.0E+0
	       IF (DENSIT(I,J,K).LE.O) THEN
	       DENSITN(I,J,K) = DENSIT(I,J,K)
	       ELSE
	       DENSITP(I,J,K) = DENSIT(I,J,K)
	       ENDIF
   90       CONTINUE
  100    CONTINUE
  110 CONTINUE
      WRITE (6,*) 'MIN, MAX DENSITY(VALUE) COMPUTED IS ',DMIN,DMAX
C	DECIDO CUAL DE LOS DOS VALORES ABSOLUTOS DMIN O DMAX ES MAYOR
C      IF (IMO.LT.0.OR.IMO.GT.TOTAL) GO TO 20
C      WRITE (17,'(2I3)') MAXPTS,NAT
C	DECIDO QUIEN ES MAYOR EN VALOR ABSOLUTO DMIN O DMAX
         IF (ABS(DMIN).GT.ABS(DMAX)) THEN
            VALMAX = ABS(DMIN)
	 ELSE
            VALMAX = ABS(DMAX)
         ENDIF
         WRITE (6,*) 'NORBS ', NORBS,'NATB ',NATB
         SPACES = 51
         XINC = (XMAX-XMIN)/SPACES
         YINC = (YMAX-YMIN)/SPACES
         ZINC = (ZMAX-ZMIN)/SPACES

C       ESCRIBO LOS RESULTADOS EN EL FICHERO VTK
      WRITE (24,'(A)') '# vtk DataFile Version 2.0'
      WRITE (24,'(A)') 'A Simple Matrix of values'
      WRITE (24,'(A)') 'ASCII'
      WRITE (24,'(A)') 'DATASET STRUCTURED_POINTS'
      WRITE (24,*) 'DIMENSIONS ', INT(SPACES),
     * INT(SPACES), INT(SPACES)
      WRITE (24,*) 'ORIGIN ',XMIN,YMIN,ZMIN
      WRITE (24,*) 'SPACING ',XINC,YINC,ZINC
      WRITE (24,'(A)') ' '
      WRITE (24,*) 'POINT_DATA ', INT(SPACES)**3
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      WRITE (24,'(A)') 'SCALARS POS float'
      WRITE (24,'(A)') 'LOOKUP_TABLE default'
      WRITE (24,'(4I5)') (((ABS(INT((DENSITP(NX,NY,NZ)*256)/VALMAX)),
     *   NX=1,INT(SPACES)),NY=1,INT(SPACES)),NZ=1,INT(SPACES))
      WRITE (24,'(A)') 'SCALARS NEG float'
      WRITE (24,'(A)') 'LOOKUP_TABLE default'
      WRITE (24,'(4I5)') (((ABS(INT((DENSITN(NX,NY,NZ)*256)/
     *   VALMAX)),NX=1,INT(SPACES)),NY=1,INT(SPACES)),NZ=1,INT(SPACES))
      WRITE (24,'(A)') 'SCALARS TOT float'
      WRITE (24,'(A)') 'LOOKUP_TABLE default'
      WRITE (24,'(4I5)') (((ABS(INT((DENSIT(NX,NY,NZ)*256)/
     *   VALMAX)),NX=1,MAXPTS),NY=1,MAXPTS),NZ=1,MAXPTS)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C      WRITE (24,'(8F10.6)') ((V(I,J),I=1,NORBS),J=1,NORBS)
C      WRITE (24,'(8F10.6)') (((DENSIT(NX,NY,NZ),
C     *   NX=1,MAXPTS),NY=1,MAXPTS),NZ=1,MAXPTS)
C
C	FIN DE PLOTBRAN
C
      STOP
      END
C
C
      SUBROUTINE MULT (EG,ES,EVECS,N)
      IMPLICIT REAL (A-D,F-H,O-Z)
      IMPLICIT DOUBLE PRECISION (E)
      DIMENSION EG(N,*),ES(N,*),EVECS(N,*)
C
C**********************************************************************
C
C   THIS ROUTINE TAKEN FROM MOPAC BY J.S. STEWART
C
C   MULT IS USED IN THE MULLIKEN ANALYSIS ONLY. IT PERFORMS THE
C        OPERATION:-
C                                   VECS=BACK-TRANSFORMED EIGENVECTORS
C        VECS  =  C*S               C   =UN-BACK-TRANSFORMED VECTORS
C                                   S   =1/SQRT(OVERLAP MATRIX)
C
C**********************************************************************
C
      DO 30 I = 1, N
         DO 20 J = 1, N
C
C COMPUTE FIRST ELEMENT HERE (K=1) TO INITIALIZE SUM
C
            EVECS(J,I) = EG(1,I)*ES(J,1)
            DO 10 K = 2, N
               EVECS(J,I) = EVECS(J,I)+EG(K,I)*ES(J,K)
   10       CONTINUE
            ESUM = EVECS(J,I)
   20    CONTINUE
   30 CONTINUE
      RETURN
      END
C
C**********************************************************************
C
C   RUTINA TOMADA DE PSI1 DE  DANIEL L. SEVERANCE Y
C      WILLIAM L. JORGENSEN
C	RECIBE COMO ENTRADA 
C	C(I,J) SON LAS COORDENADAS J (1-3=X-Z) DEL ATOMO I
C	NAT NUMERO DE ATOMOS
C	Y CALCULA EL VALOR DE 
C	CO(I) COMPOPNENTE I (1-3=X-Z) DEL VECTOR DEL CENTRO DE LA CAJA
C	CMIN(I) VALOR MIN EN AMSTRONG DE LA COMPONENTE I DE LA CAJA
C	CMAX(I) VALOR MAX EN AMSTRONG DE LA COMPONENTE I DE LA CAJA
C**********************************************************************
C

      SUBROUTINE DRAMNP (C,NAT,CO,CMIN,CMAX)
      IMPLICIT REAL (A-D,F-H,O-Z)
      IMPLICIT DOUBLE PRECISION (E)
      PARAMETER (MAXATM=50)
      DIMENSION C(3,MAXATM),CO(3),CMIN(3),CMAX(3)
C      REAL C(MAXATM,3),CO(3),CMIN(3),CMAX(3)
C
C       THIS ROUTINE DETERMINES CO AND CM WHICH ARE USED
C       FOR AUTOMATIC SCALING OF PLOTTING AREAS
C
C       THE ROUTINE WAS ADAPTED FROM THE ROUTINE CALLED
C       DRAMOL WHICH IS USED IN THE HIDDEN LINE PART OF
C       THE PROGRAM
C
      CM = -100.0E+0
      DO 20 I = 1, 3
         CMI = 100.0E+0
         CMA = -100.0E+0
         DO 10 J = 1, NAT
            P = C(I,J)
            CMI = MIN(CMI,P)
            CMA = MAX(CMA,P)
   10    CONTINUE
         CO(I) = (CMA+CMI)*0.50E+0
         CMIN(I) = CMI
         CMAX(I) = CMA
         P = CMA-CMI
         IF (P.GT.CM) THEN
C            ICM = I
            CM = P
         ENDIF
   20 CONTINUE
      RETURN
      END
C
C**********************************************************************
C
C   RUTINA MOSEMI TOMADA DE PSI1 DE  DANIEL L. SEVERANCE Y
C      WILLIAM L. JORGENSEN
C	RECIBE COMO ENTRADA 
C	C(I,J) SON LAS COORDENADAS J (1-3=X-Z) DEL ATOMO I
C	NATB NUMERO DE ATOMOS
C	Y CALCULA EL VALOR DE 
C	CO(I) COMPOPNENTE I (1-3=X-Z) DEL VECTOR DEL CENTRO DE LA CAJA
C	CMIN(I) VALOR MIN EN AMSTRONG DE LA COMPONENTE I DE LA CAJA
C	CMAX(I) VALOR MAX EN AMSTRONG DE LA COMPONENTE I DE LA CAJA
C**********************************************************************
C
C
C
      SUBROUTINE MOSEMI
      IMPLICIT REAL (A-D,F-H,O-Z)
      IMPLICIT DOUBLE PRECISION (E)
      PARAMETER (MXPTS=51)
      PARAMETER (MAXATM=50)
      PARAMETER (MAXORB=200)
C
C       REEPLACES ORIGINAL ROUTINE TO EVALUATE RADIAL PARTS OF STO-3G
C       WAVEFUNCTIONS AS WELL AS THE MAINLINE CODE FOR THE REST.
C       REF FROM ORIGINAL CODE (FUNCTION AO):
C
C       ATOMS H TO AR ARE HANDLED ACCORDING TO J CHEM PHYS 51, 2657
C       (1969), 52, 2769 (1970).
C       W.L. JORGENSEN - MARCH,1976, JULY, 1977.
C
C       REWRITTEN INTO A STAND-ALONE SUBROUTINE FOR CALCULATING ORBITAL
C       VALUES. REWORKED TO REDUCE REDUNDANT COMPUTATION OF POWERS AND
C       SQUARE ROOTS, AS WELL AS PUTTING INTO AN EASILY VECTORIZABLE
C       FORM FOR VECTOR MACHINES ( WE HAVE A CYBER 205 AT PURDUE, IT
C       WILL ALSO WORK AS WELL ON OTHER MACHINES).
C
C       DAN SEVERANCE 12/10/87
C
C       AFTER DISCUSSION WITH JIM BRIGGS WHO HAS BEEN USING THIS PROGRAM
C       ON DR. JORGENSEN'S GOULD FOR THE LAST FEW WEEKS; THE AO
C       COMPUTATION AND WAVEFUNCTION READ WAS MOVED FROM THE MAIN LINE
C       TO THE RESPECTIVE SUBROUTINES.  WHEN A WAVEFUNCTION IS ADDED,
C       ONLY THE SUBROUTINE SHOULD NEED SIGNIFICANT MODIFICATION, THE
C       MAINLINE SHOULD ONLY NEED TO HAVE THE CALL ADDED.
C       DAN SEVERANCE 1/17/88
C
      COMMON /SPLIT/ XMI,YMI,ZMI,XINC,YINC,ZINC,MONE,MOLAST,NATB,
     *   IONEMO
C      REAL XMI,YMI,ZMI,XINC,YINC,ZINC
      COMMON /DENS/ DENSIT(MXPTS,MXPTS,MXPTS),V(MAXORB,MAXORB),C(3,
     *   MAXATM),IAN(MAXATM),F(40000),H(40000),Z1(MAXATM),
     *   Z2(MAXATM),Z3(MAXATM),U(40000)
C      REAL C(MAXATM,3)
C      COMMON /IO/ IRD,ILST
      DIMENSION XDEL(MXPTS),YDEL(MXPTS),ZDEL(MXPTS),AEXPP(MXPTS,9)
      DIMENSION XDELSQ(MXPTS),YDELSQ(MXPTS),ZDELSQ(MXPTS)
      DIMENSION XYZ(3,50),ZSQ(3),AEXPS(MXPTS,9),ANEG(6)
      DIMENSION X(MXPTS),Y(MXPTS),Z(MXPTS),CNSTX(MXPTS,3),CNSTY(MXPTS,3)
      DIMENSION A(3,3),D(3,3),D2P(3),D3P(3)
      DIMENSION CNSTNS(3,3),CNSTNP(3,3),VNORM(12),CNSTZ(MXPTS,3)
C
C       12/10/87 DAN SEVERANCE
C
      DATA A(1,1),A(1,2),A(1,3) / 1.098180E-1,4.057710E-1,2.227660E+0 /
      DATA A(2,1),A(2,2),A(2,3) / 7.513860E-2,2.310310E-1,9.942030E-1 /
      DATA A(3,1),A(3,2),A(3,3) / 5.272660E-2,1.347150E-1,4.828540E-1 /
      DATA D(1,1),D(1,2),D(1,3) / 4.446350E-1,5.353280E-1,1.543290E-1 /
      DATA D(2,1),D(2,2),D(2,3) / 7.001150E-1,3.995130E-1,-9.996720E-2 /
      DATA D(3,1),D(3,2),D(3,3) / 9.003980E-1,2.255950E-1,-2.196200E-1 /
      DATA D2P / 3.919570E-1,6.076840E-1,1.559160E-1 /
      DATA D3P / 4.620010E-1,5.951670E-1,1.058760E-2 /
C
C       NOW INITIALIZE ALL OF THE NON-"R" DEPENDANT VALUES RATHER THAN
C       RECOMPUTING THEM MXPTS**3 TIMES IN THE Z,Y,X LOOP OVER THE
C       ORBITAL VALUE MATRIX (DENSIT)
C
C       THESE VALUES ARE ALSO INDEPENDANT OF ATOM TYPE, ONLY DEPENDANT
C       ON THE ROW OF THE PERIODIC TABLE AND WHETHER IT IS "S" OR "P"
C       INITIALIZE THEM HERE AND ACCESS THEM WITHIN THE NAT LOOP, BEFORE
C       ENTERING THE LOOP OVER THE GRID (CUBE) POINTS.
C
      WRITE (6,*) ' EVALUATING THE SEMIEMPIRICAL WAVEFUNCTION'
      NAO = 0
      DO 10 I = 1, NATB
         NAO = NAO+1
         IF (IAN(I).GT.2) THEN
            NAO = NAO+3
            IF (IAN(I).GT.18) THEN
               WRITE (6,*) ' ATOMIC NUMBERS > 18 NOT YET IMPLEMENTED'
            ENDIF
         ENDIF
   10 CONTINUE
      WRITE (6,*) NAO,' WAVEFUNCTIONS TO BE PROCESSED '
C
C       READ IN EIGENVECTORS
C       IT IS ASSUMED THAT THE EIGENVECTORS HAVE BEEN NORMALIZED TO 1
C       ELECTRON WITH THE OVERLAP MATRIX INCLUDED. FOR SEMI-EMPIRICAL
C       WAVEFUNCTIONS, THIS REQUIRES THE LOWDIN TRANSFORMATION AS
C       IMPLEMENTED IN THE MOPAC ROUTINE MULT.
C
C       THE ZETA VALUES ARE ASSUMED TO BE AT THE END OF THE DATA, ONE
C       FOR EACH ATOM NUMBER. (8F10.6)
C
C      IF (IONEMO.NE.0) THEN
C         READ (IRD,40) (V(I,1),I=1,NAO)
C         DO 20 I = 1, NAT
C               WRITE (ILST,*) 'ESTOY EN IONEMO NO ES CEROOOO'
C            READ (IRD,40) Z1(I),Z2(I),Z3(I)
C   20    CONTINUE
C      ELSE
C         READ (IRD,40,END=50) ((V(I,J),I=1,NAO),J=1,NAO)
C               WRITE (6,*) 'HE LEIDO'
C               WRITE (6,*) ((I,J,V(I,J),I=1,NAO),J=1,NAO)
C               WRITE (6,*) 'ESTOY EN IONEMO ES CEROOOO y NAO es', NAO
C         DO 30 I = 1, NAT
C            READ (IRD,40) Z1(I),Z2(I),Z3(I)
C   30    CONTINUE
C   40    FORMAT (8F10.6)
C      ENDIF
C   50 CONTINUE
      MO = MONE
      DO 60 J = 1, NATB
         XYZ(1,J) = C(1,J)
         XYZ(2,J) = C(2,J)
         XYZ(3,J) = C(3,J)
   60 CONTINUE
C           XDEL
      WRITE (6,'(8F10.6)') 'XYZ',((XYZ(J,I),J=1,3),I=1,NATB)
C        FINALIZO LA ESCRITURA DE DENSIDAD

      X(1) = XMI
      Y(1) = YMI
      Z(1) = ZMI
      DO 70 I = 2, MXPTS
         X(I) = XINC+X(I-1)
         Y(I) = YINC+Y(I-1)
         Z(I) = ZINC+Z(I-1)
   70 CONTINUE
C
C       THESE ARE THE FIRST PART OF THE EQUATIONS FOR 1S->3P, CALCULATE
C       THEM ONCE AND ONCE ONLY, REAL POWERS (**X.XX) ARE VERY SLOW
C       COMPUTATIONS.  THESE "CONTANTS" NS AND NP WILL BE MULTIPLIED
C       BY THE ATOM DEPENDANT - R INDEPENDANT VALUES TO FORM ONE SINGLE
C       CONSTANT FOR MULTIPLICATION WITHIN THE CUBE LOOP.  THIS WILL
C       SPEED COMPUTATION CONSIDERABLY RATHER THAN DOING ALL OF THIS IN
C       THE LOOP.
C
C       FIRST THE "NS" ORBITAL "CONSTANTS"
C
      CNSTNS(1,1) = (A(1,1)**0.750E+0)*D(1,1)
      CNSTNS(2,1) = (A(1,2)**0.750E+0)*D(1,2)
      CNSTNS(3,1) = (A(1,3)**0.750E+0)*D(1,3)
      CNSTNS(1,2) = (A(2,1)**0.750E+0)*D(2,1)
      CNSTNS(2,2) = (A(2,2)**0.750E+0)*D(2,2)
      CNSTNS(3,2) = (A(2,3)**0.750E+0)*D(2,3)
      CNSTNS(1,3) = (A(3,1)**0.750E+0)*D(3,1)
      CNSTNS(2,3) = (A(3,2)**0.750E+0)*D(3,2)
      CNSTNS(3,3) = (A(3,3)**0.750E+0)*D(3,3)
C
C       NOW FOR THE "NP" ORBITALS (THE SECOND ARG IS THE QUANTUM NUMBER)
C       THE QUANTUM NUMBER RANGES FROM 2,3 SINCE THERE IS NO 1P ORBITAL
C
      CNSTNP(1,2) = (A(2,1)**1.250E+0)*D2P(1)
      CNSTNP(2,2) = (A(2,2)**1.250E+0)*D2P(2)
      CNSTNP(3,2) = (A(2,3)**1.250E+0)*D2P(3)
      CNSTNP(1,3) = (A(3,1)**1.250E+0)*D3P(1)
      CNSTNP(2,3) = (A(3,2)**1.250E+0)*D3P(2)
      CNSTNP(3,3) = (A(3,3)**1.250E+0)*D3P(3)
C
C       ZERO THE ORBITAL VALUE ARRAY
C
      DO 100 IZ = 1, MXPTS
         DO 90 IY = 1, MXPTS
            DO 80 IX = 1, MXPTS
               DENSIT(IX,IY,IZ) = 0.0E+0
   80       CONTINUE
   90    CONTINUE
  100 CONTINUE
C
C       INITIALIZE THE AO COUNTER AND LOOP OVER ATOMS, IATB IS THE ATOMIC
C       NUMBER
C
      M = 1
      DO 330 I = 1, NATB
         IATB = IAN(I)
C
C       COMPUTE XDEL,YDEL,AND ZDEL (I.E. DELTA X,Y, AND Z FROM THE ATOM
C       TO EACH POINT ON THE GRID.  ONLY MXPTS VALUES FOR EACH SINCE,
C       FOR INSTANCE, EVERY POINT ON A PARTICULAR XY PLANE IS THE SAME
C       DELTA Z VALUE FROM THE POINT.  THEREFORE YOU HAVE ONLY ONE VALUE
C       FOR THE ENTIRE PLANE FOR DELTA Z, INSTEAD OF (FOR MXPTS=51)
C       2601.  AGAIN, BY COMPUTING THIS HERE, RATHER THAN INSIDE THE
C       LOOP WE CUT DOWN THESE SUBTRACTIONS AND MULTIPLICATIONS BY
C       A FACTOR OF 2601 TO 1. THIS HAS A SUBSTANTIAL EFFECT ON THE
C       SPEED OF THE COMPUTATIONS.
C
         DO 110 IXYZ = 1, MXPTS
            XDEL(IXYZ) = X(IXYZ)-XYZ(1,I)
            XDELSQ(IXYZ) = XDEL(IXYZ)*XDEL(IXYZ)
  110    CONTINUE
         DO 120 IXYZ = 1, MXPTS
            YDEL(IXYZ) = Y(IXYZ)-XYZ(2,I)
            YDELSQ(IXYZ) = YDEL(IXYZ)*YDEL(IXYZ)
  120    CONTINUE
         DO 130 IXYZ = 1, MXPTS
            ZDEL(IXYZ) = Z(IXYZ)-XYZ(3,I)
            ZDELSQ(IXYZ) = ZDEL(IXYZ)*ZDEL(IXYZ)
  130    CONTINUE
C           XDEL
C      WRITE (6,'(8F10.6)') 'XDEL ',(XDEL(IXYZ),IXYZ=1,MXPTS)
C        FINALIZO LA ESCRITURA DE DENSIDAD



C
C       FIRST THE H, HE ATOMS
C
         WRITE (6,'(2(A,I5))')
     *       'PROCESSING ATOM NUMBER ',I,' ATOMIC NUMBER ',IATB
         IF (IATB.LE.2) THEN
C
C       NOW CALCULATE THE NORMALIZATION FACTORS WHICH ARE ATOM TYPE AND
C       QUANTUM NUMBER DEPENDANT.  MULTIPLY BY THE "CONSTANTS" FOR THE
C       PARTICULAR A.O. AND THE EIGENVECTOR FOR THAT A.O. IN THE M.O.
C       SINCE IT IS ALSO POSITION INDEPENDANT.  THE R*COS(THETA) (XDEL,
C       YDEL,AND ZDEL) WILL HAVE TO BE DONE INSIDE THE X,Y,AND Z LOOPS
C       RESPECTIVELY FOR ATOMS WHICH HAVE "P" ORBITALS, HERE WE DON'T
C       NEED TO WORRY.
C
            ZN = Z1(I)
            ZSQRT = SQRT(ZN)
            ZSQ(1) = ZN*ZN
C
C       ZN * SQRT(ZN) * (2.0E+0/PI)**0.750E+0
C
            RNORM = ZN*ZSQRT*0.712705470E+0
            VNORM(1) = RNORM*V(M,MO)*CNSTNS(1,1)
            VNORM(2) = RNORM*V(M,MO)*CNSTNS(2,1)
            VNORM(3) = RNORM*V(M,MO)*CNSTNS(3,1)
C
C       THERE IS ONLY THE 1S TO EVALUATE
C
            ANEG(1) = -A(1,1)*ZSQ(1)
            ANEG(2) = -A(1,2)*ZSQ(1)
            ANEG(3) = -A(1,3)*ZSQ(1)
C
C       THE EXPONENTIATIONS RELATED TO XDEL,YDEL,AND ZDEL
C       THEY WILL BE MULTIPLIED IN THE LOOP, RATHER THAN
C       MAXPTS**3 SEPARATE EXPONENTIATIONS OVER R.  THESE
C       9*MXPTS MAKE THE UNIQUE ONES FOR 1S. (3 GAUSSIANS*
C       3 CARTESIAN COORDS * MXPTS PLANES )
C
            DO 140 IXYZ = 1, MXPTS
               AEXPS(IXYZ,1) = GEXP(XDELSQ(IXYZ)*ANEG(1))*VNORM(1)
               AEXPS(IXYZ,2) = GEXP(XDELSQ(IXYZ)*ANEG(2))*VNORM(2)
               AEXPS(IXYZ,3) = GEXP(XDELSQ(IXYZ)*ANEG(3))*VNORM(3)
               AEXPS(IXYZ,4) = GEXP(YDELSQ(IXYZ)*ANEG(1))
               AEXPS(IXYZ,5) = GEXP(YDELSQ(IXYZ)*ANEG(2))
               AEXPS(IXYZ,6) = GEXP(YDELSQ(IXYZ)*ANEG(3))
               AEXPS(IXYZ,7) = GEXP(ZDELSQ(IXYZ)*ANEG(1))
               AEXPS(IXYZ,8) = GEXP(ZDELSQ(IXYZ)*ANEG(2))
               AEXPS(IXYZ,9) = GEXP(ZDELSQ(IXYZ)*ANEG(3))
  140       CONTINUE
            DO 180 IZ = 1, MXPTS
               DO 170 IY = 1, MXPTS
                  DO 160 IG = 1, 3
                     DO 150 IX = 1, MXPTS
C
C       CONTR IS THE SUM OF CONTRIBUTIONS OVER THIS YZ PLANE FOR THIS
C       ATOM.   WHEN FINISHED, SUM INTO THE ORBITAL VALUE ARRAY.
C
                        DENSIT(IX,IY,IZ) = DENSIT(IX,IY,IZ)+
     *                     AEXPS(IY,IG+3)*AEXPS(IZ,IG+6)*AEXPS(IX,IG)
  150                CONTINUE
  160             CONTINUE
  170          CONTINUE
  180       CONTINUE
            M = M+1
C           ESCRIBO LA DENSIDAD DE S
C      WRITE (6,'(8F10.6)') (((DENSIT(NX,NY,NZ),
C     *   NX=1,MXPTS),NY=1,MXPTS),NZ=1,MXPTS)
C        FINALIZO LA ESCRITURA DE DENSIDAD
         ELSEIF (IATB.LE.10) THEN
C
C       CALC ZETA(2S) SQUARED AND SQRT FOR CONSTANTS.
C
            ZN = Z1(I)
            ZSQRT = SQRT(ZN)
            ZSQ(1) = ZN*ZN
C
C       ZN * SQRT(ZN) * (2.0E+0/PI)**0.750E+0
C
C       VNORM(1-3) THE THE THREE GAUSSION "CONSTANTS" FOR THE 2S
C       ORBITAL, EVERYTHING THAT IS INDEPENDANT OF R IS IN THERE.
C
            RNORM = ZN*ZSQRT*0.712705470E+0
            VNORM(1) = RNORM*V(M,MO)*CNSTNS(1,2)
            VNORM(2) = RNORM*V(M,MO)*CNSTNS(2,2)
            VNORM(3) = RNORM*V(M,MO)*CNSTNS(3,2)
C
C       CALC ZETA(2P) SQUARED AND SQRT FOR CONSTANTS.
C
            ZN = Z2(I)
            ZSQRT = SQRT(ZN)
            ZSQ(2) = ZN*ZN
C
C       ZN*ZN * SQRT(ZN) * ((128.0E+0/PI**3)**0.250E+0)
C
C       VNORM(1-3) CORRESPONDS TO THE 3 GAUSSIANS FOR THE 2S ORBITAL
C       VNORM(4-6) "                            " FOR THE 2PX ""
C       VNORM(7-9) "" FOR THE 2PY ""
C       VNORM(10-12) "" FOR THE 2PZ ""
C       YOU NEED DIFFERENT "CONSTANTS" FOR EACH DUE TO THE DIFFERENT
C       VALUE OF THE WAVEFUNCTION FOR EACH ORBITAL. AT THE END WE WILL
C       HAVE A 3 SETS OF NUMBERS ALL MULTIPLIED BY THE EXPONENTIAL,
C       WE CAN ADD THEM FIRST, THEN CALC. AND MULT. BY THE EXP.
C
            RNORM = ZSQ(2)*ZSQRT*1.425410940E+0
            AOP1 = RNORM*CNSTNP(1,2)
            AOP2 = RNORM*CNSTNP(2,2)
            AOP3 = RNORM*CNSTNP(3,2)
            VNORM(4) = AOP1*V(M+1,MO)
            VNORM(5) = AOP2*V(M+1,MO)
            VNORM(6) = AOP3*V(M+1,MO)
            VNORM(7) = AOP1*V(M+2,MO)
            VNORM(8) = AOP2*V(M+2,MO)
            VNORM(9) = AOP3*V(M+2,MO)
            VNORM(10) = AOP1*V(M+3,MO)
            VNORM(11) = AOP2*V(M+3,MO)
            VNORM(12) = AOP3*V(M+3,MO)
            DO 190 IXYZ = 1, MXPTS
               CNSTX(IXYZ,1) = VNORM(4)*XDEL(IXYZ)
               CNSTX(IXYZ,2) = VNORM(5)*XDEL(IXYZ)
               CNSTX(IXYZ,3) = VNORM(6)*XDEL(IXYZ)
               CNSTY(IXYZ,1) = VNORM(7)*YDEL(IXYZ)
               CNSTY(IXYZ,2) = VNORM(8)*YDEL(IXYZ)
               CNSTY(IXYZ,3) = VNORM(9)*YDEL(IXYZ)
               CNSTZ(IXYZ,1) = VNORM(10)*ZDEL(IXYZ)
               CNSTZ(IXYZ,2) = VNORM(11)*ZDEL(IXYZ)
               CNSTZ(IXYZ,3) = VNORM(12)*ZDEL(IXYZ)
  190       CONTINUE
C
C       EVALUATE 2S AND 2P
C
C       MINUS ALPHA FOR 2S:
C
            ANEG(1) = -A(2,1)*ZSQ(1)
            ANEG(2) = -A(2,2)*ZSQ(1)
            ANEG(3) = -A(2,3)*ZSQ(1)
C
C       MINUS ALPHA FOR 2P:
C
            ANEG(4) = -A(2,1)*ZSQ(2)
            ANEG(5) = -A(2,2)*ZSQ(2)
            ANEG(6) = -A(2,3)*ZSQ(2)
C
C       PRECOMPUTE EXP(-A*Z**2*DELO**2) WHERE DELO**2 IS
C       DELTA-X**2, DELTA-Y**2, AND DELTA-Z**2
C
            DO 200 IXYZ = 1, MXPTS
               AEXPS(IXYZ,1) = GEXP(XDELSQ(IXYZ)*ANEG(1))*VNORM(1)
               AEXPS(IXYZ,2) = GEXP(XDELSQ(IXYZ)*ANEG(2))*VNORM(2)
               AEXPS(IXYZ,3) = GEXP(XDELSQ(IXYZ)*ANEG(3))*VNORM(3)
               AEXPS(IXYZ,4) = GEXP(YDELSQ(IXYZ)*ANEG(1))
               AEXPS(IXYZ,5) = GEXP(YDELSQ(IXYZ)*ANEG(2))
               AEXPS(IXYZ,6) = GEXP(YDELSQ(IXYZ)*ANEG(3))
               AEXPS(IXYZ,7) = GEXP(ZDELSQ(IXYZ)*ANEG(1))
               AEXPS(IXYZ,8) = GEXP(ZDELSQ(IXYZ)*ANEG(2))
               AEXPS(IXYZ,9) = GEXP(ZDELSQ(IXYZ)*ANEG(3))
  200       CONTINUE
            DO 210 IXYZ = 1, MXPTS
               AEXPP(IXYZ,1) = GEXP(XDELSQ(IXYZ)*ANEG(4))
               AEXPP(IXYZ,2) = GEXP(XDELSQ(IXYZ)*ANEG(5))
               AEXPP(IXYZ,3) = GEXP(XDELSQ(IXYZ)*ANEG(6))
               AEXPP(IXYZ,4) = GEXP(YDELSQ(IXYZ)*ANEG(4))
               AEXPP(IXYZ,5) = GEXP(YDELSQ(IXYZ)*ANEG(5))
               AEXPP(IXYZ,6) = GEXP(YDELSQ(IXYZ)*ANEG(6))
               AEXPP(IXYZ,7) = GEXP(ZDELSQ(IXYZ)*ANEG(4))
               AEXPP(IXYZ,8) = GEXP(ZDELSQ(IXYZ)*ANEG(5))
               AEXPP(IXYZ,9) = GEXP(ZDELSQ(IXYZ)*ANEG(6))
  210       CONTINUE
C
C       LOOP OVER THE "CUBE" Z,Y, AND X
C
            DO 250 IZ = 1, MXPTS
               DO 240 IY = 1, MXPTS
                  DO 230 IG = 1, 3
                     DO 220 IX = 1, MXPTS
C
C       SUM THE ORBITAL CONTRIBUTIONS INTO THE ORBITAL VALUE ARRAY
C
C       FIRST THE 3 GAUSSIANS FOR THE 2S:
C
                        DENSIT(IX,IY,IZ) = DENSIT(IX,IY,IZ)+AEXPS(
     *                     IY,IG+3)*AEXPS(IZ,IG+6)*AEXPS(IX,IG)
C
C       NEXT, THE 3 FOR THE 2P:
C
                        DENSIT(IX,IY,IZ) = DENSIT(IX,IY,IZ)+(CNSTY(IY,IG
     *                     )+CNSTZ(IZ,IG)+CNSTX(IX,IG))*AEXPP(IX,IG)*
     *                     AEXPP(IY,IG+3)*AEXPP(IZ,IG+6)
  220                CONTINUE
  230             CONTINUE
  240          CONTINUE
  250       CONTINUE
            M = M+4
         ELSEIF (IATB.LE.18) THEN
C
C       CALC ZETA(3S) SQUARED AND SQRT FOR CONSTANTS.
C
            ZN = Z1(I)
            ZSQRT = SQRT(ZN)
            ZSQ(1) = ZN*ZN
C
C       ZN * SQRT(ZN) * (2.0E+0/PI)**0.750E+0
C
C       VNORM(1-3) THE THE THREE GAUSSION "CONSTANTS" FOR THE 3S
C       ORBITAL, EVERYTHING THAT IS INDEPENDANT OF R IS IN THERE.
C
            RNORM = ZN*ZSQRT*0.712705470E+0
            VNORM(1) = RNORM*V(M,MO)*CNSTNS(1,3)
            VNORM(2) = RNORM*V(M,MO)*CNSTNS(2,3)
            VNORM(3) = RNORM*V(M,MO)*CNSTNS(3,3)
C
C       CALC ZETA(2P) SQUARED AND SQRT FOR CONSTANTS.
C
            ZN = Z2(I)
            ZSQRT = SQRT(ZN)
            ZSQ(2) = ZN*ZN
C
C       ZN*ZN * SQRT(ZN) * ((128.0E+0/PI**3)**0.250E+0)
C
C       VNORM(1-3) CORRESPONDS TO THE 3 GAUSSIANS FOR THE 3S ORBITAL
C       VNORM(4-6) "                            " FOR THE 3PX ""
C       VNORM(7-9) "" FOR THE 3PY ""
C       VNORM(10-12) "" FOR THE 3PZ ""
C       YOU NEED DIFFERENT "CONSTANTS" FOR EACH DUE TO THE DIFFERENT
C       VALUE OF THE WAVEFUNCTION FOR EACH ORBITAL. AT THE END WE WILL
C       HAVE A 3 SETS OF NUMBERS ALL MULTIPLIED BY THE EXPONENTIAL,
C       WE CAN ADD THEM FIRST, THEN CALC. AND MULT. BY THE EXP.
C
            RNORM = ZSQ(2)*ZSQRT*1.425410940E+0
            AOP1 = RNORM*CNSTNP(1,3)
            AOP2 = RNORM*CNSTNP(2,3)
            AOP3 = RNORM*CNSTNP(3,3)
            VNORM(4) = AOP1*V(M+1,MO)
            VNORM(5) = AOP2*V(M+1,MO)
            VNORM(6) = AOP3*V(M+1,MO)
            VNORM(7) = AOP1*V(M+2,MO)
            VNORM(8) = AOP2*V(M+2,MO)
            VNORM(9) = AOP3*V(M+2,MO)
            VNORM(10) = AOP1*V(M+3,MO)
            VNORM(11) = AOP2*V(M+3,MO)
            VNORM(12) = AOP3*V(M+3,MO)
            DO 260 IXYZ = 1, MXPTS
               CNSTX(IXYZ,1) = VNORM(4)*XDEL(IXYZ)
               CNSTX(IXYZ,2) = VNORM(5)*XDEL(IXYZ)
               CNSTX(IXYZ,3) = VNORM(6)*XDEL(IXYZ)
               CNSTY(IXYZ,1) = VNORM(7)*YDEL(IXYZ)
               CNSTY(IXYZ,2) = VNORM(8)*YDEL(IXYZ)
               CNSTY(IXYZ,3) = VNORM(9)*YDEL(IXYZ)
               CNSTZ(IXYZ,1) = VNORM(10)*ZDEL(IXYZ)
               CNSTZ(IXYZ,2) = VNORM(11)*ZDEL(IXYZ)
               CNSTZ(IXYZ,3) = VNORM(12)*ZDEL(IXYZ)
  260       CONTINUE
C
C       EVALUATE 3S AND 3P
C
C       MINUS ALPHA FOR 3S:
C
            ANEG(1) = -A(3,1)*ZSQ(1)
            ANEG(2) = -A(3,2)*ZSQ(1)
            ANEG(3) = -A(3,3)*ZSQ(1)
C
C       MINUS ALPHA FOR 3P:
C
            ANEG(4) = -A(3,1)*ZSQ(2)
            ANEG(5) = -A(3,2)*ZSQ(2)
            ANEG(6) = -A(3,3)*ZSQ(2)
C
C       PRECOMPUTE EXP(-A*Z**2*DELO**2) WHERE DELO**2 IS
C       DELTA-X**2, DELTA-Y**2, AND DELTA-Z**2
C
            DO 270 IXYZ = 1, MXPTS
               AEXPS(IXYZ,1) = GEXP(XDELSQ(IXYZ)*ANEG(1))*VNORM(1)
               AEXPS(IXYZ,2) = GEXP(XDELSQ(IXYZ)*ANEG(2))*VNORM(2)
               AEXPS(IXYZ,3) = GEXP(XDELSQ(IXYZ)*ANEG(3))*VNORM(3)
               AEXPS(IXYZ,4) = GEXP(YDELSQ(IXYZ)*ANEG(1))
               AEXPS(IXYZ,5) = GEXP(YDELSQ(IXYZ)*ANEG(2))
               AEXPS(IXYZ,6) = GEXP(YDELSQ(IXYZ)*ANEG(3))
               AEXPS(IXYZ,7) = GEXP(ZDELSQ(IXYZ)*ANEG(1))
               AEXPS(IXYZ,8) = GEXP(ZDELSQ(IXYZ)*ANEG(2))
               AEXPS(IXYZ,9) = GEXP(ZDELSQ(IXYZ)*ANEG(3))
  270       CONTINUE
            DO 280 IXYZ = 1, MXPTS
               AEXPP(IXYZ,1) = GEXP(XDELSQ(IXYZ)*ANEG(4))
               AEXPP(IXYZ,2) = GEXP(XDELSQ(IXYZ)*ANEG(5))
               AEXPP(IXYZ,3) = GEXP(XDELSQ(IXYZ)*ANEG(6))
               AEXPP(IXYZ,4) = GEXP(YDELSQ(IXYZ)*ANEG(4))
               AEXPP(IXYZ,5) = GEXP(YDELSQ(IXYZ)*ANEG(5))
               AEXPP(IXYZ,6) = GEXP(YDELSQ(IXYZ)*ANEG(6))
               AEXPP(IXYZ,7) = GEXP(ZDELSQ(IXYZ)*ANEG(4))
               AEXPP(IXYZ,8) = GEXP(ZDELSQ(IXYZ)*ANEG(5))
               AEXPP(IXYZ,9) = GEXP(ZDELSQ(IXYZ)*ANEG(6))
  280       CONTINUE
C
C       LOOP OVER THE "CUBE" Z,Y, AND X
C
            DO 320 IZ = 1, MXPTS
               DO 310 IY = 1, MXPTS
                  DO 300 IG = 1, 3
                     DO 290 IX = 1, MXPTS
C
C       SUM THE ORBITAL CONTRIBUTIONS INTO THE ORBITAL VALUE ARRAY
C
C       FIRST THE 3 GAUSSIANS FOR THE 3S:
C
                        DENSIT(IX,IY,IZ) = DENSIT(IX,IY,IZ)+AEXPS(IY,
     *                     IG+3)*AEXPS(IZ,IG+6)*AEXPS(IX,IG)
C
C       NEXT, THE 3 FOR THE 3P:
C
                        DENSIT(IX,IY,IZ) = DENSIT(IX,IY,IZ)+(CNSTY(IY,IG
     *                     )+CNSTZ(IZ,IG)+CNSTX(IX,IG))*AEXPP(IX,IG)*
     *                     AEXPP(IY,IG+3)*AEXPP(IZ,IG+6)
  290                CONTINUE
  300             CONTINUE
  310          CONTINUE
  320       CONTINUE
            M = M+4
         ENDIF
  330 CONTINUE
      RETURN
      END
      FUNCTION GEXP(X)
C      DOUBLE PRECISION X
      IF(X.GE.-19.0) THEN
         GEXP = EXP(X)
      ELSE
      GEXP = 0.0E+0
      ENDIF
      RETURN
      END



CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C DE ANTES 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C	
C      WRITE (8,'(A)') 'SEMI'
C      WRITE (8,'(A5)') 'AUTO0'
C      WRITE (8,'(I2,I2,I5,1X,F4.2)') IMO,IMO,NORBS,SCALE
C      WRITE (8,50) ICHRG
C      WRITE (8,60) (NAT(I),(C(J,I),J=1,3),I=1,NUMAT)
C      WRITE (8,'(A)') '99'
C      WRITE (8,30) ((V(J,I),J=1,NORBS),I=1,NORBS)
C      WRITE (8,30) (U(J),J=1,LINEAR)
C
C WRITE OUT ZETA VALUES FOR EACH ATOM
C
C   30 FORMAT (8F10.6)
C      DO 40 I = 1, NUMAT
C         WRITE (8,30) ZS(I),ZP(I),ZD(I)
C   40 CONTINUE
C
C WRITE PSICON/88 INPUT FILE
C
C      WRITE (9,'(A)') 'SEMI'
C      WRITE (9,'(A)') '01010001'
C      WRITE (9,'(A)') '0.075'
C
C DETERMINE LABEL TO USE FOR PLOT
C
C      WRITE (SUBTIT,'(A,I4)') 'MO #',IMO
C      IF ((IHOMO-2).EQ.IMO) SUBTIT = 'HOMO-2'
C      IF ((IHOMO-1).EQ.IMO) SUBTIT = 'HOMO-1'
C      IF (IHOMO.EQ.IMO) SUBTIT = 'HOMO'
C      IF (ILUMO.EQ.IMO) SUBTIT = 'LUMO'
C      IF ((ILUMO+1).EQ.IMO) SUBTIT = 'LUMO+1'
C      IF ((ILUMO+2).EQ.IMO) SUBTIT = 'LUMO+2'
C
C WRITE PSI2/88 INPUT FILE
C
C      WRITE (10,'(A)') ' '
C      WRITE (10,'(A)') SUBTIT
C      WRITE (10,'(A/A)') '01','00'
C      WRITE (10,50) ICHRG
C      WRITE (10,60) (NAT(I),(C(J,I),J=1,3),I=1,NUMAT)
C      WRITE (10,'(A)') '99'
C      X = 10.0
C      SCALE = 0.7
C      WRITE (10,'(4F10.6)') X,X,X,SCALE
C      WRITE (10,'(A)') '02'
C   50 FORMAT (I2)
C   60 FORMAT (I2,8X,3F10.6)
C
