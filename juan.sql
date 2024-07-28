-- CASO DE USO 4: CONSULTA DE HISTORIAL POR CLIENTE

1. El usuario selecciona el cliente del cual desea ver el historial
SELECT ID, Fecha, ClienteID, Total
FROM Ventas;

2. El usuario selecciona una venta específica para ver los detalles.
SELECT ID,VentaID,BicicletaID,Cantidad,PrecioUnitario
FROM DetallesVentas;

-- CASO DE USO 6: CONSULTA DE BICICLETAS MAS VENDIDAS POR MARCA 

1. El sistema muestra una lista de marcas y el modelo de bicicleta más vendido para cada marca.

SELECT
    Marcas.Nombre AS Marca,Modelos.Nombre AS Modelo,SUM(DetallesVentas.Cantidad) AS TotalVendidas,Bicicletas.Precio AS PrecioUnitario,(SUM(DetallesVentas.Cantidad) * Bicicletas.Precio) AS TotalVentas
FROM DetallesVentas
    JOIN Bicicletas ON DetallesVentas.BicicletaID = Bicicletas.ID
    JOIN Modelos ON Bicicletas.ModeloID = Modelos.ID
    JOIN Marcas ON Modelos.MarcaID = Marcas.ID
    GROUP BY Marcas.Nombre, Modelos.Nombre, Bicicletas.Precio
ORDER BY TotalVendidas DESC;

-- CASO DE USO 7: CLIENTES CON MAYOR GASTO EN UN AÑO ESPECIFICO

SELECT
    Clientes.Nombre AS Cliente,SUM(Ventas.Total) AS GastoTotal
FROM Ventas
    JOIN Clientes ON Ventas.ClienteID = Clientes.ID
WHERE YEAR(Ventas.Fecha) = 2024
GROUP BY Clientes.ID
ORDER BY GastoTotal DESC;

-- CASO DE USO 8: PROVEEDORES CON MAS COMPRAS EN EL ULTIMO MES

SELECT
    Proveedores.Nombre AS Proveedor,COUNT(Compras.ID) AS NumeroDeCompras,SUM(Compras.Total) AS TotalCompras
FROM Compras
    JOIN Proveedores ON Compras.ProveedorID = Proveedores.ID
WHERE Compras.Fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
GROUP BY Proveedores.ID
ORDER BY NumeroDeCompras DESC;

-- CASO DE USO 9: REPUESTOS CON MENOR ROTACION EN EL INVENTARIO

SELECT
    Repuestos.Nombre AS Repuesto,Repuestos.Stock AS StockActual,COALESCE(SUM(DetallesCompras.Cantidad), 0) AS TotalComprado,
    CASE
        WHEN COALESCE(SUM(DetallesCompras.Cantidad), 0) = 0 THEN NULL
        ELSE Repuestos.Stock / COALESCE(SUM(DetallesCompras.Cantidad), 1)
    END AS RatioStockCompra
FROM Repuestos
LEFT JOIN DetallesCompras ON Repuestos.ID = DetallesCompras.RepuestoID
GROUP BY Repuestos.ID
ORDER BY RatioStockCompra DESC;

-- CASO DE USO 10: CIUDADES CON MAS VENTAS REALIZADAS

SELECT
    Ciudades.Nombre AS Ciudad,COUNT(Ventas.ID) AS NumeroDeVentas,SUM(Ventas.Total) AS TotalVentas
FROM Ventas
    JOIN Clientes ON Ventas.ClienteID = Clientes.ID
    JOIN Ciudades ON Clientes.CiudadID = Ciudades.ID
GROUP BY Ciudades.ID
ORDER BY NumeroDeVentas DESC;


---------- CASOS DE USO PARA FUNCIONES DE RESUMEN ----------

-- CASO DE USO 1: CALCULAR EL TOTAL DE VENTAS MENSUALES
1. Se crea un procedimiento para el calculo de las ventas mensuales

DELIMITER //

CREATE PROCEDURE CalcularTotalVentasMensuales(
    IN p_año INT,
    IN p_mes INT
)
BEGIN
    SELECT
        SUM(Ventas.Total) AS TotalVentas
    FROM Ventas
    WHERE YEAR(Ventas.Fecha) = p_año
      AND MONTH(Ventas.Fecha) = p_mes;
END //

DELIMITER ;

2. Se llama el procedimiento almacenado

CALL CalcularTotalVentasMensuales();

-- CASO DE USO 2: CALCULAR EL PROMEDIO DE VENTAS POR CLIENTE
1. Se crea el procedimiento para calcular las ventas por cliente
DELIMITER //

CREATE PROCEDURE CalcularPromedioVentasPorCliente(
    IN p_clienteID INT
)
BEGIN
    SELECT
        COALESCE(AVG(Ventas.Total), 0) AS PromedioVentas
    FROM Ventas
    WHERE Ventas.ClienteID = p_clienteID;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL CalcularPromedioVentasPorCliente();

