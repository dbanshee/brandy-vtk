#######################################################################################################
#
#	AUTOR : OSCAR NOEL AMAYA GARCIA - 2006/07
#
#								- MODULO PARA EL MANEJO DE VISORES VTK -
#									 	  --------------------
# Cada visor sera manejado por una estructura que tomara un nombre base unico definido por el usuario
# 
#
#	Definido dentro del
#			namespace eval VisorVTK
#
#	base(): array que representara la instancia del visor
#		
#	Objetos fijos del visor
	
#		Sistema Visualizacion
#	
#		base(render)			--> vtkRenderer
#		base(renderW)			--> vtkRsenderWindow
#		base(renderWInt)		--> vtkRenderWindowInteractor
#		base(intStyle)			--> vtkInteractorStyle
#		base(picker)			--> vtkPicker
#
#		Representacion de Moleculas
#	
#		base(atomoCB)    		--> vtkSphereSource
#		base(enlacePoints)		--> vtkPoints
#		base(enlaceCells)		--> vtkCellArray
#		base(atomoMapperCB)		--> vtkPolyDataMapper
#
#		base(ladosTubeFilter) 	-->  numero de lados q tendran los tubos q representan los enlaces
#
#		Interaccion :

#		base(opcionAct)			--> opcion q esta cursandose, seleccionar, rotar, desplazar, centrar, o zoom
#		base(SHIFT)				--> estado de la tecla SHIFT, 0: no pulsado, 1: pulsado
#		base(CTRL)				--> estado de la tecla CTRL, 0: no pulsado, 1: pulsado
#		base(ratonDchoPuls)		--> estado del boton derecho del raton, 0: no pulsado, 1: pulsado
#		base(ratonIzqPuls)		--> estado delboton derecho del raton, 0: no pulsado, 1: pulsado
#		base(ratonMov)			--> estado del movimiento del raton, 0: no se ha movido desde q se se pulso
#									el boton izq del raton, 1: en caso contrario
#
#		base(actorOptMover)	--> contendra el actor que se toma como referencia para mover actores en la opcion Mover
#
#		Etiquetas :
#
#		base(actoresEtiquetas) --> lista de actores Etiquetas del sistema
#		base(listaEtiquetas) --> lista de las medidas registradas

#		Medidas:
#
#		base(medidasPoints)
#		base(medidasCells)
#		base(medidasPolyData)
#		base(medidasPolyDataMapper)
#		base(medidasActor)
#
#		base(actoresTexto) --> lista de los actores texto que representan contenido numerico
#		base(semillaActoresTexto) 
#		base(actoresSeleccMedidas) 	--> lista de los ultimos atomos seleccionados, de longitud maxima : 4
#		base(listaMedidas)			--> lista de 2,3,4-tuplas, de actoresAtomos q representaran las medidas activas.
#										2 : distancia, 3 : angulo, 4: Torsion
#
#		Puentes de Hidrogeno:
#
#		base(puentesHPoints)
#		base(puentesHCells)
#		base(puentesHPolyData)
#		base(puentesHPolyDataMapper)
#		base(puentesHActor)

#		base(listaPuentesH)			--> lista de pares de actoresAtomos q representaran los puentes de hidrogeno.

#		base(ejesRot)				--> lista de los ejes de rotacion usadas para el modo rotar, ctrl, shift
#
#	Objetos que dependen de los datos introducidos en el visor
#
#
#		base(moleculas)				--> lista con los nombres de las moleculas q contiene el visor
#		
#		base(numAtomos,mol)			--> numero de atomos de la molecula mol
#		base(actoresAtomos,mol)		--> lista de nombres de actores VTK, q representan los atomos de la molecula mol
#		base(numEnlaces,mol)		--> numero de atomos de la molecula mol
#		base(actoresEnlaces,mol)	--> lista de nombres de actores VTK, q representan los atomos de la molecula mol
#
#		base(estadoRepres,mol,x)	--> estado de representacion en q se encuentra el atomo x, L, C, CB o CPK de la molecula mol
#		base(estadoRepresEn,mol,i,j)--> estado de representacion en q se encuentra el enlace i,j : L, C, CB de CPK de la molecula mol
#		base(visible,i)				--> 1 si el atomo es visible, 0 en caso contrario, se usa para la ocultacion de hidrogenos
#	
#		base(actoresAtomosVTKSeleccionados,mol)	--> lista de los nombres de los actoresAtomo VTK que se hayen seleccionados de la molecula mol
#		base(actoresEnlacesVTKSeleccionados,mol)--> lista de los nombres de los actoresEnlace VTK que se hayen seleccionados de la molecula mol
#
#		base(ficheroSeleccionado)	--> nombre del fichero de la molecula seleccionada, solo actualizada mediante doble click
#
#		base(scalarsEnlaces,mol)	--> lista de tam base(numEnlaces) con los nombres de los scalares para cada enlace
#		base(tubefilterEnlaces,mol)	--> lista de tam base(numEnlaces) con los nombres de los tubeFilter para cada enlace
#		base(polydataEnlaces,mol)	--> lista de tam base(numEnlaces) con los nombres de los polydata para cada enlace
#		base(mapperEnlaces,mol)		--> lista de tam base(numEnlaces) con los nombres de los mappers para cada enlace
#		
#		
#		base(orbitales)		--> llista de nombres de orbitales
#		base(luces) 		--> lista de luces
#		base(superficies) 	--> lista de superficies
#		base(semillaSuperficies)

#
#	Define :
#		proc newVisorVTK { base } --> 0: variable creada, -1: la variable ya existe
#		proc delVisorVTK { base }
#		proc delDatosVisorVTK { base }
#		proc inicializarVisor { base } 
#		proc cargaVisorData { baseVisor baseData }
#		proc devuelveRenderWindow { base }
#		proc actualizaInteractor { base }
#		proc manejadorEstado { base estado }

#		
#
#		Privadas : 
#			proc colorToRGB { val } --> "rr gg bb"
#			proc distCamaraActor { base ac }
#			proc pica { base }
#			proc selecciona { base baseData } 
#			proc enlacesDelAtomo { base baseData numAtomo }
#			proc coloreaComoSeleccionadoAtomo { base numAtomo listaEnlaces }
#			proc coloreaComoSeleccionadoEnlace { base baseData i j t }
#
#
#
############################################################################################################

package require vtk
package require vtkinteraction
package require math::constants

namespace eval VisorVTK {
	
	
	#crea una instancia definiendo un array VisorVTK::$base
	proc newVisorVTK { base } {
		if {[info exists VisorVTK::$base]==0} {
			variable $base
			set ${base}(render) [vtkRenderer ${base}ren]
			set ${base}(renderW) [vtkRenderWindow ${base}renWin]
			#set ${base}(renderWInt) [vtkRenderWindowInteractor ${base}iren]
			set ${base}(intStyle) [vtkInteractorStyleTrackballCamera ${base}styleCamera]
			set ${base}(picker) [vtkCellPicker ${base}picker]
				${base}picker SetTolerance 0.00004
			set ${base}(propPicker) [vtkPropPicker ${base}propPicker]
			
			
			${base}ren SetBackground .1 .2 .4
			${base}renWin AddRenderer ${base}ren
			#${base}iren SetRenderWindow ${base}renWin
			
			set ${base}(lookupTable) [vtkLookupTable ${base}lut]
			#${base}iren Initialize
			
			#vtkAxesActor axis
			#${base}ren AddActor axis
			return 0
			
		} else {
			return -1
		}
	}; #finproc
	
	proc delVisorVTK { base } {
		upvar #0 VisorVTK::$base visor
		
		if {[array exists visor]} {
			#borro los actores de esferas y cilindors
			delDatosVisorVTK $base
			
#			$visor(esfera) Delete	
#			$visor(cilindro) Delete	
#			$visor(esferaMapper) Delete
#			$visor(cilindroMapper) Delete
			
			$visor(ejesMarker) Delete
			$visor(ejesCoord) Delete
			
			
			$visor(atomoCB) Delete	
			$visor(atomoMapperCB) Delete	

			$visor(enlacePoints) Delete	
			$visor(enlaceCells) Delete	

			$visor(rSelectPoints) Delete	
			$visor(rSelectCells) Delete	
			$visor(rSelectPolyData) Delete	
			$visor(rSelectPolyDataMapper) Delete	
			$visor(rSelectActor) Delete	
			
			$visor(medidasPoints) Delete	
			$visor(medidasCells) Delete	
			$visor(medidasPolyData) Delete	
			$visor(medidasPolyDataMapper) Delete	
			$visor(medidasActor) Delete	
			
			$visor(puentesHPoints) Delete	
			$visor(puentesHCells) Delete	
			$visor(puentesHPolyData) Delete	
			$visor(puentesHPolyDataMapper) Delete	
			$visor(puentesHActor) Delete	
			
			$visor(renderWInt) Delete
			$visor(renderW) Delete
			$visor(render) Delete
			$visor(intStyle) Delete
			$visor(picker) Delete
			$visor(propPicker) Delete
			
			$visor(lookupTable) Delete
			
			foreach luz $visor(luces) { $luz Delete }
			
			unset VisorVTK::$base
		}
	}; #finproc
	
	#borra todo el contenido del Visor
	proc delDatosVisorVTK { base } {
		upvar #0 VisorVTK::$base visor
		foreach mol $visor(moleculas) {
			VisorVTK::delDatosMolVisorVTK $base $mol
		}
		eliminarOrbitalesVisor $base
		VisorVTK::eliminarPuentesH v
		$visor(renderW) Render
	}; #finproc
	
	proc delDatosMolVisorVTKSelecc { base } {
		upvar #0 VisorVTK::$base visor
		set molList [devuelveMolSelecc $base]
		#puts "Las moleculas que se hayan seleccionadas son : $molList"
		if {[llength $molList] == 0} {
			set molList $visor(moleculas)
			#puts "no hay ninguna seleccionada, asi q las borro todas : $molList"
		}
		foreach mol $molList {
			VisorVTK::delDatosMolVisorVTK $base $mol
		}
		$visor(renderW) Render
		return $molList
	}; #finproc
	
	#borra los datos contenidos de la molecula baseData en el visor
	proc delDatosMolVisorVTK { base baseData } {
	
		upvar #0 VisorVTK::${base} visor
		
		foreach actor $visor(actoresAtomos,$baseData) {
			$visor(render) RemoveActor $actor
			$actor Delete
		}
		foreach actor $visor(actoresEnlaces,$baseData) {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
			$visor(render) RemoveActor $actor
			$actor Delete
			${b}_scalarEnlace_${i}_${j}_${t} Delete
			${b}_pdEnlace_${i}_${j}_${t} Delete
			${b}_tfEnlace_${i}_${j}_${t} Delete
			${b}_mapperEnlace_${i}_${j}_${t} Delete
		}
		
		unset visor(numAtomos,$baseData)
		unset visor(numEnlaces,$baseData)
		unset visor(actoresAtomos,$baseData)
		unset visor(actoresEnlaces,$baseData)
		unset visor(actoresAtomosVTKSeleccionados,$baseData)
		unset visor(actoresEnlacesVTKSeleccionados,$baseData)
		
		
		unset visor(scalarsEnlaces,$baseData)
		unset visor(polydataEnlaces,$baseData)
		unset visor(tubefilterEnlaces,$baseData)
		unset visor(mapperEnlaces,$baseData)
		
		#puts "Borrando molecula $baseData"
		
		set index [lsearch -exact $visor(moleculas) $baseData]
		#puts "index de visor(moleculas) para $baseData : $index"
		set visor(moleculas) [lreplace $visor(moleculas) $index $index]
		
		#actualizo el nombre de fichero activo
		if {[llength $visor(moleculas)] > 1 || [llength $visor(moleculas)] == 0} {
			set visor(ficheroSeleccionado) "Fichero no Definido"
		} else {
			upvar #0 Data::[lindex $visor(moleculas) 0] datos
			set visor(ficheroSeleccionado) $datos(nombreFich)
		}
		VisorVTK::eliminarPuentesH v
	}; #finproc
	
	#inicializa el visor creando los objetos basicos necesarios
	proc inicializarVisor { base } {
		
		upvar #0 VisorVTK::$base visor
		
		#inicio ciertas variables por defecto
		set visor(moleculas) [list]
		set visor(ficheroSeleccionado) "Fichero no Definido"
		
		set visor(scalarsEnlaces) [list]
		set visor(polydataEnlaces) [list]
		set visor(tubefilterEnlaces) [list]
		set visor(mapperEnlaces) [list]
		#set visor(actoresEnlaces) [list]
		
		set visor(actoresTexto) [list]
		set visor(semillaActoresTexto) 0
		set visor(actoresSeleccMedidas) [list]
		set visor(listaMedidas) [list]
		
		set visor(listaEtiquetas) [list]
		set visor(actoresEtiquetas) [list]
		set visor(etqId) 0
		set visor(etqCodB) 0
		set visor(etqCarga) 0
		set visor(etqCodTink) 0
		set visor(etqQuira) 0
		
		
		
		set visor(listaPuentesH) [list]
		set visor(elemsPuentesH) [list]
		set visor(distPuentesH) 0
		
		set visor(opcionAct) "rotar"
		set visor(SHIFT) 0
		set visor(CTRL) 0
		set visor(agregaSeleccion) 0
		set visor(ejesRot) [list]
		
		set visor(actorOpcMover) ""
		set visor(ratonIzqPuls) 0
		set visor(ratonDchoPuls) 0
		set visor(ratonMov) 0
		set visor(DobleClick) 0
		
		set visor(escalaCPK) 9
		set visor(ladosTubeFilter) 18
		
		set visor(orbitales) [list]
		
		#creo un actor para definir unos ejes de coordenadas
		set visor(ejesCoord) [vtkAxesActor ${base}axes]
		$visor(ejesCoord) SetShaftTypeToCylinder
		$visor(ejesCoord) SetCylinderRadius 0.04
		$visor(ejesCoord) VisibilityOff
		[$visor(ejesCoord) GetXAxisCaptionActor2D] SetHeight 0.07
		[$visor(ejesCoord) GetXAxisCaptionActor2D] SetWidth 0.07
		[$visor(ejesCoord) GetYAxisCaptionActor2D] SetHeight 0.07
		[$visor(ejesCoord) GetYAxisCaptionActor2D] SetWidth 0.07
		[$visor(ejesCoord) GetZAxisCaptionActor2D] SetHeight 0.07
		[$visor(ejesCoord) GetZAxisCaptionActor2D] SetWidth 0.07
		
		
		set visor(ejesMarker) [vtkOrientationMarkerWidget ${base}marker]
			$visor(ejesMarker) SetOutlineColor 0 1 0
			$visor(ejesMarker) SetOrientationMarker ${base}axes
			#$visor(ejesMarker) SetViewport -0.2 -0.2 0.12 0.2
			$visor(ejesMarker) SetViewport 0.0 0.0 0.13 0.2
			
		
		#$visor(render) AddActor $visor(ejesCoord)
		#marker SetInteractor $visor(renderWInt)
		#marker SetEnabled 1
		#marker InteractiveOff
		
		#$visor(render) VisibilityOff
		
		
		#para evitar los saltos q se producen al entrar en el renderer desde otra ventana
		#hay algo q desconozco q cambia el valor del LastEventPosition, asi q hago el control manual
		set visor(last) "0 0"
		
		#creo una esfera que representara los atomos en el modo cilindros y bolas, y cilindros
		set visor(atomoCB) [vtkSphereSource ${base}atomoCB]
			$visor(atomoCB) SetCenter 0 0 0 
			$visor(atomoCB) SetRadius 0.1
			$visor(atomoCB) SetThetaResolution 18
			$visor(atomoCB) SetStartTheta 0
			$visor(atomoCB) SetEndTheta 360
			$visor(atomoCB) SetPhiResolution 18
			$visor(atomoCB) SetStartPhi 0
			$visor(atomoCB) SetEndPhi 180
			
		
			
		#creo los mappers de los actores atomos
		set visor(atomoMapperCB) [vtkPolyDataMapper ${base}atomoMapperCB]
			$visor(atomoMapperCB) SetInput [$visor(atomoCB) GetOutput]
		
			
		#creo una cell q representa una polylinde de 3 tramos, centrada en 0 0 0
		set visor(enlacePoints) [vtkPoints ${base}enlacePoints]
			$visor(enlacePoints) InsertPoint 0 0.0 -0.5 0.0 
			$visor(enlacePoints) InsertPoint 1 0.0 -0.25 0.0
			$visor(enlacePoints) InsertPoint 2 0.0 0.25 0.0
			$visor(enlacePoints) InsertPoint 3 0.0 0.5 0.0
			
		set visor(enlaceCells) [vtkCellArray ${base}enlaceCells]
			$visor(enlaceCells) InsertNextCell 2
				$visor(enlaceCells) InsertCellPoint 0
				$visor(enlaceCells) InsertCellPoint 1
			$visor(enlaceCells) InsertNextCell 2
			    $visor(enlaceCells) InsertCellPoint 1
			    $visor(enlaceCells) InsertCellPoint 2
	        $visor(enlaceCells) InsertNextCell 2
			    $visor(enlaceCells) InsertCellPoint 2
			    $visor(enlaceCells) InsertCellPoint 3
		
		
		#estas dos variables definen el rectangulo de seleccion del visor, a partir de 2 de sus esquinas
		set visor(rSelect) 0 ; #indica si el rectangulo de seleccion debe ser mostrado
		set visor(rSelectI) "0 0"
		set visor(rSelectF) "0 0"
		
		#creo un actor q representara el rectangulo de seleccion tipo lazo
		set visor(rSelectPoints) [vtkPoints ${base}rSelectPoints]
		set visor(rSelectCells) [vtkCellArray ${base}rSelectCells]
		set visor(rSelectPolyData) [vtkPolyData ${base}rSelectpolyData]
			$visor(rSelectPolyData) SetPoints $visor(rSelectPoints)
			$visor(rSelectPolyData) SetLines $visor(rSelectCells)
		set visor(rSelectPolyDataMapper) [vtkPolyDataMapper2D ${base}rSelectpdMapper]
			$visor(rSelectPolyDataMapper) SetInput $visor(rSelectPolyData)
		set visor(rSelectActor) [vtkActor2D ${base}rSelectActor]
			$visor(rSelectActor) SetMapper $visor(rSelectPolyDataMapper)
			[$visor(rSelectActor) GetProperty] SetColor 1 0.9254 0
			$visor(rSelectActor) PickableOff
		$visor(render) AddActor $visor(rSelectActor)
		
		
		#creo un actor que representara las medidas que se tomen en nuestro programa
		set visor(medidasPoints) [vtkPoints ${base}medidasPoints]
		set visor(medidasCells) [vtkCellArray ${base}medidasCells]
		set visor(medidasPolyData) [vtkPolyData ${base}medidaspolyData]
			$visor(medidasPolyData) SetPoints $visor(medidasPoints)
			$visor(medidasPolyData) SetLines $visor(medidasCells)
		set visor(medidasPolyDataMapper) [vtkPolyDataMapper ${base}medidaspdMapper]
			$visor(medidasPolyDataMapper) SetInput $visor(medidasPolyData)
		set visor(medidasActor) [vtkActor ${base}medidasActor]
			$visor(medidasActor) SetMapper $visor(medidasPolyDataMapper)
			[$visor(medidasActor) GetProperty] SetColor 0 1 0
			$visor(medidasActor) PickableOff
		$visor(render) AddActor $visor(medidasActor)
		
		
		#creo un actor que representara los puentes de hidrogeno
		set visor(puentesHPoints) [vtkPoints ${base}puentesHPoints]
		set visor(puentesHCells) [vtkCellArray ${base}puentesHCells]
		set visor(puentesHPolyData) [vtkPolyData ${base}polyDataPH]
			$visor(puentesHPolyData) SetPoints $visor(puentesHPoints)
			$visor(puentesHPolyData) SetLines $visor(puentesHCells)
			#[$visor(puentesHPolyData) GetPointData] SetScalars $visor(puentesHScalars)
		set visor(puentesHPolyDataMapper) [vtkPolyDataMapper ${base}pdMapperPH]
			$visor(puentesHPolyDataMapper) SetInput $visor(puentesHPolyData)
		set visor(puentesHActor) [vtkActor ${base}puentesHActor]
			$visor(puentesHActor) SetMapper $visor(puentesHPolyDataMapper)
			[$visor(puentesHActor) GetProperty] SetColor 0 1 0
			$visor(puentesHActor) PickableOff
			#[$visor(puentesHActor) GetProperty] SetLineWidth 10
		$visor(render) AddActor $visor(puentesHActor)
		
		
		
		#orbitales
		set visor(orbitales) [list]
		
		#creo 3 luces y las apago
		set visor(luces) [list]
		for {set x 0} {$x < 3} {incr x} {
			set l [vtkLight "${base}_light_$x"]
				$l SwitchOff
				#$l PositionalOn
				$l SetIntensity 0.5
			lappend visor(luces) $l
			$visor(render) AddLight $l
		}
		
		#superficies
		set visor(superficies) [list]
		set visor(semillaSuperficies) 0

	}; #finproc
	
	proc inicializarLookupTable { base baseConf } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Conf::$baseConf config
		
		
		$visor(lookupTable) SetNumberOfColors 93
		$visor(lookupTable) Build
		
