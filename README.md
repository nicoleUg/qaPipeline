# Cafe Orbital: mision de entrega

Proyecto academico de Nicole Ugarte. Una cafeteria espacial usa Jenkins como centro de control: ningun pedido despega si fallan los controles de calidad.

## Que hace de diferente esta pipeline

- Cuatro etapas tematicas: Encender motores, Revisar la nave, Escudo de calidad y Autorizar despegue.
- Obtiene el codigo desde Git con `checkout scm`.
- Limpia el entorno antes de cada ejecucion con Workspace Cleanup.
- Valida la sintaxis de todos los scripts antes de probarlos.
- Ejecuta 16 pruebas de reglas reales de negocio: precios, descuentos, envio, stock y entradas invalidas.
- Publica resultados JUnit y una bitacora visual HTML generada con los resultados de esa ejecucion.
- Conserva XML y HTML como artefactos con huellas digitales.
- Si falla un control, omite el despegue y marca la ejecucion como FAILURE.
- Parametro SIMULAR_FALLO para demostrar un fallo intencional sin modificar el codigo.
- Evita ejecuciones simultaneas y detiene la pipeline si excede cinco minutos.

## Requisitos

Un agente Jenkins con Windows y Windows PowerShell 5.1. Plugins: Git, Pipeline, JUnit, Workspace Cleanup y HTML Publisher. Ya se instalaron en la computadora de trabajo. El proyecto no necesita contrasenas, dependencias de pago ni llamadas a servicios externos.

NodeJS, Allure y Blue Ocean tambien estan instalados en Jenkins. Esta version usa pruebas PowerShell y publica JUnit y HTML; no ejecuta Newman ni genera resultados Allure. Blue Ocean permite visualizar las etapas del trabajo.

## Subir el proyecto al repositorio

1. Crear un repositorio vacio en GitHub, GitLab u otro servicio Git.
2. Subir TODOS los archivos de esta carpeta a la raiz del repositorio, incluidos Jenkinsfile y los tres scripts. No subir el ZIP como archivo: descomprimirlo primero.
3. Confirmar que el Jenkinsfile sea visible directamente en la raiz.
4. No incluir contrasenas, tokens ni credenciales personales.

## Conectar Jenkins al repositorio

1. Nueva tarea > nombre Cafe-Orbital > Pipeline > OK.
2. En Pipeline > Definition elegir Pipeline script from SCM.
3. SCM: Git. Repository URL: pegar la URL HTTPS del repositorio.
4. Si es privado, elegir una credencial de Jenkins con acceso de lectura. No pegar el token dentro del Jenkinsfile. Si es publico, normalmente no hace falta credencial.
5. Branch Specifier: `*/main` si tu rama se llama main; ajustar si tiene otro nombre.
6. Script Path: `Jenkinsfile`.
7. Guardar y pulsar Build Now.
8. Al terminar, abrir Test Result y Control de mision. Tambien se puede descargar `mision.html` desde los artefactos y abrirlo localmente.

## Demostracion en clase

1. Construir normalmente: deben aprobarse 16 controles y aparecer SUCCESS.
2. Abrir el resultado JUnit y la bitacora visual.
3. Elegir Build with Parameters y marcar SIMULAR_FALLO. Habra 17 pruebas: 16 pasan y una falla intencionalmente. Jenkins debe bloquear Autorizar despegue y marcar FAILURE.
4. Volver a ejecutar sin marcar el parametro para dejar el trabajo en SUCCESS.

Guion breve en PRESENTACION.md.

## Probar localmente

Abrir PowerShell dentro de esta carpeta:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Pruebas.ps1
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Reporte.ps1

Se generan `reportes/pruebas.xml` y `reportes/mision.html`.
Para demostrar el fallo: agregar `-SimularFallo` al primer comando.
ExecutionPolicy Bypass solo se aplica al proceso que ejecuta las pruebas.

## Reglas de negocio

Espresso Bs 12, latte Bs 18, brownie Bs 15. Envio Bs 8; gratis si el subtotal alcanza Bs 50 antes del descuento. ORBITA10 descuenta el 10% del subtotal. Cantidades permitidas: 1 a 20, sujetas al stock disponible. Stock predeterminado: 10 unidades. Los pedidos no modifican un inventario persistente: cada prueba usa un stock independiente.

## Alcance

Demo de reglas de negocio: no es una tienda publicada ni realiza entregas o pagos. Repositorio: https://github.com/nicoleUg/qaPipeline. Jenkins ya esta conectado a main mediante Pipeline script from SCM; el build #4 verifico el checkout remoto y termino en SUCCESS con 16 pruebas aprobadas. El ejemplo inicial de la calculadora se reemplaza por este proyecto para la entrega.
