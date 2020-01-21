########################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#									- MODULO PARA EL MANEJO DE MOPAC -
#    	   						   		   --------------------
#	Manejo de las aplicaciones Tinker, interfaz hacia ellas y control de procesos
#
#	Definido dentro del
#			namespace eval Mopac
#
#
#	base(): array que representara la instancia de Mopac
#
#			base(mainframe)
#
#			base(textWM) 			--> nombre del widget texto de la ventana ModelizarMopac

			#para la modelizacion
#			base(hamiltoniano) 
#			base(estado) 
#			base(optimizacion) 
			
#			base(uhf_rhf) 
#			base(int_cart) 
			
#			base(carga) 
#			base(gnorm) 
#			base(recalc) 
#			base(iter) 
#			
#			base(geo) 
#			base(prec) 
#			base(xyz) 
#			base(mmok) 
#			
#			base(graph) 
#			base(mulliken) 
#			base(local) 
#			base(bond) 
#			base(pi) 
#			base(density)
#			base(vectors) 
#			base(fock) 
#			base(otros)
#
########################################################################################################


namespace eval Mopac {

	#tipo identifica kien llama a tinker
	#		tipo 0 --> Modelizacion Mopac
	#		tipo 1 --> Mostrar Cargas
	#		tipo 2 --> Mostrar Vibraciones
	#		tipo 3 --> Mostrar Orbitales
	proc newMopac { base baseData baseConf baseGui fichMOL tipo } {
	
		if {[info exists Mopac::$base]==0} { 
		
			GUI::activaDesactivaSemaforo $baseGui 1 "Mopac en curso..."
		
			variable $base
			
			set ${base}(data) $baseData
			set ${base}(conf) $baseConf
			set ${base}(gui) $baseGui
			
			
			#inicializo variables
			set ${base}(mainframe) ""
			
			set ${base}(nombreCalculo) ""
			set ${base}(NB) ""
			set ${base}(buttonEjec) ""
			
			#ficheros asociados
			set ${base}(fichMOL) $fichMOL
			set ${base}(coordMOPACCart) ""
			set ${base}(coordMOPACInt) ""
			
			
			set ${base}(fichMNO) ""
			
			set ${base}(textWM) ""
			set ${base}(nombCalculo) ""
			
			#para la modelizacion
			set ${base}(hamiltoniano) "AM1"
			set ${base}(estado) "SINGLET"
			set ${base}(optimizacion) "NONE"
			
			set ${base}(uhf_rhf) "RHF"
			set ${base}(int_cart) "car"
			
			set ${base}(carga) "0"
			set ${base}(gnorm) "1"
			set ${base}(recalc) "NONE"
			set ${base}(iter) "200"
			
			set ${base}(geo) "N"
			set ${base}(prec) "N"
			set ${base}(xyz) "N"
			set ${base}(mmok) "N"
			
			set ${base}(graph) "N"
			
			set ${base}(allvec) "N"
			set ${base}(mulliken) "N"
			set ${base}(local) "N"
			set ${base}(bond) "N"
			set ${base}(pi) "N"
			set ${base}(density) "N"
			set ${base}(vectors) "N"
			set ${base}(fock) "N"
			set ${base}(otros) ""
			
			#para el control del formato de la lina de mopac
			set ${base}(linea) 1
			
			#para saddle
			set ${base}(fichMOLSaddle1) "Defina el fichero 1"
			set ${base}(coordMOPACCartSaddle1) ""
			set ${base}(coordMOPACIntSaddle1) ""
			set ${base}(fichMOLSaddle2) "Defina el fichero 2"
			set ${base}(coordMOPACCartSaddle2) ""
			set ${base}(coordMOPACIntSaddle2) ""
			
			#borro los posibles datas q se han creao
			Data::delData tempSaddle1
			Data::delData tempSaddle2
			set ${base}(datafichMOLSaddle1) "tempSaddle1"
			set ${base}(datafichMOLSaddle2) "tempSaddle1"
			
			#para las vibraciones
			set ${base}(nVibraciones) 0
			set ${base}(vibSeleccionada) ""
			set ${base}(semillaVib) 0
			set ${base}(listaVib) [list]
			set ${base}(escalaAnt) 1
			set ${base}(lineaCanvasSeleccionada) 0
			set ${base}(maxTDipolo) -1
			#base(tDipolo,nVib), solo para las vibraciones para las q se haya definido el tDipolo
			set ${base}(mismaVentanaVib) "Y"
			
			#para los orbitales
			set ${base}(semillaOrb) 0
			set ${base}(listaOrb) [list]
			set ${base}(ocupados) 0
			set ${base}(orbSeleccionado) ""
			set ${base}(isovalor) "0.05"
			set ${base}(resolucion) "M"
			set ${base}(mismaVentanaOrb) "N"
			set ${base}(escalaAntOrb) 1
			set ${base}(lineaCanvasSeleccionadaOrb) 0
			set ${base}(colorUltimalineaCanvasSeleccionadaOrb) "blue"
			
			
			
			
			#controlo q el fichero exista
			if {[file exists $fichMOL] && $tipo != 1} {
				set ${base}(coordMOPACCart) [Fich::MOLtoMOPACCartesianas $fichMOL]
				#le propongo un nombre para el calculo
				recomiendaNombreMopac $base
			}
			
			switch $tipo {
				1 { 
					if {[file exists $fichMOL]} {
						mostrarCargasCHIME $base
					} else {
						tk_messageBox -type ok -message "Guarde su fichero y ejecute Mopac antes de ver la Distribucion de cargas"
						delMopac $base
					}
				}
				2 {
					if {[file exists $fichMOL]} {
						set f1 [string map {".mol" ""} [file tail $fichMOL]]
						set fmno "[file dirname $fichMOL]/Almacen/$f1/Mopac/$f1.mno"
						if {[file exists $fmno] && [file exists "[file dirname $fmno]/VIBRATE"]} {
							set ${base}(fichMNO) $fmno
							set ${base}(listaVib) [devuelveVibraciones $base $fmno]
							ventanaVibraciones $base
						} else {
							tk_messageBox -type ok -message "No existen vibraciones para el fichero : \"$fichMOL\""
							delMopac $base
						}
					} else {
						tk_messageBox -type ok -message "No existen vibraciones para el fichero : \"$fichMOL\""
						delMopac $base
					}
				}
				3 {
					if {[file exists $fichMOL]} {
						set f1 [string map {".mol" ""} [file tail $fichMOL]]
						set fmno "[file dirname $fichMOL]/Almacen/$f1/Mopac/$f1.mno"
						if {[file exists $fmno] && [file exists "[file dirname $fmno]/GRAPH/$f1.gpt"]} {
							set ${base}(fichMNO) $fmno
							set ${base}(listaOrb) [devuelveOrbitales $base $fmno]
							set ${base}(ocupados) [devuelveNumeroOrbitalesOcupados $base $fmno]
							ventanaOrbitales $base
						} else {
							tk_messageBox -type ok -message "No existen orbitales para el fichero : \"$fichMOL\""
							delMopac $base
						}
					} else {
						tk_messageBox -type ok -message "No existen orbitales para el fichero : \"$fichMOL\""
						delMopac $base
					}
				}
				default { 
					#arranco la ventana
					ventanaModelizarMopac $base
				}
			}
		} else {
			tk_messageBox -type ok -message "Mopac se encuentra abierto o ejecutandose en estos momentos.\n \
											              Cierrelo e intentelo de nuevo."
			return -1
		}
	}; #finproc
	
	proc delMopac { base } {
		upvar #0 Mopac::$base mopac
		
		if {[array exists mopac]} {
			catch {
				GUI::activaDesactivaSemaforo $mopac(gui) 0 "Listo"
				cerrarOrbitales $base	
			}
			unset mopac 
		}
	}; #finproc
	