		set x 0
		foreach elem $config(listaSimb) {
			set col [colorToRGB $config(colorSimb,$elem)]
			$visor(lookupTable) SetTableValue $x [lindex $col 0] [lindex $col 1] [lindex $col 2] 1
			incr x
		}
		#inserto un ultimo color para los objetos seleccionados, amarillo en ppo 255 250 205 #FFFACD
		$visor(lookupTable) SetTableValue $x [expr 255 / 255.0] [expr 236 / 255.0] [expr 0 / 255.0] 1
	}; #finproc
	
	#devuelve el nombre base de un actor, que es realmente el nombre base de la instancia Data de los datos q representa
	proc devuelveDataDeActor { actor } {
		scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9\_]} b r
		return $b
	}; #finproc
	
	#devuelve una lista con los nombres base de todas las moleculas q haya en el visor
	proc devuelveListaMol { base } {
		upvar #0 VisorVTK::$base visor
		return $visor(moleculas)
	}; #finproc
	
	
	proc cargaVisorMolData { base baseData baseConf } {
		
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		upvar #0 Conf::$baseConf config
		
		#creo una nueva molecula 
		lappend visor(moleculas) $baseData
		set visor(actoresAtomos,$baseData) [list]
		set visor(actoresEnlaces,$baseData) [list]
		set visor(scalarsEnlaces,$baseData) [list]
		set visor(tubefilterEnlaces,$baseData) [list]
		set visor(polydataEnlaces,$baseData) [list]
		set visor(mapperEnlaces,$baseData) [list]
		
		
		
		set visor(actoresAtomosVTKSeleccionados,$baseData) [list]
		set visor(actoresEnlacesVTKSeleccionados,$baseData) [list]
		
		#creo un actor esfera por cada atomo, con la representacion de una esfera
		set visor(numAtomos,$baseData) $datos(numAtomos)
		
		#Los defino como vtkActor
		for {set x 0} {$x < $visor(numAtomos,$baseData)} {incr x} {
			#inserto el nombre en la lista
			lappend visor(actoresAtomos,$baseData) [vtkActor ${baseData}_actorAtomo_$x]
			
			set visor(estadoRepres,$baseData,$x) "CB"
			
			
			#por defector le pongo el mapper de CB
			set actor [lindex $visor(actoresAtomos,$baseData) $x]
			$actor SetMapper $visor(atomoMapperCB)
			
			#establezco las propiedades del atomo
			$actor SetPosition $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)
			$actor SetScale [expr $datos(radioVdW,$x)*1.5]
			
			set color [colorToRGB $datos(colorAtom,$x)]
			
				
			eval [$actor GetProperty] SetColor [lindex $color 0] [lindex $color 1] [lindex $color 2]
			[$actor GetProperty] SetSpecularColor 1 1 1
			[$actor GetProperty] SetSpecular 0.5
			[$actor GetProperty] SetSpecularPower 50
			[$actor GetProperty] SetDiffuse 0.9
			[$actor GetProperty] SetAmbient 0.1
			#[$actor GetProperty] SetSpecular 0
			
			#podemos considerar un assembly, de momento estan los actores sueltos
			$visor(render) AddActor $actor
			
			set visor(visible,$actor) 1
			
		}
		
		
		#creo un actor cilindro por cada enlace, que exista conectividad, no quiere decir que solo haya un enlace
		#pues este puede ser simple, doble o triple, lo que se conoce por datos(tipoConect,i,j)
		set visor(numEnlaces,$baseData) 0
		
		for {set i 0} {$i < $visor(numAtomos,$baseData)} {incr i} {
			foreach j $datos(conect,$i) {
				
				#para no repetir los enlaces
				if {$j < $i} {
					
					set props [Data::calculoProp $baseData $i $j]
					set visor(estadoRepresEn,$baseData,$i,$j) "CB"
					
					switch $datos(tipoConect,$i,$j) {
						2 {
							#enlace doble, debo generar 2 actores cilindros
							incr visor(numEnlaces,$baseData) 2
							
							# el actor enlace consta de 1 polydata, un intArray un tubeFilter, un polydatamapper y un actor
							lappend visor(scalarsEnlaces,$baseData) [vtkIntArray ${baseData}_scalarEnlace_${i}_${j}_A]
								#cargar los colores adecuados
							set x [lindex $visor(scalarsEnlaces,$baseData) end]
							set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
							set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
							
							#puts "$numOrdeni $numOrdenj"
							
							#inserto los escalares en el enlace
							$x InsertTuple1 0 $numOrdeni
							$x InsertTuple1 1 $numOrdeni
							$x InsertTuple1 2 $numOrdenj
							$x InsertTuple1 3 $numOrdenj
								
		
							lappend visor(polydataEnlaces,$baseData) [vtkPolyData ${baseData}_pdEnlace_${i}_${j}_A]
							set x [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetPoints $visor(enlacePoints)
							$x SetLines $visor(enlaceCells)
							[$x GetPointData] SetScalars [lindex $visor(scalarsEnlaces,$baseData) end]
							
							lappend visor(tubefilterEnlaces,$baseData) [vtkTubeFilter ${baseData}_tfEnlace_${i}_${j}_A]
							set x [lindex $visor(tubefilterEnlaces,$baseData) end]
							$x SetInput [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetRadius 0.1
							$x SetNumberOfSides $visor(ladosTubeFilter)
							
							
							#por defecto lo asocio a los tubes
							lappend visor(mapperEnlaces,$baseData) [vtkPolyDataMapper ${baseData}_mapperEnlace_${i}_${j}_A]
							set x [lindex $visor(mapperEnlaces,$baseData) end]
							$x SetInputConnection [[lindex $visor(tubefilterEnlaces,$baseData) end] GetOutputPort]
							$x SetLookupTable $visor(lookupTable)
							$x SetColorModeToMapScalars
							$x SetScalarRange 0.0 92.0
							

							lappend visor(actoresEnlaces,$baseData) [vtkActor ${baseData}_actorEnlace_${i}_${j}_A]
							
							#establezco propiedades
							set actor [lindex $visor(actoresEnlaces,$baseData) end]
							$actor SetMapper [lindex $visor(mapperEnlaces,$baseData) end]
							$actor SetScale 0.4 [expr [lindex $props 7] - 0.3] 0.4
							$actor SetPosition [lindex $props 0] [lindex $props 1] [lindex $props 2]
							$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
							[$actor GetProperty] SetSpecularColor 1 1 1
							[$actor GetProperty] SetSpecular 0.5
							[$actor GetProperty] SetSpecularPower 50
							[$actor GetProperty] SetDiffuse 0.2
							[$actor GetProperty] SetAmbient 0.01
							
							$visor(render) AddActor $actor
							set visor(visible,$actor) 1
							
							#el otro enlace
							# el actor enlace consta de 1 polydata, un intArray un tubeFilter, un polydatamapper y un actor
							lappend visor(scalarsEnlaces,$baseData) [vtkIntArray ${baseData}_scalarEnlace_${i}_${j}_B]
								#cargar los colores adecuados
							set x [lindex $visor(scalarsEnlaces,$baseData) end]
							set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
							set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
							
							#puts "$numOrdeni $numOrdenj"
							
							#inserto los escalares en el enlace
							$x InsertTuple1 0 $numOrdeni
							$x InsertTuple1 1 $numOrdeni
							$x InsertTuple1 2 $numOrdenj
							$x InsertTuple1 3 $numOrdenj
								
		
							lappend visor(polydataEnlaces,$baseData) [vtkPolyData ${baseData}_pdEnlace_${i}_${j}_B]
							set x [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetPoints $visor(enlacePoints)
							$x SetLines $visor(enlaceCells)
							[$x GetPointData] SetScalars [lindex $visor(scalarsEnlaces,$baseData) end]
							
							lappend visor(tubefilterEnlaces,$baseData) [vtkTubeFilter ${baseData}_tfEnlace_${i}_${j}_B]
							set x [lindex $visor(tubefilterEnlaces,$baseData) end]
							$x SetInput [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetRadius 0.1
							$x SetNumberOfSides $visor(ladosTubeFilter)
							
							
							#por defecto lo asocio a los tubes
							lappend visor(mapperEnlaces,$baseData) [vtkPolyDataMapper ${baseData}_mapperEnlace_${i}_${j}_B]
							set x [lindex $visor(mapperEnlaces,$baseData) end]
							$x SetInputConnection [[lindex $visor(tubefilterEnlaces,$baseData) end] GetOutputPort]
							$x SetLookupTable $visor(lookupTable)
							$x SetColorModeToMapScalars
							$x SetScalarRange 0.0 92.0
							

							lappend visor(actoresEnlaces,$baseData) [vtkActor ${baseData}_actorEnlace_${i}_${j}_B]
							
							#establezco propiedades
							set actor [lindex $visor(actoresEnlaces,$baseData) end]
							$actor SetMapper [lindex $visor(mapperEnlaces,$baseData) end]
							$actor SetScale 0.4 [expr [lindex $props 7] - 0.3] 0.4
							$actor SetPosition [lindex $props 8] [lindex $props 9] [lindex $props 10]
							$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
							[$actor GetProperty] SetSpecularColor 1 1 1
							[$actor GetProperty] SetSpecular 0.5
							[$actor GetProperty] SetSpecularPower 50
							[$actor GetProperty] SetDiffuse 0.2
							[$actor GetProperty] SetAmbient 0.01
							
							$visor(render) AddActor $actor
							set visor(visible,$actor) 1
						}
						
						3 {
							#enlace triple, 
							incr visor(numEnlaces,$baseData) 3
							
							# el actor enlace consta de 1 polydata, un intArray un tubeFilter, un polydatamapper y un actor
							lappend visor(scalarsEnlaces,$baseData) [vtkIntArray ${baseData}_scalarEnlace_${i}_${j}_A]
								#cargar los colores adecuados
							set x [lindex $visor(scalarsEnlaces,$baseData) end]
							set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
							set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
							
							#puts "$numOrdeni $numOrdenj"
							
							#inserto los escalares en el enlace
							$x InsertTuple1 0 $numOrdeni
							$x InsertTuple1 1 $numOrdeni
							$x InsertTuple1 2 $numOrdenj
							$x InsertTuple1 3 $numOrdenj
								
		
							lappend visor(polydataEnlaces,$baseData) [vtkPolyData ${baseData}_pdEnlace_${i}_${j}_A]
							set x [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetPoints $visor(enlacePoints)
							$x SetLines $visor(enlaceCells)
							[$x GetPointData] SetScalars [lindex $visor(scalarsEnlaces,$baseData) end]
							
							lappend visor(tubefilterEnlaces,$baseData) [vtkTubeFilter ${baseData}_tfEnlace_${i}_${j}_A]
							set x [lindex $visor(tubefilterEnlaces,$baseData) end]
							$x SetInput [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetRadius 0.1
							$x SetNumberOfSides $visor(ladosTubeFilter)
							
							
							#por defecto lo asocio a los tubes
							lappend visor(mapperEnlaces,$baseData) [vtkPolyDataMapper ${baseData}_mapperEnlace_${i}_${j}_A]
							set x [lindex $visor(mapperEnlaces,$baseData) end]
							$x SetInputConnection [[lindex $visor(tubefilterEnlaces,$baseData) end] GetOutputPort]
							$x SetLookupTable $visor(lookupTable)
							$x SetColorModeToMapScalars
							$x SetScalarRange 0.0 92.0
							

							lappend visor(actoresEnlaces,$baseData) [vtkActor ${baseData}_actorEnlace_${i}_${j}_A]
							
							#establezco propiedades
							set actor [lindex $visor(actoresEnlaces,$baseData) end]
							$actor SetMapper [lindex $visor(mapperEnlaces,$baseData) end]
							$actor SetScale 0.4 [expr [lindex $props 7] - 0.3] 0.4
							$actor SetPosition [lindex $props 0] [lindex $props 1] [lindex $props 2]
							$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
							[$actor GetProperty] SetSpecularColor 1 1 1
							[$actor GetProperty] SetSpecular 0.5
							[$actor GetProperty] SetSpecularPower 50
							[$actor GetProperty] SetDiffuse 0.2
							[$actor GetProperty] SetAmbient 0.01
			
							$visor(render) AddActor $actor
							set visor(visible,$actor) 1
							
							#el 2º enlace
							# el actor enlace consta de 1 polydata, un intArray un tubeFilter, un polydatamapper y un actor
							lappend visor(scalarsEnlaces,$baseData) [vtkIntArray ${baseData}_scalarEnlace_${i}_${j}_B]
								#cargar los colores adecuados
							set x [lindex $visor(scalarsEnlaces,$baseData) end]
							set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
							set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
							
							#puts "$numOrdeni $numOrdenj"
							
							#inserto los escalares en el enlace
							$x InsertTuple1 0 $numOrdeni
							$x InsertTuple1 1 $numOrdeni
							$x InsertTuple1 2 $numOrdenj
							$x InsertTuple1 3 $numOrdenj
								
		
							lappend visor(polydataEnlaces,$baseData) [vtkPolyData ${baseData}_pdEnlace_${i}_${j}_B]
							set x [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetPoints $visor(enlacePoints)
							$x SetLines $visor(enlaceCells)
							[$x GetPointData] SetScalars [lindex $visor(scalarsEnlaces,$baseData) end]
							
							lappend visor(tubefilterEnlaces,$baseData) [vtkTubeFilter ${baseData}_tfEnlace_${i}_${j}_B]
							set x [lindex $visor(tubefilterEnlaces,$baseData) end]
							$x SetInput [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetRadius 0.1
							$x SetNumberOfSides $visor(ladosTubeFilter)
							
							
							#por defecto lo asocio a los tubes
							lappend visor(mapperEnlaces,$baseData) [vtkPolyDataMapper ${baseData}_mapperEnlace_${i}_${j}_B]
							set x [lindex $visor(mapperEnlaces,$baseData) end]
							$x SetInputConnection [[lindex $visor(tubefilterEnlaces,$baseData) end] GetOutputPort]
							$x SetLookupTable $visor(lookupTable)
							$x SetColorModeToMapScalars
							$x SetScalarRange 0.0 92.0
							

							lappend visor(actoresEnlaces,$baseData) [vtkActor ${baseData}_actorEnlace_${i}_${j}_B]
							
							#establezco propiedades
							set actor [lindex $visor(actoresEnlaces,$baseData) end]
							$actor SetMapper [lindex $visor(mapperEnlaces,$baseData) end]
							$actor SetScale 0.4 [expr [lindex $props 7] - 0.3] 0.4
							$actor SetPosition [lindex $props 8] [lindex $props 9] [lindex $props 10]
							$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
							[$actor GetProperty] SetSpecularColor 1 1 1
							[$actor GetProperty] SetSpecular 0.5
							[$actor GetProperty] SetSpecularPower 50
							[$actor GetProperty] SetDiffuse 0.2
							[$actor GetProperty] SetAmbient 0.01
			
							$visor(render) AddActor $actor
							set visor(visible,$actor) 1
							
							#el 3º enlace
							# el actor enlace consta de 1 polydata, un intArray un tubeFilter, un polydatamapper y un actor
							lappend visor(scalarsEnlaces,$baseData) [vtkIntArray ${baseData}_scalarEnlace_${i}_${j}_C]
								#cargar los colores adecuados
							set x [lindex $visor(scalarsEnlaces,$baseData) end]
							set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
							set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
							
							#puts "$numOrdeni $numOrdenj"
							
							#inserto los escalares en el enlace
							$x InsertTuple1 0 $numOrdeni
							$x InsertTuple1 1 $numOrdeni
							$x InsertTuple1 2 $numOrdenj
							$x InsertTuple1 3 $numOrdenj
								
		
							lappend visor(polydataEnlaces,$baseData) [vtkPolyData ${baseData}_pdEnlace_${i}_${j}_C]
							set x [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetPoints $visor(enlacePoints)
							$x SetLines $visor(enlaceCells)
							[$x GetPointData] SetScalars [lindex $visor(scalarsEnlaces,$baseData) end]
							
							lappend visor(tubefilterEnlaces,$baseData) [vtkTubeFilter ${baseData}_tfEnlace_${i}_${j}_C]
							set x [lindex $visor(tubefilterEnlaces,$baseData) end]
							$x SetInput [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetRadius 0.1
							$x SetNumberOfSides $visor(ladosTubeFilter)
							
							
							#por defecto lo asocio a los tubes
							lappend visor(mapperEnlaces,$baseData) [vtkPolyDataMapper ${baseData}_mapperEnlace_${i}_${j}_C]
							set x [lindex $visor(mapperEnlaces,$baseData) end]
							$x SetInputConnection [[lindex $visor(tubefilterEnlaces,$baseData) end] GetOutputPort]
							$x SetLookupTable $visor(lookupTable)
							$x SetColorModeToMapScalars
							$x SetScalarRange 0.0 92.0
							

							lappend visor(actoresEnlaces,$baseData) [vtkActor ${baseData}_actorEnlace_${i}_${j}_C]
							
							#establezco propiedades
							set actor [lindex $visor(actoresEnlaces,$baseData) end]
							$actor SetMapper [lindex $visor(mapperEnlaces,$baseData) end]
							$actor SetScale 0.4 [expr [lindex $props 7] - 0.3] 0.4
							$actor SetPosition [lindex $props 11] [lindex $props 12] [lindex $props 13]
							$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
							[$actor GetProperty] SetSpecularColor 1 1 1
							[$actor GetProperty] SetSpecular 0.5
							[$actor GetProperty] SetSpecularPower 50
							[$actor GetProperty] SetDiffuse 0.2
							[$actor GetProperty] SetAmbient 0.01
							
							$visor(render) AddActor $actor
							set visor(visible,$actor) 1
							
						}
						
						default {
							#enlace simple, debo generar 1 actor enlace
							incr visor(numEnlaces,$baseData)

							# el actor enlace consta de 1 polydata, un intArray un tubeFilter, un polydatamapper y un actor
							lappend visor(scalarsEnlaces,$baseData) [vtkIntArray ${baseData}_scalarEnlace_${i}_${j}_A]
								#cargar los colores adecuados
							set x [lindex $visor(scalarsEnlaces,$baseData) end]
							set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
							set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
							
							#puts "$numOrdeni $numOrdenj"
							
							#inserto los escalares en el enlace
							$x InsertTuple1 0 $numOrdeni
							$x InsertTuple1 1 $numOrdeni
							$x InsertTuple1 2 $numOrdenj
							$x InsertTuple1 3 $numOrdenj
								
		
							lappend visor(polydataEnlaces,$baseData) [vtkPolyData ${baseData}_pdEnlace_${i}_${j}_A]
							set x [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetPoints $visor(enlacePoints)
							$x SetLines $visor(enlaceCells)
							[$x GetPointData] SetScalars [lindex $visor(scalarsEnlaces,$baseData) end]
							
							lappend visor(tubefilterEnlaces,$baseData) [vtkTubeFilter ${baseData}_tfEnlace_${i}_${j}_A]
							set x [lindex $visor(tubefilterEnlaces,$baseData) end]
							$x SetInput [lindex $visor(polydataEnlaces,$baseData) end]
							$x SetRadius 0.1
							$x SetNumberOfSides $visor(ladosTubeFilter)
							
							
							#por defecto lo asocio a los tubes
							lappend visor(mapperEnlaces,$baseData) [vtkPolyDataMapper ${baseData}_mapperEnlace_${i}_${j}_A]
							set x [lindex $visor(mapperEnlaces,$baseData) end]
							$x SetInputConnection [[lindex $visor(tubefilterEnlaces,$baseData) end] GetOutputPort]
							$x SetLookupTable $visor(lookupTable)
							$x SetColorModeToMapScalars
							$x SetScalarRange 0.0 92.0
							

							lappend visor(actoresEnlaces,$baseData) [vtkActor ${baseData}_actorEnlace_${i}_${j}_A]
							
							#establezco propiedades
							set actor [lindex $visor(actoresEnlaces,$baseData) end]
							$actor SetMapper [lindex $visor(mapperEnlaces,$baseData) end]
							$actor SetScale 1 [expr [lindex $props 7] - 0.3] 1
							$actor SetPosition [lindex $props 0] [lindex $props 1] [lindex $props 2]
							set ii [lindex $props 3]
							$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
							[$actor GetProperty] SetSpecularColor 1 1 1
							[$actor GetProperty] SetSpecular 0.5
							[$actor GetProperty] SetSpecularPower 50
							[$actor GetProperty] SetDiffuse 0.2
							[$actor GetProperty] SetAmbient 0.01
							
							$visor(render) AddActor $actor
							set visor(visible,$actor) 1
						}
					}
				}
			}
		}
		$visor(render) ResetCamera
		$visor(renderW) Render
		
	}; #finproc
	
	#solo actualiza las posiciones de los actores
	proc actualizaVisorMolData { base baseData } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		
		foreach actor $visor(actoresAtomos,$baseData) {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			$actor SetPosition $datos(coordX,$x) $datos(coordY,$x) $datos(coordZ,$x)
		}
		foreach actor $visor(actoresEnlaces,$baseData) {
			#para los enlaces calculo su posicion y orientacion a partir de los atomos a los q estan conectados
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
			set props [Data::calculoProp $baseData $i $j]
			
			#reseteo su posicion original, al eje Y
			$actor SetOrientation 0 1 0
			if {$t == "A"} {
				$actor SetPosition [lindex $props 0] [lindex $props 1] [lindex $props 2]
				$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
			} elseif {$t == "B"} {
				$actor SetPosition [lindex $props 8] [lindex $props 9] [lindex $props 10]
				$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
			} elseif {$t == "C"} {
				$actor SetPosition [lindex $props 11] [lindex $props 12] [lindex $props 13]
				$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
			}
		}
	}; #finproc
	
	#devuelve el color asociado al simbolo de un atomo
	proc colorToRGB { val } {
		set rr 0; set gg 0; set bb 0
		scan $val "#%2x%2x%2x" rr gg bb
		set rr [format "%1.4f" [expr $rr.0/255]]
		set gg [format "%1.4f" [expr $gg.0/255]]
		set bb [format "%1.4f" [expr $bb.0/255]]
		return "$rr $gg $bb"
	}; #finproc

	proc render { base } {
		upvar #0 VisorVTK::$base visor
		$visor(renderW) Render
	};#finproc
	
	proc resetCameraClippingRange { base } {
		upvar #0 VisorVTK::$base visor
		$visor(render) ResetCameraClippingRange
	}; #finproc
	
	proc devuelveFicheroSeleccionado { base } {
		upvar #0 VisorVTK::$base visor
		return $visor(ficheroSeleccionado)
	}; #finproc

	proc cargarOrbitalFich { base filename nombreOrbital } {
		upvar #0 VisorVTK::$base visor
		
		#si el orbital existe, lo borro
		eliminarOrbital $base $nombreOrbital
		
		#creo el orbital
		lappend visor(orbitales) $nombreOrbital
		
		set n "${base}_structuredPointReaderOrb_${nombreOrbital}_POS"
		vtkStructuredPointsReader $n
			$n SetFileName $filename
			$n SetScalarsName "POS"
			$n Update
		
		set n "${base}_structuredPointReaderOrb_${nombreOrbital}_NEG"
		vtkStructuredPointsReader $n
			$n SetFileName $filename
			$n SetScalarsName "NEG"
			$n Update
		
		set n "${base}_marchingCubesOrb_${nombreOrbital}_POS"
		vtkMarchingCubes $n
			$n SetInput ["${base}_structuredPointReaderOrb_${nombreOrbital}_POS" GetOutput]
			$n SetValue 0 60
		
		set n "${base}_marchingCubesOrb_${nombreOrbital}_NEG"
		vtkMarchingCubes $n
			$n SetInput ["${base}_structuredPointReaderOrb_${nombreOrbital}_NEG" GetOutput]
			$n SetValue 0 60
		
		set n "${base}_polyDataMapperOrb_${nombreOrbital}_POS"
		vtkPolyDataMapper $n
			$n SetInput ["${base}_marchingCubesOrb_${nombreOrbital}_POS" GetOutput]
			$n ScalarVisibilityOff
		
		set n "${base}_polyDataMapperOrb_${nombreOrbital}_NEG"
		vtkPolyDataMapper $n
			$n SetInput ["${base}_marchingCubesOrb_${nombreOrbital}_NEG" GetOutput]
			$n ScalarVisibilityOff
		
		set n "${base}_actorOrb_${nombreOrbital}_POS"
			vtkActor $n
			$n SetMapper "${base}_polyDataMapperOrb_${nombreOrbital}_POS"
			$n PickableOff
			[$n GetProperty] SetPointSize 2
			eval [$n GetProperty] SetColor $Colors::venetian_red
			
			puts [[$n GetProperty] GetSpecularColor]
			puts [[$n GetProperty] GetSpecular]
			puts [[$n GetProperty] GetSpecularPower]
			puts [[$n GetProperty] GetDiffuse]
			puts [[$n GetProperty] GetAmbient]
			
			
			[$n GetProperty] SetSpecularColor 1 1 1
			[$n GetProperty] SetSpecular 0.5
			[$n GetProperty] SetSpecularPower 50
			[$n GetProperty] SetDiffuse 0.9
			[$n GetProperty] SetAmbient 0.1
			
		set n "${base}_actorOrb_${nombreOrbital}_NEG"
		puts $n
			vtkActor $n
			$n SetMapper "${base}_polyDataMapperOrb_${nombreOrbital}_NEG"
			$n PickableOff
			[$n GetProperty] SetPointSize 2
			eval [$n GetProperty] SetColor $Colors::blue
			[$n GetProperty] SetSpecularColor 1 1 1
			[$n GetProperty] SetSpecular 0.5
			[$n GetProperty] SetSpecularPower 50
			[$n GetProperty] SetDiffuse 0.9
			[$n GetProperty] SetAmbient 0.1
			
		$visor(render) AddActor "${base}_actorOrb_${nombreOrbital}_POS"
		$visor(render) AddActor "${base}_actorOrb_${nombreOrbital}_NEG"
		
		
		#actualizo las luces segun el tamaño del orbital
		#creo una asamblea con los actores de los orbitales, y calculos los limites de su caja
		vtkAssembly assemTemp
			assemTemp AddPart "${base}_actorOrb_${nombreOrbital}_POS"
			assemTemp AddPart "${base}_actorOrb_${nombreOrbital}_NEG"
		set center [assemTemp GetCenter]	
		set bounds [assemTemp GetBounds]
		assemTemp Delete
		
		#situo las luces a una distancia superior del volumen de los orbitales, respecto de su centro
		#especifico la distancia de separacion en proporcion al orbital en lugar de darle un valor fijo
		#set distSepar
		set distSepar 0
		
		#uso las 3 luces definidas por defecto en el VisorVTK
		[lindex $visor(luces) 0] SetPosition [expr [lindex $bounds 1] + $distSepar] [lindex $center 1] [lindex $center 2]
		[lindex $visor(luces) 1] SetPosition [lindex $center 0] [expr [lindex $bounds 3] + $distSepar] [lindex $center 2]
		[lindex $visor(luces) 2] SetPosition [lindex $center 0] [lindex $center 1] [expr [lindex $bounds 5] + $distSepar]
		
		$visor(render) ResetCamera
		lappend visor(orbital) $nombreOrbital
	}; #finproc 
	
	proc modificarIsovalorOrbital { base nombreOrbital level } {
		upvar #0 VisorVTK::$base visor
		if {[lsearch -exact $visor(orbitales) $nombreOrbital] != -1} {
			"${base}_marchingCubesOrb_${nombreOrbital}_POS" SetValue 0 $level
			"${base}_marchingCubesOrb_${nombreOrbital}_NEG" SetValue 0 $level
			$visor(renderW) Render
		}
	}; #finproc
	
	proc modificarTransparenciaOrbital { base nombreOrbital level } {
		upvar #0 VisorVTK::$base visor
		if {[lsearch -exact $visor(orbitales) $nombreOrbital] != -1} {
			["${base}_actorOrb_${nombreOrbital}_POS" GetProperty] SetOpacity $level
			["${base}_actorOrb_${nombreOrbital}_NEG" GetProperty] SetOpacity $level	
			$visor(renderW) Render
		}
	}; #finproc
	
	proc activarDesactivarEspecularOrbital { base nombreOrbital } {
		upvar #0 VisorVTK::$base visor
		if {[lsearch -exact $visor(orbitales) $nombreOrbital] != -1} {
			if {[["${base}_actorOrb_${nombreOrbital}_POS" GetProperty] GetSpecular] == 0} {
				set n "${base}_actorOrb_${nombreOrbital}_POS"
				[$n GetProperty] SetSpecular 0.5
				[$n GetProperty] SetSpecularPower 50
				[$n GetProperty] SetDiffuse 0.9
				[$n GetProperty] SetAmbient 0.1
				
				set n "${base}_actorOrb_${nombreOrbital}_NEG"
				[$n GetProperty] SetSpecular 0.5
				[$n GetProperty] SetSpecularPower 50
				[$n GetProperty] SetDiffuse 0.9
				[$n GetProperty] SetAmbient 0.1
			} else {
				set n "${base}_actorOrb_${nombreOrbital}_POS"
				[$n GetProperty] SetSpecular 0
				[$n GetProperty] SetSpecularPower 1
				[$n GetProperty] SetDiffuse 1
				[$n GetProperty] SetAmbient 0
				
				set n "${base}_actorOrb_${nombreOrbital}_NEG"
				[$n GetProperty] SetSpecular 0
				[$n GetProperty] SetSpecularPower 1
				[$n GetProperty] SetDiffuse 1
				[$n GetProperty] SetAmbient 0
			}
			$visor(renderW) Render
		}
	}; #finproc
	
	proc devuelveTransparenciaOrbital { base nombreOrbital } {
		upvar #0 VisorVTK::$base visor
		if {[lsearch -exact $visor(orbitales) $nombreOrbital] != -1} {
			["${base}_actorOrb_${nombreOrbital}_POS" GetProperty] GetOpacity 
		} else {
			return -1
		}
	}; #finproc 
	
	proc modificarRepresentacionOrbital { base nombreOrbital representacion } {
		upvar #0 VisorVTK::$base visor
		if {[lsearch -exact $visor(orbitales) $nombreOrbital] != -1} {
			["${base}_actorOrb_${nombreOrbital}_POS" GetProperty] SetRepresentationTo${representacion}
			["${base}_actorOrb_${nombreOrbital}_NEG" GetProperty] SetRepresentationTo${representacion}
			$visor(renderW) Render
		}
	}; #finproc
	
	proc eliminarOrbital { base nombreOrbital } {
		upvar #0 VisorVTK::$base visor
		
		set index [lsearch -exact $visor(orbitales) $nombreOrbital]
		if {$index != -1} {
			$visor(render) RemoveActor "${base}_actorOrb_${nombreOrbital}_POS"
			$visor(render) RemoveActor "${base}_actorOrb_${nombreOrbital}_NEG"
			
			"${base}_structuredPointReaderOrb_${nombreOrbital}_POS" Delete
			"${base}_structuredPointReaderOrb_${nombreOrbital}_NEG" Delete
			"${base}_marchingCubesOrb_${nombreOrbital}_POS" Delete
			"${base}_marchingCubesOrb_${nombreOrbital}_NEG" Delete
			"${base}_polyDataMapperOrb_${nombreOrbital}_POS" Delete
			"${base}_polyDataMapperOrb_${nombreOrbital}_NEG" Delete
			"${base}_actorOrb_${nombreOrbital}_POS" Delete
			"${base}_actorOrb_${nombreOrbital}_NEG" Delete
			
			set visor(orbitales) [lreplace $visor(orbitales) $index $index]
		}
	}; #finproc
	
	proc eliminarOrbitalesVisor { base } {
		upvar #0 VisorVTK::$base visor
		foreach nombreOrbital $visor(orbitales) {
			eliminarOrbital $base $nombreOrbital
		}
	}; #finproc
	
	proc encenderApagarLuz { base numLuz encenderApagar } {
		upvar #0 VisorVTK::$base visor
		if { $numLuz < [llength $visor(luces)] } {
			set luz [lindex $visor(luces) $numLuz]	
			if {$encenderApagar == 0} {
				$luz SwitchOff
			} else {
				$luz SwitchOn
			}
			$visor(renderW) Render
		}
	}; #finproc
	
	proc devolverEstadoLuz { base numLuz } {
		upvar #0 VisorVTK::$base visor
		if { $numLuz < [llength $visor(luces)] } { 
			set luz [lindex $visor(luces) $numLuz]	
			return [$luz GetSwitch]
		} else {
			return 0
		}
		
	}; #finproc

	proc cambiarProyeccionCamara { base paralelaConica } {
		upvar #0 VisorVTK::$base visor
		if {$paralelaConica == 0} {
			[$visor(render) GetActiveCamera] ParallelProjectionOn
		} else {
			[$visor(render) GetActiveCamera] ParallelProjectionOff
		}
		$visor(renderW) Render
	}; #finproc
	
	proc devolverProyeccionCamara { base } {
		upvar #0 VisorVTK::$base visor
		return [[$visor(render) GetActiveCamera] GetParallelProjection]
	}; #finproc
	
	#listaEsferas es una lista de 4-tuplas "centroX centroY centroZ radio" de todas las esferas que formaran parte de la superficie
	#para la superficie se crearan vtkSpheres q son funciones implicitas, despues se sumaran dichas funciones mediante un vtkImplicitBoolean
	#obteniendo una nueva funcion implicita, una vez aki mediante un vtkSampleFunction, obtenemos un vtkStructuredPoints de la funcion anterior	
	proc generarSuperficie { base baseConf } {
		upvar #0 VisorVTK::$base visor
		
		eliminarSuperficiesVisorVTK $base
		
		set listaM [devuelveMolSeleccEntera $base]
		if {$listaM == ""} {
			set listaM $visor(moleculas)
		}
		
		set lista [Data::generaListaCentroRadio $listaM]
		incr visor(semillaSuperficies)
		set super "${base}_superficie_$visor(semillaSuperficies)"
		
		generarSuperficieLista $base $super $lista $baseConf

	}; #finproc
	
	proc generarSuperficieLista2 { base nombreSuperficie listaEsferas } {
		upvar #0 VisorVTK::$base visor
		
		if {[lsearch $visor(superficies) $nombreSuperficie] == -1 && [llength $listaEsferas] > 0} {
			lappend visor(superficies) $nombreSuperficie
			
			set ib "${base}_implicitBoolean_${nombreSuperficie}"
			vtkImplicitBoolean $ib
			$ib SetOperationTypeToUnion
			#para cada elemento
			for {set x 0} {$x < [llength $listaEsferas]} {incr x} {
				set e [lindex $listaEsferas $x]
				if {$e != ""} {
					#creamos una funcion de esfera
					set esf "${base}_esfera_${nombreSuperficie}"
					vtkSphere $esf
						$esf SetCenter [lindex $e 0] [lindex $e 1] [lindex $e 2]
						$esf SetRadius [lindex $e 3]
					
					#sumo a la funcion implicita
					$ib AddFunction $esf
					
					#elimino la esfera
					$esf Delete
				}
			}
			
			set sf "${base}_sampleFunction_${nombreSuperficie}"
			vtkSampleFunction $sf
				$sf SetImplicitFunction $ib
				$sf SetModelBounds -5 5 -5 5 -5 5
				#$sf SetSampleDimensions 100 60 60
			
			
			
			set cf "${base}_contourFilter_${nombreSuperficie}"
			vtkContourFilter $cf
				$cf SetInputConnection [$sf GetOutputPort]
				$cf SetValue 4 0.0
			
			set mapper "${base}_polyDataMapper_${nombreSuperficie}"
			vtkPolyDataMapper $mapper
				$mapper SetInputConnection [$cf GetOutputPort]
				$mapper ScalarVisibilityOff
			
			set actor "${base}_actorSuperficie_${nombreSuperficie}"
			vtkActor $actor
				$actor SetMapper $mapper
				$actor PickableOff
				[$actor GetProperty] SetColor .97 .97 .97
				
			#elimino lo q no necesito
			$ib Delete
			$sf Delete
			$cf Delete
			$mapper Delete
			
			$visor(render) AddActor $actor
			$visor(renderW) Render
		} 
	}; #finproc
	
	
	proc generarSuperficieLista { base nombreSuperficie listaEsferas baseConf } {
		upvar #0 VisorVTK::$base visor
		
		if {[lsearch $visor(superficies) $nombreSuperficie] == -1 && [llength $listaEsferas] > 0} {
			lappend visor(superficies) $nombreSuperficie
			
			
			#calculo los limites
			set lx [list]; set ly [list]; set lz [list]; set lr [list]
			foreach e $listaEsferas {
				lappend lx [lindex $e 0]; lappend ly [lindex $e 1]; lappend lz [lindex $e 2]; lappend lr [lindex $e 3]
			}
			set lx [lsort -real -increasing $lx]
			set ly [lsort -real -increasing $ly]
			set lz [lsort -real -increasing $lz]
			set lr [lsort -real -increasing $lr]
			#tengo listas ordenadas de las coordenadas y radios
			
			set ib "${base}_implicitBoolean_${nombreSuperficie}"
			vtkImplicitBoolean $ib
			$ib SetOperationTypeToUnion
			#para cada elemento
			for {set x 0} {$x < [llength $listaEsferas]} {incr x} {
				set e [lindex $listaEsferas $x]
				if {$e != ""} {
					#creamos una funcion de esfera
					set esf "${base}_esfera_${nombreSuperficie}"
					vtkSphere $esf
						$esf SetCenter [lindex $e 0] [lindex $e 1] [lindex $e 2]
						$esf SetRadius [lindex $e 3]
					
					#sumo a la funcion implicita
					$ib AddFunction $esf
					
					#elimino la esfera
					$esf Delete
				}
			}
			
			set sf "${base}_sampleFunction_${nombreSuperficie}"
			vtkSampleFunction $sf
				$sf SetImplicitFunction $ib
				puts "$sf SetModelBounds  [expr [lindex $lx 0] - [lindex $lr end]] [expr [lindex $lx end] + [lindex $lr end]] \
									[expr [lindex $ly 0] - [lindex $lr end]] [expr [lindex $ly end] + [lindex $lr end]] \
									[expr [lindex $lz 0] - [lindex $lr end]] [expr [lindex $lz end] + [lindex $lr end]]"
				
				puts "$lx\n$ly\n$lz\n$lr"
				$sf SetModelBounds  [expr [lindex $lx 0] - [lindex $lr end] -10] [expr [lindex $lx end] + [lindex $lr end] +10] \
									[expr [lindex $ly 0] - [lindex $lr end] -10] [expr [lindex $ly end] + [lindex $lr end] +10] \
									[expr [lindex $lz 0] - [lindex $lr end] -10] [expr [lindex $lz end] + [lindex $lr end] +10]
				
				#$sf SetModelBounds -5 5 -5 5 -5 5
				#$sf SetModelBounds -20 20 -20 20 -20 20
				$sf SetSampleDimensions 100 100 100

			set cf "${base}_contourFilter_${nombreSuperficie}"
			vtkContourFilter $cf
				$cf SetInputConnection [$sf GetOutputPort]
				$cf SetValue 0 10.0
				$cf ComputeNormalsOn
				#cf ComputeScalarsOn 
				#cf SetValue 0 0.0
			
			#actualizo los escalares
			$cf Update
			set pdata [$cf GetOutput]
			
			set points [$pdata GetPoints]
			set scalars [[$pdata GetPointData] GetScalars]
			actualizaScalarsSuperficie $points $scalars $listaEsferas $baseConf
			#for {set i 0} {$i < 1000} {incr i 5} {
			#	$scalars SetValue $i 10
			#}
			
			#$scalars Modified
			#$pdata Modified
			
			set mapper "${base}_polyDataMapper_${nombreSuperficie}"
			vtkPolyDataMapper $mapper
				$mapper SetInputConnection [$cf GetOutputPort]
				$mapper ScalarVisibilityOn
				$mapper SetLookupTable $visor(lookupTable)
				$mapper SetColorModeToMapScalars
				$mapper SetScalarRange 0.0 92.0
							
				
			set actor "${base}_actorSuperficie_${nombreSuperficie}"
			puts $actor
			vtkActor $actor
				$actor SetMapper $mapper
				$actor PickableOff
				[$actor GetProperty] SetColor .97 .97 .97
				
			#elimino lo q no necesito
			$ib Delete
			$sf Delete
			$cf Delete
			$mapper Delete
			
			$visor(render) AddActor $actor
			#$visor(render) ResetCameraClippingRange
			$visor(render) ResetCamera
			$visor(renderW) Render
		} 
	}; #finproc
	
	#actualiza los escalares segun el punto al q corresponde y la funcion calculaEscalarSuperficie
	proc actualizaScalarsSuperficie { points scalars listaEsferas baseConf } {
		
		upvar #0 Conf::$baseConf config
		
		puts "numero de puntos : [$points GetNumberOfPoints]"
		puts "numero de scalars : [$scalars GetNumberOfTuples]"
		for {set x 0} {$x < [$points GetNumberOfPoints]} {incr x} {
			
			set point [$points GetPoint $x]
			#puts "para el punto $point : "
			
			#calculo cual es el mas cercano
			set min 0
			set dismin 10000
			for {set i 0} {$i < [llength $listaEsferas]} {incr i} {
				set at [lindex $listaEsferas $i]
				set dist [expr [math::linearalgebra::norm [math::linearalgebra::sub $point "[lindex $at 0] [lindex $at 1] [lindex $at 2]"]]  - [lindex $at 3]]
				if {$dist < $dismin} {
					set min $config(numOrdenAtomo,[lindex $at 4])
					set dismin $dist
				}
			}
			#puts "Distancia : $dist $min"
			$scalars SetValue $x $min
		}
		
		
	}; #finproc
	
	
	proc eliminarSuperficie { base nombreSuperficie } {
		upvar #0 VisorVTK::$base visor
		set index [lsearch $visor(superficies) $nombreSuperficie]
		if {$index != -1 } {
			set actor "${base}_actorSuperficie_${nombreSuperficie}"
			$visor(render) RemoveActor $actor
			$actor Delete
			set visor(superficies) [lreplace $visor(superficies) $index $index]
			$visor(renderW) Render
		}
	}; #finproc
	
	proc eliminarSuperficiesVisorVTK { base } {
		upvar #0 VisorVTK::$base visor
		foreach sup $visor(superficies) {
			eliminarSuperficie $base $sup
		}
	}; #finproc
	
	#la transformacion sera en base al estado de la 1º superficie q haya en la lista visor(superficies), si esta opaca, se aplicara transparencia
	#a todas
	proc transparenciaSuperficies { base onOff } {
		upvar #0 VisorVTK::$base visor
		
		if {[llength $visor(superficies)] > 0} {
			if {$onOff == 1} {
				set opacity 1
			} else {
				set opacity 0.5
			}
			
			foreach super $visor(superficies) {
				["${base}_actorSuperficie_${super}" GetProperty] SetOpacity $opacity
			}
			$visor(renderW) Render
		}
	}; #finproc
	
	proc modificarRepresentacionSuperficie { base representacion } {
		upvar #0 VisorVTK::$base visor
		if {[llength $visor(superficies)] > 0} {
			foreach super $visor(superficies) {
				["${base}_actorSuperficie_${super}" GetProperty] SetRepresentationTo${representacion}
			}
			$visor(renderW) Render
		}
	}; #finproc 
	
	proc cambiarResolucionVisorVTK { base numeroLados } {
		upvar #0 VisorVTK::$base visor
		
			
		$visor(atomoCB) SetThetaResolution $numeroLados
		$visor(atomoCB) SetPhiResolution $numeroLados
		
		#cambio el numero de tubeFilters
		set visor(ladosTubeFilter) $numeroLados
		
		foreach mol $visor(moleculas) {
			foreach e $visor(tubefilterEnlaces,$mol) {
				$e SetNumberOfSides $visor(ladosTubeFilter)
			}
		}
		#$visor(renderW) Render
	}; #finproc
	
	proc cambiarAntiAliasingVisorVTK { base numberFrames } {
		upvar #0 VisorVTK::$base visor
		
		$visor(renderW) SetAAFrames $numberFrames
		$visor(renderW) Render
	}; #finproc

#----------------------------------------------------------------------------------------------
#										-	REPRESENTACION   -
#----------------------------------------------------------------------------------------------			
	#representa en lineas los atomos y los enlaces q estan conectados a el,
	#pero no los enlaces seleccionados de forma simple, funciona asi por similitud con el ActiveX
	
	proc cambiarColorFondo { base color } {
		upvar #0 VisorVTK::$base visor
		puts $color
		set c [colorToRGB $color]
		$visor(render) SetBackground [lindex $c 0] [lindex $c 1] [lindex $c 2]
		$visor(renderW) Render
	}; #finproc

	#cambia la representacion de todo lo que hay seleccionado en el visor al modo especificado por "modo"	
	proc representaEn { base modo } {
		upvar #0 VisorVTK::$base visor
	
		set molSelecc [devuelveMolSelecc $base]
		if {[llength $molSelecc] == 0} {
			set molSelecc $visor(moleculas)
		}
		foreach mol $molSelecc {
			representaEn${modo}Mol $base $mol
		}
		#$visor(renderW) Render
	}; #finproc
	
	proc representaEnLineasMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		
			#seleccionos los actores q debo transformar
			if {[llength $visor(actoresAtomosVTKSeleccionados,$baseData)] == 0 && [llength $visor(actoresEnlacesVTKSeleccionados,$baseData)] == 0} {
				set listaAtomos $visor(actoresAtomos,$baseData)
			} else {
				set listaAtomos $visor(actoresAtomosVTKSeleccionados,$baseData)
			}
			
			#contrendra los enlaces que ya han sido tratados, para evitar repetidos
			#ya que por ej : En atA<----->atB, el enlace seria tratado 2 veces
			set listaTratados [list]
			
			foreach actor $listaAtomos {
				scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
				if {$visor(estadoRepres,$baseData,$x) != "L"} {
					set estadoAnt $visor(estadoRepres,$baseData,$x)
					set visor(estadoRepres,$baseData,$x) "L"
	
					
					#para cada actor seleccionado, transformo a lineas sus enlaces
					set listaEnlaces [enlacesDelAtomo $base $baseData $x]
					
					if {[llength $listaEnlaces] == 0} {
						$actor SetScale 0.2
					} else {
						$actor VisibilityOff
					}
					
					foreach e $listaEnlaces {
						scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
						
						set visor(estadoRepresEn,$baseData,$i,$j) "L"
						#debo tener en cuenta el estado de representacion del otro atomo conectado al enlace
					
						if {$x == $i} {
							#mi atomo es el del lado i del enlace, debo comprobar el atomo del lado j
							set adyacente $j
						} else {
							#mi atomo es el del lado j del enlace, debo comprobar el atomo del lado i
							set adyacente $i
						}
	
						"${b}_tfEnlace_${i}_${j}_${t}" SetRadius 0.01
						
						if {($estadoAnt == "CB" || $estadoAnt == "CPK") && ($visor(estadoRepres,$baseData,$adyacente) == "CB" || $visor(estadoRepres,$baseData,$adyacente) == "CPK" ) } {
							if {[lsearch -exact $listaTratados $e] == -1} {
								lappend listaTratados $e
								#escalo el enlace par que tenga la longitud correcta
								set s [$e GetScale]
								$e SetScale [lindex $s 0] [expr [lindex $s 1] + 0.3] [lindex $s 2]
							}
						}	
					}
				}
			}
			#$visor(renderW) Render
		
	}; #finproc 
	
	proc representaEnCilindrosMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		
			#seleccionos los actores q debo transformar
			if {[llength $visor(actoresAtomosVTKSeleccionados,$baseData)] == 0 && [llength $visor(actoresEnlacesVTKSeleccionados,$baseData)] == 0} {
				set listaAtomos $visor(actoresAtomos,$baseData)
			} else {
				set listaAtomos $visor(actoresAtomosVTKSeleccionados,$baseData)
			}
			set listaTratados [list]
			
			foreach actor $listaAtomos {
				scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
				if {$visor(estadoRepres,$baseData,$x) != "C"} {
					set estadoAnt $visor(estadoRepres,$baseData,$x)
					set visor(estadoRepres,$baseData,$x) "C"
					
					if {$estadoAnt == "L" && $visor(visible,$actor) == 1} {
						$actor VisibilityOn
					}
					$actor SetScale 0.95
					
					set listaEnlaces [enlacesDelAtomo $base $baseData $x]
					
					#en este caso no usamos la listaTratados, aunque asi los enlaces eran tratados 2 veces
					#pero es necesario en ciertos casos, como L<---->L<---->L, donde tras una pasada, su adyacente 
					#sera L, y no se tocara el enlace, y durante la 2º L<---->L<---->C, sera C y ya podra modificarse
					foreach e $listaEnlaces {
						scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
						
						#debo tener en cuenta el estado de representacion del otro atomo conectado al enlace
						
						if {$x == $i} {
							#mi atomo es el del lado i del enlace, debo comprobar el atomo del lado j
							set adyacente $j
						} else {
							#mi atomo es el del lado j del enlace, debo comprobar el atomo del lado i
							set adyacente $i
						}
						
						#en caso de q la representacion del adyacente sea L, el enlace seguira siendo el correspondiente
						#a L, en el caso de ser CB, la cambiare a C porq de lo contrario el enlace seria mas corto de la cuenta
						if {$visor(estadoRepres,$baseData,$adyacente) != "L"} {
							set visor(estadoRepresEn,$baseData,$i,$j) "C"
							if {$estadoAnt == "L"} {
								"${b}_tfEnlace_${i}_${j}_${t}" SetRadius 0.1
							} elseif {($estadoAnt == "CB" || $estadoAnt == "CPK") && ($visor(estadoRepres,$baseData,$adyacente) == "CB" || $visor(estadoRepres,$baseData,$adyacente) == "CPK" ) } {
								set s [$e GetScale]
								#en el caso de 2 pasadas, se incrementaria su tam 2 veces, asi lo evitamos
								if {[lsearch -exact $listaTratados $e] == -1} {
									lappend listaTratados $e
									$e SetScale [lindex $s 0] [expr [lindex $s 1] + 0.3] [lindex $s 2]
								}
							}
						}
					}
				}
			}
			#$visor(renderW) Render
	}; #finproc
	
	proc representaEnCilindrosYBolasMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos

		if {[llength $visor(actoresAtomosVTKSeleccionados,$baseData)] == 0 && [llength $visor(actoresEnlacesVTKSeleccionados,$baseData)] == 0} {
			set listaAtomos $visor(actoresAtomos,$baseData)
		} else {
			set listaAtomos $visor(actoresAtomosVTKSeleccionados,$baseData)
		}
		set listaTratados [list]
		
		foreach actor $listaAtomos {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			if {$visor(estadoRepres,$baseData,$x) != "CB"} { 
				set estadoAnt $visor(estadoRepres,$baseData,$x)
				set visor(estadoRepres,$baseData,$x) "CB"
				
				if {$estadoAnt == "L"  && $visor(visible,$actor) == 1} {
					$actor VisibilityOn
				}
				$actor SetScale [expr $datos(radioVdW,$x)*1.5]
				
				set listaEnlaces [enlacesDelAtomo $base $baseData $x]
				
				foreach e $listaEnlaces {
					scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
					
					#debo tener en cuenta el estado de representacion del otro atomo conectado al enlace
					if {$x == $i} {
						#mi atomo es el del lado i del enlace, debo comprobar el atomo del lado j
						set adyacente $j
					} else {
						#mi atomo es el del lado j del enlace, debo comprobar el atomo del lado i
						set adyacente $i
					}

					#solo cambiare el enlace en el caso de que los adyacentes sean CB, en caso contrario se quedaran
					#como esten, si es L, seguira siendo L, si es C, se quedara C porq si se cambiara a CB, se quedaria
					#mas corto de la cuenta
					if {$visor(estadoRepres,$baseData,$adyacente) != "L"} {
						if {$estadoAnt == "L"} {
							"${b}_tfEnlace_${i}_${j}_${t}" SetRadius 0.1
						}
						#tanto si estaba en L o C, y el adyacente es CB, debo reducir su longitud, tb se tienen en cuenta las 2 pasadas
						#y se evita que se reduzcan 2 veces
						if {(($visor(estadoRepres,$baseData,$adyacente) == "CB") || ($visor(estadoRepres,$baseData,$adyacente) == "CPK")) && \
						    ($estadoAnt == "L" || $estadoAnt == "C")} {
							if {[lsearch -exact $listaTratados $e] == -1} {
								set visor(estadoRepresEn,$baseData,$i,$j) "CB"
								lappend listaTratados $e
								set s [$e GetScale]		
								$e SetScale [lindex $s 0] [expr [lindex $s 1] - 0.3] [lindex $s 2]
							}
						}
					}
				}
			}
		}
		#$visor(renderW) Render
	}; #finproc
	
	proc representaEnCPKMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		
		if {[llength $visor(actoresAtomosVTKSeleccionados,$baseData)] == 0 && [llength $visor(actoresEnlacesVTKSeleccionados,$baseData)] == 0} {
			set listaAtomos $visor(actoresAtomos,$baseData)
		} else {
			set listaAtomos $visor(actoresAtomosVTKSeleccionados,$baseData)
		}
		set listaTratados [list]
		
		foreach actor $listaAtomos {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			if {$visor(estadoRepres,$baseData,$x) != "CPK"} { 
				set estadoAnt $visor(estadoRepres,$baseData,$x)
				set visor(estadoRepres,$baseData,$x) "CPK"
				
				if {$estadoAnt == "L" && $visor(visible,$actor) == 1} {
					$actor VisibilityOn
				}
				$actor SetScale [expr $datos(radioVdW,$x) * $visor(escalaCPK)]
				
				set listaEnlaces [enlacesDelAtomo $base $baseData $x]
				
				foreach e $listaEnlaces {
					scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
					
					#debo tener en cuenta el estado de representacion del otro atomo conectado al enlace
					if {$x == $i} {
						#mi atomo es el del lado i del enlace, debo comprobar el atomo del lado j
						set adyacente $j
					} else {
						#mi atomo es el del lado j del enlace, debo comprobar el atomo del lado i
						set adyacente $i
					}

					#solo cambiare el enlace en el caso de que los adyacentes sean CB, en caso contrario se quedaran
					#como esten, si es L, seguira siendo L, si es C, se quedara C porq si se cambiara a CB, se quedaria
					#mas corto de la cuenta
					if {$visor(estadoRepres,$baseData,$adyacente) != "L"} {
						if {$estadoAnt == "L"} {
							"${b}_tfEnlace_${i}_${j}_${t}" SetRadius 0.1
						}
						#tanto si estaba en L o C, y el adyacente es CB, debo reducir su longitud, tb se tienen en cuenta las 2 pasadas
						#y se evita que se reduzcan 2 veces
						if {($visor(estadoRepres,$baseData,$adyacente) == "CB" || $visor(estadoRepres,$baseData,$adyacente) == "CPK") && \
						    ($estadoAnt == "L" || $estadoAnt == "C")} {
							if {[lsearch -exact $listaTratados $e] == -1} {
								set visor(estadoRepresEn,$baseData,$i,$j) "CPK"
								lappend listaTratados $e
								set s [$e GetScale]		
								$e SetScale [lindex $s 0] [expr [lindex $s 1] - 0.3] [lindex $s 2]
							}
						}
					}
				}
			}
		}
		#$visor(renderW) Render
	}; #finproc
	
	proc cambiarEscalaCPK { base escala } {
		upvar #0 VisorVTK::$base visor
		set visor(escalaCPK) $escala
	}; #finproc
	
	proc ocultarMostrarHidrogenosMol { base baseData mostrarOcultar} {
		upvar #0 VisorVTK::$base visor
		
		set listaH [Data::devolverHidrogenosMol $baseData]
		foreach x $listaH {
			ocultarMostrarAtomo $base $baseData $x $mostrarOcultar
		}
		$visor(renderW) Render
	}; #finproc

	proc ocultarMostrarAtomo { base baseData numAtomo mostrarOcultar } {
		upvar #0 VisorVTK::$base visor
		
		if {$mostrarOcultar == 0 } {
			${baseData}_actorAtomo_${numAtomo} VisibilityOff
			set visor(visible,${baseData}_actorAtomo_${numAtomo}) 0
			
			eliminaListaMedidasActor $base ${baseData}_actorAtomo_${numAtomo}
			
			set enlaces [enlacesDelAtomo $base $baseData $numAtomo]
			foreach e $enlaces {	
				$e VisibilityOff
				set visor(visible,$e) 0
			}
			calcularMedidas $base
		} elseif {$mostrarOcultar == 1} {
			if {$visor(estadoRepres,$baseData,$numAtomo) != "L"} {
				${baseData}_actorAtomo_${numAtomo} VisibilityOn
			}
			set visor(visible,${baseData}_actorAtomo_${numAtomo}) 1
			set enlaces [enlacesDelAtomo $base $baseData $numAtomo]
			foreach e $enlaces {	
				$e VisibilityOn
				set visor(visible,$e) 1
			}
		}
	}; #finproc
	
	#este muestra u oculta la mol baseData, pero no tiene en cuenta las medidas q puedan estar presentes en el visor, de momento
	#solo se usa en los orbitales, ya q no se mide en ellos
	proc ocultarMostrarMol { base baseData mostrarOcultar } {
		upvar #0 VisorVTK::$base visor
		
		if {$mostrarOcultar == 0} {
			foreach actor $visor(actoresAtomos,$baseData) { $actor VisibilityOff }
			foreach actor $visor(actoresEnlaces,$baseData) { $actor VisibilityOff }
		} else {
			foreach actor $visor(actoresAtomos,$baseData) { $actor VisibilityOn }
			foreach actor $visor(actoresEnlaces,$baseData) { $actor VisibilityOn }
		}
		$visor(renderW) Render
	}; #finproc
	
	
	proc devuelveRenderWindow { base } {
		upvar #0 VisorVTK::$base visor
		return $visor(renderW)
	}; #finproc
	
	#actualiza el interactor y le asocia el picker
	proc actualizaInteractor { base baseConf } {
		upvar #0 VisorVTK::$base visor
		
		set visor(renderWInt) [$visor(renderW) GetInteractor]
		$visor(renderWInt) SetInteractorStyle $visor(intStyle)
		#$visor(renderWInt) SetInteractorStyle ""
		
		#quitamos los observers que manejaremos nosotros
		$visor(renderWInt) RemoveObservers 12 ; # LeftButtonPressEvent
		$visor(renderWInt) RemoveObservers 13 ; # LeftButtonReleaseEvent
		$visor(renderWInt) RemoveObservers 16 ; # RightButtonPressEvent
		$visor(renderWInt) RemoveObservers 17 ; # RightButtonReleaseEvent
		#$visor(renderWInt) RemoveObservers 18 ; # EnterEvent
		
		
		$visor(renderWInt) AddObserver LeftButtonReleaseEvent "VisorVTK::manejadorLBRE $base $baseConf"
		$visor(renderWInt) AddObserver LeftButtonPressEvent "VisorVTK::manejadorLBPE $base"
		#$visor(renderWInt) AddObserver RightButtonReleaseEvent "VisorVTK::manejadorRBRE $base"
		$visor(renderWInt) AddObserver RightButtonPressEvent "VisorVTK::manejadorRBPE $base"
		$visor(renderWInt) AddObserver MouseMoveEvent "VisorVTK::manejadorMME $base $baseConf"
		#$visor(renderWInt) AddObserver KeyPressEvent "VisorVTK::manejadorKPE $base"
		#$visor(renderWInt) AddObserver KeyReleaseEvent "VisorVTK::manejadorKRE $base"
		
		[$visor(render) GetActiveCamera] ParallelProjectionOn
		
		$visor(ejesMarker) SetInteractor $visor(renderWInt)
		$visor(ejesMarker) SetEnabled 1
		$visor(ejesMarker) InteractiveOff
		#$visor(ejesMarker) SetEnabled 0
		[$visor(ejesMarker) GetOrientationMarker] PickableOff
		
		
		
		
		#$visor(renderWInt) SetPicker $visor(picker)
	}; #finproc
	
	proc actualizaInteractorOrb { base baseConf } {
		upvar #0 VisorVTK::$base visor
		
		set visor(renderWInt) [$visor(renderW) GetInteractor]
		$visor(renderWInt) SetInteractorStyle $visor(intStyle)
		#$visor(renderWInt) SetInteractorStyle ""
		
		#quitamos los observers que manejaremos nosotros
		$visor(renderWInt) RemoveObservers 20 ; # LeftButtonPressEvent
		$visor(renderWInt) RemoveObservers 21 ; # LeftButtonReleaseEvent
		#$visor(renderWInt) RemoveObservers 16 ; # RightButtonPressEvent
		#$visor(renderWInt) RemoveObservers 17 ; # RightButtonReleaseEvent
		#$visor(renderWInt) RemoveObservers 18 ; # EnterEvent
		
		
		#$visor(renderWInt) AddObserver LeftButtonReleaseEvent "VisorVTK::manejadorLBRE $base $baseConf"
		#$visor(renderWInt) AddObserver LeftButtonPressEvent "VisorVTK::manejadorLBPE $base"
		#$visor(renderWInt) AddObserver RightButtonReleaseEvent "VisorVTK::manejadorRBRE $base"
		#$visor(renderWInt) AddObserver RightButtonPressEvent "VisorVTK::manejadorRBPE $base"
		#$visor(renderWInt) AddObserver MouseMoveEvent "VisorVTK::manejadorMME $base"
		#$visor(renderWInt) AddObserver KeyPressEvent "VisorVTK::manejadorKPE $base"
		#$visor(renderWInt) AddObserver KeyReleaseEvent "VisorVTK::manejadorKRE $base"
		
		[$visor(render) GetActiveCamera] ParallelProjectionOn
		
		$visor(ejesMarker) SetInteractor $visor(renderWInt)
		$visor(ejesMarker) SetEnabled 1
		$visor(ejesMarker) InteractiveOff
		$visor(ejesMarker) SetEnabled 0
		[$visor(ejesMarker) GetOrientationMarker] PickableOff
	}; #finproc
	
	
	#obsoleto
	#devolvera el actor sobre el que se haya picado
	proc seleccion2 { base } {
		upvar #0 VisorVTK::$base visor
		
		#$visor(picker) Pick 
		set pos [$visor(renderWInt) GetEventPosition]
		
		#si se ha picado sobre algun actor
		if {[$visor(picker) Pick [lindex $pos 0] [lindex $pos 1] 0.0 $visor(render)] != 0} {
			
			#en ppo supongo q el correcto es el que me devuelve GetActor
			#pero comprobare sobre todos los actores intersectados, cual se aproxima mas 
			#a la posicion sobre la que se ha picado
			set actor [$visor(picker) GetActor]
			set x [$actor GetPosition]
				$visor(render) SetWorldPoint [lindex $x 0] [lindex $x 1] [lindex $x 2] 1.0
				$visor(render) WorldToDisplay
			set x [$visor(render) GetDisplayPoint]
			
			set i [expr [lindex $pos 0] - [lindex $x 0]]
			set j [expr [lindex $pos 1] - [lindex $x 1]]
			set distMin [expr sqrt ($i * $i + $j * $j )]
			
			set actors [$visor(picker) GetActors]
			$actors InitTraversal
			set a [$actors GetNextItem]
			while {$a != ""} {
				set x [$a GetPosition]
					$visor(render) SetWorldPoint [lindex $x 0] [lindex $x 1] [lindex $x 2] 1.0
					$visor(render) WorldToDisplay
				set x [$visor(render) GetDisplayPoint]
				
				set i [expr [lindex $pos 0] - [lindex $x 0]]
				set j [expr [lindex $pos 1] - [lindex $x 1]]
				set dist [expr sqrt ($i * $i + $j * $j )]
				

				if {$dist < $distMin} {
					set distMin $dist
					set actor $a
				}
				set a [$actors GetNextItem]
			}
			
			[$actor GetProperty] SetColor 0 1 0
			$visor(renderW) Render
		}
	}; #finproc

	proc distCamaraActor { base ac } {
		upvar #0 VisorVTK::$base visor
		
		
		set x [[$visor(render) GetActiveCamera] GetPosition]
		set y [$ac GetPosition]
		
		#calculo la distancia entre la camara y el actor
		set a [expr [lindex $x 0] - [lindex $y 0]]
		set b [expr [lindex $x 1] - [lindex $y 1]]
		set c [expr [lindex $x 2] - [lindex $y 2]]
		
		set dist [expr sqrt ( $a *$ a + $b * $b + $c * $c)]
		return $dist
	}; #finproc
	
	proc mostrarOcultarEjes { base onOff } {
		upvar #0 VisorVTK::$base visor
		if {$onOff == 1} {
			$visor(ejesMarker) SetEnabled 1
		} else {
			$visor(ejesMarker) SetEnabled 0
		}
		$visor(renderW) Render
	}; #finproc	
	
	proc devolverEstadoEjes { base } {
		upvar #0 VisorVTK::$base visor
		return [$visor(ejesMarker) GetEnabled]
	}; #finproc
	
	proc ejesInteractivos { base onOff } {
		upvar #0 VisorVTK::$base visor
		if {$onOff == 1} {
			$visor(ejesMarker) SetInteractive 1
		} else {
			$visor(ejesMarker) SetInteractive 0
		}
	}; #finproc
	
	proc devolverEjesInteractivos { base } {
		upvar #0 VisorVTK::$base visor
		return [$visor(ejesMarker) GetInteractive]
	}; #finproc
	
	
#----------------------------------------------------------------------------------------------
#										-	SELECCION   -
#----------------------------------------------------------------------------------------------		
	
	#devolvera el actor y el cell sobre el q se haya picado
	proc pica { base } {
		
		upvar #0 VisorVTK::$base visor
		
		set posCam [[$visor(render) GetActiveCamera] GetPosition]
		
		set pos [$visor(renderWInt) GetEventPosition]
		if {[$visor(picker) Pick [lindex $pos 0] [lindex $pos 1] 0.0 $visor(render)] != 0} {
			
			#puts [$visor(picker) GetCellId]
			#considero que el primer actor es el correcto
			set actor [$visor(picker) GetActor]
			set x [$actor GetPosition]
			
			set distMin [math::linearalgebra::sub $posCam $x]
			set distMin [math::linearalgebra::norm $distMin]
			#distMin es la menor distancia encontrada desde la camara a algun actor
			
			set actors [$visor(picker) GetActors]
			$actors InitTraversal
			set a [$actors GetNextItem]
			while {$a != ""} {
				set x [$a GetPosition]
				
				#puts [$visor(picker) GetCellId]
				
				set dist [math::linearalgebra::sub $posCam $x]
				set dist [math::linearalgebra::norm $dist]
				
				if {$dist < $distMin} {
					set distMin $dist
					set actor $a
				}
				set a [$actors GetNextItem]
			}
			
			#aki se supone que tengo el actor mas cercano a la camara de los que se han intersectado
			
			#compruebo
			
			set cell [$visor(picker) GetCellId]
			if {[string last "Enlace" $actor] != -1} {
				scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
				#puts "es un enlace $actor"
				#puts "es un enlace $actor $visor(estadoRepresEn,$i,$j)"
			
				if {$visor(estadoRepresEn,$b,$i,$j) == "L" } {
					return "$actor"
				}
			}
			#puts "actor : $actor cell : $cell"
			return "$actor $cell"
		} else {
			puts "No ha picado nada"
			return ""
		}
		
	}; #finproc

	#sera el encargado de controlar la seleccion de elementos de una molecula
	proc seleccion { base baseConf actorYcell } {
		upvar #0 VisorVTK::$base visor
		if {[llength $actorYcell] == 2} {
			#tengo un dato correcto del picker
			set mol [devuelveDataDeActor [lindex $actorYcell 0]]
			# compruebo si es un atomo o un enlace
			if {[string last "Atomo" [lindex $actorYcell 0]] != -1 } {
				#es un atomo				
				if {$visor(SHIFT) == 0} {
					if {[lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) [lindex $actorYcell 0]] == -1} {
						deseleccionarTodo $base $baseConf
						seleccionaAtomo $base $mol $baseConf [lindex $actorYcell 0]
					} else {
						deseleccionarTodo $base $baseConf
					}
				} else {
					seleccionaAtomo $base $mol $baseConf [lindex $actorYcell 0]
				}
			} else {
				#es un enlace
				#tengo q averiguar si realmente se esta refiriendo al enlace o a alguno de sus extremos
				scan [lindex $actorYcell 0] {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
				
				
				set cell [lindex $actorYcell 1]
				if {$cell >= 0 && $cell < $visor(ladosTubeFilter)} {
					#llamada recursiva con CB Atomo
					seleccion $base $baseConf "${b}_actorAtomo_${i} 1"
				} elseif {$cell >= $visor(ladosTubeFilter) && $cell < [expr 2 * $visor(ladosTubeFilter)]} {
					if {$visor(SHIFT) == 0} {
						if {[lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) [lindex $actorYcell 0]] == -1} {
							#el atomo q he picado no estaba seleccionado
							deseleccionarTodo $base $baseConf
							seleccionaEnlace $base $mol $baseConf [lindex $actorYcell 0]
						} else {
							deseleccionarTodo $base $baseConf
						}
					} else {
						seleccionaEnlace $base $mol $baseConf [lindex $actorYcell 0]
					}
				} elseif {$cell >= [expr 2 * $visor(ladosTubeFilter)] && $cell < [expr 3 * $visor(ladosTubeFilter)]} {
						#llamada recursiva con CB Atomo
						seleccion $base $baseConf "${b}_actorAtomo_${j} 1"
				} else {
					puts "caso anomalo, intenta picar otra vez"
				}		
			}
			#$visor(renderW) Render
		} 	
	}; #finproc
	
	#deseleccionar todo lo que haya en el visor
	proc deseleccionarTodo { base baseConf } {
		upvar #0 VisorVTK::$base visor
		foreach mol $visor(moleculas) {
			deseleccionarMol $base $mol $baseConf
		}
		if {[llength $visor(moleculas)] > 1} { set visor(ficheroSeleccionado) "Fichero no Definido" }
		
		#puts $visor(ficheroSeleccionado)
	}; #finproc
	
	#deselecciona la molecula dada por baseData
	proc deseleccionarMol { base baseData baseConf } {
		upvar #0 VisorVTK::$base visor
		
		foreach x $visor(actoresAtomosVTKSeleccionados,$baseData) {
				seleccionaAtomo $base $baseData $baseConf $x
		}
		foreach x $visor(actoresEnlacesVTKSeleccionados,$baseData) {
			scan $x {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
			if {$t == "A"} {
				seleccionaEnlace $base $baseData $baseConf $x
			}
		}
	}; #finproc
	
	proc seleccionarMol { base baseData baseConf } {
		upvar #0 VisorVTK::$base visor
		
		deseleccionarMol $base $baseData $baseConf
		foreach actor $visor(actoresAtomos,$baseData) {
			seleccionaAtomo $base $baseData $baseConf $actor
		}
	}; #finproc
#		 seleccionarMolQuick $base $b $baseConf
	proc seleccionarMolQuick { base baseData baseConf } {
	
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		
		set visor(actoresAtomosVTKSeleccionados,$baseData) $visor(actoresAtomos,$baseData)
		foreach actor $visor(actoresAtomosVTKSeleccionados,$baseData) {
			[$actor GetProperty] SetColor [expr 255 / 255.0] [expr 236 / 255.0] [expr 0 / 255.0]
		}
		set visor(actoresEnlacesVTKSeleccionados,$baseData) $visor(actoresEnlaces,$baseData)
		foreach actor $visor(actoresEnlacesVTKSeleccionados,$baseData) {
			#coloreo la parte correspondiente
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
			set obj "${b}_scalarEnlace_${i}_${j}_${t}"
	
			$obj SetTuple1 0 92
			$obj SetTuple1 1 92
			$obj SetTuple1 2 92
			$obj SetTuple1 3 92
			${b}_pdEnlace_${i}_${j}_${t} Modified 
		}
		if {[llength [devuelveMolSeleccEntera $base]] == 1} {
			set visor(ficheroSeleccionado) $datos(nombreFich)
		} else {
			set visor(ficheroSeleccionado) "Fichero no Definido"
		}
		puts $visor(ficheroSeleccionado)
	}
	
	proc seleccionarTodo { base baseConf } {
		upvar #0 VisorVTK::$base visor
		foreach mol $visor(moleculas) { seleccionarMolQuick $base $mol $baseConf; $visor(renderW) Render}
	}; #finproc
	#devuelve una lista de enlaces q estan conectados a numAtomo 
	proc enlacesDelAtomo { base baseData numAtomo } {
		
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		
		set listaEnl [list]
		
		# veo todos los enlaces q tiene el atomo numAtom
		foreach x $datos(conect,$numAtomo) {
			
			if {$numAtomo < $x} {
				#se ke el enlace va de numAtomo a x
				#al menos tiene un enlace
				lappend listaEnl "${baseData}_actorEnlace_${x}_${numAtomo}_A"
				
				if {$datos(tipoConect,$numAtomo,$x) == 2} {
					lappend listaEnl "${baseData}_actorEnlace_${x}_${numAtomo}_B"
				}
				if {$datos(tipoConect,$numAtomo,$x) == 3} {
					lappend listaEnl "${baseData}_actorEnlace_${x}_${numAtomo}_B"
					lappend listaEnl "${baseData}_actorEnlace_${x}_${numAtomo}_C"
				}
			} else {
				#se ke el enlace va de x a numAtomo
				#al menos tiene un enlace
				lappend listaEnl "${baseData}_actorEnlace_${numAtomo}_${x}_A"
				
				if {$datos(tipoConect,$numAtomo,$x) == 2} {
					lappend listaEnl "${baseData}_actorEnlace_${numAtomo}_${x}_B"
				}
				if {$datos(tipoConect,$numAtomo,$x) == 3} {
					lappend listaEnl "${baseData}_actorEnlace_${numAtomo}_${x}_B"
					lappend listaEnl "${baseData}_actorEnlace_${numAtomo}_${x}_C"
				}
			}
		}
		
		#puts "Enlaces del atomo : $listaEnl"
		return $listaEnl
	}; #finproc
	
	#devuelve un lista de enlaces q estan conectados a numAtomo, pero quitando los dobles y triples : solo devuelve base_actorEnlace_i_j_A
	proc enlacesSimplesDelAtomo { base baseData numAtomo } {
		
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		
		set listaEnl [list]
		
		# veo todos los enlaces q tiene el atomo numAtom
		foreach x $datos(conect,$numAtomo) {
			
			if {$numAtomo < $x} {
				#se ke el enlace va de numAtomo a x
				#al menos tiene un enlace
				lappend listaEnl "${baseData}_actorEnlace_${x}_${numAtomo}_A"
			} else {
				#se ke el enlace va de x a numAtomo
				#al menos tiene un enlace
				lappend listaEnl "${baseData}_actorEnlace_${numAtomo}_${x}_A"
			}
		}
		
		#puts "Enlaces del atomo : $listaEnl"
		return $listaEnl
		
		
		
	}; #finproc
	
	#colorea como seleccionado el atomo numAtomo, y los trozos de enlaces correspondientes a los q este conectado
	proc seleccionaAtomo { base baseData baseConf atomo } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		upvar #0 Conf::$baseConf config
		
		puts $atomo
		set mol $baseData
		
		set index [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) $atomo]
		if {$index == -1} {
			#puts [$atomo GetPosition]
			
		
			#lo tengo q seleccionar
			lappend visor(actoresAtomosVTKSeleccionados,$mol) $atomo
			#lo coloreo como seleccionado
			[$atomo GetProperty] SetColor [expr 255 / 255.0] [expr 236 / 255.0] [expr 0 / 255.0]
			
			#actualizo la lista de actoresSeleccMedidas
			seleccionaMedidas $base $atomo 1
			
			#coloreo los extremos de los enlaces a los q esta conectado, si los 2 extremos del enlace estan
			#seleccionados, entonces considerare seleccionado al enlace
			#en caso contrario, coloreare la mitad correspondiente, pero sin consid. seleccionado
			scan $atomo {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n numAtomo
			set listaEnlaces [enlacesDelAtomo $base $mol $numAtomo]
			foreach e $listaEnlaces {
				#en caso de no estar seleccionado
				if {[lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) $e] == -1} {				
					scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
					
					set estai [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) "${b}_actorAtomo_${i}"]
					set estaj [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) "${b}_actorAtomo_${j}"]
					
					if {$estai != -1 && $estaj != -1} {
						#selecciono el enlace
						lappend visor(actoresEnlacesVTKSeleccionados,$mol) $e
					}
					
					#coloreo la parte correspondiente
					set obj "${b}_scalarEnlace_${i}_${j}_${t}"
					if {$numAtomo == $i} {
						#puts "tengo q colorear la parte i del enlace"
						$obj SetTuple1 0 92
						$obj SetTuple1 1 92
					} else {
						#puts "tengo q colorear la parte j del enlace"
						$obj SetTuple1 2 92
						$obj SetTuple1 3 92
					}
					${b}_pdEnlace_${i}_${j}_${t} Modified 
				}
			}
			
			
		} else {
			if {$visor(agregaSeleccion) == 0} {
				#lo tengo q deseleccionar
				set visor(actoresAtomosVTKSeleccionados,$mol) [lreplace $visor(actoresAtomosVTKSeleccionados,$mol) $index $index]
				
				#actualizo la lista de actoresSeleccMedidas
				seleccionaMedidas $base $atomo 0
				
				scan $atomo {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n numAtomo
				
				set color [colorToRGB $datos(colorAtom,$numAtomo)]
				[$atomo GetProperty] SetColor [lindex $color 0] [lindex $color 1] [lindex $color 2]
				
				#debo restaurar el color de los extremos de los enlaces, a no ser que el enlace en cuestion este seleccionado
				#en ese caso lo debo dejar como este
				
				set listaEnlaces [enlacesDelAtomo $base $mol $numAtomo]
				foreach e $listaEnlaces {
					#en caso de no estar seleccionado
					if {[lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) $e] == -1} {				
						scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
						
						#coloreo la parte correspondiente
						set obj "${b}_scalarEnlace_${i}_${j}_${t}"
						if {$numAtomo == $i} {
							#puts "tengo q colorear la parte i del enlace"
							set numOrden $config(numOrdenAtomo,$datos(simbolo,$i))
							$obj SetTuple1 0 $numOrden
							$obj SetTuple1 1 $numOrden
						} else {
							#puts "tengo q colorear la parte j del enlace"
							set numOrden $config(numOrdenAtomo,$datos(simbolo,$j))
							$obj SetTuple1 2 $numOrden
							$obj SetTuple1 3 $numOrden
						}
						${b}_pdEnlace_${i}_${j}_${t} Modified 
					}
				}
			}
		}
	}; #finproc
	
	#colorea como seleccionados unicamente el enlace seleccionado, teniendo en cuenta si son simples dobles o triples
	proc seleccionaEnlace { base baseData baseConf enlace } {
		
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		upvar #0 Conf::$baseConf config
		
		set mol $baseData
		set listaTratados [list]
		
		scan $enlace {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
		
		switch $datos(tipoConect,$i,$j) {
			2 {
				set lis "A B"
			}
			3 {
				set lis "A B C"
			}
			default {
				set lis "A"
			}
		}
		
		set index [lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) $enlace]
		if {$index == -1} {
			#no esta seleccionado, debo seleccionarlo, a el y a sus compañeros en caso de que no sea un enlace simple
			foreach x $lis {
				lappend visor(actoresEnlacesVTKSeleccionados,$mol) "${b}_${n}_${i}_${j}_${x}"
				set obj "${b}_scalarEnlace_${i}_${j}_${x}"
				$obj SetTuple1 0 92
				$obj SetTuple1 1 92
				$obj SetTuple1 2 92
				$obj SetTuple1 3 92
				${b}_pdEnlace_${i}_${j}_${x} Modified 
			}
		} else {
			#debo deseleccionar, en el caso de que los atomos adyacentes al enlace, esten seleccionados, el enlace no sera deseleccionado
			#en caso contrario, recuperara el color que le corresponda segun el estado de dichos atomos
			set estai [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) "${b}_actorAtomo_${i}"]
			set estaj [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) "${b}_actorAtomo_${j}"]
			
			foreach x $lis {
				set index [lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) "${b}_${n}_${i}_${j}_${x}"]
				set visor(actoresEnlacesVTKSeleccionados,$mol) [lreplace $visor(actoresEnlacesVTKSeleccionados,$mol) $index $index]
				#por defecto los considero seleccionados
				set numOrdeni 92
				set numOrdenj 92
					
				if {$estai == -1 && $estaj == -1} {
					set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))
					set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
					#puts "quito $numOrdeni $numOrdenj"				
				} elseif {$estai != -1 && $estaj == -1} {
					set numOrdenj $config(numOrdenAtomo,$datos(simbolo,$j))
				} elseif {$estai == -1 && $estaj != -1} {
					set numOrdeni $config(numOrdenAtomo,$datos(simbolo,$i))				
				}
				
				set obj "${b}_scalarEnlace_${i}_${j}_${x}"
				$obj SetTuple1 0 $numOrdeni
				$obj SetTuple1 1 $numOrdeni
				$obj SetTuple1 2 $numOrdenj
				$obj SetTuple1 3 $numOrdenj
				${b}_pdEnlace_${i}_${j}_${x} Modified
			}
		}

	}; #finproc

	#selecciona como props, solo tiene en cuenta el actor, no la cell
	proc seleccionProp { base baseConf actor } {
		upvar #0 VisorVTK::$base visor
		#upvar #0 Data::$baseData datos
		#upvar #0 Conf::$baseConf config
		
		set mol [devuelveDataDeActor $actor]
		
		if {[string last "Atomo" $actor] != -1 } {
			#puts "es un atomo"
			seleccionaAtomo $base $mol $baseConf $actor
			if {$visor(SHIFT) == 0} {
				if {[lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) $actor] == -1} {
					deseleccionarTodo $base $baseConf
					seleccionaAtomo $base $mol $baseConf $actor
				} else {
					deseleccionarTodo $base $baseConf
				}
			} else {
				seleccionaAtomo $base $mol $baseConf $actor
			}
		} else {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
			set listai [enlacesSimplesDelAtomo $base $mol $i]
			set listaj [enlacesSimplesDelAtomo $base $mol $j]
		
			if {$visor(SHIFT) == 0} {
				if {[lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) $actor] == -1} {
					#el atomo q he picado no estaba seleccionado
					deseleccionarTodo $base $baseConf
					seleccionaEnlace $base $mol $baseConf $actor
					
					#aunque estemos seleccionando solo los enlaces, en el caso de q el enlaces tenga una atomo "satelite"
					#tb lo seleccionaremos
					if {[llength $listai] == 1} {
						seleccionaAtomo $base $mol $baseConf "${b}_actorAtomo_${i}"
					}
					if {[llength $listaj] == 1} {
						seleccionaAtomo $base $mol $baseConf "${b}_actorAtomo_${j}"
					}
				} else {
					deseleccionarTodo $base $baseConf
				}
			} else {
				#puts "selecciono el enlace en si"
				seleccionaEnlace $base $mol $baseConf $actor
				
				#compruebo los atomos con los q esta conectado, tienen tb sus enlaces seleccionados
				#en ese caso seleccionare el atomo tb
				#scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
				
				# para evitar propceso extra, como todo enlace tendra al menos un actor de tipo ..._A,
				#solo trabajare con ellos, extraere las listas de enlaces q acaben en A, y los comparare 
				#con el que haya seleccionado, tambien acabado en A
				
				#set listai [enlacesSimplesDelAtomo $base $mol $i]
				#set listaj [enlacesSimplesDelAtomo $base $mol $j]
				
				if {[llength $listai] == 1} {
					seleccionaAtomo $base $mol $baseConf "${b}_actorAtomo_${i}"
				}
				if {[llength $listaj] == 1} {
					seleccionaAtomo $base $mol $baseConf "${b}_actorAtomo_${j}"
				}
				
				set seleccionoi 0
				set x 0
				while {$seleccionoi == 0 && $x < [llength $listai]} {
					if {[lindex $listai $x] != "${b}_${n}_${i}_${j}_A" && [lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) [lindex $listai $x]] != -1} {
						set seleccionoi 1
					} else {
						incr x
					}
				}
				if {$seleccionoi == 1} {
					seleccionaAtomo $base $mol $baseConf ${b}_actorAtomo_${i}
				}
				
				set seleccionoj 0
				set x 0
				while {$seleccionoj == 0 && $x < [llength $listaj]} {
					if {[lindex $listaj $x] != "${b}_${n}_${i}_${j}_A" && [lsearch -exact $visor(actoresEnlacesVTKSeleccionados,$mol) [lindex $listaj $x]] != -1} {
						set seleccionoj 1
					} else {
						incr x
					}
				}
				if {$seleccionoj == 1} {
					seleccionaAtomo $base $mol $baseConf ${b}_actorAtomo_${j}
				}	
			}
		}
	}; #finproc
	
	#devuelve 1 si la molecula baseData esta completamente seleccionada, -1 eoc
	#esto evita calculo adicional en otras funciones
	proc estaSeleccEnteraMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		if {$visor(numAtomos,$baseData) == [llength $visor(actoresAtomosVTKSeleccionados,$baseData)] } {
			return 1
		} else {
			return -1
		}
		
	}; #finproc
	
	#devuelve una lista con los pares "baseData numAtomo" que esten seleccionados en el visor
	proc devuelveMolNumAtomoSelecc { base } {
		upvar #0 VisorVTK::$base visor
		
		set lista [list]
		foreach mol $visor(moleculas) {
			foreach at $visor(actoresAtomosVTKSeleccionados,$mol) {
				scan $at {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
				lappend lista "$b $x"
			}
		}
		return $lista
	};#finproc
	
	#devuelve una lista de ternas "baseData numAtomo1 numAtomo2" de los enlaces seleccionados en el visor
	proc devuelveMolNumEnlacesSelecc { base } {
		upvar #0 VisorVTK::$base visor
		
		set lista [list]
		foreach mol $visor(moleculas) {
			foreach e $visor(actoresEnlacesVTKSeleccionados,$mol) {
				scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
				#solo el A, sino devolveria el enlace repetido
				if {$t == "A"} {lappend lista "$b $i $j"}
			}
		}
		return $lista
	}; #finproc
	
	proc devuelveAtomosSeleccMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		return $visor(actoresAtomosVTKSeleccionados,$baseData)
	}; #finproc
	
	proc devuelveNumAtomosSeleccMol { base baseData } {
		upvar #0 VisorVTK::$base visor
		#return $visor(actoresAtomosVTKSeleccionados,$baseData)
		
		set lista [list]
		foreach actor $visor(actoresAtomosVTKSeleccionados,$baseData) {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			lappend lista $x
		}
		return $lista
	}; #finproc
	#devuelve una lista con los nombres base de las moleculas que tienen algun actor seleccionado 
	proc devuelveMolSelecc { base } {
		upvar #0 VisorVTK::$base visor
		
		set res [list]
		foreach mol $visor(moleculas) {
			if {[llength $visor(actoresAtomosVTKSeleccionados,$mol)] > 0 || [llength $visor(actoresEnlacesVTKSeleccionados,$mol)] > 0} {
				lappend res $mol
			}
		}
		return $res
	}; #finproc
		 
	proc devuelveMolSeleccEntera { base } {
		upvar #0 VisorVTK::$base visor
		
		set lista [devuelveMolSelecc $base]
		set listaE [list]
		foreach mol $lista {
			if {[estaSeleccEnteraMol $base $mol] == 1} {
				lappend listaE $mol
			}
		}
		return $listaE
	}; #finproc
	
	proc empiezaRSeleccion { base } {
		upvar #0 VisorVTK::$base visor
		#puts "comienzo lazo de seleccion"
		set visor(rSelect) 1
		set visor(rSelectI) [$visor(renderWInt) GetEventPosition]
		
	}; #finproc
	
	proc terminaRSeleccion { base } {
		upvar #0 VisorVTK::$base visor
		#puts "finalizo lazo de seleccion"
		
		set visor(rSelect) 0
		set visor(rSelectF) [$visor(renderWInt) GetEventPosition]
		
		$visor(rSelectPoints) Reset
		$visor(rSelectPoints) Modified
		$visor(rSelectCells) Reset
	}; #finproc
	
	proc actualizaRSeleccion { base } {
		upvar #0 VisorVTK::$base visor
		
		#puts "actualizo lazo seleccion"
		
		$visor(rSelectPoints) Reset
		$visor(rSelectPoints) Modified
		$visor(rSelectCells) Reset
		
		set p1 $visor(rSelectI)
		set p2 [$visor(renderWInt) GetEventPosition]
		set n [$visor(rSelectPoints) GetNumberOfPoints]
			$visor(rSelectPoints) InsertNextPoint [lindex $p1 0] [lindex $p1 1] 0
			$visor(rSelectPoints) InsertNextPoint [lindex $p2 0] [lindex $p1 1] 0
			$visor(rSelectPoints) InsertNextPoint [lindex $p2 0] [lindex $p2 1] 0
			$visor(rSelectPoints) InsertNextPoint [lindex $p1 0] [lindex $p2 1] 0
			$visor(rSelectPoints) Modified
			
			$visor(rSelectCells) InsertNextCell 5
			$visor(rSelectCells) InsertCellPoint $n
			$visor(rSelectCells) InsertCellPoint [expr $n + 1]
			$visor(rSelectCells) InsertCellPoint [expr $n + 2]
			$visor(rSelectCells) InsertCellPoint [expr $n + 3]
			$visor(rSelectCells) InsertCellPoint $n
		$visor(renderW) Render
	}; #finproc
	
	proc seleccionaRSeleccion { base baseConf } {
		upvar #0 VisorVTK::$base visor
		
		set visor(agregaSeleccion) 1
		
		#determino el tipo de diagonal q forman los 2 puntos visor(rSelectI) y visor(rSelectF), determino a y b, como 
		#esquina superior izquierda y esquina inferior dcha respectivamente
		if {[lindex $visor(rSelectI) 0] < [lindex $visor(rSelectF) 0]} {
			if {[lindex $visor(rSelectI) 1] < [lindex $visor(rSelectF) 1]} {
				set a "[lindex $visor(rSelectI) 0] [lindex $visor(rSelectF) 1]"
				set b "[lindex $visor(rSelectF) 0] [lindex $visor(rSelectI) 1]"
			} else {
				set a $visor(rSelectI)
				set b $visor(rSelectF)
			}
		} else {
			if {[lindex $visor(rSelectI) 1] < [lindex $visor(rSelectF) 1]} {
				set a $visor(rSelectF)
				set b $visor(rSelectI)
			} else {
				set a "[lindex $visor(rSelectF) 0] [lindex $visor(rSelectI) 1]"
				set b "[lindex $visor(rSelectI) 0] [lindex $visor(rSelectF) 1]"
			}
		}
		
		foreach mol $visor(moleculas) {
			foreach actor $visor(actoresAtomos,$mol) {
				set orig [$actor GetPosition]
				$visor(render) SetWorldPoint [lindex $orig 0] [lindex $orig 1] [lindex $orig 2] 1.0
				$visor(render) WorldToDisplay
				set posDispl [$visor(render) GetDisplayPoint]
				
				#ya tengo la posicion del actor en coordenadas de pantalla, ahora compruebo q esten dentro de mi rectangulo
				if {[lindex $posDispl 0] >= [lindex $a 0] && [lindex $posDispl 0] <= [lindex $b 0] && \
					[lindex $posDispl 1] <= [lindex $a 1] && [lindex $posDispl 1] >= [lindex $b 1]} {
					#debo seleccionar ese atomo
					scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} d n x
					seleccionaAtomo $base $d $baseConf $actor
				}
			}
		}
		set visor(agregaSeleccion) 0
		$visor(renderW) Render
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#										-	INTERACCION   -
#----------------------------------------------------------------------------------------------			
	
	proc moverAtomos { base vector } {
		upvar #0 VisorVTK::$base visor
		set listaMol [devuelveMolSelecc $base]
		foreach mol $listaMol { 
			moverAtomosMol $base $mol $vector
		}
		calcularMedidas $base
		#$visor(renderW) Render
	}; #finproc
	
	#mueve los atomos que haya en ese momento seleccionados en la direccion, sentido y magnitud de vector
	proc moverAtomosMol { base baseData vector } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
		
		set mol $baseData
		
		set listaMover $visor(actoresAtomosVTKSeleccionados,$mol)
		
		#si no esta seleccionada entera, tendre q comprobar q hidorgenos tengo q mover
		if {[estaSeleccEnteraMol $base $mol] == -1} {
			set listaHidrog [list]
			foreach a $visor(actoresAtomosVTKSeleccionados,$mol) {
				scan $a {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
				lappend listaHidrog [Data::devuelveHidrogDelAtomo $b $x]
			}
			set listaHidrog [join $listaHidrog " "]
			#puts "-----------------------> $listaHidrog"
			
			#ya tengo todos los hidrogenos de los atomos seleccionados, ahora genero la lista
			#de atomos que se deben mover, para generarla estaran los atomos seleccionados manualmente en
			#la molecula, ademas de los hidrogenos, pero procurando que no esten repetidos en dicha lista
			#porq se moverian mas de una vez
			
			
			foreach a $listaHidrog {
				if {[lsearch -exact $listaMover ${b}_actorAtomo_${a}] == -1} {
					lappend listaMover ${b}_actorAtomo_${a}
				}
			}
		}
		
		#ahora los muevo
		foreach actor $listaMover {
			set orig [$actor GetPosition]
			$visor(render) SetWorldPoint [lindex $orig 0] [lindex $orig 1] [lindex $orig 2] 1.0
			$visor(render) WorldToDisplay
			set posDispl [$visor(render) GetDisplayPoint]
			
			set a [list [lindex $posDispl 0] [lindex $posDispl 1]]
			
			set x [math::linearalgebra::add $a $vector]
		
			$visor(render) SetDisplayPoint [lindex $x 0] [lindex $x 1] [lindex $posDispl 2]
			$visor(render) DisplayToWorld
			set posF [$visor(render) GetWorldPoint]
			
			$actor SetPosition [lindex $posF 0] [lindex $posF 1] [lindex $posF 2]
			
			#actualizo la base de datos
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			set datos(coordX,$x) [lindex $posF 0]
			set datos(coordY,$x) [lindex $posF 1]
			set datos(coordZ,$x) [lindex $posF 2]
			
			
			#cambio la orientacion y escalo sus enlaces
			set listaEnlaces [enlacesDelAtomo $base $mol $x]
						
			foreach e $listaEnlaces {
				scan $e {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
				set props [Data::calculoProp $baseData $i $j]
				
				#reseteo su posicion original, al eje Y
				$e SetOrientation 0 1 0
				
				if {$t == "A"} {
					$e SetPosition [lindex $props 0] [lindex $props 1] [lindex $props 2]
					$e RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
				} elseif {$t == "B"} {
					$e SetPosition [lindex $props 8] [lindex $props 9] [lindex $props 10]
					$e RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
				} else {
					$e SetPosition [lindex $props 11] [lindex $props 12] [lindex $props 13]
					$e RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
				}
				
				if {$visor(estadoRepresEn,$mol,$i,$j) == "L" || $visor(estadoRepresEn,$mol,$i,$j) == "C"} {
					if {$datos(tipoConect,$i,$j) == 2 || $datos(tipoConect,$i,$j) == 3} {
						$e SetScale 0.4 [lindex $props 7] 0.4
					} else {
						$e SetScale 1 [lindex $props 7] 1
					} 
				} else {
					if {$datos(tipoConect,$i,$j) == 2 || $datos(tipoConect,$i,$j) == 3} {
						$e SetScale 0.4 [expr [lindex $props 7] - 0.3] 0.4
					} else {
						$e SetScale 1 [expr [lindex $props 7] - 0.3] 1
					}
				}
			}
		}
		
		#$visor(renderW) Render
	}; #finproc
	
	#rota la molecula 'baseData' en angulo 'ang' alrededor del eje definido por 'ejeA <--> ejeB'
	proc rotarMolEje { base baseData ejeA ejeB ang } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Data::$baseData datos
	
		#creacion de matrices
		vtkMatrix4x4 T
		vtkMatrix4x4 RX
		vtkMatrix4x4 RY
		vtkMatrix4x4 RZ
		vtkMatrix4x4 Res
		vtkMatrix4x4 iT
		vtkMatrix4x4 iRX
		vtkMatrix4x4 iRY
		
		set ab [math::linearalgebra::sub $ejeB $ejeA]
		set longT [math::linearalgebra::norm $ab]
		
		#Matriz de traslacion
		T Identity
		T SetElement 0 3 [expr - [lindex $ejeA 0]]
		T SetElement 1 3 [expr - [lindex $ejeA 1]]
		T SetElement 2 3 [expr - [lindex $ejeA 2]]
		
		#inversa de la matriz de traslacion
		iT Identity
		iT SetElement 0 3 [lindex $ejeA 0]
		iT SetElement 1 3 [lindex $ejeA 1]
		iT SetElement 2 3 [lindex $ejeA 2]
		
		#calcula la proyeccion de ab sobre el plano YZ
		set u "0 [lindex $ab 1] [lindex $ab 2]"

		
		#calculo el angulo q debo rotar ab sobre el eje X para abatirlo sobre el plano XZ
		if {[lindex $u 1] != 0 || [lindex $u 2] != 0} {
			set long [math::linearalgebra::norm $u]
			#sea alphaX el angulo entre u y el plano XZ
			set sinalphaX [expr [lindex $u 1] / $long]
			set cosalphaX [expr [lindex $u 2] / $long]
		} else {
			set long 0.0
			set sinalphaX 0.0
			set cosalphaX 1.0
		}
		
		#matriz de rotacion sobre ejeX
		RX Identity
		RX SetElement 1 1 $cosalphaX
		RX SetElement 1 2 $sinalphaX
		RX SetElement 2 1 [expr - $sinalphaX]
		RX SetElement 2 2 $cosalphaX
		
		#inversa de la matriz de rotacion sobre ejeX
		iRX Identity
		iRX SetElement 1 1 $cosalphaX
		iRX SetElement 1 2 [expr - $sinalphaX]
		iRX SetElement 2 1 $sinalphaX
		iRX SetElement 2 2 $cosalphaX

		#calculo el angulo que debo rotar el vector anterior sobre el ejeY para alinearlo con el ejeZ
		set sinbetaY [expr [lindex $ab 0] / $longT]
		set cosbetaY [expr $long / $longT]
		
		#matriz de rotacion sobre ejeY
		RY Identity
		RY SetElement 0 0 $cosbetaY
		RY SetElement 0 2 $sinbetaY
		RY SetElement 2 0 [expr - $sinbetaY]
		RY SetElement 2 2 $cosbetaY
		#inversa de la matriz de rotacion sobre ejeY
		iRY Identity
		iRY SetElement 0 0 $cosbetaY
		iRY SetElement 0 2 [expr - $sinbetaY]
		iRY SetElement 2 0 $sinbetaY
		iRY SetElement 2 2 $cosbetaY
		
		#calculo el angulo que debo rotar sobre el eje Z
		set sinPiZ [expr sin($ang * $math::constants::degtorad)]
		set cosPiZ [expr cos($ang * $math::constants::degtorad)]
		
		#matriz de rotacion sobre el eje Z
		RZ Identity
		RZ SetElement 0 0 $cosPiZ
		RZ SetElement 0 1 $sinPiZ
		RZ SetElement 1 0 [expr - $sinPiZ]
		RZ SetElement 1 1 $cosPiZ
		
		#calculo una matriz que agrupa todas las transformaciones
		Res Identity
		Res Multiply4x4 iT RX Res
		Res Multiply4x4 Res RY Res
		Res Multiply4x4 Res RZ Res
		Res Multiply4x4 Res iRY Res
		Res Multiply4x4 Res iRX Res
		Res Multiply4x4 Res T Res
		
		#calculo las nuevas posiciones de los actoresAtomos
		foreach actor $visor(actoresAtomos,$baseData) {
			#$actor RotateZ 5
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n numAtom
	
			set p [$actor GetPosition]
			set np [Res MultiplyPoint [lindex $p 0] [lindex $p 1] [lindex $p 2] 1]
			$actor SetPosition [lindex $np 0] [lindex $np 1] [lindex $np 2]

			#actualizo base de datos
			set datos(coordX,$numAtom) [lindex $np 0]
			set datos(coordY,$numAtom) [lindex $np 1]
			set datos(coordZ,$numAtom) [lindex $np 2]
			
			#insertarDistancia $base $p [list [lindex $np 0] [lindex $np 1] [lindex $np 2]]	
		}
		
		#calculo la posicion y la orientacion de los actoresEnlaces en base a los atomos a los que estan conectados
		foreach actor $visor(actoresEnlaces,$baseData) {
			#para los enlaces calculo su posicion y orientacion a partir de los atomos a los q estan conectados
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
			set props [Data::calculoProp $baseData $i $j]
			
			#reseteo su posicion original, al eje Y
			$actor SetOrientation 0 1 0
			if {$t == "A"} {
				$actor SetPosition [lindex $props 0] [lindex $props 1] [lindex $props 2]
				$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
			} elseif {$t == "B"} {
				$actor SetPosition [lindex $props 8] [lindex $props 9] [lindex $props 10]
				$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
			} elseif {$t == "C"} {
				$actor SetPosition [lindex $props 11] [lindex $props 12] [lindex $props 13]
				$actor RotateWXYZ [lindex $props 3] [lindex $props 4] [lindex $props 5] [lindex $props 6]
			}
		}
		
		#elimino las matrices
		T Delete
		RX Delete
		RY Delete
		RZ Delete
		iT Delete
		iRX Delete
		iRY Delete
		Res Delete
	}; #finproc
	
	#devuelve el centro del cjto de las moleculas que haya en 'lista'
	proc calculaCentro { base lista } {
		upvar #0 VisorVTK::$base visor
		puts "-----$lista"
		
		#tengo en lista las moleculas sobre las q tengo calcular la bounding box
		#creo una assembly para ayudarme a calcular el centro de la boundingBox que forman esos actores
		vtkAssembly assem
		foreach mol $lista {
			foreach actor $visor(actoresAtomos,$mol) {
				assem AddPart $actor
			}
			foreach actor $visor(actoresEnlaces,$mol) {
				assem AddPart $actor
			}
		}
		
		#el centro de la assembly se cañlcula sobre las partes visibles
		#si los actores estan invisibles como en el caso del modo de representacion en lineas, el centro no sera el correcto
		#set col [assem GetParts]
		#$col InitTraversal
		#set e [$col GetNextProp3D]
		#while {$e != ""} {
		#	$e VisibilityOn
		#	set e [$col GetNextProp3D]
		#}
		
		#puts "Bounds : [assem GetBounds]"
		#puts "Centro : [assem GetCenter]"
		set center [assem GetCenter]
		assem Delete
		#puts "CENTRO --> $center"
		return $center
	}; #finproc
	
	#calcula unos ejes centrado en la BB de todo lo seleccionado, con respecto a la camara
	#return "$centro $ejeX $ejeY $ejeZ"
	proc calculaEjesCameraBB { base modo } {
		upvar #0 VisorVTK::$base visor
		
		#calculo en centro de la BB
		set centro [calculaCentro $base $modo]
		
		set focal [[$visor(render) GetActiveCamera] GetFocalPoint]
		set posCam [[$visor(render) GetActiveCamera] GetPosition]
		set viewUp [[$visor(render) GetActiveCamera] GetViewUp]
		
		#calculo el ejeY
		set ejeY [math::linearalgebra::add $viewUp $centro]
		
		#calculo el ejeZ
		set b [math::linearalgebra::sub $focal $posCam]
		set ejeZ [math::linearalgebra::add $b $centro]

		
		set ejeX [math::linearalgebra::crossproduct $b $viewUp]
		set ejeX [math::linearalgebra::add $ejeX $centro]
		
		#eliminarMedidas $base
		#insertarDistancia $base $centro $ejeX
		#insertarDistancia $base $centro [math::linearalgebra::add $centro [math::linearalgebra::unitLengthVector [math::linearalgebra::sub $ejeX $centro]]]
		#insertarDistancia $base $centro [math::linearalgebra::add $centro [math::linearalgebra::unitLengthVector [math::linearalgebra::sub $ejeY $centro]]]
		#insertarDistancia $base $centro [math::linearalgebra::add $centro [math::linearalgebra::unitLengthVector [math::linearalgebra::sub $ejeZ $centro]]]
		
		$visor(renderW) Render
		return "[list $centro] [list $ejeX] [list $ejeY] [list $ejeZ]"
		
	}; #finproc
	
	#ejecuta la rotacion de moleculas cuando estan pulsados CTRL o SHIFT
	proc rotacionMoleculas { base lastXYpos XYpos } {
		upvar #0 VisorVTK::$base visor

		if {$visor(SHIFT) == 1 && $visor(CTRL) == 0} {
			#roto todas las moleculas respecto del eje paralelo al focal de la camara, centrado en
			#la BoundingBox del cjto
			set dif [expr [lindex $lastXYpos 1] - [lindex $XYpos 1]]
			foreach mol $visor(moleculas) {
				if {$dif < 0} { 
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 3] [expr abs($dif) * 0.5]
				} elseif {[lindex $lastXYpos 1] > [lindex $XYpos 1]} {
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 3] [expr - abs($dif) * 0.5]
				}
			}
		} elseif {$visor(SHIFT) == 1 && $visor(CTRL) == 1} {
			#roto solo las seleccionadas o todas si no hay ninguna
			set listaE [devuelveMolSeleccEntera $base]
			if {$listaE == ""} {
				set listaE $visor(moleculas)
			}
			set dif [expr [lindex $lastXYpos 1] - [lindex $XYpos 1]]
			foreach mol $listaE {
				if {$dif < 0} { 
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 3] [expr abs($dif) * 0.5]
				} elseif {[lindex $lastXYpos 1] > [lindex $XYpos 1]} {
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 3] [expr - abs($dif) * 0.5]
				}
			}
		} elseif {$visor(SHIFT) == 0 && $visor(CTRL) == 1} {
			#roto solo las seleccionadas o todas si no hay ninguna
			set listaE [devuelveMolSeleccEntera $base]
			if {$listaE == ""} {
				set listaE $visor(moleculas)
			}
			#set ejes [calculaEjesCameraBB $base $listaE]
			foreach mol $listaE {
				set dif [expr [lindex $lastXYpos 0] - [lindex $XYpos 0]]
				if {$dif < 0} { 
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 2] [expr - abs($dif) * 0.5]
				} elseif {$dif > 0} {
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 2] [expr (abs($dif) * 0.5)]
				}
				
				set dif [expr [lindex $lastXYpos 1] - [lindex $XYpos 1]]
				if {$dif < 0} { 
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 1] [expr abs($dif) * 0.5]
				} elseif {$dif > 0} {
					rotarMolEje $base $mol [lindex $visor(ejesRot) 0] [lindex $visor(ejesRot) 1] [expr - (abs($dif) * 0.5)]
				}
				
			}
		}
		$visor(render) ResetCameraClippingRange
		$visor(renderW) Render	
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#										-	MEDIDAS   -
#----------------------------------------------------------------------------------------------		
	
	#mantiene una cola de 4 actores en la lista base(actoresSeleccMedidas), que se utilizara para 
	#realizar las medidas segun lo que haya seleccionado
	proc seleccionaMedidas { base actor selecDeselec } {
		upvar #0 VisorVTK::$base visor
		#visor(actoresSeleccMedidas)
		
		set index [lsearch -exact $visor(actoresSeleccMedidas) $actor]
		#puts "$actor , $selecDeselec"
		#se esta deseleccionando el actor
		if {$selecDeselec == 0} {
			if {$index != -1} {
				set visor(actoresSeleccMedidas) [lreplace $visor(actoresSeleccMedidas) $index $index]
			}
		} else {
			if {[llength $visor(actoresSeleccMedidas)] < 4} {
				lappend visor(actoresSeleccMedidas) $actor
			} else {
				set visor(actoresSeleccMedidas) [lreplace $visor(actoresSeleccMedidas) 0 0]
				lappend visor(actoresSeleccMedidas) $actor
			}
		}
		#puts "Lista : $visor(actoresSeleccMedidas)"
	}; #finproc
	
	#crea e inserta en el sistema un actor con texto, devuelve su nombre
	proc crearActorTexto { base texto } {
		upvar #0 VisorVTK::$base visor
		
		
		vtkVectorText ${base}_texto_${visor(semillaActoresTexto)}
			${base}_texto_${visor(semillaActoresTexto)} SetText $texto
		vtkPolyDataMapper ${base}_textoMapper_${visor(semillaActoresTexto)}
			${base}_textoMapper_${visor(semillaActoresTexto)} SetInputConnection [${base}_texto_${visor(semillaActoresTexto)} GetOutputPort]
			
		lappend visor(actoresTexto) [vtkFollower ${base}_textoActor_${visor(semillaActoresTexto)}]
			set actor [lindex $visor(actoresTexto) end]
		    $actor SetMapper ${base}_textoMapper_${visor(semillaActoresTexto)}
			$actor SetScale 0.3 0.3 0.3
			[$actor GetProperty] SetColor 0 1 0
			$actor SetCamera [$visor(render) GetActiveCamera]
			$actor PickableOff
			
		incr visor(semillaActoresTexto)
		return $actor
	}; #finproc
	
	proc cambiarSignoActorTexto { base actor } {
		upvar #0 VisorVTK::$base visor
		scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x

		set t [${b}_texto_${x} GetText]
		
		${b}_texto_${x} SetText "-$t"
		${b}_texto_${x} Modified
		
	}; #finproc

	#elimina todos los actores de texto
	proc eliminarTextos { base } {
		upvar #0 VisorVTK::$base visor
		
		foreach actor $visor(actoresTexto) {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			
			$visor(render) RemoveActor $actor
			$actor Delete
			${b}_textoMapper_${x} Delete
			${b}_texto_${x} Delete
		}
		set visor(actoresTexto) [list]
	}; #finproc
	
	#actualiza el actorMedidas, insertando los puntos y lineas necesarios, para representar la distancia
	#entre 2 puntos de nuestro espacio tridimensional, 
	proc insertarDistancia { base p1 p2 insertarDevolver } {
		upvar #0 VisorVTK::$base visor
		
		if {$insertarDevolver == 1} {
			set n [$visor(medidasPoints) GetNumberOfPoints]
			$visor(medidasPoints) InsertNextPoint [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			$visor(medidasPoints) InsertNextPoint [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
			$visor(medidasPoints) Modified
			
			$visor(medidasCells) InsertNextCell 2
			$visor(medidasCells) InsertCellPoint $n
			$visor(medidasCells) InsertCellPoint [expr $n + 1]
		}
		
		set c [math::linearalgebra::sub $p2 $p1]
		set long [math::linearalgebra::norm $c]
		
		if {$insertarDevolver == 1} {
			
			set center [math::linearalgebra::scale 0.5 $c]
			set center [math::linearalgebra::add $center $p1]
			
			set texto [crearActorTexto $base [format "%3.2f" $long]]
			$texto SetPosition [lindex $center 0] [lindex $center 1] [lindex $center 2]
			$visor(render) AddActor $texto
		} else {
			return [format "%3.2f" $long]
		}
		
		#$visor(renderW) Render
	
	}; #finproc
	
	#actualiza el actorMedidas, insertando los puntos y lineas necesarios, para representar el angulo
	#entre 3 puntos de nuestro espacio tridimensional
	proc insertarAngulo { base p1 orig p2 insertarDevolver } {
		upvar #0 VisorVTK::$base visor
		
		set a [math::linearalgebra::sub $p1 $orig]
		set b [math::linearalgebra::sub $p2 $orig]
		set ang [math::linearalgebra::angle $a $b]
		set ang [expr $ang * $math::constants::radtodeg]
		
		set longa [math::linearalgebra::norm $a]
		set longb [math::linearalgebra::norm $b]
		
		if {$longa < $longb} {
			set x [math::linearalgebra::unitLengthVector $b]
			set extra [math::linearalgebra::scale $longa $x]
			
			set c [math::linearalgebra::sub $extra $a]
			#tengo c, ahora calculare 3 puntos en para definir mi arco
			
			set r1 [math::linearalgebra::scale 0.2 $c]
			set r1 [math::linearalgebra::add $r1 $a]
			set r1 [math::linearalgebra::unitLengthVector $r1]
			set r1 [math::linearalgebra::scale $longa $r1]
			
			set r2 [math::linearalgebra::scale 0.4 $c]
			set r2 [math::linearalgebra::add $r2 $a]
			set r2 [math::linearalgebra::unitLengthVector $r2]
			set r2 [math::linearalgebra::scale $longa $r2]
			
			set r3 [math::linearalgebra::scale 0.5 $c]
			set r3 [math::linearalgebra::add $r3 $a]
			set r3 [math::linearalgebra::unitLengthVector $r3]
			set r3 [math::linearalgebra::scale $longa $r3]
			
			set r4 [math::linearalgebra::scale 0.6 $c]
			set r4 [math::linearalgebra::add $r4 $a]
			set r4 [math::linearalgebra::unitLengthVector $r4]
			set r4 [math::linearalgebra::scale $longa $r4]
			
			set r5 [math::linearalgebra::scale 0.8 $c]
			set r5 [math::linearalgebra::add $r5 $a]
			set r5 [math::linearalgebra::unitLengthVector $r5]
			set r5 [math::linearalgebra::scale $longa $r5]

		} else {
			set x [math::linearalgebra::unitLengthVector $a]
			set extra [math::linearalgebra::scale $longb $x]
			
			set c [math::linearalgebra::sub $b $extra]
			
			set r1 [math::linearalgebra::scale 0.2 $c]
			set r1 [math::linearalgebra::add $r1 $extra]
			set r1 [math::linearalgebra::unitLengthVector $r1]
			set r1 [math::linearalgebra::scale $longb $r1]
			
			set r2 [math::linearalgebra::scale 0.4 $c]
			set r2 [math::linearalgebra::add $r2 $extra]
			set r2 [math::linearalgebra::unitLengthVector $r2]
			set r2 [math::linearalgebra::scale $longb $r2]
			
			set r3 [math::linearalgebra::scale 0.5 $c]
			set r3 [math::linearalgebra::add $r3 $extra]
			set r3 [math::linearalgebra::unitLengthVector $r3]
			set r3 [math::linearalgebra::scale $longb $r3]
			
			set r4 [math::linearalgebra::scale 0.6 $c]
			set r4 [math::linearalgebra::add $r4 $extra]
			set r4 [math::linearalgebra::unitLengthVector $r4]
			set r4 [math::linearalgebra::scale $longb $r4]
			
			set r5 [math::linearalgebra::scale 0.8 $c]
			set r5 [math::linearalgebra::add $r5 $extra]
			set r5 [math::linearalgebra::unitLengthVector $r5]
			set r5 [math::linearalgebra::scale $longb $r5]
		}
		set extra [math::linearalgebra::add $extra $orig]
		set r1 [math::linearalgebra::add $r1 $orig]
		set r2 [math::linearalgebra::add $r2 $orig]
		set r3 [math::linearalgebra::add $r3 $orig]
		set r4 [math::linearalgebra::add $r4 $orig]
		set r5 [math::linearalgebra::add $r5 $orig]
		
		
		if {$insertarDevolver == 1} {
			#inserto datos
			set n [$visor(medidasPoints) GetNumberOfPoints]
			$visor(medidasPoints) InsertNextPoint [lindex $p1 0] [lindex $p1 1] [lindex $p1 2]
			$visor(medidasPoints) InsertNextPoint [lindex $orig 0] [lindex $orig 1] [lindex $orig 2]
			$visor(medidasPoints) InsertNextPoint [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
			$visor(medidasPoints) InsertNextPoint [lindex $extra 0] [lindex $extra 1] [lindex $extra 2]
			$visor(medidasPoints) InsertNextPoint [lindex $r1 0] [lindex $r1 1] [lindex $r1 2]
			$visor(medidasPoints) InsertNextPoint [lindex $r2 0] [lindex $r2 1] [lindex $r2 2]
			$visor(medidasPoints) InsertNextPoint [lindex $r3 0] [lindex $r3 1] [lindex $r3 2]
			$visor(medidasPoints) InsertNextPoint [lindex $r4 0] [lindex $r4 1] [lindex $r4 2]
			$visor(medidasPoints) InsertNextPoint [lindex $r5 0] [lindex $r5 1] [lindex $r5 2]
			
			$visor(medidasPoints) Modified
			
			$visor(medidasCells) InsertNextCell 2
			$visor(medidasCells) InsertCellPoint $n
			$visor(medidasCells) InsertCellPoint [expr $n + 1]
			$visor(medidasCells) InsertNextCell 2
			$visor(medidasCells) InsertCellPoint [expr $n + 1]
			$visor(medidasCells) InsertCellPoint [expr $n + 2]
			
			#inserto linea del angulo
			
			if {$longa < $longb} {
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint $n
				$visor(medidasCells) InsertCellPoint [expr $n + 4]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 4]
				$visor(medidasCells) InsertCellPoint [expr $n + 5]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 5]
				$visor(medidasCells) InsertCellPoint [expr $n + 6]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 6]
				$visor(medidasCells) InsertCellPoint [expr $n + 7]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 7]
				$visor(medidasCells) InsertCellPoint [expr $n + 8]
				
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 8]
				$visor(medidasCells) InsertCellPoint [expr $n + 3]
				
				
				
			} else {
			
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 3]
				$visor(medidasCells) InsertCellPoint [expr $n + 4]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 4]
				$visor(medidasCells) InsertCellPoint [expr $n + 5]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 5]
				$visor(medidasCells) InsertCellPoint [expr $n + 6]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 6]
				$visor(medidasCells) InsertCellPoint [expr $n + 7]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 7]
				$visor(medidasCells) InsertCellPoint [expr $n + 8]
				
				$visor(medidasCells) InsertNextCell 2
				$visor(medidasCells) InsertCellPoint [expr $n + 8]
				$visor(medidasCells) InsertCellPoint [expr $n + 2]
				
			}

			set texto [crearActorTexto $base [format "%3.2f" $ang]]
			$texto SetPosition [lindex $r3 0] [lindex $r3 1] [lindex $r3 2]
			$visor(render) AddActor $texto
			
			#$visor(renderW) Render
			return $texto
		} else {
			return [format "%3.2f" $ang]
		}
	}; #finproc
	
	proc insertarTorsion { base p1 p2 p3 p4 insertarDevolver } {
		upvar #0 VisorVTK::$base visor
		
		#calculo del vector del plano formado por p1, p2 y p3, perpendicular a la recta p3-p2
		
		set x1 [math::linearalgebra::sub $p1 $p2]
		set x2 [math::linearalgebra::sub $p3 $p2]
		
		set v1 [math::linearalgebra::crossproduct $x1 $x2] ; #usado para calcular es sentido del angulo despues
		set center [math::linearalgebra::scale 0.5 $x2]
		#puts "center $center"
		
		set x3 [Data::calculoProyecc $x1 $x2]
		set x4 [math::linearalgebra::sub $x1 $x3]
		
		set x5 [math::linearalgebra::scale 1 $x4]
		
		set x6 [math::linearalgebra::add $x5 $center]

		#a1 esta en el centro de p3-p2, perpendicualrmente a un distancia de 0.5*proyeccion
		set a1 [math::linearalgebra::add $x6 $p2]
		
		
		#calculo a2 como la interseccion de la recta que pasa por el punto O, y vector x1, y la recta que pasa por x5, y vector x3
		#recta 1 : r1 = O + s*x1
		#recta 2 : r2 = x5 + t*x3
		set A [list [list [lindex $x1 0] [lindex $x3 0]] [list [lindex $x1 1] [lindex $x3 1]]]
		set b [list [lindex $x5 0] [lindex $x5 1]]
		set res [catch {math::linearalgebra::solveGauss $A $b} sol]
		
		if {$res == 1} {
			#se ha producido un error las rectas son paralelas, por lo que no es necesario pintar
			#se le asignara el mismo valor de a1
			set a2 $a1
		} else {
			set x7 [math::linearalgebra::scale [lindex $sol 0] $x1]
			set a2 [math::linearalgebra::add $x7 $p2]
		}

		#para el otro lado
		set x1 [math::linearalgebra::sub $p4 $p3]
		set x2 [math::linearalgebra::sub $p2 $p3]
		
		set v2 [math::linearalgebra::crossproduct $x1 $x2] ; #usado para calcular es sentido del angulo despues
		
		set center [math::linearalgebra::scale 0.5 $x2]
		#puts "center $center"
		
		set x3 [Data::calculoProyecc $x1 $x2]
		set x4 [math::linearalgebra::sub $x1 $x3]
		
		set x5 [math::linearalgebra::scale 1 $x4]
		
		set x6 [math::linearalgebra::add $x5 $center]
		set x7 [math::linearalgebra::add $x5 $x3]
		
		
		#a1 esta en el centro de p2-p3, perpendicualrmente a un distancia de 0.5*proyeccion
		set a3 [math::linearalgebra::add $x6 $p3]
		
		#calculo a4 como la interseccion de la recta que pasa por el punto O, y vector x1, y la recta que pasa por x5, y vector x3
		#recta 1 : r1 = O + s*x1
		#recta 2 : r2 = x5 + t*x3
		set A [list [list [lindex $x1 0] [lindex $x3 0]] [list [lindex $x1 1] [lindex $x3 1]]]
		set b [list [lindex $x5 0] [lindex $x5 1]]
		set res [catch {math::linearalgebra::solveGauss $A $b} sol]
		
		if {$res == 1} {
			#se ha producido un error las rectas son paralelas, por lo que no es necesario pintar
			#se le asignara el mismo valor de a1
			set a2 $a1
		} else {
			set x7 [math::linearalgebra::scale [lindex $sol 0] $x1]
			set a4 [math::linearalgebra::add $x7 $p3]
		}
		set center [math::linearalgebra::add $center $p3]
		
		#para la constante de acoplamiento era necesario devolver el angulo sin insertarlo como medida
		#en este caso la variable insertarDevolver, decide si debe ser una media o solo retornar el valor
		#del angulo diedro
		if { $insertarDevolver == 1 } {
			set n [$visor(medidasPoints) GetNumberOfPoints]
			$visor(medidasPoints) InsertNextPoint [lindex $a1 0] [lindex $a1 1] [lindex $a1 2]
			$visor(medidasPoints) InsertNextPoint [lindex $a2 0] [lindex $a2 1] [lindex $a2 2]
			$visor(medidasPoints) InsertNextPoint [lindex $p2 0] [lindex $p2 1] [lindex $p2 2]
			
			$visor(medidasPoints) InsertNextPoint [lindex $a3 0] [lindex $a3 1] [lindex $a3 2]
			$visor(medidasPoints) InsertNextPoint [lindex $a4 0] [lindex $a4 1] [lindex $a4 2]
			$visor(medidasPoints) InsertNextPoint [lindex $p3 0] [lindex $p3 1] [lindex $p3 2]
			
			$visor(medidasPoints) InsertNextPoint [lindex $center 0] [lindex $center 1] [lindex $center 2]
			
			$visor(medidasPoints) Modified
			
			$visor(medidasCells) InsertNextCell 4
				$visor(medidasCells) InsertCellPoint $n
				$visor(medidasCells) InsertCellPoint [expr $n + 1]
				$visor(medidasCells) InsertCellPoint [expr $n + 2]
				$visor(medidasCells) InsertCellPoint [expr $n + 6]
				
			$visor(medidasCells) InsertNextCell 4
				$visor(medidasCells) InsertCellPoint [expr $n + 3]
				$visor(medidasCells) InsertCellPoint [expr $n + 4]
				$visor(medidasCells) InsertCellPoint [expr $n + 5]
				$visor(medidasCells) InsertCellPoint [expr $n + 6]
		}
		#texto sera el nombre sde un actor texto, en el caso de insertar uan medida
		#o el valo del angulo diedro en el caso una consulta
		set texto [insertarAngulo $base $a1 $center $a3 $insertarDevolver]
		
		set x [math::linearalgebra::crossproduct $v1 $v2]
		
		#set angv [math::linearalgebra::angle [math::linearalgebra::sub $a1 $center] {1 0 0}]
		#set angw [math::linearalgebra::angle [math::linearalgebra::sub $a3 $center] {1 0 0}]
		#puts "$angv $angw"
		
		set sentido [math::linearalgebra::dotproduct $x $x2]
		if { $insertarDevolver == 1 } {
			if {$sentido < 0} {
				#el angulo es negativo
				cambiarSignoActorTexto $base $texto
			}
		} else {
			if {$sentido < 0} {return "-$texto"
			} else { return "$texto"}
		}
	}; #finproc
	
	#inserta la medida actualmente seleccionada en base(listaMedidas), como n-tupla {n= 2,3,4}
	proc insertarMedida { base } {
		upvar #0 VisorVTK::$base visor
		
		switch [llength $visor(actoresSeleccMedidas)] {
			2 {
				lappend visor(listaMedidas) "[lindex $visor(actoresSeleccMedidas) 0] [lindex $visor(actoresSeleccMedidas) 1]"
			}
			3 {
				lappend visor(listaMedidas) "[lindex $visor(actoresSeleccMedidas) 0] [lindex $visor(actoresSeleccMedidas) 1] \
											 [lindex $visor(actoresSeleccMedidas) 2]"
			}
			4 {
				lappend visor(listaMedidas) "[lindex $visor(actoresSeleccMedidas) 0] [lindex $visor(actoresSeleccMedidas) 1] \
											 [lindex $visor(actoresSeleccMedidas) 2] [lindex $visor(actoresSeleccMedidas) 3]"
			}
		}
	}; #finproc
	
	#elimina todas las medidas registradas en el visor, refiriendose tan solo al aspecto visual
	proc eliminarMedidas { base } {
		upvar #0 VisorVTK::$base visor
		
		$visor(medidasPoints) Reset
		$visor(medidasPoints) Modified
		$visor(medidasCells) Reset
		set visor(listaMedidas) [list]
		
		eliminarTextos $base
		
		$visor(renderW) Render
	}; #finproc
	
	#recalcula todas las medidas de base(listaMedidas)
	proc calcularMedidas { base } {
		upvar #0 VisorVTK::$base visor
		
		$visor(medidasPoints) Reset
		$visor(medidasPoints) Modified
		$visor(medidasCells) Reset
		eliminarTextos $base
		
		#puts $visor(listaMedidas)
		foreach med $visor(listaMedidas) {
			switch [llength $med] {
				
				2 {
					#distancia
					insertarDistancia $base [[lindex $med 0] GetPosition] [[lindex $med 1] GetPosition] 1
				}
				3 {
					#angulo
					insertarAngulo $base [[lindex $med 0] GetPosition] [[lindex $med 1] GetPosition] \
										 [[lindex $med 2] GetPosition] 1 
				}
				4 {
					#torsion
					insertarTorsion $base [[lindex $med 0] GetPosition] [[lindex $med 1] GetPosition] \
										  [[lindex $med 2] GetPosition] [[lindex $med 3] GetPosition] 1
				}
				default {
					
				}
			}
		}
		#$visor(renderW) Render
	}; #finproc
	
	proc eliminaListaMedidas { base } {
		upvar #0 VisorVTK::$base visor
		set molList [devuelveMolSelecc $base]
		if {[llength $molList] == 0} {
			#si no hay ninguna seleccionada, borra todas las medidas
			set molList [VisorVTK::devuelveListaMol $base]
		}
		#puts "estan seleccionadas las moleculas $molList"
		if {[llength $molList] > 0} {
			foreach mol $molList {
				foreach actor $visor(actoresAtomos,$mol) {
					#puts "elimino las medidas q tengan al actor $actor"
					eliminaListaMedidasActor $base $actor
				}
			}
		}
	}; #finproc
	
	proc eliminaListaMedidasActor { base actor } {
		upvar #0 VisorVTK::$base visor

		#elimino de la lista de actoresSeleccMedidas
		set index [lsearch -exact $visor(actoresSeleccMedidas) $actor]
		if {$index != -1} {
			set visor(actoresSeleccMedidas) [lreplace $visor(actoresSeleccMedidas) $index $index]
		}
		
		set i 0
		foreach med $visor(listaMedidas) {
			#puts $med
			#elimino de la lista de medidas
			set index [lsearch -exact $med $actor]
			if {$index != -1} {
				set visor(listaMedidas) [lreplace $visor(listaMedidas) $i $i]
			}
			incr i
		}
	}; #finproc
	
	#devuelve el valor del angulodiedro si hay 4 atomos seleccionados, -1 en caso contrario
	proc devuelveTorsion { base } {
		upvar #0 VisorVTK::$base visor
		
		if {[llength $visor(actoresSeleccMedidas)] == 4} {
			return [insertarTorsion $base [[lindex $visor(actoresSeleccMedidas) 0] GetPosition] [[lindex $visor(actoresSeleccMedidas) 1] GetPosition] \
										 [[lindex $visor(actoresSeleccMedidas) 2] GetPosition] [[lindex $visor(actoresSeleccMedidas) 3] GetPosition] 0]
		} else { return -1}
	}; #finproc

