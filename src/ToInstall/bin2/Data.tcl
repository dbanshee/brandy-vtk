#######################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#						- MODULO PARA EL MANEJO DE LOS DATOS MOLECULARES -
#										--------------------
#
# Los datos seran manejados por una estructura, que tomara 
# un nombre base unico proporcionado por el usuario.
#
#	Definido dentro del
#			namespace eval Data
#
#	base() : array que representara la instancia de datos
#		
#		base(nombreFich)	--> nombre del fichero al que corresponde el Data, puede ser ""
#
#		base(numAtomos)
#		base(numEnlaces)
#		base(coordX,i) 		--\  	cada uno de tamaño base(numatomos)
#		base(coordY,i) 		---> coordenada x, y o z del atomo i-esimo
#		base(coordZ,i) 		--/	
#		base(simbolo,i) 		--> simbolo del atomo i-esimo
#		base(colorAtom,i)		--> color del atomo i-esimo
#		base(numAtom,i) 		--> numero atomico del atomo i-esimo
#		base(radioVdW,i) 		--> radio VanderWalls del atomo i-esimo
#		base(valenciaReal,i)	--> valencia real del atomo i-esimo
#		base(carga,i)			--> carga del atomo i-esimo
#		base(cargasParcialesCalculadas) --> 1 si las cargas parciales han sido actualizadas, 0 en caso contrario
#		base(cargaParcial,i)	--> carga parcial del atomo i-esimo
#		base(conect,i)  		--> lista de atomos conectados con el atomo i
#		base(tipoConect,i,j)	--> tipo de la conexion entre i y j, 1: simple, 2: doble, 3:triple
#		base(valencia,i)		--> valencia actual del atomo i-esimo

#		base(inchi) 			--> informacion inchi 
#		base(quiralidad) 		--> lista de "id simbolo_quiralidad", puede ser vacia si no se ha podido calcular inchi
#									o la molecula no contiene atomos quirales

#		
#		base(anillo,j,i)		--> indica si el atomo i forma parte de una anillo de tipo j

#		base(conv,i) 			--> valor de conversion dekl atomo i, usado en la reenumeracion
		
#		base(modificada)		--> nos indica si ha sufrido modificaciones de adicion o eliminacion de atomos
#
#		Define :
#			proc newData { base } --> 0: variable creada, -1:la variable ya existe
#			proc delData { base }
#			proc obtenerNumAt { atomo } --> "numAtom radioVdW carga"
#			proc calculoProp { baseData id1 id2 } 
#						-->		 "$center $angCY $unitProdYC $long" : enlace simple
#						-->		 "$center1 $angCY $unitProdYC $long $center2" : enlace doble
#						-->		 "$center $angCY $unitProdYC $long $center1 $center2" :enlace triple

#				Privadas :
#					proc calculoVectorPerp { vector }
#
#
#########################################################################################################

package require math::linearalgebra
package require math::constants

namespace eval Data {

	#crea una instancia, definiendo un array Data::$base
	proc newData { base } {
		if {[info exists Data::$base]==0} {
			variable $base
			set ${base}(numAtomos) 0
			set ${base}(numEnlaces) 0
			set ${base}(nombreFich) ""
			return 0
		} else {
			#puts "La variable ya existe"
			return -1
		}
	}; #finpoc
	
	#elimina los datos de la instancia $base
	proc delData { base } {
		upvar #0 Data::$base dat
		if {[array exists dat]} { unset dat }
	}; #finproc
	
	#obtiene el numero atomico, el radio de VdW, carga del elemento de simbolo 'atomo'
        #y peso atomico del mismo
	proc obtenerNumAt { atomo } {
		switch $atomo {
			Al	{ set codigo "13 2.10 3 26.981538"}
			Ag	{ set codigo "47 1.72 0 107.8682"} 
			Ar	{ set codigo "18 1.88 0 39.948"}
			As	{ set codigo "33 1.85 3 74.9216"}
			Au	{ set codigo "79 1.66 0 196.96655"}
			Br	{ set codigo "35 1.85 1 79.904"}
			B	{ set codigo "5 1.60 3 10.811"}
			C	{ set codigo "6 1.70 4 12.0107"}
			Cd	{ set codigo "48 1.58 0 112.411"}
			Cl	{ set codigo "17 1.75 1 35.4527"}
			Cu	{ set codigo "29 1.40 0 63.546"}
			F	{ set codigo "9 1.47 1 18.9984032"}
			Ga	{ set codigo "31 1.87 0 69.723"}
			H	{ set codigo "1 1.20 1 1.00794"}
			He	{ set codigo "2 1.40 0 4.002602"}
			Hg	{ set codigo "80 1.55 0 200.59"}
			I	{ set codigo "53 1.98 1 126.90447"}
			In	{ set codigo "49 1,93 0 114.818"}
			K	{ set codigo "19 2.75 0 39.0983"}
			Kr	{ set codigo "36 2.02 0 83.80"}
			Li	{ set codigo "3 1.82 0 6.941"}
			Mg	{ set codigo "12 1.73 0 24.3050"}
			N	{ set codigo "7 1.55 3 14.00674"}
			Na	{ set codigo "11 2.27 0 22.98977"}
			Ne	{ set codigo "10 1.54 0 20.1797"}
			Ni	{ set codigo "28 1.63 0 58.6934"}
			O	{ set codigo "8 1.52 2 15.9994"}
			P	{ set codigo "15 1.80 3 30.973761"}
			Pb	{ set codigo "82 2.02 0 207.2"}
			Pd	{ set codigo "46 1.63 0 106.42"}
			Pt	{ set codigo "78 1.72 0 195.078"}
			S	{ set codigo "16 1.80 2 32.066"}
			Se	{ set codigo "34 1.90 2 78.96"}
			Si	{ set codigo "14 2.10 4 28.0855"}
			Sn	{ set codigo "50 2.17 0 118.71"}
			Te	{ set codigo "52 2.06 0 127.60"}
			Tl	{ set codigo "81 1.96 0 204.3833"}
			U	{ set codigo "92 1.86 0 238.0289"}
			Xe	{ set codigo "54 2.16 0 131.29"}
			Zn	{ set codigo "30 1.39 0 65.39"}
			default     {set codigo "999 1.00 0 0.0"}
		}
		return $codigo
	} ; #finproc
	
	#devuelve la carga de un atomo, a partir del codigo que le asignan los ficheros mol
	proc cargaReal { num } { 
		switch $num {
			1	{set codigo 3 }
			2	{set codigo 2 }
			3	{set codigo 1 }
			4	{set codigo 1 }
			5	{set codigo -1 }
			6	{set codigo -2 }
			7	{set codigo -3 }
			0	{set codigo 0}	
			default {set codigo 0}
		}
		return $codigo
	}; #finproc
	
