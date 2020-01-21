#######################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#				- MODULO PARA EL ALMACENAMIENTO Y MANIPULACION DE LA INFORMACION  GENERAL -
#									 --------------------
# Almacenara y manejara los datos generales de configuracion del programa
# 
#
#	Definido dentro del
#			namespace eval Conf
#
#	base(): array que representara la instancia de la Conf
#	
#	Objetos Fijos del Conf
#
#		base(dirPpal)			--> Directorio Ppal
#		base(dirTemp)			--> Directorio Temporal
#		base(dirBin)			--> Directorio Ejecutables
#		base(dirDataOrig)		--> Directorio de Datos Original
#		base(dirData)			--> Directorio Datos, se modifica cada vez q se habre un o guarda un fichero
#		base(dirCHM)			--> Directorio CHM
#		base(colorFondo)		--> Color Fondo
#		base(colorEtq)			--> Color Etiquetas
#		base(listaSimb)			--> Lista de Simbolos quimicos en el orden del fichero .ini
#		base(colorSimb,x)		--> color asociado al simbolo quimico x
#		base(numOrdenAtomo,x)	--> numero que ocupa en el fichero ini el elemento x
#
#		base(prmCargado) 		--> nombre del fichero del cual estan cargados los procedimientos de traduccion
#									obtenerCargaXYZ, obtenerSimbMol y obtenerCodXYZ
#		base(prmModificado)		--> 1 si ha sido modificado desde la ultima vez q se cargo, -1 en caso contrario
#		
#	Define :
#		proc newConf { base }
#		proc delConf { base }
#		proc inicializarConf { base file }
#
#
#
############################################################################################################


namespace eval Conf {

	proc newConf { base } {
		if {[array exists Conf::$base]==0} {
			variable ${base}
			return 0
		} else {
			return -1
		}
	}; #finproc
	
	proc delConf { base } {
		if {[array exists Conf::$base]} {
			unset Conf::$base
		}
	}; #finproc
	
	#buscara el archivo conf.ini en el directorio actual, de lo encontrarlo mostrara un error
	#modificar para que genere uno por defecto
	proc inicializarConf { base fileD fileC } {
		
		upvar #0 Conf::$base config
		
		
		#compruebo datos del registro de windows
		set reg [compruebaRegistroWindows $base]
		if {$reg != 1 } { return -1 }

		if {[file exists conf.ini]} {
			set fich [open $fileD r+]
			gets $fich line
			
			#obtengo el directorio ppal
			gets $fich line
			set config(dirPpal) [string map {"<DIR_PPAL>=" "" "\\" "/"} $line]
			
			#obtengo el directorio de trabajo
			gets $fich line
			set config(dirCHM) [string map {"<DIR_CHM>=" "" "\\" "/"} $line]
			puts $line
			puts [string map {"<DIR_CHM>=" "" "\\" "/"} $line]
			
			
			#obtengo el directorio ppal
			gets $fich line
			set config(dirTemp) [string map {"<DIR_TEMP>=" "" "\\" "/"} $line]
			file mkdir $config(dirTemp)
			
			#obtengo el directorio de ejecutables
			gets $fich line
			set config(dirBin) [string map {"<DIR_BIN>=" "" "\\" "/"} $line]

			#obtengo el directorio de datos
			gets $fich line
			set config(dirData) [string map {"<DIR_DATA>=" "" "\\" "/"} $line]
			set config(dirDataOrig) [string map {"<DIR_DATA>=" "" "\\" "/"} $line]
			file mkdir $config(dirData)
			
			#preferencias
			gets $fich line
			#escala cpk
			gets $fich line
			set config(escalaCPK) [string map {"<ESCALA>=" ""} $line]
			
			#consola
			gets $fich line
			set config(estadoConsola) [string map {"<CONSOLE>=" ""} $line]
			
			close $fich
			
			
			if {[compruebaIntegridadFicherosBrandy $base] == -1} { 
				return -1
			} else {
				#colores
				set fich [open $fileC r+]
				
				#obtengo el color de fondo
				gets $fich line
				set config(colorFondo) $line
				
				#obtengo el color de las etiquetas
				gets $fich line
				set config(colorEtq) $line
				
				set config(listaSimb) [list]
				#obtengo los colores asociados a los simbolos quimicos, hay 92 elementos definidos
				for {set x 0} {$x < 92} {incr x} {
					gets $fich line
					lappend config(listaSimb) [lindex $line 0]
					set config(colorSimb,[lindex $line 0]) [lindex $line 1]
					set config(numOrdenAtomo,[lindex $line 0]) $x 
					#set i [lindex $line 0]
					#puts "Atomo : $i, color : $x"
				}			
				
				close $fich
				#creo y cargo los procedimientos iniciales de conversion segun el fichero de parametros definido
				#en el TINKER.key
				set fTINK [open $config(dirCHM)/TINKER.key r]
				#en la 1� linea deberia estar el fichero de parametros
				
				gets $fTINK line
				set line [string map { "PARAMETERS" "" " " ""} $line]
				#si el fichero prm no existe, se le asocia uno por defecto
				if {[file exists $line] && [file exists [file rootname $line].bdy]} {
					set config(prmCargado) $line
				} else {
					set config(prmCargado) "$config(dirCHM)/MM3BrandyMol.prm"
					tk_messageBox -type ok -message "El fichero $line o su correspondiente .prm no se encuentra o es ilegible, se ha cargado \
													 MM3BrandyMol.prm por defecto.\nPor favor edite su fichero Tinker.key"
				}
				
				Fich::calculaProcsConvPRM $base
				close $fTINK
				
				return 1
			}
		} else {
			tk_messageBox -type ok -title "Error Critico!" -icon error -message "Error : No encontrado el fichero conf.ini" 
			return -1
		}

	}; #finproc
	
