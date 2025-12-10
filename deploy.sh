#!/bin/bash
# ======================================
# Déploiement de l'application Test
# ======================================

# Configuration des variables
BUILD_DIR="build_test"
WEBAPP_DIR="webapps"
WAR_NAME="test.war"
TOMCAT_WEBAPPS_DIR="/opt/apache-tomcat-10.1.28/webapps"
SRC_DIR="src"
LIB_DIR="webapps/WEB-INF/lib"
CLASSES_DIR="$BUILD_DIR/WEB-INF/classes"

echo "======================================"
echo "Déploiement de l'application Test"
echo "======================================"

# Nettoyage
if [ -d "$BUILD_DIR" ]; then
    echo "Nettoyage de l'ancien build..."
    rm -rf "$BUILD_DIR"
fi

# Création des dossiers
mkdir -p "$BUILD_DIR"
mkdir -p "$CLASSES_DIR"

echo "Étape 1: Compilation des fichiers Java..."

# Vérifier si le dossier src existe
if [ ! -d "$SRC_DIR" ]; then
    echo "ERREUR: Le dossier $SRC_DIR n'existe pas!"
    read -p "Appuyez sur Entrée pour quitter..."
    exit 1
fi

# Trouver tous les fichiers Java
java_files=($(find "$SRC_DIR" -name "*.java"))
FILE_COUNT=${#java_files[@]}

if [ $FILE_COUNT -eq 0 ]; then
    echo "ERREUR: Aucun fichier Java trouvé dans $SRC_DIR!"
    read -p "Appuyez sur Entrée pour quitter..."
    exit 1
fi

echo "Compilation de $FILE_COUNT fichier(s) Java..."

# Préparer le classpath
CLASSPATH="$CLASSES_DIR"

# Ajouter les JARs du dossier lib au classpath
if [ -d "$LIB_DIR" ]; then
    for jar in "$LIB_DIR"/*.jar; do
        if [ -f "$jar" ]; then
            CLASSPATH="$CLASSPATH:$jar"
        fi
    done
fi

# Ajouter les JARs de Tomcat au classpath
if [ -d "/opt/apache-tomcat-10.1.28/lib" ]; then
    # Chercher servlet-api.jar
    servlet_jar=$(find "/opt/apache-tomcat-10.1.28/lib" -name "*servlet*.jar" | head -1)
    if [ -n "$servlet_jar" ]; then
        CLASSPATH="$CLASSPATH:$servlet_jar"
    else
        echo "ATTENTION: servlet-api.jar non trouvé dans Tomcat lib"
    fi
fi

echo "Classpath: $CLASSPATH"

# Compiler les fichiers Java
javac -parameters -cp "$CLASSPATH" -d "$CLASSES_DIR" "${java_files[@]}"

if [ $? -ne 0 ]; then
    echo "ERREUR: La compilation a échoué!"
    read -p "Appuyez sur Entrée pour quitter..."
    exit 1
fi

echo "✓ Compilation terminée avec succès!"

echo ""
echo "Étape 2: Copie des ressources web..."

# Copie des fichiers webapp
if [ -d "$WEBAPP_DIR" ]; then
    cp -r "$WEBAPP_DIR"/* "$BUILD_DIR"/
else
    echo "ATTENTION: Dossier $WEBAPP_DIR non trouvé"
fi

# Copier les librairies vers WEB-INF/lib
if [ -d "$LIB_DIR" ]; then
    mkdir -p "$BUILD_DIR/WEB-INF/lib"
    cp "$LIB_DIR"/*.jar "$BUILD_DIR/WEB-INF/lib/" 2>/dev/null || true
fi

echo "✓ Ressources web copiées!"

echo ""
echo "Étape 3: Création du fichier WAR..."

# Création du WAR
cd "$BUILD_DIR" || exit
jar -cvf "$WAR_NAME" ./* > ../war_creation.log
cd ..

if [ $? -ne 0 ]; then
    echo "ERREUR: La création du WAR a échoué!"
    read -p "Appuyez sur Entrée pour quitter..."
    exit 1
fi

echo "✓ Fichier WAR créé: $WAR_NAME"

echo ""
echo "Étape 4: Déploiement dans Tomcat..."

# Vérifier si Tomcat est installé
if [ ! -d "$TOMCAT_WEBAPPS_DIR" ]; then
    echo "ATTENTION: Dossier Tomcat non trouvé: $TOMCAT_WEBAPPS_DIR"
    echo "Installation de Tomcat recommandée:"
    echo "  sudo pacman -S tomcat10"
    echo "Ou téléchargez depuis: https://tomcat.apache.org/"
    read -p "Continuer malgré tout ? (o/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Oo]$ ]]; then
        exit 1
    fi
    mkdir -p "$TOMCAT_WEBAPPS_DIR"
fi

# Arrêter Tomcat si nécessaire (optionnel)
# echo "Arrêt de Tomcat..."
# sudo systemctl stop tomcat10
# sleep 3

# Déploiement dans Tomcat
cp "$BUILD_DIR/$WAR_NAME" "$TOMCAT_WEBAPPS_DIR/"

if [ $? -ne 0 ]; then
    echo "ERREUR: Le déploiement a échoué!"
    read -p "Appuyez sur Entrée pour quitter..."
    exit 1
fi

echo "✓ Déployé dans: $TOMCAT_WEBAPPS_DIR"

# Démarrage de Tomcat (optionnel)
# echo "Démarrage de Tomcat..."
# sudo systemctl start tomcat10

echo ""
echo "======================================"
echo "DÉPLOIEMENT TERMINÉ AVEC SUCCÈS!"
echo "======================================"
echo ""
echo "Accédez à : http://localhost:8080/test/"
echo ""
echo "Fichiers compilés: $CLASSES_DIR"
echo "Fichier WAR: $BUILD_DIR/$WAR_NAME"
echo "Log de création: war_creation.log"
echo ""
read -p "Appuyez sur Entrée pour continuer..."