	#para calcular las coordenadas internas ocartesianas se realiza una ejecucion previa de mopac, con la opcion 0SCF - AFTER READING AND PRINTING DATA, STOP
	#y de su resultado las obtengo
	proc calculaCoordenadasCartIntMopac { base fichMOL cartInt coords} {
		upvar #0 Mopac::$base mopac
		upvar #0 Conf::$mopac(conf) config
		
		catch { file delete -force $config(dirTemp) ; file mkdir $config(dirTemp) }
		
		set fMOPi [open "$config(dirTemp)FOR005" w+]
		puts $fMOPi "0scf"
		puts $fMOPi "$fichMOL"
		puts $fMOPi "$fichMOL"
		
		puts $fMOPi $coords
		#close $fichMOP
		close $fMOPi
		
		#ejecuto mopac
		cd "$config(dirTemp)"
		exec "$config(dirBin)mopacesp.exe"
		cd "$config(dirBin)"
		
		#guardo las coordenadas cartesianas
		if {[file exists "$config(dirTemp)FOR006"]} {
			if {$cartInt == "car"} {
				return [Fich::primerasCartesianasMOPACOSCF "$config(dirTemp)FOR006" "$fichMOL"]
			} else {
				return [Fich::primerasInternasMOPACOSCF "$config(dirTemp)FOR006" "$fichMOL"]
			}	
		} else { return -1 }
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#										-	MODELIZACION GENERAL   -
#----------------------------------------------------------------------------------------------		
	
	proc ventanaModelizarMopac { base } {
		upvar #0 Mopac::$base mopac
		
		#creo la ventana
		toplevel .mopacq
		set mopac(mainframe) ".mopacq"
		wm title .mopacq "Modelización con Mopac"
		
		
		#4 frames ppales superior, superior2, central e inferior
		#frame superior
		set frameup [frame .mopacq.frameup]
		set label [Label $frameup.label -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		set label2 [Label $frameup.label2 -activebackground #a0a0a0 -text "Mopac Tools" -font {Arial 12 {bold italic}} -relief flat -anchor center]
		
		#pack $label -side right
		pack $label2 -side left
		
		set frameup2 [frame .mopacq.frameup2]
		set ncalc [ LabelEntry $frameup2.calculo -label "Nombre del Calculo Mopac : " -textvariable "Mopac::${base}(nombreCalculo)" -side left -width 40 -labelfont {Arial 9 {bold roman}}]
		set mopac(nombCalculo) $ncalc
		
		pack $ncalc -side left -padx 5
		
		
		#frame central
		set framecent [frame .mopacq.framecent]
		
		set notebook [NoteBook $framecent.nb] 
		set mopac(NB) $notebook
		$notebook insert 0 metodo -text "Método" 
		$notebook insert 1 salida -text "Salida"
		$notebook insert 2 saddle -text "Saddle" -state disabled 
		
		
		#pestaña de metodo
		set metodo [$notebook getframe metodo]
		
		set metodo1 [frame $metodo.f1 -bd 1 -relief raised]
		set label1 [Label $metodo1.l1 -activebackground #a0a0a0 -text "Hamiltoniano " -relief flat]
		set hamil [ComboBox $metodo1.model -modifycmd "Mopac::actualizaTextWMopac $base" -textvariable "Mopac::${base}(hamiltoniano)" -values [list AM1 PM3 MNDO MINDO3] -width 15 -hottrack 1]
		set rhf [ radiobutton $metodo1.rhf -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(uhf_rhf)" -text "RHF" -value RHF]
		set uhf [ radiobutton $metodo1.uhf -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(uhf_rhf)" -text "UHF" -value UHF]
		set int [ radiobutton $metodo1.int -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(int_cart)" -text "Internas" -value int]
		set car [ radiobutton $metodo1.car -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(int_cart)" -text "Cartesianas" -value car]
		pack $label1 $hamil $rhf $uhf $int $car -side left -pady 3 -padx 4
	
		set metodo2 [frame $metodo.f2 -bd 1 -relief raised]
		set label2 [Label $metodo2.l1 -activebackground #a0a0a0 -text "Estado          " -relief flat]
		set estado [ComboBox $metodo2.est -modifycmd "Mopac::actualizaTextWMopac $base" -textvariable "Mopac::${base}(estado)" -values [list SINGLET DOUBLET TRIPLET QUARTET QUINTET SEXTET] -width 15 -hottrack 1]
		set carga [ LabelEntry $metodo2.carg -label "Carga : " -textvariable "Mopac::${base}(carga)" -side left -width 3]
		set gnorm [ LabelEntry $metodo2.gnorm -label "GNorm : " -textvariable "Mopac::${base}(gnorm)" -side left -width 3]
		set rec [ LabelEntry $metodo2.rec -label "Rec : " -textvariable "Mopac::${base}(recalc)" -side left -width 5]
		set iter [ LabelEntry $metodo2.iter -label "Iter : " -textvariable "Mopac::${base}(iter)" -side left -width 3]
		pack $label2 $estado $carga $gnorm $rec $iter -side left -pady 3 -padx 4
		
		bind $carga <FocusOut> "Mopac::actualizaTextWMopac $base"
		bind $gnorm <FocusOut> "Mopac::actualizaTextWMopac $base"
		bind $rec <FocusOut> "Mopac::actualizaTextWMopac $base"
		bind $iter <FocusOut> "Mopac::actualizaTextWMopac $base"
		
		
		
		set metodo3 [frame $metodo.f3 -bd 1 -relief raised]
		set label3 [Label $metodo3.l1 -activebackground #a0a0a0 -text "Optimizacion   " -relief flat]
		set opti [ComboBox $metodo3.opt -modifycmd "Mopac::controlaOptimizacionMopac $base" -textvariable "Mopac::${base}(optimizacion)" -values [list NONE EF NLLSQ SIGMA TS SADDLE FORCE] -width 15 -hottrack 1]
		set geo [checkbutton $metodo3.geo -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(geo)" -text "GeoOk" -onvalue "Y" -offvalue "N"]
		set prec [checkbutton $metodo3.prec -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(prec)" -text "Precise"  -onvalue "Y" -offvalue "N"]
		set xyz [checkbutton $metodo3.xyz -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(xyz)" -text "XYZ"  -onvalue "Y" -offvalue "N"]
		set mm [checkbutton $metodo3.mm -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(mmok)" -text "MmOk"  -onvalue "Y" -offvalue "N"]
		set graph [checkbutton $metodo3.graph -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(graph)" -text "Graph"  -onvalue "Y" -offvalue "N"]
		pack $label3 $opti -side left -pady 3 -padx 2
		pack $geo $prec $xyz $mm $graph -side left -pady 3
		
		
		pack $metodo1 -fill x -ipadx 3
		pack $metodo2 -fill x -ipadx 3
		pack $metodo3 -fill x -ipadx 3
		
		
		#pestaña de salida
		set salida [$notebook getframe salida]
		
		set salida1 [frame $salida.f1 -bd 1 -relief raised]
		set allvec [checkbutton $salida1.all -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(allvec)" -text "Allvec"  -onvalue "Y" -offvalue "N"]
		set mul [checkbutton $salida1.mul -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(mulliken)" -text "Mulliken"  -onvalue "Y" -offvalue "N"]
		set local [checkbutton $salida1.local -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(local)" -text "Local" -onvalue "Y" -offvalue "N"]
		pack $allvec $mul $local -side left -pady 3 -padx 25
		

		set salida2 [frame $salida.f2 -bd 1 -relief raised]
		set bond [checkbutton $salida2.bond -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(bond)" -text "Bond" -onvalue "Y" -offvalue "N"]
		set pi [checkbutton $salida2.pi -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(pi)" -text "Pi"  -onvalue "Y" -offvalue "N"]
		set den [checkbutton $salida2.den -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(density)" -text "Density"  -onvalue "Y" -offvalue "N"]
		pack $bond -side left -pady 3 -padx 25
		pack $pi -side left -pady 3 -padx 30
		pack $den -side left -pady 3 -padx 50
		
		set salida3 [frame $salida.f3 -bd 1 -relief raised]
		set vect [checkbutton $salida3.vect -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(vectors)" -text "Vectors"  -onvalue "Y" -offvalue "N"]
		set fock [checkbutton $salida3.fock -command "Mopac::actualizaTextWMopac $base" -variable "Mopac::${base}(fock)" -text "Fock"  -onvalue "Y" -offvalue "N"]
		set otros [LabelEntry $salida3.otros -textvariable "Mopac::${base}(otros)" -label "Otros" -side right]
		pack $vect  -side left -pady 3 -padx 25
		pack $fock  -side left -pady 3 -padx 20
		pack $otros  -side left -pady 3 -padx 50
		
		bind $otros <FocusOut> "Mopac::actualizaTextWMopac $base"

		pack $salida1 -fill x -ipadx 3
		pack $salida2 -fill x -ipadx 3
		pack $salida3 -fill x -ipadx 3
		
		#pestaña saddle
		set sad [$notebook getframe saddle]
		
		set label1 [Label $sad.l1 -activebackground #a0a0a0 -text "Fichero 1 : " -relief flat -font {Arial 8 {bold roman}}]
		set fb1 [frame $sad.b1]
		set e1 [entry $fb1.file1 -width 30 -textvariable "Mopac::${base}(fichMOLSaddle1)"]
		set b1 [Button $fb1.b1 -activebackground #a0a0a0 -command "Mopac::manejadorBotFichSaddleMopac $base 1" -helptext "Escoja el Primer Fichero" -image $Icon::diricon -text "Ayuda"]
		pack $e1  -side left -fill x -expand 1
		pack $b1 -side left -fill x

		set label2 [Label $sad.l2 -activebackground #a0a0a0 -text "Fichero 2 : " -relief flat -font {Arial 8 {bold roman}}]
		set fb2 [frame $sad.b2]
		set e2 [entry $fb2.file2 -width 30 -textvariable "Mopac::${base}(fichMOLSaddle2)"]
		set b2 [Button $fb2.b2 -activebackground #a0a0a0 -command "Mopac::manejadorBotFichSaddleMopac $base 2" -helptext "Escoja el Segundo Fichero" -image $Icon::diricon -text "Ayuda"]
		pack $e2 -side left -fill x -expand 1
		pack $b2 -side left -fill x 
		
		pack $label1 -anchor w
		pack $fb1 -fill x
		pack $label2 -anchor w
		pack $fb2 -fill x
		
		
		pack $notebook -fill x -padx 10
		$notebook raise metodo
		#el widget texto
		set framecentd [frame $framecent.down]
		set texto [text $framecentd.text -borderwidth 2 -font {Terminal 9 } -relief raised -yscrollcommand "$framecentd.textscroll set"]
		set mopac(textWM) $texto
		puts $texto
		set scroll [scrollbar $framecentd.textscroll -command "$framecentd.text yview"]
		pack $texto -side left -fill both -expand 1
		pack $scroll -side left -fill y
		pack $framecentd -fill both -expand 1 -padx 10
		

		#botones inferiores
		set framedown [frame .mopacq.framedown -borderwidth 3 -bd 2 -relief raised]
		set buttonEjec [Button $framedown.ok -activebackground #a0a0a0 -command "Mopac::manejadorEjecutarModelizar $base" -helptext "Ejecuta Mopac" -image $Icon::jotaicon]
		set mopac(buttonEjec) $buttonEjec
		set buttonCancel [Button $framedown.cancel -activebackground #a0a0a0 -command "Mopac::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon]
		set buttonAyuda [Button $framedown.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon]
		pack $buttonEjec $buttonAyuda $buttonCancel -side right
		

		#empaquetado
		pack $frameup -side top -fill both 
		pack $frameup2 -side top -fill both 
		pack $framedown -side bottom -fill both 
		pack $framecent -side top -fill both -expand 1 -pady 4
		
		bind $mopac(mainframe) <Destroy> "Mopac::delMopac $base"
		
		
		#inicializo segun los datos disponibles
		if {![file exists $mopac(fichMOL)]} {
			$buttonEjec configure -state disabled
			$ncalc configure -state disabled
		}
		actualizaTextWMopac $base
		focus $mopac(mainframe)
		
		#puts " fich mopac $mopac(fichMOPACCart)"
	}; #finproc
	
	proc manejadorEjecutarModelizar { base } {
		upvar #0 Mopac::$base mopac
		
		set calc 1
		if {[file exists "[file dirname $mopac(fichMOL)]/$mopac(nombreCalculo).mol"] && 
		   ![tk_messageBox -type yesno -message "El calculo \"$mopac(nombreCalculo)\" ya existe\nSi continua se borrara, ¿Esta seguro de que desea continuar?"]} {
			set calc 0
		}
		if {$calc == 1} { manejadorEjecutar $base } else { focus $mopac(mainframe) }
	}; #finproc
	
	
	#devuelve un texto con las keywords que se hayan marcado en la ventana de Modelizacion de MOPAC
	#las opciones por defecto de Mopac y q no son necesarias escribir son : 
	# hamilt -> MNDO,  estado -> RHF, optimizacion -> NONE, uhf_rhf -> UHF
	#la linea de keywords, debe ser separada por un '&'\n, si supera los 60 caracteres de longitud
	proc generaLineaKeywords { base } {
		upvar #0 Mopac::$base mopac
		
		set keywords ""
		set mopac(linea) 1
		#recorro todas las variables agregando las keywords
		set lista 	"$mopac(hamiltoniano) MNDO $mopac(hamiltoniano) \
					 $mopac(estado) SINGLET $mopac(estado) \
					 $mopac(optimizacion) NONE $mopac(optimizacion) \
					 $mopac(uhf_rhf) RHF $mopac(uhf_rhf) \
					 $mopac(carga) 0 \"CHARGE = $mopac(carga)\" \
					 $mopac(gnorm) 1 \"GNORM = $mopac(gnorm)\" \
					 $mopac(iter) 200 \"ITRY = $mopac(iter)\" \
					 $mopac(recalc) NONE \"RECALC = $mopac(recalc)\" \
					 $mopac(geo) N GEO-OK \
					 $mopac(prec) N PRECISE \
					 $mopac(xyz) N XYZ \
					 $mopac(mmok) N MMOK \
					 $mopac(graph) N GRAPH \
					 $mopac(allvec) N ALLVEC \
					 $mopac(mulliken) N MULLIKEN \
					 $mopac(local) N LOCAL \
					 $mopac(bond) N BONDS \
					 $mopac(pi) N PI \
					 $mopac(density) N DENSITY \
					 $mopac(vectors) N VECTORS \
					 $mopac(fock) N FOCK "
					 
		foreach {var def val} $lista { 
			if {![string match $var $def]} {
				set keywords [agregaLineaKeywords $base $keywords $val]
			}
		}
		#una keyword especial es la definida en otros, q puede ser cualquier cosa
		set keywords [agregaLineaKeywords $base $keywords $mopac(otros)]	
		
		return "$keywords"
	}; #finproc
	
	proc agregaLineaKeywords { base lkey keyw } {
		upvar #0 Mopac::$base mopac
		if {[expr [string length $lkey] + [string length $keyw]] > [expr 55 * $mopac(linea)]} {
			incr mopac(linea)
			return "$lkey \+\n$keyw"
		} else {
			return "$lkey $keyw"
		}
	}; #finproc
	
	#actualiza el textWidget de la Modelizacion con Mopac segun las opciones marcadas
	proc actualizaTextWMopac { base } {
		upvar #0 Mopac::$base mopac
		if {[file exists $mopac(fichMOL)] || $mopac(optimizacion) == "SADDLE"} {
			$mopac(buttonEjec) configure -state normal
			
			set ntexto ""
			append ntexto "[generaLineaKeywords $base]\n"

			#inserto los 2 comentarios obligatorios
			if {$mopac(optimizacion) != "SADDLE"} {
				append ntexto "$mopac(fichMOL)\n"
				append ntexto "$mopac(fichMOL)\n"
				
				#Debemos cargar los datos desde fichero, de lo contrario generarlo a partir de
				#el q tenemos escrito en el textW
				
				#debo actualizar el text widget, si es la primera vez o no se han podido calcular algunas de las coordenadas
				#mostraremos las cartesianas. 
				if {$mopac(coordMOPACCart) == "" || $mopac(coordMOPACInt) == ""} {
					set mopac(coordMOPACCart) [Fich::MOLtoMOPACCartesianas $mopac(fichMOL)]
					append ntexto "$mopac(coordMOPACCart)\n"
					#calculo las coordenadas internas
					set int [ calculaCoordenadasCartIntMopac $base $mopac(fichMOL) "int" $mopac(coordMOPACCart)]
					if {$int != -1} { set mopac(coordMOPACInt) $int }
					#si se hubiera pulsado sobre internas, pero estas no se hubieran podido calcular, o es la primera vez entramos
					#mostraremos las cartesianas
					set mopac(int_cart) "car"
				} else {
					if {$mopac(int_cart) == "car"} {
						set coords [devuelveCoordWText $base 0]
						set ncoords [calculaCoordenadasCartIntMopac $base $mopac(fichMOL) "car" $coords]
						if {$ncoords != -1 } {
							set mopac(coordMOPACCart) $ncoords
							set mopac(coordMOPACInt) $coords
						} else {
							# de haber algun problema se kedaran las coordenadas anteriores
							tk_messageBox -icon warning -title "Formato Incorrecto" -message "Imposible realizar la conversion" -parent $mopac(mainframe)
						}
						#debo mostrar las cartesianas a partir de las internas escritas en el textW
						append ntexto "$mopac(coordMOPACCart)\n"
					} else {
						set coords [devuelveCoordWText $base 0]
						set ncoords [calculaCoordenadasCartIntMopac $base $mopac(fichMOL) "int" $coords]
						if {$ncoords != -1 } {
							set mopac(coordMOPACInt) $ncoords
							set mopac(coordMOPACCart) $coords
						} else {
							# de haber algun problema se kedaran las coordenadas anteriores
							tk_messageBox -icon warning -title "Formato Incorrecto" -message "Imposible realizar la conversion" -parent $mopac(mainframe)
						}
						#debo mostrar las internas a partir de las cartesianas escritas en el textW
						append ntexto "$mopac(coordMOPACInt)\n"
					}
				}
			} else {
				#saddle
				#inserto los comentarios
				append ntexto "$mopac(fichMOLSaddle1)\n"
				append ntexto "$mopac(fichMOLSaddle2)\n"

				#insertamos las coordenadas			
				if {[file exists $mopac(fichMOLSaddle1)] && [file exists $mopac(fichMOLSaddle2)]} { 
					set coords [devuelveCoordWText $base 1]
					if {[llength $coords] != 2 || $mopac(coordMOPACCartSaddle1) == "" || $mopac(coordMOPACCartSaddle2) == ""} {	
						set mopac(coordMOPACCartSaddle1) [Fich::MOLtoMOPACCartesianas $mopac(fichMOLSaddle1)]
						set int [calculaCoordenadasCartIntMopac $base $mopac(fichMOLSaddle1) "int" $mopac(coordMOPACCartSaddle1)]
						if {$int != -1} { set mopac(coordMOPACIntSaddle2) $int}
						set mopac(coordMOPACCartSaddle2) [Fich::MOLtoMOPACCartesianas $mopac(fichMOLSaddle2)]
						set int [calculaCoordenadasCartIntMopac $base $mopac(fichMOLSaddle2) "int" $mopac(coordMOPACCartSaddle2)]
						if {$int != -1} { set mopac(coordMOPACIntSaddle2) $int}					
						if {$mopac(int_cart) == "car"} { 
							append ntexto "$mopac(coordMOPACCartSaddle1)"
							append ntexto "0        0.00000  0       0.00000  0       0.00000 0\n"
							append ntexto "$mopac(coordMOPACCartSaddle2)\n"
						} else {
							append ntexto "$mopac(coordMOPACIntSaddle1)\n"
							append ntexto "0        0.00000  0       0.00000  0       0.00000 0\n"
							append ntexto "$mopac(coordMOPACIntSaddle2)\n"
						}
					} else {
						if {$mopac(int_cart) == "car"} {
							set coords1 [lindex $coords 0]
							set coords2 [lindex $coords 1]
							set ncoords1 [calculaCoordenadasCartIntMopac $base $mopac(fichMOLSaddle1) "car" $coords1]
							set ncoords2 [calculaCoordenadasCartIntMopac $base $mopac(fichMOLSaddle1) "car" $coords2]
							
							if {$ncoords1 != -1 && $ncoords2 != -1} {
								set mopac(coordMOPACCartSaddle1) $ncoords1
								set mopac(coordMOPACCartSaddle2) $ncoords2
								set mopac(coordMOPACIntSaddle1) $coords1
								set mopac(coordMOPACIntSaddle2) $coords2
								
								#debo mostrar las cartesianas a partir de las internas escritas en el textW
								append ntexto "$mopac(coordMOPACCartSaddle1)"
								append ntexto "0        0.00000  0       0.00000  0       0.00000 0\n"
								append ntexto "$mopac(coordMOPACCartSaddle2)\n"
							} else {
								# de haber algun problema se kedaran las coordenadas anteriores
								tk_messageBox -icon warning -title "Formato Incorrecto" -message "Imposible realizar la conversion" -parent $mopac(mainframe)
							}
							
						} else {
							set coords1 [lindex $coords 0]
							set coords2 [lindex $coords 1]
							set ncoords1 [calculaCoordenadasCartIntMopac $base $mopac(fichMOLSaddle1) "int" $coords1]
							set ncoords2 [calculaCoordenadasCartIntMopac $base $mopac(fichMOLSaddle1) "int" $coords2]
							
							if {$ncoords1 != -1 && $ncoords2 != -1} {
								set mopac(coordMOPACIntSaddle1) $ncoords1
								set mopac(coordMOPACIntSaddle2) $ncoords2
								set mopac(coordMOPACCartSaddle1) $coords1
								set mopac(coordMOPACCartSaddle2) $coords2
								
								#debo mostrar las cartesianas a partir de las internas escritas en el textW
								append ntexto "$mopac(coordMOPACIntSaddle1)"
								append ntexto "0        0.00000  0       0.00000  0       0.00000 0\n"
								append ntexto "$mopac(coordMOPACIntSaddle2)\n"
							} else {
								# de haber algun problema se kedaran las coordenadas anteriores
								tk_messageBox -icon warning -title "Formato Incorrecto" -message "Imposible realizar la conversion" -parent $mopac(mainframe)
							}
							
						}
					}	
				}
			}
			#reseteo el textWidget
			$mopac(textWM) delete 0.0 end
			$mopac(textWM) insert end $ntexto	
		} else { 
			$mopac(buttonEjec) configure -state disabled
			$mopac(textWM) delete 0.0 end
		}
		
	}; #finproc
	
	#el caso de seleccionar Saddle es especial, y es controlado aki
	proc controlaOptimizacionMopac { base } {
		upvar #0 Mopac::$base mopac
		
		if {$mopac(optimizacion) == "SADDLE"} {
			#activo el nombre 
			$mopac(nombCalculo) configure -state normal
			$mopac(NB) itemconfigure saddle -state normal
			$mopac(NB) raise saddle
		} else {
			$mopac(NB) itemconfigure saddle -state disabled
			if {$mopac(data) == ""} { 
				$mopac(nombCalculo) configure -state disabled 
				#le propongo un nombre para el calculo
				set f1 [string map {".mol" ""} [file tail $fichMOL]]
				set mopac(nombreCalculo) "$f1-mop"
			}
		}
		recomiendaNombreMopac $base
		actualizaTextWMopac $base
		
	}; #finproc
	
	proc manejadorBotFichSaddleMopac { base bot } {
		upvar #0 Mopac::$base mopac
		upvar #0 Conf::$mopac(conf) config
		
		set types { {{Ficheros Mol} {.mol} } }
		if {$bot == 1} {
			#pido fichero
			set filename [tk_getOpenFile -filetypes $types -initialdir $config(dirData) -title "Seleccion Fichero MOL" -parent $mopac(mainframe)]
			if {$filename != ""} { set config(dirData) [file dirname $filename] }
			if {[file exists $filename]} {
			
				#borro los datos q hubiera
				set mopac(nombreCalculo) ""
				Data::delData tempSaddle1
				Data::delData tempSaddle2
				
				set mopac(fichMOLSaddle2) "Defina Fichero 1"
				set mopac(coordMOPACCartSaddle1) ""
				set mopac(coordMOPACIntSaddle1) ""
				
				set mopac(fichMOLSaddle2) "Defina Fichero 2"
				set mopac(coordMOPACCartSaddle2) ""
				set mopac(coordMOPACIntSaddle2) ""
				
				#creo datos segun el fichero 1
				Data::newData tempSaddle1
				set mopac(datafichMOLSaddle1) tempSaddle1
				Fich::leeFichMol $filename tempSaddle1 $mopac(conf)
				set mopac(fichMOLSaddle1) $filename
			}
		} else {
			if {![file exists $mopac(fichMOLSaddle1)]} {
				tk_messageBox -type ok -message "Defina antes el fichero 1" -parent $mopac(mainframe)
			} else {
				#pido fichero
				set filename [tk_getOpenFile -filetypes $types -initialdir $config(dirData) -title "Seleccion Fichero MOL" -parent $mopac(mainframe)]
				if {$filename != ""} { set config(dirData) [file dirname $filename] }
				if {[file exists $filename]} {
					
					#borro datos anteriores
					Data::delData tempSaddle2
					set mopac(fichMOLSaddle2) "Defina Fichero 2"
					set mopac(coordMOPACCartSaddle2) ""
					set mopac(coordMOPACIntSaddle2) ""
					
					Data::newData tempSaddle2
					Fich::leeFichMol $filename tempSaddle2 $mopac(conf)
					set mopac(datafichMOLSaddle2) tempSaddle2
				
					set formula1 [Data::formulaMolecular $mopac(datafichMOLSaddle1)]
					set formula2 [Data::formulaMolecular $mopac(datafichMOLSaddle2)]
					
					if {[string match $formula1 $formula2]} {
						set mopac(fichMOLSaddle2) $filename	
					} else {
						tk_messageBox -type ok -message "Formulas moleculares Distintas" -parent $mopac(mainframe)
					}
				}
			}
		}
		recomiendaNombreMopac $base
		actualizaTextWMopac $base
	}; #finproc
	
	proc recomiendaNombreMopac { base } {
		upvar #0 Mopac::$base mopac
		
		if {$mopac(optimizacion) != "SADDLE" && $mopac(coordMOPACCart) != ""} {
			set f1 [string map {".mol" ""} [file tail $mopac(fichMOL)]]
			set mopac(nombreCalculo) "$f1-mop"
		} elseif {$mopac(optimizacion) == "SADDLE"  && [file exists $mopac(fichMOLSaddle1)] && [file exists $mopac(fichMOLSaddle2)]} {
			set f1 [string map {".mol" ""} [file tail $mopac(fichMOLSaddle1)]]
			set f2 [string map {".mol" ""} [file tail $mopac(fichMOLSaddle2)]]
			set mopac(nombreCalculo) "$f1-$f2-saddle-mop"
		} else {
			set mopac(nombreCalculo) ""
		}
	}; #finproc
	
	#devuelve las coordenadas del widget texto
	#si saddle es 0 devolvera todo el despues de las keywords y las lineas de comentarios
	#si saddle es 1 comprobara el numero de atomos de las moleculas y devolvera una lista de 2 elementos con las coordenadas de 
	#cada una de ellas
	#debemos ser cuidadosos con estos resultados ya q no podemos preveer el contenido al ser poder ser este modificado por el usuario
	proc devuelveCoordWText { base saddle } {
		upvar #0 Mopac::$base mopac
		#debemos evitar las posibles lineas de keywords y los dos comentarios siguientes
		
		#examino la linea de keywords para ver cuantas lineas ocupa, por defecto ocupa 1
		set keys [generaLineaKeywords $base]
		set nkeys [llength [lsearch -all $keys "+"]]
		
		puts $nkeys
		#las coordenadas se situan 1(defecto)+keys(lineas extras)+2(comentarios)+1(la linea siguiente) lineas tras el comienzo del texto
		set n [expr 1 + $nkeys + 2 + 1]
		
		#devuelve x.y, donde x es el numero de lineas, lo cual puedo usarlo directamente como un numero decimal
		set lineas [$mopac(textWM) index end]
		
		if {$saddle == 0} {
			set coords [$mopac(textWM) get $n.0 end]
			return $coords
		} else {
			#calculo en numero de atomos
			upvar #0 Data::tempSaddle1 datos
			if {$lineas < [expr $n + 2 * $datos(numAtomos) + 1]} {
				return -1
			} else {
				set coords1 ""
				set coords2 ""
				
				set coords1 [$mopac(textWM) get "$n.0" "[expr $n + $datos(numAtomos) - 1].end"]
				set coords2 [$mopac(textWM) get "[expr $n + $datos(numAtomos) + 1].0" end]
				return [list "$coords1" "$coords2"]
			}
		}
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#										-	VIBRACIONES   -
#----------------------------------------------------------------------------------------------		
	
	proc ventanaVibraciones { base } {
		upvar #0 Mopac::$base mopac
		
		
		set mopac(mainframe) ".vibrateMop"
		toplevel .vibrateMop
		wm geometry .vibrateMop +250+300
		#wm resizable .scan 0 0
		wm title .vibrateMop "Espectro Vibracional"
		
		#la ventana consta de 3 frames superior e inferior y central
		
		#frame superior
		set frameup [frame .vibrateMop.frameup]
		set frameupa [frame $frameup.frameupa  -borderwidth 3 -bd 2 -relief groove]
		#set combo [ComboBox $frameupa.combo -values $tink(listaVib) -textvariable Tinker::${base}(vibSeleccionada) -justify center]
		set combo [ComboBox $frameupa.combo -values $mopac(listaVib) -textvariable Mopac::${base}(vibSeleccionada) -justify center -hottrack 1]
		$combo setvalue first
		#set modelib [ComboBox $frameup.model -textvariable Tinker::${base}(prog) -values [list Newton Minimizar Optimizar Analizar] -width 15 ]
		set butonayu [Button $frameupa.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon -text "Ayuda"]
		set butonejec [Button $frameupa.ok -activebackground #a0a0a0 -command "Mopac::manejadorBotVibracion $base" -helptext "Mostrar Vibracion" -image $Icon::okicon]
		set butoncanc [Button $frameupa.cancel -activebackground #a0a0a0 -command "Mopac::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon -anchor center]
		set butonelim [Button $frameupa.elim -activebackground #a0a0a0 -command "Mopac::cerrarVibraciones $base" -helptext "Cierra Todas las Ventanas de Vibraciones" -image $Icon::trashicon -anchor center]
		pack $combo -side left -padx 3
		pack $butonejec $butonayu $butoncanc -side left
		pack $butonelim  -side left -fill both
		
		set ima1 [Label $frameup.ima1 -activebackground #a0a0a0 -text "Vibracion --> Frecuencia" -font {Arial 9 {bold roman}} -relief flat -anchor center]
		set ima2 [Label $frameup.ima2 -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		pack $ima1 -side left -padx 50
		pack $frameupa -side left
		#pack $ima2 -side right
		
		
		#frame central
		set framecent [frame .vibrateMop.framecent]
		set mismavent [checkbutton $framecent.mv -offvalue N -onvalue Y -text "Todas en la misma Ventana" -variable Mopac::${base}(mismaVentanaVib)]
		pack $mismavent
		
		
		#frame inferior, consta de un canvas con informacion relativa a las frecuencias calculadas
		set framedown [frame .vibrateMop.framedown -borderwidth 3 -bd 2 -relief groove]
		
		
		set canv $framedown.canv
		set escala [scale $framedown.scale -orient horizontal -from 1 -to 50 -width 10 -command "Mopac::fijarEscalaCanvas $base $canv" -resolution 0.01 -showvalue 0]
		$escala set 1
		
		scrollbar $framedown.hscroll -orient horiz -command "$canv xview"
		#scrollbar .vibrate.can.vscroll -command "$canv yview"	
		set canvas [canvas $canv -relief raised -scrollregion {0 0 74000 220} -width 740 -height 220 -confine 1\
			-xscrollcommand ".vibrateMop.framedown.hscroll set"]
			
		pintaCanvasVib $base $canvas
		
		pack $escala -fill x
		pack $canvas -fill both -expand 1
		pack $framedown.hscroll -fill x

		#empaqueto
		pack $frameup -fill x -ipady 5
		pack $framecent -fill x -ipady 2
		pack $framedown -fill both -expand 1
		
		#le asocio el destructor
		bind $canv <Destroy> "Mopac::delMopac $base"
		focus $mopac(mainframe)
	}; #finproc
	
	#fija el canvas visible segun la escala seleccionada, y lo centra segun la linea q este seleccionada
	proc fijarEscalaCanvas { base canvas escala } {
		upvar #0 Mopac::$base mopac
		
		#1º restauro la escala a 1, y despues escalo por el valor deseado
		$canvas scale all 0 0 [expr 1 /$mopac(escalaAnt)] 1
		$canvas scale all 0 0 $escala 1
		set mopac(escalaAnt) $escala
		
		#ajusto el scroll proporcionalmente a l parte visible del canvas
		$canvas configure -scrollregion [$canvas bbox all]
		
		#si amplio por encima de un factor 10 muestro las lineas ocultas de la escala
		if {$escala > 10} { $canvas itemconfigure lineasoc -state normal
		} else { $canvas itemconfigure lineasoc -state hidden }
		
		#centro el canvas en la linea seleccionada
		set anchoBBox [expr [lindex [$canvas bbox all] 2]-[lindex [$canvas bbox all] 0]]
		set xLinea [lindex [$canvas coords $mopac(lineaCanvasSeleccionada)] 0]
		set scroll [expr ($xLinea - [lindex [$canvas bbox all] 0] - 370) / $anchoBBox]
		$canvas xview moveto $scroll
	}; #finproc
	
	proc pintaCanvasVib { base canvas } {
		upvar #0 Mopac::$base mopac
		
		set plotFont {Helvetica 8}
		
		#creo las lineas de referencia, las frecuencias posibles considerardas estan en el rango [4000..500]
		#pintaremos una linea de referencia cada 50  unidades entre dicho rango, pero inicialmente solo haremos 
		#visbles cada 250
		
		$canvas create line 20 180 720 180 -width 1
		set l [$canvas create line 20 20 720 20 -width 1]
		
		set mopac(lineaCanvasSeleccionada) $l
		
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
		}
		#calculo los dipolos
		
		leerTDipolos $base $mopac(fichMNO)
		#ahora pinto las lineas correspondientes a las vibraciones en el lugar que le correspondan segun su valor
		if {$mopac(listaVib) != -1} {
			foreach elem $mopac(listaVib) {
				set vib [lindex $elem 0]
				set frec [lindex $elem 2]
				
				#solo pinto los mayores de 500, los imaginarios son negativos
				if {[string is double $frec] && $frec <= 4000 && $frec >= 500} {
					puts $frec
					
					#la altura depende de la intensidad del tDipolo
					if {![info exists mopac(tDipolo,$vib)]} {
						set y 180
					} else {
						#calculo la altura
						set y [expr (($mopac(tDipolo,$vib) / $mopac(maxTDipolo)) *140 ) + 40 ]
					}
				
					set x [expr ((4000 - $frec) / 50)*10 + 20]
					set line [$canvas create line $x 20 $x $y -width 1 -fill "dark blue" -activefill green]
					puts $line
					set t [$canvas create text $x 0 -text "$frec" -anchor n -font $plotFont -state hidden]
					$canvas bind $line <ButtonRelease-1> "Mopac::mostrarVibracion $base $vib"
					$canvas bind $line <ButtonRelease-3> "Mopac::fijarLineaCanvasSeleccionada $base $canvas $line"
					$canvas bind $line <Any-Enter> "$canvas itemconfigure $t -state normal"
					$canvas bind $line <Any-Leave> "$canvas itemconfigure $t -state hidden"
				}
			}
		}
	}; #finproc
	
	proc fijarLineaCanvasSeleccionada { base canvas linea } {
		upvar #0 Mopac::$base mopac
		
		$canvas itemconfigure $mopac(lineaCanvasSeleccionada) -fill "dark blue"
		set mopac(lineaCanvasSeleccionada) $linea
		$canvas itemconfigure $linea -fill red
		set xLinea [lindex [$canvas coords $linea] 0]		
	}; #finproc
	
	#devuelve una lista con ternas de la forma {"nº vibracion" "--->" "frecuencia"}
	#correspondientes al fichero fichMol, del cual deben haberse calculado previamente sus vibraciones
	#devolvera -1 si no hay vibraciones en el fichero
	proc devuelveVibraciones { base fichMNO } {
		upvar #0 Mopac::$base mopac
		upvar #0 Data::$mopac(data) datos
		
		set fMNO [open $fichMNO r+]
		
		set contMNO [read $fMNO]
		close $fMNO
		if {![string match "*MASS-WEIGHTED COORDINATE ANALYSIS*" $contMNO] || ![string match "*DESCRIPTION OF VIBRATIONS*" $contMNO]} {
			return -1
		} else {
			set lista [list]
			
			set fMNO [open $fichMNO r+]
		
			gets $fMNO linea
			while {![string match "*MASS-WEIGHTED COORDINATE ANALYSIS*" $linea]} {
				gets $fMNO linea
			}
			
			while {![eof $fMNO]} {		
				while {![eof $fMNO] && ![string match "*ROOT NO.*" $linea]} {
					gets $fMNO linea
				}
				if {![eof $fMNO]} {
					#ignoro la siguiente linea
					gets $fMNO linea
					#la siguiente tiene los valores de las frecuencias
					gets $fMNO linea
					
					#como mucho habra 6 frecuencias en la linea
					set n [scan $linea {%f%f%f%f%f%f} f1 f2 f3 f4 f5 f6]
					#las guardo, e incremento el numero de vibraciones encontradas
					puts -nonewline "\n frecuencias leidas : "
					for {set x 1} {$x <= $n} {incr x} { 
						set i "lappend lista \"[expr $mopac(nVibraciones) + $x] --> \$f$x\""
						eval $i
					}
					incr mopac(nVibraciones) $n
				}
			}
			puts $lista
			close $fMNO
			return $lista
		}
	}; #finproc
	
		
	#lee las vibraciones del fichero MNO proporcionado, y guarda los resultados en base
	proc leerVibracionesMNO { base fileMNO } {
		upvar #0 Mopac::$base mopac
		upvar #0 Data::$mopac(data) datos
		
		
		set fMNO [open $fileMNO r+]
		gets $fMNO linea
		while {![string match "*MASS-WEIGHTED COORDINATE ANALYSIS*" $linea]} {
			gets $fMNO linea
		}
		
		
		#voy buscando lineas q contengan  ROOT NO., tras ellas hay lineas q tienen de 1 a 6 frecuencias
		#y tras ellas la lineas q contienen los valores de desplazamiento para cada atomo en cada una de las
		#3 direcciones del espacio
		#ademas Mopac inserta (arbitrariamente para nosotros) lineas con el caracter 1 en cualkier momento
		#q de deberemos evitar
		
		#busco a traves del resto del fichero
		while {![eof $fMNO]} {		
			while {![eof $fMNO] && ![string match "*ROOT NO.*" $linea]} {
				gets $fMNO linea
			}
			if {![eof $fMNO]} {
				#ignoro la siguiente linea
				gets $fMNO linea
				#la siguiente tiene los valores de las frecuencias
				gets $fMNO linea
				
				#como mucho habra 6 frecuencias en la linea
				set n [scan $linea {%f%f%f%f%f%f} f1 f2 f3 f4 f5 f6]
				#las guardo, e incremento el numero de vibraciones encontradas
				incr mopac(nVibraciones) $n
				puts -nonewline "\n frecuencias leidas : "
				for {set x 1} {$x <= $n} {incr x} { 
					set i "set mopac(frecuVibra,$x) \$f$x"
					set j "puts -nonewline \" \$f$x \" "
					eval $i
					eval $j
				}
				#me situo ante los datos
				gets $fMNO linea
				
				#ahora recopilo la informacion en cada una de las 3 direcciones, para cada atomo y para cada frecuencia
				#las 3 primeras lineas son los los desplazamientos para el atomo 1...
				for {set at 0} {$at < $datos(numAtomos)} {incr at} { 
					for {set dir 0} {$dir < 3} {incr dir} {
						gets $fMNO linea
					
						#evito las lineas "1"
						while {[string match "1" $linea]} {
							gets $fMNO linea
							puts "---> $linea"
						}
						puts $linea
						#ahora estoy ante una linea correcta
						set m [scan $linea {%s%f%f%f%f%f%f} s f1 f2 f3 f4 f5 f6]
						
						for {set x 1} {$x <= [expr $m - 1]} {incr x} {
							set i "set mopac(despVibra,[expr \$mopac(nVibraciones) - \$n + $x],\$at,\$dir) \$f$x"
							#set j "puts \"mopac(despVibra,[expr \$mopac(nVibraciones) - \$n + \$x],\$at,\$dir) \$f$x \""
							eval $i
						}
					}
				}
			}
		}
		close $fMNO
		return $mopac(nVibraciones)
	}; #finproc
	
	#lee los dipolos de fileMNO  y los guarda en base(tDipolo,numeroVibracion)
	proc leerTDipolos { base fileMNO } {
		upvar #0 Mopac::$base mopac
		
		set fMNO [open $fileMNO r+]
		
		gets $fMNO linea
		while {![eof $fMNO] && ![string match "*DESCRIPTION OF VIBRATIONS*" $linea]} {
			gets $fMNO linea
		}
		
		if {![eof $fMNO]} {
			while {![eof $fMNO]} {
				gets $fMNO linea
				if {[string match "*VIBRATION*" $linea]} {
					#encuentro una vibracion con su dipolo, actualizo los datos
					set vib [string trim [string range $linea 10 14]]
					#consumo dos lineas mas
					gets $fMNO linea ; gets $fMNO linea
					set tdipole [string trim [string range $linea 9 18]]
					
					if {$tdipole > $mopac(maxTDipolo)} { set mopac(maxTDipolo) $tdipole}
					set mopac(tDipolo,$vib) $tdipole
					puts "mopac(tDipolo,$vib) $tdipole"
				}
			}
		}	
	}; #finproc
	
	proc escribirVibracionMopac { base baseData numVib nombreFich } {
		upvar #0 Mopac::$base mopac
		upvar #0 Data::$baseData datos
		upvar #0 Conf::$mopac(conf) config
		
		set fVib [open $nombreFich w+]
		
		#defino cuantos frames kiero en la vibracion
		set frames 10
		set factor 10
		for {set f -$frames} {$f < $frames} {incr f 5} {
			puts $fVib "$datos(numAtomos)"
			puts $fVib "$frames"
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				set cx [expr $datos(coordX,$x) + ($mopac(despVibra,$numVib,$x,0) * $f / (2 * $frames)) + $factor]
				set cy [expr $datos(coordY,$x) + ($mopac(despVibra,$numVib,$x,1) * $f / (2 * $frames)) + $factor]
				set cz [expr $datos(coordZ,$x) + ($mopac(despVibra,$numVib,$x,2) * $f / (2 * $frames)) + $factor]
				puts $fVib [format "%-3s % 11.6f % 11.6f % 11.6f" $datos(simbolo,$x) $cx $cy $cz]
			}
		}
		close $fVib
	}; #finproc
	
	proc manejadorBotVibracion { base } {
		upvar #0 Mopac::$base mopac
		mostrarVibracion $base [lindex $mopac(vibSeleccionada) 0]
	}; #finproc
	
	proc mostrarVibracion { base vibracion } {
		upvar #0 Mopac::$base mopac
		upvar #0 Data::$mopac(data) datos
		upvar #0 Conf::$mopac(conf) config		
		
		set f1 [string map {".mol" ""} [file tail $mopac(fichMOL)]]
		set ext [format "%03d" $vibracion]
		set filename "[file dirname $mopac(fichMNO)]/VIBRATE/$f1.$ext"
		puts $filename
		
		#creamos una ventana le asociamos el fichero vibration.htm, q carga el fichero alpha.xyz, y lo representa con el plugin de CHIME
		#copio a temporal el htm
		file copy -force $filename "$config(dirTemp)alpha.xyz"
		
		set htm "$config(dirTemp)vibration.htm"
		file copy -force "$config(dirCHM)vibration.htm" $htm
		

		if {$mopac(mismaVentanaVib) == "N" } { incr mopac(semillaVib) }
		set win ".vibrationMop$mopac(semillaVib)"
		if {[winfo exists $win] == 1} {
			destroy $win
		} 
		toplevel $win
		wm title $win "Vibracion nº: $vibracion de $mopac(fichMOL) - BrandyMol"
		set visorChime [optcl::new -window $win.visor "$config(dirTemp)vibration.htm"]
		$win.visor config -width 400 -height 400
		pack $win.visor -expand  1 -fill both -side bottom
		focus $win
	}; #finproc
	
	proc cerrarVibraciones { base } {
		upvar #0 Mopac::$base mopac
		
		for {set x 0} {$x <= $mopac(semillaVib)} {incr x} {
			if {[winfo exists ".vibrationMop$x"]} { destroy ".vibrationMop$x"}
		}
	}; #finproc

#----------------------------------------------------------------------------------------------
#										-	CARGAS   -
#----------------------------------------------------------------------------------------------		
	
	proc mostrarCargasCHIME { base } {
		upvar #0 Mopac::$base mopac
		upvar #0 Data::$mopac(data) datos
		upvar #0 Conf::$mopac(conf) config
		
		
		#1º compruebo si existen cargas para el fichero
		#busco su fichero mno
		set f1 [string map {".mol" ""} [file tail $mopac(fichMOL)]]
		set filemno "[file dirname $mopac(fichMOL)]/Almacen/$f1/Mopac/$f1.mno"
		
		if {[file exists $filemno]} {
			set lcargas [Fich::ultimasCargasMOPAC $filemno $mopac(fichMOL)]
			Data::actualizaCargasParciales $mopac(data) $lcargas
		}
		
		
		if {$datos(cargasParcialesCalculadas) == 0} {
			tk_messageBox -type ok -message "No se han calculado las cargas, ejecute Mopac e intentelo de nuevo"
			
		} else {
			#creo un fichero con formato adecuado para CHIME con cargas
			set alpha [open "$config(dirTemp)alpha.xyz" w+]
			
			puts $alpha $datos(numAtomos)
			puts $alpha " "
			
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				puts $alpha [format "%s %9.4f %9.4f %9.4f %9.4f" $datos(simbolo,$x) $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x) $datos(cargaParcial,$x)]
			}
			close $alpha
			
			#creamos una ventana le asociamos el fichero cargas.htm, q carga el fichero alpha.xyz, y lo representa con el plugin de CHIME
			#copio a temporal el htm
			set htm "$config(dirTemp)carga.htm"
			file copy -force "$config(dirCHM)carga.htm" $htm
			
			set win ".cargas"
			if {[winfo exists $win] == 1} then {
				destroy $win
			} 
			toplevel $win
			wm title $win "Distribucion de Cargas para $mopac(fichMOL) - BrandyMol"
			set visorChime [optcl::new -window $win.visor "$config(dirTemp)carga.htm"]
			$win.visor config -width 400 -height 400
			pack $win.visor -expand  1 -fill both -side bottom
		}
		delMopac $base
	};
	
#----------------------------------------------------------------------------------------------
#										-	ORBITALES   -
#----------------------------------------------------------------------------------------------		
		
	proc ventanaOrbitales { base } {
		upvar #0 Mopac::$base mopac
		
		set mopac(mainframe) ".orbitMop"
		toplevel .orbitMop
		#wm geometry .orbitMop +250+300
		#wm resizable .scan 0 0
		wm title .orbitMop "Orbitales Moleculares"
		

		#frame superior
		set frameup [frame .orbitMop.frameup]
		set frameupa [frame $frameup.frameupa  -borderwidth 3 -bd 2 -relief groove]
		#set combo [ComboBox $frameupa.combo -values $mopac(listaVib) -textvariable Mopac::${base}(vibSeleccionada) -justify center]
		set combo [ComboBox $frameupa.combo -values $mopac(listaOrb) -textvariable Mopac::${base}(orbSeleccionado) -justify center -hottrack 1]
		$combo setvalue first
		set butonayu [Button $frameupa.ayuda -activebackground #a0a0a0 -helptext "Ayuda" -image $Icon::ayudicon -text "Ayuda"]
		set butonejec [Button $frameupa.ok -activebackground #a0a0a0 -command "Mopac::manejadorBotonOrbital $base" -helptext "Mostrar Orbittal" -image $Icon::okicon]
		set butoncanc [Button $frameupa.cancel -activebackground #a0a0a0 -command "Mopac::manejadorCancelar $base" -helptext "Cancelar" -image $Icon::cancelicon -anchor center]
		set butonelim [Button $frameupa.elim -activebackground #a0a0a0 -command "Mopac::cerrarOrbitales $base" -helptext "Cierra Todas las Ventanas de Vibraciones" -image $Icon::trashicon -anchor center]
		pack $combo -side left -padx 3
		pack $butonejec $butonayu $butoncanc -side left
		pack $butonelim  -side left -fill both
		
		set ima1 [Label $frameup.ima1 -activebackground #a0a0a0 -text "Orbitales : " -font {Arial 9 {bold roman}} -relief flat -anchor center]
		set ima2 [Label $frameup.ima2 -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
		pack $ima1 -side left -padx 50
		pack $frameupa -side left
		#pack $ima2 -side right
		
		
		#frame central
		set framecent [frame .orbitMop.framecent]
		set mismavent [checkbutton $framecent.mv -offvalue N -onvalue Y -text "Todas en la misma Ventana" -variable Mopac::${base}(mismaVentanaOrb)]
		pack $mismavent
		
		#frame inferior, consta de un canvas con informacion relativa a las frecuencias calculadas, y una de opciones
		set framedown [frame .orbitMop.framedown -borderwidth 3 -bd 2 -relief groove]
		
		set f1 [frame $framedown.f1]
		set canv $f1.canv
		set escala [scale $f1.scale -orient vertical -from 1 -to 100 -width 10 -resolution 0.01 -command "Mopac::fijarEscalaCanvasOrb $base $canv" -showvalue 0]
		$escala set 1
		
		scrollbar $f1.vscroll -orient vertical -command "$canv yview"	
		set canvas [canvas $canv -relief raised -scrollregion {0 0 300 60000} -width 300 -height 350 -confine 1\
			-yscrollcommand "$f1.vscroll set"]
		pintaCanvasOrb $base $canvas
		
		pack $escala -fill y -side left
		pack $canvas -fill both -expand 1 -side left
		pack $f1.vscroll -fill y -side left
		
		
		set f2 [frame $framedown.f2]
		
		set f3 [frame $f2.f3]
		set l1 [Label $f3.l1 -activebackground #a0a0a0 -text "Orbitales Moleculares " -font {Arial 12 {bold roman}} -relief flat -anchor center]
		set iso [ LabelEntry $f3.estruc -labelfont {Arial 10 {bold roman}} -label "\[0..60\]    : " -textvariable Mopac::${base}(isovalor) -side left -justify right]
		pack $l1 
		#pack $iso		
		pack $f3 -padx 5 -pady 5
		
		set f4 [frame $f2.f4]
		set l2 [Label $f4.l2 -activebackground #a0a0a0 -text "RESOLUCION : " -font {Arial 12 {bold roman}} -relief flat -anchor center]
		set resA [ radiobutton $f4.resA  -text "Alta" -value A -variable Mopac::${base}(resolucion)]
		set resM [ radiobutton $f4.resM  -text "Media" -value M -variable Mopac::${base}(resolucion)]
		set resB [ radiobutton $f4.resB  -text "Baja" -value B -variable Mopac::${base}(resolucion)]
			
		#pack $l2 -anchor n
		#pack $resA $resM $resB -anchor s -side left
		
		#pack $f4 -padx 5 -pady 5
		
		#set f4 [frame $f2.f4 -borderwidth 3 -bd 2 -relief groove] -borderwidth 3 -bd 2 -relief groove]
		set l3 [Label $f2.lb1 -image $Icon::orbitalphotoicon]
		pack $l3 -fill both -expand 1 -padx 5 -pady 5
		
		pack $f1 -side left -fill both -expand 1 -padx 5 -pady 5
		pack $f2 -side left -fill both -expand 1 -padx 5 -pady 5
		
		#empaqueto
		pack $frameup -fill x -ipady 5 -padx 10
		pack $framecent -fill x -ipady 2
		pack $framedown -fill both -expand 1 -padx 10 -pady 10
		
		
		#le asocio el destructor
		bind $mopac(mainframe) <Destroy> "Mopac::delMopac $base"
		focus $mopac(mainframe)
	}; #finproc
	
	proc pintaCanvasOrb { base canvas } {
		upvar #0 Mopac::$base mopac

		set plotFont { Helvetica 8 }
		
		#flecha roja
		$canvas create line 55 0 55 330 -width 1 -fill red -arrow first
		#linea 0
		set distancia [expr [lindex $mopac(listaOrb) end] - [lindex $mopac(listaOrb) 0]]
		set cero [expr ((([lindex $mopac(listaOrb) end]) / $distancia ) *310 ) + 20]
		$canvas create line 30 $cero 250 $cero -width 1 -fill red -dash ","
		
		
		#pinto lineas de referencia
		#set max [lindex $mopac(listaOrb) end]
		#set min [lindex $mopac(listaOrb) 0]
		$canvas create line 262 20 262 330 -width 1 -fill black
		for {set x 20.0} {$x <= 330.0} {set x [expr $x + 51.66]} {
			set val [expr - ((  (  ( $x - 20 ) / 310 ) * $distancia  )  - [lindex $mopac(listaOrb) end] )]
			#set altura [expr ((([lindex $mopac(listaOrb) end] - $val) / $distancia ) * 310 ) + 20]
			$canvas create line 258 $x 263 $x -width 1 -fill black 
			$canvas create text 280 $x -text [expr round($val / 0.02) * 0.02] -anchor n -font $plotFont
		}
		
		
		
		
		for {set x 30} {$x < 340} {incr x 10} {
			#set mopac(lineaCanvasSeleccionada)  [$canvas create line 55 $x 250 $x -width 1 -fill blue -dash {,}]
		}
		
		#pintare una linea por cada orbital, segun su energia, pero en el caso que el valor de dos orbitales difiera en menos de
		#0.02, los pintare a la misma altura pero separados, en caso de distar 0.02 con mas de 1 valor, es decir, varias lineas en
		#la q se se cumplirira la premisa, se asociara a la 1º q se encuentre, q sera la de menor energia
		
		#creo uan lista de valores redondeados
		set listaRedond [list]
		foreach e $mopac(listaOrb) {
			lappend listaRedond [expr round($e / 0.02) * 0.02]
		}
		puts $listaRedond
		
		#genero una lista de listas de listas, donde cada elemento sera una lista de listas q contienen valor de orbital y color de la linea
		#y q estaran agrupados si sus valores distan menos de 0.02 entre ellos
		
		
		
		set ocupados $mopac(ocupados)
		
		set lista [list]
		set color "dark blue"
		#el primer elemento entra siempre solo
		
		set x 0
		if {$ocupados > 0} {incr ocupados -1} else { set color "dark green" }
		lappend lista [list [list [lindex $mopac(listaOrb) $x] $color]]
		set listaRedond [lreplace $listaRedond 0 0]
		
		while {[llength $listaRedond] > 0} {
			incr x
			
			#el elemento a considerar
			set e [lindex $listaRedond 0]
			
			#el 1º valor de la ultima sublista
			set n [lindex [lindex [lindex $lista end] 0] 0]
			
			if {$ocupados > 0} {incr ocupados -1} else { set color "dark green" }
			if {[expr abs($e - $n)] <=  0.02} {
				#agrego en la ultima lista
				set sb [lindex $lista end]
				set lista [lreplace $lista end end]
				lappend lista [linsert $sb end [list [lindex $mopac(listaOrb) $x] $color]]
			} else {
				#agrego como elemento nuevo
				lappend lista [list [list [lindex $mopac(listaOrb) $x] $color]]
			}
			set listaRedond [lreplace $listaRedond 0 0]	
		}
		
		#pinto las lineas en el canvas
		#mitad de la separacion entre lineas
		set separ 10
		#ancho de una linea simple (estando ella sola) de 55 a 255 en pixeles
		set ancho 200
		set num 0
		foreach e $lista {
			#siendo e una lista de orbitales q compartiran la misma linea
			#veo cuantos trozos salen
			set n [llength $e]
			#para cada segmento
			for {set x 0} {$x < $n} {incr x} {
				incr num
				set ini [expr 55 + ($ancho / $n) * $x]
				set fin [expr 55 + (($ancho / $n) * ($x + 1)) - $separ]
				
				
				set val [expr round([lindex [lindex $e $x] 0] / 0.02) * 0.02 ]
				set altura [expr ((([lindex $mopac(listaOrb) end] - $val) / $distancia ) * 310 ) + 20]
				set line [$canvas create line $ini $altura $fin $altura -width 1 -fill "[lindex [lindex $e $x] 1]" -activefill green]
				
				set t [$canvas create text 25 $altura -text $val -anchor n -font $plotFont -state hidden]
				$canvas bind $line <ButtonRelease-1> "Mopac::mostrarOrbital $base $num"
				$canvas bind $line <ButtonRelease-3> "Mopac::fijarLineaCanvasSeleccionadaOrb $base $canvas $line \"[lindex [lindex $e $x] 1]\""
				$canvas bind $line <Any-Enter> "$canvas itemconfigure $t -state normal"
				$canvas bind $line <Any-Leave> "$canvas itemconfigure $t -state hidden"
			}
			set mopac(lineaCanvasSeleccionadaOrb) $line
			set mopac(colorUltimalineaCanvasSeleccionadaOrb) "[lindex [lindex $e $x] 1]"
		}
	}; #finproc
	
	#fija el canvas visible segun la escala seleccionada, y lo centra segun la linea q este seleccionada
	proc fijarEscalaCanvasOrb { base canvas escala } {
		upvar #0 Mopac::$base mopac
		
		#1º restauro la escala a 1, y despues escalo por el valor deseado
		$canvas scale all 0 0 1 [expr 1 /$mopac(escalaAntOrb)]
		$canvas scale all 0 0 1 $escala
		set mopac(escalaAntOrb) $escala
		
		#ajusto el scroll proporcionalmente a l parte visible del canvas
		$canvas configure -scrollregion [$canvas bbox all]
		
		#si amplio por encima de un factor 10 muestro las lineas ocultas de la escala
		if {$escala > 10} { $canvas itemconfigure lineasoc -state normal
		} else { $canvas itemconfigure lineasoc -state hidden }
		
		#centro el canvas en la linea seleccionada
		set altoBBox [expr [lindex [$canvas bbox all] 3]-[lindex [$canvas bbox all] 1]]
		set xLinea [lindex [$canvas coords $mopac(lineaCanvasSeleccionadaOrb)] 1]
		set scroll [expr ($xLinea - [lindex [$canvas bbox all] 1] - 50) / $altoBBox]
		$canvas yview moveto $scroll
	}; #finproc
	
	proc fijarLineaCanvasSeleccionadaOrb { base canvas linea color } {
		upvar #0 Mopac::$base mopac
		
		$canvas itemconfigure $mopac(lineaCanvasSeleccionadaOrb) -fill "$mopac(colorUltimalineaCanvasSeleccionadaOrb)"
		set mopac(lineaCanvasSeleccionadaOrb) $linea
		set mopac(colorUltimalineaCanvasSeleccionadaOrb) $color
		$canvas itemconfigure $linea -fill red
		#set xLinea [lindex [$canvas coords $linea] 0]		
	}; #finproc
	
	#busco y devuelvo los eigenvalores, -1 en caso de no existir
	proc devuelveOrbitales { base filemno } {
		
		set fMNO [open $filemno r+]
		set content [read $fMNO]
		close $fMNO
		
		if {[string match "*EIGENVALUES*" $content]} {
			#existe, me situo en su linea
			set fMNO [open $filemno r+]
			
			gets $fMNO linea
			while {![string match "*EIGENVALUES*" $linea]} {
				gets $fMNO linea
			}
			#consumo 1 linea nula
			gets $fMNO linea
			
			#consumo la 1º liena de datos
			gets $fMNO linea
			
			set lista [list]
			while {![eof $fMNO] && $linea != ""} {
				#leo una linea q contiene orbitales
				set n [scan $linea {%f%f%f%f%f%f%f%f} f1 f2 f3 f4 f5 f6 f7 f8]
				for {set x 1} {$x <= $n} {incr x} { 
					set i "lappend lista \"\$f$x\""
					eval $i
				}
				gets $fMNO linea
			}
			close $fMNO
			return $lista
		} else {
			return -1
		}
	}; #finproc
	
	# el numero de orbitales ocupados, o parcialmente ocupados, se puede mostrar en diferentes formatos
	#segun el calculo se haya realizado con UHF o RHF
	proc devuelveNumeroOrbitalesOcupados { base filemno } {
		upvar #0 Mopac::$base mopac
		
		set res 0
		
		set fMNO [open $filemno r+]
		
		gets $fMNO linea
		
		while {![eof $fMNO] && ![string match "*RHF CALCULATION, NO. OF DOUBLY OCCUPIED LEVELS*" $linea] && \
							   ![string match "*UHF CALCULATION, NO. OF ALPHA ELECTRONS*" $linea]} {
			gets $fMNO linea
			puts $linea
		}
		
		if {![eof $fMNO]} {
			#encontrado una de las 2 lineas anteriores
			if {[string match "*RHF CALCULATION, NO. OF DOUBLY OCCUPIED LEVELS*" $linea]} {
				#calculo realizado con rhf
				set n [scan [string trim $linea] {%[A-Z,.= ]%i} f1 f2]
				if {$n == 2} {
					incr res $f2
					#compruebo si hay orbitales parcialmente ocupados
					#consumo 2 lineas
					gets $fMNO linea ; gets $fMNO linea
					if {[string match "*NO. OF SINGLY OCCUPIED LEVELS*" $linea]} {
						puts "----$linea"
						set n [scan [string trim $linea] {%[A-Z.= ]%i} f1 f2]
						#puts "$linea ---- $n, $f2"
						if {$n == 2} { incr res $f2 }
					}
				}
			} else {
				#calculo realizado con uhf
				if {[string match "*UHF CALCULATION, NO. OF ALPHA ELECTRONS*" $linea]} {
					#calculo realizado con uhf
					set n [scan [string trim $linea] {%[A-Z,.= ]%i} f1 f2]
					if {$n == 2} {
						incr res $f2
						#compruebo si hay orbitales parcialmente ocupados
						#consumo 2 lineas
						gets $fMNO linea
						if {[string match "*NO. OF BETA  ELECTRONS*" $linea]} {
							puts "----$linea"
							set n [scan [string trim $linea] {%[A-Z.= ]%i} f1 f2]
							#puts "$linea ---- $n, $f2"
							if {$n == 2} { incr res $f2 }
						}
						set res [expr ($res / 2) + ($res % 2)]
					}
				}
			}
		}
		close $fMNO
		return $res
	}; #finproc
	
	proc manejadorBotonOrbital { base } {
		upvar #0 Mopac::$base mopac
		
		mostrarOrbital $base [expr [lsearch -exact $mopac(listaOrb) $mopac(orbSeleccionado)] + 1]
	}; #finproc
	
	proc mostrarOrbital { base orbital } {
		upvar #0 Mopac::$base mopac
		upvar #0 Conf::$mopac(conf) config
		
		set f1 [string map {".mol" ""} [file tail $mopac(fichMOL)]]
		
		#calculo de datos para vtk
		catch { file delete -force $config(dirTemp) }
		file mkdir $config(dirTemp)
		
		#copio el ejecutable de plobran
		file copy -force "$config(dirBin)PLOBRAN.exe" "$config(dirTemp)PLOBRAN.exe"
		#copio el gpt y lo renombro
		file copy -force "[file dirname $mopac(fichMOL)]/Almacen/$f1/Mopac/GRAPH/$f1.gpt" "$config(dirTemp)FOR013"
		set fMOLOrig "$config(dirTemp)[file tail $mopac(fichMOL)]"
		file copy -force "$mopac(fichMOL)" $fMOLOrig
		
		
		cd "$config(dirTemp)"
		exec "$config(dirTemp)PLOBRAN.exe" "$orbital"
		cd "$config(dirBin)"
		
		#tengo un archivo llamado CGRAPH.COR, con las ultimas coordenadas actualizadas del fichero gpt
		#tengo q crear un mol, con la info del original y estas coords
		#y cargar este nuevo fichero y el borb.vtk, q tb se habra generado
		
		set fileVTK "$config(dirTemp)/borb.vtk"
		#set fileMOL "$mopac(dirTemp)/"
		if {[file exists "$fileVTK"] && [file exists "$config(dirTemp)CGRAPH.COR"]} {
			
			set fRes [Fich::COORGRAPHtoMOL "$config(dirTemp)CGRAPH.COR" $fMOLOrig]
			
			#mostrar la ventana
			if {$mopac(mismaVentanaOrb) == "N" } { incr mopac(semillaOrb) }
			set win ".orbital_$mopac(semillaOrb)"
			set visor "visorMopac$mopac(semillaOrb)"
			puts $visor
			set data "${visor}data"
			if {[winfo exists $win] == 1} {
				#destruir visor y datos del mismo
				VisorVTK::delVisorVTK $visor
				Data::delData $data
				destroy $win
			} 
			#creo la ventana
			toplevel $win
			wm title $win "Orbital nº: $orbital de $mopac(fichMOL) - BrandyMol"
		
			
			set frameup [frame $win.fup]
			set ima1 [Label $frameup.ima1 -activebackground #a0a0a0 -text "Orbital Molecular" -font {Arial 13 {bold roman}} -relief flat -anchor center]
			set ima2 [Label $frameup.ima2 -activebackground #a0a0a0 -text "BrandyMol 1.0" -font {Arial 18 {bold roman}} -relief flat -anchor center]
			pack $ima1 -side left -pady 5 -padx 5
			#pack $ima2 -side right -pady 5
			
			#frame superior 2
			set frameup2 [frame $win.fup2]
			set buttonSaveImage [Button $frameup2.save -activebackground #a0a0a0 -command "Mopac::manejadorGuardarImagenComo $mopac(semillaOrb) $mopac(conf)" -helptext "Guardar Imagen Como" -image $Icon::camaraicon]
			
			#representacion
			set sep1 [Separator $frameup2.sepa1 -orient vertical]
			set butEjes [Button $frameup2.ejes -activebackground #a0a0a0 -command "Mopac::manejadorEjes $mopac(semillaOrb) $mopac(conf)" -helptext "Mostrar/Quitar Ejes" -image $Icon::ejesicon] 
			$butEjes configure -command "Mopac::manejadorEjes $mopac(semillaOrb) $butEjes"
			#set butTrans [Button $frameup2.trans -activebackground #a0a0a0 -command "Mopac::manejadorTransparencia $frameup2.trans $mopac(semillaOrb)" -helptext "Activar/Desactivar Transparencia" -image $Icon::cancelicon]
			#set sep2 [Separator $frameup2.sepa2 -orient vertical]
			#set butSurf [Button $frameup2.surf -activebackground #a0a0a0 -helptext "Representar en en Superficie" -image $Icon::cancelicon -relief sunken]
			#set butWire [Button $frameup2.wire -activebackground #a0a0a0 -helptext "Representar en Wireframe" -image $Icon::cancelicon]
			#set butPoint [Button $frameup2.point -activebackground #a0a0a0 -helptext "Representar en Puntos" -image $Icon::cancelicon]
			
			#set listRepre [list [list $butSurf $butWire $butPoint]]
			#$butSurf configure -command "Mopac::manejadorRepresentacion $listRepre $mopac(semillaOrb) 0"
			#$butWire configure -command "Mopac::manejadorRepresentacion $listRepre $mopac(semillaOrb) 1"
			#$butPoint configure -command "Mopac::manejadorRepresentacion $listRepre $mopac(semillaOrb) 2"
			
			#luces
			#set sep3 [Separator $frameup2.sepa3 -orient vertical]
			#set butLight1 [Button $frameup2.light1 -activebackground #a0a0a0 -command "Mopac::manejadorLuces $frameup2.light1 0 $mopac(semillaOrb)" -helptext "Activar/Desactivar Luz 1" -image $Icon::cancelicon]
			#set butLight2 [Button $frameup2.light2 -activebackground #a0a0a0 -command "Mopac::manejadorLuces $frameup2.light2 1 $mopac(semillaOrb)" -helptext "Activar/Desactivar Luz 2" -image $Icon::cancelicon]
			#set butLight3 [Button $frameup2.light3 -activebackground #a0a0a0 -command "Mopac::manejadorLuces $frameup2.light3 2 $mopac(semillaOrb)" -helptext "Activar/Desactivar Luz 3" -image $Icon::cancelicon]
			
			#set sep4 [Separator $frameup2.sepa4 -orient vertical]
			#set butProy [Button $frameup2.proy -activebackground #a0a0a0 -command "Mopac::manejadorProyeccion $frameup2.proy $mopac(semillaOrb)" -helptext "Proyeccion Paralela/Conica" -image $Icon::cancelicon]			
			
			
			set sep5 [Separator $frameup2.sepa5 -orient vertical]
			set butMostM [Button $frameup2.mostM -activebackground #a0a0a0 -command "Mopac::manejadorMostrarOcultarMol $frameup2.mostM $mopac(semillaOrb)" -helptext "Mostrar/Ocultar Molecula" -image $Icon::metanosemitransicon]			
			
			set sep6 [Separator $frameup2.sepa6 -orient vertical]
			set butColor [Button $frameup2.color -activebackground #a0a0a0 -command "Mopac::manejadorColorFondo $mopac(semillaOrb)" -helptext "Cambiar el Color de Fondo" -image $Icon::coloricon]			
			
			pack $buttonSaveImage -side left
			#pack $sep1 -side left -padx 5
			pack $butEjes -side left
			#pack $butTrans -side left
			#pack $sep2 -side left -padx 5
			#pack $butSurf $butWire $butPoint -side left 
			#pack $sep3 -side left -padx 5
			#pack $butLight1 $butLight2 $butLight3 -side left 
			#pack $sep4 -side left -padx 5
			#pack $butProy -side left
			#pack $sep5 -side left -padx 5
			pack $butMostM -side left
			#pack $sep6 -side left -padx 5
			pack $butColor -side left
			
			
			set framedown [frame $win.fdown -borderwidth 3 -bd 2 -relief groove]
			set escala [scale $framedown.scale -orient vertical -from 0 -to 256 -width 10 -resolution 1 -command "VisorVTK::modificarIsovalorOrbital $visor ${visor}orb" -showvalue 1]
			$escala set 50
			pack $escala -padx 5 -side left -fill y
			
			
			#el visor
			VisorVTK::newVisorVTK $visor
			VisorVTK::inicializarVisor $visor
			VisorVTK::inicializarLookupTable $visor $mopac(conf)
			
			#creo un widget que contendra un renderer y se lo asocio al Widget de Tk
			set vtkw [VisorVTK::devuelveRenderWindow $visor]
			set vtkWidg [vtkTkRenderWidget $framedown.visor -rw $vtkw]
			#le asocio los eventos
			::vtk::bind_tk_render_widget $vtkWidg
			VisorVTK::actualizaInteractorOrb $visor $mopac(conf)
			
			
			pack $vtkWidg -expand 1 -fill both -side right
			
			#empaketo
			pack $frameup -fill x
			pack $frameup2 -fill x -padx 5
			
			pack $framedown -fill both -expand 1 -padx 5 -pady 5
			
			#cargo los datos
			Data::newData $data
			Fich::leeFichMol $fRes $data $mopac(conf)
			VisorVTK::cargaVisorMolData $visor $data $mopac(conf)
			VisorVTK::cargarOrbitalFich $visor $fileVTK "${visor}orb"

			#manejadores
			bind $escala <Destroy> "VisorVTK::delVisorVTK $visor"
			bind $vtkWidg <Enter> {}
			bind $win <MouseWheel> "VisorVTK::manejadorScroll $visor %D"
			
			#manejador del 2º Boton
			bind $vtkWidg <ButtonPress-3>  {}
			bind $vtkWidg <ButtonRelease-3>  "Mopac::menuContextualOrbital $mopac(semillaOrb)"
			
			focus $win

		}
		
	}; #finproc
	
	proc menuContextualOrbital { numOrbital } {
		set win ".orbital_$numOrbital"
		set visor "visorMopac$numOrbital"
		
		#defino el menu contextual
		
		if {[winfo exists $win.menuContex]} {destroy $win.menuContex}
			set menu [menu $win.menuContex -tearoff 0]
			#$menu add command -label "Guardar Imagen Como" -command "Mopac::manejadorColorFondo $numOrbital"
			#$menu add command -label "Mostrar/Ocultar Ejes" -command "Mopac::manejadorColorFondo $numOrbital"
			#$menu add command -label "Mostrar/Ocultar Molecula" -command "Mopac::manejadorColorFondo $numOrbital"
			#$menu add command -label "Cambiar Color Fondo" -command "Mopac::manejadorColorFondo $numOrbital"
			$menu add command -label "Proyeccion Paralela/Conica" -command "Mopac::manejadorProyeccion $numOrbital"
			$menu add command -label "Activar/Desactivar Transparencia" -command "Mopac::manejadorTransparencia $numOrbital"
			$menu add command -label "Activar/Desactivar Luz Especular" -command "VisorVTK::activarDesactivarEspecularOrbital $visor ${visor}orb"
			$menu add cascade -label "Resolucion" -menu $menu.res
				set res [menu $menu.res -tearoff 0]
				$res add command -label "Baja" -command "Mopac::cambiarResolucion $numOrbital B"
				$res add command -label "Media" -command "Mopac::cambiarResolucion $numOrbital M"
				$res add command -label "Alta" -command "Mopac::cambiarResolucion $numOrbital A"
				$res add command -label "Ultra" -command "Mopac::cambiarResolucion $numOrbital U"
			$menu add cascade -label "Representacion" -menu $menu.rep
				set rep [menu $menu.rep -tearoff 0]
				$rep add command -label "Surface" -command "Mopac::manejadorRepresentacion $numOrbital 0" 
				$rep add command -label "Wireframe" -command "Mopac::manejadorRepresentacion $numOrbital 1"
				$rep add command -label "Points" -command "Mopac::manejadorRepresentacion $numOrbital 2"
			#	$rep add radio -label "Ultra" -variable "GUI::${base}(resolucion)" -value "U" -command "GUI::cambiarResolucion $base"
			#$menu add command -label "Guardar como Imagen" -command "GUI::manejadorGuardarImagenComo $base"	
			$menu add cascade -label "Luces" -menu $menu.luz
				set luz [menu $menu.luz -tearoff 0]
				$luz add command -label "Luz 1" -command "Mopac::manejadorLuces $numOrbital 0"
				$luz add command -label "Luz 2" -command "Mopac::manejadorLuces $numOrbital 1"
				$luz add command -label "Luz 3" -command "Mopac::manejadorLuces $numOrbital 2"
			$menu add command -label "Mover Ejes Coordenadas" -command "Mopac::manejadorEjesInteractivos $numOrbital"
		
		set x [winfo pointerx $win]
		set y [winfo pointery $win]
		tk_popup $menu $x $y
	}; #finproc
	
	proc cerrarOrbitales { base } {
		upvar #0 Mopac::$base mopac
		
		for {set x 0} {$x <= $mopac(semillaOrb)} {incr x} {
			set win ".orbital_$x"
			set visor "visorMopac$x"
			set data "${visor}data"
			if {[winfo exists $win] == 1} {
				#destruir visor y datos del mismo
				VisorVTK::delVisorVTK $visor
				Data::delData $data
				destroy $win
			}
		}
	}; #finproc

	proc manejadorTransparencia { numOrbital } {
		set visor "visorMopac$numOrbital"
		if {[VisorVTK::devuelveTransparenciaOrbital $visor "${visor}orb"] == 1} {
			#$botonTransparencia configure -relief sunken
			VisorVTK::modificarTransparenciaOrbital $visor "${visor}orb" 0.5
		} else {
			#$botonTransparencia configure -relief raised
			VisorVTK::modificarTransparenciaOrbital $visor "${visor}orb" 1
		}
	}; #finproc
	
	proc manejadorColorFondo { numOrbital } {
		set win ".orbital_$numOrbital"
		set visor "visorMopac$numOrbital"
		set color [tk_chooseColor -parent $win]
		if {$color != ""} { VisorVTK::cambiarColorFondo $visor $color }
	}; #finproc
	
	proc manejadorEjes { numOrbital boton } {
		set visor "visorMopac$numOrbital"
		
		if {[VisorVTK::devolverEstadoEjes $visor] == 0} {
			VisorVTK::mostrarOcultarEjes $visor 1
			$boton configure -relief sunken
		} else {
			VisorVTK::mostrarOcultarEjes $visor	0
			$boton configure -relief raised
		}
	}; #finproc
	
	proc manejadorEjesInteractivos { numOrbital } {
		set visor "visorMopac$numOrbital"
		
		if {[VisorVTK::devolverEstadoEjes $visor] == 1} {
			if {[VisorVTK::devolverEjesInteractivos $visor] == 0} {
				VisorVTK::ejesInteractivos $visor 1
			} else {
				VisorVTK::ejesInteractivos $visor 0
			}
		} 
	}; #finproc
	
	proc manejadorRepresentacion2 { listaBot numOrbital numBot } {
		set visor "visorMopac$numOrbital"
		if {$numBot == 0 } {
			VisorVTK::modificarRepresentacionOrbital $visor "${visor}orb" "Surface"
		} elseif {$numBot == 1 } {
			VisorVTK::modificarRepresentacionOrbital $visor "${visor}orb" "Wireframe"
		} elseif {$numBot == 2 } {
			VisorVTK::modificarRepresentacionOrbital $visor "${visor}orb" "Points"
		}
		for {set x 0} {$x < [llength $listaBot]} {incr x} {
			if {$x == $numBot} { 
				[lindex $listaBot $x] configure -relief sunken 
			} else {
				[lindex $listaBot $x] configure -relief raised
			}
		}
	}; #finproc 
	
	proc manejadorRepresentacion { numOrbital modo } {
		set visor "visorMopac$numOrbital"
		if {$modo == 0 } {
			VisorVTK::modificarRepresentacionOrbital $visor "${visor}orb" "Surface"
		} elseif {$modo == 1 } {
			VisorVTK::modificarRepresentacionOrbital $visor "${visor}orb" "Wireframe"
		} elseif {$modo == 2 } {
			VisorVTK::modificarRepresentacionOrbital $visor "${visor}orb" "Points"
		}
	}; #finproc
	
	
	proc manejadorGuardarImagenComo { numOrbital baseConf } {
		upvar #0 Conf::$baseConf config
		set win ".orbital_$numOrbital"
		set visor "visorMopac$numOrbital"
		set types {
			{{JPEG} {.jpg} }
			{{Mapa de bits} {.bmp} }
			{{TIFF} {.tif} }
			{{PostScript} {.ps} }
			{{PNG} {.png} }
		}
		set filename [tk_getSaveFile -initialfile "Dibujo" -parent $win -filetypes $types -defaultextension jpg -initialdir $config(dirData) -title "Guardar Imagen Como"]
		if {$filename != ""} {
			set config(dirData) [file dirname $filename]
			set ext [file extension $filename]
			switch $ext {
				".jpg" {
					VisorVTK::salvarPantallaComoImagen $visor JPEG $filename
				}
				".bmp" {
					VisorVTK::salvarPantallaComoImagen $visor BMP $filename
				}
				".tif" {
					VisorVTK::salvarPantallaComoImagen $visor TIFF $filename
				}
				".ps" {
					VisorVTK::salvarPantallaComoImagen $visor PostScript $filename
				}
				".png" {
					VisorVTK::salvarPantallaComoImagen $visor PNG $filename
				}
				default {}
			}
		}
	}; #finproc
	
	proc manejadorMostrarOcultarMol { botonMO numOrbital } {
		set visor "visorMopac$numOrbital"
		set data "${visor}data"
	
		set estado [$botonMO cget -relief]
		if {$estado == "sunken"} {
			VisorVTK::ocultarMostrarMol $visor $data 1
			$botonMO configure -relief raised
		} else {
			VisorVTK::ocultarMostrarMol $visor $data 0
			$botonMO configure -relief sunken
		}
	}; #finproc
	
	proc manejadorProyeccion2 { botonProy numOrbital } {
		set visor "visorMopac$numOrbital"
	
		set estado [$botonProy cget -relief]
		if {$estado == "sunken"} {
			VisorVTK::cambiarProyeccionCamara $visor 0
			$botonProy configure -relief raised
		} else {
			VisorVTK::cambiarProyeccionCamara $visor 1
			$botonProy configure -relief sunken
		}
	}; #finproc
	
	proc manejadorProyeccion { numOrbital } {
		set visor "visorMopac$numOrbital"
		if {[VisorVTK::devolverProyeccionCamara $visor] == 1} {
			VisorVTK::cambiarProyeccionCamara $visor 1
		} else {
			VisorVTK::cambiarProyeccionCamara $visor 0
		}
	}; #finproc
	
	proc manejadorLuces2 { botonLuz numLuz numOrbital } {
		set visor "visorMopac$numOrbital"
	
		set estado [$botonLuz cget -relief]
		if {$estado == "sunken"} {
			VisorVTK::encenderApagarLuz $visor $numLuz 0
			$botonLuz configure -relief raised
		} else {
			VisorVTK::encenderApagarLuz $visor $numLuz 1
			$botonLuz configure -relief sunken
		}
	}; #finproc

	proc manejadorLuces { numOrbital numLuz } {
		set visor "visorMopac$numOrbital"
	
		if {[VisorVTK::devolverEstadoLuz $visor $numLuz] == 0} {
			VisorVTK::encenderApagarLuz $visor $numLuz 1
		} else {
			VisorVTK::encenderApagarLuz $visor $numLuz 0
		}
	}; #finproc

	proc cambiarResolucion { numOrbital res } {
		set visor "visorMopac$numOrbital"
		switch $res {
			B {VisorVTK::cambiarResolucionVisorVTK $visor 6; VisorVTK::cambiarAntiAliasingVisorVTK $visor 0}
			M {VisorVTK::cambiarResolucionVisorVTK $visor 18; VisorVTK::cambiarAntiAliasingVisorVTK $visor 0}
			A {VisorVTK::cambiarResolucionVisorVTK $visor 50; VisorVTK::cambiarAntiAliasingVisorVTK $visor 0}
			U {VisorVTK::cambiarResolucionVisorVTK $visor 100; VisorVTK::cambiarAntiAliasingVisorVTK $visor 5}
		}
	}; #finproc

#----------------------------------------------------------------------------------------------
#										-	EJECUCION DE MOPAC   -
#----------------------------------------------------------------------------------------------			
	#MOPAC toma como entrada 
	proc ejecutaMopac { base } {
		upvar #0 Mopac::$base mopac
		upvar #0 Conf::$mopac(conf) config
		
		
		#trabajare en el directorio temp, y despues copiare el resultado al directorio q me hayan dado
		#borro el directorio temporal, y lo creo vacio
		catch { file delete -force $config(dirTemp) }
		file mkdir $config(dirTemp)
		
		#antes de ejecutar MOPAC debo crear un fichero llamado FOR005 en temp
		
		#el fichero de entrada de mopac se debe llamar FOR005, y contendra lo q haya escrito en el textoW
		set fMOP [open "$config(dirTemp)FOR005" w+]
		puts $fMOP [$mopac(textWM) get 0.0 end]
		close $fMOP
			
		#ejecuto Mopac
		#debo moverme al directorio temporal para ejecutar mopac, ya q es en el directorio actual donde busca el ejecutable
		cd "$config(dirTemp)"
		set pipe [open |"$config(dirBin)mopacesp.exe" r+]
		cd "$config(dirBin)" 		

		set modif "mop"
		
		#cedo el control del proceso a controlador de procesos para mopac
		set terminadoProceso [controladorProcesosMopac $base $pipe]
		if {$terminadoProceso == 1 } {
			return [tratarResultadoMopac $base $modif]
		} else {
			return [tratarResultadoMopacCancelado $base $modif]
		}
		
	}; #finproc
	
	#Mopac escribe su salida directamente a un fichero  externo, por lo q si muestra algo por la salida estandar, q hemos capturado en
	#la pipe, significara q se ha producido un error
	proc controladorProcesosMopac { base pipe } {
		upvar #0 Mopac::$base mopac
		upvar #0 GUI::$mopac(gui) gui
		upvar #0 Conf::$mopac(conf) config
		
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
			set GUI::${mopac(gui)}(varProgressBar) 1
			update
		}
		#set wio $log
		set GUI::${mopac(gui)}(varProgressBar) -1
		$gui(butonCancelProc) configure -state disabled
		close $pipe
	
		if {$gui(cancelarProceso) == 1} {
			#se ha cancelado el proceso
			#matar el proceso
			#tk_messageBox -type ok -message "Proceso $tink(prog) Cancelado"
			
			#busco el proceso y lo mato
			set lProc [listaprocesos]
			puts $lProc
			set pidProc [buscaPID $lProc "mopacesp.exe"]
			if { $pidProc != -1 && [matoproc $pidProc] == 1} {
				#busco el pid del proceso
				tk_messageBox -type ok -message "Proceso Mopac Cancelado"
			} else {
				tk_messageBox -type ok -icon error -message "Ha sido imposible cancelar el proceso Mopac"
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
	
	proc tratarResultadoMopac { base modif } {
		upvar #0 Mopac::$base mopac
		upvar #0 GUI::$mopac(gui) gui
		upvar #0 Conf::$mopac(conf) config
		upvar #0 Data::$mopac(data) datos
		
		#tk_messageBox -type ok -message "Calculo Finalizado"
		
		#fijo el fichero mol con el q estamos trabajando
		if {$mopac(optimizacion) != "SADDLE"} {
			set fichMOL $mopac(fichMOL)
		} else {
			set fichMOL $mopac(fichMOLSaddle1)
		}
		
		#creo los directorios para guardar los datos
		set f1 [string map {".mol" ""} [file tail $fichMOL]]
				
		set dirMopac "[file dirname $fichMOL]/Almacen/$mopac(nombreCalculo)/Mopac"
		file mkdir $dirMopac
		
		#copio el mno
		set filemno "$config(dirTemp)FOR006"
		file copy -force $filemno "$dirMopac/$mopac(nombreCalculo).mno"

		set res "ERROR"
		
		#muestro el log
		if {[file exists $filemno]} {
			#copio el fichero de salida al directorio de trabajo y lo muestro
			
			#si no encuentro la cadena MOPAC DONE en el fichero mno, significara q se ha producido un error
			#de calculo.
			set fMNO [open $filemno r+]
			set contMNO [read $fMNO]
			close $fMNO
			if {![string match "*MOPAC DONE*" $contMNO]} {
				tk_messageBox -type ok -icon warning -message "Se ha producido un error en el calculo de MOPAC \
															 revise el fichero MNO"
			} else {
				#trato los resultados concretos
				#siempre despues de cualquier calculo mopac, se comprobara si exite la cadena GEOMETRY OPTIMIZED,
				#de existir buscaremos la ultima definicion de coordenadas, las leeremos y generaremos un nuevo fichero
				#mol q pegaremos en el visor
				#de no existir, por defecto lanzaremos un error, aunque existen excepciones q trataremos

				#muestro un mensaje si no existe geometria optimizada
				existeGeometriaOptimizada $filemno
				
				#genero el nuevo mol

				set mol [Fich::MOPACtoMOL $filemno $fichMOL]
				file copy -force $mol "[file dirname $fichMOL]/$mopac(nombreCalculo).mol"
				set res [list "[file dirname $fichMOL]/$mopac(nombreCalculo).mol"]
				
				
				#considero casos especiales
				#han marcado el calculo de vibraciones
				if {$mopac(optimizacion) == "FORCE"} {
					if {![string match "*MASS-WEIGHTED COORDINATE ANALYSIS*" $contMNO] || ![string match "*DESCRIPTION OF VIBRATIONS*" $contMNO]} {
						tk_messageBox -type ok -icon warning -message "El fichero $filemno no contiene vibraciones, revise su estrura o sus Keywords"
					} else {
						#existen las dos secciones en el fichero, genero una carpeta VIBRATE y todos los ficheros correspondientes a las vibraciones
						#cargamos el array despVibra
						set n [leerVibracionesMNO $base $filemno]
						if {$n != [expr 3 * $datos(numAtomos)]} {
							tk_messageBox -type ok -icon warning -message "El fichero $filemno no contiene vibraciones, revise su estrura o sus Keywords"
						} else {
							#hay 3n vibraciones en el fichero mno, y en estos momentos tenemos toda la informacion en memoria
							
							file mkdir "$dirMopac/VIBRATE"
							
							#uso las coordenadas actualizadas
							Data::newData tempVib 
							Fich::leeFichMol $mol tempVib $mopac(conf)
							for {set v 1} {$v <= [expr 3 * $datos(numAtomos)]} {incr v} {
								set ext [format "%03d" $v]
								escribirVibracionMopac $base tempVib $v "$dirMopac/VIBRATE/$mopac(nombreCalculo).$ext"
							}
							Data::delData tempVib
						}
					}
				}
				
				#si han marcado graph
				if {$mopac(graph) == "Y"} {
					if {![string match "*EIGENVALUES*" $contMNO] ||	![file exists "$config(dirTemp)FOR013"]} {
						tk_messageBox -type ok -icon warning -message "El fichero $filemno no contiene vibraciones, revise su estrura o sus Keywords"
					} else {
						#copio el fichero bajo extension 3gp, a una carpeta GRAPH
						file mkdir "$dirMopac/GRAPH"
						file copy -force "$config(dirTemp)FOR013" "$dirMopac/GRAPH/$mopac(nombreCalculo).gpt"
					}
				}
			}
			Log::cerrarLogs $gui(semillaLogs)
			incr gui(semillaLogs)
			Log::newLog log_$gui(semillaLogs) "$dirMopac/$mopac(nombreCalculo).mno" $gui(conf) "mno" 0
		} else {
			tk_messageBox -type ok -icon error -message "Se ha producido un error en MOPAC, revise las keywords y los ficheros de\
											 de entrada y vuelva a ejecutar MOPAC"
		}
		set gui(resultadoMopac) $res
		puts $res
		return $res
	}; #finproc
	
	proc tratarResultadoMopacCancelado { base modif } {
		upvar #0 Mopac::$base mopac
		upvar #0 GUI::$mopac(gui) gui
		upvar #0 Conf::$mopac(conf) config
		
		set filemno "$config(dirTemp)FOR006"
		if {[file exists $filemno]} {
		
			#creo los directorios para guardar los datos
			set f1 [string map {".mol" ""} [file tail $mopac(fichMOL)]]
					
			set dirMopac "[file dirname $mopac(fichMOL)]/Almacen/$mopac(nombreCalculo)/Mopac"
			file mkdir $dirMopac
		
			file copy -force $filemno "$dirMopac/$mopac(nombreCalculo)-calculoCancelado.mno"
			Log::cerrarLogs $gui(semillaLogs)
			incr gui(semillaLogs)
			Log::newLog log_$gui(semillaLogs) "$dirMopac/$mopac(nombreCalculo)-calculoCancelado.mno" $gui(conf) "mno" 0
		}
		set gui(resultadoMopac) "ERROR"
		return "ERROR"
	}; #finproc
	
	
	proc manejadorEjecutar { base } {
		upvar #0 Mopac::$base mopac
		upvar #0 GUI::$mopac(gui) gui
		upvar #0 Conf::$mopac(conf) config
		

		#para evitar q se mezclen datos nuevos con antiguos y ante la posibilidad de confusion si ambos mantienen el mismo nombre
		#todo ello con el objetivo de poder recuperar calculos anteriores, se pregutara por el nombre q se le desea dar a los calculos
		#mopac, si estos ya existen se borraran, y se crearan los nuevos
		
		#fijo el fichero mol con el q estamos trabajando
		if {$mopac(optimizacion) != "SADDLE"} {
			set fichMOL $mopac(fichMOL)
		} else {
			set fichMOL $mopac(fichMOLSaddle1)
		}
		
		#set f1 [string map {".mol" ""} [file tail $mopac(fichMOL)]]
		
		set calcular 1
		if {[file exists "[file dirname $fichMOL]/$mopac(nombreCalculo).mol/Mopac"]} {
			if {[tk_messageBox -type yesno -icon warning -message "Ya existen calculos mopac con el nombre $mopac(nombreCalculo) \
																	desea sobreescribirlos? Especifique otro nombre en caso contrario"]} {
				set calcular 1
			} else {
				set calcular 0
			}
		} 
		if {[string map {".mol" ""} [file tail $mopac(fichMOL)]] == $mopac(nombreCalculo)} {
			tk_messageBox -type ok -message "El nombre del calculo no puede ser el mismo que el del fichero mol original.\n \
			cambielo he intente el calculo de nuevo"
			set calcular 0
			focus $mopac(mainframe)
		}
		
		if {$calcular == 1} {
			wm withdraw $mopac(mainframe)
		
			#borro los posibles calculos anteriores con el mismo nombre
			catch { 
				file delete -force "[file dirname $mopac(fichMOL)]/$mopac(nombreCalculo).mol"
				file delete -force "[file dirname $mopac(fichMOL)]/Almacen/$mopac(nombreCalculo)/Mopac"
			}
			catch { ejecutaMopac $base } res
			puts "resultado mopac $res"
			set m [GUI::finProcesoMopac $mopac(gui)]
			#si se ha cargado una molecula en el visor, es ha ocurrido un calculo correcto y en temporal tengo un FOR006
			if {$m != -1 } {
				set lcargas [Fich::ultimasCargasMOPAC "$config(dirTemp)FOR006" $fichMOL]
				Data::actualizaCargasParciales $m $lcargas
			}
			
			#destruyo la ventana Tinker, esto avisaria a la gui de q ya puede consultar la variable gui(resultadoTink)
			if {$mopac(mainframe) != "" } { 
				#esto ya incluye delTinker $base
				destroy $mopac(mainframe) 
			} else {
				#lo destruyo a mano
				delMopac $base
			}
		}
	}; #finproc
	
	proc manejadorCancelar { base } {
		upvar #0 Mopac::$base mopac
		destroy $mopac(mainframe)
	}; #finproc
	
	#para confirmar si existe geometria optimizada, buscare la cadena GEOMETRY OPTIMIZED tras la seccion de resultados
	#para ello buscare las lineas correspondientes a las keywords
	proc existeGeometriaOptimizada { fileMNO } {
		
		set fMNO [open $fileMNO r+]
		#busco las lineas conteniendo muxos asteriscos, cuando lea 4 estare frente a las keywords
		
		set enc 0
		
		gets $fMNO linea
		set cont 0
		while {![eof $fMNO] && $cont < 4} {
			puts "linea $linea"
			if {[string match {*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\**} $linea]} {
				incr cont
			}
			gets $fMNO linea			
		}
		if {![eof $fMNO]} {
			#consumo las 3 siguientes lineas, ese sera mi patron a buscar en el resto
			set key $linea
			gets $fMNO linea			
			append key "\n$linea"
			gets $fMNO linea	
			append key "\n$linea"		
			
			#ya tengo la cabecera de keywords
			#obtengo el resto dele fichero
			set content [read $fMNO]
			
			#obtengo la posicion tras la repeticion de key, es decir a partir de donde se encuentran los resultados
			set pos [string first $key $content]
			
			#busco en los resultados la cadena deseada, que me indike si el calculo ha sido correcto, 
			#buscaremos concretamente "TEST WAS SATISFIED"	
			set enc [expr [string match "*TEST WAS SATISFIED*" [string range $content $pos end]] || \
					[string match "*GEOMETRY OPTIMIZED*" [string range $content $pos end]] || \
					[string match "*SCF FIELD WAS ACHIEVED*" [string range $content $pos end]] ]
		}
		
		#muestro un mensaje si no se ha encontrado
		if {$enc == 0} { tk_messageBox -type ok -icon warning -message "No se ha encontrado Geometria Optimizada"}
		close $fMNO
		
	}; #finproc
	
}; #finnamespace


