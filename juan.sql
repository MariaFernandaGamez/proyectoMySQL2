-- CASO DE USO 4: CONSULTA DE HISTORIAL POR CLIENTE

1. El usuario selecciona el cliente del cual desea ver el historial
SELECT ID, Fecha, ClienteID, Total
FROM Ventas;

2. El usuario selecciona una venta específica para ver los detalles.
SELECT ID,VentaID,BicicletaID,Cantidad,PrecioUnitario
FROM DetallesVentas;


