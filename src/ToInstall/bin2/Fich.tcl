#######################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#							- MODULO PARA EL MANEJO DE LOS FICHEROS -
#									 --------------------
# Manejo de los ficheros .mol. Como su lectura y asociacion a un Data, o la escritura de un
# nuevo fichero a partir del Data
# 
#
#	Definido dentro del
#			namespace eval Fich
#
#	Define :
#		proc leeFichMol { file baseData }
#		proc escribeFichMol {file baseData} 
#
#
#
#
#
#########################################################################################################

package require twapi

namespace eval Fich {
	
	#lee un fichero .mol, y guarda el resultado en la instancia de datos definida a partir de baseData
	proc leeFichMol { file baseData baseConf } {
		
		upvar #0 Data::$baseData datos
		upvar #0 Conf::$baseConf config
		
		set datos(nombreFich) $file
		
		#borrar posibles datos de baseData e inicializar 
		#--
		set datos(modificada) 1
		
		#abro el fichero
		set fich [open $file r]
		#consumo las lineas del titulo
		gets $fich linea
		gets $fich linea
		gets $fich linea
		
		#la siguiente linea contiene contiene el numero de atomos y el numero de enlaces
		gets $fich linea
		set datos(numAtomos) [string trim [string range $linea 0 2]]
		set datos(numEnlaces) [string trim [string range $linea 3 5]]
		
		#leo los datos de los atomos
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			gets $fich linea
			
			set datos(coordX,$x) [string trim [string range $linea 0 9]]
			set datos(coordY,$x) [string trim [string range $linea 10 19]]
			set datos(coordZ,$x) [string trim [string range $linea 20 29]]
			set datos(simbolo,$x) [string trim [string range $linea 30 33]]
			
			#puts "atomo $x : $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)"
			
			#ahora q se que atomo es le asocio su color
			set simb $datos(simbolo,$x)
			#puts "Simb : $simb --> $config(colorSimb,$simb)"
			set datos(colorAtom,$x) $config(colorSimb,$simb)
			
			set datos(carga,$x) [string trim [string range $linea 36 38]]
			#puts "atomo $x -  $datos(carga,$x)"
			set datos(cargaParcial,$x) 0
			
			set infoAto [Data::obtenerNumAt $datos(simbolo,$x)]
			set datos(numAtom,$x) [lindex $infoAto 0]
			set datos(radioVdW,$x) [lindex $infoAto 1]
			set datos(valenciaReal,$x) [lindex $infoAto 2]
		}
		
		set datos(cargasParcialesCalculadas) 0
		
