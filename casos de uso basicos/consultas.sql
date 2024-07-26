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