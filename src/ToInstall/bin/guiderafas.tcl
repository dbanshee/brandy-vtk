package require BWidget
console show

. configure  -height 550 -width 780 -borderwidth 2
	wm title . "Rafa's Engine"
	wm geometry . +40+40

	

	set menu [menu .menuPpal -tearoff 0]
		$menu add cascade -label "Archivo" -menu $menu.archivo
			set menarch [menu $menu.archivo -tearoff 0]
			$menarch add command -label "Abrir Fichero Rafa" 
			$menarch add command -label "Guardar" 
			$menarch add command -label "Guardar Como..." 
			$menarch add separator
			$menarch add command -label "Importar" 
			$menarch add separator
			$menarch add command -label "Opciones" 
			$menarch add separator
			$menarch add command -label "Salir" 
		
		$menu add cascade -label "Ayuda" -menu $menu.ayuda
			set menayu [menu $menu.ayuda -tearoff 0]
				$menayu add command -label "Ayuda"
				$menayu add command -label "Acerca De..."		
	
	
	set ppal [frame .ppal  -borderwidth 3 -bd 2 -relief groove]
	
	for {set x 0} {$x < 8} {incr x} {
		set frame($x) [frame $ppal.frame_${x} -borderwidth 3 -bd 2 -relief groove]
		for {set y 0} {$y < 8} {incr y} {
			set butt [Button $frame($x).but_$y -activebackground #a0a0a0 -helptext "Ayuda" -command "manejador $frame($x).but_$y" -bg grey]
			pack $butt -side left -ipadx 10
			puts $butt
		}
		pack $frame($x) -side top 
	
	}
	pack $ppal -padx 10 -pady 10
	
	
	
	
	proc manejador { button } {
	puts "[$button cget -relief]"
		if {[$button cget -relief] == "sunken"} {
			$button configure -relief raised
			$button configure -bg grey
		} else {
			$button configure -relief sunken
			$button configure -bg black
		}
	
	}
	

	update 
	#.ppal.frame_0.but0 configure -relief sunken
.ppal.frame_0.but_0 configure -relief sunken
update ; after 1000
.ppal.frame_3.but_1 configure -relief sunken

update ; after 1000
.ppal.frame_4.but_2 configure -relief sunken

update ; after 1000
.ppal.frame_1.but_3 configure -relief sunken

update ; after 1000
.ppal.frame_0.but_4 configure -relief sunken

update ; after 1000
.ppal.frame_5.but_5 configure -relief sunken

update ; after 1000
.ppal.frame_7.but_6 configure -relief sunken

update ; after 1000
.ppal.frame_2.but_7 configure -relief sunken

update ; after 1000
.ppal.frame_1.but_0 configure -relief sunken
	update