		#inicializo las listas de conectividades a la lista vacia
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			set datos(conect,$x) [list]
		}
		
		#leo las conectividades, lo normal es que todo atomo tenga al menos una conexion, aunque no obstante
		#en caso contrario para cada atomo existira un lista datos(conect,x) inicializado a la lista vacia
		for {set x 0} {$x < $datos(numEnlaces)} {incr x} {
			gets $fich linea
			set alpha [string trim [string range $linea 0 2]]
			set alpha [expr $alpha - 1]
			set beta [string trim [string range $linea 3 5]]
			set beta [expr $beta - 1]
			set tipo [string trim [string range $linea 6 8]]
			
			set datos(tipoConect,$alpha,$beta) $tipo
			set datos(tipoConect,$beta,$alpha) $tipo
			lappend datos(conect,$alpha) $beta
			lappend datos(conect,$beta) $alpha
		}
		
		#cierro el fichero
		close $fich
		
		#calculo las valencias, esto no tiene nada que ver con el fichero propiamente dicho, pero
		#es un buen sitio para hacerlo, ya que es algo implicito de los datos que se acaban de cargar
		for {set x 0} {$x < $datos(numAtomos)} {incr x} { 
			set datos(valencia,$x) [llength $datos(conect,$x)] ; #la inicializo al numero de atomos q estan conectados
			#ahora tengo en cuenta el tipo del enlace
			foreach i $datos(conect,$x) {
				if {$datos(tipoConect,$x,$i)==2} {incr datos(valencia,$x)} ;# caso enlace doble
				if {$datos(tipoConect,$x,$i)==3} {incr datos(valencia,$x) 2} ;# caso enlace triple
			}
		}
		#for {set x 0} {$x < $datos(numAtomos)} {incr x} {
		#	puts "La valencia final del atomo $x es $datos(valencia,$x)"
		#}
		Data::calculaAnillos $baseData
		
		#inchi
		set inchi [calculaInchi $file $baseConf]
		if {$inchi != -1} {
			set datos(inchi) [lindex $inchi 0]
			set qui [Data::calculaQuiralidad $inchi]
			if {$qui != -1} {set datos(quiralidad) $qui} else { set datos(quiralidad) [list] }
		} else {
			set datos(inchi) ""
			set datos(quiralidad) [list]
		}
		
		
	}; #finproc
	
	proc actualizaInchi { file baseData baseConf } { 
		upvar #0 Data::$baseData datos
		
		set inchi [calculaInchi $file $baseConf]
		if {$inchi != -1} {
			set datos(inchi) [lindex $inchi 0]
			set qui [Data::calculaQuiralidad $inchi]
			if {$qui != -1} {set datos(quiralidad) $qui} else { set datos(quiralidad) [list] }
		} else {
			set datos(inchi) ""
			set datos(quiralidad) [list]
		}
	}; #finproc
	
	
	#obsoleto
	proc escribeFichMol2 { file baseData } {
		
		upvar #0 Data::$baseData datos
		
		set fich [open $file w]
		puts $fich $file ; #escribo la ruta del fichero
		puts $fich " BANBRANDY TO MOL"
		puts $fich " "
		
		puts -nonewline $fich [format "%3.0f%3.0f" $datos(numAtomos) $datos(numEnlaces)]
		puts $fich "  0  0  0  0  0  0  0  0  1 V2000"
		#para cada atomo escribo su carga, sus coordenadas y su tipo
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			puts $fich [format "%10.4f %9.4f %9.4f %-2s  0  $datos(carga,$x)  0  0  0  0  0  0  0  0  0  0" $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) $datos(simbolo,$x)]
		}	
		#sus enlaces
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			foreach i $datos(conect,$x) {
				if {$i < $x} {
					puts $fich [format "%3i%3i%3i  0  0  0  0" [expr $x + 1] [expr $i + 1] $datos(tipoConect,$x,$i)]
				}
			}
		}
		puts $fich "M  END"
		close $fich
		
	}; #finproc
	
	proc escribeFichMol { file listaBaseData baseConf } {
		upvar #0 Conf::$baseConf config
		
		set fich [open $file w+]
		puts $fich $file ; #escribo la ruta del fichero
		puts $fich " BANBRANDY TO MOL powered by BANSHEE&GT&FN"
		puts $fich " "
		
		
		set numAtomos 0
		set numEnlaces 0
		foreach mol $listaBaseData {
			upvar #0 Data::$mol datos
			incr numAtomos $datos(numAtomos)
			incr numEnlaces $datos(numEnlaces)
		}
		
		puts $fich [format "%3.0f%3.0f  0  0  0  0  0  0  0  0  1 V2000" $numAtomos $numEnlaces]
		#puts $fich "  0  0  0  0  0  0  0  0  1 V2000"
		
		file mkdir $config(dirTemp)
		set atomos [open "$config(dirTemp)at.temp" w+]
		set enlaces [open "$config(dirTemp)en.temp" w+]
		
		
		set numAtomos 0
		set numEnlaces 0
		foreach mol $listaBaseData {
			upvar #0 Data::$mol datos
			
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				puts $atomos [format "%10.4f %9.4f %9.4f %-2s  0%3i  0  0  0  0  0  0  0  0  0  0" $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) $datos(simbolo,$x) $datos(carga,$x) ]
			}
			
			#sus enlaces
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				foreach i $datos(conect,$x) {
					if {$i < $x} {
						puts $enlaces [format "%3i%3i%3i  0  0  0  0" [expr $x + 1 + $numAtomos] [expr $i + 1 + $numAtomos] $datos(tipoConect,$x,$i)]
					}
				}
			}
			incr numAtomos $datos(numAtomos)
		}
		flush $atomos
		flush $enlaces
		seek $atomos 0
		seek $enlaces 0

		#vuelco la informatcion al fichero
		gets $atomos linea
		while {$linea != ""} {
			puts $linea
			puts $fich $linea
			gets $atomos linea
		}
		gets $enlaces linea
		while {$linea != ""} {
			puts $linea
			puts $fich $linea
			gets $enlaces linea
		}
		close $atomos
		close $enlaces
		
		catch {	file delete -force "$config(dirTemp)at.temp"
				file delete -force "$config(dirTemp)en.temp"
		}
		
		puts $fich "M  END"
		close $fich
		return $file
		
	}; #finproc
	
	#ejecuta el programa externo inchi.exe para obtener toda la informacion inchi
	#y devolvera una lista de dos componentes, la informacion inchi ppal, y la informacion inchi auxiliar
	#devolvrea -1 en caso de no poder devolver la informacion adecuada
	proc calculaInchi { file baseConf } {
		upvar #0 Conf::$baseConf config
	 	
		catch { exec "$config(dirBin)inchi.exe" "$file" } res
		#busco en res la informacion q necesito InChI, y AuxInfo
		#puts "resultado inchi : $res"
		
		set x 0
		set lista [list]
		foreach e $res {
			if {[string match "*InChI=*" $e] || [string match "*AuxInfo=*" $e]} {
				lappend lista $e
			}
		}
		if {[llength $lista] == 2} { return $lista } else { return -1 }
	}; #finproc

	proc devuelveEnlacesFichMol { file } {
		#borrar posibles datos de baseData e inicializar 
		#--
		set datos(modificada) 1
		
		#abro el fichero
		set fich [open $file r]
		#consumo las lineas del titulo
		gets $fich linea
		gets $fich linea
		gets $fich linea
		
		#la siguiente linea contiene contiene el numero de atomos y el numero de enlaces
		gets $fich linea
		set numAtomos [string trim [string range $linea 0 2]]
		set numEnlaces [string trim [string range $linea 3 5]]
		
		#consumo las lineas de los datos de los atomos
		for {set x 0} {$x < $numAtomos} {incr x} {
			gets $fich linea
		}
		
		set enlaces [list]
		#guardo en enlaces los enlaces q haya en el fichero
		for {set x 0} {$x < $numEnlaces} {incr x} {
			gets $fich linea
			lappend enlaces $linea
		}
		
		#cierro el fichero
		close $fich
		
		return $enlaces
	}; #finproc
	
	proc devuelveNumAtomNumEnlacesFichMol { file } {
		#abro el fichero
		set fich [open $file r]
		#consumo las lineas del titulo
		gets $fich linea
		gets $fich linea
		gets $fich linea
		
		#la siguiente linea contiene contiene el numero de atomos y el numero de enlaces
		gets $fich linea
		set numAtomos [string trim [string range $linea 0 2]]
		set numEnlaces [string trim [string range $linea 3 5]]
		
		close $fich
		return "$numAtomos $numEnlaces"
	};#finproc
	
	#leera el contenido del portapapeles, y en caso de existir datos de Isis Draw, generara un archivo cliptmp.mol con el contenido
	#de la molecula en formato .mol
	proc leeClipboard { baseConf } {
		upvar Conf::$baseConf config
		
		twapi::open_clipboard
		set MDLFormat [twapi::register_clipboard_format "MDLCT"]
		set formats [twapi::get_clipboard_formats]
		if {[lsearch -integer $formats $MDLFormat] != -1} {
			#el clipboard contiene datos
			set MDLCont [twapi::read_clipboard $MDLFormat]
		} else {
			set MDLCont "vacio"
		}
		twapi::close_clipboard
		
		if {$MDLCont != "vacio"} {
			#tengo en contenido del clip en formato UTF-8
			set longi [string length $MDLCont]
			puts $MDLCont
			#paso a hexadecimal para lectura mas comoda
			set val "H[expr $longi*2]"
			binary scan $MDLCont $val aa
			#puts $MDLCont
			#cada 2 numeros, inserto una '\'
			regsub -all {..} $aa {\\x&} bb
			set bb [string map { "\\x00\\x16" "\\x0a\\x0a" "\\x00\\x27" "\\x0d" "\\x30\\x45" "\\x30\\x0d" "\\x15" "\\x0d" "\\x06" "\\x0d"} $bb]
			set dd [subst $bb]
			set abi [open $config(dirTemp)/temp.mol w]
			puts $abi $dd
			close $abi
			return "$config(dirTemp)temp.mol"
		} else {
			return ""
		}
	}; #finproc
	
	#copia al portapapeles el contenido del file en formato MDLCT
	proc escribeClipboard { file baseConf } {
		upvar #0 Conf::$baseConf config
		

		set fichMol [open $file r+]
		
		set cont ""
		
		#cabecera isis
		append cont "\x00\x16\x20\x20\x2D\x49\x53\x49\x53\x2D\x20\x20\x30\x31\x31\x31\x30\x37\x31\x30\x34\x38\x32\x44\x00\x27"

		#copio los datos del fichero
		#ignoro las 3 primeras lineas
		gets $fichMol linea ; gets $fichMol linea ; gets $fichMol linea
		
		#cabecera molecula
		gets $fichMol linea
		append cont "$linea\x45"
		
		set numAtomos [string trim [string range $linea 0 2]]
		set numEnlaces [string trim [string range $linea 3 5]]
		
		for {set x 0} {$x < [expr $numAtomos - 1]} {incr x} {
			gets $fichMol linea
			append cont "$linea\x45"
		}
		gets $fichMol linea
		if {$numEnlaces == 0} {
			append cont "$linea\x06"
		} else {
			append cont "$linea\x15"
			for {set x 0} {$x < [expr $numEnlaces - 1]} {incr x} {
				gets $fichMol linea
				append cont "$linea\x15"
			}
			gets $fichMol linea
			append cont "$linea\x06"
		}
		#M END
		append cont "\x4D\x20\x20\x45\x4E\x44\x00"
		
		close $fichMol
		twapi::open_clipboard
		twapi::empty_clipboard
		set format [twapi::register_clipboard_format "MDLCT"]
		
		twapi::write_clipboard $format $cont
		twapi::close_clipboard
	}; #finproc
	
	#convierte el fichero .xyz asociado al formato definido el el .prm, a .mol
	#el .mol es creado en el mismo directorio y con el mismo nombre (pero .mol) que el original
	#la conversion es llevada a cabo mediante los ficheros .bdy
	#utiliza el fichero mol para extraer la cabecera y las conexiones
	#
	
	proc XYZtoMOL { fileXYZ fileMOLOrig } {
		
		puts "$fileXYZ $fileMOLOrig"
		#abro para lectura
		set fXYZ [open $fileXYZ r]
		#set fMOLOrig [open $fileMolOrig r]
		
		#los simbolos de los elementos los tomare del fichero original, ya q no es extra�o que se pierdan en la conversion
		#a .xyz.
		
		#abro para lectura
		set fOrig [open $fileMOLOrig r+]
		#ignoro las 4 primeras lineas
		gets $fOrig lineaO; gets $fOrig lineaO; gets $fOrig lineaO; gets $fOrig lineaO
		
		
		
		#creo y abro para escritura
		set fMOL [open [file rootname $fileXYZ].mol w+]
		#tk_messageBox -message "escribo en : [file rootname $fileXYZ].mol"
		
		#cabecera
		set nums [devuelveNumAtomNumEnlacesFichMol $fileMOLOrig]
		puts $fMOL "[file rootname $fileXYZ].mol" ; #preguntar porq se le quitan las /
		puts $fMOL " XYZ to MOL powered by BANSHEE&GT&FN\n"
		puts $fMOL [format "%3.0f%3.0f  0  0  0  0  0  0  0  0  1 V2000" [lindex $nums 0] [lindex $nums 1]]
		
		#voy leyendo los la informacion de los atomos del fichero xyz, y transformandola al mol
		#ignoro la 1� linea
		gets $fXYZ linea
		for {set x 0} {$x < [lindex $nums 0]} {incr x} {
			gets $fXYZ linea
			set n [expr $x + 1]
			
			#simbolo
			#set simb [obtenerSimbMol [string trim [string range $linea 6 10]]]
			gets $fOrig lineaO
			set simb [lindex $lineaO 3]
			#puts "simb : $simb"
			
			
			#deberia comprobar con el bdy cual es el simbolo q realmente le corresponde
			
			set cX [string trim [string range $linea 11 22]]
			set cY [string trim [string range $linea 23 34]]
			set cZ [string trim [string range $linea 35 46]]
			set tipo [string trim [string range $linea 47 52]]
			#puts "tipo : $tipo"
			#la carga tb debe ser obtenida del bdy a partir del tipo leido en el xyz
			set carga [obtenerCargaXYZ $tipo]
			
			puts $fMOL [format "%10.4f %9.4f %9.4f %-2s  0  $carga  0  0  0  0  0  0  0  0  0  0" $cX $cY $cZ $simb]
		}
		
		#leo los enlaces del fichero mol original y se lo concateno al nuevo
		
		set enlaces [devuelveEnlacesFichMol $fileMOLOrig]
		foreach e $enlaces {
			puts $fMOL $e
		}
		puts $fMOL "M  END"
		
		close $fXYZ
		close $fMOL
		close $fOrig
		
		return "[file rootname $fileXYZ].mol"
	};#finproc	
	
	#Necesita que este en memoria el baseData del fichero MOL
	#esto ultimo no es expresamente necesario, pues prodriamos crear un data temporal a partir del
	#fichero mol, pero debido al funcionamiento del sistema el data siempre estara en memoria
	#por lo que nos ahorramos trabajo
	proc MOLtoXYZ { fileMOL baseData baseConf } {
		upvar #0 Data::$baseData datos
		upvar #0 Conf::$baseConf config
		
		puts $baseData
		#comprobar q estan cargados los procs del bdy q estamos usando
		#creo el nuevo fichero .xyz
		set fXYZ [open [file rootname $fileMOL].xyz w+]
	
		#inserto el numero de atomos
		set numAt [format "%6.0f" $datos(numAtomos)]
		puts $fXYZ "$numAt     MOL to XYZ powered by BANSHEE&GT&FN for [file tail $config(prmCargado)] parameter file"
		
		#inserto la info para cada atomo
		for {set x 0} {$x < $datos(numAtomos)} {incr x} {
			
			#puts "$x : "
			set cs [obtenerCodXYZ $baseData $x]
			set simb [lindex $cs 1]
			#puts "simbolo :$simb, [string length $simb]"
			if {[string length $simb] == 1} {
				set simb " $simb"
			}
			#puts $simb
			
			set conec ""
			foreach l $datos(conect,$x) {
				append conec " [format %5.0f [expr $l + 1]]"
			}
			#conectiva($x) "$conectiva($x) [format "%5.0f" [expr [lindex $conect($x) $y] + 1]]"
			set linea [format "%6.0f %s  %12.6f%12.6f%12.6f%6.0f%s" [expr $x + 1] $simb $datos(coordX,$x) \
						$datos(coordY,$x) $datos(coordZ,$x) [lindex $cs 0] $conec]
			puts $fXYZ $linea
		}
		
		close $fXYZ
		return "[file rootname $fileMOL].xyz"
	}; #finproc
	
	#devuelve las coordenadas resultantes de la conversion de fileMOL a un fichero
	#en formato MOPAC en coordenadas Cartesianas
	proc MOLtoMOPACCartesianas { fileMOL } {
		
		set fMOL [open $fileMOL r+]
		#desecho las 2 primeras lineas
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea
		
		#obtengo el numero de atomos
		gets $fMOL linea
		set numAtomos [string trim [string range $linea 0 2]]
		puts $numAtomos
		
		#leo los atomos y escribo el fichero mop
		for {set x 0} {$x < $numAtomos} {incr x} {
			#leo el fichero mol
			gets $fMOL linea
			set coordX [string trim [string range $linea 0 9]]
			set coordY [string trim [string range $linea 10 19]]
			set coordZ [string trim [string range $linea 20 29]]
			set simbolo [string trim [string range $linea 30 33]]
			
			#transformo y escribo en el fichero mop
			if {[string length $simbolo] == 1} {
				set simbolo "$simbolo "
			}
			append texto "[format "%s  %12.5f  %1u  %12.5f  %1u  %12.5f %1u" $simbolo \
						$coordX 1 $coordY 1 $coordZ 1]\n"
		}
		close $fMOL
		return $texto
	}; #finproc
	
	#devuelve el nombre del fichero .osc correspondiente a las ultimas coordenadas cartesianas encontradas en un fichero MOPAC
	#fileMOlOrig es el fichero mol a partir del cual se ha generado el MNO
	proc ultimasCoordMOPAC { fileMNO fileMOL } {
	
		#obtengo el numero de atomos del fichero mol original
		set fMOL [open $fileMOL r+]
		#desecho las 2 primeras lineas
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea

		#obtengo el numero de atomos
		gets $fMOL linea
		set numAtomos [string trim [string range $linea 0 2]]
		close $fMOL
		
		set fRes [open "[file rootname $fileMNO]-coords.osc" w+]
		puts $fRes "MOST UPDATE CARTESIAN COORDINATES from $fileMNO powered by BANSHEE"
		
		set fMNO [open $fileMNO r+]
		#en un fichero MNO pueden aparecer varios bloques de coordenadas cartesianas
		#primero leeremos el fichero para comprobar cuantas veces aparece la cadena  "CARTESIAN COORDINATES"
		
		#si el fichero MNO fuera consistente en cuanto a formato, q no lo es, se hubieran usado las opciones 
		#string range o seek, para capturar el bloque de codigo correspondiente a las coordenadas, una vez 
		#averiguado su comienzo mediante string last
		
		#por lo que tenemos q hacer 2 recorridos,sobre el fichero, una para buscar cuantos bloques hay,
		#y otro para recorrer las lineas
		
		set content [read $fMNO]
		
		set numBloques 0
		set n [string first "CARTESIAN COORDINATES" $content]
		while {$n != -1} {
			incr numBloques
			set n [string first "CARTESIAN COORDINATES" $content [expr $n + 20]]
		}
		
		#me situo al ppo del fichero
		seek $fMNO 0
		
		#consumo lineas hasta q este delante de la 1� coordenada del ultimo bloque del fichero
		while {$numBloques != 0} {
			gets $fMNO linea
			if {[string match "*CARTESIAN COORDINATES*" $linea]} {
				incr numBloques -1
			}
		}
		#estoy situado al ppo de la linea cartesian del ultimo bloque
		gets $fMNO linea ; puts $fRes $linea
		gets $fMNO linea ; puts $fRes $linea
		gets $fMNO linea ; puts $fRes $linea
		
		#leo las lineas y las guardo en el fichero
		#las lineas tienen un formato q dependen n� de bloque, para homogeneizar, se leera, extraera la informacion relevante
		#yse formateara de manera estandar
		for {set x 0} {$x < $numAtomos} {incr x} {
			gets $fMNO linea
			
			#scan $linea {%i%s%f%f%f} f1 f2 f3 f4 f5
			#puts $fRes [format "%i	%s	%f 	%f 	%f" $f1 $f2 $f3 $f4 $f5]
			puts $fRes $linea
		}
		close $fMNO
		close $fRes
		
		return "[file rootname $fileMNO]-coords.osc"
	}; #finproc
	
	#devuelve una lista con las cargas parciales de los atomos de la molecula definida en fileMOL
	proc ultimasCargasMOPAC { fileMNO fileMOL } {
		#obtengo el numero de atomos del fichero mol original
		set fMOL [open $fileMOL r+]
		#desecho las 2 primeras lineas
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea

		#obtengo el numero de atomos
		gets $fMOL linea
		set numAtomos [string trim [string range $linea 0 2]]
		close $fMOL
		
		#set fRes [open "[file rootname $fileMNO]-cargas.raf" w+]
		#puts $fRes "MOST UPDATE CHARGES from $fileMNO powered by BANSHEE"
		
		set fMNO [open $fileMNO r+]
		#las cargas pueden no aparecer, o bien aparecer 1 o + veces.
		#en el caso de aparecer 1 vez, se leen y se escriben al fichero .raf, de aparecer varias veces, se toma la ultima
		#y de no aparecer, se genera un fichero de cargas, con las mismas a 0
		
		set content [read $fMNO]
		
		set numBloques 0
		set n [string first "NET ATOMIC CHARGES AND DIPOLE CONTRIBUTIONS" $content]
		while {$n != -1} {
			incr numBloques
			set n [string first "NET ATOMIC CHARGES AND DIPOLE CONTRIBUTIONS" $content [expr $n + 43]]
		}
		
		set lista [list]
		if {$numBloques == 0} {
			# no hay coordenadas, genero las 0.0
			#leo las lineas y las guardo en el fichero
			for {set x 0} {$x < $numAtomos} {incr x} {
				lappend lista 0.0
			}
		} else {		
			#me situo al ppo del fichero
			seek $fMNO 0
			
			#consumo lineas hasta q este delante de la 1� carga del ultimo bloque del fichero
			while {$numBloques != 0} {
				gets $fMNO linea
				if {[string match "*NET ATOMIC CHARGES AND DIPOLE CONTRIBUTIONS*" $linea]} {
					incr numBloques -1
				}
			}
			gets $fMNO linea
			gets $fMNO linea
			
			#leo las lineas y las guardo en el fichero
			for {set x 0} {$x < $numAtomos} {incr x} {
				gets $fMNO linea
				if {[scan $linea {%s%s%f%s} f1 f2 f3 f4] == 4} {
					lappend lista $f3
				} else {
					lappend lista 0.0
				}
			}
		}
		close $fMNO
		#close $fRes

		return $lista
	}; #finproc
	
	#devuelve el nombre del fichero q contiene las primeras coordenadas internas de mopac correspondientes al fichMol
	#q se encuentren en fichMNO, este fichero debera haber sido creado con OSCF, de lo contrario se devolvera -1
	proc primerasInternasMOPACOSCF { fileMNO fileMOL } {
		
		#obtengo el numero de atomos del fichero mol original
		set fMOL [open $fileMOL r+]
		#desecho las 2 primeras lineas
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea

		#obtengo el numero de atomos
		gets $fMOL linea
		set numAtomos [string trim [string range $linea 0 2]]
		close $fMOL
		
		#
		set fMNO [open $fileMNO r+]
		gets $fMNO linea
		while {![eof $fMNO] && $linea != " 0SCF"} {
			gets $fMNO linea
		}
		
		if {![eof $fMNO]} {
			#ignoro las siguientes lineas
			gets $fMNO linea ; gets $fMNO linea ; gets $fMNO linea ; gets $fMNO linea
			gets $fMNO linea ; gets $fMNO linea ; gets $fMNO linea
			
			#guardo en textolas  coordenadas internas
			for {set x 0} {$x < $numAtomos} {incr x} {
				gets $fMNO linea
				set linea [string range $linea 12 end]
				set linea [string map {"*" "1"} $linea]
				append texto "$linea\n"
			}
			close $fMNO
			return $texto
		} else {
			close $fMNO
			return -1
		}
	}; #finproc
	
	#devuelve el nombre del fichero q contiene las primeras coordenadas internas de mopac correspondientes al fichMol
	#q se encuentren en fichMNO, este fichero debera haber sido creado con OSCF, de lo contrario se devolvera -1
	proc primerasCartesianasMOPACOSCF { fileMNO fileMOL } {
		
		#obtengo el numero de atomos del fichero mol original
		set fMOL [open $fileMOL r+]
		#desecho las 2 primeras lineas
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea

		#obtengo el numero de atomos
		gets $fMOL linea
		set numAtomos [string trim [string range $linea 0 2]]
		close $fMOL
		
		
		set fMNO [open $fileMNO r+]
		gets $fMNO linea
		while {![eof $fMNO] && ![string match "*GEOMETRY IN CARTESIAN COORDINATE FORMAT*" $linea]} {
			gets $fMNO linea
		}
		
		if {![eof $fMNO]} {
			#ignoro las siguientes lineas
			gets $fMNO linea ; gets $fMNO linea ; gets $fMNO linea 
			
			#recupero la informacion de las coordenadas
			set texto ""
			for {set x 0} {$x < $numAtomos} {incr x} {
				gets $fMNO linea
				append texto "[string trim $linea]\n"
			}
			close $fMNO
			return $texto

		} else {
			close $fMNO
			return -1
		}
	}; #finproc
	
	
	#genera el fichero MOL correspondiente a los datos mas actualizados de coordenadas y cargas del fichero MNO
	#devuelve su nombre
	proc MOPACtoMOL { fileMNO fileMOL } {
		
		#obtengo el numero de atomos del fichero mol original
		set fMOL [open $fileMOL r+]
		#desecho las 2 primeras lineas
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea

		#obtengo el numero de atomos y de enlaces
		gets $fMOL linea
		set numAtomos [string trim [string range $linea 0 2]]
		set numEnlaces [string trim [string range $linea 3 5]]
		
		#close $fMOL
		
		
		set fRes [open "[file rootname $fileMNO].mol" w+]
		puts $fRes "[file rootname $fileMNO].mol"
		puts $fRes " MOPAC to MOL powered by BANSHEE\n"
		
		set fCoords [ultimasCoordMOPAC $fileMNO $fileMOL]
		
		#abro los ficheros de coordenadas y cargas y me situ al ppo de los datos
		set fCoor [open $fCoords r+]
		#ignoro las 1� 4 lineas
		gets $fCoor lineaC; gets $fCoor lineaC; gets $fCoor lineaC; gets $fCoor lineaC
		
		set err 0
		#construyo el fichero mol
		puts $fRes [format "%3.0f%3.0f  0  0  0  0  0  0  0  0  1 V2000" $numAtomos $numEnlaces]
		for {set x 0} {$x < $numAtomos} {incr x} {
		
			#leo de los ficheros
			gets $fMOL linea
			gets $fCoor lineaC
			#gets $fCarg lineaCa
			
			set simbolo [string trim [string range $linea 30 33]]
			set carga [string trim [string range $linea 39 41]]
			
			#si se produce un error de formato devuelvo un error
			#no sera normal q se produzca un error ya que de haberse producido un error de formato
			#no aparecia MOPAC DONE al final del MNO, y no estariamos aki
			if {[scan $lineaC {%i%s%f%f%f} f1 f2 f3 f4 f5] == 5} {
				set coordX $f3
				set coordY $f4
				set coordZ $f5
				puts $fRes [format "%10.4f %9.4f %9.4f %-2s  0  $carga  0  0  0  0  0  0  0  0  0  0" $coordX $coordY $coordZ $simbolo]
			} else { set err 1 }
		}
		#ahora pego los enlaces
		set enl [devuelveEnlacesFichMol $fileMOL]
		foreach e $enl { puts $fRes $e }
		puts $fRes "M  END"
		
		close $fRes
		close $fCoor
		close $fMOL
		
		set f [open "[file rootname $fileMNO].mol" r+]
		puts [read $f]
		close $f
		
		if { $err == 1} { 
			return -1
		} else {
			return "[file rootname $fileMNO].mol"
		}
	}; #finproc
	
	#genera un archivo .mol, identico al fileMOL pero con las coordenadas extraidas del gpt
	proc COORGRAPHtoMOL { fileCOORGRAPH fileMOL } {
	
		set fCOOR [open $fileCOORGRAPH r+]
		set fMOL [open $fileMOL r+]
		
		#consumo en el fileGraph
		gets $fCOOR linea
		gets $fCOOR linea
		gets $fCOOR linea
		gets $fCOOR linea
		
		#consumo en el fich MOL
		gets $fMOL linea
		gets $fMOL linea
		gets $fMOL linea
		
		#la siguiente linea contiene contiene el numero de atomos y el numero de enlaces
		gets $fMOL linea
		puts $linea
		set numAtomos [string trim [string range $linea 0 2]]
		
		
		
		#el archivo q voy a escribir
		set fRes [open "[file rootname $fileMOL]-graph.mol" w+]
		
		puts $fRes $fileMOL ; #escribo la ruta del fichero
		puts $fRes " COORGRAPH TO MOL powered by BANSHEE&GT&FN"
		puts $fRes " "
		#escribo la linea q contiene los numeros de atomos u enlaces
		puts $fRes $linea
		
		#para cada atomo
		#leo los datos de los atomos
		#puts $numAtomos
		
		for {set x 0} {$x < $numAtomos} {incr x} {
			puts paso
			#del archivo mol original
			gets $fMOL linea
			set simbolo [string trim [string range $linea 30 33]]
			set carga [string trim [string range $linea 36 38]]
			
			#del archivo coorgraph
			gets $fCOOR linea
			puts $linea
			scan $linea {%i%f%f%f} f1 f2 f3 f4
			
			#escribo la la linea en el fichero resultado
			puts $fRes [format "%10.4f %9.4f %9.4f %-2s  0%3i  0  0  0  0  0  0  0  0  0  0" $f2 $f3 $f4 $simbolo $carga]
		}
		close $fMOL
		close $fCOOR
		
		set enlaces [devuelveEnlacesFichMol $fileMOL]
		foreach e $enlaces {
			puts $fRes $e
		}
		puts $fRes "M  END"
		close $fRes
		return "[file rootname $fileMOL]-graph.mol"
	}; #finproc
	
	#da la siguiente linea del fichero 'file' que no empieze por '#'
	#en forma de lista de 9 elementos
	proc dameLinea { file } {
		
		set ok 0
		gets $file linea
		#puts $linea
		while {![eof $file] && $ok == 0} {
			set lineap [split $linea "\t"]
			#puts $lineap
			if {[llength $lineap] > 0 && [string range [lindex $lineap 0] 0 0] != "#"} {
				set ok 1
			} else {
				gets $file linea
				#puts $linea
			}
		}
		if {$ok == 0} {
			return "FIN"
		} else {
			return $lineap
		}
	}; #finproc
	
	#somprueba el fichero prmCargado con el q contiene el fichero key y actualiza los procedimientos de
	#conversion si fuera necesario
	proc modificaPRM { base } {
		upvar #0 Conf::$base config
		
		#recalculo los procedimientos de conversion
		set fTINK [open $config(dirCHM)/TINKER.key r+]
		gets $fTINK line
		set line [string map { "PARAMETERS" "" " " ""} $line]
		close $fTINK
		
		set prmAnt $config(prmCargado)
		if {[file exists $line] && [file exists [file rootname $line].bdy]} {
			puts "---------------------------------------------------------------------------existe"
			set config(prmCargado) $line
			puts "config(prmCargado) $line"
			
		} else {
			set config(prmCargado) "$config(dirCHM)/MM3BrandyMol.prm"
			puts "establezco config(prmCargado) $config(dirCHM)/MM3BrandyMol.prm"
			tk_messageBox -type ok -title "Informacion" -message "El fichero $line o us correspondiente .bdy no se encuentra o es ilegible, se ha cargado \
											 MM3BrandyMol.prm por defecto. \nPor favor edite su fichero Tinker.key"
		}
		if {$prmAnt != $config(prmCargado)} {
			Fich::calculaProcsConvPRM $base
			puts "Fich::calculaProcsConvPRM $base"
			return 1
		} else {
			return 0
		}

		
	}
	
	#calcula los procedimientos necesarios para conversion entre .mol y .xyz, segun el archivo .prm
	#para ello tenemos los ficheros .bdy que contienen la informacion necesaria para realizar los cambios
	proc calculaProcsConvPRM { baseConf } {
		upvar #0 Conf::$baseConf config
		
		set procCarga "proc obtenerCargaXYZ \{ tipoXYZ \} \{\n"
		append procCarga "\t switch \$tipoXYZ \{\n"
		
		set procSimbolo "proc obtenerSimbMol \{ simbXYZ \} \{\n"
		append procSimbolo "\t switch \$simbXYZ \{ \n"
		
		set procCod "proc obtenerCodXYZ \{ baseData atomo \} \{\n"
		append procCod "\t upvar #0 Data::\$baseData datos \n\n"
		append procCod "\t switch -glob \[Data::codBrandy \$baseData \$atomo\] \{\n"
		
		
		set fBDY [open [file rootname $config(prmCargado)].bdy r]
		set linea [dameLinea $fBDY]
		#puts $linea
		set casoSwitch ""
		while {$linea != "FIN"} {
			
			#trato la linea
			if {[lindex $linea 0] != $casoSwitch} {
				#es un elemento nuevo
				#cierro el anterior
				if {$casoSwitch != ""} { append procCod "\t \}\n" }
				
				#abro un nuevo caso
				set casoSwitch [lindex $linea 0]
				append procCod "\t [lindex $linea 0] \{ \n\t\t set codigo \"[lindex $linea 2] [lindex $linea 4]\" \n"
			} else {
				#es otra restriccion del elemento anterior
				
				#pongo un if
				append procCod "\t\t if \{ \[casanExpr [lindex $linea 1] \[ Data::esferaCoordinacionN \$baseData 3 \$atomo\] \] == 1\} \{ set codigo \"[lindex $linea 2] [lindex $linea 4]\" \}\n"
			}
			
			#agrego la conversion del simbolo que haya en esta linea
			set c [string map {"_" ""} [string range [lindex $linea 0] 0 1]]
			append procSimbolo "\t\t [lindex $linea 4] \{ set simbolo $c \}\n"
			
			#agrego la conversion de cargas
			set carga [string range [lindex $linea 0] 3 3]
			if {$carga != 0} {
				append procCarga "\t\t [lindex $linea 2] \{ set carga $carga \}\n"
			}
		
			set linea [dameLinea $fBDY]
		}
		close $fBDY
		
		#cierro el ultimo caso, a�ado el default, cierro el switch, pongo el return y cierro el proc
		append procCod "\t\} \n\t default \{ set codigo \"999 XX\" \} \n"
		append procCod "\t \}\n"
		append procCod "return \$codigo \n \}"
		
		#a�ado el default, cierro el switch y el procedimiento
		append procSimbolo "\t\t default \{ set simbolo XX \}\n"
		append procSimbolo "\t \}\n"
		append procSimbolo "return \$simbolo \n \}"
		
		#a�ado el default, cierro el switch y el procedimiento
		append procCarga "\t\t default \{ set carga 0 \}\n"
		append procCarga "\t \}\n"
		append procCarga "return \$carga \n \}"
		
		#puts $procSimbolo
		
		eval $procCod
		eval $procSimbolo
		eval $procCarga
	}; #finproc
	
	#devuelve 1 si las expresiones casan, -1 en caso contrario
	proc casanExpr { exprGen exprAt } {
	
		#debo reestructurar exprGen 
		# #x#expr: --> repetir expr tantas veces como x

		#si la exprGen contienen #num# repito el elemento q le sigue inmediatamente despues
		#tantas veces como num
		set exprGenRev [list]
		set lista [split $exprGen \:]
		#trato un posible error
		if {[string match "#*#" [lindex $lista end]]} {
			set lista [lreplace $lista end end]
		}
		#siempre q haya un #num# habra un elemento siguiente
		while {[llength $lista] != 0} {
			if {[ string match "#*#" [lindex $lista 0]] } {
				set veces [string map { "#" "" } [lindex $lista 0]]
				for {set x 0} {$x < $veces} {incr x} { lappend exprGenRev "[lindex $lista 1]*" }
				set lista [lreplace $lista 0 1]
				
			} else {
				lappend exprGenRev "[lindex $lista 0]*"
				set lista [lreplace $lista 0 0]
			}
		}
		
		#puts "casan ? --> Gen : join $exprGenRev , at : [split $exprAt \:]\n\n"
		#puts "casan : --> Gen : [split $exprAt \:] ,Gen : $exprGenRev"
		#puts "at : [split $exprAt \:]"
		
		return [repartoTareas [split $exprAt \:] $exprGenRev]
	}; #finproc
	
	#realiza la resolucion del problema del reparto de tareas
	#	en este caso las tareas son las expresiones genericas del fichero prm
	#	y las personas son las expresiones concretas de la esfera de coordinacion del atomo
	#
	#	toma listas de listas de la forma { C-S C-*-* C-*-H C-F-H C-C-H C-*} y {C-P C-S C-F-H C-H-H C-C-H C-M-M}
	#	
	#	e intenta repartirlas entre si, de manera q existe solucion si se encuentra una expresion de de listaA para
	#	cada elemento de la listaA
	proc repartoTareas { listaA listaG } {
		if {[llength $listaG] == 0} {
			return 1
		} elseif {[llength $listaG] != 0 && [llength $listaA] == 0 } {
			return -1
		} else {
			for {set x 0} {$x < [llength $listaA]} {incr x} {
				if {[string match [lindex $listaG 0] [lindex $listaA $x]] == 1 && [repartoTareas [lreplace $listaA $x $x] [lreplace $listaG 0 0]] == 1} {
					return 1
				}
			}
			return -1
		}	
	}; #finproc
	
 }; #finnamespace