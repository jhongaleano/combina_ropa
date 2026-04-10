# StyleStack

StyleStack es una aplicación móvil desarrollada en Flutter que transforma la gestión de prendas de vestir en una experiencia tecnológica e interactiva. A diferencia de un inventario estático, nuestra App permite registrar ropa real, categorizarla y recibir sugerencias inteligentes utilizando el hardware del dispositivo.

---
## Instrucciones de instalación 

1. Clonar el proyecto
   
Abre la terminal y ejecuta:
```bash
git clone https://github.com/jhongaleano/combina_ropa.git
  ```
2. Instalar dependencias

Descarga todos los paquetes necesarios (Provider, Shared Preferences, Vibration, sensors_plus, http,  image_picker) definidos en el pubspec.yaml
```bash
flutter pub get
  ```
3. Ejecutar la aplicación

Para ejecutar el proyecto en tu telefono, asegurate de tener las configuraciones de desarrollador:

```bash
flutter run
  ```
## Equipo de Trabajo y Responsabilidades

Nuestro equipo dividió las tareas para cumplir con cada requerimiento y aprender juntos en el proceso:

| Integrante | Responsabilidades |
| :--- | :--- |
| **Sofia Ballen** | • Maquetación de diseño <br> • conexión con API <br> • diseño y lógica de las vistas: Home y Favoritos <br> • sistema de vibración. |
| **Crsthian Padilla** | • Creación de modelos de datos<br> • Diseño de la vista Main Screen <br> • integración de la Cámara <br> • gestión de estados con el Provider. |
| **Jhon Galeano** | • Estructura de carpetas <br> • lógica del mini player con la libreria sensors_plus <br> • diseño y logica de la vista:  recomendaciones por temporada. |
---

## Estructura del Proyecto
El código está organizado de manera modular para facilitar el mantenimiento y la escalabilidad:
```
StyleStack/
│
├── android/ , ios/ , web/       # Archivos de configuración por plataforma
├── lib/                         # Núcleo de la aplicación
│   ├── models/                  # Estructuras de datos (Clases)
│   │   ├── models_api.dart      # Modelo para las "Sugerencias de temporada" (Fake Store API)
│   │   └── models_camera.dart   # Modelo para gestionar las fotos capturadas
│   │
│   ├── providers/               # Gestión de estado (Lógica de negocio)
│   │   ├── category_provider.dart # Control de categorías de ropa
│   │   └── Wardrobe_provider.dart # Manejo de la colección y outfits favoritos
│   │
│   ├── screens/                 # Vistas o pantallas principales
│   │   ├── favorite-screen.dart # Visualización de outfits marcados como favoritos
│   │   ├── garment_screens.dart # Capturacion de las prendas por medio de la camara
│   │   ├── home-screen.dart     # Visualización de las prendas atravez de su respectiva categoria (guardadas localcamente)
│   │   └── main_screen.dart     # Estructura de navegación reutilizable
│   │
│   ├── service/                 # Comunicación con servicios externos
│   │   └── service.dart         # Lógica para consumir la Fake Store API
│   │
│   ├── widget/                  # Componentes visuales
│   │   └── outfit_widget.dart   # MiniPlayer fijo (Sugerencia de outfit) y tarjetas de ropa
│   │
│   └── main.dart                # Punto de entrada; configura el tema y Providers
│
├── .gitignore                  
├── pubspec.yaml                 # Dependencias (sensors_plus, shared_preferences, vibration.)
└── README.md                    # Documentación del proyecto
```
---

## Flujo de la Aplicación
1. **Captura:** El usuario registra sus prendas tomando fotos directamente con la **cámara** del dispositivo.
2. **Organización:** Las prendas se clasifican en categorías como Camisetas, Sneakers o Chaquetas.
3. **Interacción:** Al marcar favoritos o eliminar prendas, el usuario recibe **feedback háptico (vibración)**.
4. **Sugerencias:** Se consumen datos de la **Fake Store API** para mostrar recomendaciones de temporada.

---

## Tecnologías y Hardware
### Feedback Háptico e Interacción
Implementamos el uso de hardware para mejorar la experiencia de usuario. Cada acción importante en la lista de favoritos o al gestionar la colección dispara una vibración específica.

### Sensor de Movimiento (Shake to Randomize)
Utilizamos la librería `sensors_plus` para añadir una la funcionalidad: Al sacudir el teléfono, el acelerómetro detecta el movimiento y la aplicación selecciona automáticamente un outfit aleatorio de tu colección, ayudándote a decidir qué ponerte.:
```dart
import 'package:sensors_plus/sensors_plus.dart';
```
---
## Flujo Del Desarrollo En GIT
Para este proyecto seguimos los estándares profesionales de Git exigidos:

* **Feature Branching:** No se realizaron cambios directamente en `main`. Cada funcionalidad nació en ramas independientes como `feature/camara` o `feature/provider`, para luego realizar los pull request a la rama `developer`. Main solo acepta pull request provenientes de la rama `developer`, para acegurar la seguridad de la rama princal, solo Jhon Galeano puede hacer el pull a Main.

* **Commits Atómicos:** Aplicamos **Conventional Commits** para mantener un historial claro:
    * `feat:` para nuevas funcionalidades (ej: conexión API).
    * `fix:` para corrección de errores de lógica.
    * `style:` para cambios estéticos y de diseño.
    * `refactor` para cuando se cambia el código pero la app hace lo mismo (ej: remplazar IndexedStack con PageView y PageController).
