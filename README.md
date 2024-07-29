+---------+------------+
|        EQUIPO        |               
+---------+------------+
| María Fernanda Gámez |
| Juan Felipe Paredes  |
+---------+------------+

(images/Untitled.svg)

+---------+------------++---------+------------+
|       CASOS DE USO PARA LA BASE DE DATOS     |               
+---------+------------++---------+------------+

-- CASO DE USO 1: GESTIÓN DE INVENTARIO DE BICICLETAS

1. Insertar una nueva bicicleta
   INSERT INTO Bicicletas (ModeloID, Precio, Stock) 
   VALUES (1, 499.99, 10); 

2. Actualizar valores de una bicicleta
   UPDATE Bicicletas 
   SET Precio = 549.99, Stock = 15 
   WHERE ID = 1;

3. Eliminar bicicleta
   ALTER TABLE DetallesVentas 
   DROP FOREIGN KEY DetallesVentas_ibfk_2;

   ALTER TABLE DetallesVentas 
   ADD CONSTRAINT DetallesVentas_ibfk_2 
   FOREIGN KEY (BicicletaID) 
   REFERENCES Bicicletas(ID) 
   ON DELETE CASCADE;

   DELETE from Bicicletas
   WHERE ID =2;


   -- CASO DE USO 2: REGISTRO DE VENTAS

1. Registrar una nueva venta 
   SELECT ID, Nombre, CorreoElectronico 
   FROM Clientes;

2. Obtener las bicicletas disponibles
   SELECT b.ID, b.Precio, b.Stock, m.Nombre AS Modelo, ma.Nombre AS Marca
   FROM Bicicletas b
   JOIN Modelos m ON b.ModeloID = m.ID
   JOIN Marcas ma ON m.MarcaID = ma.ID
   WHERE b.Stock > 0;

3. Calcular el total de la venta 
   CREATE TEMPORARY TABLE Carrito (
      BicicletaID INT,
      Cantidad INT,
      Precio DECIMAL(10, 2)
   );

4. Insertar venta
   INSERT INTO Carrito (BicicletaID, Cantidad, Precio)
   VALUES (1, 2, 499.99), (2, 1, 749.99);

5. Calcular el total de la venta
   SELECT SUM(Cantidad * Precio) AS TotalVenta 
   FROM Carrito;

6. Insertar la venta y los detalles de la venta
   INSERT INTO Ventas (Fecha, ClienteID, Total) 
   VALUES (CURDATE(), 1, (SELECT SUM(Cantidad * Precio) FROM Carrito));

   SET @VentaID = LAST_INSERT_ID();

   INSERT INTO DetallesVentas (VentaID, BicicletaID, Cantidad, PrecioUnitario)
   SELECT @VentaID, BicicletaID, Cantidad, Precio 
   FROM Carrito;

7. Actualizar el inventario de bicicletas
   UPDATE Bicicletas b
   JOIN Carrito c ON b.ID = c.BicicletaID
   SET b.Stock = b.Stock - c.Cantidad;

   -- CASO DE USO 3: GESTIÓN DE PROVEEDORES Y REPUESTOS

1. Agregar nuevo proveedor
   INSERT INTO Proveedores (Nombre, Contacto, Telefono, CorreoElectronico, CiudadID)
   VALUES ('Proveedor A', 'Contacto A', '123456789', 'proveedorA@example.com', 1);

2. Agregar nuevo repuesto
   INSERT INTO Repuestos (Nombre, Descripcion, Precio, Stock, ProveedorID)
   VALUES ('Repuesto A', 'Descripción del repuesto A', 19.99, 100, 1);

3. Actualizar proveedor
   UPDATE Proveedores
   SET Nombre = 'Proveedor B', Contacto = 'Contacto B', Telefono = '987654321', CorreoElectronico = 'proveedorB@example.com', CiudadID = 2
   WHERE ID = 1;

4. Actualizar repuesto
   UPDATE Repuestos
   SET Nombre = 'Repuesto B', Descripcion = 'Descripción del repuesto B', Precio = 29.99, Stock = 150, ProveedorID = 2
   WHERE ID = 1;

5. Eliminar repuesto
   UPDATE Repuestos
   SET ProveedorID = NULL
   WHERE ProveedorID = 1;

   DELETE FROM Repuestos
   WHERE ProveedorID = 1;

6. Eliminar proveedor
   UPDATE Proveedores
   SET ProveedorID = NULL
   WHERE ProveedorID = 1;

   DELETE FROM Repuestos
   WHERE ProveedorID = 1;

   -- Insertar una nueva compra
INSERT INTO Compras (Fecha, ProveedorID, Total)
VALUES ('2024-07-26', 1, 500.00);

