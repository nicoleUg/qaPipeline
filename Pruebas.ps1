param([switch]$SimularFallo)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/Cafeteria.ps1"
function Rechaza($Accion, $Mensaje) {
    try { & $Accion | Out-Null; return $false }
    catch { return $_.Exception.Message -eq $Mensaje }
}
$casos = @(
    @{ Nombre='Espresso: precio y envio'; Accion={ (Nuevo-Pedido espresso 1).Total -eq 20 } },
    @{ Nombre='Latte: precio unitario'; Accion={ (Nuevo-Pedido latte 1).Subtotal -eq 18 } },
    @{ Nombre='Brownie: precio unitario'; Accion={ (Nuevo-Pedido brownie 1).Subtotal -eq 15 } },
    @{ Nombre='Multiples unidades'; Accion={ (Nuevo-Pedido latte 2).Subtotal -eq 36 } },
    @{ Nombre='Envio gratis sobre Bs 50'; Accion={ (Nuevo-Pedido latte 3).Envio -eq 0 } },
    @{ Nombre='Envio cobrado debajo del umbral'; Accion={ (Nuevo-Pedido espresso 4).Envio -eq 8 } },
    @{ Nombre='Cupon ORBITA10: descuento exacto'; Accion={ (Nuevo-Pedido latte 3 ORBITA10).Total -eq 48.6 } },
    @{ Nombre='Sin cupon no hay descuento'; Accion={ (Nuevo-Pedido brownie 2).Descuento -eq 0 } },
    @{ Nombre='Inventario se descuenta'; Accion={ (Nuevo-Pedido espresso 3).StockRestante -eq 7 } },
    @{ Nombre='Se permite agotar stock'; Accion={ (Nuevo-Pedido espresso 10).StockRestante -eq 0 } },
    @{ Nombre='Bloqueo de sobreventa'; Accion={ Rechaza { Nuevo-Pedido espresso 11 } 'Stock insuficiente' } },
    @{ Nombre='Rechazo de producto inexistente'; Accion={ Rechaza { Nuevo-Pedido pizza 1 } 'Producto desconocido' } },
    @{ Nombre='Rechazo de cantidad cero'; Accion={ Rechaza { Nuevo-Pedido latte 0 } 'Cantidad fuera de rango' } },
    @{ Nombre='Rechazo de cantidad negativa'; Accion={ Rechaza { Nuevo-Pedido latte -1 } 'Cantidad fuera de rango' } },
    @{ Nombre='Limite de 20 unidades'; Accion={ Rechaza { Nuevo-Pedido latte 21 -Stock 30 } 'Cantidad fuera de rango' } },
    @{ Nombre='Cupon desconocido rechazado'; Accion={ Rechaza { Nuevo-Pedido latte 1 FALSO } 'Cupon invalido' } }
)
if ($SimularFallo) { $casos += @{ Nombre='DEMO: expectativa incorrecta intencional'; Accion={ (Nuevo-Pedido espresso 1).Total -eq 999 } } }
$xml = New-Object System.Xml.XmlDocument
$suite = $xml.CreateElement('testsuite')
$suite.SetAttribute('name','CafeOrbital')
$suite.SetAttribute('tests',[string]$casos.Count)
[void]$xml.AppendChild($suite)
$fallos=0
foreach ($caso in $casos) {
    $test=$xml.CreateElement('testcase')
    $test.SetAttribute('classname','CafeOrbital.Pedidos')
    $test.SetAttribute('name',$caso.Nombre)
    $reloj=[Diagnostics.Stopwatch]::StartNew()
    try {
        if (-not (& $caso.Accion)) { throw 'Resultado distinto al esperado' }
        Write-Host "[OK] $($caso.Nombre)"
    } catch {
        $fallos++
        $failure=$xml.CreateElement('failure')
        $failure.SetAttribute('message',$_.Exception.Message)
        [void]$test.AppendChild($failure)
        Write-Host "[FALLO] $($caso.Nombre): $($_.Exception.Message)"
    }
    $reloj.Stop()
    $test.SetAttribute('time',$reloj.Elapsed.TotalSeconds.ToString('F4',[Globalization.CultureInfo]::InvariantCulture))
    [void]$suite.AppendChild($test)
}
$suite.SetAttribute('failures',[string]$fallos)
$suite.SetAttribute('errors','0')
New-Item -ItemType Directory -Force "$PSScriptRoot/reportes" | Out-Null
$xml.Save("$PSScriptRoot/reportes/pruebas.xml")
Write-Host "MISION: $($casos.Count) pruebas, $fallos fallos."
if ($fallos -gt 0) { exit 1 }
exit 0
