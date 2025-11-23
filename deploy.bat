@echo off
set BUILD_DIR=build_test
set WEBAPP_DIR=webapps
set WAR_NAME=test.war
set TOMCAT_WEBAPPS_DIR="C:\Users\rmita\Documents\Riana\Utils\apache-tomcat-10.1.28\webapps"
set SRC_DIR=src
set LIB_DIR="webapps\WEB-INF\lib"
set CLASSES_DIR=%BUILD_DIR%\WEB-INF\classes

echo ======================================
echo Déploiement de l'application Test
echo ======================================

:: Nettoyage
if exist %BUILD_DIR% (
    rmdir /s /q %BUILD_DIR%
)

:: Création des dossiers
mkdir %BUILD_DIR%
mkdir %CLASSES_DIR%

echo Étape 1: Compilation des fichiers Java...

:: Vérifier si le dossier src existe
if not exist "%SRC_DIR%" (
    echo ERREUR: Le dossier %SRC_DIR% n'existe pas!
    pause
    exit /b 1
)

:: Trouver tous les fichiers Java et les compiler
dir /s /b "%SRC_DIR%\*.java" > java_files.txt

if %errorlevel% neq 0 (
    echo ERREUR: Aucun fichier Java trouvé dans %SRC_DIR%!
    pause
    exit /b 1
)

:: Vérifier si des fichiers Java ont été trouvés
for /f %%i in ('type java_files.txt ^| find /c /v ""') do set FILE_COUNT=%%i
if %FILE_COUNT% equ 0 (
    echo ERREUR: Aucun fichier Java trouvé dans %SRC_DIR%!
    del java_files.txt
    pause
    exit /b 1
)

echo Compilation de %FILE_COUNT% fichier(s) Java...

:: Préparer le classpath avec les librairies
set CLASSPATH=%CLASSES_DIR%

:: Ajouter les JARs du dossier lib au classpath
if exist "%LIB_DIR%" (
    for %%f in ("%LIB_DIR%\*.jar") do (
        set CLASSPATH=!CLASSPATH!;%%f
    )
)

:: Ajouter les JARs de Tomcat au classpath (nécessaires pour Servlet API)
set CLASSPATH=%CLASSPATH%;%TOMCAT_WEBAPPS_DIR%\..\lib\servlet-api.jar

:: Compiler les fichiers Java
javac -parameters -cp "%CLASSPATH%" -d "%CLASSES_DIR%" @java_files.txt

if %errorlevel% neq 0 (
    echo ERREUR: La compilation a échoué!
    del java_files.txt
    pause
    exit /b 1
)

del java_files.txt
echo ✓ Compilation terminée avec succès!

echo.
echo Étape 2: Copie des ressources web...

:: Copie des fichiers webapp
xcopy %WEBAPP_DIR%\* %BUILD_DIR% /e /i /y

:: Copier les librairies vers WEB-INF/lib
if exist "%LIB_DIR%" (
    if not exist "%BUILD_DIR%\WEB-INF\lib" mkdir "%BUILD_DIR%\WEB-INF\lib"
    xcopy "%LIB_DIR%\*.jar" "%BUILD_DIR%\WEB-INF\lib\" /y
)

echo ✓ Ressources web copiées!

echo.
echo Étape 3: Création du fichier WAR...

:: Création du WAR
cd %BUILD_DIR%
jar -cvf %WAR_NAME% * > ..\war_creation.log
cd ..

if %errorlevel% neq 0 (
    echo ERREUR: La création du WAR a échoué!
    pause
    exit /b 1
)

echo ✓ Fichier WAR créé: %WAR_NAME%

echo.
echo Étape 4: Déploiement dans Tomcat...

:: Arrêter Tomcat si nécessaire (optionnel)
:: echo Arrêt de Tomcat...
:: call %TOMCAT_WEBAPPS_DIR%\..\bin\shutdown.bat
:: timeout /t 3

:: Déploiement dans Tomcat
copy %BUILD_DIR%\%WAR_NAME% %TOMCAT_WEBAPPS_DIR%

if %errorlevel% neq 0 (
    echo ERREUR: Le déploiement a échoué!
    pause
    exit /b 1
)

echo ✓ Déployé dans: %TOMCAT_WEBAPPS_DIR%

:: Démarrage de Tomcat (optionnel)
:: echo Démarrage de Tomcat...
:: call %TOMCAT_WEBAPPS_DIR%\..\bin\startup.bat

echo.
echo ======================================
echo DÉPLOIEMENT TERMINÉ AVEC SUCCÈS!
echo ======================================
echo.
echo Accédez à : http://localhost:8080/test/
echo.
echo Fichiers compilés: %CLASSES_DIR%
echo Fichier WAR: %BUILD_DIR%\%WAR_NAME%
echo.
pause