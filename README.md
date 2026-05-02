# 📦 Echo Stock

> **Solución integral para gestión de inventarios con arquitectura de grado empresarial.**

<p align="left">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi" />
  <img src="https://img.shields.io/badge/Clean_Architecture-black?style=for-the-badge" />
</p>

---

### 📱 Vista Previa
| Dashboard Principal | Gestión de Stock | Analíticas / Modo Oscuro |
| :---: | :---: | :---: |
| ![Captura 1](URL_DE_TU_IMAGEN) | ![Captura 2](URL_DE_TU_IMAGEN) | ![Captura 3](URL_DE_TU_IMAGEN) |

---

### 💎 Propuesta de Valor
Echo Stock no es solo un CRUD; es un ecosistema diseñado para la **escalabilidad**. 
*   **Interfaz:** Implementación completa de **Material 3** con soporte nativo para temas.
*   **Rendimiento:** Lógica reactiva que minimiza el consumo de recursos en dispositivos móviles.
*   **Mantenimiento:** Código modular que permite añadir funcionalidades sin romper el sistema existente.

---

### 🛠️ Especificaciones Técnicas
*   **Gestión de Estado:** `Cubit` & `BLoC` (Flujo de datos predecible).
*   **Backend:** `FastAPI` con base de datos relacional `PostgreSQL`.
*   **Inyección de Dependencias:** `GetIt` para un desacoplamiento total.
*   **Manejo de Errores:** Programación funcional con el patrón `Either` (evita excepciones inesperadas).

---

### 🏗️ Estructura del Proyecto
Basado en los principios de **Clean Architecture**:


```text
── lib
│   ├── config
│   │   └── theme
│   │       └── app_theme.dart
│   ├── data
│   │   ├── datasources
│   │   │   └── local_product_data_source.dart
│   │   └── repositories
│   │       ├── category_repository_impl.dart
│   │       └── product_repository_impl.dart
│   ├── domain
│   │   ├── core
│   │   │   ├── di
│   │   │   │   └── service_locator.dart
│   │   │   └── failures.dart
│   │   ├── entities
│   │   │   ├── category.dart
│   │   │   └── product.dart
│   │   ├── repositories
│   │   │   ├── category_repository.dart
│   │   │   └── product_repository.dart
│   │   └── usecases
│   │       ├── category
│   │       │   ├── add_category.dart
│   │       │   ├── ensure_sub_category.dart
│   │       │   ├── get_all_categories.dart
│   │       │   ├── get_category_by_id.dart
│   │       │   ├── get_main_categories.dart
│   │       │   └── get_subcategories.dart
│   │       └── product
│   │           ├── add_product.dart
│   │           ├── delete_product.dart
│   │           ├── get_all_products.dart
│   │           ├── get_archived_product.dart
│   │           ├── get_archived_products_by_categories.dart
│   │           ├── get_products_by_categories.dart
│   │           └── upgrate_product.dart
│   ├── main.dart
│   └── presentation
│       ├── cubit
│       │   ├── category
│       │   │   ├── category_cubit.dart
│       │   │   └── category_state.dart
│       │   └── product
│       │       ├── product_cubit.dart
│       │       └── product_state.dart
│       ├── screens
│       │   ├── add_product_screen.dart
│       │   ├── home_screen.dart
│       │   └── recycle_bin_screen.dart
│       └── widgets
│           ├── category_list.dart
│           ├── category_list_skeleton.dart
│           ├── classification_filter_list.dart
│           ├── custom_drawer.dart
│           ├── custom_search_bar.dart
│           ├── custom_text_form_field.dart
│           ├── empty_state.dart
│           ├── product_card.dart
│           ├── product_detail_overlay.dart
│           ├── product_filtrer_panel.dart
│           ├── product_list_skeleton.dart
│           └── product_list_view.dart
