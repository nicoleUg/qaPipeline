pipeline {
    agent any
    options { skipDefaultCheckout(true); disableConcurrentBuilds(); timeout(time: 5, unit: 'MINUTES') }
    parameters { booleanParam(name: 'SIMULAR_FALLO', defaultValue: false, description: 'Agrega una prueba incorrecta para demostrar que Jenkins bloquea el despegue.') }
    stages {
        stage('01 | Encender motores') {
            steps {
                cleanWs()
                echo 'CAFE ORBITAL: iniciando control de mision'
                checkout scm
                bat 'if not exist mision mkdir mision'
                bat 'copy /Y *.ps1 mision\\'
            }
        }
        stage('02 | Revisar la nave') {
            steps {
                bat 'powershell.exe -NoProfile -NonInteractive -Command "$ErrorActionPreference=\'Stop\'; Get-ChildItem mision/*.ps1 | ForEach-Object { $tokens=$null; $errores=$null; [void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$tokens,[ref]$errores); if($errores.Count) { throw $errores[0] } }; Write-Host \'Codigo validado\'"'
            }
        }
        stage('03 | Escudo de calidad') {
            steps {
                script {
                    def extra = params.SIMULAR_FALLO ? ' -SimularFallo' : ''
                    bat 'powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File mision\\Pruebas.ps1' + extra
                }
            }
        }
        stage('04 | Autorizar despegue') {
            steps { echo 'Todos los controles aprobados: pedido autorizado para despegar.' }
        }
    }
    post {
        always {
            script {
                if (fileExists('mision/reportes/pruebas.xml')) {
                    bat 'powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File mision\\Reporte.ps1'
                    junit testResults: 'mision/reportes/pruebas.xml', skipPublishingChecks: true
                    archiveArtifacts artifacts: 'mision/reportes/*', fingerprint: true
                    publishHTML(target: [reportDir: 'mision/reportes', reportFiles: 'mision.html', reportName: 'Control de mision', keepAll: true, alwaysLinkToLastBuild: true, allowMissing: false])
                }
            }
        }
        success { echo 'MISION CUMPLIDA. Cafe listo para entrega orbital.' }
        failure { echo 'DESPEGUE BLOQUEADO. Revisar controles fallidos en la bitacora.' }
    }
}
