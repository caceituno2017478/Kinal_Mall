DROP DATABASE IF EXISTS IN5BM_KinalMall;
CREATE DATABASE IN5BM_KinalMall;
USE IN5BM_KinalMall;

-- -----------------------------------------------------
-- Tabla Administracion
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS Administracion (
  id INT NOT NULL AUTO_INCREMENT,
  direccion VARCHAR(100) NOT NULL,
  telefono VARCHAR(8) NOT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla Cargos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cargos (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla TipoCliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TipoCliente (
  id INT NOT NULL AUTO_INCREMENT,
  descripcion VARCHAR(45) NOT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla Clientes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Clientes (
  id INT NOT NULL AUTO_INCREMENT,
  nombres VARCHAR(45) NOT NULL,
  apellidos VARCHAR(45) NOT NULL,
  telefono VARCHAR(8) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  email VARCHAR(45) NOT NULL,
  codigoTipoCliente INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_Clientes_TipoCliente
    FOREIGN KEY (codigoTipoCliente)
    REFERENCES TipoCliente (id) ON DELETE CASCADE);

CREATE INDEX FK_Clientes_TipoCliente ON Clientes (codigoTipoCliente ASC) VISIBLE;


-- -----------------------------------------------------
-- Tabla Locales
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Locales (
  id INT NOT NULL AUTO_INCREMENT,
  saldoFavor DECIMAL(11,2) NULL DEFAULT 0.00,
  saldoContra DECIMAL(11,2) NULL DEFAULT 0.00,
  mesesPendientes INT NULL DEFAULT NULL,
  disponibilidad BOOLEAN NOT NULL,
  valorLocal DECIMAL(11,2) NOT NULL,
  valorAdministracion DECIMAL(11,2) NOT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla CuentasPorCobrar
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CuentasPorCobrar (
  id INT NOT NULL AUTO_INCREMENT,
  numeroFactura VARCHAR(45) NOT NULL,
  anio YEAR NOT NULL,
  mes INT NOT NULL,
  valorNetoPago DECIMAL(11,2) NOT NULL,
  estadoPago VARCHAR(45) NOT NULL,
  codigoAdministracion INT NOT NULL,
  codigoCliente INT NOT NULL,
  codigoLocal INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_CuentasPorCobrar_Administracion
    FOREIGN KEY (codigoAdministracion)
    REFERENCES Administracion (id) ON DELETE CASCADE,
  CONSTRAINT FK_CuentasPorCobrar_Clientes
    FOREIGN KEY (codigoCliente)
    REFERENCES Clientes (id) ON DELETE CASCADE ,
  CONSTRAINT FK_CuentasPorCobrar_Locales
    FOREIGN KEY (codigoLocal)
    REFERENCES Locales (id) ON DELETE CASCADE);

CREATE INDEX FK_CuentasPorCobrar_Administracion ON CuentasPorCobrar (codigoAdministracion ASC) VISIBLE;

CREATE INDEX FK_CuentasPorCobrar_Clientes ON CuentasPorCobrar (codigoCliente ASC) VISIBLE;

CREATE INDEX FK_CuentasPorCobrar_Locales ON CuentasPorCobrar (codigoLocal ASC) VISIBLE;


-- -----------------------------------------------------
-- Tabla proveedores
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Proveedores (
  id INT NOT NULL AUTO_INCREMENT,
  nit VARCHAR(45) NOT NULL,
  servicioPrestado VARCHAR(45) NOT NULL,
  telefono VARCHAR(8) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  saldoFavor DECIMAL(11,2) NOT NULL,
  saldoContra DECIMAL(11,2) NOT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla CuentasPorPagar
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CuentasPorPagar (
  id INT NOT NULL AUTO_INCREMENT,
  numeroFactura VARCHAR(45) NOT NULL,
  fechaLimitePago DATE NOT NULL,
  estadoPago VARCHAR(45) NOT NULL,
  valorNetoPago DECIMAL(11,2) NOT NULL,
  codigoAdministracion INT NOT NULL,
  codigoProveedor INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_CuentasPorPagar_Administracion
    FOREIGN KEY (codigoAdministracion)
    REFERENCES Administracion (id) ON DELETE CASCADE,
  CONSTRAINT FK_CuentasPorPagar_Proveedores
    FOREIGN KEY (codigoProveedor)
    REFERENCES proveedores (id) ON DELETE CASCADE);

CREATE INDEX FK_CuentasPorPagar_Administracion ON CuentasPorPagar (codigoAdministracion ASC) VISIBLE;

CREATE INDEX FK_CuentasPorPagar_Proveedores ON CuentasPorPagar (codigoProveedor ASC) VISIBLE;


-- -----------------------------------------------------
-- Tabla Departamentos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Departamentos (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla Horarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Horarios (
  id INT NOT NULL AUTO_INCREMENT,
  horarioEntrada TIME NOT NULL,
  horarioSalida TIME NOT NULL,
  lunes BOOLEAN NULL DEFAULT NULL,
  martes BOOLEAN NULL DEFAULT NULL,
  miercoles BOOLEAN NULL DEFAULT NULL,
  jueves BOOLEAN NULL DEFAULT NULL,
  viernes BOOLEAN NULL DEFAULT NULL,
  PRIMARY KEY (id));


-- -----------------------------------------------------
-- Tabla Empleados
-- -----------------------------------------------------
DROP TABLE IF EXISTS Empleados;
CREATE TABLE IF NOT EXISTS Empleados (
  id INT NOT NULL AUTO_INCREMENT,
  nombres VARCHAR(45) NOT NULL,
  apellidos VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  telefono VARCHAR(8) NOT NULL,
  fechaContratacion DATE NOT NULL,
  sueldo DECIMAL(11,2) NOT NULL,
  codigoDepartamento INT NOT NULL,
  codigoCargo INT NOT NULL,
  codigoHorario INT NOT NULL,
  codigoAdministracion INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT FK_Empleados_Administracion
    FOREIGN KEY (codigoAdministracion)
    REFERENCES Administracion (id) ON DELETE CASCADE,
  CONSTRAINT FK_Empleados_Cargos
    FOREIGN KEY (codigoCargo)
    REFERENCES Cargos (id) ON DELETE CASCADE,
  CONSTRAINT FK_Empleados_Departamento
    FOREIGN KEY (codigoDepartamento)
    REFERENCES Departamentos (id) ON DELETE CASCADE,
  CONSTRAINT FK_Empleados_Horarios
    FOREIGN KEY (codigoHorario)
    REFERENCES Horarios (id) ON DELETE CASCADE);

CREATE INDEX FK_Empleados_Departamento ON Empleados (codigoDepartamento ASC) VISIBLE;

CREATE INDEX FK_Empleados_Cargos ON Empleados (codigoCargo ASC) VISIBLE;

CREATE INDEX FK_Empleados_Horarios ON Empleados (codigoHorario ASC) VISIBLE;

CREATE INDEX FK_Empleados_Administracion ON Empleados (codigoAdministracion ASC) VISIBLE;

DROP TABLE IF EXISTS Rol;
CREATE TABLE Rol(
	id INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(45) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS Usuario;
CREATE TABLE Usuario(
    user VARCHAR(255) NOT NULL,
    pass VARCHAR(255) NOT NULL,
    nombre varchar(100) not null,
    rol INT NOT NULL,
    PRIMARY KEY(user),
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (rol) REFERENCES Rol (id) ON DELETE CASCADE
);