-- CASO DE USO 3: CONTAR EL NUMERO DE VENTAS REALIZADAS EN UN RANGO DE FECHAS
1. Se crea el procedimiento para calculoar las ventas en un rango de fechas 

DELIMITER //

CREATE PROCEDURE ContarVentasPorRangoFechas(
    IN p_fechaInicio DATE,
    IN p_fechaFin DATE
)
BEGIN
    SELECT
        COUNT(*) AS NumeroDeVentas
    FROM Ventas
    WHERE Ventas.Fecha BETWEEN p_fechaInicio AND p_fechaFin;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL ContarVentasPorRangoFechas();

-- CASO DE USO 4: CALCULAR EL TOTAL DE REPUESTOS COMPRADOS POR PROVEEDOR

1. Se crea el procedimiento para calcular el total de repuestos comprados por proveedor 

DELIMITER //

CREATE PROCEDURE CalcularTotalRepuestosPorProveedor(
    IN p_proveedorID INT
)
BEGIN
    SELECT
        COALESCE(SUM(DetallesCompras.Cantidad), 0) AS TotalRepuestosComprados
    FROM DetallesCompras
    JOIN Repuestos ON DetallesCompras.RepuestoID = Repuestos.ID
    WHERE Repuestos.ProveedorID = p_proveedorID;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL CalcularTotalRepuestosPorProveedor();

-- CASO DE USO 5: CALCULAR EL INGRESO TOTAL POR AÑO

1. Se define el procedimiento para calcular el ingreso total por año 

DELIMITER //

CREATE PROCEDURE CalcularIngresoTotalPorAño(
    IN p_iaño INT
)
BEGIN
    SELECT
        COALESCE(SUM(Ventas.Total), 0) AS IngresoTotal
    FROM Ventas
    WHERE YEAR(Ventas.Fecha) = p_iaño;
END //

DELIMITER ;

2. Se llama el procedimiento 

CALL CalcularIngresoTotalPorAño();

-- CASO DE USO 6: CALCULAR EL NUMERO DE CLIENTES ACTIVOS EN UN MES

1. Se define el procedimiento para calcular el numero de clientes activos en un mes 

DELIMITER //

CREATE PROCEDURE ContarClientesActivosEnMes(
    IN p_mes INT,
    IN p_año INT
)
BEGIN
    SELECT
        COUNT(DISTINCT Ventas.ClienteID) AS NumeroDeClientesActivos
    FROM Ventas
    WHERE MONTH(Ventas.Fecha) = p_mes
      AND YEAR(Ventas.Fecha) = p_año;
END //

DELIMITER ;

2. Se llama el procedimiento 

CALL ContarClientesActivosEnMes();

--  CASO DE USO 7: CALCULAR EL PROMEDIO DE COMPRAS POR PROVEEDOR

1. Se calcula el promedio de compras por proveedor por medio del siguiente procedimiento

DELIMITER //

CREATE PROCEDURE CalcularPromedioComprasPorProveedor(
    IN p_proveedorID INT
)
BEGIN
    SELECT
        COALESCE(AVG(Compras.Total), 0) AS PromedioCompras
    FROM Compras
    WHERE Compras.ProveedorID = p_proveedorID;
END //

DELIMITER ;

2. Se llama el procedimiento de la siguiente manera

CALL CalcularPromedioComprasPorProveedor();

-- CASO DE USO 8: CALCULAR EL TOTAL DE VENTAS POR MARCA

1. Se crea el procedimiento para calcular el total de ventas por marca

DELIMITER //

CREATE PROCEDURE CalcularTotalVentasPorMarca()
BEGIN
    SELECT
        Marcas.Nombre AS Marca, COALESCE(SUM(DetallesVentas.Cantidad * DetallesVentas.PrecioUnitario), 0) AS TotalVentas
    FROM
        DetallesVentas
    JOIN Bicicletas ON DetallesVentas.BicicletaID = Bicicletas.ID
    JOIN Modelos ON Bicicletas.ModeloID = Modelos.ID
    JOIN Marcas ON Modelos.MarcaID = Marcas.ID
    GROUP BY
        Marcas.Nombre;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL CalcularTotalVentasPorMarca();

-- CASO DE USO 9: CALCULAR EL PROMEDIO DE PRECIOS DE BICICLETAS POR MARCA

1. Se delimita el nuevo procedimiento para calcular el promedio de precios por marca de bicicleta

DELIMITER //

CREATE PROCEDURE CalcularPromedioPreciosPorMarca()
BEGIN
    SELECT
        Marcas.Nombre AS Marca, COALESCE(AVG(Bicicletas.Precio), 0) AS PromedioPrecio
    FROM
        Bicicletas
    JOIN Modelos ON Bicicletas.ModeloID = Modelos.ID
    JOIN Marcas ON Modelos.MarcaID = Marcas.ID
    GROUP BY
        Marcas.Nombre;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL CalcularPromedioPreciosPorMarca();

