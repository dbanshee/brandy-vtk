########################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#									- MODULO PARA EL MANEJO DE TINKER -
#    	   						   		   --------------------
#	Manejo de las aplicaciones Tinker, interfaz hacia ellas y control de procesos
#
#
#	Definido dentro del
#			namespace eval Tinker
#
#
#	base(): array que representara la instancia de Tinker
#
#			base(conf)				--> nombre de la baseConf asociada
#
#			base(mainframe)			--> ventana ppal del tinker

#			base(prog)				--> programa seleccionado para ejecutar
#			base(fichKey) 			--> dir absoluta del fichero tinker.key
#			base(fichPRM) 			--> dir absoluta del fichero .prm con q esta construido el fichero xyz suministrado
#			base(fichMol) 			--> dir absoluta del fichero .mol
#			base(fichXYZ) 			--> dir absoluta del fichero .xyz
		
#			para el programa
#			base(prog) Newton		--> opcion elegida mediante el ComboBox : Newton, Minimizar, Optimizar o Analisis
#			base(rms) 0.0001		--> rms elegido
#			base(xyz) N				--> estado de la checkbutton xyz, elige si mostrar el .mol o el .xyz : Y/N
#			base(batch) N			--> estado de la checkbutton batch : Y/N
			
#			para el metodo
#			base(estadoMetodo)  	--> estado de los botones de metodo, normal o disabled
#			base(metodo) RHF		--> opcion elegida mediante el ComboBox : Auto, Newton, TNCG, DTNCG
#			base(precond) 			--> opcion elegida mediante el ComboBox : Auto Diagonal Bloques SSQR ICCG Ninguno
			 
#			para el analisis
#			base(estadoAnalisis)	--> estado de los botones de metodo, normal o disabled
#			base(analisis) 			--> opcion elegida mediante radiobuttons : Energia, Propiedades Electrostaticas
#											Interacciones Individuales, Campo de Fuerza, Volumen de VdW, Area Accesible
#			base(hidrogenos) N		--> estado de la checkbutton hidrogenos
#
#			#para la Busqueda Conformacional
#			base(tipoBC)		--> tipo de la Busqueda Conformacional 0: scan, 1: scanocvm
#			base(seleccion)		--> estado de lo option button Automatico, Manual
#			base(rms2)			--> rms elegido
#			base(direc)			--> direcc elegido
#			base(tresh)			--> direcc elegido
#			base(textoE)		--> Enlaces Seleccionados

#		 	#para las vibraciones 
#			base(semillaVib)
#			base(listaVib)			--> lista de ternas "nºvibracion --> frecuencia", leidas del log de vibraciones
#			base(vibSeleccionada) 	--> elemento de la lista listaVib seleccionado mediante el combo
#			base(escalaAnt) 		--> contiene el ultimo valor de la escala del canvas
#			base(lineaCanvasSeleccionada) --> linea del canvas actualmente seleccionada
#
#			#para el estado de transicion y trayectoria de reaccion
#			base(rms3)				--> rms seleccionado
#			base(estructuras)		--> estructuras seleccionadas
#			base(seleccionETTR)		--> estado de la seleccion : ET o TR
#			base(transicionPrev)	--> estado transicion previo : Y / N

#		
#			#para la superposicion
#			base(comboFicherosBaseSuper)--> nombredel combo de superpose
#			base(ficheroBaseSuper)		--> fichero base del superpose
#			base(directorioTrabSuper)	--> direcotrio de trabajado del superpose
#			base(textoWSuper)			--> nombre del Widget con los enlaces seleccionados

#			#ficheros adicionales para usos varios
#			base(fichero1Mol)			--> nombre del 1º fichero Mol
#			base(fichero2Mol)			--> nombre del 2º fichero Mol
#			base(fichero3Mol)			--> nombre del 3º fichero Mol
#			base(fichero1XYZ)			--> nombre del 1º fichero XYZ
#			base(fichero2XYZ)			--> nombre del 2º fichero XYZ
#			base(fichero3XYZ)			--> nombre del 3º fichero XYZ

#
#
############################################################################################################################
package require optcl

namespace eval Tinker {
	
	#genera una instancia de tinker, con una interfaz q varia segun el tipo
	# existen 3 tipos de interfaces
	#		tipo 0 --> Modelizacion Tinker
	#		tipo 1 --> Busqueda Conformacional TNCG
	#		tipo 2 --> Busqueda Conformacional OCVM
	#		tipo 3 --> Calcula Vibraciones
	#		tipo 4 --> Mostrar Vibraciones
	#		tipo 5 --> Estado Transicion y Trayectoria de transicion
	#		tipo 6 --> Superponer
	proc newTinker { base baseData baseConf fichMOL baseGui tipo } {
		upvar #0 Conf::$baseConf config
		upvar #0 GUI::$baseGui gui
	
		if {[info exists Tinker::$base] == 0} {
			
			GUI::activaDesactivaSemaforo $baseGui 1 "Tinker en curso..."
			variable $base
			set ${base}(conf) $baseConf
			set ${base}(gui) $baseGui
			
			#para controlar el nombre del calculo
			set ${base}(nombreCalculo) ""
			
			
			set ${base}(cancelaProceso) 0
			#set ${base}(progBar) $gui(varProgressBar)
			
			set ${base}(baseData) $baseData
			set ${base}(fichKey) "$config(dirCHM)/tinker.key"
			#set ${base}(fichPRM) $config(prmCargado)
			set ${base}(fichMol) $fichMOL
			set ${base}(fichXYZ) ""
			
			
			set ${base}(mainframe) ""
			
			#set ${base}(fichKey) [open "$config(dirCHM)/tinker.key r]"
			#set fichero [open "$chmdir/tinker.key" r]
		
			#nombre del ejecutable q esta ejecutandose
			set ${base}(progEjec) "ninguno"
		
			#para el programa
			set ${base}(prog) Newton
			set ${base}(rms) 0.0001
			set ${base}(xyz) N
			set ${base}(batch) N
			
			#para el metodo
			set ${base}(estadoMetodo) normal
			set ${base}(metodo) RHF
			set ${base}(precond) Auto
			 
			#para el analisis
			set ${base}(estadoAnalisis) disabled
			set ${base}(analisis) 0
			set ${base}(hidrogenos) N
			
			#para la Busqueda Conformacional
			set ${base}(tipoBC) 0
			set ${base}(seleccion) 0
			set ${base}(rms2) 0.01
			set ${base}(direc) 10
			set ${base}(tresh) 50
			
			set ${base}(textoE) ""

			#Vibraciones
			set ${base}(semillaVib) 0
			set ${base}(vibSeleccionada) ""
			set ${base}(listaVib) [list]
			set ${base}(escalaAnt) 1
			set ${base}(lineaCanvasSeleccionada) 0
			set ${base}(mismaVentana) Y
			
			
			#Estado de Transicion y trayectoria de reaccion
			set tink(ncalcETTR) ""
			set tink(butokETTR) ""
			set ${base}(rms3) 0.1
			set ${base}(estructuras) 10
			set ${base}(seleccionETTR) ET	
			set ${base}(transicionPrev) N	
			set ${base}(fichero1Mol) "Primer Fichero"
			set ${base}(fichero2Mol) "Segundo Fichero"
			set ${base}(fichero3Mol) "Estado de Transicion Previo"
			set ${base}(fichero1XYZ) ""
			set ${base}(fichero2XYZ) ""
			set ${base}(fichero3XYZ) ""
			
			#superposicion
			set tink(ncalcSUPER) ""
			set tink(butokSUPER) ""
			set ${base}(comboFicherosBaseSuper) ""
			set ${base}(listaFicherosTrabSuper) [list]
			set ${base}(listaComboFicherosTrabSuper) [list]
			set tink(textoWSuper) ""
			set ${base}(entryFicherosTrabSuper) "Elija Ficheros para la Superposicion"
			
			
			#guardarTinkerKey Tinker::guardarTinkerKey $base $textokey $texto $tink(conf)"
			comprobarPRM $base
			#controlo q el fichero exista
			if {[file exists $fichMOL]} {
				set fileDir "[file dirname $fichMOL]/Almacen/[string map {".mol" ""} [file tail $fichMOL]]"
				file mkdir $fileDir
				puts "Fich::MOLtoXYZ $fichMOL $baseData $baseConf"
				set fxyz [Fich::MOLtoXYZ $fichMOL $baseData $baseConf]
				file rename -force $fxyz "$fileDir/[file tail $fxyz]"
				set ${base}(fichXYZ) "$fileDir/[file tail $fxyz]"
			}

			switch $tipo {
				1 { set ${base}(tipoBC) 1; ventanaBusquedaConformacional $base "Busqueda Conformacional (Newton)" }
				2 { set ${base}(tipoBC) 2; ventanaBusquedaConformacional $base "Busqueda Conformacional (Optimizar)" }
				3 { if {[file exists $fichMOL]} {
						#si ya existen vibraciones aviso de q se van a maxacar
						set calc 1
						if {[file exists "[file dirname $fichMOL]/Almacen/[string map {".mol" ""} [file tail $fichMOL]]/Tinker/VIBRATE/[lindex [file split [file rootname $fichMOL]] end]-vib.log" ]&& 
						   ![tk_messageBox -type yesno -message "Ya existen vibraciones para el fichero \"$fichMOL\".\nSi continua se borraran, ¿Esta seguro de que desea continuar?"]} {
							set calc 0
						}
						if {$calc == 1} {
							set ${base}(prog) Vibrate
							set f1 [string map {".mol" ""} [file tail $fichMOL]]
							set ${base}(nombreCalculo) "$f1"
							manejadorEjecutar $base
						} else { delTinker $base }
					} else {
						tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
						-message "No se pueden calcular las vibraciones de \"$fichMOL\" compruebe que el fichero existe"
						#unset $base ; set gui(semaforoProceso) 0
						delTinker $base
					}
				}
				4 { if {[file exists $fichMOL] && 
						[file exists "[file dirname $fichMOL]/Almacen/[string map {".mol" ""} [file tail $fichMOL]]/Tinker/VIBRATE/[lindex [file split [file rootname $fichMOL]] end]-vib.log"]} {
						set listaVib [devuelveVibraciones $base]
						set ${base}(listaVib) $listaVib
						if {$listaVib == 1} {
							tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
							-message "Las vibraciones para el fichero \"$fichMOL\" no son correctas, revise su fichero log"
							#unset $base ; set gui(semaforoProceso) 0
							delTinker $base
							return -1
						} else {
							ventanaVibraciones $base
						}
					} else {
						tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
						-message "Por favor calcule las vibraciones para el fichero \"$fichMOL\" antes de visualizarlas"
						#unset $base ; set gui(semaforoProceso) 0
						delTinker $base
						return -1
					}
				}
				5 { ventanaETTR $base }
				6 { ventanaSuperponer $base }
				default { ventanaModelizarTinker $base }
			}
		} else {
			puts "La variable $base ya existe"
			return -1
		}
	}; #finproc

