# Presupuesto y plazos – TeafAPP (VisualTEAF)

**Cliente:** [Nombre del cliente]  
**Proyecto:** TeafAPP – App de apoyo al diagnóstico (rasgos faciales, percentiles, informe PDF)  
**Fecha:** Febrero 2025  

---

## 1. Resumen del análisis técnico

### Alcance de la aplicación
- **Tipo:** App Flutter multiplataforma (Android, iOS, Web, Windows).
- **Tamaño aproximado:** ~7.500 líneas de código Dart en `lib/`, 36 archivos, sin base de datos ni backend.
- **Funcionalidad principal:**
  - Flujo de bienvenida e idioma (ES/EN).
  - 8 pantallas de análisis (analisis0–analisis7) con lógica de diagnóstico.
  - Gestión de pacientes (lista y detalle).
  - Resumen de diagnóstico y pantalla de solución.
  - Generación y compartición de PDF.
  - Datos locales: CSVs embebidos (altura, peso, perímetro craneal, etc.) y `SharedPreferences`.
- **Estado actual:** Proyecto funcional; ya tiene estructura Android, iOS y Web. Irene incluyó versión para PC (Windows/Web).

### Puntos a tener en cuenta
- **Android:** Falta configuración de firma release (ahora usa debug). `applicationId`: `com.teaf_app`.
- **iOS:** Info.plist y estructura básica listos; faltan certificados y provisioning para distribución.
- **Web/PWA:** Existe `manifest.json` e iconos PWA; el PDF usa `dart:io` (solo móvil/desktop), por lo que en web habría que adaptar generación/descarga de PDF para que funcione en navegador.
- **Dependencias:** Una dependencia descontinuada (`js`). Resto estable; conviene actualizar a versiones compatibles con el SDK actual.

**Conclusión:** Es una app de tamaño medio, sin backend ni base de datos. El esfuerzo está en actualizar, preparar builds de tiendas o pulir PWA y definir mantenimiento, no en desarrollar funcionalidades nuevas complejas.

---

## 2. Opción A: Actualización + publicación en tiendas (Android e iOS) + mantenimiento

### Alcance
1. **Actualización técnica**
   - Actualizar Flutter/Dart y dependencias a versiones compatibles y soportadas.
   - Revisar y corregir deprecaciones y, si procede, sustituir el paquete descontinuado.
   - Ajustar permisos y configuraciones para las versiones actuales de Android e iOS.
   - Pruebas básicas en ambos entornos.

2. **Preparación para tiendas**
   - **Android:** Keystore de release, configuración de firma en `build.gradle`, preparar ficheros para Google Play (iconos, descripción, capturas si las aporta el cliente).
   - **iOS:** Cuenta Apple Developer, certificados y provisioning, configuración en Xcode, preparar App Store Connect (textos, capturas, etc.).
   - Política de privacidad y textos legales mínimos (enlace o texto según lo que exijan las tiendas).

3. **Publicación**
   - Subida a Google Play y gestión del proceso de revisión.
   - Subida a App Store y gestión del proceso de revisión (suele ser más lento que Android).
   - Resolución de posibles rechazos (ajustes menores de texto, capturas o permisos).

4. **Mantenimiento (incluido en la opción)**
   - Actualizaciones de compatibilidad: Flutter/SDK y paquetes cuando sea necesario (p. ej. una vez al año o ante cambios importantes de OS).
   - Corrección de fallos críticos que impidan uso normal en las versiones publicadas.
   - Soporte ante incidencias razonables (consultas, pequeños ajustes de configuración).
   - No incluye: nuevas funcionalidades, cambios de diseño amplios ni soporte 24/7.

### Estimación de tiempo (orientativa)

| Concepto | Días |
|----------|------|
| Actualización técnica (dependencias, SDK, deprecaciones) | 2–3 |
| Android: firma, build release, preparar Play Store | 1,5–2 |
| iOS: certificados, provisioning, build, preparar App Store | 2–3 |
| Política de privacidad y textos tiendas | 0,5 |
| Pruebas y ajustes post-revisión | 1–2 |
| **Total desarrollo y publicación** | **7–11 días** |

*Los plazos de revisión de Google (días) y Apple (1–2 semanas en muchos casos) son aparte y no son días de desarrollo.*

### Presupuesto orientativo (solo desarrollo, sin cuotas de tiendas)

- **Tarifa día (ejemplo):** X €/día (ajustar a tu tarifa).
- **Rango:** 7–11 días → **entre 7X y 11X €** (una sola vez).
- **Cuotas no incluidas:** Google Play (pago único) y Apple Developer (anual). Las paga el cliente.

