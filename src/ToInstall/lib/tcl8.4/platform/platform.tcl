# -*- tcl -*-
# ### ### ### ######### ######### #########
## Overview

# Heuristics to assemble a platform identifier from publicly available
# information. The identifier describes the platform of the currently
# running tcl shell. This is a mixture of the runtime environment and
# of build-time properties of the executable itself.
#
# Examples:
# <1> A tcl shell executing on a x86_64 processor, but having a
#   wordsize of 4 was compiled for the x86 environment, i.e. 32
#   bit, and loaded packages have to match that, and not the
#   actual cpu.
#
# <2> The hp/solaris 32/64 bit builds of the core cannot be
#   distinguished by looking at tcl_platform. As packages have to
#   match the 32/64 information we have to look in more places. In
#   this case we inspect the executable itself (magic numbers,
#   i.e. fileutil::magic::filetype).
#
# The basic information used comes out of the 'os' and 'machine'
# entries of the 'tcl_platform' array. A number of general and
# os/machine specific transformation are applied to get a canonical
# result.
#
# General
# Only the first element of 'os' is used - we don't care whether we
# are on "Windows NT" or "Windows XP" or whatever.
#
# Machine specific
# % arm*   -> arm
# % sun4*  -> sparc
# % intel  -> ix86
# % i*86*  -> ix86
# % Power* -> powerpc
# % x86_64 + wordSize 4 => x86 code
#
# OS specific
# % AIX are always powerpc machines
# % HP-UX 9000/800 etc means parisc
# % linux has to take glibc version into account
# % sunos -> solaris, and keep version number
#
# NOTE: A platform like linux glibc 2.3, which can use glibc 2.2 stuff
# has to provide all possible allowed platform identifiers when
# searching search. Ditto a solaris 2.8 platform can use solaris 2.6
# packages. Etc. This is handled by the other procedure, see below.

# ### ### ### ######### ######### #########
## Requirements

namespace eval ::platform {}

# ### ### ### ######### ######### #########
## Implementation

# -- platform::generic
#
# Assembles an identifier for the generic platform. It leaves out
# details like kernel version, libc version, etc.

proc ::platform::generic {} {
    global tcl_platform

    set plat [string tolower [lindex $tcl_platform(os) 0]]
    set cpu  $tcl_platform(machine)

    switch -glob -- $cpu {
	sun4* {
	    set cpu sparc
	}
	intel -
	i*86* {
	    set cpu ix86
	}
	x86_64 {
	    if {$tcl_platform(wordSize) == 4} {
		# See Example <1> at the top of this file.
		set cpu ix86
	    }
	}
	"Power*" {
	    set cpu powerpc
	}
	"arm*" {
	    set cpu arm
	}
    }

    switch -- $plat {
	windows {
	    set plat win32
	}
	sunos {
	    set plat solaris
	    if {$tcl_platform(wordSize) == 8} {
		append cpu 64
	    }
	}
	darwin {
	    set plat macosx
	}
	aix {
	    set cpu powerpc
	    if {$tcl_platform(wordSize) == 8} {
		append cpu 64
	    }
	}
	hp-ux {
	    set plat hpux
	    if {$cpu ne "ia64"} {
		set cpu parisc
		if {$tcl_platform(wordSize) == 8} {
		    append cpu 64
		}
	    }
	}
	osf1 {
	    set plat tru64
	}
    }

    return "${cpu}-${plat}"
}

# -- platform::identify
#
# Assembles an identifier for the exact platform, by extending the
# generic identifier. I.e. it adds in details like kernel version,
# libc version, etc., if they are relevant for the loading of
# packages on the platform.

proc ::platform::identify {} {
    global tcl_platform

    set id [generic]
    regexp {^([^-]+)-([^-]+)$} $id -> cpu plat

    switch -- $plat {
	solaris {
	    regsub {^5} $tcl_platform(osVersion) 2 text
	    append plat $text
	    return "${cpu}-${plat}"
	}
	linux {
	    # Look for the libc*.so and determine its version
	    # (libc5/6, libc6 further glibc 2.X)

	    set libclist [glob -nocomplain /lib/libc.so*]
	    if {[llength $libclist]} {
		set libc [lindex $libclist 0]

		# Try executing the library first. This should suceed
		# for a glibc library, and return the version
		# information.

		if {![catch {
		    set vdata [lindex [split [exec $libc] \n] 0]
		}]} {
		    regexp {([0-9]+(\.[0-9]+)*)} $vdata -> v
		    foreach {major minor} [split $v .] break
		    set v ${major}.${minor}
		} else {
		    # Trouble executing the library. Poke into its
		    # symbol information using basic system utilities
		    # to get an approximation of the information we
		    # want.

		    set vlist [exec nm $libc | grep @GLIBC_ | \
				   grep -v PRIVATE | \
				   sed -e {s/^.*@//} -e {s/GLIBC_//} | \
				   sort | uniq 2>/dev/null]

		    set maxmajor 0
		    set maxminor 0
		    foreach v $vlist {
			foreach {major minor} [split $v .] break
			if {$major > $maxmajor} {
			    set maxmajor $major
			    set maxminor $minor
			} elseif {
				  ($major == $maxmajor) &&
				  ($minor >  $maxminor) &&
			      } {
			    set maxminor $minor
			}
		    }

		    set v ${maxmajor}.${maxminor}
		}

		append plat -glibc$v
	    }
	    return "${cpu}-${plat}"
	}
    }

    return $id
}

# -- platform::patterns
#
# Given an exact platform identifier, i.e. _not_ the generic
# identifier it assembles a list of exact platform identifier
# describing platform which should be compatible with the
# input.
#
# I.e. packages for all platforms in the result list should be
# loadable on the specified platform.

# << Should we add the generic identifier to the list as well ? In
#    general it is not compatible I believe. So better not. In many
#    cases the exact identifier is identical to the generic one
#    anyway.
# >>

proc ::platform::patterns {id} {
    set res [list $id]
    switch -glob --  $id {
	*-solaris* {
	    if {![regexp {(.*)-solaris([^-]*)} $id -> cpu v]} {return $id}
	    foreach {major minor} [split $v .] break
	    incr minor -1
	    for {set j $minor} {$j >= 6} {incr j -1} {
		lappend res ${cpu}-solaris${major}.${j}
	    }
	}
	*-linux* {
	    if {![regexp {(.*)-linux-glibc([^-]*)} $id -> cpu v]} {return $id}
	    foreach {major minor} [split $v .] break
	    incr minor -1
	    for {set j $minor} {$j >= 0} {incr j -1} {
		lappend res ${cpu}-linux-glibc${major}.${j}
	    }
	}
    }
    lappend res tcl ; # Pure tcl packages are always compatible.
    return $res
}


# ### ### ### ######### ######### #########
## Ready

package provide platform 1.0

# ### ### ### ######### ######### #########
## Demo application

if {[info exists argv0] && ($argv0 eq [info script])} {
    puts ====================================
    parray tcl_platform
    puts ====================================
    puts Generic\ identification:\ [::platform::generic]
    puts Exact\ identification:\ \ \ [::platform::identify]
    puts ====================================
    puts Search\ patterns:
    puts *\ [join [::platform::patterns [::platform::identify]] \n*\ ]
    puts ====================================
    exit 0
}
