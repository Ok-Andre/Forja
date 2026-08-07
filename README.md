# 🔨 FORJA — Fitness & Habits Tracker for macOS

![macOS](https://img.shields.io/badge/macOS-13.0%2B-000000?style=for-the-badge&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-007ACC?style=for-the-badge&logo=swift&logoColor=white)
![WebKit](https://img.shields.io/badge/WebKit-Native%20Wrapper-0055FF?style=for-the-badge&logo=safari&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-ES6%2B-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Firebase](https://img.shields.io/badge/Firebase-Realtime%20DB-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

**FORJA** es una aplicación nativa y liviana para **macOS** diseñada para forjar hábitos de alto rendimiento, llevar el control diario de tus entrenamientos de gimnasio, registrar tu peso y sincronizar tu progreso en tiempo real. 

Combina la potencia de **SwiftUI & WebKit** en la capa nativa de macOS con una interfaz web moderna, oscura y ultra fluida construida en **HTML5/CSS3/JS**.

---

## ✨ Características Principales

- 🏋️‍♂️ **Registro de Entrenamientos y Series:** Anota ejercicios, repeticiones y peso cargado en cada sesión.
- 🔥 **Seguimiento de Hábitos (Rachas & Heatmap):** Monitorea tus hábitos clave (sueño de 8h, hidratación, proteína, pasos) con un mapa de calor semanal y contador de días seguidos (*streaks*).
- 📋 **Gestor de Rutinas:** Crea y organiza tus rutinas de entrenamiento personalizadas (ej. *Push/Pull/Legs*, *Upper/Lower*).
- ⚖️ **Control de Peso Corporal:** Registra tu peso diario o semanal y observa tu evolución.
- ☁️ **Sincronización Opcional con Firebase:** Sincroniza tu progreso entre varias Macs o compártelo con tu compañero de entrenamiento.
- ⚡ **Compilación Ultra-Rápida sin Xcode:** No requiere instalar los ~15 GB de Xcode completo. Se compila en segundos desde la Terminal usando solo las **Apple Command Line Tools**.

---

## 🛠️ Tecnologías Utilizadas

| Categoría | Tecnología / Herramienta | Descripción |
| :--- | :--- | :--- |
| **Nativo macOS** | `Swift 5.9` / `SwiftUI` | Estructura de la aplicación nativa macOS y manejo de ventana sin barra de título. |
| **Renderizado** | `WebKit (WKWebView)` | Motor de renderizado integrado para cargar la interfaz gráfica con alto rendimiento. |
| **Frontend UI** | `HTML5`, `CSS3`, `JS (ES6+)` | Interfaz oscura premium con variables CSS, tipografías personalizadas (*Oswald*, *Inter*, *JetBrains Mono*) y estado local reactivo. |
| **Backend / DB** | `Firebase Realtime DB` *(Opcional)* | Sincronización en tiempo real de logs, hábitos y rutinas entre usuarios o dispositivos. |
| **Build System** | `Swift Package Manager` & `bash` | Gestión de paquetes ejecutable nativa y script de empaquetado `.app` con firma ad-hoc. |

---

## 📂 Estructura del Proyecto

```text
Forja/
├── Package.swift               # Configuración del paquete ejecutable Swift (SPM)
├── build.sh                    # Script bash para compilar, empaquetar e iconizar Forja.app
├── README.md                   # Documentación principal del repositorio
├── README_SETUP.md             # Guía detallada de compilación sin Xcode
├── AppIcon.icns                # Ícono compilado para macOS
├── forja.iconset/              # Conjunto de resoluciones de íconos (16x16 a 1024x1024)
└── Sources/
    └── Forja/
        ├── App.swift           # Punto de entrada SwiftUI de la aplicación macOS
        ├── ContentView.swift   # Wrapper NSViewRepresentable para WKWebView
        └── Resources/
            ├── forja.html      # Interfaz de la app (versión activa)
            └── forja_firebase.html # Versión con soporte para sincronización en Firebase
```

---

## 🚀 Instalación y Compilación

### 1. Prerrequisitos
Solo necesitas las **Command Line Tools** de Apple (no requiere Xcode completo):
```bash
xcode-select --install
```

### 2. Seleccionar Modo de Uso (Local o Firebase)
Por defecto, la aplicación utiliza almacenamiento local (`localStorage`). Si deseas habilitar la sincronización con Firebase:
```bash
# Cambiar a versión Firebase (debes configurar tus credenciales en forja.html)
mv Sources/Forja/Resources/forja.html Sources/Forja/Resources/forja_local.html
mv Sources/Forja/Resources/forja_firebase.html Sources/Forja/Resources/forja.html
```

### 3. Compilar y Empaquetar `.app`
Ejecuta el script de compilación incluido:
```bash
chmod +x build.sh
./build.sh
```
Esto creará el paquete ejecutable `Forja.app` firmado ad-hoc en la raíz del proyecto.

### 4. Ejecutar la Aplicación
```bash
open Forja.app
```
O haz doble clic en `Forja.app` desde el Finder.

---

## 🤝 Contribuciones y Créditos

Desarrollado para quienes buscan una herramienta liviana, estética y sin fricción para forjar su mejor versión diaria en macOS.

---
*Desarrollado con Swift, WebKit y HTML5.* 🔨
