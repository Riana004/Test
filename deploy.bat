@echo off
set BUILD_DIR=build_test
set WEBAPP_DIR=webapps
set WAR_NAME=test.war
set TOMCAT_WEBAPPS_DIR="C:\Users\rmita\Documents\Riana\Utils\apache-tomcat-10.1.28\webapps"

echo ======================================
echo Déploiement de l'application Test
echo ======================================

:: Nettoyage
if exist %BUILD_DIR% (
    rmdir /s /q %BUILD_DIR%
)

:: Création du dossier build
mkdir %BUILD_DIR%

:: Copie des fichiers webapp
xcopy %WEBAPP_DIR% %BUILD_DIR% /e /i

:: Création du WAR
cd %BUILD_DIR%
jar -cvf %WAR_NAME% *
cd ..

:: Déploiement dans Tomcat
copy %BUILD_DIR%\%WAR_NAME% %TOMCAT_WEBAPPS_DIR%

echo ======================================
echo Déploiement terminé !
echo Accédez à : http://localhost:8080/test/hello
pause