-- Obtener el ID de la compra recién insertada
SET @MiCompraID = LAST_INSERT_ID();

-- Verificar que el ID se ha obtenido correctamente
SELECT @MiCompraID;

-- Insertar detalles de la compra utilizando el valor de la variable
INSERT INTO DetallesCompras (CompraID, RepuestoID, Cantidad, PrecioUnitario)
VALUES (@MiCompraID, 1, 10, 50.00),
       (@MiCompraID, 2, 5, 30.00);
   
-- CASO DE USO 4: CONSULTA DE HISTORIAL POR CLIENTE

1. El usuario selecciona el cliente del cual desea ver el historial
SELECT ID, Fecha, ClienteID, Total
FROM Ventas;

2. El usuario selecciona una venta específica para ver los detalles.
SELECT ID,VentaID,BicicletaID,Cantidad,PrecioUnitario
FROM DetallesVentas;


--CASO DE USO 5: GESTIÓN DE COMPRAS DE REPUESTOS

1. Registrar una nueva compra
   INSERT INTO Compras (Fecha, ProveedorID, Total)
   VALUES ('2024-07-26', 1, 500.00);

   SET @CompraID = LAST_INSERT_ID();

2. Registrar detalles de la compra
   INSERT INTO DetallesCompras (CompraID, RepuestoID, Cantidad, PrecioUnitario)
   VALUES (@CompraID, 1, 10, 50.00), (@CompraID, 2, 5, 30.00);

3. Actualizar stock 
   UPDATE Repuestos
   SET Stock = Stock + 10
   WHERE ID = 1;

   UPDATE Repuestos
   SET Stock = Stock + 5
   WHERE ID = 2;  

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









   

--CASOS DE USO CON JOIN

   -- CASO DE USO 11: CONSULTA DE VENTAS POR CIUDAD
   SELECT Ciudad,SUM(Ventas.Total) AS TotalVentas
   FROM Ventas
   JOIN Clientes ON Ventas.ClienteID = Clientes.ID
   GROUP BY Ciudad


   -- CASO DE USO 12: CONSULTA DE PROVEEDORES POR PAIS
   SELECT p.Nombre AS Proveedor, p.Ciudad AS Ciudad, p.Pais AS Pais
   FROM Proveedores p
   ORDER BY p.Pais, p.Nombre;

   
   --CASO DE USO 13: COMPRAS DE REPUESTO POR PROVEEDOR
   SELECT Proveedores.Nombre AS Proveedor, SUM(DetallesCompras.Cantidad) AS TotalRepuestosComprados
   FROM Proveedores
   JOIN Compras ON Proveedores.ID = Compras.ProveedorID
   JOIN DetallesCompras ON Compras.ID = DetallesCompras.CompraID
   GROUP BY Proveedores.Nombre


   --CASO DE USO 14: CLIENTES CON VENTAS EN UN RANGO DE FECHAS 
   SELECT 
      c.Nombre AS Cliente,
      c.CorreoElectronico AS Correo,
      c.Telefono AS Telefono,
      v.Fecha AS FechaDeVenta,
      v.Total AS TotalDeVenta
   FROM Clientes c
   JOIN Ventas v ON c.ID = v.ClienteID
   WHERE v.Fecha BETWEEN '2024-01-01' AND '2024-07-10'
   ORDER BY v.Fecha ASC;


--CASOS DE USO CON PROCEDIMIENTOS ALMACENADOS

   --CASO DE USO 1: ACTUALIZACIÓN DE INVENTARIO DE BICILCETAS

1. Creación del procedimiento
   DELIMITER &&

   CREATE PROCEDURE ActualizarInventarioBicicletas(
      IN p_BicicletaID INT,
      IN p_CantidadVendida INT
   )
   BEGIN
      UPDATE Bicicletas
      SET Stock = Stock - p_CantidadVendida
      WHERE ID = p_BicicletaID;
   END &&

   DELIMITER ;

2. Uso del procedimiento por el administrador
   INSERT INTO Ventas (Fecha, ClienteID, Total) VALUES ('2024-07-26', 1, 1500.00);
   SET @VentaID = LAST_INSERT_ID();
   INSERT INTO DetallesVentas (VentaID, BicicletaID, Cantidad, PrecioUnitario) VALUES (@VentaID, 1, 3, 500.00);

   CALL ActualizarInventarioBicicletas(1, 3);


   --CASO DE USO 2: REGISTRO DE NUEVA VENTA

