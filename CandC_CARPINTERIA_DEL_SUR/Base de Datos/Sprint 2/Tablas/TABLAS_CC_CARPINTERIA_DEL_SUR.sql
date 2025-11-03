USE CC_CARPINTERÍA_DEL_SUR;
GO

/* CLIENTE */
CREATE TABLE Cliente (
    id_cliente INT IDENTITY(10000,1) PRIMARY KEY,
    tipo NVARCHAR(30) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    razon_social NVARCHAR(150) NOT NULL,
    doc_tipo NVARCHAR(20) NOT NULL,
    doc_numero NVARCHAR(20) NOT NULL,
    telefono NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    fecha_alta DATE NOT NULL DEFAULT GETDATE(),
    activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT ck_cliente_email
        CHECK (
            email LIKE '%@gmail.com%' 
            OR email LIKE '%@outlook.com%' 
            OR email LIKE '%@yahoo.com%'
        )
);
GO

/* CATEGORIA */
CREATE TABLE Categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NOT NULL
);
GO

/* PRODUCTO */
CREATE TABLE Producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    codigo NVARCHAR(50) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    precio_venta DECIMAL(12,2) NOT NULL CHECK (precio_venta >= 0),
    costo_produccion DECIMAL(12,2) NOT NULL CHECK (costo_produccion >= 0),
    stock DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo BIT NOT NULL DEFAULT 1,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);
GO

/* PROVEEDOR */
CREATE TABLE Proveedor (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    razon_social NVARCHAR(150) NOT NULL,
    cuit NVARCHAR(20) NOT NULL,
    telefono NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(200) NOT NULL,
    fecha_alta DATE NOT NULL DEFAULT GETDATE(),
    estado NVARCHAR(50) NOT NULL
);
GO

/* MATERIAL */
CREATE TABLE Material (
    id_material INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    tipo NVARCHAR(50) NOT NULL,
    unidad_medida NVARCHAR(50) NOT NULL,
    fecha_ult_actualizacion DATE NOT NULL DEFAULT GETDATE(),
    activo BIT NOT NULL DEFAULT 1,
    id_proveedor INT NOT NULL,
    CONSTRAINT fk_material_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);
GO

/* ORDEN DE COMPRA */
CREATE TABLE OrdenCompra (
    id_orden_compra INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT GETDATE(),
    estado NVARCHAR(50) NOT NULL,
    total DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
    id_proveedor INT NOT NULL,
    CONSTRAINT fk_oc_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);
GO

/* DETALLE COMPRA */
CREATE TABLE DetalleCompra (
    id_detalle_compra INT IDENTITY(1,1) PRIMARY KEY,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    costo_unitario DECIMAL(12,2) NOT NULL CHECK (costo_unitario >= 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    id_orden_compra INT NOT NULL,
    id_material INT NOT NULL,
    CONSTRAINT fk_detallecompra_oc
        FOREIGN KEY (id_orden_compra) REFERENCES OrdenCompra(id_orden_compra),
    CONSTRAINT fk_detallecompra_material
        FOREIGN KEY (id_material) REFERENCES Material(id_material)
);
GO

/* PEDIDO */
CREATE TABLE Pedido (
    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT GETDATE(),
    total_bruto DECIMAL(12,2) NOT NULL DEFAULT 0,
    descuento_total DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_neto DECIMAL(12,2) NOT NULL DEFAULT 0,
    estado NVARCHAR(50) NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);
GO

/* FACTURA */
CREATE TABLE Factura (
    id_factura INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT GETDATE(),
    tipo NVARCHAR(10) NOT NULL,
    punto_venta NVARCHAR(10) NOT NULL,
    numero NVARCHAR(20) NOT NULL,
    total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
    estado NVARCHAR(50) NOT NULL,
    id_pedido INT NOT NULL,
    CONSTRAINT fk_factura_pedido
        FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    CONSTRAINT ck_factura_tipo 
        CHECK (tipo IN ('A','B','C')),
    CONSTRAINT uq_factura_pedido UNIQUE (id_pedido),
    CONSTRAINT uq_factura_fiscal UNIQUE (tipo, punto_venta, numero)
);
GO

/* DOMICILIO */
CREATE TABLE Domicilio (
    id_domicilio INT IDENTITY(1,1) PRIMARY KEY,
    calle NVARCHAR(100) NOT NULL,
    numero NVARCHAR(10) NOT NULL,
    ciudad NVARCHAR(100) NOT NULL,
    provincia NVARCHAR(100) NOT NULL,
    codigo_postal NVARCHAR(20) NOT NULL,
    pais NVARCHAR(50) NOT NULL,
    tipo NVARCHAR(30) NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_domicilio_cliente
        FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);
GO

/* DETALLEPEDIDO */
CREATE TABLE DetallePedido (
    id_detalle_pedido INT IDENTITY(1,1) PRIMARY KEY,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (descuento >= 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT fk_detallepedido_pedido
        FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    CONSTRAINT fk_detallepedido_producto
        FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
GO

/* DETALLEFABRICACION */
CREATE TABLE DetalleFabricacion (
    id_detalle_fab INT IDENTITY(1,1) PRIMARY KEY,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    merma_pct DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (merma_pct >= 0),
    id_producto INT NOT NULL,
    id_material INT NOT NULL,
    CONSTRAINT fk_detallefab_producto
        FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    CONSTRAINT fk_detallefab_material
        FOREIGN KEY (id_material) REFERENCES Material(id_material)
);
GO

/* PROVEEDORMATERIAL */
CREATE TABLE ProveedorMaterial (
    id_proveedor INT NOT NULL,
    id_material INT NOT NULL, 
    costo_unitario DECIMAL(12,2) NOT NULL CHECK (costo_unitario >= 0),
    CONSTRAINT PK_ProveedorMaterial 
        PRIMARY KEY (id_proveedor, id_material),
    CONSTRAINT FK_PM_Proveedor 
        FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
    CONSTRAINT FK_PM_Material 
        FOREIGN KEY (id_material) REFERENCES Material(id_material)
);
GO