	#calcula en centro de los dos atomos, las rotaciones que debe sufrir para alinearse, y la longitud
	proc calculoProp { baseData id1 id2 } {
		
		upvar #0 Data::$baseData datos
		#math::constants::constants pi radtodeg degtorad
		set a [list $datos(coordX,$id1) $datos(coordY,$id1) $datos(coordZ,$id1)]
		set b [list $datos(coordX,$id2) $datos(coordY,$id2) $datos(coordZ,$id2)]
		
		# C, el vector q una a y b. c = b - a
		set c [math::linearalgebra::sub $b $a]
		
		#el vector c deberia ser distinto del {0 0 0},  puesto q q es fisicamente imposible q dos atomos
		#esten en el mismo lugar geometrico, no bostante consideraremos dicha anomalia, y le asignaremos
		#el {1 0 0}, para evitar errores.
		if {[lindex $c 0] == 0 && [lindex $c 1] == 0 && [lindex $c 2] == 0} { set c "0.01 0.0 0.0"}
		
		#determino el centro del vector. Esta sera la posicion de nuestro actor cilindro
		set center [math::linearalgebra::scale 0.5 $c]
		set center [math::linearalgebra::add $center $a]		
		#determino su longitud
		set long [math::linearalgebra::norm $c]
		
		#calculo el producto vectorial del ejeY con el vector c
		#set cxy [math::linearalgebra::crossproduct { 0 1 0 } $c ]
		if {[lindex $c 0]==0 && [lindex $c 2]==0} {
			#si el vector c es paralelo al y, el producto vectorial seria 0 0 0 
			#y la funcion unitLengthVector fallaria al encontrarse el vector nulo
			set unitProdYC $c
			#set unitProdYC [math::linearalgebra::unitLengthVector $c]
			set unitProdYC "1.0 0.0 0.0"
			set angCY 0
			if {[lindex $c 1] < 0.0} {
				set angCY 180
			}
		} else {
			set prodYC [math::linearalgebra::crossproduct { 0.0 1.0 0.0 } $c]
			#calculo el vector unitario
			if {$prodYC == "0 0 0"} {set prodYC "1 0 0"}
			set unitProdYC [math::linearalgebra::unitLengthVector $prodYC]
			
			#calculo el angulo que forman C e Y
			set angCY [math::linearalgebra::angle $c {0.0 1.0 0.0}]
			set angCY [expr $angCY*$math::constants::radtodeg]
		}
		#puts "id1 : $id1, id2 : $id2, angcy : $angCY"
		
		# ya tengo los datos para el cilindro q une los 2 atomos, ahora segun sea el tipo de enlace
		# le dare los datos como estan, o le proporcionare informacion adicional.
		
		switch $datos(tipoConect,$id1,$id2) {
			
			2 {
				#enlace doble
				
				set perp [calculoVectorPerp $c]
				if {[lindex $perp 0] == 0 && [lindex $perp 1] == 0 && [lindex $perp 2] == 0} {set perp "0.01 0.0 0.0"}
				set perp [math::linearalgebra::unitLengthVector $perp]
				set perp [math::linearalgebra::scale 0.05 $perp]
				  
				#creo dos centros paralelos a c
				set center1 [math::linearalgebra::add $center $perp]
				set center2 [math::linearalgebra::sub $center $perp]
				  
				return "$center1 $angCY $unitProdYC $long $center2"
			}
			
			3 {
				#enlace triple
				set perp [calculoVectorPerp $c]
				if {[lindex $perp 0] == 0 && [lindex $perp 1] == 0 && [lindex $perp 2] == 0} {set perp "0.01 0.0 0.0"}
				set perp [math::linearalgebra::unitLengthVector $perp]
				set perp [math::linearalgebra::scale 0.07 $perp]
				
				#creo dos centros paralelos a c
				set center1 [math::linearalgebra::add $center $perp]
				set center2 [math::linearalgebra::sub $center $perp]
				
				return "$center $angCY $unitProdYC $long $center1 $center2"
			}
			
			default {
				#determino el centro del vector. Esta sera la posicion de nuestro actor cilindro
				set center [math::linearalgebra::scale 0.5 $c]
				set center [math::linearalgebra::add $center $a]
				return "$center $angCY $unitProdYC $long"
			}
		}
	}; #finproc
	
	proc calculoVectorPerp { vector } {
		
		#para calcular un vector perpendicular al dado, realizare un producto vectorial entre el y otro vector
		#libre, como el {1 1 1}. En el pero caso {1 1 1} podria ser paralelo a vector, por lo que su producto
		#vectorial seria {0 0 0}, y la funcion unitLengthVector fallaria.
		#
		#La solucion consistira en intentarlo con {1 1 1}, si su prod vect es el vector nulo, lo intentaremos con
		#{1 0 0}, que no es paralelo a {1 1 1}, por lo tanto no puede serlo tambien de nuestro vector.
		
		set p [math::linearalgebra::crossproduct {1.0 1.0 1.0} $vector]
		if {[string compare {0 0 0} $p] == 0} {
			set p [math::linearalgebra::crossproduct {1.0 0.0 0.0} $vector]
		}
		
		return $p
	}; #finproc

	#calcula la proyeccion del vector v sobre el w
	proc calculoProyecc { v w } {
		set x1 [math::linearalgebra::dotproduct $w $v]
		set x2 [math::linearalgebra::dotproduct $w $w]
		set s [expr $x1 / $x2]
		return [math::linearalgebra::scale $s $w]
	}; #finproc
	
	#proc calcula el punto simetrico a p respecto del plano formado por p1, p2 y p3
	proc calculoPuntoSimetricoPlano { x1 x2 x3 p } {

		set v1 [math::linearalgebra::sub $x2 $x1]
		set v2 [math::linearalgebra::sub $x3 $x1]
		#defino la normal al plano
		set n [math::linearalgebra::crossproduct $v1 $v2]
		#puts "Normal : $n"
		#la ecuacion de un plano es ax+by+cz+d=0
		#donde (a,b,c) es la normal al plano
		# luego d = -(ax+by+cz)
		set a [lindex $n 0]
		set b [lindex $n 1]
		set c [lindex $n 2]
		set d [expr - ($a * [lindex $x1 0] + $b * [lindex $x1 1] + $c * [lindex $x1 2])]
		
		#calculo la proyeccion del punto p sobre el plano ax+by+cz+d=0
		#	sea n=(a,b,c) la normal al plano, y p=(p1,p2,p3) el punto del que queremos el simetrico
		# 	se define la proyeccion como
		#	x = p1 + a?
		#	y = p2 + b?
		#	z = p3 + c?
		#	ax + by + cz + d = 0
		# donde ? = (-a*p1 -b*p2 -c*p3 - d ) / (a*a + b*b + c*c)
		# sustituyendo, tenemos M(p1+a?,p2+b?,p3+c?)
		
		set p1 [lindex $p 0]
		set p2 [lindex $p 1]
		set p3 [lindex $p 2]
		
		set lambda [expr (-$a*$p1 -$b*$p2 -$c*$p3 - $d ) / ($a*$a + $b*$b + $c*$c)]
		
		set M "[expr $p1 + $a*$lambda] [expr $p2 + $b*$lambda] [expr $p3 + $c*$lambda]"
		#puts "Punto Medio : $M"
		
		#sea pprima el punto simetrico a p, y siendo M la proyeccion de p al plano x1,x2,x3, 
		#entonces M es el punto medio de la recta que une p con pprima
		# Por lo tanto siendo M=(m1,m2,m3) podemos definir pprima(pp1,pp2,pp3) como :
		#	(pp1+p1) / 2 = m1
		#	(pp2+p2) / 2 = m2
		#	(pp3+p3) / 2 = m3
		#
		#	pp1 = (m1*2) - p1
		#	pp2 = (m2*2) - p2
		#	pp3 = (m3*2) - p3
		set m1 [lindex $M 0]
		set m2 [lindex $M 1]
		set m3 [lindex $M 2]
		
		set pprima "[expr ($m1 * 2) - $p1] [expr ($m2 * 2) - $p2] [expr ($m3 * 2) - $p3]"
		#puts "simetrico $pprima"
		return $pprima

	}; #finproc
	
	
	proc modificada { base } {
		upvar #0 Data::$base datos
		return $datos(modificada)
	}; #finproc
	
