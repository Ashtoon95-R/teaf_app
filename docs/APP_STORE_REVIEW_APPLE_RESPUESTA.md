# Respuesta a App Review — VisualTEAF (TEAF) — guías 3.2, 2.1 y 2.3

Copia y pega el **bloque siguiente** (puedes enviarlo en **inglés**; Apple suele aceptar español en el hilo, pero el inglés agiliza la revisión) en el **Resolution Center** de App Store Connect, en respuesta al mensaje del 22/04/2026.

Ajusta solo lo imprescindible: si el modelo de negocio o la descripción de privacidad en Connect difiere de lo indicado, alinea el texto o la ficha antes de enviar.

---

## Texto sugerido para Resolution Center (inglés)

**Guideline 3.2 – Business (public App Store distribution)**

1. Is the app restricted to users who are part of a single company or organization?  
   **No.** The app is publicly distributed on the App Store. There is no employer-only access, no invitation list, and no sign-in to our servers to use the app.

2. Is the app designed for use by a limited or specific group of companies or organizations?  
   **No.** The app is intended for any user who downloads it from the App Store (e.g. healthcare professionals and others interested in FASD assessment tools). It is not limited to one hospital or a closed set of clients. The acknowledgements in the app mention research and institutional partners, but they do not restrict who may install or use the app.

3. What features, if any, are intended for the general public (broad users who can discover, download, and use the app without invitation)?  
   The full app is available to anyone who downloads it: step-by-step workflow for entering clinical measurements and context, help links and in-app guide, neurodevelopmental/behavioral domain questions, dermal/facial feature assessment, an algorithmic **support** output aligned with published FASD criteria (Hoyme et al.), a diagnosis summary view, optional PDF export/sharing, and local saving of patient records on the device. There is no feature locked to a specific organization’s users.

4. How do users obtain an account?  
   **No account is required.** The app does not use server-side registration. Session data and saved evaluations are stored **locally on the device** (see 2.1). Optional sharing (e.g. PDF) is initiated by the user through the system share sheet.

5. Is there any paid content? Who pays?  
   **The app is free; there are no in-app purchases in this version** and we do not charge to open the app or to use any feature. (Confirm this matches the pricing and in-app purchase settings you selected in App Store Connect.)

---

**Guideline 2.1 – Information needed (diagnostics and where patient data is stored)**

1. **Does the app provide any kind of diagnostic?**  
   The app is a **clinical decision support** tool. It **does not** replace professional judgment or a clinical visit. It guides the user through data entry and applies published diagnostic criteria (e.g. Hoyme et al., 2016, as referenced in the app) to suggest a **classification/result label** for documentation and discussion, together with a summary and optional PDF. The on-screen and PDF text should be interpreted only in a professional context.

2. **Where is patient data saved?**  
   **All persisted evaluation and patient entry data is stored only on the device** using the platform’s local app storage (SharedPreferences / app sandbox on iOS). **We do not send patient data to our own backend servers** for storage in the current app version. If the user opens external links in Safari (e.g. educational or reference web pages), that is a separate system browser session and is not our server collecting form data. If the user shares a PDF or uses the system share sheet, delivery is under the user’s control through iOS, not a proprietary cloud account in the app.

---

**Guideline 2.3 – Accurate metadata (support material; physical and neurobehavioral signs vs published criteria)**

We cannot change your public App Store description from here. Below is **how to locate the features** mentioned in the metadata so review can verify them.

**A) “Material de apoyo” (support material)**

- **First launch:** From the welcome screen, open the introductory screen. It includes a **tappable link to the Hoyme 2016 reference** (PubMed/PMC) and other institutional link areas as shown on that screen.  
- **Home (`Inicio`):** Tap **“Guía del usuario”** to open a dialog with the full usage guide, which explicitly documents links to explanatory texts, the Hoyme diagnostic scheme, the **“?”** help icons, and the lip/philtrum page link, etc. (same content as the Spanish `instructions` string in the app).  
- **During the flow:** On measurement and feature pages, use the **“?”** icons and tappable **video / reference links** (e.g. hosted on Vimeo) for how to measure weight, height, head circumference, palpebral fissure, and related topics.  
- **Diagnosis / summary:** On the **Diagnóstico** screen, the small **“?”** next to the result opens a dialog with a link to **Cursos TEAF** (`cursoteaf.com`). The **Resumen** screen also offers access to the same type of support link where implemented in the UI.

**B) “Valoración de signos físicos y neuroconductuales con referencia a criterios publicados”**

