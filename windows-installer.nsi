; NSIS test w/ modern user inteface
;
; Include the modern UI
  !include "MUI2.nsh"

; General config
  Name "OmegaV Daemon"
  OutFile "OmegaV Daemon Installer.exe"
  Unicode True

  ; Default installation directory
  InstallDir "$LOCALAPPDATA\OmegaV Daemon"

  ; Get installation folder from registry is available
  InstallDirRegKey HKCU "Software\OmegaV Daemon" ""

  ; Set the icon
  !define MUI_ICON "OV.ico"
  !define MUI_UNICON "OV.ico"

; Interace settings
  !define MUI_ABORTWARNING

; Start menu config
  Var StartMenuFolder
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\"
  !define MUI_STARTMENUOAGE_REGISTRY_VALUENAME "OmegaV Daemon"

; Pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "hello.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ; Uninstaller pages
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
 
; Languages
  !insertmacro MUI_LANGUAGE "English"

; Installer section
Section ! "REQUIRED - OmegaV Daemon"
	SetOutPath "$INSTDIR"  ; Set the appropriate installation directory
	File omegav-daemon.exe ; Install the program

	; Store the installtion directory in the registry
	WriteRegStr HKCU "Software\OmegaV Daemon" "" $INSTDIR

	; Add the program to the start menu
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
	  ; Create a directory in the Start Menu
	  CreateDirectory "$SMPROGRAMS\$StartMenuFolder"

	  ; Create shortcuts
	  CreateShortcut "$SMPROGRAMS\$StartMenuFolder\OmegaV Daemon.lnk" "$INSTDIR\omegav-daemon.exe"
	  CreateShortcut "$SMPROGRAMS\$StartMenuFolder\OmegaV Daemon Uninstall.lnk" "$INSTDIR\Uninstall.exe"
	!insertmacro MUI_STARTMENU_WRITE_END
	
	; Create the uninstaller
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

; The part that adds the program to the autostart list
Section "Auto start on login"
	WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "OmegaV Daemon" "$INSTDIR\omegav-daemon.exe"
SectionEnd

; -------------------
; Uninstaller section
; -------------------
Section "Uninstall"
	; Remove the program from the Start Menu
	!insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
	Delete "$SMPrograms\$StartMenuFolder\OmegaV Daemon.lnk"
	Delete "$SMPrograms\$StartMenuFolder\OmegaV Daemon Uninstall.lnk"
	RMDir "$SMPrograms\$StartMenuFolder"

	; Delete the install directory from the registry
	DeleteRegKey HKCU "Software\OmegaV Daemon"
	DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "OmegaV Daemon"
	
	; Remove the program itself
	Delete omegav-daemon.exe
	RMDir "$INSTDIR"
SectionEnd
