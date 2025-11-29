# Estructura del Proyecto - Cupazo App

Este proyecto sigue una arquitectura **Clean Architecture** con estructura **feature-first** y modular.

## 📁 Estructura de Carpetas

```
lib/
├── app/                    # Bootstrap y configuración global
│   ├── app.dart           # Widget principal de la app
│   ├── router.dart        # Configuración de rutas
│   └── di/                # Inyección de dependencias
│       └── injection_container.dart
│
├── core/                   # Código transversal
│   ├── config/            # Configuración de entorno y flavors
│   │   ├── env.dart
│   │   └── flavor.dart
│   ├── error/             # Manejo de errores y fallos
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/           # Cliente HTTP y utilidades de red
│   │   ├── http_client.dart
│   │   └── network_info.dart
│   ├── services/          # Servicios compartidos (opcional)
│   ├── ui/                # Design system global
│   │   └── theme/
│   │       ├── colors.dart
│   │       ├── gradients.dart
│   │       ├── radii.dart
│   │       ├── spacing.dart
│   │       ├── theme.dart
│   │       └── typography.dart
│   ├── usecase/           # Clases base para casos de uso
│   │   └── usecase.dart
│   └── utils/             # Utilidades genéricas
│       ├── logger.dart
│       ├── storage_service.dart
│       └── validators.dart
│
├── features/              # Features de la aplicación
│   └── <feature_name>/    # Cada feature tiene su propia estructura
│       ├── presentation/  # UI y estado
│       │   ├── pages/     # Pantallas completas
│       │   ├── widgets/   # Widgets específicos del feature
│       │   └── state/     # Gestores de estado (Bloc, Cubit, Riverpod)
│       ├── domain/        # Lógica de negocio
│       │   ├── entities/  # Modelos de dominio puros
│       │   ├── repositories/  # Interfaces de repositorios
│       │   └── usecases/  # Casos de uso
│       └── data/          # Implementaciones de acceso a datos
│           ├── datasources/
│           │   ├── remote/    # API, servicios externos
│           │   └── local/     # Base de datos local, caché
│           ├── models/    # DTOs/Models que mapean a Entities
│           └── repositories/  # Implementaciones de repositorios
│
├── shared/                # Recursos compartidos
│   ├── constants/         # Constantes de la app
│   │   ├── app_constants.dart
│   │   └── routes.dart
│   └── localization/      # Soporte multi-idioma
│       └── l10n.dart
│
└── main.dart              # Punto de entrada de la aplicación
```

## 🏗️ Arquitectura

### Capas

1. **Presentation** - Widgets, páginas, navegación y manejo de estado
2. **Domain** - Reglas de negocio puras, entities, interfaces, casos de uso
3. **Data** - Implementaciones de repositorios, DataSources, mapeo de modelos

### Reglas de Dependencias

- ✅ **Permitido:**
  - `presentation` → `domain`
  - `presentation` → `core`
  - `domain` → `core`
  - `data` → `domain`
  - `data` → `core`

- ❌ **Prohibido:**
  - `domain` → `presentation`
  - `domain` → `data`
  - `data` → `presentation`
  - `core` → `features`

## 📝 Convenciones de Nomenclatura

### Presentation
- Páginas: `FeatureNamePage`
- Widgets: `FeatureSpecificWidget`
- State: `FeatureNameState`

### Domain
- Entities: `EntityName`
- Repository Interface: `EntityNameRepository`
- UseCase: `ActionEntityNameUseCase`

### Data
- Repository Implementation: `EntityNameRepositoryImpl`
- Remote DataSource: `EntityNameRemoteDataSource`
- Local DataSource: `EntityNameLocalDataSource`
- Model: `EntityNameModel`

## 🔄 Flujo de Datos

1. **Presentation** recibe input del usuario
2. **State Manager** (Cubit/Bloc) invoca **UseCase**
3. **UseCase** (domain) llama a **Repository Interface**
4. **Repository Implementation** (data) decide usar Remote o Local DataSource
5. **DataSource** obtiene/guarda datos
6. **Model** mapea la respuesta a **Entity**
7. **UseCase** devuelve **Entity** al State Manager
8. **State Manager** actualiza estado y **Presentation** reconstruye UI

## 📦 Dependencias Principales

- `equatable` - Para comparación de objetos
- `http` - Cliente HTTP para peticiones de red

## 🚀 Próximos Pasos

1. Crear features siguiendo la estructura documentada
2. Configurar inyección de dependencias (get_it, injectable, etc.)
3. Implementar router (go_router, auto_route, etc.)
4. Configurar localización si es necesario
5. Agregar más utilidades a `core` según se necesiten
