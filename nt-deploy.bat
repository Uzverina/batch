
@echo off
:*** CONFIGURING SYSTEM ***
::
echo *** Setting up "LAN settings" ***
:set IFACE="ethernet"
:set IP=10.169.10.2
:set MASK=255.255.255.0
:set GWMETRIC=1
:netsh interface ip set address name=%IFACE% source=static addr=%IP% mask=%MASK% gwmetric=%GWMETRIC%
:netsh interface ip set dns name=%IFACE% source=static address=none register=PRIMARY
echo *** DONE *** 
echo .
:: timeout-ac - in case of desktop pc
:: timeout-dc - in case of laptop pc (battery usage)
echo *** Setting up display timeout to 3 minutes ***
powercfg.exe /x monitor-timeout-ac 3
echo *** DONE ***
echo . 
:: hide d,z volumes (from windows explorer only)
echo *** Hiding drives in win explorer ***
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ /f NoDrives /t REG_DWORD /c /e
if not %errorlevel% LEQ 0 (reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -t REG_DWORD -v NoDrives -d 33554440 -f && echo *** registry added ***) else echo !!! DIR already exist !!!
echo .
:: restrict accsess to d,z volumes (from windows explorer only)
echo *** Restricting access to drives ***
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ /f NoViewOnDrive /t REG_DWORD /c /e
if not %errorlevel% LEQ 0 (reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -t REG_DWORD -v NoViewOnDrive -d 33554440 -f && echo *** registry added ***) else echo !!! DIR already exist !!!
echo .
::
:*** CREATE SERVICE SCRIPTS ***
::
echo ****** CREATING SERVICE SCRIPTS ******
echo .
::set var
set core="C:\Program Files\service.core\soft"
::
:Create batch file cleaning unnecessary DIRs
echo *** Create batch file cleaning unnecessary DIRs ***
if exist %systemroot%\cl.bat echo !!! DIR already exist !!! && goto clexist
echo @echo off                                                                >> %systemroot%\cl.bat
echo reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f >> %systemroot%\cl.bat
echo reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f     >> %systemroot%\cl.bat
echo reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers"           >> %systemroot%\cl.bat
echo cd %userprofile%\documents\                                              >> %systemroot%\cl.bat
echo attrib Default.rdp -s -h                                                 >> %systemroot%\cl.bat
echo del Default.rdp                                                          >> %systemroot%\cl.bat
echo cd %tmp%\vmw*                                                            >> %systemroot%\cl.bat
echo del VMwareDnD /s /q                                                      >> %systemroot%\cl.bat
echo "%ProgramFiles%\CCleaner\CCleaner64.exe" /auto                           >> %systemroot%\cl.bat
echo "C:\Program Files\service.core\soft\usboblivion-1.10.3.0\USBOblivion64.exe" -enable -nosave -auto -silent >> %systemroot%\cl.bat
echo echo ### DONE ###                                                        >> %systemroot%\cl.bat
echo timeout 3                                                                >> %systemroot%\cl.bat
attrib +h %systemroot%\cl.bat
echo *** DONE ***
:clexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file executing application TOTALCMD
echo *** Create batch file executing application TOTALCMD ***
if exist %systemroot%\t.bat echo !!! DIR already exist !!! && goto texist
echo @echo off                                                                 >> %systemroot%\t.bat
echo start %%systemroot%%\TCPU\TOTALCMD.exe                                    >> %systemroot%\t.bat
echo exit                                                                      >> %systemroot%\t.bat
attrib +s +h %systemroot%\t.bat
echo *** DONE ***
:texist
echo .
:: ----------------------------------------------------------------------------------------
set core="C:\Program Files\service.core\soft"
:Create batch file executing application ProcessHacker
echo *** Create batch file executing application ProcessHacker ***
if exist %systemroot%\htop.bat echo !!! DIR already exist !!! && goto htopexist
echo @echo off                                                              >> %systemroot%\htop.bat
echo call "C:\Program Files\service.core\soft\processhacker-2.36-bin\x64\ProcessHacker.exe"             >> %systemroot%\htop.bat
echo exit                                                                   >> %systemroot%\htop.bat
attrib +h %systemroot%\htop.bat
echo *** DONE ***
:htopexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file starting *vmx files
echo *** Create batch file starting *vmx files ***
if exist %systemroot%\z.bat echo !!! DIR already exist !!! && goto zexist
echo @echo off                                                                 >> %systemroot%\z.bat
echo start vmware.exe z:\kali*\*.vmx                                           >> %systemroot%\z.bat
attrib +h +s %systemroot%\z.bat
echo *** DONE ***
:zexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file executing emergency_backup.bat script
echo *** Create batch file executing emergency_backup.bat script ***
if exist %systemroot%\eme.bat echo !!! DIR already exist !!! && goto emeexist
echo @echo off                                                               >> %systemroot%\eme.bat
echo start %systemroot%\emergency_backup.bat                                 >> %systemroot%\eme.bat
attrib +h %systemroot%\eme.bat  
echo *** DONE ***
:emeexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file executing backup-c.bat script
echo *** Create batch file executing backup-c.bat script ***
if exist %systemroot%\ba.bat echo !!! DIR already exist !!! && goto baexist
echo @echo off                                                                >> %systemroot%\ba.bat
echo start %systemroot%\backup-c.bat                                          >> %systemroot%\ba.bat
attrib +h %systemroot%\ba.bat
echo *** DONE ***
:baexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file executing base and \\base\Docs_job\..\..\2018 DIRs
echo *** Create batch file executing base and \\base\Docs_job\..\..\2018 DIRs ***
if exist %systemroot%\start.bat echo !!! DIR already exist !!! && goto startexist
echo @echo off                                                             >> %systemroot%\start.bat
echo start %userprofile%\desktop\dbase.accdb                               >> %systemroot%\start.bat
echo start explorer c:\2018.lnk                                            >> %systemroot%\start.bat
attrib +h %systemroot%\start.bat
echo *** DONE ***
:startexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file killing access.exe process
echo *** Create batch file killing access.exe process ***
if exist %systemroot%\kill.bat echo !!! DIR already exist !!! && goto killexist
echo @echo off                                                              >> %systemroot%\kill.bat
echo taskkill /im msaccess.exe                                              >> %systemroot%\kill.bat
echo echo ### DONE  ###                                                     >> %systemroot%\kill.bat
echo timeout 2                                                              >> %systemroot%\kill.bat
attrib +h %systemroot%\kill.bat
echo *** DONE ***
:killexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file mnt
echo *** Create batch file mnt ***
if exist %systemroot%\mnt.bat echo !!! DIR already exist !!! && goto mntexist
echo @echo off                                                               >> %systemroot%\mnt.bat
echo chcp 1251                                                               >> %systemroot%\mnt.bat
echo start truecrypt /q /l z /v c:\Windows\assembly\GAC\ADODB\iconic.ttf     >> %systemroot%\mnt.bat
echo exit                                                                    >> %systemroot%\mnt.bat
attrib +s +h %systemroot%\mnt.bat
echo *** DONE ***
:mntexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file mnt2
echo *** Create batch file mnt2 ***
if exist %systemroot%\mnt2.bat echo !!! DIR already exist !!! && goto mnt2exist
echo @echo off                                                              >> %systemroot%\mnt2.bat
echo chcp 1251                                                              >> %systemroot%\mnt2.bat
echo start veracrypt /q /l y /v d:\505\pic\!ARTYPres.ALPHA9,VoltaMoskvaEkskliuzyvnaiatransliatsyia.mp4      >> %systemroot%\mnt2.bat
echo exit                                                                   >> %systemroot%\mnt2.bat
attrib +s +h %systemroot%\mnt2.bat
echo *** DONE ***
:mnt2exist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file cleaning unwanted dirs on SessionUnlock event [antivedro protection xD]
echo *** Create batch file cleaning unwanted dirs on SessionUnlock event [antivedro xD] ***
if exist %systemroot%\un.bat echo !!! DIR already exist !!! && goto unexist	
echo @echo off	                                                                             >> %systemroot%\un.bat
echo reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f >> %systemroot%\un.bat
echo reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f        >> %systemroot%\un.bat
echo "%ProgramFiles%\CCleaner\CCleaner64.exe" /auto                                          >> %systemroot%\un.bat
echo "C:\Program Files\service.core\soft\usboblivion-1.10.3.0\USBOblivion64.exe" -enable -nosave -auto -silent  >> %systemroot%\un.bat
echo exit                                                                                    >> %systemroot%\un.bat
attrib +s +h %systemroot%\un.bat
echo *** DONE ***
:unexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file executing unlock.bat (done for hiding process status information)
echo *** Create batch file executing unlock.bat (done for hiding process status information) ***
if exist %systemroot%\unlock.bat echo !!! DIR already exist !!! && goto unlockexist
echo @echo off                                                                >> %systemroot%\unlock.bat
echo call %systemroot%\un.bat                                                 >> %systemroot%\unlock.bat
echo exit                                                                     >> %systemroot%\unlock.bat
attrib +s +h %systemroot%\un.bat
echo *** DONE ***
:unlockexist
:: ----------------------------------------------------------------------------------------
:Create batch file cleaning unwanted dirs and FORCE UNMOUNTING ctr quiting crypt apps
echo *** Create batch cleaning unwanted dirs and FORCE UNMOUNTING ctr quiting crypt apps ***
if exist %systemroot%\ex.bat echo !!! DIR already exist !!! && goto exexist
echo @echo off                                                                >> %systemroot%\ex.bat
echo truecrypt /d /q /s /f                                                    >> %systemroot%\ex.bat
echo echo .################# 8 ##################                             >> %systemroot%\ex.bat
echo veracrypt /d /q /s /f                                                    >> %systemroot%\ex.bat
echo echo .################# 7 ##################                             >> %systemroot%\ex.bat
echo reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f >> %systemroot%\ex.bat
echo echo .################# 6 ##################                             >> %systemroot%\ex.bat
echo reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f >> %systemroot%\ex.bat
echo echo .################# 5 ##################                             >> %systemroot%\ex.bat
echo cd %userprofile%\documents                                             >> %systemroot%\ex.bat
echo attrib Default.rdp -s -h                                                 >> %systemroot%\ex.bat
echo del Default.rdp                                                          >> %systemroot%\ex.bat
echo echo .################# 4 ##################                             >> %systemroot%\ex.bat
echo cd %tmp%\vmw*                                                            >> %systemroot%\ex.bat
echo del VMwareDnD /s /q                                                      >> %systemroot%\ex.bat
echo echo .################# 3 ##################                             >> %systemroot%\ex.bat
echo "%ProgramFiles%\CCleaner\CCleaner64.exe" /auto                           >> %systemroot%\ex.bat
echo echo .################# 2 ##################                             >> %systemroot%\ex.bat
echo "C:\Program Files\service.core\soft\usboblivion-1.10.3.0\USBOblivion64.exe" -enable -nosave -auto -silent  >> %systemroot%\ex.bat
echo echo .################# 1 ##################                             >> %systemroot%\ex.bat
echo echo .################# OPERATION COMPLETE ##################            >> %systemroot%\ex.bat
echo taskkill /f /im truecrypt.exe                                            >> %systemroot%\ex.bat
echo taskkill /f /im veracrypt.exe                                            >> %systemroot%\ex.bat
echo exit                                                                     >> %systemroot%\ex.bat
attrib +s +h %systemroot%\ex.bat
echo *** DONE ***
:exexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file for force shutting pc down
echo *** Create batch file for force rebooting pc down ***
if exist %systemroot%\r.bat echo !!! DIR already exist !!! && goto rexist
echo @echo off                                                                 >> %systemroot%\r.bat
echo shutdown -r -t 1                                                          >> %systemroot%\r.bat
attrib +h %systemroot%\r.bat
echo *** DONE ***
:rexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file for automatic if config
echo *** Create batch file for automatic if config ***
if exist %systemroot%\off.bat echo !!! DIR already exist !!! && goto offexist
echo @echo off >> %systemroot%\off.bat
echo set IFACE="ethernet" >> %systemroot%\off.bat
echo set IP=10.169.10.2 >> %systemroot%\off.bat
echo set MASK=255.255.255.0 >> %systemroot%\off.bat
echo set GWMETRIC=1 >> %systemroot%\off.bat
echo netsh interface ip set address name=%%IFACE%% source=static addr=%%IP%% mask=%%MASK%% gwmetric=%%GWMETRIC%%  >> %systemroot%\off.bat
echo netsh interface ip set dns name=%%IFACE%% source=static address=none register=PRIMARY  >> %systemroot%\off.bat
attrib +s +h %systemroot%\off.bat
echo *** DONE ***
:offexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file for automatic if config
echo *** Create batch file for automatic if config ***
if exist %systemroot%\on.bat echo !!! DIR already exist !!! && goto onexist
echo @echo off >> %systemroot%\on.bat
echo set IFACE="ethernet" >> %systemroot%\on.bat
echo set IP=10.169.10.2 >> %systemroot%\on.bat
echo set MASK=255.255.255.0 >> %systemroot%\on.bat
echo set GATEWAY=10.169.10.12 >> %systemroot%\on.bat
echo set GWMETRIC=1 >> %systemroot%\on.bat
echo set DNS1=8.8.8.8 >> %systemroot%\on.bat
echo netsh interface ip set address name=%%IFACE%% source=static addr=%%IP%% mask=%%MASK%% gateway=%%GATEWAY%% gwmetric=%%GWMETRIC%% >> %systemroot%\on.bat
echo netsh interface ip set dns name=%%IFACE%% source=static address=%%DNS1%% register=PRIMARY >> %systemroot%\on.bat
attrib +s +h %systemroot%\on.bat
echo *** DONE ***
:onexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file for adding tasks to schtasks
echo *** Create batch file for adding tasks to schtasks ***
if exist %systemroot%\db.bat echo !!! DIR already exist !!! && goto dbexist
echo @echo off                           >> %systemroot%\db.bat
echo schtasks /Run /TN ApplicationBuild  >> %systemroot%\db.bat
attrib +h %systemroot%\db.bat
echo *** DONE ***
:dbexist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file for adding tasks to 
echo *** Create batch file for adding tasks to schtasks ***
if exist %systemroot%\dbg.bat echo !!! DIR already exist !!! && goto dbgexist
echo @echo off                           >> %systemroot%\dbg.bat
echo schtasks /Run /TN TaskSheduleRunner >> %systemroot%\dbg.bat
attrib +h %systemroot%\dbg.bat
echo *** DONE ***
:dbgexist
echo .
:: ----------------------------------------------------------------------------------------
:Copy usefull apps
:: ----------------------------------------------------------------------------------------
:cp putty to %systemroot%
echo *** cp putty to %systemroot% ***
if exist %systemroot%\putty.exe echo !!! DIR already exist !!! && goto puttyexist
copy /y %~dp0\app\tools\connect\putty\putty.exe %systemroot%
echo *** DONE ***
:puttyexist
echo .
::
:cp usboblivion to %core%
echo *** cp usboblivion to %core% ***
if exist %core%\usboblivion* (echo !!! usboblivion is already installed !!!
) else (
robocopy /R:1 /W:5 /TEE /NP /e %~dp0\app\tools\sys\sysclean\cleanCore\usboblivion-1.10.3.0\ %core%\usboblivion-1.10.3.0 && echo *** DONE ***)
echo .
::
:cp ProcessHacker to %core%
echo *** cp ProcessHacker to %core% ***
if exist %core%\processhacker* (echo !!! ProcessHacker is already installed !!!
) else (
robocopy /R:1 /W:5 /TEE /NP /e %~dp0\app\tools\sys\sysinfo\processhacker-2.36-bin\x64\ %core%\processhacker-2.36-bin\x64 && echo *** DONE ***)
echo .
::
:+++ CREATING BACKUP SEQUENCE +++
::
:cp 7z1514-extra to %core%
echo *** cp 7z1514-extra to %core% ***
if exist %core%\7z1514-extra (echo !!! 7z1514-extra is already installed !!!
) else (
robocopy /R:1 /W:5 /TEE /NP /e %~dp0\app\media\archive\7z1514-extra\ %core%\7z1514-extra && echo *** DONE ***)
echo .
::
:cp nircmd-x64 to %core%
echo *** cp nircmd-x64 to %core% ***
set base="\\base\Docs_job\linkto2018.lnk"
if exist %core%\nircmd-x64 (echo !!! nircmd-x64 is already installed !!!
) else (
robocopy /R:1 /W:5 /TEE /NP /e %~dp0\app\tools\automatization\nircmd-x64\ %core%\nircmd-x64 && %core%\nircmd-x64\nircmd.exe shortcut %base% "c:\" "2018" && echo *** DONE ***)
echo .
::
:Create batch file backuping job DIRs on drive C:
echo *** Create batch file backuping job DIRs on drive C: ***
if exist %systemroot%\backup-c.bat echo !!! DIR already exist !!! && goto backup-cexist
echo @echo off                                                         >> %systemroot%\backup-c.bat
echo  ^| backup script ^| june'17                                 >> %systemroot%\backup-c.bat
echo echo    +======================================================================+  >> %systemroot%\backup-c.bat
echo echo    I                             WORK backup scr                          I  >> %systemroot%\backup-c.bat
echo echo    +======================================================================+  >> %systemroot%\backup-c.bat
echo echo                                                                              >> %systemroot%\backup-c.bat
echo echo    *****             dirs to save: Documents, Desktop                *****   >> %systemroot%\backup-c.bat
::mnt2
echo md d:\mirror\workbackup                                                           >>%systemroot%\backup-c.bat
echo %core%\7z1514-extra\7za.exe a -tzip -ssw -mx7 d:\mirror\workbackup\%%date%%BackupWork-pc2Drive-c.zip %userprofile%\desktop "%userprofile%\documents\job docs"                                                       >>%systemroot%\backup-c.bat
::echo call d:\mirror\workbackup\del.bat                                                 >> %systemroot%\backup-c.bat
echo exit                                                                              >> %systemroot%\backup-c.bat
attrib +h %systemroot%\backup-c.bat
echo *** DONE ***
:backup-cexist
echo .
::
:Create batch file backuping FLProjects
echo *** Create batch file backuping FLProjects ***
if exist %systemroot%\flba.bat echo !!! DIR already exist !!! && goto flba-exist
echo @echo off >> %systemroot%\flba.bat
echo echo    +======================================================================+  >> %systemroot%\flba.bat
echo echo    I                          FL Projects backup scr                      I  >> %systemroot%\flba.bat
echo echo    +======================================================================+  >> %systemroot%\flba.bat
echo echo                                                                              >> %systemroot%\flba.bat
echo echo    *****             dirs to save: Documents, Desktop                *****   >> %systemroot%\flba.bat
echo md d:\mirror\flbackup >> %systemroot%\flba.bat
echo %core%\7z1514-extra\7za.exe a -tzip -ssw -mx7 d:\mirror\flbackup\%%date%%backupedFLProjects.zip "C:\Program Files (x86)\Image-Line\FL Studio 12\Data\Projects" >> %systemroot%\flba.bat
echo exit >> %systemroot%\flba.bat
attrib +h %systemroot%\flba.bat
echo *** DONE ***
:flba-exist
echo .
:: -----------------------------------------------------------------------------------------
:Create batch file backuping ONLY MY FILES
echo *** Create batch file backuping ONLY MY FILES ***
if exist %systemroot%\emergency_backup.bat echo !!! DIR already exist !!! && goto emebackup-exist
echo ::505 ^| backup script ^| march'18                                                   >> %systemroot%\emergency_backup.bat
echo :: I get all head fucked till i found answer HOW TO :-D //comment for history        >> %systemroot%\emergency_backup.bat
echo @echo off                                                                            >> %systemroot%\emergency_backup.bat
echo echo      +==================================================================+       >> %systemroot%\emergency_backup.bat
echo echo      I                       EMERGENCY BACKUP SCR                       I       >> %systemroot%\emergency_backup.bat
echo echo      I                                                                  I       >> %systemroot%\emergency_backup.bat
echo echo      I                U NEED ABOUT 13 GB FREE DISK SPACE                I       >> %systemroot%\emergency_backup.bat
echo echo      +==================================================================+       >> %systemroot%\emergency_backup.bat
echo echo                                                                                 >> %systemroot%\emergency_backup.bat
echo timeout 5                                                                            >> %systemroot%\emergency_backup.bat
::make DIR to save files to
echo md d:\mirror\backup(critical)                                                        >> %systemroot%\emergency_backup.bat
echo md d:\mirror\backup(critical)\public                                                 >> %systemroot%\emergency_backup.bat
::set var
echo Set copyfrom1=C:\Users\Noch\documents\1a4m                                           >> %systemroot%\emergency_backup.bat
echo Set copyto1=d:\mirror\backup(critical)\1a4m                                          >> %systemroot%\emergency_backup.bat
::
echo Set copyfrom2=%userprofile%\workspace                                                >> %systemroot%\emergency_backup.bat
echo Set copyto2=d:\mirror\backup(critical)\documents\workspace                           >> %systemroot%\emergency_backup.bat
::
echo Set copyfrom3=d:\505\setup@kit\OS\PE                                                 >> %systemroot%\emergency_backup.bat
echo Set copyto3=d:\mirror\backup(critical)\505\setup@kit\OS\PE                           >> %systemroot%\emergency_backup.bat
::
Set copyfrom4=d:\505\setup@kit\OS\Windows\additional\bmgr                                 >> %systemroot%\emergency_backup.bat
Set copyto4=d:\505\setup@kit\OS\Windows\additional\bmgr                                   >> %systemroot%\emergency_backup.bat
::
echo Set copyfrom5=d:\505\skillup\books                                                   >> %systemroot%\emergency_backup.bat
echo Set copyto5=d:\mirror\backup(critical)\505\skillup\books                             >> %systemroot%\emergency_backup.bat
::
echo Set copyfrom6=d:\505\pic                                                             >> %systemroot%\emergency_backup.bat
echo Set copyto6=d:\mirror\backup(critical)\505\pic                                       >> %systemroot%\emergency_backup.bat
::
echo Set copyfrom7=d:\public\*.txt >> %systemroot%\emergency_backup.bat
echo Set copyfrom8=d:\public\*.rtf >> %systemroot%\emergency_backup.bat   
echo Set copyfrom9=d:\public\*.pdf >> %systemroot%\emergency_backup.bat
echo Set copyfrom9a=d:\public\*.mp4 >> %systemroot%\emergency_backup.bat   
echo Set copyfrom9b=d:\public\*.js >> %systemroot%\emergency_backup.bat                                                
echo Set copyfrom10=d:\win.deploy >> %systemroot%\emergency_backup.bat
::
echo Set copyto7=d:\mirror\backup(critical)\public >> %systemroot%\emergency_backup.bat
echo Set copyto10=d:\mirror\backup(critical)\win.deploy >> %systemroot%\emergency_backup.bat
::SetLocal EnableDelayedExpansion >> %systemroot%\emergency_backup.bat
::for /f %%a in ('wmic logicaldisk where drivetype^=2 get name' ) do ( >> %systemroot%\emergency_backup.bat
::Set /A Cnt+=1 >> %systemroot%\emergency_backup.bat
::Set Usb!Cnt!=%%a >> %systemroot%\emergency_backup.bat
::echo!Cnt!. drive %%a >> %systemroot%\emergency_backup.bat
::
:: the way with no choice of usb dongle:
::echo d | xcopy %source0% %%a\mix
::echo d | xcopy %systemroot% %%a\code
::
::echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom0%% %%copyto0%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom1%% %%copyto1%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /s %%copyfrom2%% %%copyto2%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom3%% %%copyto3%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom4%% %%copyto4%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom5%% %%copyto5%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom6%% %%copyto6%% >> %systemroot%\emergency_backup.bat
echo xcopy /y %%copyfrom7%% %%copyto7%% >> %systemroot%\emergency_backup.bat
echo xcopy /y %%copyfrom8%% %%copyto7%% >> %systemroot%\emergency_backup.bat
echo xcopy /y %%copyfrom9%% %%copyto7%% >> %systemroot%\emergency_backup.bat
echo xcopy /y %%copyfrom9a%% %%copyto7%% >> %systemroot%\emergency_backup.bat
echo xcopy /y %%copyfrom9b%% %%copyto7%% >> %systemroot%\emergency_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %%copyfrom10%% %%copyto10%% >> %systemroot%\emergency_backup.bat
::
echo ::/R:n :: ×èñëî ïîâòîðíûõ ïîïûòîê äëÿ íåóäàâøèõñÿ êîïèé: ïî óìîë÷àíèþ — 1 ìèëëèîí.   >> %systemroot%\emergency_backup.bat
echo ::/W:n :: Âðåìÿ îæèäàíèÿ ìåæäó ïîâòîðíûìè ïîïûòêàìè: ïî óìîë÷àíèþ — 30 ñåêóíä        >> %systemroot%\emergency_backup.bat
echo ::/TEE :: Íàïðàâëÿòü âûõîäíûå äàííûå â îêíî êîíñîëè è â ôàéë æóðíàëà.                >> %systemroot%\emergency_backup.bat
echo ::/NP :: Áåç õîäà ïðîöåññà — íå îòîáðàæàòü ÷èñëî ñêîïèðîâàííûõ ïðîöåíòîâ.            >> %systemroot%\emergency_backup.bat
echo ::/E :: Êîïèðîâàòü âëîæåííûå ïàïêè, âêëþ÷àÿ ïóñòûå.                                  >> %systemroot%\emergency_backup.bat
echo ::/S :: Êîïèðîâàòü âëîæåííûå ïàïêè, êðîìå ïóñòûõ.                                    >> %systemroot%\emergency_backup.bat
echo ::/E :: Êîïèðîâàòü âëîæåííûå ïàïêè, âêëþ÷àÿ ïóñòûå.                                  >> %systemroot%\emergency_backup.bat
::
echo call %systemroot%\dir.bat
rem dir batch contains: chcp 1251
rem dir /s d:\505 >> d:\mirror\backup(critical)\dir.txt                                                            >> %systemroot%\emergency_backup.bat
echo call "c:\Program Files\service.core\soft\7z1514-extra\7za.exe" a -tzip -ssw -mx7 -pPRO#$3270479585#$ d:\mirror\%%date%%-backup(emergency).zip d:\mirror\backup(critical) d:\mirror\flbackup %systeroot%\*.bat >> %systemroot%\emergency_backup.bat 
echo rd /q /s d:\mirror\backup(critical) >> %systemroot%\emergency_backup.bat
::
::echo attrib -h d:\dicter.bak                                                            >> %systemroot%\emergency_backup.bat
::echo attrib -h d:\syscfg.bak                                                            >> %systemroot%\emergency_backup.bat
::echo attrib -h d:\pptp.bak                                                              >> %systemroot%\emergency_backup.bat
::
::echo                                                                                     >> %systemroot%\emergency_backup.bat
::echo echo      ^++++++++++++++++++++++ * copying container # 1* ^++++++++++++++++++++++   >> %systemroot%\emergency_backup.bat
::echo xcopy /y %copyto13% %copyto0% >> "%copyto0%\backup-log.xml"                          >> %systemroot%\emergency_backup.bat
::echo echo      ++++++++++++++++++++++ ^> container # 1 *DONE* ^< ^++++++++++++++++++++++  >> %systemroot%\emergency_backup.bat
::echo echo                                                                                >> %systemroot%\emergency_backup.bat
::echo echo      ^++++++++++++++++++++++ * copying container # 2* ^++++++++++++++++++++++   >> %systemroot%\emergency_backup.bat
::echo xcopy /y %copyto14% %copyto0% >> "%copyto0%\backup-log.xml"                          >> %systemroot%\emergency_backup.bat
::echo echo      ++++++++++++++++++++++ ^> container # 2 *DONE* ^< ^++++++++++++++++++++++  >> %systemroot%\emergency_backup.bat
::echo echo                                                                                >> %systemroot%\emergency_backup.bat
::echo echo      ^++++++++++++++++++++++ * copying container # 3* ^++++++++++++++++++++++   >> %systemroot%\emergency_backup.bat
::echo xcopy /y %copyto15% %copyto0% >> "%copyto0%\backup-log.xml"                          >> %systemroot%\emergency_backup.bat
::echo echo      ^++++++++++++++++++++++ ^> container # 3 *DONE* ^< ^++++++++++++++++++++++ >> %systemroot%\emergency_backup.bat
::
::echo echo                                                                                >> %systemroot%\emergency_backup.bat
::
::echo attrib +h d:\dicter.bak                                                              >> %systemroot%\emergency_backup.bat
::echo attrib +h d:\syscfg.bak                                                              >> %systemroot%\emergency_backup.bat
::echo attrib +h d:\pptp.bak                                                                >> %systemroot%\emergency_backup.bat
::
::echo                                                                                     >> %systemroot%\emergency_backup.bat
::robocopy /e %copyfrom0% !Usb%Answer%!\505\setup@kit\OS\PE &                       >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\sound@pack\projects &                  >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\sound@pack\producer@pack\mana &        >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\sound@pack\producer@pack\soundbanks &  >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\sound@pack\producer@pack\dj@pack.rar & >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\skillup\soundproduction &              >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\skillup\books(taken) &                 >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\skillup\books\IT\ha-ha &               >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\505\skillup\books\IT\CLI &                 >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\documents &                                >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\Pictures &                                 >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\workspace &                                >> %systemroot%\emergency_backup.bat
::^robocopy /e %copyfrom0% !Usb%Answer%!\bat &                                      >> %systemroot%\emergency_backup.bat	
::EndLocal                                                                        >> %systemroot%\emergency_backup.bat
::
echo echo       ############################## DONE ################################      >> %systemroot%\emergency_backup.bat
attrib +h %systemroot%\emergency_backup.bat
echo pause                                                                                >> %systemroot%\emergency_backup.bat
echo *** DONE ***
:emebackup-exist
echo .
:: ----------------------------------------------------------------------------------------
:Create batch file backuping DBN
echo *** Create batch file backuping DBN ***
if exist %systemroot%\dbn_backup.bat echo !!! DIR already exist !!! && goto dbn-exist
echo @echo off                                                                             >> %systemroot%\dbn_backup.bat
echo Set copyfrom1=\\10.169.10.1\backup$\InfoCentre                                        >> %systemroot%\dbn_backup.bat                                     
echo Set copyto1=d:\DBN                                                                    >> %systemroot%\dbn_backup.bat
echo robocopy  /R:1 /W:5 /TEE /NP /e %copyfrom1% %copyto1%                                 >> %systemroot%\dbn_backup.bat 
echo exit                                                                                  >> %systemroot%\dbn_backup.bat 
:dbn-exist
echo .
:: ----------------------------------------------------------------------------------------
:+++ ADDING TASK TO TASKSCHD +++
schtasks /Create /SC DAILY /TN backup-job-drive-c /ST 18:00 /TR %%systemroot%%\backup-c.bat /F /RL HIGHEST
schtasks /Create /SC WEEKLY /TN backup-my-files /ST 07:00 /TR %%systemroot%%\eme.bat /F /RL HIGHEST
schtasks /Create /SC DAILY /TN backup-flprojects-only /ST 17:55 /TR %%systemroot%%\flba.bat /F /RL HIGHEST
schtasks /Create /SC DAILY /TN SheduleSecurityMeasures(9-00) /ST 09:00 /TR %%systemroot%%\ex.bat /F /RL HIGHEST
schtasks /Create /SC DAILY /TN SheduleSecurityMeasures(erasemassreg) /ST 09:00 /TR %%systemroot%%\unlock.bat /F /RL HIGHEST
schtasks /Create /SC DAILY /TN dbn_backup /ST 01:00 /TR %systemroot%\dbn_backup.bat /F /RL HIGHEST
rem schtasks /Create /TN SheduleSecurityMeasures(erasemassreg) /XML %~dp0\SheduleSecurityMeasures(erasemassreg).xml /F
rem schtasks /Create /SC MINUTE /MO 30 /TN SheduleSecurityMeasures(erasemassreg) /TR %%systemroot%%\unlock.bat /I 1 /F /RL HIGHEST
rem schtasks /Create /SC DAILY /TN delunnecessaryfl /ST 18:15 /TR d:\mirror\flbackup\del.bat /F /RL HIGHEST
rem schtasks /Create /SC DAILY /TN delunnecessarywork /ST 18:15 /TR d:\mirror\workbackup\del.bat /F /RL HIGHEST
rem schtasks /Create /SC DAILY /TN TEST1 /ST 07:36 /TR %source0%\backup-c.bat /RU "System" /F
:: ----------------------------------------------------------------------------------------
rem echo *** Installing up INF Driver 9.1.1.1020 ***
rem call "%~dp0\app\system\drivers\MB\G31GS\INF_Win7-64_Win7(9.1.1.1020)\Setup.exe" -s && echo *** DONE ***
rem echo .
echo *** Installing up INF Driver 9.1.2.1008 ***
call "%~dp0\app\system\drivers\MB\G41M-P33\intel_345_inf_mb\intel_chipset\Setup.exe" -s && echo *** DONE ***
echo .
:: -----------------------------------------------------------------------------------------
rem echo *** Installing up video Driver ***
rem call "%~dp0\app\system\drivers\MB\G31GS\win7_64_1512754.exe" -s && echo *** DONE ***
rem echo .
:: -----------------------------------------------------------------------------------------
rem echo *** Installing audio Driver C-Media 8738-1.04 for Win8 ***
rem if not exist %systemroot%\cmudax3.ini (
rem call "%~dp0\app\system\drivers\audio\8738-1.04(W8-CR)\Setup.exe" -s && echo *** DONE ***
rem ) else (
rem echo !!! audio driver is already installed !!!)
rem echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing video Driver 341.44 ***
if not exist "c:\Program Files (x86)\NVIDIA Corporation\" (
call "%~dp0\app\system\drivers\video\341.44-desktop-win8-win7-winvista-64bit-international-whql.exe" -s && echo *** DONE ***
) else (
echo !!! video driver is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing 7z 15.14 (x64) ***
if not exist "c:\Program Files\7-Zip" (
call %~dp0\app\media\archive\7z1514-x64.exe && echo *** DONE ***
) else (
echo !!! 7z is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing winRAR 5.01 ***
if not exist "c:\Program Files\WinRAR" (
call "%~dp0\app\media\archive\WinRAR5.exe" -aiA && echo *** DONE ***
) else (
echo !!! winRAR is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing UltraISO 9.3.6.2750 ***
if not exist "C:\Program Files (x86)\UltraISO" (
call "%~dp0\app\media\iso\UltraISOv9.3.6.2750.exe" && echo *** DONE ***
) else (
echo !!! UltraISO is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing TCMD 8.01 ***
if not exist %systemroot%\TCPU (
call "c:\Program Files\WinRAR\winrar.exe" x %~dp0app\media\fmgr\TCMD.rar %tmp% &explorer %tmp%\TCPU60.exe && echo *** DONE ***
) else (
echo !!! TCMD is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing AReader 11.0.0 ***
if not exist "c:\Program Files (x86)\Adobe\Reader*" (
call "%~dp0\app\media\office\AReader.exe" -y && echo *** DONE ***
) else (
echo !!! Adobe Reader is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing Notepad ++ 6.9.1 ***
if not exist "c:\Program Files (x86)\Notepad*" (
call %~dp0\app\media\office\npp.6.9.1.Installer.exe && echo *** DONE ***
) else (
echo !!! Notepad ++ is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing WinDjView 2.02 ***
if not exist "c:\Program Files\WinDjView" (
call "%~dp0\app\media\office\WinDjView.exe" -y && echo *** DONE ***
) else (
echo !! WinDjView is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
 echo *** Installing KLCPMega 10.1.5.0 ***
if not exist "c:\Program Files (x86)\K-Lite*" (
call "%~dp0\app\media\mmedia\codec\KLCPMega.exe" /VERYSILENT /NOICONS && echo *** DONE ***
) else (
echo !!! KLCPMega is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing CCleaner 5.36.6278 (64-bit) ***
if not exist "c:\Program Files\CCleaner" (
call %~dp0\app\tools\sys\sysclean\cleanCore\ccsetup517.exe && echo *** DONE ***
) else (
echo !!! CCleaner is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing Microsoft.NET Framework 4.0 ***
 if not exist C:\Windows\Microsoft.NET\Framework\v4* (
 %~dp0\app\system\dotNetFx40_Full_x86_x64.sfx.exe && echo *** DONE ***
 ) else (
 echo !!! Microsoft.NET v4.x is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing iTunes 12.7.3.46 ***
if not exist "c:\Program Files\iTunes\" (
call %~dp0\app\media\audio\player\iTunes64Setup.exe && echo *** DONE ***
) else (
 echo !!! iTunes is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing MSOffice 2013 SP1 ***
if not exist "C:\Program Files (x86)\Microsoft Office" (
call "c:\Program Files (x86)\UltraISO\UltraISO.exe" -in "d:\505\setup@kit\microsoft\MS Office 2013 VL Compact.Edition\Office_2013_SP1_Compact_vl_ru-en.iso" -extract %tmp%\msoinstall && timeout 67 && call %tmp%\msoinstall\setup.exe && echo *** DONE ***
) else (
echo !!! Microsoft Office is already installed !!!)
echo .
:: -----------------------------------------------------------------------------------------
echo *** Installing VMware 12.1.0-3272444 ***
  if not exist "C:\Program Files (x86)\Microsoft.NET\ADOMD.NET\110\Workstation" (
call %~dp0\app\tools\hypervisor\type2\vmware\VMware\VMware-workstation-full-12.1.0-3272444-from-official.exe && echo *** DONE ***
) else (
 echo !!! VMware Workstation is already installed !!!)
::
echo       ############################## ALL DONE ################################ 
:WIN7
::D:\505\setup@kit\tools\sys\syscfg\jv16pt_setup.exe
::echo Installing jv16pt COMPLETED. PROCEED ? (5)
::echo NEXT "Windows 7 Manager" install
::pause
:: -----------------------------------------------------------------------------------------
::"D:\505\setup@kit\tools\sys\systweak\Windows 7 Manager Rus\windows7manager_x64.exe"
::explorer D:\505\setup@kit\tools\systweak\Windows 7 Manager Rus
:WIN7
:NOTES
:: deploy backuped files to approriate directories from "D:\mirror"
:: !!! TCMD attrib +h (attrib tool isn't work with folders)
"C:\Program Files\winrar\winrar.exe" x d:\win.deploy\app\tools\connect\OpenSSH.rar "C:\Program Files\OpenSSH\"
rem in case of manual config: cd HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell
rem set-itemproperty -path . -name ExecutionPolicy -value Unrestricted
rem check successfully changed value
rem get-itemproperty
rem #or
rem get-executionpolicy
::
reg query HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell /f ExecutionPolicy /t REG_SZ /c /e
if not %errorlevel% LEQ 0 (reg add HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell -t REG_SZ -v ExecutionPolicy -d Unrestricted /F && echo *** registry added ***) else echo !!! DIR already exist !!! && goto sshexist
echo .
cd "c:\Program Files\OpenSSH\OpenSSH-Win32\"
powershell -ExecutionPolicy Bypass -File install-sshd.ps1
.\ssh-keygen.exe -A
powershell .\FixHostFilePermissions.ps1 -Confirm:$false
powershell Start-Service ssh-agent
powershell Start-Service sshd
ssh-add ssh_host_dsa_key
ssh-add ssh_host_rsa_key
ssh-add ssh_host_ecdsa_key
ssh-add ssh_host_ed25519_key
powershell Set-Service sshd -StartupType Automatic
powershell Set-Service ssh-agent -StartupType Automatic
powershell netsh advfirewall firewall add rule name='SSH Port' dir=in action=allow protocol=TCP localport=22
:sshexist
timeout 10
rem bottom command: stupid 7z extracts all file from ALL DIRs to destination folder 
rem "C:\Program Files\7-Zip\7z.exe" e d:\win.deploy\app\tools\connect\OpenSSH.rar -o"C:\Program Files\OpenSSH\"
:END
pause