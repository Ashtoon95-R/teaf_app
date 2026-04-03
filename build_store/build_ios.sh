#!/bin/bash

# Script para construir la app iOS en macOS
# Uso: 
#   ./build_ios.sh                                      # Lee version de pubspec.yaml
#   ./build_ios.sh --build-name 2.0.8 --build-number 22  # Version personalizada

set -e  # Salir si hay algún error

# Parametros opcionales
CUSTOM_BUILD_NAME=""
CUSTOM_BUILD_NUMBER=""

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --build-name)
            CUSTOM_BUILD_NAME="$2"
            shift 2
            ;;
        --build-number)
            CUSTOM_BUILD_NUMBER="$2"
            shift 2
            ;;
        *)
            echo "Parametro desconocido: $1"
            echo "Uso: ./build_ios.sh [--build-name VERSION] [--build-number BUILD]"
            exit 1
            ;;
    esac
done

echo "Iniciando build de iOS para Teaf App"
echo "===================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: No se encontro pubspec.yaml. Asegurate de estar en el directorio del proyecto Flutter.${NC}"
    exit 1
fi

# Verificar Flutter
echo -e "${YELLOW}Verificando Flutter...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter no esta instalado o no esta en el PATH${NC}"
    exit 1
fi

# Verificar versión
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo -e "${GREEN}Flutter encontrado: $FLUTTER_VERSION${NC}"

# Determinar version a usar
if [ -n "$CUSTOM_BUILD_NAME" ] && [ -n "$CUSTOM_BUILD_NUMBER" ]; then
    # Usar version personalizada
    APP_VERSION="$CUSTOM_BUILD_NAME"
    BUILD_NUMBER="$CUSTOM_BUILD_NUMBER"
    echo -e "${CYAN}Usando version personalizada: $APP_VERSION (Build $BUILD_NUMBER)${NC}"
