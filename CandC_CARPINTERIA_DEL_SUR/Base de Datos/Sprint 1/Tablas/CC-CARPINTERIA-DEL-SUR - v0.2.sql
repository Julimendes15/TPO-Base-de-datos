CREATE DATABASE CC_CARPINTERÍA_DEL_SUR;

USE CC_CARPINTERÍA_DEL_SUR;


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

    -- email debe ser de dominio permitido
    CONSTRAINT ck_cliente_email
        CHECK (
            email LIKE '%@gmail.com%' 
            OR email LIKE '%@outlook.com%' 
            OR email LIKE '%@yahoo.com%'
        )
);


-- TABLA PEDIDO

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


-- TABLA FACTURA

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

    -- Tipo válido
    CONSTRAINT ck_factura_tipo 
        CHECK (tipo IN ('A','B','C')),

    -- Relación 1:1 (cada pedido tiene una sola factura)
    CONSTRAINT uq_factura_pedido UNIQUE (id_pedido),

    -- Evita duplicar misma factura fiscal
    CONSTRAINT uq_factura_fiscal UNIQUE (tipo, punto_venta, numero)
);


-- TABLA DOMICILIO

CREATE TABLE Domicilio (
    id_domicilio INT IDENTITY(1,1) PRIMARY KEY,
    calle NVARCHAR(100) NOT NULL,
    numero NVARCHAR(10) NOT NULL,
    ciudad NVARCHAR(100) NOT NULL,
    provincia NVARCHAR(100) NOT NULL,
    codigo_postal NVARCHAR(20) NOT NULL,
    pais NVARCHAR(50) NOT NULL,
    tipo NVARCHAR(30) NOT NULL,     -- entrega / fiscal / retiro
    id_cliente INT NOT NULL,

    CONSTRAINT fk_domicilio_cliente
        FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);


-- TABLA CATEGORIA

CREATE TABLE Categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255) NOT NULL
);


-- TABLA PRODUCTO

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


-- TABLA PROVEEDOR

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


-- TABLA MATERIAL

CREATE TABLE Material (
    id_material INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    tipo NVARCHAR(50) NOT NULL,
    unidad_medida NVARCHAR(50) NOT NULL,        -- ej: 'm2', 'kg', 'lt'
    costo_unitario DECIMAL(12,2) NOT NULL CHECK (costo_unitario >= 0),
    fecha_ult_actualizacion DATE NOT NULL DEFAULT GETDATE(),
    activo BIT NOT NULL DEFAULT 1,
    id_proveedor INT NOT NULL,

    CONSTRAINT fk_material_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);


-- TABLA ORDEN DE COMPRA

CREATE TABLE OrdenCompra (
    id_orden_compra INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT GETDATE(),
    estado NVARCHAR(50) NOT NULL,
    total DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
    id_proveedor INT NOT NULL,

    CONSTRAINT fk_oc_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);


--------------------------------------------------------
-- 2) TABLAS INTERMEDIAS / DETALLE (relaciones N a N)
--    (las celestes en tu diagrama)
--------------------------------------------------------

-- TABLA DETALLEPEDIDO
-- Relaciona Pedido <-> Producto (ítems vendidos)

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


-- TABLA DETALLEFABRICACION
-- Relaciona Producto <-> Material (receta de fabricación)

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


-- TABLA DETALLECOMPRA
-- Relaciona OrdenCompra <-> Material (ítems comprados al proveedor)

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