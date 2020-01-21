# -*- tcl -*-
# ### ### ### ######### ######### #########
## Overview

# Higher-level commands which invoke the functionality of this package
# for an arbitrary tcl shell (tclsh, wish, ...). This is required by a
# repository as while the tcl shell executing packages uses the same
# platform in general as a repository application there can be
# differences in detail (i.e. 32/64 bit builds).

# ### ### ### ######### ######### #########
## Requirements

package require platform
namespace eval ::platform::shell {}

# ### ### ### ######### ######### #########
## Implementation

# -- platform::shell::generic

proc ::platform::shell::generic {shell} {
    # Argument is the path to a tcl shell.

    variable self
    variable dir

    if {![file exists $shell]} {
	return -code error "Shell \"$shell\" does not exist"
    }
    if {![file executable $shell]} {
	return -code error "Shell \"$shell\" is not executable"
    }

    # If we are wrapped we have to copy the code somewhere where the
    # spawned shell is able to read it.

    set out 0

    set base [file join $dir platform.tcl]

    if {[lindex [file system $self]] ne "native"} {
	set temp [fileutil::tempfile platform]
	file copy -force $base $temp
	set base $temp
	set out 1
    }

    set     code {}
    lappend code [list source $base]
    lappend code {puts [platform::generic]}
    lappend code {exit 0}

    if {[catch {
	set arch [exec $shell << [join $code \n]]
    }]} {
	return -code error "Shell \"$shell\" is not executable"
    }

    if {$out} {file delete -force $base}
    return $arch
}

# -- platform::shell::identify

proc ::platform::shell::identify {shell} {
    # Argument is the path to a tcl shell.

    variable self
    variable dir

    if {![file exists $shell]} {
	return -code error "Shell \"$shell\" does not exist"
    }
    if {![file executable $shell]} {
	return -code error "Shell \"$shell\" is not executable"
    }

    # If we are wrapped we have to copy the code somewhere where the
    # spawned shell is able to read it.

    set out 0

    set base [file join $dir platform.tcl]

    if {[lindex [file system $self]] ne "native"} {
	set temp [fileutil::tempfile platform]
	file copy -force $base $temp
	set base $temp
	set out 1
    }

    set     code {}
    lappend code [list source $base]
    lappend code {puts [platform::identify]}
    lappend code {exit 0}

    if {[catch {
	set arch [exec $shell << [join $code \n]]
    }]} {
	return -code error "Shell \"$shell\" is not executable"
    }

    if {$out} {file delete -force $base}
    return $arch
}

# -- platform::shell::platform

proc ::platform::shell::platform {shell} {
    # Argument is the path to a tcl shell.

    if {![file exists $shell]} {
	return -code error "Shell \"$shell\" does not exist"
    }
    if {![file executable $shell]} {
	return -code error "Shell \"$shell\" is not executable"
    }

    set     code {}
    lappend code {puts $tcl_platform(platform)}
    lappend code {exit 0}

    if {[catch {
	set platform [exec $shell << [join $code \n]]
    }]} {
	return -code error "Shell \"$shell\" is not executable"
    }

    return $platform
}

# ### ### ### ######### ######### #########
## Ready

namespace eval ::platform::shell {
    variable self [info script]
    variable dir  [file dirname $self]
}

package provide platform::shell 1.0