1. Creación del procedimiento 
   DELIMITER &&
   CREATE PROCEDURE RegistrarVenta(
      IN p_Fecha DATE,
      IN p_ClienteID INT,
      IN p_Total DECIMAL(10, 2),
      IN p_BicicletaID INT,
      IN p_Cantidad INT,
      IN p_PrecioUnitario DECIMAL(10, 2)
   )
   BEGIN
      DECLARE v_VentaID INT;

      INSERT INTO Ventas (Fecha, ClienteID, Total)
      VALUES (p_Fecha, p_ClienteID, p_Total);

      SET v_VentaID = LAST_INSERT_ID();

      INSERT INTO DetallesVentas (VentaID, BicicletaID, Cantidad, PrecioUnitario)
      VALUES (v_VentaID, p_BicicletaID, p_Cantidad, p_PrecioUnitario);

      UPDATE Bicicletas
      SET Stock = Stock - p_Cantidad
      WHERE ID = p_BicicletaID;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL RegistrarVenta('2024-07-26', 1, 1500.00, 1, 3, 500.00);


   --CASO DE USO 3: GENERACIÓN DE REPORTE DE VENTAS POR CLIENTE

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE GenerarReporteVentasPorCliente(
      IN p_ClienteID INT
   )
   BEGIN
      SELECT 
         v.ID AS VentaID,
         v.Fecha AS FechaDeVenta,
         v.Total AS TotalDeVenta
      FROM 
         Ventas v
      WHERE 
         v.ClienteID = p_ClienteID;

      SELECT 
         dv.VentaID,
         b.Nombre AS Bicicleta,
         dv.Cantidad,
         dv.PrecioUnitario,
         (dv.Cantidad * dv.PrecioUnitario) AS Subtotal
      FROM 
         DetallesVentas dv
      JOIN 
         Bicicletas b ON dv.BicicletaID = b.ID
      WHERE 
         dv.VentaID IN (SELECT ID FROM Ventas WHERE ClienteID = p_ClienteID);
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL GenerarReporteVentasPorCliente(1);


   --CASO DE USO 4: REGISTRO DE COMPRAS DE REPUESTOS

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE RegistrarCompraSimplificado(
      IN p_Fecha DATE,
      IN p_ProveedorID INT,
      IN p_Total DECIMAL(10, 2),
      IN p_RepuestoID1 INT,
      IN p_Cantidad1 INT,
      IN p_PrecioUnitario1 DECIMAL(10, 2),
      IN p_RepuestoID2 INT,
      IN p_Cantidad2 INT,
      IN p_PrecioUnitario2 DECIMAL(10, 2)
   )
   BEGIN
      DECLARE v_CompraID INT;

      -- Insertar la nueva compra
      INSERT INTO Compras (Fecha, ProveedorID, Total)
      VALUES (p_Fecha, p_ProveedorID, p_Total);

      -- Obtener el ID de la compra recién insertada
      SET v_CompraID = LAST_INSERT_ID();

      -- Insertar los detalles de la compra para el primer repuesto
      INSERT INTO DetallesCompras (CompraID, RepuestoID, Cantidad, PrecioUnitario)
      VALUES (v_CompraID, p_RepuestoID1, p_Cantidad1, p_PrecioUnitario1);

      -- Actualizar el stock del primer repuesto
      UPDATE Repuestos
      SET Stock = Stock + p_Cantidad1
      WHERE ID = p_RepuestoID1;

      -- Insertar los detalles de la compra para el segundo repuesto
      INSERT INTO DetallesCompras (CompraID, RepuestoID, Cantidad, PrecioUnitario)
      VALUES (v_CompraID, p_RepuestoID2, p_Cantidad2, p_PrecioUnitario2);

      -- Actualizar el stock del segundo repuesto
      UPDATE Repuestos
      SET Stock = Stock + p_Cantidad2
      WHERE ID = p_RepuestoID2;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL RegistrarCompraSimplificado(
      '2024-07-15', 
      1, 
      1500.00, 
      1, 10, 50.00, 
      2, 5, 100.00
   );


   --CASO DE USO 5: GENERACIÓN DE REPORTE DE INVENTARIO

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE GenerarReporteInventario()
   BEGIN
   
      SELECT 
         b.ID AS BicicletaID,
         m.Nombre AS Modelo,
         ma.Nombre AS Marca,
         b.Precio,
         b.Stock
      FROM 
         Bicicletas b
      JOIN 
         Modelos m ON b.ModeloID = m.ID
      JOIN 
         Marcas ma ON m.MarcaID = ma.ID;
      SELECT 
         r.ID AS RepuestoID,
         r.Nombre,
         r.Descripcion,
         r.Precio,
         r.Stock,
         p.Nombre AS Proveedor
      FROM 
         Repuestos r
      JOIN 
         Proveedores p ON r.ProveedorID = p.ID;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL GenerarReporteInventario();


   --CASO DE USO 6: ACTUALIZACIÓN MASIVA DE PRECIOS

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE ActualizarPreciosPorMarca(
      IN p_MarcaID INT,
      IN p_PorcentajeIncremento DECIMAL(5, 2)
   )
   BEGIN
   
      UPDATE Bicicletas b
      JOIN Modelos m ON b.ModeloID = m.ID
      SET b.Precio = b.Precio * (1 + p_PorcentajeIncremento / 100)
      WHERE m.MarcaID = p_MarcaID;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL ActualizarPreciosPorMarca(2, 15.00);


   --CASO DE USO 7: GENERACIÓN DE REPORTE DE CLIENTES POR CIUDAD

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE GenerarReporteClientesPorCiudad()
   BEGIN
      SELECT 
         ci.Nombre AS Ciudad, 
         cl.Nombre AS Cliente, 
         cl.CorreoElectronico, 
         cl.Telefono
      FROM 
         Clientes cl
      JOIN 
         Ciudades ci ON cl.CiudadID = ci.ID
      ORDER BY 
         ci.Nombre, cl.Nombre;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL GenerarReporteClientesPorCiudad();


   --CASO DE USO 8: VERIFICACIÓN DE STOCK ANTES DE VENTA
   