- **Neurodevelopmental/behavioral axis:** The workflow includes **domains** and related items (e.g. domain count, neurodevelopmental context by age) in the early analysis steps, consistent with the published framework in the Hoyme criteria narrative used by the app.  
- **Physical / dysmorphology axis:** The user enters **anthropometry** (e.g. weight, height, head circumference, palpebral distance) and **facial feature selection** (filtrum, upper lip) with comparison to reference data in-app.  
- **Criteria-aligned output:** After completing the required steps, the app shows the **“Diagnóstico”** result screen with a label derived from the in-app application of the published algorithm, and **“Resumen”** lists the recorded data. The user guide on `Inicio` describes the **Editar / Resumen / Inicio (home)** flow from the Diagnosis screen.  
- **Test path for review (Spanish UI):** Bienvenida → Intro text screen → **Siguiente** → `Inicio` → **“Empezar análisis”** → complete **edad y acogida** (typical case: edad en meses **≥ 24** as required) and follow **Siguiente** through the analysis screens, filling required fields, until you reach **“Diagnóstico”**, then open **“Resumen”** to see the full table. Use the language switcher in the header if you need **English** labels. If a branch leads to a summary dialog, use **“Continuar”** to the Diagnosis screen as prompted.

We remain available to clarify any step or to add an extra screenshot in App Store metadata if you prefer a more obvious visual for reviewers.

---

## Mismo contenido: versión en español (si prefieres contestar en castellano)

Puedes traducir el bloque de inglés literalmente, o usar esta versión condensada:

- **3.2:** No hay restricción a una sola empresa u organización; la app es pública en la App Store, sin registro en nuestro servidor, sin códigos de invitación. Cualquiera puede descargarla. Funcionalidad completa para el usuario. Sin cuenta. Gratis y **sin compras in-app** en esta versión (verificar en Connect).

- **2.1:** La app ofrece **apoyo a la evaluación** según criterios publicados; **no sustituye** el criterio clínico. Los datos de evaluación y pacientes se guardan **solo en el dispositivo** (almacenamiento local de la app en iOS). No se persisten en servidores propios. Enlaces abren en el navegador; compartir PDF es por el flujo de iOS a decisión del usuario.

- **2.3:** El material de apoyo está en la **pantalla inicial de información** (enlace a Hoyme/PMC), en **Guía del usuario** en `Inicio`, en iconos **“?”** y enlaces a **vídeos** en el flujo de análisis, y enlaces a **cursoteaf.com** en **Diagnóstico/Resumen** donde aparezca. La valoración física y neuroconductual se recorre con **Empezar análisis** (dominios, medidas, filtrum/labio, etc.) hasta **Diagnóstico** y **Resumen**. Idioma: conmutador de idioma en la cabecera. **Ruta de prueba:** Bienvenida → texto introductorio → **Siguiente** → **Empezar análisis** → completar el flujo (edad ≥ 24 meses en el caso típico) hasta **Diagnóstico** y **Resumen**.

---

## Cotejo con App Store Connect (App Privacy) — tarea `align-privacy`

Antes o justo después de enviar el mensaje, en **App Store Connect** → tu app → **App Privacy** (y, si aplica, la política de privacidad de URL), verifica coherencia con lo que afirmas arriba:

| Declaración en tu respuesta | Comprueba en Connect |
|-----------------------------|----------------------|
| No hay registro con servidor; datos clínicos/paciente en el **dispositivo** | Tipo de datos: si declaras “datos de salud” o similares, el uso debe explicarse como **solo en el dispositivo** o como corresponda al formulario de Apple. |
| No se envía a *vuestro* backend para guardar | No incluyas “redes”/“sincronización con servidor propio” si no existe. |
| Enlaces externo (Safari) | Opcional: aclarar que no son almacenamiento vuestro; muchas fichas tratan el navegador como “salida a la web”. |
| Compartir PDF / hoja de compartir | Ajusta la explicación a “control del usuario** al compartir**”. |
| Sin compras in-app | La sección de precios/Compras in-app en la ficha debe ser **consonante** (gratis, sin IAP). |

Si el cuestionario de privacidad quedó en “no recopilamos nada” pero la app guarda nombres o datos de salud **localmente**, el formulario de Apple puede requerir declarar el **uso en el dispositivo**; revisa la guía actual de Apple y el editor de **Privacy Nutrition Labels**.

---

## Metadatos y capturas (solo si hace falta) — tarea `metadata-if-needed`

Usa esto **solo** si, tras vuestro mensaje, el revisor sigue indicando 2.3.

1. **Descripción / novedades:** Cada frase del marketing debe corresponder a una pantalla o flujo. Si no queréis reescribir, al menos añadid una frase de estilo: *“Incluye guía in-app, iconos de ayuda y enlaces a material formativo; el resultado de apoyo a la evaluación se muestra en Diagnóstico y Resumen tras completar el cuestionario.”*  
2. **Capturas:** Incluid al menos: **Inicio** con **Guía del usuario** visible o una captura de la **Guía** abierta; una pantalla con **?**/enlace; **Diagnóstico** o **Resumen** con el resultado.  
3. **No tocar el código** salvo producto: si lo preferís, basta con App Store Connect.

---

*Documento generado para acompañar al plan “Cerrar la revisión de App Store (guías 3.2, 2.1 y 2.3)”. Ajustad las afirmaciones legales/clínicas y de producto a la postura de vuestro equipo (el texto sobre “apoyo a la evaluación” y “no sustituye al profesional” es orientativo).*
