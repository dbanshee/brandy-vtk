# Microsoft Developer Studio Generated NMAKE File, Based on tlistadll.dsp
!IF "$(CFG)" == ""
CFG=tlistadll - Win32 Debug
!MESSAGE No configuration specified. Defaulting to tlistadll - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "tlistadll - Win32 Release" && "$(CFG)" != "tlistadll - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "tlistadll.mak" CFG="tlistadll - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "tlistadll - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "tlistadll - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "tlistadll - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\tlistadll.dll"


CLEAN :
	-@erase "$(INTDIR)\common.obj"
	-@erase "$(INTDIR)\listo.obj"
	-@erase "$(INTDIR)\modulo.obj"
	-@erase "$(INTDIR)\tclextension.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\tlistadll.dll"
	-@erase "$(OUTDIR)\tlistadll.exp"
	-@erase "$(OUTDIR)\tlistadll.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "TLISTADLL_EXPORTS" /Fp"$(INTDIR)\tlistadll.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\tlistadll.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\tlistadll.pdb" /machine:I386 /out:"$(OUTDIR)\tlistadll.dll" /implib:"$(OUTDIR)\tlistadll.lib" 
LINK32_OBJS= \
	"$(INTDIR)\common.obj" \
	"$(INTDIR)\listo.obj" \
	"$(INTDIR)\modulo.obj" \
	"$(INTDIR)\tclextension.obj"

"$(OUTDIR)\tlistadll.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "tlistadll - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\tlistadll.dll"


CLEAN :
	-@erase "$(INTDIR)\common.obj"
	-@erase "$(INTDIR)\listo.obj"
	-@erase "$(INTDIR)\modulo.obj"
	-@erase "$(INTDIR)\tclextension.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\tlistadll.dll"
	-@erase "$(OUTDIR)\tlistadll.exp"
	-@erase "$(OUTDIR)\tlistadll.ilk"
	-@erase "$(OUTDIR)\tlistadll.lib"
	-@erase "$(OUTDIR)\tlistadll.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "TLISTADLL_EXPORTS" /D "USE_TCL_STUBS" /Fp"$(INTDIR)\tlistadll.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\tlistadll.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib tclstub84.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\tlistadll.pdb" /debug /machine:I386 /out:"$(OUTDIR)\tlistadll.dll" /implib:"$(OUTDIR)\tlistadll.lib" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\common.obj" \
	"$(INTDIR)\listo.obj" \
	"$(INTDIR)\modulo.obj" \
	"$(INTDIR)\tclextension.obj"

"$(OUTDIR)\tlistadll.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("tlistadll.dep")
!INCLUDE "tlistadll.dep"
!ELSE 
!MESSAGE Warning: cannot find "tlistadll.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "tlistadll - Win32 Release" || "$(CFG)" == "tlistadll - Win32 Debug"
SOURCE=.\common.cpp

"$(INTDIR)\common.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\listo.cpp

"$(INTDIR)\listo.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\modulo.cpp

"$(INTDIR)\modulo.obj" : $(SOURCE) "$(INTDIR)"


SOURCE=.\tclextension.cpp

"$(INTDIR)\tclextension.obj" : $(SOURCE) "$(INTDIR)"



!ENDIF 

