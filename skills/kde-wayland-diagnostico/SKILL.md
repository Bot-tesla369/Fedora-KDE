---
name: kde-wayland-diagnostico
description: "Diagnosticar fallos de Plasma, KWin y sesiones Wayland/X11 en Fedora: panel, bandeja, plasmoides, sensores, temas, ventanas, efectos, escalado y monitores. Usar para funciones de escritorio que fallan o configuraciones que no se aplican."
---

# Diagnóstico del escritorio y gráficos

## Objetivo y entradas

Restablecer la función afectada sin reiniciar ni restablecer todo el escritorio por rutina. Identifica síntoma, sesión, componente, cambios recientes y resultado esperado.

## Procedimiento

1. Lee el [protocolo compartido](../fedora-diagnostico/references/contexto-y-fuentes.md). Confirma versión de Plasma, sesión real y acceso al escritorio afectado. `--section graphics` del script aporta GPU/controlador y versiones instaladas; no prueba modos de pantalla ni aceleración. Usa `kscreen-doctor -o` si está disponible y solo en la sesión afectada cuando hagan falta esos datos.
2. Distingue cuatro casos: componente ausente, componente presente sin datos, datos incorrectos y error al representarlos. Comprueba primero ajuste/permiso visible, después fuente de datos, compatibilidad y conflicto con complementos; recoge logs de usuario acotados cuando permitan separar hipótesis. Si hay sospecha de driver/kernel, compruébala en paralelo al nivel gráfico, sin asumir que es un tema visual.
3. Sensores: distingue `lm_sensors`/`sensors`, proveedor de sensores de Plasma y widget que consume los datos. Instalar `lm_sensors` no crea widgets ni garantiza que Plasma reciba todas las temperaturas. Identifica qué sensor requiere el usuario y si debe verse en panel, bandeja o monitor del sistema.
4. Panel o widget ausente: comprueba panel/pantalla afectados, modo de edición, lista de widgets, bandeja y paquete del plasmoide. Prueba un componente integrado o desactiva únicamente el complemento sospechoso con forma de restaurarlo. No elimines la configuración global de Plasma ni todo el conjunto de widgets.
5. Escalado/varios monitores: contrasta modos, frecuencia, escala y conectores con lo admitido por pantalla y driver. Distingue aplicaciones Wayland nativas y XWayland cuando proceda. Usa primero ajustes visuales con posibilidad de revertir; no borres KScreen ni fuerces parámetros globales. Para decoraciones/efectos, comprueba soporte de KWin y versión del complemento.
6. En fallos tras actualizar, identifica el paquete y contrasta documentación/incidencias de esa versión. Cambiar a X11 no es una solución universal; solo considera una comparación temporal si esa sesión ya existe y aclara qué hipótesis prueba. No instales una sesión alternativa ni mates KWin para una prueba de rutina.
7. Si la causa apunta a permisos, kernel, drivers, paquetes o servicios base, continúa con [fedora-diagnostico](../fedora-diagnostico/SKILL.md) o [fedora-operaciones](../fedora-operaciones/SKILL.md). Aplica una corrección y verifica el comportamiento exacto; revierte si empeora y evita encadenar ajustes especulativos.

## Salida y límites

Entrega causa o hipótesis con evidencia, prueba discriminante, acción, validación visual/funcional y reversión. No inventes nombres de unidades, claves KConfig, flags o paquetes. Una sesión Wayland puede cerrarse al terminar KWin; no trates su reinicio como una operación inocua.
