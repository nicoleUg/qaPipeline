function Nuevo-Pedido {
    param([string]$Producto, [int]$Cantidad, [string]$Cupon = '', [int]$Stock = 10)
    $menu = @{ espresso=12; latte=18; brownie=15 }
    if (-not $menu.ContainsKey($Producto)) { throw 'Producto desconocido' }
    if ($Cantidad -lt 1 -or $Cantidad -gt 20) { throw 'Cantidad fuera de rango' }
    if ($Stock -lt $Cantidad) { throw 'Stock insuficiente' }
    if ($Cupon -ne '' -and $Cupon -ne 'ORBITA10') { throw 'Cupon invalido' }
    $subtotal = $menu[$Producto] * $Cantidad
    $descuento = 0
    if ($Cupon -eq 'ORBITA10') { $descuento = [math]::Round($subtotal * 0.10, 2) }
    $envio = 8
    if ($subtotal -ge 50) { $envio = 0 }
    [pscustomobject]@{
        Producto=$Producto; Cantidad=$Cantidad; Subtotal=$subtotal
        Descuento=$descuento; Envio=$envio
        Total=($subtotal - $descuento + $envio); StockRestante=($Stock - $Cantidad)
    }
}
