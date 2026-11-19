# Fedora-KDE

Plugin en español para administrar, diagnosticar y personalizar Fedora con KDE Plasma. Reúne las capacidades de Edward-Fedora y Edward-KDE en un paquete público, sin perfiles de hardware ni configuraciones de un usuario concreto.

## 1. Objetivo

Resolver problemas de compatibilidad, estabilidad, rendimiento y uso del escritorio mediante evidencia del sistema actual. Codex consulta el entorno cuando lo necesita, propone o aplica el cambio pertinente y comprueba el resultado.

## 2. Funcionalidades

| Skill | Responsabilidad |
| --- | --- |
| `fedora-diagnostico` | Fallos de inicio, servicios, dispositivos, red, audio y permisos. |
| `fedora-operaciones` | RPM/DNF, Flatpak, repositorios, actualizaciones y firmware; distingue Fedora tradicional y Kinoite/OSTree. |
| `fedora-seguridad-rendimiento` | Mediciones, recursos, arranque, batería, temperatura, SELinux y firewall. |
| `kde-escritorio` | Paneles, widgets, temas, colores, fuentes, atajos y apariencia. |
| `kde-terminales` | Konsole, perfiles, shell, prompt, Fastfetch, ASCII e imágenes compatibles. |
| `kde-wayland-diagnostico` | Plasma/KWin, sensores de widgets, escalado, monitores y fallos de escritorio. |

Las skills comparten un [protocolo de contexto, compatibilidad y privacidad](skills/fedora-diagnostico/references/contexto-y-fuentes.md). Conservan sus identificadores para facilitar la migración y se remiten unas a otras dentro de este plugin.

## 3. Requisitos

Codex u otro agente compatible con skills y acceso a sus archivos. Para consultas automáticas necesita una herramienta shell conectada al equipo afectado; el plugin no aporta acceso remoto ni una conexión privilegiada. Sin esa herramienta, entrega comandos para ejecutar localmente.

El script opcional requiere Bash y herramientas habituales de Fedora; `timeout` limita cada consulta. Detecta herramientas ausentes sin instalarlas. Las pruebas del paquete requieren Bash y Python 3, y usan comandos simulados para evitar inspeccionar servicios o hardware reales. Las consultas web necesitan navegación disponible.

## 4. Instalación y uso

Registra esta carpeta como plugin local o incorpora su repositorio al marketplace que utilice tu cliente. La identidad nueva es **`fedora-kde`**, versión **2.0.0**. No es una actualización automática de los identificadores `edward-fedora` y `edward-kde`: instala este paquete, comprueba que aparecen las seis skills y después retira los anteriores desde la gestión de plugins para evitar activaciones duplicadas.

Ejemplos:

- «Este error apareció después de actualizar Fedora KDE; investiga la causa y corrígelo».
- «Mide por qué Plasma consume tanta memoria antes de cambiar configuraciones».
- «Configura Konsole y un indicador de temperatura compatible con mi versión de Plasma».

Para inspección manual, desde la raíz del plugin:

```bash
bash src/fedora-diagnostico.sh --help
bash src/fedora-diagnostico.sh
bash src/fedora-diagnostico.sh --section graphics
```

Otras secciones: `resources`, `security` y `all`. Cada sección incluye contexto base. El script solo consulta datos locales y escribe en la salida estándar: no usa red, sudo, instaladores ni crea informes. No recoge logs ni busca hostname, IP, MAC, UUID o números de serie; versiones y modelos consultados siguen siendo información técnica del equipo. Revisa cualquier salida antes de compartirla. Código 1 significa informe parcial, no necesariamente avería; 0 tampoco significa ausencia de fallos.

## 5. Arquitectura

```txt
[Petición y síntoma]
        ↓
[Skill principal + protocolo compartido]
        ↓
[Contexto local mínimo y versión/edición/sesión verificadas]
        ↓
[Evidencia y documentación aplicable]
        ├── Incompleta → [Consulta dirigida y revisión de hipótesis]
        └── Suficiente → [Cambio dentro del alcance autorizado]
                                  ↓
                          [Prueba funcional]
                            ├── Falla → [Reversión y nueva hipótesis]
                            └── Pasa  → [Resultado y recuperación documentada]
```

Fedora tradicional y Kinoite tienen rutas de administración distintas. Una sesión SSH, Toolbx o un contenedor no demuestra el estado del escritorio del host. Las versiones se consultan, no se fijan en el paquete.

## 6. Fuentes, privacidad y límites

El protocolo enlaza [Fedora KDE SIG](https://fedoraproject.org/wiki/KDE), [Fedora Docs](https://docs.fedoraproject.org/), [Kinoite](https://docs.fedoraproject.org/en-US/fedora-kinoite/), [manuales de KDE](https://docs.kde.org/) y [Konsole](https://docs.kde.org/stable_kf6/en/konsole/konsole/index.html). Codex debe contrastar la versión instalada con la documentación; un enlace no garantiza compatibilidad y algunas páginas pueden bloquear clientes automáticos.

No se publican resultados del equipo, logs, secretos ni copias de configuraciones personales. Guarda los informes y respaldos fuera del plugin. `.gitignore` reduce inclusiones accidentales; revisa los archivos preparados para el commit, incluidos los ya rastreados.

No se aplican ajustes universales, reinicios ni actualizaciones masivas por rutina. Arranque, discos y firmware requieren evaluación específica. El paquete no certifica seguridad ni sustituye una prueba en el sistema real. La edición de esta carpeta no modifica instalaciones ya almacenadas en caché ni desinstala los plugins anteriores.

## 7. Índice y comprobación

```txt
Fedora-KDE/
├── README.md
├── plugin.json
├── .agents/
│   └── plugins/
│       └── marketplace.json
├── skills/
│   ├── fedora-diagnostico/
│   │   ├── SKILL.md
│   │   └── references/contexto-y-fuentes.md
│   ├── fedora-operaciones/SKILL.md
│   ├── fedora-seguridad-rendimiento/SKILL.md
│   ├── kde-escritorio/SKILL.md
│   ├── kde-terminales/SKILL.md
│   └── kde-wayland-diagnostico/SKILL.md
├── src/fedora-diagnostico.sh
└── tests/
    ├── test-plugin.sh
    └── test_plugin.py
```

Ejecuta `bash tests/test-plugin.sh` para validar sintaxis, metadatos, enlaces internos y comportamiento del script con herramientas simuladas, ausencias y fallos de consulta. Estas pruebas no equivalen a instalar el plugin ni comprobar cada función sobre hardware real.