else
    # Leer versión de la app desde pubspec.yaml (portable: [[:space:]] para macOS/BSD sed)
    if [ -f "pubspec.yaml" ]; then
        APP_VERSION=$(grep -E "^version:" pubspec.yaml | sed -nE "s/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+).*/\1/p")
        BUILD_NUMBER=$(grep -E "^version:" pubspec.yaml | sed -nE "s/^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+([0-9]+).*/\1/p")
        
        if [ -z "$APP_VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
             echo -e "${RED}Error: No se pudo leer la version o el build number de pubspec.yaml${NC}"
             exit 1
        fi
        
        echo -e "${GREEN}Version de la App a compilar: $APP_VERSION (Build $BUILD_NUMBER)${NC}"
    else
        echo -e "${RED}Error: No se encontro pubspec.yaml${NC}"
        exit 1
    fi
fi
echo ""

# Limpiar proyecto
echo -e "${YELLOW}🧹 Limpiando proyecto...${NC}"
flutter clean
echo -e "${GREEN}✅ Limpieza completada${NC}"
echo ""

# Obtener dependencias
echo -e "${YELLOW}📦 Obteniendo dependencias de Flutter...${NC}"
flutter pub get
echo -e "${GREEN}✅ Dependencias obtenidas${NC}"
echo ""

# CRÍTICO: Modificar el podspec del plugin ANTES de pod install
# Esto debe hacerse DESPUÉS de flutter pub get (que genera .symlinks)
echo -e "${YELLOW}🔧 Modificando podspec de facebook_app_events para compatibilidad...${NC}"

# Buscar el podspec en diferentes ubicaciones posibles
PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"
PODSPEC_PATHS=(
    ".symlinks/plugins/facebook_app_events/ios/facebook_app_events.podspec"
    "$PUB_CACHE/hosted/pub.dev/facebook_app_events-0.19.7/ios/facebook_app_events.podspec"
    "$PUB_CACHE/hosted/pub.dev/facebook_app_events-0.19.5/ios/facebook_app_events.podspec"
)

# Buscar cualquier versión del plugin en el cache
if [ -d "$PUB_CACHE/hosted/pub.dev" ]; then
    for plugin_dir in "$PUB_CACHE/hosted/pub.dev"/facebook_app_events-*; do
        if [ -d "$plugin_dir" ]; then
            PODSPEC_PATHS+=("$plugin_dir/ios/facebook_app_events.podspec")
        fi
    done
fi

PODSPEC_FOUND=""
for PODSPEC_PATH in "${PODSPEC_PATHS[@]}"; do
    if [ -f "$PODSPEC_PATH" ]; then
        PODSPEC_FOUND="$PODSPEC_PATH"
        echo -e "${GREEN}   ✅ Podspec encontrado en: $PODSPEC_PATH${NC}"
        
        # Hacer backup del podspec original
        cp "$PODSPEC_PATH" "${PODSPEC_PATH}.backup" 2>/dev/null || true
        
        # Modificar el podspec para aceptar SDK 16.3 en lugar de 18.0
        # Usar múltiples patrones para asegurar que funcione
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS - usar sed con extensión vacía
            sed -i '' "s/'FBSDKCoreKit', '~> 18/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/'FBSDKCoreKit', '~> 18\.0/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/\"FBSDKCoreKit\", \"~> 18/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/\"FBSDKCoreKit\", \"~> 18\.0/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/FBSDKCoreKit.*~> 18/FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
        else
            # Linux
            sed -i "s/'FBSDKCoreKit', '~> 18/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i "s/'FBSDKCoreKit', '~> 18\.0/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i "s/\"FBSDKCoreKit\", \"~> 18/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
        fi
        
        # Verificar que se modificó
        if grep -q "FBSDKCoreKit.*~> 16.3" "$PODSPEC_PATH" || ! grep -q "FBSDKCoreKit.*~> 18" "$PODSPEC_PATH"; then
            echo -e "${GREEN}   ✅ Podspec modificado para usar FBSDKCoreKit ~> 16.3${NC}"
        else
            echo -e "${YELLOW}   ⚠️  Podspec no se modificó correctamente, el hook pre_install lo intentará${NC}"
        fi
        break
    fi
done

if [ -z "$PODSPEC_FOUND" ]; then
    echo -e "${YELLOW}   ⚠️  Podspec no encontrado, el hook pre_install lo buscará en el cache de pub${NC}"
fi
echo ""

# Verificar CocoaPods
echo -e "${YELLOW}📋 Verificando CocoaPods...${NC}"
if ! command -v pod &> /dev/null; then
    echo -e "${RED}❌ Error: CocoaPods no está instalado${NC}"
    echo -e "${YELLOW}💡 Instala CocoaPods con: sudo gem install cocoapods${NC}"
    exit 1
fi

POD_VERSION=$(pod --version)
echo -e "${GREEN}✅ CocoaPods encontrado: v$POD_VERSION${NC}"
echo ""

# Instalar/Actualizar pods
echo -e "${YELLOW}📦 Instalando/Actualizando pods de iOS...${NC}"
cd ios

# Limpiar pods anteriores (IMPORTANTE para aplicar cambios del Podfile)
echo -e "${YELLOW}   Limpiando pods anteriores...${NC}"
rm -rf Pods Podfile.lock

# CRÍTICO: Buscar y modificar el podspec desde el directorio ios
echo -e "${YELLOW}   Buscando podspec de facebook_app_events...${NC}"
PODSPEC_PATHS=(
    "../.symlinks/plugins/facebook_app_events/ios/facebook_app_events.podspec"
    "../../.symlinks/plugins/facebook_app_events/ios/facebook_app_events.podspec"
    "$HOME/.pub-cache/hosted/pub.dev/facebook_app_events-0.19.7/ios/facebook_app_events.podspec"
)

PODSPEC_MODIFIED=false
for PODSPEC_PATH in "${PODSPEC_PATHS[@]}"; do
    if [ -f "$PODSPEC_PATH" ]; then
        echo -e "${GREEN}   ✅ Podspec encontrado: $PODSPEC_PATH${NC}"
        
        # Hacer backup
        cp "$PODSPEC_PATH" "${PODSPEC_PATH}.backup" 2>/dev/null || true
        
        # Modificar el podspec - múltiples patrones para asegurar que funcione
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/'FBSDKCoreKit', '~> 18/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/'FBSDKCoreKit', '~> 18\.0/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/\"FBSDKCoreKit\", \"~> 18/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/\"FBSDKCoreKit\", \"~> 18\.0/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
            sed -i '' "s/FBSDKCoreKit.*~> 18/FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
        else
            # Linux
            sed -i "s/'FBSDKCoreKit', '~> 18/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i "s/'FBSDKCoreKit', '~> 18\.0/'FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH"
            sed -i "s/\"FBSDKCoreKit\", \"~> 18/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
            sed -i "s/\"FBSDKCoreKit\", \"~> 18\.0/\"FBSDKCoreKit\", \"~> 16.3/g" "$PODSPEC_PATH"
        fi
        
        # Verificar que se modificó
        if grep -q "FBSDKCoreKit.*~> 16.3" "$PODSPEC_PATH"; then
            echo -e "${GREEN}   ✅ Podspec modificado correctamente${NC}"
            PODSPEC_MODIFIED=true
        else
            echo -e "${YELLOW}   ⚠️  Podspec no se modificó, intentando método alternativo...${NC}"
            # Método alternativo: reemplazo directo con perl o python
            perl -i -pe "s/FBSDKCoreKit.*~> 18[^']*/FBSDKCoreKit', '~> 16.3/g" "$PODSPEC_PATH" 2>/dev/null || \
            python3 -c "import re; content=open('$PODSPEC_PATH').read(); content=re.sub(r\"FBSDKCoreKit.*~> 18[^']*\", \"FBSDKCoreKit', '~> 16.3\", content); open('$PODSPEC_PATH', 'w').write(content)" 2>/dev/null
        fi
        break
    fi
done

if [ "$PODSPEC_MODIFIED" = false ]; then
    echo -e "${YELLOW}   ⚠️  Podspec no encontrado, el hook pre_install intentará modificarlo${NC}"
fi

# Limpiar cache de CocoaPods para asegurar versiones correctas
echo -e "${YELLOW}   Limpiando cache de CocoaPods...${NC}"
pod cache clean --all 2>/dev/null || true

# Actualizar repositorios de CocoaPods
echo -e "${YELLOW}   Actualizando repositorios de CocoaPods...${NC}"
pod repo update

# Instalar pods con SDK de Facebook ~> 16.3 (compatible con facebook_app_events)
echo -e "${YELLOW}   Instalando pods con SDK de Facebook ~> 16.3 (compatible con facebook_app_events)...${NC}"
if pod install; then
    echo -e "${GREEN}✅ Pods instalados correctamente${NC}"
else
    echo -e "${RED}❌ Error al instalar pods${NC}"
    echo -e "${YELLOW}💡 Verifica el Podfile y los logs de error arriba${NC}"
    exit 1
fi
cd ..
echo ""

# Verificar configuración
echo -e "${YELLOW}🔍 Verificando configuración de iOS...${NC}"
flutter doctor -v | grep -i ios || true
echo ""

# Preguntar tipo de build
echo -e "${YELLOW}¿Qué tipo de build deseas crear?${NC}"
echo "1) IPA para App Store (recomendado)"
echo "2) APP sin código firmado"
echo "3) APP con código firmado"
read -p "Selecciona una opción (1-3): " BUILD_TYPE

case $BUILD_TYPE in
    1)
        echo -e "${YELLOW}🏗️  Construyendo IPA para App Store (Versión: $APP_VERSION+$BUILD_NUMBER)...${NC}"
        flutter build ipa --release --build-name=$APP_VERSION --build-number=$BUILD_NUMBER
        IPA_DIR="build/ios/ipa"
        IPA_FILE=$(find "$IPA_DIR" -maxdepth 1 -name "*.ipa" -print -quit 2>/dev/null)
        if [ -n "$IPA_FILE" ] && [ -f "$IPA_FILE" ]; then
            IPA_SIZE=$(du -h "$IPA_FILE" | cut -f1)
            echo ""
            echo -e "${GREEN}✅ Build completado exitosamente!${NC}"
            echo -e "${GREEN}📦 Archivo IPA: $IPA_FILE${NC}"
            echo -e "${GREEN}📊 Tamaño: $IPA_SIZE${NC}"
            echo ""
            echo -e "${YELLOW}💡 Puedes subir este archivo a App Store Connect usando:${NC}"
            echo "   - Xcode Organizer"
            echo "   - Transporter app"
            echo "   - xcrun altool"
        else
            echo -e "${RED}❌ Error: No se encontró el archivo IPA${NC}"
            exit 1
        fi
        ;;
    2)
        echo -e "${YELLOW}🏗️  Construyendo APP sin código firmado (Versión: $APP_VERSION+$BUILD_NUMBER)...${NC}"
        flutter build ios --release --no-codesign --build-name=$APP_VERSION --build-number=$BUILD_NUMBER
        echo -e "${GREEN}✅ Build completado${NC}"
        echo -e "${YELLOW}📦 Archivo APP en: build/ios/iphoneos/Runner.app${NC}"
        ;;
    3)
        echo -e "${YELLOW}🏗️  Construyendo APP con código firmado (Versión: $APP_VERSION+$BUILD_NUMBER)...${NC}"
        flutter build ios --release --build-name=$APP_VERSION --build-number=$BUILD_NUMBER
        echo -e "${GREEN}✅ Build completado${NC}"
        echo -e "${YELLOW}📦 Archivo APP en: build/ios/iphoneos/Runner.app${NC}"
        ;;
    *)
        echo -e "${RED}❌ Opción inválida${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Proceso completado!${NC}"
echo ""
echo -e "${YELLOW}Información de la versión:${NC}"
# Leer versión desde pubspec.yaml (formato: version: X.Y.Z+BUILD, portable para macOS)
if [ -f "pubspec.yaml" ]; then
    APP_VERSION=$(grep -E "^version:" pubspec.yaml | sed -nE "s/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+).*/\1/p")
    BUILD_NUMBER=$(grep -E "^version:" pubspec.yaml | sed -nE "s/^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+([0-9]+).*/\1/p")
    echo "   Versión: ${APP_VERSION:-?}"
    echo "   Build: ${BUILD_NUMBER:-?}"
else
    echo "   (ejecutar desde la raíz del proyecto para ver versión)"
fi
echo ""