-- CASO DE USO 10: CONTAR EL NUMERO DE REPUESTOS POR PROVEEDOR

1. Se crea el procedimiento para contar el numero de repuestos por proveedor

DELIMITER //

CREATE PROCEDURE ContarRepuestosPorProveedor()
BEGIN
    SELECT
        Proveedores.Nombre AS Proveedor, COUNT(Repuestos.ID) AS NumeroDeRepuestos
    FROM
        Repuestos
    JOIN Proveedores ON Repuestos.ProveedorID = Proveedores.ID
    GROUP BY
        Proveedores.Nombre;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL ContarRepuestosPorProveedor();

-- CASO DE USO 11: CALCULAR EL TOTAL DE INGRESOS POR CLIENTE

1. Creamos el procedimiento para calcular el total de ingresos por cliente

DELIMITER //

CREATE PROCEDURE CalcularTotalIngresosPorCliente()
BEGIN
    SELECT
        Clientes.Nombre AS Cliente, COALESCE(SUM(Ventas.Total), 0) AS TotalIngresos
    FROM
        Clientes
    LEFT JOIN Ventas ON Clientes.ID = Ventas.ClienteID
    GROUP BY
        Clientes.Nombre;
END //

DELIMITER ;

2. LLamamos el procedimiento

CALL CalcularTotalIngresosPorCliente();

-- CASO DE USO 12: CALCULAR EL PROMEDIO DE COMPRAS MENSUALES

DELIMITER //

CREATE PROCEDURE CalcularPromedioComprasMensuales()
BEGIN
    WITH VentasMensuales AS (
        SELECT
            DATE_FORMAT(Fecha, '%Y-%m') AS Mes,
            SUM(Total) AS TotalVentas
        FROM
            Ventas
        GROUP BY
            DATE_FORMAT(Fecha, '%Y-%m')
    )
    SELECT
        AVG(TotalVentas) AS PromedioComprasMensuales
    FROM
        VentasMensuales;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL CalcularPromedioComprasMensuales();

--CASO DE USO 13: CALCULAR EL TOTAL DE VENTAS POR DIA DE LA SEMANA

1. Procedimiento para calcular el total de ventas por dias 

DELIMITER //

CREATE PROCEDURE CalcularTotalVentasPorDiaSemana()
BEGIN
    SELECT
        CASE DAYOFWEEK(Fecha)
            WHEN 1 THEN 'Lunes'
            WHEN 2 THEN 'Martes'
            WHEN 3 THEN 'Miercoles'
            WHEN 4 THEN 'Jueves'
            WHEN 5 THEN 'Viernes'
            WHEN 6 THEN 'Sabado'
            WHEN 7 THEN 'Domingo'
        END AS DiaDeLaSemana,
        SUM(Total) AS TotalVentas
    FROM
        Ventas
    GROUP BY
        DAYOFWEEK(Fecha)
    ORDER BY
        DAYOFWEEK(Fecha);
END //

DELIMITER ;

2. LLamada del procedimiento

CALL CalcularTotalVentasPorDiaSemana();

-- CASO DE USO 14: CALCULAR EL NUMERO DE VENTAS POR CATEGORIA DE BICICLETA

1. Creacion del procedimiento para calcular el numero de ventas por categoria de bicicletas

DELIMITER //

CREATE PROCEDURE ContarVentasPorMarca()
BEGIN
    SELECT
        M.Nombre AS Marca,
        COUNT(DV.ID) AS NumeroDeVentas
    FROM
        DetallesVentas DV
    INNER JOIN
        Bicicletas B ON DV.BicicletaID = B.ID
    INNER JOIN
        Modelos MD ON B.ModeloID = MD.ID
    INNER JOIN
        Marcas M ON MD.MarcaID = M.ID
    GROUP BY
        M.Nombre
    ORDER BY
        NumeroDeVentas DESC;
END //

DELIMITER ;

2. Se llama el procedimiento

CALL ContarVentasPorMarca();

-- CASO DE USO 15: CALCULAR EL TOTAL DE VENTAS POR AÑO Y MES

1. Procedimiento

DELIMITER //

CREATE PROCEDURE CalcularTotalVentasPorAnyoYMes()
BEGIN
    SELECT
        YEAR(V.Fecha) AS Año,
        MONTH(V.Fecha) AS Mes,
        SUM(V.Total) AS TotalVentas
    FROM
        Ventas V
    GROUP BY
        YEAR(V.Fecha),
        MONTH(V.Fecha)
    ORDER BY
        Año DESC,
        Mes DESC;
END //

DELIMITER ;

2. Llamada del procedimiento

CALL CalcularTotalVentasPorAnyoYMes();