#----------------------------------------------------------------------------------------------
#									-	PUENTES DE HIDROGENO   -
#----------------------------------------------------------------------------------------------	

	#actualiza el actor puentesH, insertando los puntos y lineas necesarios, para representar la distancia
	#entre 2 puntos de nuestro espacio tridimensional, 
	proc insertarPuenteHidrogeno { base p1 p2 } {
		upvar #0 VisorVTK::$base visor
		
		#el puente sera representado como una linea discontinua, los tramos tendran una longitud lDisc

		set lDisc 0.1
		
		
		set long [math::linearalgebra::sub $p2 $p1]
		
		set nTramos [expr round([math::linearalgebra::norm $long] / $lDisc)]
		
		set unit [math::linearalgebra::unitLengthVector $long]
		set v [math::linearalgebra::scale $lDisc $unit]
		
		if {$nTramos >= 1} {
			set x 1
			
			while {$x < $nTramos} {
				#inserto un nuevo tramo				
				#los puntos a insertar son
				set a [math::linearalgebra::add $p1 [math::linearalgebra::scale [expr $x - 1] $v]]
				set b [math::linearalgebra::add $p1 [math::linearalgebra::scale $x $v]]
				
				set n [$visor(puentesHPoints) GetNumberOfPoints]

				$visor(puentesHPoints) InsertNextPoint [lindex $a 0] [lindex $a 1] [lindex $a 2]
				$visor(puentesHPoints) InsertNextPoint [lindex $b 0] [lindex $b 1] [lindex $b 2]
				$visor(puentesHPoints) Modified
				$visor(puentesHCells) InsertNextCell 2
				$visor(puentesHCells) InsertCellPoint $n
				$visor(puentesHCells) InsertCellPoint [expr $n + 1]
				incr x 2
			}
		}	
	}; #finproc

	#recalcula todas los puentes de hidrogeno de base(listapuentesH)
	proc calcularPuentesH { base } {
		upvar #0 VisorVTK::$base visor
		
		$visor(puentesHPoints) Reset
		$visor(puentesHPoints) Modified
		$visor(puentesHCells) Reset
		
		#puts $visor(listaPuentesH)
		
		#puts $visor(listapuentesH)
		foreach p $visor(listaPuentesH) {
			switch [llength $p] {
				2 {
					#inserto el PH
					#puts paso
					insertarPuenteHidrogeno $base [[lindex $p 0] GetPosition] [[lindex $p 1] GetPosition]
				}
				default {}
			}
		}
		#$visor(renderW) Render
	}; #finproc
	
	#inserta en la lista visor(listaPuentesH) los actores correspondientes a los pH definidos el listaPuentes, q es una lista de pares de elementos, donde
	#cada elemento es una par (mol id)
	proc crearPuentesH { base } {
		upvar #0 VisorVTK::$base visor
		eliminarPuentesH $base
		if {[llength $visor(elemsPuentesH)] > 0} {
			set listaPuentes [Data::calculaPuentesHidrogeno $visor(moleculas) $visor(elemsPuentesH) $visor(distPuentesH)]
			foreach puen $listaPuentes {
				set i [lindex $puen 0]
				set j [lindex $puen 1]
				if {$visor(visible,[lindex $i 0]_actorAtomo_[lindex $i 1]) == 1 && $visor(visible,[lindex $j 0]_actorAtomo_[lindex $j 1]) == 1} {
					lappend visor(listaPuentesH) [list "[lindex $i 0]_actorAtomo_[lindex $i 1]" "[lindex $j 0]_actorAtomo_[lindex $j 1]"]
				}
			}
			calcularPuentesH $base
		}
		
	}; #finproc
	
	proc eliminarPuentesH { base } {
		upvar #0 VisorVTK::$base visor
		
		$visor(puentesHPoints) Reset
		$visor(puentesHPoints) Modified
		$visor(puentesHCells) Reset
		set visor(listaPuentesH) [list]
	}; #finproc

	proc definirElemsFormanPH { base listaElems dist } {
		upvar #0 VisorVTK::$base visor
		set visor(elemsPuentesH) $listaElems
		set visor(distPuentesH) $dist
		crearPuentesH $base
	}