1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE VerificarStock(
      IN p_BicicletaID INT, 
      IN p_Cantidad INT, 
      OUT p_Disponible BOOLEAN
   )
   BEGIN
      DECLARE v_Stock INT;
      
      SELECT Stock INTO v_Stock 
      FROM Bicicletas 
      WHERE ID = p_BicicletaID;

      IF v_Stock >= p_Cantidad THEN
         SET p_Disponible = TRUE;
      ELSE
         SET p_Disponible = FALSE;
      END IF;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL VerificarStock(1, 5, @Disponible);
   SELECT @Disponible;


   --CASO DE USO 9: REGISTRO DE DEVOLUCIONES

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE RegistrarDevolucion(
      IN p_Fecha DATE,
      IN p_ClienteID INT,
      IN p_BicicletaID INT,
      IN p_Cantidad INT
   )
   BEGIN
      INSERT INTO Devoluciones (Fecha, ClienteID, BicicletaID, Cantidad)
      VALUES (p_Fecha, p_ClienteID, p_BicicletaID, p_Cantidad);

      UPDATE Bicicletas
      SET Stock = Stock + p_Cantidad
      WHERE ID = p_BicicletaID;
   END &&
   DELIMITER ;
   
2. Uso del procedimiento por el administrador
   CALL RegistrarDevolucion('2024-07-01', 1, 1, 2);


   --CASO DE USO 10: GENERACIÓN DE REPORTE DE COMPRAS POR PROVEEDOR

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE GenerarReporteComprasPorProveedor(
      IN p_ProveedorID INT
   )
   BEGIN
      SELECT 
         c.ID AS CompraID, 
         c.Fecha, 
         c.Total, 
         dc.RepuestoID, 
         r.Nombre AS Repuesto, 
         dc.Cantidad, 
         dc.PrecioUnitario
      FROM 
         Compras c
      JOIN 
         DetallesCompras dc ON c.ID = dc.CompraID
      JOIN 
         Repuestos r ON dc.RepuestoID = r.ID
      WHERE 
         c.ProveedorID = p_ProveedorID
      ORDER BY 
         c.Fecha;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL GenerarReporteComprasPorProveedor(1);


   --CASO DE USO 11: CALCULADORA DE DESCUENTOS EN VENTAS

1. Creación del procedimiento
   DELIMITER &&
   CREATE PROCEDURE AplicarDescuentoVenta 
      IN p_Fecha DATE,
      IN p_ClienteID INT,
      IN p_Total DECIMAL(10, 2),
      IN p_Descuento DECIMAL(5, 2
      IN p_BicicletaID INT,
      IN p_Cantidad INT,
      IN p_PrecioUnitario DECIMAL(10, 2)
   )
   BEGIN
      DECLARE v_VentaID INT;
      DECLARE v_TotalConDescuento DECIMAL(10, 2);

      SET v_TotalConDescuento = p_Total * (1 - p_Descuento / 100);

      INSERT INTO Ventas (Fecha, ClienteID, Total)
      VALUES (p_Fecha, p_ClienteID, v_TotalConDescuento);

      SET v_VentaID = LAST_INSERT_ID();

      INSERT INTO DetallesVentas (VentaID, BicicletaID, Cantidad, PrecioUnitario)
      VALUES (v_VentaID, p_BicicletaID, p_Cantidad, p_PrecioUnitario);

      UPDATE Bicicletas
      SET Stock = Stock - p_Cantidad
      WHERE ID = p_BicicletaID;
   END &&
   DELIMITER ;

2. Uso del procedimiento por el administrador
   CALL AplicarDescuentoVenta('2024-07-01', 1, 1000.00, 10.00, 1, 2, 500.00);

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
