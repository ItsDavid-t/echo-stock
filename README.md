# Echo Stock

App Flutter para gestión de inventarios (CRUD productos/categorías) con diseño moderno y clean architecture.

## Estado actual (evaluación 1-10)
- Calidad actual: **8.5 / 10**
- Analizado y limpio con `flutter analyze` (0 issues).
- Formateado con `dart format`.
- Dependencias minoritarias con versiones no últimas (recomendado actualizar con `dart pub upgrade`).
- No se encontraron `TODO`, `print()` ni `// ignore` en `lib` y `test`.

## Descripción breve
Echo Stock es un starter kit de inventario con:
- Separación de capas (domain/data/presentation)
- Gestión de estado con Cubits/Blocs en `presentation/cubit`
- Tema oscuro completo bajo `lib/config/theme/app_theme.dart`
- Manejo funcional de errores (`Either<Failure, T>`)
- DI con GetIt (`service_locator.dart`)

## Diagnóstico técnico aplicado (mar 2026)
- `flutter analyze`: OK
- `dart format` sobre todo `lib/` y `test/`: OK
- `dart pub outdated --no-dev-dependencies`: versiones posibles de upgrade:
  - `cupertino_icons: 1.0.8 → 1.0.9`
  - `async: 2.13.0 → 2.13.1`
  - `meta: 1.17.0 → 1.18.2`
  - `vector_math: 2.2.0 → 2.3.0`
  - (transitive, echo_stock notifica `native_toolchain_c`, `path_provider_android` también)

## Checklist recomendada antes de release
1. `dart pub upgrade` + `flutter clean` + `flutter pub get`
2. `flutter test` completo y `flutter test integration_test`
3. Añadir `analysis_options.yaml` con rules estrictas.
4. Establecer CI (GitHub Actions) para `flutter analyze` y tests.
5. Versionado semántico y changelog por commits.
6. Implementar repositorios de datos reales (API o DB local) y states para UI.

## Uso rápido
```bash
flutter pub get
flutter run
```

## Estructura de carpetas (resumen)
- `lib/config/theme` → tema de la app
- `lib/domain` → entidades / repositorios / usecases
- `lib/data` → data sources / repositorios impl
- `lib/presentation` → cubits/screens/widgets

## Cambios aplicados en revisión
- Tema actualizado en `lib/config/theme/app_theme.dart` (Material 3, botones, estilo uniforme)
- README reforzado con estado real y pasos de profesionalización

## Siguientes pasos clave
1. migrar a `go_router` + navegación declarativa
2. Implementar capas de almacenamiento con `drift`/`hive` o API `Dio`
3. tests unitarios para `usecases`, tests widget para pantallas
4. Integración continua y publicación de APK/IPA

---

### Cómo contribuir
1. Clona `git clone <repo>`
2. Crea rama `feature/<nombre>`
3. Asegura tests y `flutter analyze`
4. Pull request con descripción + evidencia de test verde

---

"La simplicidad en código es la mayor sofisticación."