#----------------------------------------------------------------------------------------------
#										-	ETIQUETAS   -
#----------------------------------------------------------------------------------------------	
	proc eliminarEtiquetas { base } {
		upvar #0 VisorVTK::$base visor
		
		eliminarActoresEtiquetas $base
		set visor(listaEtiquetas) [list]
	}; #finproc

	proc eliminarActoresEtiquetas { base } {
		upvar #0 VisorVTK::$base visor
		
		foreach actor $visor(actoresEtiquetas) {
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]} b n x
			
			$visor(render) RemoveActor $actor
			$actor Delete
			${b}_labelMapper_${x} Delete
			${b}_label_${x} Delete
		}
		set visor(actoresEtiquetas) [list]
	}; #finproc
	
	proc establecerEtiquetasAMostrar { base etq onOff baseConf } {
		upvar #0 VisorVTK::$base visor

		
		switch $etq {
			ID {set visor(etqId) $onOff}
			CODB {set visor(etqCodB) $onOff}
			CARGA {set visor(etqCarga) $onOff}
			CODTINK {set visor(etqCodTink) $onOff}
			QUIRA {set visor(etqQuira) $onOff}
		}
		if {$visor(etqId) == 0 && $visor(etqCodB) == 0 && $visor(etqCarga) == 0 && $visor(etqCodTink) == 0 && $visor(etqQuira) == 0} {
			eliminarEtiquetas $base
		} else {
			crearEtiquetas $base $baseConf
		}
		$visor(renderW) Render
	}; #finproc
	
	proc crearEtiquetas { base baseConf } {
		upvar #0 VisorVTK::$base visor
		eliminarEtiquetas $base
		
		foreach mol $visor(moleculas) {
			upvar #0 Data::$mol datos
			
			for {set x 0} {$x < $datos(numAtomos)} {incr x} {
				set text ""
				if {$visor(etqId) == 1} {append text "[expr $x + 1]\n" }
				if {$visor(etqCodB) == 1} {append text "[Data::codBrandy $mol $x]\n" }
				if {$visor(etqCarga) == 1} {append text "$datos(carga,$x)\n" }
				if {$visor(etqCodTink) == 1} {Fich::calculaProcsConvPRM $baseConf ; append text "[Fich::obtenerCodXYZ $mol $x]\n" }
				if {$visor(etqQuira) == 1} {
					set index [lsearch $datos(quiralidad) [list $x *]]
					if {$index != -1} { append text "[lindex [lindex $datos(quiralidad) $index] 1]\n" }
				}

				lappend visor(listaEtiquetas) [list $text ${mol}_actorAtomo_${x}]
			}
		}
		calcularEtiquetas $base $baseConf
	}; #finproc
	
	proc calcularEtiquetas { base baseConf } {
		upvar #0 VisorVTK::$base visor
		upvar #0 Conf::$baseConf config
		
		eliminarActoresEtiquetas $base
		
		set contLabel 0
		set despl 0.12
		foreach etq $visor(listaEtiquetas) {
			
			set act [lindex $etq 1]
			if {$visor(visible,$act)} {
				vtkVectorText ${base}_label_${contLabel}
					${base}_label_${contLabel} SetText [lindex $etq 0]
				vtkPolyDataMapper ${base}_labelMapper_${contLabel}
					${base}_labelMapper_${contLabel} SetInputConnection [${base}_label_${contLabel} GetOutputPort]
				
				set pos [$act GetPosition]
				lappend visor(actoresEtiquetas) [vtkFollower ${base}_labelActor_${contLabel}]
					set actor [lindex $visor(actoresEtiquetas) end]
					$actor SetMapper ${base}_labelMapper_${contLabel}
					$actor SetPosition [expr [lindex $pos 0] + $despl] [expr [lindex $pos 1] + $despl] [expr [lindex $pos 2] + $despl]
					$actor SetScale 0.3 0.3 0.3
					set col [colorToRGB $config(colorEtq)]
					[$actor GetProperty] SetColor [lindex $col 0] [lindex $col 1] [lindex $col 2]
					$actor SetCamera [$visor(render) GetActiveCamera]
					$actor PickableOff
				$visor(render) AddActor $actor
				incr contLabel
			}
		}
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#									-	MANEJADORES	DE EVENTOS  -
#----------------------------------------------------------------------------------------------	
	#manejador LeftButtonPressEvent
	proc manejadorLBPE { base } {
		upvar #0 VisorVTK::$base visor
		
		#puts "pulso izq"
		
		set visor(ratonIzqPuls) 1
		set visor(ratonMov) 0
		
		set p [$visor(renderWInt) GetEventPosition]
		set visor(last) $p
		
		if { $visor(opcionAct) == "mover" } {
			
			#pico y si me encuentro un actor, entonces lo fijo como referencia, para los calculos de posiciones posteriores
			#que tendran lugar en manejadorMME
			set actorYcell [pica $base]
			
			#silo que se ha seleccionado es una enlace en el modo lineas, actualizaremos actorYcell de manera q tenga una cell
			#que corresponderia al centro del enlace
			if {[llength $actorYcell] == 1} {
				set actorYcell "$actorYcell $visor(ladosTubeFilter)"
			}
			
			if {[llength $actorYcell] == 2 } {
				set mol [devuelveDataDeActor [lindex $actorYcell 0]]
				if {[string last "Atomo" [lindex $actorYcell 0]] != -1 && [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) [lindex $actorYcell 0]] != -1} {
					#puts "hemos picado un atomo, que ya estaba seleccionado"
					set visor(actorOpcMover) [lindex $actorYcell 0]
				} elseif {[string last "Enlace" [lindex $actorYcell 0]] != -1} { 
					#hemos picado en un enlace, debo comprobar si alguno de sus extremos esta seleccionado
					#si asi es debo actuar como si se hubiera pulsado el mismo
					scan [lindex $actorYcell 0] {%[a-zA-Z0-9]_%[a-zA-Z0-9]_%[0-9]_%[0-9]_%[A-Z]} b n i j t
					
					#compruebo en cual de sus extremos he picado y si el atomo proximo a ese extremo
					#esta seleccionado
					set pulsi -1; set pulsj -1; set pulsc -1;
					
					set cell [lindex $actorYcell 1]
					
					if {$cell >= 0 && $cell < $visor(ladosTubeFilter)} {
						#puts "hemos picado en el lado cercano a $i"
						set pulsi 1
					} elseif {$cell >= $visor(ladosTubeFilter) && $cell < [expr 2 * $visor(ladosTubeFilter)]} {
						#he pulsado en el centro del enlace
						set pulsc 1
					} elseif {$cell >= [expr 2 * $visor(ladosTubeFilter)] && $cell < [expr 3 * $visor(ladosTubeFilter)]} {
						#puts "He picado en el lado cercano a $j"
						set pulsj 1
					}
					
					#compruebo si estan seleccionados los atomos de los extremos
					set estai [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) "${b}_actorAtomo_${i}"]
					set estaj [lsearch -exact $visor(actoresAtomosVTKSeleccionados,$mol) "${b}_actorAtomo_${j}"]
					
					#puts "$pulsi $pulsj $pulsc"
					#puts "$estai $estaj"
					
					if {($pulsi == 1 || $pulsc == 1) && $estai != -1} {
						#he pulsado el lado i del enlace y el atomo i esta seleccionado
						set visor(actorOpcMover) "${b}_actorAtomo_${i}"
					} elseif {($pulsj == 1 || $pulsc == 1) && $estaj != -1} {
						#he pulsado el lado j del enlace y el atomo j esta seleccionado
						set visor(actorOpcMover) "${b}_actorAtomo_${j}"
					} 
				}
			} 
			#comienzo un lazo de seleccion
			empiezaRSeleccion $base
			
		} elseif {$visor(opcionAct) == "rotar" && $visor(SHIFT) == 0 && $visor(CTRL) == 0} {
			#$visor(intStyle) StartRotate
		} elseif {$visor(opcionAct) == "desplazar"} {
			$visor(intStyle) StartPan
		} elseif {$visor(opcionAct) == "ampliar"} {
			$visor(intStyle) StartDolly
		}
	}; #finproc
	
	#manejador LeftButtonReleaseEvent
	proc manejadorLBRE { base baseConf } {
		upvar #0 VisorVTK::$base visor
		

		#puts "suelto raton"
		if {$visor(DobleClick) == 0} {
			#para q se produzca una seleccion no se puede haber movido el raton
			if {$visor(ratonMov) == 0} {
				set actorYcell [pica $base]
				if {[llength $actorYcell] == 2 } {
					seleccion $base $baseConf $actorYcell
				} elseif {[llength $actorYcell] == 1} { 
					#puts sellecionoprop
					seleccionProp $base $baseConf $actorYcell
				} elseif {$visor(SHIFT) == 0} {
					#puts deseleccionotodo
					deseleccionarTodo $base $baseConf
				}
				#puts "------------------------------------> $actorYcell "
			} 
			
			#lazo de seleccion
			if {$visor(opcionAct) == "mover" && $visor(rSelect) == 1 && $visor(actorOpcMover) == ""} {
				terminaRSeleccion $base
				if {$visor(ratonMov) == 1} {
					#si no se ha movido el raton, no tiene sentido seleccionar atomos, pues el rectangulo sera de tamaño 0
					#selecciona los atomos dentro del rectangulo
					seleccionaRSeleccion $base $baseConf
				}
			}
			
			if {$visor(opcionAct) == "mover" } {
				set visor(actorOpcMover) ""
			} elseif {$visor(opcionAct) == "rotar"  && $visor(SHIFT) == 0 && $visor(CTRL) == 0} {
				#$visor(intStyle) EndRotate
			} elseif {$visor(opcionAct) == "desplazar"} {
				$visor(intStyle) EndPan
			} elseif {$visor(opcionAct) == "ampliar"} {
				$visor(intStyle) EndDolly
			}
		}
		#restauro 
		$visor(renderW) Render
		set visor(ratonIzqPuls) 0
		set visor(ratonMov) 0
	}; #finproc
	
	proc manejadorRBPE { base } {
		upvar #0 VisorVTK::$base visor
		set visor(ratonDchoPuls) 1
		set visor(ratonMov) 0
		if {$visor(opcionAct) != "rotar" } {
			set pos [$visor(renderWInt) GetEventPosition]
			set visor(last) $pos
		}
	}; #finproc
	
	proc manejadorRBRE { base } {
		upvar #0 VisorVTK::$base visor
		set visor(ratonDchoPuls) 0
		set visor(ratonMov) 0
	}; #finproc
	
	#manejador MouseMoveEvent
	proc manejadorMME { base baseConf } {
		upvar #0 VisorVTK::$base visor
		set visor(ratonMov) 1
		
		#
		#puts "last : [$visor(renderWInt) GetLastEventPosition]"
		#puts "new : [$visor(renderWInt) GetEventPosition]\n"
		
		if { $visor(opcionAct) == "mover" && $visor(ratonIzqPuls) == 1 && $visor(actorOpcMover) != "" } {
			#se ha movido el raton, en la funcion mover, con el boton izq pulsado, y habiendose pulsado sobre un actor
			#lo que significa que debemos mover todos los actoresAtomos seleccionados en la misma proporcion que haya
			#entre el actor q hay en visor(actorOpcMover) y la posicion del raton en este momento
			
			set orig [$visor(actorOpcMover) GetPosition]
			$visor(render) SetWorldPoint [lindex $orig 0] [lindex $orig 1] [lindex $orig 2] 1.0
			$visor(render) WorldToDisplay
			set posDispl [$visor(render) GetDisplayPoint]; #posicion en pixeles del actor
			
			set posM [$visor(renderWInt) GetEventPosition]; #posicion en pixeles del cursor
			
			set a [list [lindex $posDispl 0] [lindex $posDispl 1]]
			set b [list [lindex $posM 0] [lindex $posM 1]]
			set c [math::linearalgebra::sub $b $a]; #vector diferencia entre el atomo y el cursor
			moverAtomos $base $c
			crearPuentesH $base
			#si hay medidas las actualizo
			calcularEtiquetas $base $baseConf
			$visor(renderW) Render
		} elseif { $visor(opcionAct) == "mover" && $visor(ratonIzqPuls) == 1 && $visor(actorOpcMover) == "" && $visor(rSelect) == 1} {
			#idem q el anterior pero sin haber pulsado sobre ningun actor
			actualizaRSeleccion $base
		} elseif {$visor(opcionAct) == "rotar" && $visor(ratonIzqPuls) == 1 && ($visor(SHIFT) == 1 || $visor(CTRL) == 1)} {
			#se ha movido el raton en el modo rotar, con el boton izq pulsado, y el control o el shift o ambos pulsados
			set lastXYpos [$visor(renderWInt) GetLastEventPosition]
			set XYpos [$visor(renderWInt) GetEventPosition]
			rotacionMoleculas $base $lastXYpos $XYpos
			calcularMedidas $base
			crearPuentesH $base
			calcularEtiquetas $base $baseConf
			$visor(renderW) Render
		} elseif {($visor(opcionAct) == "rotar" && $visor(ratonIzqPuls) == 1 && $visor(SHIFT) == 0 && $visor(CTRL) == 0) || \
				 (($visor(opcionAct) == "mover" || $visor(opcionAct) == "desplazar" || $visor(opcionAct) == "ampliar" ) && $visor(ratonDchoPuls) == 1 )} {
			set last $visor(last)
			set new [$visor(renderWInt) GetEventPosition]
			set visor(last) $new
			set camera [$visor(render) GetActiveCamera]
			#calculo la rotacion en cada eje, divido entre un factor > 1 para hacer la rotacion + lenta
			$camera Azimuth [expr ([lindex $last 0] - [lindex $new 0])/2.0]
			$camera Elevation [expr ([lindex $last 1] - [lindex $new 1])/2.0]
			$camera OrthogonalizeViewUp
			$visor(render) ResetCameraClippingRange
			$visor(renderW) Render
		}
	}; #finproc
	
	#manejador Doble-Click Event
	proc manejadorDCE { base baseConf } {
		upvar #0 VisorVTK::$base visor
		
		set visor(DobleClick) 1
		set actorYcell [pica $base]
		set n [llength $actorYcell]
		if {$n > 0} {
			if {$n == 1} {
				set actor $actorYcell
			} else {	
				set actor [lindex $actorYcell 0]
			}
			scan $actor {%[a-zA-Z0-9]_%[a-zA-Z0-9\_]} b r
			deseleccionarMol $base $b $baseConf
			seleccionarMolQuick $base $b $baseConf
		}
		$visor(renderW) Render
		set visor(DobleClick) 0
		set visor(ratonMov) 1
	}; #finproc
	
	#manejador KeyPressEvent
	proc manejadorKPE { base key } {
		upvar #0 VisorVTK::$base visor
		
		#puts $key
		$visor(renderWInt) SetKeySym $key
		switch $key {
			Shift_L - Shift_R {
				if {$visor(opcionAct) == "rotar" && $visor(SHIFT) == 0 && $visor(CTRL) == 0} {
					set visor(ejesRot) [calculaEjesCameraBB $base $visor(moleculas)]
				}
				set visor(SHIFT) 1
			}
			Control_L - Control_R {
				if {$visor(opcionAct) == "rotar" && $visor(CTRL) == 0} {
					set listaE [devuelveMolSeleccEntera $base]
					if {$listaE == ""} {
						set listaE $visor(moleculas)
					}
					set visor(ejesRot) [calculaEjesCameraBB $base $listaE]
				}
				set visor(CTRL) 1
			}
			w - W {
				foreach mol $visor(moleculas) {
					foreach at $visor(actoresAtomos,$mol) {[$at GetProperty] SetRepresentationToWireframe}
					foreach en $visor(actoresEnlaces,$mol) {[$en GetProperty] SetRepresentationToWireframe}
				}
				$visor(renderW) Render
			}
			s - S {
				foreach mol $visor(moleculas) {
					foreach at $visor(actoresAtomos,$mol) {[$at GetProperty] SetRepresentationToSurface}
					foreach en $visor(actoresEnlaces,$mol) {[$en GetProperty] SetRepresentationToSurface}
				}
				$visor(renderW) Render
			}
			r - R {
				$visor(render) ResetCamera
				$visor(renderW) Render
			}
			F5 {
				$visor(renderW) Render
			}
			default {
				
			}
		
		}
	}; #finproc
	
	#manejador KeyReleaseEvent
	proc manejadorKRE { base key } {
		upvar #0 VisorVTK::$base visor
		#puts [$visor(renderWInt) GetKeySym]
		$visor(renderWInt) SetKeySym $key
		switch $key {
			Shift_L - Shift_R {
				if {$visor(opcionAct) == "rotar" && $visor(CTRL) == 1} {
					set listaE [devuelveMolSeleccEntera $base]
					if {$listaE == ""} {
						set listaE $visor(moleculas)
					}
					set visor(ejesRot) [calculaEjesCameraBB $base $listaE]
				} 
				set visor(SHIFT) 0
			}
			Control_L {
				if {$visor(opcionAct) == "rotar" && $visor(SHIFT) == 1} {
					set visor(ejesRot) [calculaEjesCameraBB $base $visor(moleculas)]
				} 
				set visor(CTRL) 0
			}
			default {
				
			}
		}
	}; #finproc
	
	#manejadir ScrollRaton 
	proc manejadorScroll { base sentido } {
		upvar #0 VisorVTK::$base visor
		
		if {$sentido < 0} {
			[$visor(render) GetActiveCamera] Zoom 0.8
		} else {
			[$visor(render) GetActiveCamera] Zoom 1.2
		}
		$visor(renderW) Render
		
	}; #
	
	#establece la variable base(opcionAct), con el estado seleccionado
	#estado podra ser : seleccionar, rotar, desplazar centrar o ampliar
	proc manejadorEstado { base estado } {
		upvar #0 VisorVTK::$base visor
		switch $estado {
			mover {
				set visor(opcionAct) mover
				#desactivo el style del interactor, en este estado el la interaccion se realizara manualmente
				#$visor(renderWInt) SetInteractorStyle ""
			}
			rotar {
				set visor(opcionAct) rotar
				#$visor(renderWInt) SetInteractorStyle $visor(intStyle)
			}
			desplazar {
				set visor(opcionAct) desplazar
			}
			centrar {
				$visor(render) ResetCamera
				$visor(renderW) Render
			}
			ampliar {
				set visor(opcionAct) ampliar
				#$visor(renderWInt) SetInteractorStyle ""
			}
		}
	}; #finproc

	proc manejadorEnter { base x y } {
		upvar #0 VisorVTK::$base visor
		puts "enter : $x , [expr [lindex [$visor(renderW) GetSize] 1] - $y]"
		$visor(renderWInt) SetEventPosition $x [expr [lindex [$visor(renderW) GetSize] 1] - $y]
		$visor(renderWInt) SetEventPositionFlipY $x $y
		$visor(renderWInt) SetEventSize $x $y
		
		
		
	}; #finproc
	
#----------------------------------------------------------------------------------------------
#									-	MANEJADORES	DE EVENTOS  -
#----------------------------------------------------------------------------------------------	

	#salva como imagen lo q haya en ese momento en el visor, en el formato especificado.
	proc salvarPantallaComoImagen { base formato fichero } {
		upvar #0 VisorVTK::$base visor
		
		vtkRenderLargeImage ${base}renderLarge
			${base}renderLarge SetInput $visor(render)
			${base}renderLarge SetMagnification 4
		
		vtk${formato}Writer ${base}writer
			${base}writer SetInputConnection [${base}renderLarge GetOutputPort]
			${base}writer SetFileName $fichero
			${base}writer Write
			
		${base}renderLarge Delete
		${base}writer Delete
	}; #finproc

}; #finnamespace