	#crea un Data a partir de una lista de atomos de otro Data
	proc newSubData { base baseOriginal listaAtom } {
		upvar #0 Data::$baseOriginal orig
		newData $base
		upvar #0 Data::$base datos
		
		#copiamos los datos del subconjunto
		#pero debemos de reenumerar el contenido
		
		
		#copio los atomos, y creo una tabla de equivalencia
		for {set x 0} {$x < [llength $listaAtom]} {incr x} {
			set xOrig [lindex $listaAtom $x]
			set datos(coordX,$x) $orig(coordX,$xOrig)
			set datos(coordY,$x) $orig(coordY,$xOrig)
			set datos(coordZ,$x) $orig(coordZ,$xOrig)
			set datos(simbolo,$x) $orig(simbolo,$xOrig)
			set datos(numAtom,$x) $orig(numAtom,$xOrig)
			set datos(radioVdW,$x) $orig(radioVdW,$xOrig)
			set datos(carga,$x) $orig(carga,$xOrig)
			set datos(valenciaReal,$x) $orig(valenciaReal,$xOrig)
			set datos(valencia,$x) $orig(valencia,$xOrig)
			
			set equiv($xOrig) $x
			puts "$x --> $xOrig $equiv($xOrig)"
		}
		
		set datos(numEnlaces) 0
		#genero la info de los enlaces, relativa a los nuevos atomos
		for {set x 0} {$x < [llength $listaAtom]} {incr x} { 
			set xOrig [lindex $listaAtom $x]
			set enlOrig $orig(conect,$xOrig)
			
			set enl [list]
			foreach e $enlOrig {
				if {[lsearch $listaAtom $e] != -1} {
					lappend enl $equiv($e) 
					incr datos(numEnlaces)
					set datos(tipoConect,$x,$equiv($e)) $orig(tipoConect,$xOrig,$e)
				}
			}
			set datos(conect,$x) $enl
		}
		
		set datos(numAtomos) [llength $listaAtom]
		set datos(numEnlaces) [expr $datos(numEnlaces) / 2]
		
		puts "$datos(numAtomos) $datos(numEnlaces)"
		set datos(modificada) 1
		return $base
	}; #finproc
	
	proc asociaFichData { base file } {
		upvar #0 Data::$base datos
		set datos(nombreFich) $file
	}
	
	proc devuelveFichData { base } {
		upvar #0 Data::$base datos
		return $datos(nombreFich)
	}; #finproc
	
	#devuelve un string con la formula molecular, la formula molecular consiste en ordenar alfabeticamente
	#los SIMBOLO,NºELEMENTOS_DE_ESE_SIMBOLO, ej : C6 H12 para el ciclohexano
	proc formulaMolecular { base } { 
		upvar #0 Data::$base datos
		
		set lista [list]
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			lappend lista $datos(simbolo,$x)
		}
		
		set lista [lsort -ascii $lista]
		
