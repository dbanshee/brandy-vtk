##########################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#		Desarrollado como Proyecto Fin de Carrera de Ingenieria Tecnica en Informatica de Sistemas
#
#																	Universidad de Malaga
#
#										- Main de BrandyMol 1.0 - 
#
#
###########################################################################################################



package require BWidget
package require Img

# ventana de bienvenida que carga en el sistema todas las librerias y fuentes necesarias
proc ventanaBienvenida { listaSources listaDlls } {
		wm iconify .
		variable bienv
		
		set bienv(progressBar) 0
		set bienv(label) ""
		
		set win [toplevel .bienv]
		wm resizable $win 0 0
		wm overrideredirect $win 1
		
			
		#frame superior
		set frameup [frame $win.frameup -borderwidth 3 -bd 2 -relief sunken]		
		set image [image create photo img_welcome -file "logo.jpg"] 

		set limage [label $frameup.lb1 -image img_welcome]
		#creo una frame dentro de la imagen
		set framein [frame $limage.f]
		
		set infover " Versión 1.0 \n \
					  Copyright(c)  -  2007\n \
					   OSCAR NOEL AMAYA GARCÍA \n\
					   GREGORIO TORRES GARCÍA \n\
					   FRANCISCO NÁJERA ALBENDÍN"
		
		#set labelVersion [label $framein.lab1 -text $infover \
	    #-activebackground #a0a0a0 -relief flat -font {Arial 8 {bold italic}} -justify left]
		set labelVersion [label $framein.lab1 -text $infover \
	    -activebackground black -fg white -bg black -relief flat -font {Arial 8 {bold italic}} -justify left]
		
		
		place $framein -x 10 -y 320
		pack $labelVersion 
		pack $limage -side top
		
		
		
		#frame inferior
		set framedown [frame $win.framedown -borderwidth 3 -bd 2 -relief flat]
		set prg  [ProgressBar $framedown.prg -width 200 -height 10 -variable bienv(progressBar) \
		-maximum [expr [llength $listaSources] + [llength $listaDlls]]]
		set label [Label $framedown.lab -activebackground #a0a0a0 -textvariable bienv(label) -font {Arial 8 {bold roman}} -anchor w -takefocus]
		pack $label -side left -padx 10
		pack $prg -side right -padx 10
		
		#empaqueto
		pack $frameup -fill both -expand 1  -padx 3 -pady 3
		pack $framedown -fill x -expand 1 -padx 3 -pady 3
		
		BWidget::place $win 0 0 center

		#bind $win <Destroy> "wm deiconify ."
		focus $win

		#cargo los fuentes
		foreach sourc $listaSources {
			puts "Cargando ${sourc}..."
			set bienv(label) "Cargando $sourc..."
			update
			source $sourc
			incr bienv(progressBar)
			
		}
		foreach lib $listaDlls {
			puts "Cargando ${lib}..."
			set bienv(label) "Cargando $lib..."
			load $lib
			incr bienv(progressBar)
			update
		}
		set bienv(label) "Terminado"
		update
		
		
		Conf::newConf c
		set ok [Conf::inicializarConf c "conf.ini" "colors.ini"]
		if {$ok == 1} {
			VisorVTK::newVisorVTK v
			VisorVTK::inicializarVisor v
			VisorVTK::inicializarLookupTable v c
			GUI::newGUI g v c
			
			destroy $win
			unset bienv
			#wm deiconify .
		} else {
			exit
		}
}

# lanzo el programa ppal
set sources "Data.tcl Fich.tcl VisorVTK.tcl GUI.tcl Icon.tcl Conf.tcl Tinker.tcl \
			Log.tcl Mopac.tcl Colors.tcl"
set dlls "tlistadll.dll"		
ventanaBienvenida $sources $dlls
# fin