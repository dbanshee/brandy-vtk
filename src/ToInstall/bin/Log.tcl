#########################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#										- MODULO PARA EL MANEJO DE LOGS -
#   	 	   						   		  --------------------
#	Manejo de Logs, permite su creacion, destruccion, guardado y carga de ficheros.
#
#
#	Definido dentro del
#			namespace eval Log
#
#
#	base(): array que representara la instancia de Log
#
#		base(config)		-->		Nombre de la instancia de Conf asociada
#		base(file)			-->		Fichero activo en el Log
#		base(tipo)			-->		Extension de los Log
#		base(editable) 		-->		0 : solo lectura, 1 : lectura/escritura
#		base(mainf)			-->		nombre de la ventana ppal del Log
#		base (texto)		-->		Widget Texto del Log
#
#	Define :
#		proc newLog { base file baseConf tipo editable }
#		proc delLog { base }
#		proc cargarTexto { base texto }
#		proc cargarFichTextoW { fich textWidget }
#		proc cargarTextoTextoW { texto textWidget }
#		proc guardarTextoWFich { textWidget fich }
#		proc cerrarLog { base }
#		proc abrirLog { base }
#		proc guardarLog { base }
#		proc cerrarLogs { maxlogs }
#
##########################################################################################################




namespace eval Log {
	
	proc newLog { base file baseConf tipo editable } {
		
		set mainf ".${base}_ficheroLog"
		if {[winfo exists $mainf]} {delLog $base}
		
		
		variable $base
		upvar #0 Log::$base log
		set log(config) $baseConf
		
		set log(file) $file
		set log(tipo) $tipo
		set log(editable) $editable
		set log(mainf) ".${base}_ficheroLog"
	
		
		toplevel $mainf
		wm title $mainf "Edici�n de Ficheros [string toupper $tipo]"
		$mainf configure -menu $mainf.menulog
		set frameup [frame $mainf.fup -borderwidth 3 -bd 2 -relief groove]
		set texto [text $frameup.text -borderwidth 2 -font {Terminal 9 } -relief raised -yscrollcommand "$frameup.textscroll set"]
		set log(texto) $texto
		set scroll [scrollbar $frameup.textscroll -command "$texto yview"]
		pack $scroll -fill y -side right -expand no
		pack $texto -fill both -expand yes
		
		pack $frameup -side top -fill both -expand yes -padx 5 -pady 5
		
		
		set framedown [frame $mainf.down -bd 1 -relief raised]
		set butAbrir [Button $framedown.abrirlog -activebackground #a0a0a0 -command "Log::abrirLog $base" -helptext "Abre un Fichero" -image $Icon::abriricon]
		set butCerrar [Button $framedown.ok -activebackground #a0a0a0  -command "Log::cerrarLog $base" -helptext "Cierra la Ventana" -image $Icon::cancelicon]
		set butGuardar [Button $framedown.grd -activebackground #a0a0a0 -command "Log::guardarLog $base" -helptext "Guardar Cambios" -image $Icon::guardaricon]
		set butOrdenar [Button $framedown.ord -activebackground #a0a0a0 -state disabled -helptext "Ordena el Fichero Log de una\nB�squeda Conformacional" -image $Icon::ordenicon]
		pack $butAbrir $butCerrar $butGuardar -side left
		pack $framedown -fill x
		
		set menulog [menu $mainf.menulog -tearoff 0]
			$mainf.menulog add cascade -label "Fichero" -menu $mainf.menufich -state active
			set filelog [menu $mainf.menufich -tearoff 0]
				$filelog add command -label "Abrir [string toupper $tipo]" -command "Log::abrirLog $base"
				$filelog add command -label "Salir" -command "destroy $mainf"
			
		#asocio el evento de salida de la ventana a delLog
		bind $mainf <Destroy> "Log::delLog $base"
		
		#compruebo si se quiere cargar algun fichero por defecto
		if {$file != ""} {
			cargarFichTextoW $file $texto
		} 
		if {$editable == 0 } {
			$butGuardar configure -state disabled
		}
		focus $texto
	}; #finproc
	
	#crea un log con la posibilidad de a�adirle un boton personalizable
	proc anadirBotonLog { base textoB iconB commandB } {
		set boton [Button ".${base}_ficheroLog.down.adv" -image $iconB -helptext $textoB -command $commandB]
		pack $boton -side right
	}
	
	proc delLog { base } {

		if {[info exists Log::$base] == 1} { unset Log::$base }
		if {[winfo exists .${base}_ficheroLog] == 1} {
			destroy .${base}_ficheroLog
		} 
	};#finproc
	
	proc cargarTexto { base texto } {
		upvar #0 Log::$base log
		cargarTextoTextoW "$texto" $log(texto)
	}; #finproc
	
	proc cargarFichTextoW { fich textWidget } {
		set fichero [open $fich r]
		set text [read $fichero]
		close $fichero
		$textWidget delete 0.0 end
		$textWidget insert end $text
		$textWidget configure -state normal
		
	}; #finproc
	
	proc cargarTextoTextoW { texto textWidget } {
		$textWidget delete 0.0 end
		$textWidget insert end $texto
		$textWidget configure -state normal
	}; #finproc

	proc guardarTextoWFich { textWidget fich } {
		set fichero [open $fich w+]
		set texto [$textWidget get 0.0 end]
		puts $fichero $texto
		close $fichero
	}; #finproc
	
	proc cerrarLog { base } {
		destroy .${base}_ficheroLog
		delLog $base
	}; #finproc

	proc abrirLog { base } {
		upvar #0 Log::$base log
		upvar #0 Conf::$log(config) config
		
		set types [list [list [list Ficheros [string toupper $log(tipo)]] ".$log(tipo)" ]]
		#si colocas parent en tkget pierde el control del widgett de texto
		set filename [tk_getOpenFile -filetypes $types -initialdir $config(dirData) -title "Abrir Fichero [string toupper $log(tipo)]"]
		if {[file exists $filename]} {
			#set config(dirData) [file dirname $filename]
			cargarFichTextoW $filename $log(texto)
			set log(file) $filename
			focus $log(texto)
			return 1
		}
		return -1
	}; #finproc
	
	proc guardarLog { base } {
		upvar #0 Log::$base log
		upvar #0 Conf::$log(config) config
				
		if {$log(file) == ""} {set fich ""} else {set fich $log(file)}
		set types [list [list [list Ficheros [string toupper $log(tipo)]] ".$log(tipo)"]]
		set filename [tk_getSaveFile -filetypes $types -initialdir $config(dirData) -initialfile $fich -title "Guardar Fichero [string toupper $log(tipo)]" -parent $log(mainf)]
		if {$filename != ""} { 
			set config(dirData) [file dirname $filename]
			guardarTextoWFich $log(texto) $filename
			set log(file) $filename 
		}
		
	}; #finproc

	proc cerrarLogs { maxlogs } {
		for {set x 0} {$x <= $maxlogs } {incr x} { cerrarLog "log_$x" }
	}; #finproc

}; #finnamespace