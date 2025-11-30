# Cupazo - Panel del Emprendedor (Web)

Este documento detalla las responsabilidades y funcionalidades clave de la plataforma web de Cupazo, diseñada específicamente para emprendedores y vendedores (Sellers).

## 1. Autenticación y Gestión de Cuenta
El punto de entrada para los emprendedores.
- **Registro**: Capacidad para registrarse como nuevo emprendedor o convertir una cuenta de usuario existente en cuenta de vendedor.
- **Inicio/Cierre de Sesión**: Acceso seguro a la plataforma.
- **Perfil de Negocio**: Gestión de la identidad de la marca:
  - Nombre de la tienda/marca.
  - Ciudad y dirección comercial.
  - Datos de contacto.

## 2. Gestión de Ofertas (Deals)
El núcleo operativo del panel, donde se crean y administran las promociones.
- **Creación de Ofertas**: Formulario completo para publicar nuevos deals:
  - Título y descripción detallada.
  - Tipo de promoción (2x1, 3x2, precio por grupo).
  - Categoría y precio.
  - Tamaño máximo del grupo.
  - Ubicación/Ciudad.
  - Carga de imagen principal.
  - Fechas de vigencia (inicio/fin).
- **Administración**: Capacidades para editar, activar, pausar o eliminar ofertas existentes.
- **Listado de Estado**: Vista general de todas las ofertas con su estado actual (Activa, Pausada, Vencida).

## 3. Métricas y Analítica
Dashboard de rendimiento para cada oferta publicada.
- **KPIs por Deal**:
  - Número de vistas y clics.
  - Número de usuarios interesados (deal_interests).
  - Grupos creados (match_groups).
  - Tasa de éxito: Grupos completados vs. cancelados.
- **Tendencias**: Visualización simple del rendimiento a lo largo del tiempo (semanal/mensual).

## 4. Panel Inteligente (IA para Emprendedores)
Módulo de inteligencia artificial para potenciar las ventas.
- **Insights de Rendimiento**: Análisis automático que indica, por ejemplo, los mejores horarios de venta o las categorías más exitosas.
- **Sugerencias Proactivas**: Recomendaciones generadas por IA sobre:
  - Qué tipo de promoción funciona mejor (2x1 vs 3x2).
  - Rangos de precios sugeridos.
  - Categorías a potenciar.
  - Momentos ideales para relanzar promociones.

## 5. Gestión de Grupos y Clientes
Herramientas para monitorear la actividad de los usuarios en tiempo real.
- **Monitoreo de Grupos**: Visualización de grupos activos, número de integrantes y estado actual.
- **Análisis de Clientes**: Identificación de:
  - "Clientes Buenos": Usuarios con alto índice de compras completadas.
  - "Usuarios Problemáticos": Usuarios con alta tasa de cancelaciones.

## 6. Gestión de Riesgo y Confiabilidad
Evaluación de la calidad del tráfico y las transacciones.
- **Nivel de Riesgo**: Métricas sobre porcentaje de grupos cancelados y ratio de conversión.
- **Alertas de IA**: Avisos automáticos sobre ofertas que atraen usuarios poco confiables o horarios con alto abandono.

## 7. Soporte al Emprendedor
Recursos para maximizar el éxito en la plataforma.
- **Centro de Ayuda**: Guías sobre cómo crear ofertas atractivas y gestión de entregas.
- **Asistente IA (Futuro)**: Herramienta para revisar borradores de ofertas y sugerir mejoras en redacción y precios antes de publicar.
