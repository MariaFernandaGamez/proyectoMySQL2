-- Paises
INSERT INTO Paises (ID, Nombre) VALUES (1, 'Colombia');
INSERT INTO Paises (ID, Nombre) VALUES (2, 'Argentina');
INSERT INTO Paises (ID, Nombre) VALUES (3, 'Brasil');
INSERT INTO Paises (ID, Nombre) VALUES (4, 'México');
INSERT INTO Paises (ID, Nombre) VALUES (5, 'Chile');

-- Ciudades
INSERT INTO Ciudades (ID, Nombre, PaisID) VALUES (1, 'Bogotá', 1);
INSERT INTO Ciudades (ID, Nombre, PaisID) VALUES (2, 'Buenos Aires', 2);
INSERT INTO Ciudades (ID, Nombre, PaisID) VALUES (3, 'São Paulo', 3);
INSERT INTO Ciudades (ID, Nombre, PaisID) VALUES (4, 'Ciudad de México', 4);
INSERT INTO Ciudades (ID, Nombre, PaisID) VALUES (5, 'Santiago', 5);

-- Marcas
INSERT INTO Marcas (ID, Nombre) VALUES (1, 'Trek');
INSERT INTO Marcas (ID, Nombre) VALUES (2, 'Specialized');
INSERT INTO Marcas (ID, Nombre) VALUES (3, 'Cannondale');
INSERT INTO Marcas (ID, Nombre) VALUES (4, 'Giant');
INSERT INTO Marcas (ID, Nombre) VALUES (5, 'Scott');

-- Modelos
INSERT INTO Modelos (ID, Nombre, MarcaID) VALUES (1, 'Domane AL 2', 1);
INSERT INTO Modelos (ID, Nombre, MarcaID) VALUES (2, 'Allez', 2);
INSERT INTO Modelos (ID, Nombre, MarcaID) VALUES (3, 'Synapse', 3);
INSERT INTO Modelos (ID, Nombre, MarcaID) VALUES (4, 'Defy Advanced 1', 4);
INSERT INTO Modelos (ID, Nombre, MarcaID) VALUES (5, 'Speedster 20', 5);

-- Bicicletas
INSERT INTO Bicicletas (ID, ModeloID, Precio, Stock) VALUES (1, 1, 1000.00, 10);
INSERT INTO Bicicletas (ID, ModeloID, Precio, Stock) VALUES (2, 2, 1100.00, 15);
INSERT INTO Bicicletas (ID, ModeloID, Precio, Stock) VALUES (3, 3, 1200.00, 20);
INSERT INTO Bicicletas (ID, ModeloID, Precio, Stock) VALUES (4, 4, 1300.00, 5);
INSERT INTO Bicicletas (ID, ModeloID, Precio, Stock) VALUES (5, 5, 1400.00, 8);

-- Clientes
INSERT INTO Clientes (ID, Nombre, CorreoElectronico, Telefono, CiudadID) VALUES (1, 'Juan Perez', 'juan.perez@example.com', '3001234567', 1);
INSERT INTO Clientes (ID, Nombre, CorreoElectronico, Telefono, CiudadID) VALUES (2, 'Maria Gomez', 'maria.gomez@example.com', '3011234567', 2);
INSERT INTO Clientes (ID, Nombre, CorreoElectronico, Telefono, CiudadID) VALUES (3, 'Carlos Sanchez', 'carlos.sanchez@example.com', '3021234567', 3);
INSERT INTO Clientes (ID, Nombre, CorreoElectronico, Telefono, CiudadID) VALUES (4, 'Ana Ruiz', 'ana.ruiz@example.com', '3031234567', 4);
INSERT INTO Clientes (ID, Nombre, CorreoElectronico, Telefono, CiudadID) VALUES (5, 'Luis Herrera', 'luis.herrera@example.com', '3041234567', 5);

-- Ventas
INSERT INTO Ventas (ID, Fecha, ClienteID, Total) VALUES (1, '2024-01-01', 1, 2000.00);
INSERT INTO Ventas (ID, Fecha, ClienteID, Total) VALUES (2, '2024-01-02', 2, 2200.00);
INSERT INTO Ventas (ID, Fecha, ClienteID, Total) VALUES (3, '2024-01-03', 3, 2400.00);
INSERT INTO Ventas (ID, Fecha, ClienteID, Total) VALUES (4, '2024-01-04', 4, 2600.00);
INSERT INTO Ventas (ID, Fecha, ClienteID, Total) VALUES (5, '2024-01-05', 5, 2800.00);

