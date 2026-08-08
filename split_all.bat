@echo off
cd /d "%~dp0"
setlocal

set MISSING=0
call :check SCUS_944.26
call :check 221_EndRaceMenu_CrystalChallenge.bin
call :check 222_EndRaceMenu_ArcadeAdventure.bin
call :check 223_EndRaceMenu_Relic.bin
call :check 224_EndRaceMenu_TimeTrial.bin
call :check 225_EndRaceMenu_BattleVS.bin
call :check 226_Quadblock_1P.bin
call :check 227_Quadblock_2P.bin
call :check 228_Quadblock_3P.bin
call :check 229_Quadblock_4P.bin
call :check 230_Threads_MainMenu.bin
call :check 231_Threads_Racing.bin
call :check 232_Threads_AdvHub.bin
call :check 233_Threads_Cutscene.bin

if not "%MISSING%"=="0" goto :missing

echo Extracting 14 binaries into "split\" ...
echo.

set FAILED=0
call :split executable_cfg  "SCUS_944.26 (PSX-EXE)"
call :split 221_cfg         "221 EndRaceMenu - Crystal Challenge"
call :split 222_cfg         "222 EndRaceMenu - Arcade / Adventure"
call :split 223_cfg         "223 EndRaceMenu - Relic"
call :split 224_cfg         "224 EndRaceMenu - Time Trial"
call :split 225_cfg         "225 EndRaceMenu - Battle / VS"
call :split 226_cfg         "226 Quadblock - 1P"
call :split 227_cfg         "227 Quadblock - 2P"
call :split 228_cfg         "228 Quadblock - 3P"
call :split 229_cfg         "229 Quadblock - 4P"
call :split 230_cfg         "230 Threads - Main Menu"
call :split 231_cfg         "231 Threads - Racing"
call :split 232_cfg         "232 Threads - Adventure Hub"
call :split 233_cfg         "233 Threads - Cutscene"

echo.
if not "%FAILED%"=="0" (
    echo Finished with %FAILED% failure^(s^). See the messages above.
) else (
    echo Done. All 14 binaries were extracted successfully.
)
echo.
pause
exit /b 0


:missing
echo.
echo ==========================================================
echo   ERROR: %MISSING% required binary file^(s^) not found
echo ==========================================================
echo.
echo Paste the game binaries into this folder:
echo.
echo   %~dp0
echo.
echo The file names must match EXACTLY:
echo.
echo   SCUS_944.26                            (the PSX-EXE)
echo   221_EndRaceMenu_CrystalChallenge.bin
echo   222_EndRaceMenu_ArcadeAdventure.bin
echo   223_EndRaceMenu_Relic.bin
echo   224_EndRaceMenu_TimeTrial.bin
echo   225_EndRaceMenu_BattleVS.bin
echo   226_Quadblock_1P.bin
echo   227_Quadblock_2P.bin
echo   228_Quadblock_3P.bin
echo   229_Quadblock_4P.bin
echo   230_Threads_MainMenu.bin
echo   231_Threads_Racing.bin
echo   232_Threads_AdvHub.bin
echo   233_Threads_Cutscene.bin
echo.
echo Nothing was extracted. Run this script again once the files are in place.
echo.
pause
exit /b 1


:check
if not exist "%~1" (
    echo   MISSING: %~1
    set /a MISSING+=1
)
goto :eof

:split
echo  -^> %~2
splat split "yaml\%~1.yaml" >nul
if errorlevel 1 (
    echo     FAILED: yaml\%~1.yaml
    set /a FAILED+=1
)
goto :eof
