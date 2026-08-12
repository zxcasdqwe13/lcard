rem šà¥ªâ®àšï €®«Š­  ¡ëâì ®¡ï§ â¥«ì­® \ADI_DSP\21XX
rem  è Autoexec.bat ®¡ï§ â¥«ì­® €®«Š¥­ á®€¥àŠ âì 
rem á«¥€ãîéš¥ ®¡êï¢«¥­šï

Set ADII=C:\ADI_DSP\21XX\INCLUDE
Set ADIL=C:\ADI_DSP\21XX\LIB
Set ADIRTH=C:\ADI_DSP\LIB
Set ADI_DSP=C:\ADI_DSP

PATH=C:\ADI_DSP\21XX\BIN;



@ECHO OFF

rem Building architecture file

rem compiling internal memory segment
asm21 inttable -2181
asm21 e440 -2181
if errorlevel==1 goto ERROR

rem linking all in exe file
ld21 inttable e440  -a e440 -g -e e440 -l
if errorlevel==1 goto ERROR

rem creating .bio file
bin3pci e440.exe
if errorlevel==1 goto ERROR

rem copying file
rem copy e440.bio ..\..\test\*.*
rem copy e440.bio ..\..\test1\*.*
rem copy e440.bio ..\..\test2\*.*
rem copy e440.bio ..\..\dll\*.*
rem copy e440.bio ..\..\e440test\*.*

if exist *.cde del *.cde
if exist *.int del *.int
if exist *.bak del *.bak
if exist *.obj del *.obj
if exist e440.sym del e440.sym
if exist inttable.sym del inttable.sym
if exist e440.exe del e440.exe
if exist inttable.exe del inttable.exe

ECHO -
ECHO #####################################################################
ECHO   	      S U C C E S S ! ! !   ©« E440.bio áä®à¬šà®¢ ­
ECHO #####################################################################






ECHO -
goto END

:ERROR
ECHO -
ECHO #####################################################################
ECHO          E R R O R ! ! !  èš¡ª  ä®à¬šà®¢ ­šï ä ©«  E440.bio
ECHO #####################################################################
ECHO - 

:END

rem copy e440.BIO C:
rem exit



