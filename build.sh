#!/bin/bash
set -e

APP_NAME="Forja"
BUNDLE_ID="com.tuusuario.forja"

echo "-> Compilando..."
swift build -c release

BIN_PATH=".build/release/${APP_NAME}"
RES_BUNDLE=".build/release/${APP_NAME}_${APP_NAME}.bundle"

if [ ! -f "$BIN_PATH" ]; then
  echo "No se encontró el binario compilado en $BIN_PATH"
  exit 1
fi

echo "-> Armando el ícono (.icns)..."
if [ -d "forja.iconset" ]; then
  iconutil -c icns forja.iconset -o AppIcon.icns
fi

echo "-> Armando ${APP_NAME}.app..."
rm -rf "${APP_NAME}.app"
mkdir -p "${APP_NAME}.app/Contents/MacOS"
mkdir -p "${APP_NAME}.app/Contents/Resources"

cp "$BIN_PATH" "${APP_NAME}.app/Contents/MacOS/${APP_NAME}"

if [ -d "$RES_BUNDLE" ]; then
  cp -r "$RES_BUNDLE" "${APP_NAME}.app/Contents/Resources/"
fi

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
    <key>LSMinimumSystemVersion</key><string>13.0</string>
    <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

echo "-> Firmando (ad-hoc)..."
codesign --force --deep -s - "${APP_NAME}.app"

echo ""
echo "Listo: ${APP_NAME}.app"
echo "Abrilo con: open ${APP_NAME}.app"