	proc delTinker { base } {
		upvar #0 Tinker::$base tink
		
		if {[array exists tink]} { 
			catch { GUI::activaDesactivaSemaforo $tink(gui) 0 "Listo"}
			unset tink 
		}
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#							-	PROCEDIMIENTOS TINKER ESPECIFICOS   -
#----------------------------------------------------------------------------------------------		
	
	proc ventanaModelizarTinker { base } {	
		upvar #0 Tinker::$base tink
		
		set tink(prog) "Newton"

		#creo la ventana
		toplevel .tinkerq
		set tink(mainframe) ".tinkerq"
		wm title .tinkerq "Modelización con TINKER"
		
		
		#frame superior
		#frame superior
		set frameupsup [frame .tinkerq.frameup]
		set label [Label $frameupsup.label -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		set label2 [Label $frameupsup.label2 -activebackground #a0a0a0 -text "Tinker Tools" -font {Arial 12 {bold italic}} -relief flat -anchor center]
		
		#pack $label -side right
		pack $label2 -side left
		
		
		set frameup2 [frame .tinkerq.frameup2]
		set ncalc [ LabelEntry $frameup2.calculo -label "Nombre del Calculo Tinker : " -textvariable "Tinker::${base}(nombreCalculo)" -side left -width 40 -labelfont {Arial 9 {bold roman}}]	
		pack $ncalc -side left -padx 5
		
		
		#creo un TabPanel
		set notebook [NoteBook .tinkerq.nb] 
		$notebook insert 0 model -text "Modelizar"
		$notebook insert 1 key -text "KEY"
		
		#creo la ventana modelizar
		set modeli [$notebook getframe model]
		#LA VENTANA MODELIZAR TIENE TRES FRAMES QUE CORRESPONDEN CON 
		#EL PROGRAMA A UTILIZAR
		#EL METODO
		#EL PRECONDICIONAMIENTO
		#TODO DETRO DE UNA GFRAME GENERAL
		#CREO LA FRAME GENERAL
		set frameupcom [frame $modeli.frameup -bd 1 -relief raised]
		
		#INTRODUZCO EL TEXTO
		set texto [text $frameupcom.text -borderwidth 2 -font {Terminal 9 } -relief raised -yscrollcommand "$frameupcom.textscroll set"]
		set scroll [scrollbar $frameupcom.textscroll -command "$frameupcom.text yview"]
		
		set frameupup [frame $frameupcom.frameupup -bd 1 -relief raised]
		#CREO LA FRAME DE PROGRAMA AQUI INCLUYO PROGRAMA Y RMS Y VARIAR XYZ
		set frameup [frame $frameupup.frameup  -bd 1 -relief raised]
		set programal [ LabelFrame $frameup.programal -text {Modelizar} -side left ]
		set modelib [ComboBox $frameup.model -textvariable Tinker::${base}(prog) -values [list Newton Minimizar Optimizar Analizar] -width 15 -hottrack 1]
		$modelib setvalue first
		set rmsl [ LabelEntry $frameup.rms -label {RMS:} -textvariable Tinker::${base}(rms) -side left ]
		set xyz [checkbutton $frameup.xyz -offvalue N -onvalue Y -text "XYZ" -variable Tinker::${base}(xyz) -command "Tinker::cambiaMolXYZTextW $base $texto"]
		set batch [checkbutton $frameup.batch -offvalue N -onvalue Y -text "Batch" -variable Tinker::${base}(batch)]
		pack $programal $modelib $rmsl $xyz $batch -anchor nw -expand 0 -fill none -ipadx 1 -ipady 1 -padx 0 -pady 0 -side left
		#$modelib setvalue first

		#CREO LA FRAME DE METODO
		set metodo [frame $frameupup.metodo -bd 1 -relief raised]
		set metodol [ LabelFrame $metodo.metodol -text {Metodo} -side left ]
		
		set auto [ radiobutton $metodo.auto -text Auto -variable Tinker::${base}(metodo) -anchor nw -value Auto -state $tink(estadoMetodo)]		
		set newt [ radiobutton $metodo.newton -text Newton -variable Tinker::${base}(metodo) -anchor nw -value Newton -state $tink(estadoMetodo)]
		$auto select
		set tncg [ radiobutton $metodo.tncg -text TNCG -variable Tinker::${base}(metodo) -anchor nw -value TNCG -state $tink(estadoMetodo)]
		set dtncg [ radiobutton $metodo.dtncg -text DTNCG -variable Tinker::${base}(metodo) -anchor nw -value DTNCG -state $tink(estadoMetodo)]
		
		set ima1 [Label $metodo.ima -activebackground #a0a0a0 -helptext "Newton" -image $Icon::metanoicon -anchor center -relief flat -height 16 -width 16]
		pack $ima1 $metodol $auto $newt $tncg $dtncg -anchor nw -expand 0 -fill none -ipadx 1 -ipady 1 -padx 0 -pady 0 -side left
		set framepre $metodo
		set precondl [ LabelFrame $framepre.prrecondl -text {Precondicionamiento} -side left ]
		set precon [ComboBox $framepre.precon -textvariable Tinker::${base}(precond) -values [list Auto Diagonal Bloques SSQR ICCG Ninguno ] -width 15 -state $tink(estadoMetodo) -hottrack 1]
		
		pack $precondl $precon -anchor center -expand 0 -fill none -ipadx 1 -ipady 1 -padx 0 -pady 0 -side left
		
		#CREO LA FRAME DE ANALISIS
		set frameupb [frame $frameupup.frameupb -bd 1 -relief raised]		
		set alfa [radiobutton $frameupb.energia -text "Energía " -value E -variable Tinker::${base}(analisis) -state $tink(estadoAnalisis)]
		$alfa select
		set propelec [radiobutton $frameupb.propelec -text "Propiedades Electrostáticas" -value M -variable Tinker::${base}(analisis) -state $tink(estadoAnalisis)]
		set interindi [radiobutton $frameupb.interindi -text "Interacciones Individuales" -value D -variable Tinker::${base}(analisis) -state $tink(estadoAnalisis)]
		set ff [radiobutton $frameupb.ff -text "Campo de Fuerza" -value P -variable Tinker::${base}(analisis) -state $tink(estadoAnalisis)]
		set ima2 [Label $frameupb.ima -activebackground #a0a0a0 -helptext "Newton" -image $Icon::analicon -relief flat -anchor center -height 16 -width 16 -state $tink(estadoAnalisis)]
		pack $ima2 $alfa $propelec $interindi $ff -in $frameupb -anchor center -expand 0 -fill x -ipadx 1 -ipady 1 -padx 0 -pady 0 -side left
		

		#EN LA FRAME MID ESTAN LOS BOTONES DE VOLUMEN
		set framemid [frame $frameupup.framemid -bd 1 -relief raised]		
		set vdw [radiobutton $framemid.vdw -text "Volumen de Van der Waals" -value 1 -variable Tinker::${base}(analisis) -state $tink(estadoAnalisis)]
		set areavol [radiobutton $framemid.areavol -text "Área Accesible y Volumen Excluido" -value 2 -variable Tinker::${base}(analisis) -state $tink(estadoAnalisis)]
		set hidrogenos [checkbutton $framemid.hidrogenos -offvalue N -onvalue Y -text "Con Hidrógenos" -variable Tinker::${base}(hidrogenos) -state $tink(estadoAnalisis)]
		set ima3 [Label $framemid.ima -activebackground #a0a0a0 -helptext "Newton" -image $Icon::volumeicon -relief flat -anchor center -height 16 -width 16  -state $tink(estadoAnalisis)]
		pack $ima3 $vdw $areavol $hidrogenos -in $framemid -anchor center -expand 0 -fill x -ipadx 1 -ipady 1 -padx 0 -pady 0 -side left
		
		#empaqueto
		pack $frameup $metodo $frameupb $framemid -anchor nw -expand 1 -fill x -ipadx 1 -ipady 1 -padx 0 -pady 0 -side top
		pack $frameupup -fill both
		#EMPAQURETO LA VENTANA DE TEXTO
		pack $scroll -fill y -side right -expand no
		pack $texto -fill both -expand yes -side left
		
		
		
		pack $frameupcom -anchor nw -expand 0 -fill both -ipadx 1 -ipady 1 -padx 0 -pady 0 -side top -expand yes
		
		
		#--------------------------------------------- Creo la pestaña de Key -------------------------------------------------
		set key [$notebook getframe key]
		set textokey [text $key.text -borderwidth 2 -font {Terminal 9 } -relief raised -yscrollcommand "$key.textscroll set"]
		set scrollkey [scrollbar $key.textscroll -command "$key.text yview"]
		
		set frameup [frame $key.frameup -bd 1 -relief raised]
		
		#CREO EL BOTON DE GUARDAR EL KEY
		#set guardo [Button $frameup.guardar -activebackground #a0a0a0 -command "guardokey $textokey" -helptext "Guarda el Fichero TINKER.key" -image $Icon::guardaricon]
		set guardo [Button $frameup.guardar -activebackground #a0a0a0 -command "Tinker::guardarTinkerKey $base $textokey $texto" -helptext "Guarda el Fichero TINKER.key" -image $Icon::guardaricon]
		#CREO EL BOTON DEL MENU DE INSERTAR
		set insert [menubutton $frameup.in -activebackground #a0a0a0 -menu $frameup.in.m -text "Insertar" -relief raised -image $Icon::restrainicon]
		#DEFINO EL MENU DEL BOTON INSERTAR
		set menuinsert [menu $frameup.in.m -tearoff 0]
		#$menuinsert add command  -command "$textokey insert 0.0 {PARAMETERS $chmdir/MM3BRANDYMOL.PRM \n}" -label "Parámetros" -underline 0
		$menuinsert add command  -command "Tinker::modificaPRMFichKey $base $textokey $texto" -label "Parámetros" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {PISYSTEM   Escriba la lista de atomos PI \n}" -label "Sistema Pi" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {RESTRAIN-DISTANCE  Escriba la lista de atomos \n}" -label "Fijar Distancia" -underline 0
		$menuinsert add command  -command "$textokey insert end {RESTRAIN-ANGLE  Escriba la lista de atomos \n}" -label "Fijar Ángulo" -underline 0
		$menuinsert add command  -command "$textokey insert end {RESTRAIN-TORSION  Escriba la lista de atomos \n}" -label "Fijar Torsión" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {DIELECTRIC Escriba la constante dieléctrica (0.1 a 79)\n}" -label "Constante Dieléctrica" -underline 0
		$menuinsert add command  -command "$textokey insert end {MAXITER Escriba el máximo número de iteraciones \n}" -label "Iteraciones Máximas" -underline 0
		$menuinsert add separator 
		$menuinsert add command  -command "$textokey insert end {SADDLEPOINT \n}" -label "Estado de Transición" -underline 0
		$menuinsert add command  -command "$textokey insert end {REDUCE Escriba un valor entre 0 y 1 (aprox. 0.3) \n}" -label "Reduce" -underline 0
		$menuinsert add command  -command "$textokey insert end {ENFORCE-CHIRALITY \n}" -label "Forzar quiralidad" -underline 0
		#CREO EL BOTON DEL MENU RESTRINGIR
		set ima4 [Label $frameup.ima -activebackground #a0a0a0 -image $Icon::llaveicon -anchor center ]
		
		pack $frameup -anchor center -expand 0 -fill x -ipadx 1 -ipady 1 -padx 0 -pady 0 -side top
		pack $guardo $insert -in $frameup -anchor s -pady 4 -side left
		pack $ima4 -in $frameup -anchor s -pady 4 -side right
		pack $scrollkey -fill y -side right -expand no
		pack $textokey -fill both -expand yes -side left
		
		pack $frameupsup -fill x -side top
		pack $frameup2 -fill x -side top -pady 3
		pack $notebook -in .tinkerq -anchor n -expand 1 -fill both -ipadx 1 -ipady 1 -padx 0 -pady 0 -side top
		$notebook raise model
		
		frame .tinkerq.butonframe -borderwidth 3 -bd 2 -relief raised
		set butonayu [Button .tinkerq.butonframe.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon -text "Ayuda"]
		set butonejec [Button .tinkerq.butonframe.ok -activebackground #a0a0a0 -command "Tinker::manejadorEjecutarModelizar $base" -helptext "Ejecutar" -image $Icon::okicon]
		set butoncanc [Button .tinkerq.butonframe.cancel -activebackground #a0a0a0 -command "Tinker::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon -anchor center]
		
		pack $butonejec $butonayu $butoncanc  -side right
		pack .tinkerq.butonframe -anchor center -fill x -expand 1 -ipadx 0 -ipady 0 -pady 3 -side left 
		#asocio al combobox del metodo, la capacidad de desactivar otros botones, llamara a una funcion,
		#con 2 listas de botones, la 1º de los botones de modelar, y la 2º de analizar
		set l1 [list [list $ima1 $auto $newt $tncg $dtncg $precon]]
		set l2 [list [list $ima2 $ima3 $alfa $propelec $interindi $ff $vdw $areavol $hidrogenos]]
		$modelib configure -modifycmd "Tinker::estadoBotonesMT $base $l1 $l2"
		set l3 [list [list $modelib $rmsl $xyz $butonejec]]
		$batch configure -command "Tinker::estadoBotonesMT2 $base $l3"
		
		
		
		#cargo los textWidgets
		#cargo el tinker.key
		
		#si le han pasado un mol, lo cargo y calculo su xyz
		if {[file exists $tink(fichMol)]} {
			Tinker::cargarFichTextoW $tink(fichMol) $texto
			#set tink(fichXYZ) [Fich::MOLtoXYZ $tink(fichMol) $tink(baseData) $tink(conf)]
			recomiendaNombreTinker $base
		} else {
			#de lo contrario no los cargo y le capo la mayoria de opciones
			$butonejec configure -state disabled
			$modelib configure -state disabled
			$rmsl configure -state disabled
			$xyz configure -state disabled
			#$batch configure -state disabled
			$precondl  configure -state disabled
			foreach elem [lindex $l1 0] { $elem configure -state disabled }
			$ncalc configure -state disabled
		}
		#establzco un manejador para cuando termine el proceso de tinker, este avisara a la gui de q ha terminado
		#y ha depositado en gui(resultadoTink) el resultado
		#capturo cuando se elimina el boton de ejecutar, no por ser el boton, lo logico seria cuando se elimine
		#la ventana, pero el Destroy de .tinkerq, devuelve un evento por cada subelemento q esta contenga, por lo
		#se llama multiples veces al capturador. butonejec solo lo llama una vez pues de el no dependen subelementos
		#consultar si no hay alguna restriccion sobre el bind para no devuelva eventos de esta manera recursiuva
		bind $butonejec <Destroy> "Tinker::delTinker $base"
	
		#"Tinker::manejadorCancelar $base"
		Tinker::cargarFichTextoW $tink(fichKey) $textokey
		#focus $tink(mainframe)
		focus $butonejec
	}; #finproc
	
	proc manejadorEjecutarModelizar { base } {
		upvar #0 Tinker::$base tink
		if {$tink(batch) == "N"} {
			set calc 1
			if {[file exists "[file dirname $tink(fichMol)]/$tink(nombreCalculo).mol"] && 
			   ![tk_messageBox -type yesno -message "El calculo \"$tink(nombreCalculo)\" ya existe\nSi continua se borrara, ¿Esta seguro de que desea continuar?" -parent $tink(mainframe)]} {
				set calc 0
			}
			if {$calc == 1} { manejadorEjecutar $base } else { focus $tink(mainframe) }
		} else {
			manejadorEjecutar $base
		}
	}; #finproc
	
	proc recomiendaNombreTinker { base } {
		upvar #0 Tinker::$base tink
		#requieren fichMol
		if {[file exists $tink(fichMol)]} {
			set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
			if {$tink(mainframe) == ".tinkerq"} { 
				#tengo abierta la ventana de Modelizacion con Tinker
				switch $tink(prog) {
					Newton { set tink(nombreCalculo) "$f1-newt" }
					Minimizar {set tink(nombreCalculo) "$f1-mini"} 
					Optimizar {set tink(nombreCalculo) "$f1-opti"}
					Analizar {set tink(nombreCalculo) "$f1-anal"}
				}
			} elseif {$tink(mainframe) == ".scan"} {
				switch $tink(tipoBC) {
					1 { set tink(nombreCalculo) "$f1-scan"  }
					2 { set tink(nombreCalculo) "$f1-scancvm" }
				}
			}
		}
		
		if {$tink(mainframe) == ".ts"} {
			if {[file exists $tink(fichero1Mol)] && [file exists $tink(fichero2Mol)]} {
				set f1 [string map {".mol" ""} [file tail $tink(fichero1Mol)]]
				set f2 [string map {".mol" ""} [file tail $tink(fichero2Mol)]]
				set combi "$f1-$f2"
				switch $tink(seleccionETTR) {
					ET { set tink(nombreCalculo) "$combi-sad" }
					TR { set tink(nombreCalculo) "$combi-path" }
					TR { set tink(nombreCalculo) "$combi-path" }
				}
			} else {
				set tink(nombreCalculo) ""
			}
		}
		if {$tink(mainframe) == ".super" } {
			if {[file exists $tink(fichero1Mol)]} {
				set tink(nombreCalculo) "[string map {".mol" ""} [file tail $tink(fichero1Mol)]]-fit"
			}
		}
	}; #finproc
	
	proc ventanaBusquedaConformacional { base title } {
		upvar #0 Tinker::$base tink
		
		set tink(prog) "Scan"
		
		set tink(mainframe) ".scan"
		puts $tink(mainframe)
		toplevel .scan
		wm geometry .scan +300+300
		#wm resizable .scan 0 0
		wm title .scan $title
		
		#botones inferiores
		set framedown [frame .scan.framedown -borderwidth 3 -bd 2 -relief raised]
		set buttonEjec [Button $framedown.ok -activebackground #a0a0a0 -command "Tinker::manejadorEjecutarBC $base" -helptext "Ejecuta la Búsqueda Conformacional" -image $Icon::okicon]
		set buttonCancel [Button $framedown.cancel -activebackground #a0a0a0 -command "Tinker::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon]
		set buttonAyuda [Button $framedown.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon]
		pack $buttonEjec $buttonAyuda $buttonCancel -side right
		
		
		#set ima2 [Label $frameup.ima2 -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		
		#frame superior
		set frameup [frame .scan.frameup]
		set label [Label $frameup.label -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
		
		#nombre calculo
		set frameup2 [frame .scan.frameup2]
		set ncalc [ LabelEntry $frameup2.calculo -label "Nombre del Calculo Tinker : " -textvariable "Tinker::${base}(nombreCalculo)" -side left -width 40 -labelfont {Arial 9 {bold roman}}]	
		pack $ncalc -side left -padx 5

		
		#frame central
		#botones superiores
		set framecent [frame .scan.framecent]
		set fcizq [frame $framecent.izq -borderwidth 3 -bd 2 -relief groove]
		set fccen [frame $framecent.center -bd 2 -relief groove]
		set fcder [frame $framecent.der -bd 2 -relief groove ]
		
		
		#superiores izquierdos
		set label [Label $fcizq.lab1 -text "Selección : " -font {Arial 9 {bold roman}}]
		set auto [radiobutton $fcizq.auto -text "Automatica" -value 0 -command "Tinker::estadoBotonesBC $base" -variable Tinker::${base}(seleccion) ]
		set manu [radiobutton $fcizq.manu -text "Manual" -value 1 -command "Tinker::estadoBotonesBC $base" -variable Tinker::${base}(seleccion) ]
		pack $label -anchor w -ipadx 10 -ipady 10
		pack $auto $manu -anchor w -ipadx 10
		
		#superiores centrales
		set label2 [Label $fccen.lab2 -text "Opciones : " -font {Arial 9 {bold roman}}]
		set rmsl [ LabelEntry $fccen.rms -label "RMS:   " -textvariable Tinker::${base}(rms2) -side left -justify right]
		set direcl [ LabelEntry $fccen.direc -label "Direcc: " -textvariable Tinker::${base}(direc) -side left -justify right]
		set tresl [ LabelEntry $fccen.tres -label "Thresh:  " -textvariable Tinker::${base}(tresh) -side left -justify right]
		pack $label2 -anchor w -ipadx 10 -ipady 5
		pack $rmsl $direcl $tresl -pady 7 -padx 7
		
		#superiores derechos
		set tink(textoWE) [text $fcder.text -borderwidth 2 -font {Terminal 9 } -height 8 -relief raised -width 25]
		$tink(textoWE) delete 0.0 end
		$tink(textoWE) insert end " Introduzca los enlaces \n\t  aqui"
		#tag configure alineado -justify center
		#$tink(textoWE) tag configure center -justify center -spacing1 5m -spacing3 5m
		$tink(textoWE) configure -state disabled -background #dcdcdc -relief ridge
		
		pack $tink(textoWE) -fill both -expand 1
		
		
		pack $fcizq -side left -fill both -padx 5 -pady 3 -ipadx 10 -anchor w
		pack $fccen -side left -fill both -padx 5 -pady 3
		pack $fcder -side left -fill both -expand true  -padx 5 -pady 3
		
		
		pack $frameup -side top -fill both -pady 4
		pack $frameup2 -side top -fill both -padx 10
		pack $framedown -side bottom -fill both 
		pack $framecent -side top -fill both -expand true -pady 4
		
		#bind $tink(mainframe) <Destroy> "Tinker::delTinker $base"
		bind $tink(textoWE) <Destroy> "Tinker::delTinker $base"
		
		if {[file exists $tink(fichMol)]} {
			#set tink(fichXYZ) [Fich::MOLtoXYZ $tink(fichMol) $tink(baseData) $tink(conf)]
			recomiendaNombreTinker $base
		} else {
			#de lo contrario no los aviso y desactivo el boton de aceptar
			$buttonEjec configure -state disabled
			$ncalc configure -state disabled
			tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" -message "El fichero \"$tink(fichMol)\" no existe" -parent $tink(mainframe)
		}
		focus $tink(mainframe)
		
	}; #finproc
	
	proc manejadorEjecutarBC { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		set calc 1
		if {[file exists "$config(dirDataOrig)/SCAN/$tink(nombreCalculo)"] && 
		   ![tk_messageBox -type yesno -message "El calculo \"$tink(nombreCalculo)\" ya existe\nSi continua se borrara, ¿Esta seguro de que desea continuar?" -parent $tink(mainframe)]} {
			set calc 0
		}
		if {$calc == 1} { manejadorEjecutar $base } else { focus $tink(mainframe) }
	}; #finproc
	
	proc ordenaLogBC { fileLog } {	
		set fLog [open $fileLog r+]
		
		set lista [list]
		gets $fLog linea
		while {![eof $fLog]} {
			if {[string match "*Potential*" $linea]} {
				if {[scan $linea {%s%s%s%s%i%f} s1 s2 s3 s4 i f] == 6} {
					lappend lista "$s4 $i $f"
				}
			}
			gets $fLog linea
		}
		close $fLog
		# ordeno la lista segun el sentido creciente de la energia	
		set texto ""
		while {[llength $lista] > 0} {
			#busco el minimo
			set t [lindex $lista 0]
			set min [lindex $t 2]
			foreach e $lista {
				set val [lindex $e 2]
				if {$val < $min} { set min $val ; set t $e}
			}
			append texto "$t\n"
			set index [lsearch -exact $lista $t]
			set lista [lreplace $lista $index $index]
		}
		return $texto
	}; #finproc
	
	proc ventanaVibraciones { base } {
		upvar #0 Tinker::$base tink
		
		set tink(mainframe) ".vibrate"
		toplevel .vibrate
		wm geometry .vibrate +250+300
		#wm resizable .scan 0 0
		wm title .vibrate "Espectro Vibracional"
		
		#la ventana consta de 3 frames superior e inferior y central
		
		#frame superior
		set frameup [frame .vibrate.frameup]
		set frameupa [frame $frameup.frameupa  -borderwidth 3 -bd 2 -relief groove]
		set combo [ComboBox $frameupa.combo -values $tink(listaVib) -textvariable Tinker::${base}(vibSeleccionada) -justify center -hottrack 1]
		$combo setvalue first
		#set modelib [ComboBox $frameup.model -textvariable Tinker::${base}(prog) -values [list Newton Minimizar Optimizar Analizar] -width 15 ]
		set butonayu [Button $frameupa.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon -text "Ayuda"]
		set butonejec [Button $frameupa.ok -activebackground #a0a0a0 -command "Tinker::manejadorBotVibracion $base" -helptext "Mostrar Vibracion" -image $Icon::okicon]
		set butoncanc [Button $frameupa.cancel -activebackground #a0a0a0 -command "Tinker::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon -anchor center]
		set butonelim [Button $frameupa.elim -activebackground #a0a0a0 -command "Tinker::cerrarVibraciones $base" -helptext "Cierra Todas las Ventanas de Vibraciones" -image $Icon::trashicon -anchor center]
		
		pack $combo -side left -padx 3
		pack $butonejec $butonayu $butoncanc -side left
		pack $butonelim  -side left -fill both
		
		set ima1 [Label $frameup.ima1 -activebackground #a0a0a0 -text "Vibracion --> Frecuencia" -font {Arial 9 {bold roman}} -relief flat -anchor center]
		set ima2 [Label $frameup.ima2 -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		pack $ima1 -side left -padx 50
		pack $frameupa -side left 
		#pack $ima2 -side right
		
		#frame central
		set framecent [frame .vibrate.framecent]
		set mismavent [checkbutton $framecent.mv -offvalue N -onvalue Y -text "Todas en la misma Ventana" -variable Tinker::${base}(mismaVentana)]
		pack $mismavent
		
		#frame inferior, consta de un canvas con informacion relativa a las frecuencias calculadas
		set framedown [frame .vibrate.framedown -borderwidth 3 -bd 2 -relief groove]

		set canv $framedown.canv
		set escala [scale $framedown.scale -orient horizontal -from 1 -to 50 -width 10 -command "Tinker::fijarEscalaCanvas $base $canv" -resolution 0.01 -showvalue 0]
		$escala set 1
		
		scrollbar $framedown.hscroll -orient horiz -command "$canv xview"
		#scrollbar .vibrate.can.vscroll -command "$canv yview"	
		set canvas [canvas $canv -relief raised -scrollregion {0 0 74000 220} -width 740 -height 220 -confine 1\
			-xscrollcommand ".vibrate.framedown.hscroll set"]

		pintaCanvas $base $canvas
		
		pack $escala -fill x
		pack $canvas -fill both -expand 1
		pack $framedown.hscroll -fill x

		pack $frameup -fill x -ipady 5
		pack $framecent -fill x -ipady 2
		pack $framedown -fill both -expand 1
		
		#le asocio el destructor
		bind ".vibrate" <Destroy> "Tinker::delTinker $base"
		focus $tink(mainframe)
	}; #finproc
	
	#devuelve una lista con ternas de la forma {"nº vibracion" "--->" "frecuencia"}
	#correspondientes al fichero fichMol, del cual deben haberse calculado previamente sus vibraciones
	proc devuelveVibraciones { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Data::$tink(baseData) datos
		
		#abro el fichero log q contiene la info vibrate
		set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
		set logvib [open "[file dirname $tink(fichMol)]/Almacen/$f1/Tinker/VIBRATE/$f1-vib.log" r+]
		
		gets $logvib linea
		while {![eof $logvib] && ![string match " Vibrational Frequencies" [string range $linea 0 23]]} {
			gets $logvib linea
			puts "$linea" 
			puts "![eof $logvib]"
			puts "![string match [string range $linea 0 23] " Vibrational Frequencies"]"
		}
		
		if {[eof $logvib]} {
			#el log no contiene vibraciones 
			return -1
		} else {
			#una molecula tiene 3n vibraciones siendo n el numero de atomos
			#el log contiene 3n vibraciones repartiendo 5 por cada linea excepto la ultima q puede tener menos
			set nlineas [expr ($datos(numAtomos) * 3) / 5]
			if {[expr $datos(numAtomos) % 5] != 0} { incr nlineas }
			
			#consumo la linea vacia
			gets $logvib linea
			
			#leo las n lineas y extraigo la informacion
			set lista [list]
			set n 1
			for {set x 0} {$x < $nlineas} {incr x} {
				gets $logvib linea
				puts $linea
				for {set y 1} {$y <= 5} {incr y} {
					set frec [string range $linea [expr ($y * 5) + (($y-1) * 10)] [expr ($y * 5) + ($y * 10)]]
					if {$frec != "" } {
						lappend lista "$n --> $frec"
					}
					incr n
				}
			}
			close $logvib
			return $lista
		}
	}; #finproc
	
	proc pintaCanvas { base canvas } {
		upvar #0 Tinker::$base tink
		
		set plotFont {Helvetica 8}
		
		#creo las lineas de referencia, las frecuencias posibles considerardas estan en el rango [4000..500]
		#pintaremos una linea de referencia cada 50  unidades entre dicho rango, pero inicialmente solo haremos 
		#visbles cada 250
		
		$canvas create line 20 180 720 180 -width 1
		set l [$canvas create line 20 20 720 20 -width 1]
		
		set tink(lineaCanvasSeleccionada) $l
		
		for {set i 20} {$i <= 720} {incr i 50} {
			$canvas create line $i 180 $i 20 -width 1 -fill black -dash {,} -activefill red
			if {$i < 720} {
				for {set j 1} {$j < 5} {incr j} {
					set p [expr $i + 10 * $j]
					$canvas create line $p 180 $p 20 -width 1 -fill black -dash {,} -activefill red -tag lineasoc -state hidden
					$canvas create text $p 205 -text [string map {".0" ""} [expr 4000 - (3500*(($p - 20)/700.0))]] -anchor n -font $plotFont -tag lineasoc -state hidden
				}
			}
			$canvas create line $i 180 $i 190 -width 1
			$canvas create text $i 205 -text [string map {".0" ""} [expr 4000 - (3500*(($i - 20)/700.0))]] -anchor n -font $plotFont
			puts "$i -> [expr 4000 - (($i / 50)*250)]"
		}
		
		#ahora pinto las lineas correspondientes a las vibraciones en el lugar que le correspondan segun su valor
		foreach elem $tink(listaVib) {
			set vib [lindex $elem 0]
			set frec [lindex $elem 2]
			
			#solo pinto los mayores de 500, los imaginarios son negativos
			if {[string is double $frec] && $frec <= 4000 && $frec >= 500} {
				puts $frec
				set y 90
				set x [expr ((4000 - $frec) / 50)*10 + 20]
				set line [$canvas create line $x 20 $x $y -width 1 -fill "dark blue" -activefill green]
				puts $line
				set t [$canvas create text $x 0 -text "$frec" -anchor n -font $plotFont -state hidden]
				$canvas bind $line <ButtonRelease-1> "Tinker::mostrarVibracion $base $vib"
				$canvas bind $line <ButtonRelease-3> "Tinker::fijarLineaCanvasSeleccionada $base $canvas $line"
				$canvas bind $line <Any-Enter> "$canvas itemconfigure $t -state normal"
				$canvas bind $line <Any-Leave> "$canvas itemconfigure $t -state hidden"
			}
		}
		
	}; #finproc
	
	#fija el canvas visible segun la escala seleccionada, y lo centra segun la linea q este seleccionada
	proc fijarEscalaCanvas { base canvas escala } {
		upvar #0 Tinker::$base tink
		
		#1º restauro la escala a 1, y despues escalo por el valor deseado
		$canvas scale all 0 0 [expr 1 /$tink(escalaAnt)] 1
		$canvas scale all 0 0 $escala 1
		set tink(escalaAnt) $escala
		
		#ajusto el scroll proporcionalmente a l parte visible del canvas
		$canvas configure -scrollregion [$canvas bbox all]
		
		#si amplio por encima de un factor 10 muestro las lineas ocultas de la escala
		if {$escala > 10} { $canvas itemconfigure lineasoc -state normal
		} else { $canvas itemconfigure lineasoc -state hidden }
		
		#centro el canvas en la linea seleccionada
		set anchoBBox [expr [lindex [$canvas bbox all] 2]-[lindex [$canvas bbox all] 0]]
		set xLinea [lindex [$canvas coords $tink(lineaCanvasSeleccionada)] 0]
		set scroll [expr ($xLinea - [lindex [$canvas bbox all] 0] - 370) / $anchoBBox]
		$canvas xview moveto $scroll
	}; #finproc
	
	proc fijarLineaCanvasSeleccionada { base canvas linea } {
		upvar #0 Tinker::$base tink
		
		$canvas itemconfigure $tink(lineaCanvasSeleccionada) -fill "dark blue"
		set tink(lineaCanvasSeleccionada) $linea
		$canvas itemconfigure $linea -fill red
		set xLinea [lindex [$canvas coords $linea] 0]		
	}; #finproc
	
	#ventana estado de transicion y trayectoria de reaccion
	proc ventanaETTR { base } {
		upvar #0 Tinker::$base tink
		
		set tink(prog) "Saddle"
		
		#creo la ventana
		toplevel .ts
		set tink(mainframe) ".ts"
		wm title .ts "Estado de Transicion y Trayectoria de Reaccion"
		wm resizable .ts 0 0
		
		#la ventana consta de 3 frames superior central e inferior
		
		#frame superior
		set frameup [frame .ts.frameup ]
		set label [Label $frameup.label -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
		
		#nombre calculo
		set frameup2 [frame .ts.frameup2]
		set ncalc [ LabelEntry $frameup2.calculo -label "Nombre del Calculo Tinker : " -textvariable "Tinker::${base}(nombreCalculo)" -side left -width 40 -labelfont {Arial 9 {bold roman}} -state disabled]	
		set tink(ncalcETTR) $ncalc
		pack $ncalc -side left -padx 5 -pady 7
		
		
		#frame central
		set framecent [frame .ts.framecent]
		
		#la frame central tendra 3 frames una superior, inferior izq e inferior derecha
		set framecentup [frame $framecent.up]
		set rmsl [ LabelEntry $framecentup.rms -label {RMS:} -textvariable Tinker::${base}(rms3) -side left ]
		set estrucl [ LabelEntry $framecentup.estruc -label {Estructuras:} -textvariable Tinker::${base}(estructuras) -side left -state disabled]
		pack $rmsl $estrucl -side left -pady 5 -padx 5
		
		
		set framecentizq [frame $framecent.izq -borderwidth 3 -bd 2 -relief groove]
		set radio1 [radiobutton $framecentizq.r1 -text "Estado de Transicion" -value ET -variable Tinker::${base}(seleccionETTR)]
		set radio2 [radiobutton $framecentizq.r2 -text "Trayectoria de Reaccion" -value TR -variable Tinker::${base}(seleccionETTR)]
		set check1 [checkbutton $framecentizq.c1 -offvalue N -onvalue Y -text "Partir de un Estado de Transicion Previo" -variable Tinker::${base}(transicionPrev)]
		set lab2 [Label $framecentizq.lab2 -activebackground #a0a0a0 -text "Seleccion de Modo : " -font {Arial 9 {bold roman}} -relief flat -anchor w]
		pack $lab2 -ipady 10
		pack $radio1 $radio2 $check1 -anchor sw -pady 4
		
		set framecentder [frame $framecent.der -borderwidth 3 -bd 2 -relief groove]
		
		set fb1 [frame $framecentder.b1]
		set e1 [entry $fb1.file1 -width 30 -textvariable Tinker::${base}(fichero1Mol)]
		set b1 [Button $fb1.b1 -activebackground #a0a0a0 -command "Tinker::manejadorBotonesFicherosETTR $base Tinker::${base}(fichero1Mol)" -helptext "Escoja el Primer Fichero" -image $Icon::diricon -text "Ayuda"]
		pack $e1 $b1 -side left -fill x -pady 5
		
		set fb2 [frame $framecentder.b2]
		set e2 [entry $fb2.file2 -width 30 -textvariable Tinker::${base}(fichero2Mol)]
		set b2 [Button $fb2.b2 -activebackground #a0a0a0 -command "Tinker::manejadorBotonesFicherosETTR $base Tinker::${base}(fichero2Mol)" -helptext "Escoja el Segundo Fichero" -image $Icon::diricon -text "Ayuda"]
		pack $e2 $b2 -side left -fill x -pady 5
		pack $e2 $b2 -side left -fill x -pady 5
		
		set fb3 [frame $framecentder.b3]
		set e3 [entry $fb3.file3 -width 30 -textvariable Tinker::${base}(fichero3Mol) -state disabled]
		set b3 [Button $fb3.b3 -activebackground #a0a0a0 -command "Tinker::manejadorBotonesFicherosETTR $base Tinker::${base}(fichero3Mol)" -helptext "Escoja Estado de Transicion Previo" -image $Icon::diricon -text "Ayuda" -state disabled]
		pack $e3 $b3 -side left -fill x -pady 5
		
		set lab2 [Label $framecentder.lab2 -activebackground #a0a0a0 -text "Seleccion de Ficheros : " -font {Arial 9 {bold roman}} -relief flat -anchor w]
		pack $lab2 -ipady 5
		pack $fb1 $fb2 $fb3
		
		
		pack $framecentup 
		pack $framecentizq -side left -fill y -expand 1 -pady 15 -padx 10 -ipadx 3
		pack $framecentder -side right -fill y -expand 1 -pady 15 -padx 10 -ipadx 5
		
		#frame inferior
		set framedown [frame .ts.framedown -borderwidth 3 -bd 2 -relief raised]
		set butonayu [Button $framedown.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon -text "Ayuda"]
		set butonejec [Button $framedown.ok -activebackground #a0a0a0 -command "Tinker::manejadorEjecutarETTR $base" -helptext "Ejecutar" -image $Icon::okicon -state disabled]
		set tink(butokETTR) $butonejec
		set butoncanc [Button $framedown.cancel -activebackground #a0a0a0 -command "Tinker::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon -anchor center]
		
		pack $butonejec $butonayu $butoncanc -side right -fill x 
		
		#empaqueto las frames ppales
		pack $frameup -fill x
		pack $frameup2 -side top -fill both -padx 10
		pack $framecent -fill both -expand 1
		pack $framedown -fill x
		
		
		$radio1 configure -command "Tinker::manejadorRadioETTR $base $estrucl $check1 $e3 $b3 "
		$radio2 configure -command "Tinker::manejadorRadioETTR $base $estrucl $check1 $e3 $b3"
		$check1 configure -command "Tinker::manejadorCheckETTR $base $e3 $b3"
		
		bind $butonejec <Destroy> "Tinker::delTinker $base"
		focus $tink(mainframe)
		recomiendaNombreTinker $base
	}; #finproc
	
	proc manejadorRadioETTR { base le chk ent but } {
		upvar #0 Tinker::$base tink
		
		if {$tink(seleccionETTR) == "ET" } { 
			set tink(prog) "Saddle"
			$le configure -state disabled
			$chk configure -state normal
			manejadorCheckETTR $base $ent $but
		} else { 
			set tink(prog) "Path"
			$le configure -state normal 
			$chk configure -state disabled
			$ent configure -state disabled
			$but configure -state disabled
		}
		recomiendaNombreTinker $base
	}; #finproc
	
	proc manejadorCheckETTR { base ent but } {
		upvar #0 Tinker::$base tink
		
		if {$tink(transicionPrev) == "N" } { $ent configure -state disabled; $but configure -state disabled
		} else { $ent configure -state normal; $but configure -state normal }
	}; #finproc
	
	proc manejadorBotonesFicherosETTR { base ent } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		
		set types { {{Ficheros Mol} {.mol} } }
		set filename [tk_getOpenFile -filetypes $types -parent $tink(mainframe) -initialdir $config(dirData) -title "Abrir Fichero Mol"]
		if {$filename != ""} { set $ent $filename ; set config(dirData) [file dirname $filename]}
		recomiendaNombreTinker $base
		if {[file exists $tink(fichero1Mol)] && [file exists $tink(fichero2Mol)]} {
			$tink(ncalcETTR) configure -state normal
			$tink(butokETTR) configure -state normal
		} else {
			$tink(ncalcETTR) configure -state disabled
			$tink(butokETTR) configure -state disabled
		}
		
		
		
		focus $tink(mainframe)
	}; #finproc
	
	proc manejadorEjecutarETTR { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		if {![file exists $tink(fichero1Mol)]} {
			tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
						-message "El fichero \"$tink(fichero1Mol)\" no existe" -parent $tink(mainframe)
			destroy $tink(mainframe)
			return
		}
		if {![file exists $tink(fichero2Mol)]} {
			tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
						-message "El fichero \"$tink(fichero2Mol)\" no existe" -parent $tink(mainframe)
			destroy $tink(mainframe)
			return
		}
		if {$tink(seleccionETTR) == "ET" && $tink(transicionPrev) == "Y" && ![file exists $tink(fichero3Mol)]} {
			tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
						-message "El fichero \"$tink(fichero3Mol)\" no existe" -parent $tink(mainframe)
			destroy $tink(mainframe)
			return 
		}
		
		#cargo como datos base del tinker los correspondientes al 1º fichero, con ello me ahorro trabajo, ya q respeta el protocolo general
		#creo un data temporal q borro cuando termino el proceso
		if {$tink(seleccionETTR) == "ET"} {set carp "TS"} else { set carp "PATH"}
		set calc 1
		if {[file exists "$config(dirDataOrig)/${carp}/$tink(nombreCalculo)"] && 
		   ![tk_messageBox -type yesno -message "El calculo \"$tink(nombreCalculo)\" ya existe\nSi continua se borrara, ¿Esta seguro de que desea continuar?"]} {
			set calc 0
		}
		if {$calc == 1} {
			set tink(fichMol) $tink(fichero1Mol)
			Data::newData tempDataETTR
			Fich::leeFichMol $tink(fichMol) tempDataETTR $tink(conf)
			set fxyz [Fich::MOLtoXYZ $tink(fichMol) tempDataETTR $tink(conf)]
			set infoDir "[file dirname $tink(fichero1Mol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichero1Mol)]]"
			catch { file delete -force $infoDir } ; file mkdir $infoDir ; file rename $fxyz "$infoDir/[file tail $fxyz]"
			set tink(fichXYZ) "$infoDir/[file tail $fxyz]"
			manejadorEjecutar $base
		} else {
			focus $tink(mainframe)
		}
		
	}; #finproc
	
	proc ventanaSuperponer { base } {
		upvar #0 Tinker::$base tink
		
		set tink(prog) "Superpose"
		
		#creo la ventana
		toplevel .super
		set tink(mainframe) ".super"
		wm title .super "Superponer"
		#wm resizable .ts 0 0
		
		#la ventana consta de 3 frames superior central e inferior
		
		#frame superior
		set frameup [frame .super.frameup ]
		set label [Label $frameup.label -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		#pack $label -side right
		
		#nombre calculo
		set frameup2 [frame .super.frameup2]
		set ncalc [ LabelEntry $frameup2.calculo -label "Nombre del Calculo Tinker : " -textvariable "Tinker::${base}(nombreCalculo)" -side left -width 20 -labelfont {Arial 9 {bold roman}} -state disabled]	
		set tink(ncalcSUPER) $ncalc
		pack $ncalc -side left -padx 5 -pady 7
		
		
		#frame central
		set framecent [frame .super.framecent -borderwidth 3 -bd 2 -relief groove]
		
		set label [Label $framecent.lab -activebackground #a0a0a0 -text "Directorio de Trabajo : " -font {Arial 9 {bold roman}} -relief flat -anchor w]
		set fb1 [frame $framecent.b1]
		set e1 [entry $fb1.file1 -width 30 -textvariable Tinker::${base}(entryFicherosTrabSuper) -state disabled]
		set b1 [Button $fb1.b1 -activebackground #a0a0a0 -command "Tinker::manejadorBotonFicheroSuperponer $base" -helptext "Escoja el Primer Fichero" -image $Icon::diricon -text "Ayuda"]
		pack $e1 -side left -fill x -pady 5 -expand 1
		pack $b1 -side left
		
		set label2 [Label $framecent.lab2 -activebackground #a0a0a0 -text "Fichero Base : " -font {Arial 9 {bold roman}} -relief flat -anchor w]
		set fb2 [frame $framecent.b2]
		#set e2 [entry $fb2.file2 -width 30 -textvariable Tinker::${base}(directorioTrabSuper)]
		set combo [ComboBox $fb2.combo -width 33 -modifycmd "Tinker::actualizaComboSuperponer $base" -justify left -text "Elija Primero el Directorio de Trabajo" -expand tab -hottrack 1 -autopost 1]
		puts $combo
		set tink(comboFicherosBaseSuper) $combo
		#set b2 [Button $fb2.b2 -activebackground #a0a0a0 -command "Tinker::manejadorBotonesFicherosETTR $base Tinker::${base}(fichero1Mol)" -helptext "Escoja el Primer Fichero" -image $Icon::diricon -text "Ayuda"]
		pack $combo -side left -fill x -pady 5 -expand 1

	
		
		set tink(textoWSuper) [text $framecent.text -borderwidth 2 -font {Terminal 9 } -height 8 -relief groove -width 25]
		$tink(textoWSuper) delete 0.0 end
		$tink(textoWSuper) insert end "      Introduzca los enlaces aqui"
		
		set label3 [Label $framecent.lab3 -activebackground #a0a0a0 -text "Enlaces : " -font {Arial 9 {bold roman}} -relief flat -anchor w]
		pack $label -anchor w -padx 10 -pady 5
		pack $fb1 -padx 30 -expand true -fill x
		pack $label2 -anchor w -padx 10
		pack $fb2 -padx 30 -expand true -fill x
		pack $label3 -anchor w -padx 10
		pack $tink(textoWSuper) -fill both -expand 1 -padx 30 -pady 15
		
		
		#frame inferior
		set framedown [frame .super.framedown -borderwidth 3 -bd 2 -relief raised]
		set butonayu [Button $framedown.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon -text "Ayuda"]
		set butonejec [Button $framedown.ok -activebackground #a0a0a0 -command "Tinker::manejadorEjecutarSuperponer $base" -helptext "Ejecutar" -image $Icon::okicon -state disabled]
		set tink(butokSUPER) $butonejec
		set butoncanc [Button $framedown.cancel -activebackground #a0a0a0 -command "Tinker::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon -anchor center]
		
		pack $butonejec $butonayu $butoncanc  -side right -fill x 
		
		#empaquetado
		pack $frameup -fill x
		pack $frameup2 -fill x
		pack $framecent -fill both -expand 1 -padx 10 -pady 10
		pack $framedown -fill x
		
		bind $butonejec <Destroy> "Tinker::delTinker $base"
		focus $tink(mainframe)
	}; #finproc
	
	proc manejadorBotonFicheroSuperponer { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		set types { {{Ficheros Mol} {.mol} } }
		set filename [tk_getOpenFile -filetypes $types -multiple 1 -parent $tink(mainframe) -initialdir $config(dirData) -title "Seleccionar Ficheros Mol"]
		
		if {$filename != ""} {
			set tink(listaFicherosTrabSuper) $filename
			
			set tink(listaComboFicherosTrabSuper) [list]
			foreach f $filename {lappend tink(listaComboFicherosTrabSuper) [file tail $f]}
			#set tink(listaComboFicherosTrabSuper) $filename
			set tink(entryFicherosTrabSuper) [file dirname [lindex $filename 0]]
			$tink(comboFicherosBaseSuper) configure -values $tink(listaComboFicherosTrabSuper)
			$tink(comboFicherosBaseSuper) setvalue first
			
			$tink(ncalcSUPER) configure -state normal
			$tink(butokSUPER) configure -state normal
		}
		actualizaComboSuperponer $base
		recomiendaNombreTinker $base
		focus $tink(mainframe)
	}; #finproc
	
	proc actualizaComboSuperponer { base } {
		upvar #0 Tinker::$base tink
		
		#obtengo el indice del elemento seleccionado
		set index [$tink(comboFicherosBaseSuper) getvalue]
		if {$index != -1} {
			set tink(fichero1Mol) [lindex $tink(listaFicherosTrabSuper) $index]
		}
		recomiendaNombreTinker $base
		
	}; #finproc
	
	proc manejadorEjecutarSuperponer { base } {
		upvar #0 Tinker::$base tink
		upvar #0 GUI::$tink(gui) gui
		upvar #0 Conf::$tink(conf) config
		
		if {![file exists $tink(fichero1Mol)]} {
			tk_messageBox -type ok -icon warning -title "Fichero Mol No definido" \
						-message "El fichero \"$tink(fichero1Mol)\" no existe" -parent $tink(mainframe)
			destroy $tink(mainframe)
			return
		} else {
			set calc 1
			if {[file exists "$config(dirDataOrig)/SUPER/$tink(nombreCalculo)"] && 
				![tk_messageBox -type yesno -message "El calculo \"$tink(nombreCalculo)\" ya existe\nSi continua se borrara, ¿Esta seguro de que desea continuar?"]} {
				set calc 0
			}
			if {$calc == 1} { 
				wm withdraw $tink(mainframe)
			
				#lo considero un proceso en batch para q no muestre los logs
				set tink(batch) "Y"
				
				set tink(fichMol) $tink(fichero1Mol)
				Data::newData tempBatch
				Fich::leeFichMol $tink(fichMol) tempBatch $tink(conf)
				set infoDir "[file dirname $tink(fichMol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichMol)]]"
				catch { file delete -force $infoDir } ; file mkdir $infoDir
				set fxyz [Fich::MOLtoXYZ $tink(fichMol) tempBatch $tink(conf)]
				file rename -force $fxyz "$infoDir/[file tail $fxyz]"
				set tink(fichXYZ) "$infoDir/[file tail $fxyz]"
				
				set index [lsearch -exact $tink(listaFicherosTrabSuper) $tink(fichero1Mol)]
				set lista [lreplace $tink(listaFicherosTrabSuper) $index $index]
				#el fichero mol inicial se debe cargar tb en el visor
				set listaF [list $tink(fichMol)]
				foreach file $lista {
					puts $file
					set tink(fichero2Mol) $file
					#puts "ejecuto Tinker con : $tink(fichero1Mol)=$tink(fichMol) y $tink(fichero2Mol)"
					lappend listaF [ejecutaTinker $base]
				}
				
				set gui(resultadoTink) $listaF
				GUI::finProcesoTink $tink(gui)
				destroy $tink(mainframe)
				tk_messageBox -type ok -message "Calculo Finalizado" -title "Informacion"
				
			} else { focus $tink(mainframe) }
		}
		
	}; #finproc

#----------------------------------------------------------------------------------------------
#							-	PROCEDIMIENTOS TINKER GENERALES   -
#----------------------------------------------------------------------------------------------		

	#carga el contenido de un fichero en el widget 'texto'
	proc cargarFichTextoW { fich textWidget } {
		set fichero [open $fich r]
		set text [read $fichero]
		close $fichero
		$textWidget delete 0.0 end
		$textWidget insert end $text
	}; #finproc
	
	proc guardarTextoWFich { textWidget fich } {
		set fichero [open $fich w+]
		set texto [$textWidget get 0.0 end]
		puts $fichero $texto
		close $fichero
	}; #finproc
	
	proc cargarTextoTextoW { texto textWidget } {
		#$textWidget configure -state normal
		$textWidget delete 0.0 end
		$textWidget insert end $texto
		#$textWidget configure -state disabled
	}; #finproc
	
	#controla la activacion de widgets segun el prog activo
	proc estadoBotonesMT { base botMod botAnal } {
		upvar #0 Tinker::$base tink
		
		recomiendaNombreTinker $base
		switch $tink(prog) {
			Newton {
				foreach a $botMod { $a configure -state normal}
				foreach a $botAnal { $a configure -state disabled}
			}
			Minimizar -
			Optimizar {
				foreach a $botMod { $a configure -state disabled}
				foreach a $botAnal { $a configure -state disabled}
			}
			Analizar {
				foreach a $botMod { $a configure -state disabled}
				foreach a $botAnal { $a configure -state normal}
			}
			default {}
		}
	}; #finproc
	
	#controla la activacion de widgets segun el boton batch
	proc estadoBotonesMT2 { base botProg } {
		upvar #0 Tinker::$base tink
		
		if {$tink(batch) == "Y"} {
			foreach a $botProg { $a configure -state normal }
		} else {
			if {![file exists $tink(fichMol)]} { foreach a $botProg { $a configure -state disabled } }
		}
	}; #finproc
	
	proc estadoBotonesBC { base } {
		upvar #0 Tinker::$base tink
		if {$tink(seleccion) == 0} {
			$tink(textoWE) configure -state disabled -background #dcdcdc -relief ridge
		} else {
			$tink(textoWE) configure -state disabled -background white -relief groove
			$tink(textoWE) configure -state normal
		}
	}; #finproc
	
	proc cambiaMolXYZTextW { base textW } {
		upvar #0 Tinker::$base tink

		puts "..> $tink(fichXYZ)"
		
		if {[file exists $tink(fichMol)] == 1 && [file exists $tink(fichXYZ)] == 1} {
			if {$tink(xyz) == N} {
				cargarFichTextoW $tink(fichMol) $textW
			} else {
				cargarFichTextoW $tink(fichXYZ) $textW
			}
		} else {
			cargarTextoTextoW "" $textW
		}	
	}; #finproc
	
	#devuelvo 0 si no ha habido cambios entre la ultima vez y esta, y 1 en caso contrario
	proc comprobarPRM { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		#recalculo los procedimientos de conversion
		set fTINK [open $config(dirCHM)/TINKER.key r]
		gets $fTINK line
		set line [string map { "PARAMETERS" "" " " ""} $line]
		close $fTINK
		
		Fich::modificaPRM $tink(conf)
		if {[file exists $tink(fichMol)]} {
			return 1
		} else {
			return 0
		}
	}
	
	proc devolverTextoTinkerKeyFormateado { base } {
		upvar #0 Tinker::$base tink
		
		if {[file exists $tink(fichKey)]} {
			set fkey [open $tink(fichKey) r+]
			puts $fkey
			gets $fkey linea
			set res ""
			while {![eof $fkey]} {
				if {![string match "*PARAMETERS*" $linea] && ![string match "" $linea]} {
					append res "$linea\n"
				}
				gets $fkey linea
			}
			close $fkey
		}
		return $res
	}; #finproc
	
	proc guardarTinkerKey { base textoK textoM } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config

		Tinker::guardarTextoWFich $textoK $tink(fichKey)
		tk_messageBox -message "Tinker.key Guardado" -parent $tink(mainframe)
		
		if {[comprobarPRM $base] == 1} {
			#regenero el xyz si ha sufirdo cambios
			set fileDir "[file dirname $tink(fichMol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichMol)]]"
			file mkdir $fileDir
			set fxyz [Fich::MOLtoXYZ $tink(fichMol) $tink(baseData) $tink(conf)]
			file rename -force $fxyz "$fileDir/[file tail $fxyz]"

			if {$tink(xyz) == "Y"} {
				#puts "Tinker::cargarFichTextoW $tink(fichXYZ) $textoM"
				Tinker::cargarFichTextoW $tink(fichXYZ) $textoM
			}
		}
	}; #finproc
	
	#ejecuta la modelizacion segun las opciones q se hayan seleccionado
	#devuelve el nombre del fichero mol si se ha generado alguno, ERROR si se ha producido un error, o NOGENFICH si el calculo
	#ha sido correcto pero no se ha generado ningun fichero
	proc ejecutaTinker2 { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		set err 1
		switch $tink(prog) {
			
			Newton {
				#puts $tink(fichPRM)
				puts "newton.exe $tink(fichXYZ) $config(prmCargado) $tink(metodo) $tink(precond) $tink(rms)"
				set err [catch {exec newton.exe $tink(fichXYZ) $config(prmCargado) $tink(metodo) $tink(precond) $tink(rms) stderr} res]
				set modif "newt"
			}
			Minimizar {
				set err [catch {exec minimize.exe $tink(fichXYZ) $config(prmCargado) $tink(rms) stderr} res]
				set modif "mini"
			}
			Optimizar {
				set err [catch {exec optimize.exe $tink(fichXYZ) $config(prmCargado) $tink(rms) stderr} res]
				set modif "opti"
			}
			Analizar {
				switch $tink(analisis) {
					E -
					M -
					D -
					P {	
						#puts "analyze.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis)"
						set err [catch {exec analyze.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis) stderr} res]
					}
					1 -
					2 {
						puts "spacefill.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis) $tink(hidrogenos)"
						set err [catch {exec spacefill.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis) 1.4 $tink(hidrogenos) stderr} res]
					}
				}
			}
		}
		if {$err == 1} {
			puts "error"
			return "ERROR"
		} else {
			#muestro el log del resultado
			Log::newLog l $res 0
		
			#el calculo ha sido correcto
			if {[file exists "[file rootname $tink(fichXYZ)].xyz_2"] && ($tink(prog) == "Newton" || $tink(prog) == "Minimizar" || $tink(prog) == "Optimizar" )} {
				#renombro el nuevo fichero, como el anterior concatenandole la opcion con q se ha tinkeado
				file rename -force "[file rootname $tink(fichXYZ)].xyz_2" "[file rootname $tink(fichXYZ)]-$modif.xyz"
				
				#creo el .mol del xyz resultante y el mol original(para leer simbolos y enlaces)
				puts $tink(fichMol)
				set nuevoMOL [Fich::XYZtoMOL "[file rootname $tink(fichXYZ)]-$modif.xyz" $tink(fichMol)]
				return $nuevoMOL
			}
			return "NOGENFICH"
		}
	}; #finproc
	
	#transforma el fichero de la vibracion 'vibracion' para adaptarlo a chime, y lanza un explorer con el
	proc mostrarVibracion { base vibracion } {
		upvar #0 Tinker::$base tink
		upvar #0 Data::$tink(baseData) datos
		upvar #0 Conf::$tink(conf) config
		
		set ext [format "%03d" $vibracion]
		#set filename "[file dirname $tink(fichMol)]/VIBRATE/[lindex [file split [file rootname $tink(fichMol)]] end].$ext"
		set filename "[file dirname $tink(fichMol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichMol)]]/Tinker/VIBRATE/[lindex [file split [file rootname $tink(fichMol)]] end].$ext"
		puts $filename
		if {[file exist $filename]} {
			set beta "$config(dirTemp)vibration.vib"
			file copy -force $filename $beta
			
			#transformo el fichero para chime
			#los ficheros tienen de tinker tienen 7 frames, separadas por 1 linea
			set fich [open $filename r+]
			set alpha [open "$config(dirTemp)alpha.xyz" w+]
			for {set x 0} {$x < 7} {incr x} {
				gets $fich linea
				puts $alpha $datos(numAtomos)
				puts $alpha $x
				#copio las coordenadas
				for {set y 0} {$y < $datos(numAtomos)} {incr y} {
					gets $fich linea
					set lin [string range $linea 8 47]
					puts $alpha $lin
				}
			}
			close $fich
			close $alpha
			
			#creamos una ventana le asociamos el fichero vibration.htm, q carga el fichero alpha.xyz, y lo representa con el plugin de CHIME
			#copio a temporal el htm
			set htm "$config(dirTemp)vibration.htm"
			file copy -force "$config(dirCHM)vibration.htm" $htm

			if {$tink(mismaVentana) == "N"} { incr tink(semillaVib) }
			set win ".vibration$tink(semillaVib)"
			if {[winfo exists $win] == 1} then {
				destroy $win
			} 
			toplevel $win
			wm title $win "Vibracion nº: $vibracion de $tink(fichMol) - BrandyMol"
			set visorChime [optcl::new -window $win.visor "$config(dirTemp)vibration.htm"]
			$win.visor config -width 400 -height 400
			pack $win.visor -expand  1 -fill both -side bottom
			focus $win
		}
		
		
	}; #finproc
	
	proc cerrarVibraciones { base } {
		upvar #0 Tinker::$base tink
		
		for {set x 0} {$x <= $tink(semillaVib)} {incr x} {
			if {[winfo exists ".vibration$x"]} { destroy ".vibration$x"}
		}
	}; #finproc
	
	proc manejadorBotVibracion { base } {
		upvar #0 Tinker::$base tink
		mostrarVibracion $base [lindex $tink(vibSeleccionada) 0]
	}; #finproc
	
	#debo leer los enlaces individuales, en el programa tinker, los enlaces q se puedan rotar se introducen como: "e1 e2\n"
	#cuando se hayan introducido todos, se envia un \n adicional
	#nuestro protocolo sera leer el widget text, eliminar los posibles \n intermedios sobrantes, y añadir el \n final
	
	proc formatearTextoWEnlaces { textoW } {

		set enl [$textoW get 0.0 end]
		set enl [split $enl \n] ; #todos los \n son ahora elementos nulos en la lista enl --> {1 2} {} {3 4} {} {} {5 6}
		set lista [list]
		foreach e $enl {
			if {$e != ""} {lappend lista $e}
		}
		#ya tengo uan lista de la forma {1 2} {3 4} {5 6}
		set lista [join $lista \n]
		#append lista \n\n
		
		return $lista
	}
	
	#este proceso lanza los procesos, pero no es el quien se encarga de controlarlos.
	proc ejecutaTinker { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		upvar #0 Data::$tink(baseData) datos
		
		set modif ""
		
		#trabajare en el directorio temp, y despues copiare el resultado al directorio q me hayan dado
		#borro el directorio temporal, y lo creo vacio
		catch { file delete -force $config(dirTemp) }
		file mkdir $config(dirTemp)
		
		#copio los ficheros sobre los q voy a trabajar en el directorio temporal
		file copy -force $tink(fichMol) "$config(dirTemp)[file tail $tink(fichMol)]"
		set patron { ".xyz" "" "." "#banshee#"}
		set alpha "$config(dirTemp)[string map $patron [file tail $tink(fichXYZ)]].xyz"
		puts $alpha
		file copy -force $tink(fichXYZ) $alpha
		
		#copio el fichero Tinker.key, no es necesario pasarle el prm en la llamada de la pipe
		file copy -force $tink(fichKey) "$config(dirTemp)[file tail $tink(fichKey)]"
		
		set tink(progEjec) "ninguno"
		puts $alpha
		switch $tink(prog) {			
			Newton {
				#puts $tink(fichPRM)
				set pipe [open "|newton.exe $alpha $tink(metodo) $tink(precond) $tink(rms)"]
				set modif "newt"
				set tink(progEjec) "newton.exe"
			}
			Minimizar {
				set pipe [open "|minimize.exe $alpha $tink(rms)"]
				set modif "mini"
				set tink(progEjec) "minimize.exe"
			}
			Optimizar {
				set pipe [open "|optimize.exe $alpha $tink(rms)"]
				set modif "opti"
				set tink(progEjec) "optimize.exe"
			}
			Analizar {
				switch $tink(analisis) {
					E -
					M -
					D -
					P {	
						#puts "analyze.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis)"
						set pipe [open "|analyze.exe $alpha $tink(analisis)"]
						set modif "anal"
						set tink(progEjec) "analyze.exe"
					}
					1 -
					2 {
						#puts "spacefill.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis) $tink(hidrogenos)"
						set pipe [open "|spacefill.exe $alpha $tink(analisis) 1.4 $tink(hidrogenos)"]
						set modif "space"
						set tink(progEjec) "spacefill.exe"
					}
				}	
			}
			Scan {
				if {$tink(tipoBC) == 1} { 
					set prog "scan.exe"
					set modif "scan"
				} else {
					set prog "scanocvm.exe" 
					set modif "scancvm"
				}
				puts $modif
			
				if {$tink(seleccion) == 0} {
					#modo automatico
					set pipe [open "|$prog $alpha $tink(seleccion) $tink(direc) $tink(tresh) $tink(rms2)"]
					set tink(progEjec) $prog
				} else {
					#modo manual
					
					set lista [formatearTextoWEnlaces $tink(textoWE)]
					append lista \n\n
					#lo guardaremos en un fichero temporal llamado scan.run y se lo pasaremos como argumento en la llamada a la pipe
					set scanrun [open "$config(dirTemp)/scan.run" w+]
					puts -nonewline $scanrun $lista
					close $scanrun
				
					set pipe [open "|$prog $alpha $tink(seleccion) \< $config(dirTemp)scan.run $tink(direc) $tink(tresh) $tink(rms2)"] 
					set tink(progEjec) $prog
					#$enl $tink(direc) $tink(tresh) $tink(rms2)"]
				}
			}
			Vibrate {
				set prog "vibrate.exe"
				set modif "vib"
				
				#una molecula de n atomos, tiene 3n vibraciones.
				#vibrate.exe devuelve el numero de vibracion junto a su frecuencia
				#despues acepta los numeros de frecuencias y genera el fichero correspondiente a dicha frec
				
				#generamos el fichero scan.run q contiene 3n lineas con los numeros [1..3n] q le pasaremos
				#a la pipe para q los genere del tiron
				set scanrun [open "$config(dirTemp)/scan.run" w+]
				for {set x 1} {$x <= [expr $datos(numAtomos) * 3]} {incr x} {
					puts $scanrun $x
				}
				puts $scanrun "\n\n\n"
				close $scanrun
				puts "open |$prog $alpha \< $config(dirTemp)scan.run"
				set pipe [open "|$prog $alpha \< $config(dirTemp)scan.run"] 
				set tink(progEjec) $prog
			}
			Saddle {
				set prog "saddle.exe"
				set modif "sad"
				#el fichero1 ya lo tengo temporal, y su nombre en este contexto es alpha
								
				
				#para el calculo del estado de transicion se necesitan 2 ficheros, el inicial y el final
				#adicionalmente se puede usar un 3º como estado de transicion intermedio
				
				#copio el 2º fichero y lo transformo a xyz
				set mol2 "$config(dirTemp)[file tail $tink(fichero2Mol)]"
				file copy -force $tink(fichero2Mol) $mol2
				
				#creo los datos del 2º fichero y lo paso a xyz
				Data::newData tempDataETTR2
				Fich::leeFichMol $tink(fichero2Mol) tempDataETTR2 $tink(conf)
				set fxyz2 [Fich::MOLtoXYZ $tink(fichero2Mol) tempDataETTR2 $tink(conf)]
				set infoDir2 "[file dirname $tink(fichero2Mol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichero2Mol)]]"
				catch { file delete -force $infoDir2 } ; file mkdir $infoDir2
				file rename -force $fxyz2 "$infoDir2/[file tail $fxyz2]"
				set tink(fichero2XYZ) "$infoDir2/[file tail $fxyz2]"
				
				
				Data::delData tempDataETTR2
				set beta "$config(dirTemp)[string map $patron [file tail $tink(fichero2XYZ)]].xyz"
				file copy -force $tink(fichero2XYZ) $beta
				
				
				#saddle busca un el fichero tstate.xyz en su directorio, /bin/ como estado de transicion previo
				#y tambien lo generara alli en caso necesario
				
				#borro el cualquier rastro de tstate
				set lis [glob -nocomplain "tstate.*"]
				foreach f $lis { catch {  file delete -force $f } }
				
				#copio si fuera necesario el fichero3 a /bin como tstate.xyz
				if {$tink(transicionPrev) == "Y"} {
					#copio el 2º fichero y lo transformo a xyz
					set mol3 "$config(dirTemp)[file tail $tink(fichero3Mol)]"
					file copy -force $tink(fichero3Mol) $mol3
					
					#creo los datos del 2º fichero y lo paso a xyz
					Data::newData tempDataETTR3
					Fich::leeFichMol $tink(fichero3Mol) tempDataETTR3 $tink(conf)
					set fxyz3 [Fich::MOLtoXYZ $tink(fichero3Mol) tempDataETTR3 $tink(conf)]
					set infoDir3 "[file dirname $tink(fichero3Mol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichero3Mol)]]"
					catch { file delete -force $infoDir3 } ; file mkdir $infoDir3
					file rename -force $fxyz3 "$infoDir3/[file tail $fxyz3]"
					set tink(fichero3XYZ) "$infoDir3/[file tail $fxyz3]"
					
					Data::delData tempDataETTR3
					set delta "$config(dirTemp)[string map $patron [file tail $tink(fichero3XYZ)]].xyz"
					file copy -force $tink(fichero3XYZ) $delta
					

					#lo copio al directorio bin
					file copy -force $tink(fichero3XYZ) "tstate.xyz"
					
				}
				set pipe [open "|$prog $alpha $beta $tink(rms3) N"]
				set tink(progEjec) $prog
			}
			Path {
				set prog "path.exe"
				set modif "path"

				#para el calculo del estado de transicion se necesitan 2 ficheros, el inicial y el final
				#adicionalmente se puede usar un 3º como estado de transicion intermedio
				
				#el fichero1 ya lo tengo temporal, y su nombre en este contexto es alpha
				
				#copio el 2º fichero y lo transformo a xyz
				set mol2 "$config(dirTemp)[file tail $tink(fichero2Mol)]"
				file copy -force $tink(fichero2Mol) $mol2
				
				
				#creo los datos del 2º fichero y lo paso a xyz
				Data::newData tempDataETTR2
				Fich::leeFichMol $tink(fichero2Mol) tempDataETTR2 $tink(conf)
				set fxyz2 [Fich::MOLtoXYZ $tink(fichero2Mol) tempDataETTR2 $tink(conf)]
				set infoDir2 "[file dirname $tink(fichero2Mol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichero2Mol)]]"
				catch { file delete -force $infoDir2 } ; file mkdir $infoDir2
				file rename -force $fxyz2 "$infoDir2/[file tail $fxyz2]"
				set tink(fichero2XYZ) "$infoDir2/[file tail $fxyz2]"
				
				
				Data::delData tempDataETTR2
				set beta "$config(dirTemp)[string map $patron [file tail $tink(fichero2XYZ)]].xyz"
				file copy -force $tink(fichero2XYZ) $beta
				
				
				set pipe [open "|$prog $alpha $beta $tink(estructuras) $tink(rms3) N"]
				set tink(progEjec) $prog
			}
			Superpose {
				set prog "superpose.exe"
				set modif "fit"
				
				#para el calculo de la superposicion se necesitan 2 ficheros
				#el 1º ya lotenemos en este contexto, us nombre es alpha
				
				#copio el 2º fichero y lo transformo a xyz
				set mol2 "$config(dirTemp)[file tail $tink(fichero2Mol)]"
				file copy -force $tink(fichero2Mol) $mol2
				
				#creo los datos del 2º fichero y lo paso a xyz
				Data::newData tempDataSUPER2
				Fich::leeFichMol $tink(fichero2Mol) tempDataSUPER2 $tink(conf)
				set infoDir2 "[file dirname $tink(fichero2Mol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichero2Mol)]]"
				catch { file delete -force $infoDir2 } ; file mkdir $infoDir2
				set fxyz2 [Fich::MOLtoXYZ $tink(fichero2Mol) tempDataSUPER2 $tink(conf)]
				file rename -force $fxyz2 "$infoDir2/[file tail $fxyz2]"
				set tink(fichero2XYZ) "$infoDir2/[file tail $fxyz2]"
				Data::delData tempDataSUPER2
				
				set beta "$config(dirTemp)[string map $patron [file tail $tink(fichero2XYZ)]].xyz"
				file copy -force $tink(fichero2XYZ) $beta
				
				
				#genero el fichero scan.run con los parametros q le pasare al superpose
				set lista [formatearTextoWEnlaces $tink(textoWSuper)]
				set lista [split $lista \n]
				
				set scanrun [open "$config(dirTemp)/scan.run" w+]
				if {[llength $lista] == 0} {
					#modo por defecto, doy un \n
					puts -nonewline $scanrun \n
					puts $scanrun N
					puts $scanrun U
					puts $scanrun Y
					puts $scanrun 0.0
				} elseif {[llength $lista] == 1} {
					#modo 1, desde el atomo M al N, en tinker seria 1,M,N
					puts $scanrun "1 [lindex [lindex $lista 0] 0] [lindex [lindex $lista 0] 1]"
					puts $scanrun N
					puts $scanrun U
					puts $scanrun Y
					puts $scanrun 0.0
				} else {
					#modo 2, especificacion explicita de los atomos implicados, en tinker seria 2,i,j para cada par
					puts $scanrun "2"
					foreach enl $lista {
					puts "enl --> $enl"
						puts $scanrun "[lindex $enl 0] [lindex $enl 1]"
					}
					puts -nonewline $scanrun \n
					puts $scanrun U
					puts $scanrun Y
					puts $scanrun 0.0
				}
				close $scanrun
				
				#puts "pipe open |$prog $alpha $beta < $config(dirTemp)scan.run"
				
				set pipe [open "|$prog $alpha $beta < $config(dirTemp)scan.run"]
				set tink(progEjec) $prog
				
			}
		}
		#ya esta lanzado el proceso, ejecuto el controlador/capturador del proceso
		#en ppo creo el fichero log junto al fichero mol de partida, despues que cada cual lo mueva a donde le corresponda
		#set fichLog "[file rootname $tink(fichMol)]-$modif.log"
		set fichLog "$config(dirTemp)[string map {".mol" ""} [file tail $tink(fichMol)]]-$modif.log"
		
		set log [open $fichLog w+]
		puts $log $tink(fichMol)
		puts $log [generarInformacionCalculoTinker $base]
		set terminadoProceso [controladorProcesos $base $pipe $log]
		close $log
		if { $terminadoProceso == 1} {
			return [tratarResultadoTinker $base $fichLog $alpha $modif]
		} else {
			return [tratarResultadoTinkerCancelado $base $fichLog $alpha $modif]
		}
	}; #finproc
	
	#en batch debe pedirse una lista de ficheros, lo cuales se procesaran mediante tinker en lote, cada vez q termine uno se eliminara el contenido del visor
	#y se pegara el finalizado
	proc ejecutaTinkerBatch { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		set types {
			{{Ficheros Mol} {.mol} }
		}
		set filenames [tk_getOpenFile -filetypes $types  -multiple 1 -initialdir $config(dirData) -title "Abrir Ficheros Batch"]
		if {$filenames != ""} {set config(dirData) [file dirname [lindex $filenames 0]]}
		foreach file $filenames {
			set tink(fichMol) $file
			Data::newData tempBatch
			Fich::leeFichMol $file tempBatch $tink(conf)
			set fileDir "[file dirname $file]/Almacen/[string map {".mol" ""} [file tail $file]]"
			catch { file delete -force $fileDir } ; file mkdir $fileDir
			set fxyz [Fich::MOLtoXYZ $tink(fichMol) tempBatch $tink(conf)]
			file rename -force $fxyz "$fileDir/[file tail $fxyz]"
			set tink(fichXYZ) "$fileDir/[file tail $fxyz]"
			recomiendaNombreTinker $base
			ejecutaTinker $base
			Data::delData tempBatch
			GUI::finProcesoTink $tink(gui)
		}
	}; #finproc
	
	#controla cuando acaba el proceso. detectando el eof en el pipe, ademas guarda la salida
	#en un fichero .log del cual devuelve el nombre
	proc controladorProcesos { base pipe log } {
		upvar #0 Tinker::$base tink
		upvar #0 GUI::$tink(gui) gui
		
		$gui(butonCancelProc) configure -state normal
		
		
		#establezco el modo no bloqueo de este modo no se keda esperando si no hay nada q leer de la pipe
		fconfigure $pipe -blocking 0

		while {$gui(cancelarProceso) == 0 && ![eof $pipe]} {
			catch {gets $pipe linea} res
			if {$res != -1} {
				#append log "$linea\n"
				puts $log $linea
				puts $linea
			}
			#actualizo la progress bar
			set GUI::${tink(gui)}(varProgressBar) 1
			update
		}
		close $pipe
		$gui(butonCancelProc) configure -state disable	
		set GUI::${tink(gui)}(varProgressBar) -1			
		if {$gui(cancelarProceso) == 1} {
			#se ha cancelado el proceso
			#matar el proceso
			#tk_messageBox -type ok -message "Proceso $tink(prog) Cancelado"
			
			#busco el proceso y lo mato
			set lProc [listaprocesos]
			puts $lProc
			puts $tink(progEjec) 
			set pidProc [buscaPID $lProc $tink(progEjec)]
			if { $pidProc != -1 && [matoproc $pidProc] == 1} {
				#busco el pid del proceso
				tk_messageBox -type ok -message "Proceso $tink(prog) Cancelado"
			} else {
				tk_messageBox -type ok -icon error -message "Ha sido imposible cancelar el proceso $tink(prog)"
			}
			set gui(cancelarProceso) 0
			$gui(butonCancelProc) configure -state disable
			return -1
		} else {	
			return 1
		}
	}; #finproc
	
	#buscar el pid del proceso proc en la lista de pares <pid> <nombre Proceso> listaProc
	proc buscaPID { listaProc nombreProc } {
		set enc -1
		set res -1
		set x 0
		while {$enc != 1 && $x < [llength $listaProc]} {
			set proceso [lindex $listaProc $x]
			if {[string match $nombreProc [lindex $proceso 1]]} {
				set enc 1
				set res [lindex $proceso 0]
			} else {
				incr x
			}
		}
		return $res
	}; #finproc
	
	proc tratarResultadoTinker { base log alpha modif } {
		upvar #0 Tinker::$base tink
		upvar #0 GUI::$tink(gui) gui
		upvar #0 Conf::$tink(conf) config
		
		#a tinker le supone un problema encontrarse el caracter '.' en medio del fichero, por lo q 
		#renombro todos los archivos q contengan #banshee# sustiyuyendolos por '.', ejecuto tinker y
		#despues los restauro nuevamente a '.'
		set patron {"#banshee#" "."}
		set files [glob -nocomplain "[file dirname $alpha]/*#banshee#*"]
		puts $files
		foreach file $files {
			file rename -force $file "[string map $patron $file]"
		}	
		#modifico alpha q a partir de ahora tampoco contendra #banshee#
		set alpha "[string map $patron $alpha]"
		
		
		#creo los directorios para guardar los datos			
		#set dirTinker "[file dirname $tink(fichMol)]/$tink(nombreCalculo)/Tinker"
		#file mkdir $dirTinker
		
		
		set res "ERROR"
		if {$gui(cancelarProceso) == 1} {
			#el proceso ha sido cancelado
			tk_messageBox -type ok -message "Calculo Cancelado"
			#set res "ERROR"
		} else {
			#el proceso ha finalizado por si solo
			#wm iconify .tinkerq
			
			switch $tink(prog) {
				Newton -
				Minimizar -
				Optimizar {
					#renombro el nuevo fichero, como el anterior concatenandole la opcion con q se ha tinkeado
					#file rename -force "[file rootname $tink(fichXYZ)].xyz_2" "[file rootname $tink(fichXYZ)]-$modif.xyz"
					set infoDir "[file dirname $tink(fichMol)]/Almacen/$tink(nombreCalculo)"
					catch { file delete -force $infoDir } ; file mkdir $infoDir
					
					#copio el log
					file copy -force $log "$infoDir/[file tail $log]"
					set log "$infoDir/[file tail $log]"
				
					if {[file exists "${alpha}_2"]} {								
						#copio el xyz resultante al directorio original
						file copy -force "${alpha}_2" "$infoDir/$tink(nombreCalculo).xyz"
						
						#creo el .mol del xyz resultante y el mol original(para leer simbolos y enlaces)
						set nuevoMOL [Fich::XYZtoMOL "$infoDir/$tink(nombreCalculo).xyz" $tink(fichMol)]
						
						file rename -force $nuevoMOL "[file dirname $tink(fichMol)]/[file tail $nuevoMOL]"
						if {$tink(batch) == "N"} {tk_messageBox -type ok -message "Calculo Finalizado"  -title "Informacion"}
						set res [list "[file dirname $tink(fichMol)]/[file tail $nuevoMOL]"]
					} else {
						tk_messageBox -type ok -icon warning -title "Error en el Calculo" -message "Ha ocurrido un error durante el calculo, mire el fichero Log"
						set res "ERROR"
					}
				}
				Analizar {
					set analisis ""
					
					set infoDir "[file dirname $tink(fichMol)]/Almacen/[string map {".mol" ""} [file tail $tink(fichMol)]]"
					file mkdir $infoDir
					
					#copio el log
					file copy -force $log "$infoDir/[file tail $log]"
					set log "$infoDir/[file tail $log]"
					
					
					set l [open $log r+]
					gets $l linea
					while {![eof $l] && ![string match " Total Area" [string range $linea 0 10]]} {
						gets $l linea
					}
					if {![eof $l]} {
						append analisis "$linea\n"
						gets $l linea
						append analisis $linea
						tk_messageBox -type ok -icon warning -title "Area y Volumen" -message $analisis
					} else {
						if {$tink(batch) == "N"} {tk_messageBox -type ok -message "Calculo Finalizado"  -title "Informacion"}
					}
					close $l
					set res [list $tink(fichMol)]
				}
				Scan {
					
					#debo copiar el log, y los restantes que no sean ni el mol, ni el xyz debere copiarlos al directorio de trabajo
					#bajo extension xyz, y transformalos a mol
					set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
					
					#creo el directorio SCAN
					#set scanDir "[file dirname $tink(fichMol)]/SCAN/$tink(nombreCalculo)"
					set scanDir "$config(dirDataOrig)/SCAN/$tink(nombreCalculo)"
					catch { file delete -force $scanDir } ; file mkdir $scanDir
					
					
					#muevo el fichero log
					file rename -force $log $scanDir
					set log "$scanDir/[file tail $log]"
					
					#lista de todos los archivos con el mismo nombre, 
					set lista [glob -nocomplain "[file rootname $alpha].*"]
					
					#elimino de la lista el mol y el xyz, para quedarme solo con los ficheros resultantes del scan
					set index [lsearch -exact $lista "[file rootname $alpha].mol"]
					set lista [lreplace $lista $index $index]
					set index [lsearch -exact $lista "$alpha"]
					set lista [lreplace $lista $index $index]
					
					#para el resto de los ficheros los convierto y copio a la carpeta SCAN
					
					#copio cada fichero
					foreach f $lista {
						set infoDir "$scanDir/Almacen/[string map {".mol" ""} [file tail $f]]-$modif"
						catch { file delete -force $infoDir } ; file mkdir $infoDir
						file copy -force $f "$infoDir/[file tail $f]-$modif.xyz"
						set f [Fich::XYZtoMOL "$infoDir/[file tail $f]-$modif.xyz" $tink(fichMol)]
						file rename -force $f "$scanDir/[file tail $f]"
					}
					if {$tink(batch) == "N"} {tk_messageBox -type ok -message "Calculo Finalizado"  -title "Informacion"}
					set res "NOGENFICH"
				}
				Vibrate {
					#creo el directorio VIBRATE
	
					set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
					set dirTinker "[file dirname $tink(fichMol)]/Almacen/$f1/Tinker/VIBRATE"
					catch { file delete -force $dirTinker }
					file mkdir $dirTinker
					
					#copio el fichero log
					#file copy -force $log $vibrateDir;
					file rename -force $log $dirTinker
					set log "$dirTinker/[file tail $log]"
					
					
					#lista de todos los archivos con el mismo nombre, 
					set lista [glob -nocomplain "[file rootname $alpha].*"]
					
					#elimino de la lista el mol y el xyz, para quedarme solo con los ficheros resultantes del vibrate
					set index [lsearch -exact $lista "[file rootname $alpha].mol"]
					set lista [lreplace $lista $index $index]
					set index [lsearch -exact $lista "$alpha"]
					set lista [lreplace $lista $index $index]
					
					puts "lista vib : $lista"
					
					foreach f $lista {
						#file copy -force $f "$vibrateDir/[file tail $f]";
						file copy -force $f $dirTinker
					}
					if {$tink(batch) == "N"} {tk_messageBox -type ok -message "Calculo Finalizado"  -title "Informacion"}
					set res "NOGENFICH"
				}
				Saddle {
				#creo una carpeta TS en el direcotiro del 1º fichero proporcionado
					#set tsDir "[file dirname $tink(fichMol)]/TS"
					set tsDir "$config(dirDataOrig)TS/$tink(nombreCalculo)"
					catch { file delete -force $tsDir } ; file mkdir $tsDir
					
					set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
					
					#copio los mol y los xyz aunq estos no se han modificado
					set mols [glob -nocomplain "[file dirname $alpha]/*.mol"]
					set xyzs [glob -nocomplain "[file dirname $alpha]/*.xyz"]
					
					foreach fich $mols { file copy -force $fich "$tsDir/[file tail $fich]" }
					
					foreach fich $xyzs {
						set infoDir "$tsDir/Almacen/[string map {".xyz" ""} [file tail $fich]]"
						catch { file delete -force $infoDir } ; file mkdir $infoDir
						file copy -force $fich $infoDir
					}
					
					#genero el nombre combinado
					set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
					set f2 [string map {".mol" ""} [file tail $tink(fichero2Mol)]]
					set combi "$f1-$f2"
					
					#muevo el fichero log
					file rename -force $log $tsDir
					set log "$tsDir/[file tail $log]"
					
					#debo considerar si existe tstate.xyz
					if {$tink(transicionPrev) == "N" && [file exists tstate.xyz]} {
						tk_messageBox -type ok -message "Calculo Finalizado" -title "Informacion"
						set infoDir "$tsDir/Almacen/$combi-$modif/"
						catch { file delete -force $infoDir } ; file mkdir $infoDir
						file copy -force tstate.xyz "$infoDir/$combi-$modif.xyz";
						set f [Fich::XYZtoMOL "$infoDir/$combi-$modif.xyz" $tink(fichero2Mol)];
						file rename -force $f "$tsDir/[file tail $f]"
						set res [list "$tsDir/[file tail $f]"]
					} elseif {$tink(transicionPrev) == "Y" && [file exists tstate.xyz_2]} {
						tk_messageBox -type ok -message "Calculo Finalizado"
						set infoDir "$tsDir/Almacen/${combi}2-$modif/"
						catch { file delete -force $infoDir } ; file mkdir $infoDir
						file copy -force tstate.xyz "$infoDir/${combi}2-$modif.xyz";
						set f [Fich::XYZtoMOL "$infoDir/${combi}2-$modif.xyz" $tink(fichero2Mol)];
						file rename -force $f "$tsDir/[file tail $f]"
						set res [list "$tsDir/[file tail $f]"]
					} else {
						tk_messageBox -type ok -icon warning -message "No se ha encontrado estado de transicion" -title "Informacion"
						set res "ERROR"
					}
					#borro el cualquier rastro de tstate
					set lis [glob -nocomplain "tstate.*"]
					foreach f $lis { catch { file delete -force $f } }
					
					#borro el data temporal
					Data::delData tempDataETTR	
				}
				Path {
					#debo copiar el log, y los restantes que no sean ni el mol, ni el xyz debere copiarlos al directorio de trabajo
					#bajo extension xyz, y transformalos a mol
					
					#creo el directorio PATH
					set pathDir "$config(dirDataOrig)PATH/$tink(nombreCalculo)"
					catch { file delete -force $pathDir } ; file mkdir $pathDir
					
					#genero el nombre combinado
					set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
					set f2 [string map {".mol" ""} [file tail $tink(fichero2Mol)]]
					set combi "$f1-$f2"
					
					#muevo el fichero log
					file rename -force $log $pathDir
					set log "$pathDir/[file tail $log]"
					
					#lista de todos los archivos con el mismo nombre, 
					set lista [glob -nocomplain "$config(dirTemp)$f2.*"]
					
					#elimino de la lista el mol y el xyz, para quedarme solo con los ficheros resultantes del vibrate
					set index [lsearch -exact $lista "config(dirTemp)$f1.mol"]
					set lista [lreplace $lista $index $index]
					set index [lsearch -exact $lista "$config(dirTemp)$f2.mol"]
					set lista [lreplace $lista $index $index]
					set index [lsearch -exact $lista "$config(dirTemp)$f1.xyz"]
					set lista [lreplace $lista $index $index]
					set index [lsearch -exact $lista "$config(dirTemp)$f2.xyz"]
					set lista [lreplace $lista $index $index]
					
					set listaF [list]
					foreach f $lista {

						set infoDir "$pathDir/Almacen/[string map {".mol" ""} [file tail $f]]-$modif"
						catch { file delete -force $infoDir } ; file mkdir $infoDir
						file copy -force $f "$infoDir/[file tail $f]-$modif.xyz"
						set f [Fich::XYZtoMOL "$infoDir/[file tail $f]-$modif.xyz" $tink(fichMol)]
						file rename -force $f "$pathDir/[file tail $f]"
						lappend listaF "$pathDir/[file tail $f]"
					}
					set res $listaF
				}
				Superpose {
					#creo el directorio SUPER
					set superDir "$config(dirDataOrig)/SUPER/$tink(nombreCalculo)"
					file mkdir $superDir
					
					set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
					set f2 [string map {".mol" ""} [file tail $tink(fichero2Mol)]]
					
					#copio el log
					#file copy -force $log "$superDir/$f2-$modif.log"
					#muevo el fichero log
					#file copy -force $log "$superDir/Almacen/[file tail $log]"
					#set log "$superDir/Almacen/[file tail $log]"

					#copio los mols y xyz
					file copy -force "$config(dirTemp)$f1.mol" "$superDir/$f1.mol"
					file copy -force "$config(dirTemp)$f2.mol" "$superDir/$f2.mol"
					
					set infoDir "$superDir/Almacen/$f1"
					catch { file delete -force $infoDir } ; file mkdir $infoDir
					file copy -force "$config(dirTemp)$f1.xyz" "$infoDir/$f1.xyz"
					set infoDir2 "$superDir/Almacen/$f2"
					catch { file delete -force $infoDir2 } ; file mkdir $infoDir2
					file copy -force "$config(dirTemp)$f2.xyz" "$infoDir2/$f2.xyz"
					
					if {[file exists "$config(dirTemp)$f2.xyz_2"]} {
						set infoDir "$superDir/Almacen/[string map {".mol" ""} [file tail $f2]]-$modif"
						file delete -force $infoDir ; file mkdir $infoDir
						file copy -force "$config(dirTemp)$f2.xyz_2" "$infoDir/[file tail $f2]-$modif.xyz"
						set f [Fich::XYZtoMOL "$infoDir/[file tail $f2]-$modif.xyz" $tink(fichero2Mol)]
						file rename -force $f "$superDir/[file tail $f]"
						set res [list "$superDir/[file tail $f]"]
						
						#copio el log
						file copy -force $log "$infoDir/[file tail $f2]-$modif.log"
						set log "$infoDir2/[file tail $f2]-$modif.log"
					}
				}
				default {
					puts "NOGENFICH"
					set res "NOGENFICH"
				}
			}
			#muestro el resultado si no estoy en batch
			if {$tink(batch) == "N"} {
				Log::cerrarLogs $gui(semillaLogs)
				incr gui(semillaLogs)
				Log::newLog log_$gui(semillaLogs) $log $gui(conf) "log" 0
				if {$tink(prog) == "Scan" } {
					#en el caso de scan es necesario añadirle un nuevo boton
					set cmd "Log::cargarTexto log_$gui(semillaLogs) [list [ordenaLogBC $log]]"
					Log::anadirBotonLog log_$gui(semillaLogs) "texto" "$Icon::ordenicon" $cmd
				}
				
			}
		}
		set gui(resultadoTink) $res 
		return $res
	}; #finproc
	
	proc tratarResultadoTinkerCancelado { base log alpha modif } {
		upvar #0 Tinker::$base tink
		upvar #0 GUI::$tink(gui) gui
		upvar #0 Conf::$tink(conf) config
		
		
		#si se estaba ejecutando un scan, intentaremos recuperar el trabajo q llevaba echo
		if {$tink(prog) == "Scan"} {
		
			set recuperado [list]
		#
			#debo copiar el log, y los restantes que no sean ni el mol, ni el xyz debere copiarlos al directorio de trabajo
			#bajo extension xyz, y transformalos a mol
			set f1 [string map {".mol" ""} [file tail $tink(fichMol)]]
			
			#creo el directorio SCAN
			#set scanDir "[file dirname $tink(fichMol)]/SCAN/$tink(nombreCalculo)"
			set scanDir "$config(dirDataOrig)/SCAN/$tink(nombreCalculo)_cancelado"
			catch { file delete -force $scanDir } ; file mkdir $scanDir
			
					
			#muevo el fichero log
			file rename -force $log "$scanDir/[file tail $log]"
			set log "$scanDir/[file tail $log]"
					
			#lista de todos los archivos con el mismo nombre, 
			set lista [glob -nocomplain "[file rootname $alpha].*"]
			
			#elimino de la lista el mol y el xyz, para quedarme solo con los ficheros resultantes del scan
			set index [lsearch -exact $lista "[file rootname $alpha].mol"]
			set lista [lreplace $lista $index $index]
			set index [lsearch -exact $lista "$alpha"]
			set lista [lreplace $lista $index $index]
			
			#para el resto de los ficheros los convierto y copio a la carpeta SCAN
			
			#copio cada fichero
			foreach f $lista {
				catch {
					set infoDir "$scanDir/Almacen/[string map {".mol" ""} [file tail $f]]-$modif"
					catch { file delete -force $infoDir } ; file mkdir $infoDir
					file copy -force $f "$infoDir/[file tail $f]-$modif.xyz"
					set f [Fich::XYZtoMOL "$infoDir/[file tail $f]-$modif.xyz" $tink(fichMol)]
					file rename -force $f "$scanDir/[file tail $f]"
				} erro
				if {$erro == ""} {append recuperado "$f\n"}
			}
			puts "recuperado : $recuperado"
			if {$recuperado != ""} { tk_messageBox -message "Ficheros Scan Recuperados Satisfactoriamente en \"$scanDir\"" }
		
			#muestro el resultado si no estoy en batch
			Log::cerrarLogs $gui(semillaLogs)
			incr gui(semillaLogs)
			Log::newLog log_$gui(semillaLogs) $log $gui(conf) "log" 0
			if {$tink(prog) == "Scan" } {
				#en el caso de scan es necesario añadirle un nuevo boton
				set cmd "Log::cargarTexto log_$gui(semillaLogs) [list [ordenaLogBC $log]]"
				Log::anadirBotonLog log_$gui(semillaLogs) "texto" "$Icon::ordenicon" $cmd
			}
		}
		set gui(resultadoTink) "ERROR"
		return "ERROR"
	}; #finproc
	
	proc generarInformacionCalculoTinker { base } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		upvar #0 Data::$tink(baseData) datos
		
		set texto ""
		append texto "powered by BANSHEE&GT&FN\n"
		append texto "******************************************************************************\n"
		append texto "*                              PARAMETROS UTILIZADOS                         *\n"
		append texto "******************************************************************************\n"
		append texto "Calculo : $tink(prog)\n"
		
		switch $tink(prog) {			
			Newton {
				#set pipe [open "|newton.exe $alpha $tink(metodo) $tink(precond) $tink(rms)"]
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Choose Automatic, Newton, TNCG or DTNCG Method : $tink(metodo)\n"
				append texto "Precondition via Auto/None/Diag/Block/SSOR/ICCG: $tink(precond)\n"
				append texto "Enter RMS Gradient per Atom Criterion : $tink(rms)\n"
			}
			Minimizar {
				#set pipe [open "|minimize.exe $alpha $tink(rms)"]
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Enter RMS Gradient per Atom Criterion : $tink(rms)\n"
			}
			Optimizar {
				#set pipe [open "|optimize.exe $alpha $tink(rms)"]
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Enter RMS Gradient per Atom Criterion : $tink(rms)\n"
			}
			Analizar {
				switch $tink(analisis) {
					E -
					M -
					D -
					P {	
						#set pipe [open "|analyze.exe $alpha $tink(analisis)"]
						append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
						append texto "Enter the Desired Analysis Types : $tink(analisis)\n"
					}
					1 -
					2 {
						#puts "spacefill.exe $tink(fichXYZ) $config(prmCargado) $tink(analisis) $tink(hidrogenos)"
						#set pipe [open "|spacefill.exe $alpha $tink(analisis) 1.4 $tink(hidrogenos)"]
						append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
						append texto "Enter the number of your Choice: $tink(analisis)\n"
						append texto "Probe Radius : 1.4\n"
						append texto "Include Hidrogen Atoms in : $tink(hidrogenos)\n"
					}
				}	
			}
			Scan {
				if {$tink(tipoBC) == 1} { 
					append texto "Tipo Scan : scan\n"
				} else {
					append texto "Tipo Scan : scancvm\n"
				}
				if {$tink(seleccion) == 0} {
					#modo automatico
					#set pipe [open "|$prog $alpha $tink(seleccion) $tink(direc) $tink(tresh) $tink(rms2)"]
					append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
					append texto "Enter the Method of Choice : $tink(seleccion)\n"
					append texto "Enter the Number Search Directions for Local Search : $tink(direc)\n"
					append texto "Enter the Energy Threshold for Local Minima : $tink(tresh)\n"
					append texto "Enter RMS Gradient per Atom Criterion : $tink(rms)\n"
				} else {
					#modo manual
					set lista [formatearTextoWEnlaces $tink(textoWE)]
					append lista \n\n
					
					append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
					append texto "Enter the Method of Choice : $tink(seleccion)\n"
					append texto "Enter the Number Search Directions for Local Search : $tink(direc)\n"
					append texto "Enter the Energy Threshold for Local Minima : $tink(tresh)\n"
					append texto "Enter RMS Gradient per Atom Criterion : $tink(rms)\n"
					append texto "Bounds: $lista\n"
				}
			}
			Vibrate {
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Numero Vibraciones : [expr $datos(numAtomos) * 3]\n"
			}
			Saddle {
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichero2XYZ)]\n"
				if {$tink(transicionPrev) == "Y"} {append texto "Previus TS  : [file tail $tink(fichero3Mol)]\n"}
				append texto "Enter RMS Gradient per Atom Criterion : $tink(rms3)\n"
			}
			Path {
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichero2XYZ)]\n"
				append texto "Enter the Number of Path Points to Generate : $tink(estructuras)\n"
				append texto "Enter RMS Gradient per Atom Criterion : $tink(rms3)\n"
			}
			Superpose {
				#genero el fichero scan.run con los parametros q le pasare al superpose
				set lista [formatearTextoWEnlaces $tink(textoWSuper)]
				set lista [split $lista \n]
				
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichXYZ)]\n"
				append texto "Enter Cartesian Coordinate File : [file tail $tink(fichero2XYZ)]\n"
				if {[llength $lista] == 0} {
					#modo por defecto, doy un \n
					append texto "Superpose Mode : Default\n"
					append texto "Include Hydrogen Atoms in the Fitting : N\n"
					append texto "Use Mass- or Unit-Weighted Coordinates : U\n"
					append texto "Write Best-Fit Coordinate of 2nd Molecule : Y\n"
					append texto "Cutoff Value for Listing RMS Deviations : 0.0\n"
				} elseif {[llength $lista] == 1} {
					#modo 1, desde el atomo M al N, en tinker seria 1,M,N
					append texto "Superpose Mode : 1 [lindex [lindex $lista 0] 0] [lindex [lindex $lista 0] 1]\n"
					append texto "Include Hydrogen Atoms in the Fitting : N\n"
					append texto "Use Mass- or Unit-Weighted Coordinates : U\n"
					append texto "Write Best-Fit Coordinate of 2nd Molecule : Y\n"
					append texto "Cutoff Value for Listing RMS Deviations: 0.0\n"
				} else {
					#modo 2, especificacion explicita de los atomos implicados, en tinker seria 2,i,j para cada par
					append texto "Superpose Mode : Manual\n"
					append texto "Enter a Pair of Atoms or Ranges : \n"
					foreach enl $lista { append texto "[lindex $enl 0] [lindex $enl 1]\n" }
					append texto "Use Mass- or Unit-Weighted Coordinates : U\n"
					append texto "Write Best-Fit Coordinate of 2nd Molecule : N\n"
					append texto "Cutoff Value for Listing RMS Deviations : 0.0\n"
				}	
			}
		}
		#copio el fichero Tinker.key
		set f [open $tink(fichKey)]
		append texto "\nFichero Tinker.key : \n"
		set tinkkey [read $f]
		set tinkkey [string map {"\n\n" ""} $tinkkey]
		append texto "$tinkkey\n"
		close $f
		append texto "******************************************************************************\n\n"
		append texto "Tinker's Output : \n\n"
		
		return $texto
	}; #finproc
	
	proc manejadorEjecutar { base } {
		upvar #0 Tinker::$base tink
		upvar #0 GUI::$tink(gui) gui
		
		set calc 1
		set key [devolverTextoTinkerKeyFormateado $base]
		if { $key != ""} {
			if {$tink(mainframe) != "" } { set parent $tink(mainframe) } else { set parent .}
			if {![tk_messageBox -type yesno -message "El Fichero Key tiene las siguientes restricciones.\n$key\n \
									¿Desea continuar con este fichero?" -parent $parent]} {
				set calc 0					
			}
		}
		
		
		if {$calc == 1} {
			#pongo en primer plano la ventan principal
			if {$tink(mainframe) != "" } { wm withdraw $tink(mainframe) }
			if {$tink(batch) == "N"} {
				ejecutaTinker $base
				catch {GUI::finProcesoTink $tink(gui)}
			} else {
				ejecutaTinkerBatch $base
			}

			#destruyo la ventana Tinker, esto avisaria a la gui de q ya puede consultar la variable gui(resultadoTink)
			if {$tink(mainframe) != "" } { 
				#esto ya incluye delTinker $base
				destroy $tink(mainframe) 
			} else {
				#lo destruyo a mano
				delTinker $base
			}
			#destruyo el objeto
			#delTinker $base
			#el objeto tinker se destruye por medio de un bind para no hacer distincion entre cerrarlo con la x, con el boton cerrar, o fin de proceso
		} else {
			if {$tink(mainframe) != "" } {focus $tink(mainframe)} else { delTinker $base }
		}
	}; #finproc
	
	proc manejadorCancelar { base } {
		upvar #0 Tinker::$base tink
		if {$tink(mainframe) != "" } { destroy $tink(mainframe) }
		#delTinker $base
	}; #finproc
	
	proc modificaPRMFichKey { base textoK textoM } {
		upvar #0 Tinker::$base tink
		upvar #0 Conf::$tink(conf) config
		
		set types { { {Parametros} {.prm} } }
		set filename [tk_getOpenFile -defaultextension "prm" -initialdir $config(dirCHM) -filetypes $types -parent $tink(mainframe)]
		if { $filename != "" } {
			set config(dirData) [file dirname $filename]
			$textoK delete 0.0 1.end
			$textoK insert 0.0 "PARAMETERS $filename"
			#guardarTinkerKey $base $textoK $textoM 
		}
	}; #finproc
	
}; #finnamespace

