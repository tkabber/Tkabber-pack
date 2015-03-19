; InnoSetup (http://www.innosetup.com) installer script
; for generation of "Tkabber-Pack" binary distribution
; of the free XMPP client "Tkabber" (http://tkabber.jabber.ru).
; Created by Konstantin Khomoutov <khomoutov@gmail.com>
; with the help of ISTool utility (http://www.istool.org).
; See license-<LANG>.txt for the details about usage and
; distribution of this code.
[Files]
Source: tcl\*.*; DestDir: {app}\Tcl; Flags: recursesubdirs
Source: tkabber\*.*; DestDir: {app}\Tkabber; Flags: recursesubdirs
Source: tkabber-plugins\*.*; DestDir: {app}\Plugins; Flags: recursesubdirs
Source: bootstrap.tcl; DestDir: {app}
Source: tkabber\doc\tkabber.html; DestDir: {app}\doc
Source: doc\tkabber.url; DestDir: {app}\doc
Source: doc\wiki.url; DestDir: {app}\doc
Source: info-after-en.txt; DestDir: {app}\doc; Languages: en
Source: info-after-ru.txt; DestDir: {app}\doc; Languages: ru
Source: doc\licenses\*.*; DestDir: {app}\doc\licenses; Flags: recursesubdirs
Source: images\install.ico; DestDir: {app}\images
Source: images\uninstall.ico; DestDir: {app}\images
Source: images\manual.ico; DestDir: {app}\images
Source: images\link.ico; DestDir: {app}\images
Source: images\wiki.ico; DestDir: {app}\images
[Setup]
OutputBaseFilename=tkabber-pack-{#TKABBER_VERSION}-{#TKABBER_HOST}
OutputDir=..
Compression=lzma/ultra
AppCopyright=Alexey Schepin
AppName=Tkabber
AppVerName=Tkabber {#TKABBER_VERSION}
DefaultDirName={pf}\Tkabber
AppSupportURL=http://tkabber.jabber.ru
AppUpdatesURL=http://tkabber.jabber.ru/download
AppVersion=Tkabber {#TKABBER_VERSION}
DefaultGroupName=Tkabber
ShowLanguageDialog=yes
SetupIconFile=images\install.ico
WizardImageFile=images\wizard-main.bmp
WizardSmallImageFile=images\wizard-mini-alt.bmp
AppID={{DFB83855-0A28-48A7-A452-ECA489A4C558}
VersionInfoVersion={#TKABBER_VERSION}
VersionInfoDescription=Tkabber-Pack: all-in-one package containing Tkabber, Tcl/Tk and certain Tcl/Tk extension
VersionInfoTextVersion={#TKABBER_VERSION}
VersionInfoCopyright=Tkabber-Pack is (c) 2008-2014 Konstantin Khomoutov, artwork is (c) 2008 Artem Bannikov
UninstallDisplayName=Tkabber {#TKABBER_VERSION}
InternalCompressLevel=ultra
SolidCompression=true
AppContact=xmpp:tkabber@conference.jabber.ru
AppReadmeFile={app}\doc\tkabber.html
PrivilegesRequired=none
#if TKABBER_HOST == "x64"
ArchitecturesAllowed={#TKABBER_HOST}
ArchitecturesInstallIn64BitMode={#TKABBER_HOST}
#endif
[Icons]
Name: {group}\Tkabber; Filename: {app}\Tcl\bin\wish86.exe; Parameters: """{app}\bootstrap.tcl"" -name Tkabber"; WorkingDir: {app}; IconFilename: {app}\images\install.ico
Name: {group}\Open Plugins Folder; Filename: {app}\Plugins; WorkingDir: {app}\Plugins; Languages: en
Name: {group}\Открыть каталог с расширениями; Filename: {app}\Plugins; WorkingDir: {app}\Plugins; Languages: ru
Name: {group}\Installation and operation guide; Filename: {app}\doc\tkabber.html; IconFilename: {app}\images\manual.ico; Languages: en
Name: {group}\Руководство по установке и настройке; Filename: {app}\doc\tkabber.html; IconFilename: {app}\images\manual.ico; Languages: ru
Name: {group}\Official Internet site; Filename: {app}\doc\tkabber.url; IconFilename: {app}\images\link.ico; Languages: en
Name: {group}\Официальный сайт; Filename: {app}\doc\tkabber.url; IconFilename: {app}\images\link.ico; Languages: ru
Name: {group}\Official wiki; Filename: {app}\doc\wiki.url; IconFilename: {app}\images\wiki.ico; Languages: en
Name: {group}\Официальная wiki; Filename: {app}\doc\wiki.url; IconFilename: {app}\images\wiki.ico; Languages: ru
Name: {group}\Quick Tips; Filename: {app}\doc\info-after-en.txt; IconFilename: {app}\images\manual.ico; Languages: en
Name: {group}\Подсказки по работе; Filename: {app}\doc\info-after-ru.txt; IconFilename: {app}\images\manual.ico; Languages: ru
Name: {group}\{cm:UninstallProgram, Tkabber}; Filename: {uninstallexe}; IconFilename: {app}\images\uninstall.ico
Name: {userdesktop}\Tkabber; Filename: {app}\Tcl\bin\wish86.exe; Parameters: """{app}\bootstrap.tcl"" -name Tkabber"; WorkingDir: {app}\Tkabber; IconFilename: {app}\images\install.ico; Tasks: DesktopShortcuts; IconIndex: 0
[Tasks]
Name: DesktopShortcuts; Description: Create desktop shortcuts for the current user; Languages: en
Name: DesktopShortcuts; Description: Поместить ярлыки на рабочий стол текущего пользователя; Languages: ru
[Languages]
Name: en; MessagesFile: compiler:Default.isl; LicenseFile: license-en.txt; InfoAfterFile: info-after-en.txt
Name: ru; MessagesFile: compiler:Languages\Russian.isl; LicenseFile: license-ru.txt; InfoAfterFile: info-after-ru.txt
