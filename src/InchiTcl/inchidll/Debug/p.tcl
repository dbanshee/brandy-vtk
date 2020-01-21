proc p { infoinchi } {

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
						
						lappend res "[lindex [split [lindex $reenum $x] ","] [expr $numat - 1]] $tipoqui"
					}
				}
			}
			incr grupo $n
		}
	}
	
	
	puts "grupos obtenidos : $grupo\ngrupos esperados [llength $reenum]"
	puts $res
	
	

}

p [infoinchi raro.mol]



