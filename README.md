---
<p align="right">Developed with ❤️ by <b>ItsDavid-t</b> 🐢</p>

---

### 🖼️ Cómo poner las imágenes para que todos las vean

Para que las imágenes se vean correctamente en GitHub, sigue estos pasos:

1.  **Crea una carpeta:** En la raíz de tu proyecto (donde está la carpeta `lib`), crea una carpeta llamada `assets`.
2.  **Sube las capturas:** Guarda tus imágenes ahí con nombres sencillos: `dashboard.png`, `management.png`, `dark_mode.png`.
3.  **Haz el Push:** Sube esos archivos a GitHub con el resto de tu código.
4.  **Usa rutas relativas:** En el código del README que te puse arriba, fíjate que usé `./assets/nombre.png`. GitHub detectará automáticamente que debe buscar la imagen dentro de tu repositorio y la mostrará a cualquier visitante.

**Truco de Ingeniero:** Si quieres que el README se vea aún más limpio, puedes subir las imágenes a un "Issue" vacío en GitHub o a una rama llamada `media` y usar la URL directaAquí tienes la versión final en inglés de tu README. He optimizado los términos técnicos para que suenen más profesionales (como usar *Soft Delete* en lugar de solo *Recycle Bin*) y te explico exactamente cómo gestionar las imágenes.

---

# 📦 Echo Stock

> **Enterprise-grade inventory management solution built with architectural excellence.**

<p align="left">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi" />
  <img src="https://img.shields.io/badge/Clean_Architecture-black?style=for-the-badge" />
</p>

---

### 📱 Preview
| Main Dashboard | Stock Management | Analytics / Dark Mode |
| :---: | :---: | :---: |
| ![Dashboard](./assets/dashboard.png) | ![Management](./assets/management.png) | ![Dark Mode](./assets/dark_mode.png) |

---

### 💎 Value Proposition
Echo Stock is more than a simple CRUD; it is an ecosystem engineered for **scalability**.
*   **Modern UI:** Full **Material 3** implementation with native multi-theme support.
*   **Performance:** Reactive logic designed to minimize resource consumption on mobile devices.
*   **Maintainability:** Modular codebase allowing new features without breaking existing core logic.
*   **Smart Retention:** Built-in "Reserved" status for products to prevent accidental data loss.

---

### 🛠️ Technical Specifications
*   **State Management:** `Cubit` & `BLoC` for a predictable data flow.
*   **Backend:** `FastAPI` powered by a `PostgreSQL` relational database.
*   **Dependency Injection:** `GetIt` for total decoupling of services.
*   **Error Handling:** Functional programming approach using the `Either` pattern.

---

### 🏗️ Project Structure
Following strict **Clean Architecture** principles:
```text
── lib
│   ├── config          # Themes and Global Configuration
│   ├── data            # Repositories Impl & Data Sources
│   ├── domain          # Entities, Use Cases & Repository Interfaces
│   └── presentation    # UI Logic (Cubits), Screens & Widgets