	proc compruebaRegistroWindows { base } {
		upvar #0 Conf::$base config
		
		set res ""
		
		#isis draw y chime
		catch {registry keys {HKEY_LOCAL_MACHINE\SOFTWARE\MDL Information Systems, Inc.}} mdl
		set mdl [join $mdl]
		if { ![string match "*ISIS*" $mdl] } {
			append res "Instale ISIS/DRAW \n (Gratis, www.mdli.com)\n"
		} else {
			catch {registry get {HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\idraw32.exe} {}} config(idraw)
		}
		if { ![string match "*MDL Chime/Chime Pro for Internet Explorer*" $mdl] } {
			append res "ATENCION Instale Chime Plugin \n (Gratis, www.mdli.com)\n"
		}
		
		if {$res != ""} {
			tk_messageBox -icon warning -title "Instalacion de componentes" -message "$res"
			return -1
		} else {
			return 1
		}
	}; #finproc
	
	proc compruebaIntegridadFicherosBrandy { base } {
		upvar #0 Conf::$base conf
		set texto ""
		if {![file exists "$conf(dirBin)inchi.exe"]} 		{append texto "$conf(dirBin)inchi.exe\n" }
		if {![file exists "$conf(dirBin)analyze.exe"]} 		{append texto "$conf(dirBin)inchi.analyze\n" }
		if {![file exists "$conf(dirBin)minimize.exe"]} 	{append texto "$conf(dirBin)minimize.exe\n" }
		if {![file exists "$conf(dirBin)mopacesp.exe"]} 	{append texto "$conf(dirBin)mopacesp.exe\n" }
		if {![file exists "$conf(dirBin)newton.exe"]} 		{append texto "$conf(dirBin)newton.exe\n" }
		if {![file exists "$conf(dirBin)optimize.exe"]} 	{append texto "$conf(dirBin)optimize.exe\n" }
		if {![file exists "$conf(dirBin)path.exe"]} 		{append texto "$conf(dirBin)path.exe\n" }
		if {![file exists "$conf(dirBin)PLOBRAN.exe"]} 		{append texto "$conf(dirBin)PLOBRAN.exe\n" }
		if {![file exists "$conf(dirBin)saddle.exe"]}		{append texto "$conf(dirBin)saddle.exe\n" }
		if {![file exists "$conf(dirBin)scan.exe"]} 		{append texto "$conf(dirBin)scan.exe\n" }
		if {![file exists "$conf(dirBin)scanocvm.exe"]} 	{append texto "$conf(dirBin)scanocvm.exe\n" }
		if {![file exists "$conf(dirBin)spacefill.exe"]}	{append texto "$conf(dirBin)spacefill.exe\n" }
		if {![file exists "$conf(dirBin)superpose.exe"]} 	{append texto "$conf(dirBin)superpose.exe\n" }
		if {![file exists "$conf(dirBin)vibrate.exe"]} 		{append texto "$conf(dirBin)vibrate.exe\n" }
		if {![file exists "$conf(dirBin)brandy.ico"]} 		{append texto "$conf(dirBin)brandy.ico\n" }
		if {![file exists "$conf(dirBin)conf.ini"]} 		{append texto "$conf(dirBin)conf.ini\n" }
		if {![file exists "$conf(dirBin)colors.ini"]} 		{append texto "$conf(dirBin)colors.ini\n" }
		if {![file exists "$conf(dirCHM)TINKER.key"]} 		{append texto "$conf(dirCHM)TINKER.key\n" }
		if {![file exists "$conf(dirCHM)vibration.htm"]} 	{append texto "$conf(dirCHM)vibration.htm\n" }
		if {![file exists "$conf(dirCHM)carga.htm"]} 		{append texto "$conf(dirCHM)carga.htm\n" }
		
		
		if {$texto != ""} {
			tk_messageBox -icon error -title "Error Critico" -message "Los siguientes ficheros no se encuentran y son necesarios para Brandy Mol.\n \
																	  La edicion de conf.ini o la reinstalacion podrian solucionar el problema\n$texto"
			return -1
		} else {
			return 1
		}
	}; #finproc
	
