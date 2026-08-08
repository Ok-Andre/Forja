#!/bin/bash
set -e

APP_NAME="Forja"
BUNDLE_ID="com.tuusuario.forja"
MACOS_MIN="13.0"

TARGET_ARM="arm64-apple-macosx${MACOS_MIN}"
TARGET_X86="x86_64-apple-macosx${MACOS_MIN}"

echo "-> Compilando para Apple Silicon (arm64)..."
swift build -c release --scratch-path .build-arm64 \
  -Xswiftc -target -Xswiftc "$TARGET_ARM" \
  -Xcc -target -Xcc "$TARGET_ARM"

echo "-> Compilando para Intel (x86_64)..."
swift build -c release --scratch-path .build-x86_64 \
  -Xswiftc -target -Xswiftc "$TARGET_X86" \
  -Xcc -target -Xcc "$TARGET_X86"

echo "-> Buscando los binarios compilados..."
ARM_BIN=$(find .build-arm64 -type f -name "${APP_NAME}" -perm +111 2>/dev/null | grep "/release/${APP_NAME}$" | head -n1)
X86_BIN=$(find .build-x86_64 -type f -name "${APP_NAME}" -perm +111 2>/dev/null | grep "/release/${APP_NAME}$" | head -n1)

if [ -z "$ARM_BIN" ] || [ -z "$X86_BIN" ]; then
  echo "No se encontraron los binarios compilados. Revisá los errores de arriba."
  echo "arm64: ${ARM_BIN:-<no encontrado>}"
  echo "x86_64: ${X86_BIN:-<no encontrado>}"
  exit 1
fi
echo "   arm64:  $ARM_BIN"
echo "   x86_64: $X86_BIN"

echo "-> Buscando el paquete de recursos (bundle)..."
RES_BUNDLE=$(find .build-arm64 .build-x86_64 -type d -name "${APP_NAME}_${APP_NAME}.bundle" 2>/dev/null | grep "/release/" | head -n1)
if [ -z "$RES_BUNDLE" ]; then
  echo "No se encontró el paquete de recursos ${APP_NAME}_${APP_NAME}.bundle"
  exit 1
fi
echo "   bundle: $RES_BUNDLE"

echo "-> Combinando en un binario universal..."
mkdir -p .build-universal
lipo -create "$ARM_BIN" "$X86_BIN" -output ".build-universal/${APP_NAME}"
BIN_PATH=".build-universal/${APP_NAME}"

echo "-> Verificando arquitecturas del binario:"
lipo -info "$BIN_PATH"

echo "-> Armando el ícono (.icns)..."
if [ -d "forja.iconset" ]; then
  iconutil -c icns forja.iconset -o AppIcon.icns
fi

echo "-> Armando ${APP_NAME}.app..."
rm -rf "${APP_NAME}.app"
mkdir -p "${APP_NAME}.app/Contents/MacOS"
mkdir -p "${APP_NAME}.app/Contents/Resources"

cp "$BIN_PATH" "${APP_NAME}.app/Contents/MacOS/${APP_NAME}"

# Se copia en los dos lugares donde el accessor generado por SwiftPM puede
# llegar a buscarlo, para cubrir cualquiera de los dos casos.
cp -r "$RES_BUNDLE" "${APP_NAME}.app/Contents/Resources/"
cp -r "$RES_BUNDLE" "${APP_NAME}.app/"

if [ -f "AppIcon.icns" ]; then
  cp "AppIcon.icns" "${APP_NAME}.app/Contents/Resources/AppIcon.icns"
fi

cat > "${APP_NAME}.app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key><string>${BUNDLE_ID}</string>
    <key>CFBundleName</key><string>${APP_NAME}</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>CFBundleShortVersionString</key><string>1.0</string>
    <key>CFBundleVersion</key><string>1</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>LSMinimumSystemVersion</key><string>${MACOS_MIN}</string>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

echo "-> Firmando (ad-hoc)..."
codesign --force --deep -s - "${APP_NAME}.app"

echo ""
echo "Listo: ${APP_NAME}.app (universal: arm64 + x86_64)"
echo "Abrilo con: open ${APP_NAME}.app"