		set formula [list]
		while {[llength $lista] > 0} {
			set elem [lindex $lista 0]
			set pos [lsearch -all $lista $elem]
			
			lappend formula "$elem [llength $pos]"
			
			#elimino de la lista el elemento ya considerado
			set x [lsearch $lista $elem]
			while { $x != -1} { 
				set lista [lreplace $lista $x $x]
				set x [lsearch $lista $elem]
			}
		}
		return $formula
	}; #finproc
	
	proc pesoMolecular { formulaMolecular } {
		set peso 0
		foreach e $formulaMolecular {
			if {[scan $e {%s%f} simb num] == 2} {
				set peso [expr $peso + ([lindex [obtenerNumAt $simb] 3] * $num)]
			}
		} 
		return $peso
	}; #finproc
	
	#para la reenumeracion necesito 2 datas un array de conversion, con una entrada para cada atomo, q contiene el atomo por q el convertirlo
	proc reenumerar { base base2 } {
		upvar #0 Data::$base datos
		upvar #0 Data::$base2 datos2
		
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			
			set datos(nombreFich) ""
			
			set datos2(numAtomos) $datos(numAtomos)
			set datos2(numEnlaces) $datos(numEnlaces)
			
			
			set datos2(coordX,$datos(conv,$x)) $datos(coordX,$x)
			set datos2(coordY,$datos(conv,$x)) $datos(coordY,$x)
			set datos2(coordZ,$datos(conv,$x)) $datos(coordZ,$x)
			
			set datos2(simbolo,$datos(conv,$x)) $datos(simbolo,$x)
			set datos2(colorAtom,$datos(conv,$x)) $datos(colorAtom,$x)
			set datos2(numAtom,$datos(conv,$x)) $datos(numAtom,$x))
			set datos2(radioVdW,$datos(conv,$x)) $datos(radioVdW,$x)
			set datos2(valenciaReal,$datos(conv,$x)) $datos(valenciaReal,$x)
			set datos2(carga,$datos(conv,$x)) $datos(carga,$x)
			set datos2(valencia,$datos(conv,$x)) $datos(carga,$x)
			
			
			#y para los enlaces
			set lista $datos(conect,$x)
			set listaF [list]
			foreach e $lista {
				lappend listaF $datos(conv,$e)
				set datos2(tipoConect,$datos(conv,$x),$datos(conv,$e)) $datos(tipoConect,$x,$e)
				puts "datos2(tipoConec,$datos(conv,$x),$datos(conv,$e)) $datos(tipoConect,$x,$e)"
			}
			set datos2(conect,$datos(conv,$x)) $listaF
			set datos2(modificada) $datos(modificada)
		}
	}; #finproc
	
	proc actualizaCargasParciales { base cargas } {
		upvar #0 Data::$base datos
		
		set datos(cargasParcialesCalculadas) 1
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			set datos(cargaParcial,$x) [lindex $cargas $x]
			puts $datos(cargaParcial,$x)
		}
	}; #finproc
	
	#devuelve una lista con de 4-tuplas "centroX centroY centroZ radio" de cada atomo de la molecula, de los data especificados en listaData
	proc generaListaCentroRadio { listaDatas } {
		set lista [list]
		foreach data $listaDatas {
			upvar #0 Data::$data datos
			
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				lappend lista [list $datos(coordX,$x)  $datos(coordY,$x) $datos(coordZ,$x) $datos(radioVdW,$x) $datos(simbolo,$x)]
				#lappend lista [list $datos(coordX,$x)  $datos(coordY,$x) $datos(coordZ,$x) 1]
			}
		}
		return $lista
	}; #finproc
	
	#devuelve -1 si el atomo x NO esta conectado a Y en la molecula base, 1 en caso contrario
	proc estaConectadoXY { base X Y } {
		upvar #0 Data::$base datos
		
		set res -1
		if {$X < $datos(numAtomos) && $Y < $datos(numAtomos)} {
			set res [lsearch $datos(conect,$X) $Y]
			if {$res >= 0} {set res 1}
		}
		return $res
	}; #finproc
	
	#devuelve -1 si el atomo x NO esta conectado a Y, 1 en caso contrario, base1 y base2 deben ser iguales
	proc estaConectadoXYMols { base1 X base2 Y } {
		
		if {$base1 == $base2 && [estaConectadoXY $base1 $X $Y] == 1} {
			return 1
		} 
		return -1
	}; #finproc
	
	#devuelve -1 si el atomo x NO esta conectado a un elemento elem, 1 en caso contrario
	proc estaConectadoXaElem { base id elem } {
		upvar #0 Data::$base datos
		
		set enc -1
		set i 0
		while {$enc == -1 && $i < [llength $datos(conect,$id)]} {
			if {$datos(simbolo,[lindex $datos(conect,$id) $i]) == $elem} { set enc 1 }
			incr i
		}
		return $enc
	}; #finproc
	
	proc estaConectadoXaElems { base id elems } {
		upvar #0 Data::$base datos
		
		set conectado -1
		set x 0
		while {$conectado == -1 && $x < [llength $elems]} {
			if {[estaConectadoXaElem $base $id [lindex $elems $x]] == 1} {
				set conectado 1
			} else {
				incr x
			}
		}
		return $conectado
	}; #finproc
	
	#devuelve una lista de los atomos  de tipo X, conectados a elementos de tipo Y que haya en la molecula base
	proc devuelveElemXConectadoaElemY { base elemX elemY } {
		upvar #0 Data::$base datos
		
		set listaF [list]
		
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			if {$datos(simbolo,$x) == $elemX} {
				puts "el elemento $x es del tipo $elemX --> $datos(simbolo,$x)"
				#es candidato, ahora compruebo si esta conectado a 
			}
		}
	}; #finproc
	
	#devuelve una lista de pares "mol ID" de las moleculas listaDatas, cuyo simbolo sea alguno de los contenidos en listaSimb
	proc devuelveMolIDCasaElem { listaDatas listaSimb } {
		
		set res [list]
		foreach mol $listaDatas {
			upvar #0 Data::$mol datos
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				if {[lsearch -exact $listaSimb $datos(simbolo,$x)] != -1} {
					lappend res "$mol $x"
				}
			}
		}
		return $res
	}; #finproc
	
	proc calculaPuentesHidrogeno { listaDatas listaSimb distancia } {
		
		set candidatos [devuelveMolIDCasaElem $listaDatas $listaSimb]
		set hidrogenos [devuelveMolIDCasaElem $listaDatas [list H]]
		
		
		puts $candidatos
		
		set puentes [list]
		
		foreach e $candidatos {
			upvar #0 Data::[lindex $e 0] datos1
			foreach hi $hidrogenos {	
				upvar #0 Data::[lindex $hi 0] datos2
				
				set dist [math::linearalgebra::norm [math::linearalgebra::sub "$datos1(coordX,[lindex $e 1]) $datos1(coordY,[lindex $e 1]) $datos1(coordZ,[lindex $e 1])" \
													"$datos2(coordX,[lindex $hi 1]) $datos2(coordY,[lindex $hi 1]) $datos2(coordZ,[lindex $hi 1])"] ]
				if {$dist <= $distancia && [estaConectadoXYMols [lindex $e 0] [lindex $e 1] [lindex $hi 0] [lindex $hi 1]] == -1 && [estaConectadoXaElems [lindex $hi 0] [lindex $hi 1] $listaSimb] == 1} {
					#existe puente hidrogeno
					lappend puentes [list $e $hi]
				}
			}
		}
		return $puentes
	}; #finproc

	#devuelve una lista de pares {id simbolo_quiralidad} segun la lista infoinchi, que debe ser una lista de dos elementos
	#el primero la infomarcion inchi, el segundo con la informacion auxiliar inchi
	#devolvera -1 si no ha sido posible extraer la informacion correcta
	proc calculaQuiralidad { infoinchi } {

		set inchi [lindex $infoinchi 0]
		set aux [lindex $infoinchi 1]
		
		puts "$inchi\n"

		#obtengo la informacion de la reenumeracion interna de inchi
		#esta dentro de los delimitadores /N:..../
		
		set l [split $aux "/"]
		#busco la sublista q comience por N:
		
		#busco la q empieze por /t
		set enc 0 ; set i 0
		while { $enc == 0 && $i < [llength $l]} {
			if {[string match "N:*" [lindex $l $i]]} {
				set enc 1
			} else {
				incr i
			}
		}
		if {$enc == 1} {
			set reenum [lindex $l $i]
		} else {
			return -1
		}
		
		#elimino el N:
		set reenum [string map {"N:" ""} $reenum]
		
		
		#corto por los ;
		set reenum [split $reenum ";"]
		#reenum es una lista con tantas componentes como grupos ha discretizado inchi
		
		#return $reenum
		puts "reenum : $reenum\n\n"
		
		
		
		#busco la informacion referente a la quiralidad, de existir se encuentra entre
		#/t /
		set l [split $inchi "/"]
		#busco la q empieze por /t
		set enc 0 ; set i 0
		while { $enc == 0 && $i < [llength $l]} {
			if {[string match "t*" [lindex $l $i]]} {
				set enc 1
			} else {
				incr i
			}
		}
		if {$enc == 1} {
			set quira [lindex $l $i]
		} else {
			return -1
		}
		#elimino el N:
		set quira [string map {"t" ""} $quira]
		
		puts "Quiralidad : $quira\n\n"
		
		
		
		#busco la informacion correspndiente a la inversion de quiralidad, de existir
		#se encuentra entre /m /
		set l [split $inchi "/"]
		#busco la q empieze por /t
		set enc 0 ; set i 0
		while { $enc == 0 && $i < [llength $l]} {
			if {[string match "m*" [lindex $l $i]]} {
				set enc 1
			} else {
				incr i
			}
		}
		if {$enc == 1} {
			set invquira [lindex $l $i]
		} else {
			return -1
		}
		#elimino el N:
		set invquira [string map {"m" ""} $invquira]
		
		puts "Inversion Quiralidad : $invquira\n\n"

		
		#proceso quira para identificar los atomos quirales
		set quira [split $quira ";"]
		
		#denomino grupo a cada una de las componentes extraidas de la lista de reenum
		set grupo 0
		
		
		#recorro todas las secciones q hay en quira, son secciones las partes separadas
		#por ';', y subsecciones las secciones q empiezen por <integer>*
		#al final la suma de secciones q no contengan subsecciones + subsecciones
		#debe ser = al numero de grupos
		set res [list]
		foreach q $quira {
			puts "proceso $q\n"
			
			if {$q == ""} {
				#es una seccion vacia de relleno 
				incr grupo
			} else {
				if {[scan $q {%i*%s} n cad] == 2} {
					#tiene subsecciones
				} else {
					#seccion simple
					set n 1
					set cad $q
				}
				
				set atomqui [split $cad ","]
				for {set x $grupo} {$x < [expr $grupo + $n]} {incr x} {
					foreach a $atomqui {
						if {[scan $a {%i%s} numat simbqui] == 2} {
							puts "grupo $x, atomo $numat, quira $simbqui -> [lindex [split [lindex $reenum $x] ","] [expr $numat - 1] ] , inversion qui [string range $invquira $x $x]"	
							
							set tipoqui "?"
							set invqui [string range $invquira $x $x]
							if {$simbqui == "+" && $invqui == 0} {
								set tipoqui "R"
							} elseif {$simbqui == "+" && $invqui == 1} {
								set tipoqui "S"
							} elseif {$simbqui == "-" && $invqui == 0} {
								set tipoqui "S"
							} elseif {$simbqui == "-" && $invqui == 1} {
								set tipoqui "R"
							}
							
							lappend res "[expr [lindex [split [lindex $reenum $x] ","] [expr $numat - 1]] - 1] $tipoqui"
						}
					}
				}
				incr grupo $n
			}
		}
		puts "grupos obtenidos : $grupo\ngrupos esperados [llength $reenum]"
		puts $res
		return $res
	}

