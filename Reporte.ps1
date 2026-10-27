$ErrorActionPreference='Stop'
[xml]$xml=Get-Content "$PSScriptRoot/reportes/pruebas.xml"
$suite=$xml.testsuite
$filas=foreach($test in $suite.testcase) {
    $estado='APROBADO'; $clase='ok'
    if($test.failure) { $estado='FALLO'; $clase='fallo' }
    $nombre=[Net.WebUtility]::HtmlEncode($test.name)
    "<tr><td>$nombre</td><td class='$clase'>$estado</td><td>$($test.time) s</td></tr>"
}
$estadoMision='LISTA PARA DESPEGAR'
if([int]$suite.failures -gt 0) { $estadoMision='DESPEGUE BLOQUEADO' }
$html=@"
<!doctype html><html lang='es'><meta charset='utf-8'><meta name='viewport' content='width=device-width,initial-scale=1'>
<title>Cafe Orbital | Control de mision</title><style>
body{margin:0;background:#0b1020;color:#e7edff;font:16px system-ui,sans-serif}main{max-width:1040px;margin:auto;padding:54px 28px}small{color:#66dfcf;letter-spacing:3px}h1{font-size:64px;margin:12px 0}h2{font-size:24px}.intro{color:#a8b7d3;max-width:650px;line-height:1.7}.estado{padding:20px;border:1px solid #66dfcf;border-radius:16px;margin:28px 0;color:#66dfcf}.cards{display:flex;gap:16px;flex-wrap:wrap}.card{flex:1;background:#171f36;border-radius:16px;padding:24px;min-width:170px}.num{font-size:46px;font-weight:700}table{width:100%;border-collapse:collapse;margin-top:28px;background:#121a2e}td,th{text-align:left;padding:16px;border-bottom:1px solid #2b3550}.ok{color:#66dfcf}.fallo{color:#ff8196}footer{color:#a8b7d3;margin-top:32px;font-size:14px}
</style><main><small>CONTROL DE MISION / NICOLE UGARTE</small><h1>Cafe Orbital</h1>
<p class='intro'>Cada pedido es una mision. Antes del despegue, Jenkins verifica precios, cupones e inventario para que ningun cafe se pierda en el espacio.</p>
<div class='estado'>$estadoMision</div><div class='cards'><div class='card'><div class='num'>$($suite.tests)</div>Pruebas ejecutadas</div><div class='card'><div class='num'>$([int]$suite.tests-[int]$suite.failures)</div>Controles aprobados</div><div class='card'><div class='num'>$($suite.failures)</div>Fallos detectados</div></div>
<h2>Bitacora de vuelo</h2><table><thead><tr><th>Control</th><th>Resultado</th><th>Duracion</th></tr></thead><tbody>$($filas -join '')</tbody></table>
<footer>Resultados reales del XML JUnit. Build: $env:BUILD_NUMBER | Generado: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')<br>Demo academica: reglas de negocio locales, sin pagos ni pedidos reales.</footer></main></html>
"@
$css=[regex]::Match($html,'(?s)<style>(.*?)</style>').Groups[1].Value
Set-Content "$PSScriptRoot/reportes/mision.css" $css -Encoding UTF8
$html=[regex]::Replace($html,'(?s)<style>.*?</style>','<link rel="stylesheet" href="mision.css">')
Set-Content "$PSScriptRoot/reportes/mision.html" $html -Encoding UTF8
Write-Host 'Bitacora visual generada.'
