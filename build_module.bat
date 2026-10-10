@echo off
setlocal
REM ============================================================
REM  SpotiDuck LSPosed Module - Build Script
REM  Requires: Java 11+  (java.exe must be in PATH)
REM            apksigner  (part of Android SDK build-tools, or
REM                        download from Android Studio SDK Manager)
REM  Output:   SpotiDuck-module-signed.apk
REM ============================================================

set SCRIPT_DIR=%~dp0
set DECODED_DIR=%SCRIPT_DIR%SpotiDuck-decoded
set TOOLS_DIR=%SCRIPT_DIR%tools
set APKTOOL=%TOOLS_DIR%\apktool.jar
set OUTPUT_DIR=%SCRIPT_DIR%output

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo [1/4] Rebuilding APK with apktool...
java -jar "%APKTOOL%" b "%DECODED_DIR%" -o "%OUTPUT_DIR%\SpotiDuck-module-unsigned.apk"
if errorlevel 1 (
    echo ERROR: apktool build failed. Check smali syntax above.
    exit /b 1
)

echo.
echo [2/4] Generating a debug signing key (first run only)...
set KEYSTORE=%TOOLS_DIR%\debug.keystore
if not exist "%KEYSTORE%" (
    keytool -genkeypair -v -keystore "%KEYSTORE%" ^
        -alias androiddebugkey ^
        -keyalg RSA -keysize 2048 -validity 10000 ^
        -storepass android -keypass android ^
        -dname "CN=Android Debug,O=Android,C=US"
    if errorlevel 1 (
        echo ERROR: keytool failed. Make sure Java JDK is installed.
        exit /b 1
    )
)

echo.
echo [3/4] Aligning APK...
REM Try to find zipalign in common SDK locations
set ZIPALIGN=
for /f "delims=" %%i in ('where zipalign 2^>nul') do set ZIPALIGN=%%i
if "%ZIPALIGN%"=="" (
    echo WARNING: zipalign not found in PATH - skipping alignment step.
    echo          Install Android SDK build-tools and add to PATH for optimal results.
    copy "%OUTPUT_DIR%\SpotiDuck-module-unsigned.apk" "%OUTPUT_DIR%\SpotiDuck-module-aligned.apk" >nul
) else (
    "%ZIPALIGN%" -v 4 "%OUTPUT_DIR%\SpotiDuck-module-unsigned.apk" "%OUTPUT_DIR%\SpotiDuck-module-aligned.apk"
)

echo.
echo [4/4] Signing APK...
REM Try to find apksigner
set APKSIGNER=
for /f "delims=" %%i in ('where apksigner 2^>nul') do set APKSIGNER=%%i
if "%APKSIGNER%"=="" (
    echo ERROR: apksigner not found in PATH.
    echo        Install Android SDK build-tools:
    echo        https://developer.android.com/studio (SDK Manager -^> SDK Tools -^> Build-Tools)
    echo        Then add  %LOCALAPPDATA%\Android\Sdk\build-tools\<version>  to your PATH.
    exit /b 1
)

"%APKSIGNER%" sign ^
    --ks "%KEYSTORE%" ^
    --ks-pass pass:android ^
    --key-pass pass:android ^
    --ks-key-alias androiddebugkey ^
    --out "%OUTPUT_DIR%\SpotiDuck-module-signed.apk" ^
    "%OUTPUT_DIR%\SpotiDuck-module-aligned.apk"

if errorlevel 1 (
    echo ERROR: Signing failed.
    exit /b 1
)

echo.
echo ============================================================
echo  BUILD SUCCESSFUL
echo  Output: %OUTPUT_DIR%\SpotiDuck-module-signed.apk
echo ============================================================
echo.
echo INSTALL: adb install -r "%OUTPUT_DIR%\SpotiDuck-module-signed.apk"
echo.
echo NEXT STEPS:
echo  1. Install the APK (replaces existing SpotiDuck if you had it).
echo  2. Open LSPosed / LSPatch / NPatch manager.
echo  3. Enable this module for "Spotify" (com.spotify.music).
echo  4. Open SpotiDuck from the launcher.
echo  5. Tap "Enable Module (Log In)" button.
echo  6. Force-stop and restart Spotify.
echo  7. You should see a toast: "SpotiDuck: Loaded v"
echo.
endlocal