-- DetallesVentas
INSERT INTO DetallesVentas (ID, VentaID, BicicletaID, Cantidad, PrecioUnitario) VALUES (1, 1, 1, 2, 1000.00);
INSERT INTO DetallesVentas (ID, VentaID, BicicletaID, Cantidad, PrecioUnitario) VALUES (2, 2, 2, 2, 1100.00);
INSERT INTO DetallesVentas (ID, VentaID, BicicletaID, Cantidad, PrecioUnitario) VALUES (3, 3, 3, 2, 1200.00);
INSERT INTO DetallesVentas (ID, VentaID, BicicletaID, Cantidad, PrecioUnitario) VALUES (4, 4, 4, 2, 1300.00);
INSERT INTO DetallesVentas (ID, VentaID, BicicletaID, Cantidad, PrecioUnitario) VALUES (5, 5, 5, 2, 1400.00);

-- Proveedores
INSERT INTO Proveedores (ID, Nombre, Contacto, Telefono, CorreoElectronico, CiudadID) VALUES (1, 'Proveedor 1', 'Contacto 1', '3101234567', 'contacto1@proveedor.com', 1);
INSERT INTO Proveedores (ID, Nombre, Contacto, Telefono, CorreoElectronico, CiudadID) VALUES (2, 'Proveedor 2', 'Contacto 2', '3111234567', 'contacto2@proveedor.com', 2);
INSERT INTO Proveedores (ID, Nombre, Contacto, Telefono, CorreoElectronico, CiudadID) VALUES (3, 'Proveedor 3', 'Contacto 3', '3121234567', 'contacto3@proveedor.com', 3);
INSERT INTO Proveedores (ID, Nombre, Contacto, Telefono, CorreoElectronico, CiudadID) VALUES (4, 'Proveedor 4', 'Contacto 4', '3131234567', 'contacto4@proveedor.com', 4);
INSERT INTO Proveedores (ID, Nombre, Contacto, Telefono, CorreoElectronico, CiudadID) VALUES (5, 'Proveedor 5', 'Contacto 5', '3141234567', 'contacto5@proveedor.com', 5);

-- Repuestos
INSERT INTO Repuestos (ID, Nombre, Descripcion, Precio, Stock, ProveedorID) VALUES (1, 'Repuesto 1', 'Descripcion 1', 50.00, 100, 1);
INSERT INTO Repuestos (ID, Nombre, Descripcion, Precio, Stock, ProveedorID) VALUES (2, 'Repuesto 2', 'Descripcion 2', 60.00, 200, 2);
INSERT INTO Repuestos (ID, Nombre, Descripcion, Precio, Stock, ProveedorID) VALUES (3, 'Repuesto 3', 'Descripcion 3', 70.00, 300, 3);
INSERT INTO Repuestos (ID, Nombre, Descripcion, Precio, Stock, ProveedorID) VALUES (4, 'Repuesto 4', 'Descripcion 4', 80.00, 400, 4);
INSERT INTO Repuestos (ID, Nombre, Descripcion, Precio, Stock, ProveedorID) VALUES (5, 'Repuesto 5', 'Descripcion 5', 90.00, 500, 5);

-- Compras
INSERT INTO Compras (ID, Fecha, ProveedorID, Total) VALUES (1, '2024-01-01', 1, 5000.00);
INSERT INTO Compras (ID, Fecha, ProveedorID, Total) VALUES (2, '2024-01-02', 2, 6000.00);
INSERT INTO Compras (ID, Fecha, ProveedorID, Total) VALUES (3, '2024-01-03', 3, 7000.00);
INSERT INTO Compras (ID, Fecha, ProveedorID, Total) VALUES (4, '2024-01-04', 4, 8000.00);
INSERT INTO Compras (ID, Fecha, ProveedorID, Total) VALUES (5, '2024-01-05', 5, 9000.00);

-- DetallesCompras
INSERT INTO DetallesCompras (ID, CompraID, RepuestoID, Cantidad, PrecioUnitario) VALUES (1, 1, 1, 50, 50.00);
INSERT INTO DetallesCompras (ID, CompraID, RepuestoID, Cantidad, PrecioUnitario) VALUES (2, 2, 2, 60, 60.00);
INSERT INTO DetallesCompras (ID, Compra