#----------------------------------------------------------------------------------------------
#										-	CONVERSION ENTRE .MOL Y .XYZ   -
#----------------------------------------------------------------------------------------------		
	proc calculaAnillos { base } {
		upvar #0 Data::$base datos
		
		#incializa los anillos a 0, cuando sea necesario los calculare
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			for {set y 3} {$y <= 6} {incr y} {
				set datos(anillo,$y,$x) 0
			}
		}
		#Data::calculaAnillos $baseData
		
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			calculaAnillosRec $base $x [list $x]
		}
		
	}; #finproc
	
	proc calculaAnillosRec { base x visitados } {
		upvar #0 Data::$base datos

		if {[llength $visitados] <= 6} {
			set enl $datos(conect,$x)
			foreach e $enl {
				if {$e == [lindex $visitados 0] && [llength $visitados] > 2} {
					#puts "set datos(anillo,[llength $visitados],[lindex $visitados 0]) --> $visitados"
					set datos(anillo,[llength $visitados],[lindex $visitados 0]) 1
					#puts "datos(anillo,[llength $visitados],[lindex $visitados 0]) 1"
				} else {
					if {[lsearch -integer $visitados $e] == -1} {
						#puts "calculaAnillosRec $base $e [linsert $visitados end $e]"
						calculaAnillosRec $base $e [linsert $visitados end $e]
					}
				}
			}
		}
	}; #finproc

	#devuelve la codificacion Brandy del atomo,
	#	Codificacion Brandy :
	#		
	#	Ej:	C_305
	#		|||||-> Ciclo : 0, 3, 4, 5 ó 6
	#		||||--> Carga : 0, 3(+1), 2(radical), 5(-1)
	#		|||---> Valencia : 1, 2, 3 ó 4 -> valencia tinker = numero de atomos conectados a él
	#		||
	#		 -----> Simbolo Atomico
	proc codBrandy { base id } {
		upvar #0 Data::$base datos
		
		#para el simbolo
		if {[string length $datos(simbolo,$id)] == 1} {
			set simb "$datos(simbolo,$id)_"
		} else {
			set simb "$datos(simbolo,$id)"
		}
		
		#para tinker la valencia es el numero de atomos q estan unidos a el, no teniendo en cuenta el numero
		#de enlaces
		set valencia [llength $datos(conect,$id)]
		#puts "valencia : $valencia"
		
		#para los anillos me quedo con el menor, de los anillos en los q participe el atomo
		set ciclo 0
		for {set y 3} {$y <= 6} {incr y} {
			if {$datos(anillo,$y,$id) == 1 && $ciclo == 0} { 
				set ciclo $y
			}
		}
		return "$simb$valencia$datos(carga,$id)$ciclo"
	}; #finproc	
	
	#calcula la esfera de coordinacion de profundidad n para el atomo id
	#
	# devuelvo ramas de longitud n, cuyos elementos estan separados por '-'
	# las ramas son devueltas en forma de lista separadas por ':'
	#
	proc esferaCoordinacionN { base n id } {
		upvar #0 Data::$base datos
		
		#se incremeta 1 por el funcionamiento interno de esferasRecN
		#que devuelve a id al ppo de las lista, y no deberiamos contarlo
		#set n [expr $n + 1]
		
		set listaC [esferasRecN $base $n $id [list $id]]
		
		#tenemos algo de la forma {0 1 3} {0 1 4} {0 1 5 8} {0 2 6} {0 2 7}
		#queremos rutas de tamaño 4, por lo si no son de ese tamaño insertaremos elementos de la forma '+++++'
		#puts "esgera para $id : $listaC"
		#construyo la lista de esferas de coordinacion con el formato id-id2-+++++:...
		set listaF [list]
		foreach elem $listaC {
			
			set cam [list]
			for {set x 1} {$x < [llength $elem]} {incr x} {
				lappend cam [codBrandy $base [lindex $elem $x]]
			}
			#relleno con +++++ hasta que las listas tengan la forma id1-id2-id3
			set veces [expr $n - [llength $cam]]
			for {set x 0} {$x < $veces } {incr x} {
				#puts "añado"
				lappend cam "+++++"
			}
			#puts $cam
			lappend listaF $cam
		}
		
		set listaFF [list]
		foreach l $listaF { lappend listaFF [join $l -]}
		#puts "esfera $id : [join $listaFF :]"
		return [join $listaFF :]
	}; #finproc
	
	#Considerando la molecula un grafo, devuelve todos los caminos partiendo desde la molecula id
	#de longitud mas proxima a n
	proc esferasRecN { base n id visitados } {
		upvar #0 Data::$base datos
		
		if {$n == 0 || ([llength $datos(conect,$id)] <= 1 && [llength $visitados] != 1)} {
			return [list [list $id]]
		} else {
			set lista [list]
			foreach e $datos(conect,$id) {
				if {[lsearch -integer $visitados $e] == -1} {
					lappend lista [esferasRecN $base [expr $n - 1] $e [linsert $visitados end $id]]
				}
			}
			set listaCam [list]
			foreach l $lista {
				foreach l2 $l {
					lappend listaCam [linsert $l2 0 $id]
				}
			}
			return $listaCam
		}
	};#finproc
	
	proc calculaProcsConv { base } {
		upvar #0 
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#										-	HIDROGENOS   -
#----------------------------------------------------------------------------------------------		
#----------------------------------------------------------------------------------------------
#										-	HIDROGENOS   -
#----------------------------------------------------------------------------------------------		

	#procedimiento de adicion de hidrogenos a la molecula representada por base
	proc addHidrogenos { base baseConf } {
		upvar #0 Data::$base datos
		
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			addHAtomo $base $x
		}
		set datos(modificada) 0
	}; #finproc
	
	proc addHAtomo { base id1 } {
		upvar #0 Data::$base datos
		
		#puts "<---------------------->"
		#clasificacion de los atomos segun el número atómico este valor nos indicará 
                #la valencia del atomo tratado
		set blist {5 13}
		set clist {3 4 6 11 12 14 19 20 9 17 35 53}
		set nolist {7 8 15 16 33 34}
		
		set ok 0
		# la valencia real debe considerar las cargas
		set valreal $datos(valenciaReal,$id1)
		if {[lsearch -integer $blist $datos(numAtom,$id1)] != -1} {
			set valreal [expr  $datos(valenciaReal,$id1) - [cargaReal $datos(carga,$id1)]]
			set ok 1
		} elseif {[lsearch -integer $clist $datos(numAtom,$id1)] != -1} {
			set valreal [expr  $datos(valenciaReal,$id1) - abs([cargaReal $datos(carga,$id1)])]
			set ok 1
		} elseif {[lsearch -integer $nolist $datos(numAtom,$id1)] != -1} {
			set valreal [expr  $datos(valenciaReal,$id1) + [cargaReal $datos(carga,$id1)]]
			set ok 1
		}

		#ya tengo la valencia real del atomo
		
		#puts wiowio
                #mientras la valencia del átomo sea 
		while {$datos(valencia,$id1) < $valreal && $ok == 1} {
			
			
			puts "$id1 : $datos(valencia,$id1)  $valreal"
		
			# le faltan hidrogenos al atomo, debo añadirle
			
			set numEnl [llength $datos(conect,$id1)]
			
			
			#para añadir hidrogenos, considerare que el maximo numero de atomos que pueden estar 
			#conectados a otro, es 4 (por Quimica Organica).
			
			
			#dependiendo del numero de atomos a los q este conectado, la manera de conectarlos sera diferente
			if {$numEnl == 0} {
				#el atomo no esta unido a nada, esta solo
				#es el caso mas sencillo le añadire el hidrogeno en la misma posicion q este numAtom desplazando
				#en 1 unidad la coordenada X
				set cx [expr 1 + $datos(coordX,$id1)]
				set cy $datos(coordY,$id1)
				set cz $datos(coordZ,$id1)
				addH $base $cx $cy $cz $id1
			} elseif {$numEnl == 1} {
				#el atomo esta unido a otro atomo
				#miro que atomo es
				set id2 [lindex $datos(conect,$id1) 0]
				#dependiendo del tipo de enlace que haya entre ambos, se producira un tipo de hibridacion
                                #el angulo corresponde será el angulo que esa hibridación posee - 90
                                #sp3 107.5, sp2 120 y sp 180
				switch $datos(tipoConect,$id1,$id2) {
					2 {
						#hibridacion SP2
						addH2Ang $base $id1 $id2 30
					}
					3 {
						#hibridacion SP1
						addH2Ang $base $id1 $id2 90
					}
					default {
						#hibridacion SP3
						addH2Ang $base $id1 $id2 17.5
					}
				}
			} elseif {$numEnl == 2} {
				#el atomo esta unido a 2 atomos
				
				#en este caso solo existen 2 situaciones, o es
				#hibridacion sp2 o sp3
				set id2 [lindex $datos(conect,$id1) 0]
				set id3 [lindex $datos(conect,$id1) 1]
				if {$datos(tipoConect,$id1,$id2) == 2 || $datos(tipoConect,$id1,$id3) == 2 } {
					#hibridacion sp2
					addH3Ang $base $id1 $id2 $id3 90
				} else { 
					#hibridacion sp3
					addH3Ang $base $id1 $id2 $id3 30
				}
			} else {
				#el atomo esta unido a 3 atomos
				set id2 [lindex $datos(conect,$id1) 0]
				set id3 [lindex $datos(conect,$id1) 1]
				set id4 [lindex $datos(conect,$id1) 2]
				
				#esta claro que es sp3, tetrahedro, no necesito al angulo, ya es impicito
				addH4Ang $base $id1 $id2 $id3 $id4
			}
			#incr datos(valencia,$id1)
		}
	}; #finproc
	
	#añade un hidrogeno en base, en la posicion (x y z) y lo conecta al atomo numAtom
	proc addH { base x y z numAtom } {
		upvar #0 Data::$base datos

		
		#actualizo la base de datos
		
		
		#puts $datos(numAtomos)
		#datos del atomo
		set num $datos(numAtomos)
		incr datos(numAtomos)
		incr datos(numEnlaces)
		
		set datos(coordX,$num) $x
		set datos(coordY,$num) $y
		set datos(coordZ,$num) $z
		
		set datos(simbolo,$num) H
		set datos(colorAtom,$num) #ffffff
			
		set datos(carga,$num) 0
		
		set infoAto [Data::obtenerNumAt H]
		set datos(numAtom,$num) [lindex $infoAto 0]
		set datos(radioVdW,$num) [lindex $infoAto 1]
		set datos(valenciaReal,$num) [lindex $infoAto 2]
		set datos(valencia,$num) 1
		
		#ahora los datos del enlace
		set datos(conect,$num) [list $numAtom]
		set datos(tipoConect,$num,$numAtom) 1
		
		#actualizo los datos del atomo numAtom, para mantener la concordancia de datos
		lappend datos(conect,$numAtom) $num
		set datos(tipoConect,$numAtom,$num) 1
		incr datos(valencia,$numAtom)
		
	}; #finproc
	
	#ADICION DE 1 HIDROGENO DE 1 ATOMO UNIDO A UN SOLO ATOMO
	proc addH2Ang { base id1 id2 ang } {
		
		upvar #0 Data::$base datos
		#DEFINO EL VECTOR QUE UNE EL  ORIOGEN DE COORDENADAS CON CADA UNO DE ESTOS ATOMOS
		set a "$datos(coordX,$id1) $datos(coordY,$id1) $datos(coordZ,$id1)"
		set b "$datos(coordX,$id2) $datos(coordY,$id2) $datos(coordZ,$id2)"
		#OBTENGO EL VECTOR C QUE UNE B A A
		set c [math::linearalgebra::sub $a $b]
                
		#ESTE VECTOR PUEDE TENER DOS PROBLEMAS 
                #QUE SEA UN VECTOR NULO PORQUE LOS áTOMOS A Y B ESTUVIESEN DIBUJADOS EN LA MISMA POSICION
                #O QUE SEA UN VECTOR EN LA DIRECCION DE UNO DE LOS VECTORES UNITARIOS DEL EJE DE COORDENADAS
                #LA PRIMERA SITUACION ES IMPROBABLE (AUNQUE SERA NECESARIO CONYTROLARLA)
                #LA SEGUNDA SITUACIóN ES FACTIBLE Y EN ESE CASO DEBERé ESCOGER UN TERCER VECTOR QUE SEA 
                #PERPENDICULAR A EL
                #PARA ELLO CALCULO EL VECTOR UNITARIO
		set c [math::linearalgebra::unitLengthVector $c]
                #MIRO SI DOS DE SUS COMPONENTES SON NULAS (ENTONCES SERA UNITARIO EN UN EJE)
                #SI ES ASI DEBO CONOCER SU DIRECCION Y EN FUNCION DE ELLA DEFINIR EL VECTOR PERPENDICULAR
		if { [llength [lsearch -all $c "0.0"]] == 2 } {
                        puts "Estoy $base $id1 $id2 $ang" 
			set kk [lsearch -all $c "1.0"]
			if { $kk == "" } {
				set kk [lsearch -all $c "-1.0"]
			}
			switch $kk {
				0	{ set d [list 0 0 1]}
				1	{ set d [list 0 0 1]}
				2	{ set d [list 0 1 0]}
			}
		} else {
                        #COMO NO ES UN VECTOR UNITARIO PUEDO HACER EL PRODUCTO VECTORIAL DE A Y B                        
                        # Y SERA UN VECTOR PERPENDICULAR A C
			#HAGO EL PRODUCTO VECTORIAL DE AMNBOS VECTORES 
			set  d [math::linearalgebra::crossproduct $a $b] 
                        set d [math::linearalgebra::unitLengthVector $d]
		}
		puts "Estoy $base $id1 $id2 $ang $c y $d"
                #UNA VEZ TENGO EL VECTOR PERPENDICULAR AL VECTOR AB PUEDE OCURRIR QUE 
                #ESTE ADICIONANDO HIDRóGENO A UN SISTEMA QUE ES SP2 Y QUE POSEA EL OTRO EXTREMO
                #áTOMOS YA UNIDOS. EN ESTE CASO DEBO AñADIR LOS H COPLANARES A LOS áTOMOS UNIDOS AL
                #OTRO EXTREMO POR ELLO EN LUGAR DE QUEDARME CON EL VECTOR PERPENDICULAR AL QUE UNE AMBOS
                # ME QUEDO CON EL VECTOR PERPENDICULAR AL PRODUCTO VECTORIAL DE LOS VECTORES DEL ENLACE
                #AL QUE ADICIONO Y EL QUE ME DETERMINA EL PLANO
		if { $ang == 30 } {
			if { [llength $datos(conect,$id2)] >= 2 } {
                        #ESTE ATOMO ES SP2 Y ESTA UNIDO SU OTROEXTREMO A ALGUIEN BUSCO QUIEN ES
				set index [lsearch $datos(conect,$id2) $id1]
				set lista [lreplace $datos(conect,$id2) $index $index]
				set id3 [lindex $lista 0]
                                #M ES EL VECTOR DEL ATOMO AL QUE SE UNE
				set m "$datos(coordX,$id3) $datos(coordY,$id3) $datos(coordZ,$id3)"
                                #L ES EL VETOR QUE DEFINE EL PLANO DONDE DEBE ESTAR EL SIGUIENTE HIDROGENO
				set l [math::linearalgebra::sub $m $b]
                                #AS ES EL VECTOR PERPENDICULAR AL PLANO DE L Y C
                                set as [math::linearalgebra::crossproduct $l $c]
                                #Y D SERA EL PERPENDICULAR A ESTE ULTIMO
                                set d [math::linearalgebra::crossproduct $as $c]
                                set d [math::linearalgebra::unitLengthVector $d]
							}
		}
		
		#CALCULO CUANTO TENGO QUE ROTAR
		set cos [expr cos($ang*$math::constants::degtorad)]
		set sin [expr sin($ang*$math::constants::degtorad)]
		
		set f [math::linearalgebra::rotate $cos $sin $c $d] ;#devuelve sin*c - cos*d y sin*c + cos*d
		set f [lindex $f 1] ;#me quedo con sin*c + cos*d
		
		set f [math::linearalgebra::unitLengthVector $f]
		set i [math::linearalgebra::add $a $f]
		addH $base [lindex $i 0] [lindex $i 1] [lindex $i 2] $id1
		
	}; #finproc
	
	proc addH3Ang { base id1 id2 id3 ang } {
		
		upvar #0 Data::$base datos
		
		set a "$datos(coordX,$id1) $datos(coordY,$id1) $datos(coordZ,$id1)"
		set b "$datos(coordX,$id2) $datos(coordY,$id2) $datos(coordZ,$id2)"
		set c "$datos(coordX,$id3) $datos(coordY,$id3) $datos(coordZ,$id3)"
		
		
		set ab [math::linearalgebra::sub $a $b]
		set ab [math::linearalgebra::unitLengthVector $ab]
		set ac [math::linearalgebra::sub $a $c]
		set ac [math::linearalgebra::unitLengthVector $ac]
		
		#OBTENGO UN VECTOR PERPENDICULAR AL PLANO QUE FORMAN ESTOS DOS
		set prod [math::linearalgebra::crossproduct $ab $ac] 
                set prod [math::linearalgebra::unitLengthVector $prod]
		#OBTENGO UN VECTOR RESULTANTE DE SAMAR AB Y AC
		set abac [math::linearalgebra::add $ab $ac]
                set abac [math::linearalgebra::unitLengthVector $abac]
		#AHORA ROTO EL ANGULO NECESARIO RESPECTO DEL PLANO QUE FORMAN ABAC y PROD
		set cos [expr cos($ang*$math::constants::degtorad)]
		set sin [expr sin($ang*$math::constants::degtorad)]
		set f [math::linearalgebra::rotate $cos $sin $abac $prod] ;#devuelve sin*c - cos*d y sin*c + cos*d
		set f [lindex $f 1]
		set f [math::linearalgebra::unitLengthVector $f]
		set i [math::linearalgebra::add $a $f]
		
		addH $base [lindex $i 0] [lindex $i 1] [lindex $i 2] $id1
	}; #finproc
	
	proc addH4Ang { base id1 id2 id3 id4 } {
		
		upvar #0 Data::$base datos
		
		#FIJO LOS VECTORES DE LOS TRES
		set a "$datos(coordX,$id1) $datos(coordY,$id1) $datos(coordZ,$id1)"
		set b "$datos(coordX,$id2) $datos(coordY,$id2) $datos(coordZ,$id2)"
		set c "$datos(coordX,$id3) $datos(coordY,$id3) $datos(coordZ,$id3)"
		set d "$datos(coordX,$id4) $datos(coordY,$id4) $datos(coordZ,$id4)"
		
		#CREO EL VECTOR AB QUE UNE A y B
		set ab [math::linearalgebra::sub $a $b]
		set ab [math::linearalgebra::unitLengthVector $ab]
		#CREO EL VECTOR AC QUE UNE A y C
		set ac [math::linearalgebra::sub $a $c]
		set ac [math::linearalgebra::unitLengthVector $ac]
		#CREO EL VECTOR AC QUE UNE A y D
		set ad [math::linearalgebra::sub $a $d]
		set ad [math::linearalgebra::unitLengthVector $ad]
		#OBTENGO UN VECTOR RESULTANTE DE SAMAR AB AC y AD
		set abac [math::linearalgebra::add $ab $ac]
		set abacad [math::linearalgebra::add $abac $ad]
		#SI EL MODULO ES CERCANO A 0 DEBO USAR UN VECTOR DISTINTO
		#PARA QUE AL MENOS NO COLOQUE LOS PROTONES EN EL MISMO PLANO 
		#QUE LOS CUATRO ATOMOS QUE DEBEN ESTAR COPLANARES EN REALIDAD LO LOGICO ES 
		#CONFIRMAR QUE LOS CUATRO ATOMOS NO SON COPLANARES AHORA LO HAGO
		#puts "Angulo de perp [expr $math::constants::radtodeg*[math::linearalgebra::angle [math::linearalgebra::crossproduct $ab $ac] $ad]]"
		#set mod [math::linearalgebra::norm $abacad]
		#CALCULO EL ANGULO QUE FORMAN EL PERPENDICULAR A AB Y AC CON AD
		set mod [expr $math::constants::radtodeg*[math::linearalgebra::angle [math::linearalgebra::crossproduct $ab $ac] $ad]]
		if { [expr round($mod)] == 90 } {
			set abacad [math::linearalgebra::crossproduct $ab $ac] 
		} 
		#LO NORMALIZO Y LO ESCALO
		set abacad [math::linearalgebra::unitLengthVector $abacad]

		set i [math::linearalgebra::scale 1 $abacad]
		set i [math::linearalgebra::add $a $abacad]
		puts "Añado H3sp3 a $id1 El modulo es $mod para  $id2 $id3 $id4"		
		addH $base [lindex $i 0] [lindex $i 1] [lindex $i 2] $id1
	}; #finproc
	
	proc devolverHidrogenosMol { base } {
		upvar #0 Data::$base datos
		
		set listaH [list]
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			if {$datos(simbolo,$x) == "H"} {
				lappend listaH $x
			}
		}
		return $listaH
	}; #finproc
	
	proc devolverHidrogenosDelAtomo { base numAtom } {
		upvar #0 Data::$base datos
		
		set listaH [list]
		foreach a $datos(conect,$numAtom) {
			if {$datos(simbolo,$a) == "H"} {
				lappend listaH $a
			}
		}
		return $listaH
	};#finproc
	
	#obtiene una lista con los numeros de los atomos Hidrogenos que estan conectados con 'atomo'
	#siendo 'atomo' distinto de un hidrogeno
	proc devuelveHidrogDelAtomo { base atomo } {
		upvar #0 Data::$base datos
		
		set listaHidrog [list]
		
		#compruebo q 'atomo' no sea H, esto evita recursion infinita en VisorVTK::moverAtomosMol,
		#que es quien usa esta funcion exclusivamente
		if {$atomo != "H"} {
			set listaConect $datos(conect,$atomo)
			foreach x $listaConect {
				if {$datos(simbolo,$x) == "H"} {
					lappend listaHidrog $x
				}
			}
		}
		return $listaHidrog
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#										-	IMAGEN ESPECULAR   -
#----------------------------------------------------------------------------------------------		
	
	#calcula la imagen especular respecto del eje proporcionado, eje : X, Y, Z
	proc imagenEspecularMol { base eje } {
		upvar #0 Data::$base datos
		
		set modX 1 ; set modY 1 ; set modZ 1
		switch $eje {
			X {set modX -1} 
			Y {set modY -1}
			Z {set modZ -1}
		}
		
		for {set i 0} {$i < $datos(numAtomos)} {incr i} {
			set datos(coordX,$i) [expr $datos(coordX,$i) * $modX]
			set datos(coordY,$i) [expr $datos(coordY,$i) * $modY]
			set datos(coordZ,$i) [expr $datos(coordZ,$i) * $modZ]
		}
	}; #finproc
	
	proc imagenEspecularCasoEsp { base x } {
		upvar #0 Data::$base datos
		
		# Solo considerare 2 casos : 
		#  1 atomo marcado, enlazado a 4 atomos, de los cuales 2 son terminales
		#	- sea x el atomo marcado
		#		--> sean a y b los atomos no terminales 
		#		--> sean c y d los atomos no terminales 
		# Procedimiento : reflejar c y d respecto del plano fornado por x, a, b
		#
		# 1 atomo marcado, enlazado a 4 atomos, de los cuales solo 1 es terminal
		#	- sea x el atomo marcado
		#		--> sean a, b y c los atomos no terminales 
		#		--> sea d los atomos no terminales 
		# Procedimiento : reflejar x y d respecto del plano fornado por a, b y c			
		
		if {[llength $datos(conect,$x)] == 4} {
			set a [lindex $datos(conect,$x) 0]
			set b [lindex $datos(conect,$x) 1]
			set c [lindex $datos(conect,$x) 2]
			set d [lindex $datos(conect,$x) 3]
			
			set numEnlaces_a [llength $datos(conect,$a)]
			set numEnlaces_b [llength $datos(conect,$b)]
			set numEnlaces_c [llength $datos(conect,$c)]
			set numEnlaces_d [llength $datos(conect,$d)]
			
			#set lista "$numEnlacesA $numEnlacesB $numEnlacesC $numEnlacesD"	
			set terminales [list]
			set noTerminales [list]
			
			set lista [list "$numEnlaces_a $a" "$numEnlaces_b $b" "$numEnlaces_c $c" "$numEnlaces_d $d"]	
			foreach e $lista {
				if {[lindex $e 0] == 1} {
					lappend terminales [lindex $e 1]
				} else {
					lappend noTerminales [lindex $e 1]
				}
			}
			
			if {[llength $terminales] == 1} {
				#calculo las nuevas coordenadas para los terminales
				set t1 [lindex $terminales 0]
				set nt1 [lindex $noTerminales 0]
				set nt2 [lindex $noTerminales 1]
				set nt3 [lindex $noTerminales 2]
				
				set cx "$datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)"
				set ct1 "$datos(coordX,$t1) $datos(coordY,$t1) $datos(coordZ,$t1)"
				set cnt1 "$datos(coordX,$nt1) $datos(coordY,$nt1) $datos(coordZ,$nt1)"
				set cnt2 "$datos(coordX,$nt2) $datos(coordY,$nt2) $datos(coordZ,$nt2)"
				set cnt3 "$datos(coordX,$nt3) $datos(coordY,$nt3) $datos(coordZ,$nt3)"

				set ncx [calculoPuntoSimetricoPlano $cnt1 $cnt2 $cnt3 $cx ]
				set nct1 [calculoPuntoSimetricoPlano $cnt1 $cnt2 $cnt3 $ct1 ]

				set datos(coordX,$x) [lindex $ncx 0]	
				set datos(coordY,$x) [lindex $ncx 1]
				set datos(coordZ,$x) [lindex $ncx 2]
				
				set datos(coordX,$t1) [lindex $nct1 0]	
				set datos(coordY,$t1) [lindex $nct1 1]
				set datos(coordZ,$t1) [lindex $nct1 2]
				
			} elseif {[llength $terminales] == 2} {
				#calculo las nuevas coordenadas para los terminales
				set t1 [lindex $terminales 0]
				set t2 [lindex $terminales 1]
				set nt1 [lindex $noTerminales 0]
				set nt2 [lindex $noTerminales 1]
				
				set cx "$datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)"
				set ct1 "$datos(coordX,$t1) $datos(coordY,$t1) $datos(coordZ,$t1)"
				set ct2 "$datos(coordX,$t2) $datos(coordY,$t2) $datos(coordZ,$t2)"
				set cnt1 "$datos(coordX,$nt1) $datos(coordY,$nt1) $datos(coordZ,$nt1)"
				set cnt2 "$datos(coordX,$nt2) $datos(coordY,$nt2) $datos(coordZ,$nt2)"
				
				set nct1 [calculoPuntoSimetricoPlano $cx $cnt1 $cnt2 $ct1 ]
				set nct2 [calculoPuntoSimetricoPlano $cx $cnt1 $cnt2 $ct2 ]
				
				set datos(coordX,$t1) [lindex $nct1 0]	
				set datos(coordY,$t1) [lindex $nct1 1]
				set datos(coordZ,$t1) [lindex $nct1 2]
				
				set datos(coordX,$t2) [lindex $nct2 0]	
				set datos(coordY,$t2) [lindex $nct2 1]
				set datos(coordZ,$t2) [lindex $nct2 2]
			}
		}
	}; #finproc
	
	
}; #finnamespace
