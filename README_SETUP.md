# Forja — compilar sin Xcode (Command Line Tools + Terminal)

No hace falta instalar Xcode completo. Alcanza con las Command Line Tools
de Apple, que son mucho más livianas.

## 1. Instalar las Command Line Tools

Abrí la Terminal y corré:

```
xcode-select --install
```

Te va a aparecer un cartel del sistema — aceptá y esperá a que termine
(son unos cientos de MB, no los ~15GB de Xcode completo).

## 2. Elegir qué versión de forja.html usar

En `Sources/Forja/Resources/` hay dos archivos:

- `forja.html` — la versión con **Firebase** (sincroniza tu progreso con
  tu amigo). Si la usás, antes tenés que completar el `firebaseConfig`
  con tus datos reales de Firebase (mismos pasos que ya vimos antes).
- `forja_local.html` — la versión **solo local** (sin sincronizar con
  nadie, todo queda en esta Mac).

El proyecto usa el que se llame exactamente `forja.html`. Si querés la
versión local, renombrá:

```
mv Sources/Forja/Resources/forja.html Sources/Forja/Resources/forja_firebase.html
mv Sources/Forja/Resources/forja_local.html Sources/Forja/Resources/forja.html
```

## 3. Editar el código (opcional)

Podés abrir esta carpeta en VS Code, Sublime Text, o el editor que
prefieras — `App.swift` y `ContentView.swift` son texto plano. VS Code
tiene una extensión oficial de Swift (busco "Swift" en el marketplace) que
da resaltado de sintaxis y autocompletado, pero no es obligatoria para
compilar.

## 4. Compilar y armar la app

Desde la Terminal, parado en esta carpeta:

```
chmod +x build.sh
./build.sh
```

Esto compila el código, arma el ícono (`.icns` a partir de `forja.iconset/`),
empaqueta todo en `Forja.app`, y lo firma (firma "ad-hoc", suficiente para
uso personal — no la vas a subir a la App Store).

## 5. Abrir la app

```
open Forja.app
```

O hacé doble clic en `Forja.app` desde Finder. La primera vez macOS puede
avisar que es de un desarrollador no identificado — clic derecho > Abrir,
y confirmás una sola vez.

## 6. Compartirla con tu amigo

Le pasás el archivo `Forja.app` (por AirDrop, por ejemplo). Como no está
firmada con una cuenta de desarrollador de Apple, a él también le va a
pedir "clic derecho > Abrir" la primera vez.

## Nota sobre el ícono

Si en algún momento cambiás el diseño del ícono, solo tenés que reemplazar
las imágenes dentro de `forja.iconset/` (mismos nombres de archivo) y
volver a correr `./build.sh` — se regenera todo solo.
