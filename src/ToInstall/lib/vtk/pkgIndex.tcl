# Visualization Toolkit (VTK) Tcl package configuration.

package ifneeded vtkinit {5.0} {
  namespace eval ::vtk::init {
    proc load_library_package {libName libPath {libPrefix {}}} {
      set libExt [info sharedlibextension]
      set currentDirectory [pwd]
      set libFile [file join $libPath "$libPrefix$libName$libExt"]
      if {[catch "cd {$libPath}; load {$libFile}" errorMessage]} {
        puts $errorMessage
      }
      cd $currentDirectory
    }
    proc require_package {name {version {5.0}}} {
      if {[catch "package require -exact $name $version" errorMessage]} {
        puts $errorMessage
        return 0
      } else {
        return 1
      }
    }
    set version {5.0}
    set kits {}
    foreach kit { base Common Filtering IO Imaging Graphics
                  Rendering VolumeRendering
                  Hybrid Widgets
                   } {
      lappend kits [string tolower "${kit}"]
    }
  }
  package provide vtkinit {5.0}
}

foreach kit { Common Filtering IO Imaging Graphics
              Rendering VolumeRendering
              Hybrid Widgets
               } {
  package ifneeded "vtk${kit}TCL" {5.0} "
    package require -exact vtkinit {5.0}
    ::vtk::init::load_library_package {vtk${kit}TCL} {$dir}
  "
  package ifneeded "vtk[string tolower ${kit}]" {5.0} "
    package require -exact vtkinit {5.0}
    if {\[catch {source \[file join {$dir} {vtk[string tolower ${kit}]} {vtk[string tolower ${kit}].tcl}\]} errorMessage\]} {
      puts \$errorMessage
    }
  "
}

set src {vtk}
package ifneeded ${src} {5.0} "
package require -exact vtkinit {5.0}
if {\[catch {source \{$dir/vtk.tcl}} errorMessage\]} {
  puts \$errorMessage
}

"

foreach src { vtkbase vtkinteraction vtktesting} {
  package ifneeded ${src} {5.0} "
    package require -exact vtkinit {5.0}
    if {\[catch {source \[file join {$dir} {$src.tcl}\]} errorMessage\]} {
      puts \$errorMessage
    }
	
  "
}