	#obsoleto
	#salva a un fichero la config actual
	proc crearFichConf { base file } {
		upvar Conf::$base config
		
		set fRes [open $file w+]
		
		puts $fRes "Directorios"
		#directorio ppal
		puts $fRes $config(dirPpal)
		#directorio de trabajo
		puts $fRes $config(dirCHM)
		#directorio ppal
		puts $fRes $config(dirTemp)
		#directorio de ejecutables
		puts $fRes $config(dirBin)
		#directorio de datos
		puts $fRes $config(dirDataOrig)
		#obtengo el color de fondo
		puts $fRes $config(colorFondo)
		#obtengo el color de las etiquetas
		puts $fRes $config(colorEtq)
		
		foreach elem "Ce B Pr C Yb Ir Ra Rb Br Pt F Re Cl H I Co Rh K La Sb Cr Cs N Sc O Rn P Cu Se S Si U Ta\
					  Li Kr Tb V W Tc Ru Sm Zn Te Sn Y Fe Mg Zr Th Sr Ti Dy Na Er Nb Ga Tl Tm Lu Nd Eu Mn Ne\
					  Gd Mo Ge Ni Fr Ac He Hf Hg Ag Pa Pb Ba Pd Al Be Ho Os Ar Bi As Ca Xe Pm At Au Cd In Po" {
			puts $fRes "$elem\t$config(colorSimb,$elem)"	
		}
		close $fRes
	}; #finproc
	
	#salva a un fichero la config segun el directorio de datos y los colores suministrados, el resto los toma del base actual
	proc crearFichConf { base fileD fileC dirData colorFondo colorEtq elems colors escalaCPK consola } {
		upvar #0 Conf::$base config
		
		file rename -force "$fileD" "$fileD.save"
		file rename -force "$fileC" "$fileC.save"
		
		set fRes [open $fileD w+]
		
		puts $fRes "\[Directorios\]"
		#directorio ppal
		puts $fRes "<DIR_PPAL>=$config(dirPpal)"
		#directorio de trabajo
		puts $fRes "<DIR_CHM>=$config(dirCHM)"
		#directorio temporal
		puts $fRes "<DIR_TEMP>=$config(dirTemp)"
		#directorio de ejecutables
		puts $fRes "<DIR_BIN>=$config(dirBin)"
		#directorio de datos
		puts $fRes "<DIR_DATA>=$dirData"
		
		puts $fRes "\[Preferencias\]"
		puts $fRes "<ESCALA>=$escalaCPK"
		puts $fRes "<CONSOLE>=$consola"
		
		close $fRes
		
		#colores
		set fRes [open $fileC w+]
		
		#obtengo el color de fondo
		puts $fRes $colorFondo
		#obtengo el color de las etiquetas
		puts $fRes $colorEtq
		
		#los colores de los elementos
		for {set x 0} {$x < [llength $elems]} {incr x} {
			puts $fRes "[lindex $elems $x]\t[lindex $colors $x]"	
		}
		close $fRes
		
	}; #finproc

}; #finamespace