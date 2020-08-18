;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "x64.nsh"
  !include "nsProcess.nsh"

  Unicode true
;--------------------------------
;General
  !define VERSION "1.0.0"
  !define PRODUCT_NAME "QtCustomWindow ${VERSION}"
  !define APPNAME "liamlife"
  !define MUI_FOLDER "QtCustomWindow"
  !define COMPANYNAME ******有限公司
  !define HELPURL "https://github.com/liamlife/QtCustomWindow"
  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_FINISHPAGE_RUN "$INSTDIR\${APPNAME}.exe"
  !define MUI_FINISHPAGE_RUN_CHECKED
  !define MUI_FINISHPAGE_RUN_TEXT "运行${PRODUCT_NAME}"
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
  !define BUILD_PATH "../qt_custom_window"

!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_Function AutoStartup
!define MUI_FINISHPAGE_SHOWREADME_TEXT "添加开机启动"

  Name "${PRODUCT_NAME}"
  # Icon "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
  # UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"
!define /date PRODUCT_DATE %Y%m%d

  OutFile "QtCustomWindow_${VERSION}_Setup.x64.build_${PRODUCT_DATE}.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES64\${MUI_FOLDER}"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin


;--------------------------------
;Variables

  ;Var StartMenuFolder

;--------------------------------
;Interface Configuration
  !define MUI_ICON "..\qt_custom_window\assets\ui_main.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall-nsis.ico"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "branding.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "branding-wizard.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "branding-wizard.bmp"
  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "license.txt"
  ;!insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${MUI_FOLDER}"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${MUI_FOLDER}"

  ;!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM

  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "SimpChinese"

;--------------------------------

;Installer Sections

Section "安装文件" SecFiles

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...
  File /r "${BUILD_PATH}\*.*"

  Call InstallVC


  ;create desktop shortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${APPNAME}.exe" ""

    ;create start-menu items
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${APPNAME}.exe" "" "$INSTDIR\${APPNAME}.exe" 0

  ;!insertmacro MUI_STARTMENU_WRITE_END

  ;Store installation folder
  WriteRegStr HKCU "Software\${PRODUCT_NAME}" "" $INSTDIR
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\${APPNAME}.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""

  ;管理员权限运行
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\${APPNAME}.exe" "RUNASADMIN"
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Descriptions

  LangString DESC_SecFiles ${LANG_SIMPCHINESE} "基础组件"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFiles} $(DESC_SecFiles)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section
Section Un."主程序组件"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir /r "$INSTDIR"

  ;!insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"

  DeleteRegKey /ifempty HKCU "Software\${PRODUCT_NAME}"
  DeleteRegKey HKCU "Software\${MUI_FOLDER}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
  DeleteRegKey HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\$INSTDIR\${APPNAME}.exe"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${APPNAME}"
SectionEnd

; 安装VC环境
Function InstallVC
   ReadRegStr $0 HKLM "SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64" "Version"
   ${If} $0 == ""
      ExecWait "$INSTDIR\vc_redist.x64.exe /q"
   ${EndIf}
FunctionEnd

Function LaunchLink
  ExecShell "" "$INSTDIR\${APPNAME}.exe"
FunctionEnd

Function AutoStartup
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${APPNAME}" "$INSTDIR\${APPNAME}.exe"
FunctionEnd

Function .onInit
  ${nsProcess::FindProcess} "${APPNAME}.exe" $R0

  ${If} $R0 == 0
    MessageBox MB_OK "安装程序检测到‘${PRODUCT_NAME}’ 正在运行，请关闭之后再安装！"
    Quit
 ${EndIf}

FunctionEnd

Function un.onInit
  ${nsProcess::FindProcess} "${APPNAME}.exe" $R0

  ${If} $R0 == 0
    MessageBox MB_OK "卸载程序检测到‘${PRODUCT_NAME}’ 正在运行，请关闭之后再卸载！"
    Quit
 ${EndIf}
FunctionEnd

ShowInstDetails show

ShowUnInstDetails show

BrandingText "${HELPURL}"