### Mantenimiento – Opción A

- **Formato sugerido:** Contrato anual o paquete de horas.
- **Incluye (ejemplo):**
  - 1 actualización de compatibilidad al año (Flutter/dependencias y compilación en Android/iOS).
  - Hasta X horas de corrección de fallos y soporte (p. ej. 5–10 h/año).
- **Precio orientativo:** Y €/año (ajustar según tu tarifa y horas).
- **Fuera de alcance:** Nuevas funcionalidades, rediseños, cambios de contenido masivos.

---

## 3. Opción B: PWA (Web) + uso en PC + mantenimiento

### Alcance
1. **Ajustes para PWA y web**
   - Ajustar generación/descarga de PDF en web (evitar `dart:io`; usar flujo compatible con navegador, p. ej. `Printing.sharePdf` o descarga directa en web).
   - Mejorar `manifest.json` (nombre “VisualTEAF”/TeafAPP, descripción, colores) y meta tags en `index.html`.
   - Comprobar que la PWA se instala correctamente en móvil y que en PC se usa bien en navegador (la “versión PC” que hizo Irene encaja aquí como uso web/escritorio).

2. **Build y despliegue**
   - `flutter build web` y despliegue en un hosting (Firebase Hosting, Netlify, Vercel o servidor del cliente).
   - Dominio y SSL (incluido si usas hosting que lo ofrece).

3. **Mantenimiento (incluido en la opción)**
   - Actualizaciones de compatibilidad web (Flutter/dependencias) cuando sea necesario.
   - Corrección de fallos que afecten al uso en navegador/PWA.
   - Soporte ante incidencias razonables.
   - No incluye: nuevas funcionalidades ni rediseños.

### Estimación de tiempo (orientativa)

| Concepto | Días |
|----------|------|
| Adaptar PDF para web (condicional/import o alternativa a `dart:io`) | 1–1,5 |
| PWA: manifest, meta tags, nombre, descripción | 0,5 |
| Pruebas PWA (móvil + escritorio) | 0,5–1 |
| Configuración de hosting y despliegue | 0,5–1 |
| **Total** | **2,5–4 días** |

### Presupuesto orientativo (solo desarrollo)

- **Rango:** 2,5–4 días → **entre 2,5X y 4X €** (una sola vez).
- **Costes de hosting:** Dependen del proveedor (muchos tienen plan gratuito suficiente para una PWA de este tamaño).

### Mantenimiento – Opción B

- **Formato sugerido:** Contrato anual o paquete de horas.
- **Incluye (ejemplo):**
  - 1 actualización de compatibilidad web al año.
  - Hasta X horas de corrección de fallos y soporte (p. ej. 3–6 h/año).
- **Precio orientativo:** Z €/año (algo menor que Opción A por no tener tiendas).
- **Fuera de alcance:** Nuevas funcionalidades y rediseños.

---

## 4. Comparativa rápida

| Concepto | Opción A (Tiendas) | Opción B (PWA) |
|----------|---------------------|----------------|
| **Plazo desarrollo** | 7–11 días | 2,5–4 días |
| **Coste desarrollo (orientativo)** | 7X–11X € | 2,5X–4X € |
| **Cuotas externas** | Google Play + Apple Developer (cliente) | Solo hosting (bajo o gratis) |
| **Visibilidad** | App en Google Play y App Store | Enlace web + “Añadir a pantalla de inicio” |
| **Versión PC** | No incluida (solo móvil) | Sí (uso en navegador/escritorio) |
| **Mantenimiento** | Mayor (2 plataformas, políticas tiendas) | Menor (solo web) |

---

## 5. Recomendación breve

- **Si el cliente quiere máxima visibilidad en móviles y “app en la tienda”:** Opción A.
- **Si prioriza coste y rapidez y le basta con acceso desde navegador y “app” instalable (PWA) + uso en PC:** Opción B es más económica y rápida, y la versión PC que hizo Irene encaja de forma natural.

En ambos casos, incluir explícitamente el **mantenimiento** en el contrato evita malentendidos y da seguridad al cliente (compatibilidad y fallos cubiertos) sin comprometerte a desarrollos nuevos sin presupuesto aparte.

---

*Documento basado en análisis del repositorio (estructura, código, configuración Android/iOS/Web). Ajustar X, Y, Z y alcance exacto del mantenimiento según tu tarifa y condiciones con el cliente.*
