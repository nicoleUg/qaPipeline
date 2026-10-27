# Validacion realizada

- Pruebas locales: 16 aprobadas, 0 fallos.
- Demostracion local SIMULAR_FALLO: 17 pruebas, una falla y el proceso termina con codigo 1.
- Jenkins Cafe-Orbital, build #1: SUCCESS con reporte JUnit y HTML.
- Jenkins Cafe-Orbital, build #2: FAILURE esperado al activar SIMULAR_FALLO.
- Jenkins Cafe-Orbital, build #3: SUCCESS, 16 aprobadas, 0 fallos. Reporte visual abierto y comprobado en Jenkins.

El trabajo local usa una copia de los scripts de esta computadora para demostrar la ejecucion. El Jenkinsfile entregado usa `checkout scm` y esta preparado para configurar Pipeline script from SCM con la URL del repositorio. Esa conexion remota queda pendiente hasta disponer del repositorio; no se verifico un checkout remoto.

La demostracion usa PowerShell, no Newman. El plugin Allure esta instalado, pero el proyecto genera reportes JUnit y HTML. No se incluyeron credenciales en este paquete.
