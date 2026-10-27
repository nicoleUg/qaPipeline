# Validacion realizada

- Pruebas locales: 16 aprobadas, 0 fallos.
- Demostracion local SIMULAR_FALLO: 17 pruebas, una falla y el proceso termina con codigo 1.
- Jenkins Cafe-Orbital, build #1: SUCCESS con reporte JUnit y HTML.
- Jenkins Cafe-Orbital, build #2: FAILURE esperado al activar SIMULAR_FALLO.
- Jenkins Cafe-Orbital, build #3: SUCCESS, 16 aprobadas, 0 fallos. Reporte visual abierto y comprobado en Jenkins.

- Jenkins Cafe-Orbital, build #4: SUCCESS desde https://github.com/nicoleUg/qaPipeline.git, rama main, commit 66b8b1eaf6d57f1a30046be5d48b576fabc9f004. Jenkins obtuvo el Jenkinsfile desde Git, hizo checkout del repositorio, ejecuto las 16 pruebas y publico XML, CSS y HTML.

El trabajo esta configurado como Pipeline script from SCM, Git, rama */main y Script Path Jenkinsfile. Las primeras tres ejecuciones probaron una copia local; desde la ejecucion #4 el codigo se obtiene del repositorio remoto.

La demostracion usa PowerShell, no Newman. El plugin Allure esta instalado, pero el proyecto genera reportes JUnit y HTML. No se incluyeron credenciales en este paquete.
