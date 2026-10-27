# Guion de presentacion

"Mi proyecto se llama Cafe Orbital. Simula una cafeteria espacial donde cada pedido es una mision. La creatividad esta en la tematica y en convertir la pipeline en un centro de control con una bitacora visual."

"Jenkins obtiene el codigo del repositorio, limpia el espacio de trabajo, valida la sintaxis y ejecuta 16 pruebas. Se comprueban precios, el descuento ORBITA10, el costo del envio, el stock y los pedidos invalidos."

"Si todos los controles pasan, se autoriza el despegue. Jenkins publica los resultados JUnit y un reporte HTML con los resultados reales de esa ejecucion. Si una prueba falla, el despegue queda bloqueado."

"Para demostrarlo, active SIMULAR_FALLO. Ese parametro agrega una expectativa incorrecta de forma intencional. Jenkins detecta el error, publica el reporte y marca la ejecucion como fallida. Despues lo desactivo y la siguiente ejecucion vuelve a pasar."

Si preguntan por que es integracion continua: "El flujo automatiza controles sobre el codigo obtenido de Git. En esta configuracion el build se inicia manualmente; se puede agregar un webhook para iniciarlo con cada push."

Si preguntan por herramientas: "Uso Git para el codigo, Jenkins Pipeline para la orquestacion, PowerShell para las reglas y las pruebas, JUnit para resultados, HTML Publisher para el reporte visual y Workspace Cleanup para limpiar el entorno."
