USE IN5BM_KinalMall;

-- -----------------------------------------------------
-- PROCEDURE Administracion
-- -----------------------------------------------------
-- Reporte
DROP PROCEDURE IF EXISTS sp_ReporteAdministracionEmpleadosPorId;
DELIMITER $$
CREATE PROCEDURE sp_ReporteAdministracionEmpleadosPorId(IN _id INT)
BEGIN
	-- operador tenario $F{lunes}  ? "Si" : "No" en iReport en cada valor 
    SELECT e.id AS idEmpleado,e.nombres,e.apellidos,e.email,e.telefono AS telefonoEmpleado,e.fechaContratacion,e.sueldo,
    d.nombre As nombreDepartamento,c.nombre AS nombreCargo, h.horarioEntrada, h.horarioSalida,
    a.id AS idAdministracion,a.telefono AS telefonoAdministracion,a.direccion
    FROM empleados e
    INNER JOIN Departamentos d ON e.codigoDepartamento =d.id
    INNER JOIN cargos c ON e.codigoCargo = c.id
    INNER JOIN Horarios h ON e.codigoHorario=h.id
    INNER JOIN Administracion a ON e.codigoAdministracion=a.id
    WHERE a.id=_id;
    
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ListarAdministracion;
DELIMITER $$
CREATE PROCEDURE sp_ListarAdministracion()
BEGIN
	SELECT 
		Administracion.id, 
        Administracion.direccion, 
        Administracion.telefono 
	FROM Administracion;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_BuscarAdministracion;
DELIMITER $$
CREATE PROCEDURE sp_BuscarAdministracion(IN _id INT)
BEGIN
	SELECT 
		Administracion.id, 
        Administracion.direccion, 
        Administracion.telefono 
	FROM Administracion
    WHERE id = _id;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarAdministracion; 
DELIMITER $$
CREATE PROCEDURE sp_AgregarAdministracion (
	IN _direccion VARCHAR(100), 
	IN _telefono VARCHAR(8)
)
BEGIN
	INSERT INTO Administracion (direccion, telefono) 
    VALUES (_direccion, _telefono);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EditarAdministracion;
DELIMITER $$
CREATE PROCEDURE sp_EditarAdministracion (
	IN _id INT,
	IN _direccion VARCHAR(100),
    IN _telefono VARCHAR(8)
)
BEGIN
	UPDATE Administracion 
    SET 
		direccion = _direccion, 
		telefono = _telefono 
    WHERE id = _id;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarAdministracion;
DELIMITER $$
CREATE PROCEDURE sp_EliminarAdministracion (IN _id INT)
BEGIN
	DELETE FROM Administracion WHERE id = _id;
END $$
DELIMITER ;


-- -----------------------------------------------------
-- PROCEDURE CARGOS
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_ListarCargos;
DELIMITER $$
CREATE PROCEDURE sp_ListarCargos()
BEGIN
	SELECT
		Cargos.id,
		Cargos.nombre
	FROM Cargos;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_BuscarCargos;
DELIMITER $$
CREATE PROCEDURE sp_BuscarCargos(IN _id INT)
BEGIN
	SELECT
		Cargos.id,
		Cargos.nombre
	FROM Cargos
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarCargos;
DELIMITER $$
CREATE PROCEDURE sp_AgregarCargos(
	IN _nombre VARCHAR(45)
)
BEGIN
	INSERT INTO Cargos(nombre)
	VALUES (_nombre);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_EditarCargos;
DELIMITER $$
CREATE PROCEDURE sp_EditarCargos(
	IN _id INT,
	IN _nombre VARCHAR(45)
)
BEGIN
	UPDATE Cargos
	SET
		nombre = _nombre
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarCargos;
DELIMITER $$
CREATE PROCEDURE sp_EliminarCargos(IN _id INT)
BEGIN
	DELETE FROM Cargos WHERE id = _id;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- PROCEDURE Locales
-- -----------------------------------------------------
select * from cuentasPorcobrar where codigoLocal =1;
DROP PROCEDURE IF EXISTS sp_LocalesDisponibles;
SELECT COUNT(*)FROM cuentasPorCobrar WHERE codigoLocal = 1 AND estadoPago='Pendiente';
-- reporte
DROP TRIGGER IF EXISTS tr_CuentasPorCobrar_After_Insert;
DELIMITER $$
CREATE TRIGGER tr_CuentasPorCobrar_After_Insert
AFTER INSERT ON  CuentasPorCobrar
FOR EACH ROW
BEGIN
	DECLARE _mesesPendientes INT;
	SET _mesesPendientes=(SELECT COUNT(*)FROM cuentasPorCobrar WHERE codigoLocal = NEW.codigoLocal AND estadoPago='Pendiente');
    
    UPDATE Locales l SET mesesPendientes=_mesesPendientes WHERE l.id=NEW.codigoLocal;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS tr_CuentasPorCobrar_After_Update;
DELIMITER $$
CREATE TRIGGER tr_CuentasPorCobrar_After_Update
AFTER UPDATE ON  CuentasPorCobrar
FOR EACH ROW
BEGIN
	DECLARE _mesesPendientes INT;
	SET _mesesPendientes=(SELECT COUNT(*)FROM cuentasPorCobrar WHERE codigoLocal = NEW.codigoLocal AND estadoPago='Pendiente');
    
    UPDATE Locales l SET mesesPendientes=_mesesPendientes WHERE l.id=NEW.codigoLocal;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS tr_CuentasPorCobrar_After_Delete;
DELIMITER $$
CREATE TRIGGER tr_CuentasPorCobrar_After_Delete
AFTER DELETE ON  CuentasPorCobrar
FOR EACH ROW
BEGIN
	DECLARE _mesesPendientes INT;
	SET _mesesPendientes=(SELECT COUNT(*)FROM cuentasPorCobrar WHERE codigoLocal = OLD.codigoLocal AND estadoPago='Pendiente');
    
    UPDATE Locales l SET mesesPendientes=_mesesPendientes WHERE l.id=OLD.codigoLocal;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_BuscarClientes;
DELIMITER $$
CREATE PROCEDURE sp_BuscarClientes(IN _id INT)
BEGIN
	SELECT 
		Clientes.id,
        Clientes.nombres,
        Clientes.apellidos,
        Clientes.telefono,
        Clientes.direccion,
        Clientes.email,
        Clientes.codigoTipoCliente
	FROM Clientes
	WHERE id = _id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_LocalesDisponibles()
BEGIN
	SELECT count(L.disponibilidad) as disponibilidad 
    FROM Locales L 
    where disponibilidad= false ;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ListarLocales;
DELIMITER $$
CREATE PROCEDURE sp_ListarLocales()
BEGIN
	SELECT
		Locales.id,
		Locales.saldoFavor,
		Locales.saldoContra,
		Locales.mesesPendientes,
		Locales.disponibilidad,
		Locales.valorLocal,
		Locales.valorAdministracion
	FROM Locales;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_BuscarLocales;
DELIMITER $$
CREATE PROCEDURE sp_BuscarLocales(IN _id INT)
BEGIN
	SELECT
		Locales.id,
		Locales.saldoFavor,
		Locales.saldoContra,
		Locales.mesesPendientes,
		Locales.disponibilidad,
		Locales.valorLocal,
		Locales.valorAdministracion
	FROM Locales
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarLocales;
DELIMITER $$
CREATE PROCEDURE sp_AgregarLocales(
	IN _saldoFavor DECIMAL(11,2),
	IN _saldoContra DECIMAL(11,2),
	IN _mesesPendientes INT,
	IN _disponibilidad BOOLEAN,
	IN _valorLocal DECIMAL(11,2),
	IN _valorAdministracion DECIMAL(11,2))
BEGIN
	INSERT INTO Locales(saldoFavor, saldoContra, mesesPendientes, disponibilidad, valorLocal, valorAdministracion )
	VALUES (_saldoFavor, _saldoContra, _mesesPendientes, _disponibilidad, _valorLocal, _valorAdministracion);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EditarLocales;
DELIMITER $$
CREATE PROCEDURE sp_EditarLocales(
	IN _id INT,
	IN _saldoFavor DECIMAL(11,2),
	IN _saldoContra DECIMAL(11,2),
	IN _mesesPendientes INT,
	IN _disponibilidad BOOLEAN,
	IN _valorLocal DECIMAL(11,2),
	IN _valorAdministracion DECIMAL(11,2))
BEGIN
	UPDATE Locales
	SET
		saldoFavor = _saldoFavor,
		saldoContra = _saldoContra,
		mesesPendientes = _mesesPendientes,
		disponibilidad = _disponibilidad,
		valorLocal = _valorLocal,
		valorAdministracion = _valorAdministracion
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarLocales;
DELIMITER $$
CREATE PROCEDURE sp_EliminarLocales(IN _id INT)
BEGIN
	DELETE FROM Locales WHERE id = _id;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- PROCEDURE TipoCliente
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_ListarTipoCliente;
DELIMITER $$
CREATE PROCEDURE sp_ListarTipoCliente()
BEGIN
	SELECT
		TipoCliente.id,
		TipoCliente.descripcion
	FROM TipoCliente;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_BuscarTipoCliente;
DELIMITER $$
CREATE PROCEDURE sp_BuscarTipoCliente(IN _id INT)
BEGIN
	SELECT
		TipoCliente.id,
		TipoCliente.descripcion
	FROM TipoCliente
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarTipoCliente;
DELIMITER $$
CREATE PROCEDURE sp_AgregarTipoCliente(
	IN _descripcion VARCHAR(45)
)
BEGIN
	INSERT INTO TipoCLiente(descripcion)
	VALUES (_descripcion);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_EditarTipoCliente;
DELIMITER $$
CREATE PROCEDURE sp_EditarTipoCliente(
	IN _id INT,
	IN _descripcion VARCHAR(45)
)
BEGIN
	UPDATE TipoCliente
	SET
		descripcion = _descripcion
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarTipoCliente;
DELIMITER $$
CREATE PROCEDURE sp_EliminarTipoCliente(IN _id INT)
BEGIN
	DELETE FROM TipoCliente WHERE id = _id;
END$$
DELIMITER ;


-- -----------------------------------------------------
-- PROCEDURE Cliente
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_ListarClientes;
DELIMITER $$
CREATE PROCEDURE sp_ListarClientes()
BEGIN
	SELECT 
		Clientes.id,
        Clientes.nombres,
        Clientes.apellidos,
        Clientes.telefono,
        Clientes.direccion,
        Clientes.email,
        Clientes.codigoTipoCliente
	FROM Clientes;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReporteClientes;
DELIMITER $$
CREATE PROCEDURE sp_ReporteClientes()
BEGIN
	-- operador tenario $F{lunes}  ? "Si" : "No" en iReport en cada valor 
	SELECT c.id,c.nombres,c.apellidos,c.telefono,c.direccion,c.email,t.descripcion AS tipoCliente 
    FROM clientes c INNER JOIN TipoCliente t ON c.codigoTipoCliente = t.id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_BuscarClientes;
DELIMITER $$
CREATE PROCEDURE sp_BuscarClientes(IN _id INT)
BEGIN
	SELECT 
		Clientes.id,
        Clientes.nombres,
        Clientes.apellidos,
        Clientes.telefono,
        Clientes.direccion,
        Clientes.email,
        Clientes.codigoTipoCliente
	FROM Clientes
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarClientes;
DELIMITER $$
CREATE PROCEDURE sp_AgregarClientes(
    IN _nombres VARCHAR(45),
    IN _apellidos VARCHAR(45),
    IN _telefono VARCHAR(8),
    IN _direccion VARCHAR(100),
    IN _email VARCHAR(45),
    IN _codigoTipoCliente INT
)
BEGIN
	INSERT INTO Clientes(nombres, apellidos, telefono, direccion, email, codigoTipoCliente)
	VALUES (_nombres, _apellidos, _telefono, _direccion, _email, _codigoTipoCliente);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EditarClientes;
DELIMITER $$
CREATE PROCEDURE sp_EditarClientes(
	IN _id INT,
    IN _nombres VARCHAR(45),
    IN _apellidos VARCHAR(45),
    IN _telefono VARCHAR(8),
    IN _direccion VARCHAR(100),
    IN _email VARCHAR(45),
    IN _codigoTipoCliente INT
)
BEGIN
	UPDATE Clientes
	SET
		nombres = _nombres, 
        apellidos = _apellidos, 
        telefono = _telefono, 
        direccion = _direccion, 
        email = _email, 
        codigoTipoCliente = _codigoTipoCliente
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarClientes;
DELIMITER $$
CREATE PROCEDURE sp_EliminarClientes(IN _id INT)
BEGIN
	DELETE FROM Clientes WHERE id = _id;
END$$
DELIMITER ;



-- -----------------------------------------------------
-- PROCEDURE DEPARTAMENTOS
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_ListarDepartamentos;
DELIMITER $$
CREATE PROCEDURE sp_ListarDepartamentos()
BEGIN
	SELECT
		Departamentos.id,
		Departamentos.nombre
	FROM Departamentos;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_BuscarDepartamentos;
DELIMITER $$
CREATE PROCEDURE sp_BuscarDepartamentos(IN _id INT)
BEGIN
	SELECT
		Departamentos.id,
		Departamentos.nombre
	FROM Departamentos
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarDepartamentos;
DELIMITER $$
CREATE PROCEDURE sp_AgregarDepartamentos(
	IN _nombre VARCHAR(45)
)
BEGIN
	INSERT INTO Departamentos(nombre)
	VALUES (_nombre);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_EditarDepartamentos;
DELIMITER $$
CREATE PROCEDURE sp_EditarDepartamentos(
	IN _id INT,
	IN _nombre VARCHAR(45)
)
BEGIN
	UPDATE Departamentos
	SET
		nombre = _nombre
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarDepartamentos;
DELIMITER $$
CREATE PROCEDURE sp_EliminarDepartamentos(IN _id INT)
BEGIN
	DELETE FROM Departamentos WHERE id = _id;
END$$
DELIMITER ;




-- -----------------------------------------------------
-- PROCEDURE PROVEEDORES
-- -----------------------------------------------------
-- Agregar
DROP PROCEDURE IF EXISTS sp_AgregarProveedores;
DELIMITER $$
	CREATE PROCEDURE sp_AgregarProveedores(
	IN _nit VARCHAR(45) , 
    IN _servicioPrestado VARCHAR(45), 
    IN _telefono VARCHAR(8), 
    IN _direccion VARCHAR(60),
    IN _saldoFavor DECIMAL(11,2), 
    IN _saldoContra DECIMAL(11,2))
    BEGIN
		INSERT INTO Proveedores(nit,servicioPrestado,telefono,direccion,saldoFavor,saldoContra) 
		VALUES(_nit,_servicioPrestado,_telefono,_direccion,_saldoFavor, _saldoContra);	
    END $$
DELIMITER ;
-- Listar
DROP PROCEDURE IF EXISTS sp_ListarProveedores;
DELIMITER $$
CREATE PROCEDURE sp_ListarProveedores()
	BEGIN
		SELECT
		Proveedores.id,Proveedores.nit,Proveedores.servicioPrestado,Proveedores.telefono,
        Proveedores.direccion,Proveedores.saldoFavor,Proveedores.saldoContra
		FROM Proveedores;
	END $$
DELIMITER ;
-- SELECT
DROP PROCEDURE IF EXISTS sp_BuscarProveedores;
DELIMITER $$
	CREATE PROCEDURE sp_BuscarProveedores(IN _id INT)
    BEGIN
		SELECT Proveedores.id,Proveedores.nit,Proveedores.servicioPrestado,Proveedores.telefono,Proveedores.direccion,
        Proveedores.saldoFavor,Proveedores.saldoContra
        FROM Proveedores 
        WHERE id=_id;
    END $$
DELIMITER ;
-- UPDATE
DROP PROCEDURE IF EXISTS sp_EditarProveedores;
DELIMITER $$
	CREATE PROCEDURE sp_EditarProveedores(IN _id INT,IN _nit VARCHAR(45) , IN _servicioPrestado VARCHAR(45), 
    IN _telefono VARCHAR(8), IN _direccion VARCHAR(60),IN _saldoFavor DECIMAL(11,2), 
    IN _saldoContra DECIMAL(11,2))
    BEGIN
		UPDATE Proveedores SET nit=_nit,servicioPrestado= _servicioPrestado,telefono=_telefono,
        direccion=_direccion,saldoFavor=_saldoFavor,saldoContra=_saldoContra
        WHERE id=_id;
    END $$
DELIMITER ;
-- DELETE
DROP PROCEDURE IF EXISTS sp_EliminarProveedores;
DELIMITER $$
	CREATE PROCEDURE sp_EliminarProveedores(IN _id INT)
    BEGIN
		DELETE FROM Proveedores WHERE id = _id;
    END $$
DELIMITER ;



-- -----------------------------------------------------
-- PROCEDURE CuentasPorCobrar
-- -----------------------------------------------------
-- Listar
DROP PROCEDURE IF EXISTS sp_ListarCuentasPorCobrar;
DELIMITER $$
CREATE PROCEDURE sp_ListarCuentasPorCobrar()
	BEGIN
		SELECT
		CuentasPorCobrar.id,CuentasPorCobrar.numeroFactura,CuentasPorCobrar.anio,CuentasPorCobrar.mes,
        CuentasPorCobrar.valorNetoPago,CuentasPorCobrar.estadoPago,CuentasPorCobrar.codigoAdministracion,
        CuentasPorCobrar.codigoCliente,CuentasPorCobrar.codigoLocal
		FROM CuentasPorCobrar;
	END $$
DELIMITER ;

-- Reporte
DROP PROCEDURE IF EXISTS sp_ReporteCuentasPorCobrar;
DELIMITER $$
CREATE PROCEDURE sp_ReporteCuentasPorCobrar()
BEGIN
	-- operador tenario $F{lunes}  ? "Si" : "No" en iReport en cada valor 
	SELECT  
		c.id,c.numeroFactura,CONCAT(c.anio,"/",c.mes)AS mesAnio,c.valorNetoPago,c.estadoPago,a.direccion,
		CONCAT(ci.nombres," ",ci.apellidos) AS Nombre,ci.telefono,l.valorLocal,l.valorAdministracion,l.mesesPendientes
    FROM CuentasPorCobrar c 
    INNER JOIN Administracion a ON c.codigoAdministracion = a.id
    INNER JOIN Clientes ci ON c.codigoCliente = ci.id
    INNER JOIN Locales l ON c.codigoLocal = l.id;
    
END $$
DELIMITER ;

-- Agregar
DROP PROCEDURE IF EXISTS sp_AgregarCuentasPorCobrar;
DELIMITER $$
	CREATE PROCEDURE sp_AgregarCuentasPorCobrar(IN _numeroFactura VARCHAR(45) ,IN _anio YEAR(4) ,
    IN _mes INT(2) ,IN _valorNetoPago DECIMAL(11,2),IN _estadoPago VARCHAR(45),
    IN _codigoAdministracion INT ,IN _codigoClientes INT ,IN _codigoLocal INT)
    BEGIN
		INSERT INTO CuentasPorCobrar(numeroFactura,anio,mes,valorNetoPago,
        estadoPago,codigoAdministracion,codigoCliente,codigoLocal) 
		VALUES(_numeroFactura , _anio,_mes ,_valorNetoPago ,
        _estadoPago,_codigoAdministracion, _codigoClientes ,_codigoLocal);	
    END $$
DELIMITER ;
-- SELECT
DROP PROCEDURE IF EXISTS sp_BuscarCuentasPorCobrar;
DELIMITER $$
	CREATE PROCEDURE sp_BuscarCuentasPorCobrar(IN _id INT)
    BEGIN
		SELECT CuentasPorCobrar.id,CuentasPorCobrar.numeroFactura,CuentasPorCobrar.anio,CuentasPorCobrar.mes,
        CuentasPorCobrar.valorNetoPago,CuentasPorCobrar.estadoPago,
        CuentasPorCobrar.codigoAdministracion,CuentasPorCobrar.codigoCliente,CuentasPorCobrar.codigoLocal
        FROM CuentasPorCobrar 
        WHERE id=_id;
    END $$
DELIMITER ;
-- UPDATE
DROP PROCEDURE IF EXISTS sp_EditarCuentasPorCobrar;
DELIMITER $$
	CREATE PROCEDURE sp_EditarCuentasPorCobrar(IN _id INT,IN _numeroFactura VARCHAR(45) ,IN _anio YEAR(4) ,
    IN _mes INT(2) ,IN _valorNetoPago DECIMAL(11,2),IN _estadoPago VARCHAR(45),
    IN _codigoAdministracion INT ,IN _codigoClientes INT ,IN _codigoLocal INT)
    BEGIN
		UPDATE CuentasPorCobrar SET numeroFactura=_numeroFactura,anio=_anio,mes=_mes,
        valorNetoPago=_valorNetoPago,estadoPago=_estadoPago,codigoAdministracion=_codigoAdministracion,
        codigoCliente=_codigoClientes,codigoLocal=_codigoLocal
        WHERE id=_id;
    END $$
DELIMITER ;
-- DELETE
DROP PROCEDURE IF EXISTS sp_EliminarCuentasPorCobrar;
DELIMITER $$
	CREATE PROCEDURE sp_EliminarCuentasPorCobrar(IN _id INT)
    BEGIN
		DELETE FROM CuentasPorCobrar WHERE id = _id;
    END $$
DELIMITER ;



-- -----------------------------------------------------
-- PROCEDURE CuentasPorPagar
-- -----------------------------------------------------
-- Reporte
DROP PROCEDURE IF EXISTS sp_ReporteCuentasPorPagar ;
DELIMITER $$
CREATE PROCEDURE sp_ReporteCuentasPorPagar()
BEGIN
	-- operador tenario $F{lunes}  ? "Si" : "No" en iReport en cada valor 
    SELECT c.id,c.numeroFactura,c.fechaLimitePago,c.estadoPago,c.valorNetoPago,a.direccion,p.nit AS nitProveedor, 
    p.servicioPrestado,p.saldoFavor,p.saldoContra
    FROM CuentasPorPagar c
    INNER JOIN Administracion a ON c.codigoAdministracion=a.id
    INNER JOIN Proveedores p ON c.codigoProveedor =p.id ;
    
END $$
DELIMITER ;
-- Agregar
DROP PROCEDURE IF EXISTS sp_AgregarCuentasPorPagar;
DELIMITER $$
	CREATE PROCEDURE sp_AgregarCuentasPorPagar(IN _numeroFactura VARCHAR(45) ,
    IN _fechaLimitePago DATE, IN _estadoPago VARCHAR(45), IN _valorNetoPago DECIMAL(11,2),
    IN _codigoAdministracion INT, IN _codigoProveedor INT)
    BEGIN
		INSERT INTO CuentasPorPagar(numeroFactura,fechaLimitePago,estadoPago,valorNetoPago,
        codigoAdministracion,codigoProveedor) 
		VALUES(_numeroFactura,_fechaLimitePago,_estadoPago,_valorNetoPago,
        _codigoAdministracion,_codigoProveedor);	
    END $$
DELIMITER ;
-- Listar
DROP PROCEDURE IF EXISTS sp_ListarCuentasPorPagar;
DELIMITER $$
CREATE PROCEDURE sp_ListarCuentasPorPagar()
	BEGIN
		SELECT CuentasPorPagar.id,CuentasPorPagar.numeroFactura,CuentasPorPagar.fechaLimitePago,
        CuentasPorPagar.estadoPago,CuentasPorPagar.valorNetoPago,CuentasPorPagar.codigoAdministracion,
        CuentasPorPagar.codigoProveedor
		FROM CuentasPorPagar;
	END $$
DELIMITER ;
-- SELECT
DROP PROCEDURE IF EXISTS sp_BuscarCuentasPorPagar;
DELIMITER $$
	CREATE PROCEDURE sp_BuscarCuentasPorPagar(IN _id INT)
    BEGIN
		SELECT CuentasPorPagar.id,CuentasPorPagar.numeroFactura,CuentasPorPagar.fechaLimitePago,CuentasPorPagar.estadoPago,
        CuentasPorPagar.valorNetoPago,CuentasPorPagar.codigoAdministracion,
        CuentasPorPagar.codigoProveedor
        FROM CuentasPorPagar 
        WHERE id=_id;
    END $$
DELIMITER ;
-- UPDATE
DROP PROCEDURE IF EXISTS sp_EditarCuentasPorPagar;
DELIMITER $$
	CREATE PROCEDURE sp_EditarCuentasPorPagar(IN _id INT,IN _numeroFactura VARCHAR(45) ,
    IN _fechaLimitePago DATE, IN _estadoPago VARCHAR(45), IN _valorNetoPago DECIMAL(11,2),
    IN _codigoAdministracion INT, IN _codigoProveedor INT)
    BEGIN
		UPDATE CuentasPorPagar SET numeroFactura=_numeroFactura,fechaLimitePago=_fechaLimitePago,
        estadoPago=_estadoPago,valorNetoPago=_valorNetoPago,
        codigoAdministracion=_codigoAdministracion,codigoProveedor=_codigoProveedor
        WHERE id=_id;
    END $$
DELIMITER ;
-- DELETE
DROP PROCEDURE IF EXISTS sp_EliminarCuentasPorPagar;
DELIMITER $$
	CREATE PROCEDURE sp_EliminarCuentasPorPagar(IN _id INT)
    BEGIN
		DELETE FROM CuentasPorPagar WHERE id = _id;
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDURE HORARIOS
-- -----------------------------------------------------
DROP PROCEDURE IF EXISTS sp_ListarHorarios;
DELIMITER $$
CREATE PROCEDURE sp_ListarHorarios()
BEGIN
	SELECT
		Horarios.id,
		Horarios.horarioEntrada,
        Horarios.horarioSalida,
        Horarios.lunes,
        Horarios.martes,
        Horarios.miercoles,
        Horarios.jueves,
        Horarios.viernes
	FROM Horarios;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ReporteHorarios;
DELIMITER $$
CREATE PROCEDURE sp_ReporteHorarios()
BEGIN
	-- operador tenario $F{lunes}  ? "Si" : "No" en iReport en cada valor 
	SELECT
		h.id,
		h.horarioEntrada,
		h.horarioSalida,
		CASE WHEN h.lunes= 'FALSE' THEN 'No' ELSE 'Si' END AS Lunes,
		CASE WHEN h.martes= 'FALSE' THEN 'No' ELSE 'Si' END AS Martes,
		CASE WHEN h.miercoles = 'FALSE' THEN 'No' ELSE 'Si' END AS Miercoles,
		CASE WHEN h.jueves= 'FALSE' THEN 'No' ELSE 'Si' END AS Jueves,
		CASE WHEN h.viernes = 'FALSE' THEN 'No' ELSE 'Si' END AS Viernes
	FROM horarios h;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_BuscarHorarios;
DELIMITER $$
CREATE PROCEDURE sp_BuscarHorarios(IN _id INT)
BEGIN
	SELECT
		Horarios.id,
		Horarios.horarioEntrada,
        Horarios.horarioSalida,
        Horarios.lunes,
        Horarios.martes,
        Horarios.miercoles,
        Horarios.jueves,
        Horarios.viernes
	FROM Horarios
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_AgregarHorarios;
DELIMITER $$
CREATE PROCEDURE sp_AgregarHorarios(
	IN _horarioEntrada TIME,
	IN _horarioSalida TIME,
	IN _lunes BOOLEAN,
	IN _martes BOOLEAN,
	IN _miercoles BOOLEAN,
	IN _jueves BOOLEAN,
	IN _viernes BOOLEAN
)
BEGIN
	INSERT INTO Horarios(horarioEntrada,horarioSalida,lunes,martes,miercoles,jueves,viernes)
	VALUES (_horarioEntrada,_horarioSalida,_lunes,_martes,_miercoles,_jueves,_viernes);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_EditarHorarios;
DELIMITER $$
CREATE PROCEDURE sp_EditarHorarios(
	IN _id INT,
	IN _horarioEntrada TIME,
	IN _horarioSalida TIME,
	IN _lunes BOOLEAN,
	IN _martes BOOLEAN,
	IN _miercoles BOOLEAN,
	IN _jueves BOOLEAN,
	IN _viernes BOOLEAN
)
BEGIN
	UPDATE Horarios
	SET
		horarioEntrada=_horarioEntrada,horarioSalida=_horarioSalida,
        lunes=_lunes,martes=_martes,miercoles=_miercoles,
        jueves=_jueves,viernes=_viernes
	WHERE id = _id;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_EliminarHorarios;
DELIMITER $$
CREATE PROCEDURE sp_EliminarHorarios(IN _id INT)
BEGIN
	DELETE FROM Horarios WHERE id = _id;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- PROCEDURE Empleados
-- -----------------------------------------------------
-- Reporte
DROP PROCEDURE IF EXISTS sp_ReporteEmpleados;
DELIMITER $$
CREATE PROCEDURE sp_ReporteEmpleados()
BEGIN
	-- operador tenario $F{lunes}  ? "Si" : "No" en iReport en cada valor 
    SELECT e.id,CONCAT(e.nombres," ",e.apellidos) AS nombre,e.email,e.telefono,e.fechaContratacion,e.sueldo,
    d.nombre As nombreDepartamento,c.nombre AS nombreCargo, h.horarioEntrada, h.horarioSalida,
    a.direccion
    FROM empleados e
    INNER JOIN Departamentos d ON e.codigoDepartamento =d.id
    INNER JOIN cargos c ON e.codigoCargo = c.id
    INNER JOIN Horarios h ON e.codigoHorario=h.id
    INNER JOIN Administracion a ON e.codigoAdministracion=a.id;
    
END $$
DELIMITER ;

-- Agregar
DROP PROCEDURE IF EXISTS sp_AgregarEmpleados;
DELIMITER $$
	CREATE PROCEDURE sp_AgregarEmpleados(IN _nombre VARCHAR(45),
    IN _apellido VARCHAR(45) ,IN _email VARCHAR(45) ,
    IN _telefono VARCHAR(8) ,IN _fechaContratacion DATE ,IN _sueldo DECIMAL(11,2),
	IN _codigoDepartamento INT,IN _codigoCargo INT, IN _codigoHorario INT, IN _codigoAdministracion INT)
    BEGIN
		INSERT INTO Empleados(nombres,apellidos,email,telefono,fechaContratacion,
        sueldo,codigoDepartamento,codigoCargo,codigoHorario,codigoAdministracion) 
		VALUES(_nombre,_apellido,_email,_telefono,_fechaContratacion,
        _sueldo,_codigoDepartamento,_codigoCargo,_codigoHorario,_codigoAdministracion);	
    END $$
DELIMITER ;
-- Listar
DROP PROCEDURE IF EXISTS sp_ListarEmpleados;
DELIMITER $$
CREATE PROCEDURE sp_ListarEmpleados()
	BEGIN
		SELECT Empleados.id,Empleados.nombres,Empleados.apellidos,Empleados.email,Empleados.telefono,
        Empleados.fechaContratacion,Empleados.sueldo,Empleados.codigoDepartamento,Empleados.codigoCargo,
        Empleados.codigoHorario,Empleados.codigoAdministracion
		FROM Empleados;
	END $$
DELIMITER ;
-- SELECT
DROP PROCEDURE IF EXISTS sp_BuscarEmpleados;
DELIMITER $$
	CREATE PROCEDURE sp_BuscarEmpleados(IN _id INT)
    BEGIN
		SELECT Empleados.id,Empleados.nombres,Empleados.apellidos,Empleados.email,Empleados.telefono,
        Empleados.fechaContratacion,Empleados.sueldo,Empleados.codigoDepartamento,Empleados.codigoCargo,
        Empleados.codigoHorario,Empleados.codigoAdministracion
		FROM Empleados
        WHERE id=_id;
    END $$
DELIMITER ;
-- UPDATE
DROP PROCEDURE IF EXISTS sp_EditarEmpleados;
DELIMITER $$
	CREATE PROCEDURE sp_EditarEmpleados(IN _id INT,IN _nombre VARCHAR(45),
    IN _apellido VARCHAR(45) ,IN _email VARCHAR(45) ,
    IN _telefono VARCHAR(8) ,IN _fechaContratacion DATE ,IN _sueldo DECIMAL(11,2),
	IN _codigoDepartamento INT,IN _codigoCargo INT, IN _codigoHorario INT, IN _codigoAdministracion INT)
    BEGIN
		UPDATE Empleados SET nombres=_nombre,apellidos=_apellido,email=_email,
        telefono=_telefono,fechaContratacion=_fechaContratacion,
        sueldo=_sueldo,codigoDepartamento=_codigoDepartamento,codigoCargo=_codigoCargo,
        codigoHorario=_codigoHorario,codigoAdministracion=_codigoAdministracion
        WHERE id=_id;
    END $$
DELIMITER ;
-- DELETE
DROP PROCEDURE IF EXISTS sp_EliminarEmpleados;
DELIMITER $$
	CREATE PROCEDURE sp_EliminarEmpleados(IN _id INT)
    BEGIN
		DELETE FROM Empleados WHERE id = _id;
    END $$
DELIMITER ;
-- -----------------------------------------------------
-- Usuario
-- -----------------------------------------------------

DROP PROCEDURE IF EXISTS sp_BuscarUsuario;
DELIMITER $$
	CREATE PROCEDURE sp_BuscarUsuario(IN _usuario VARCHAR(45))
    BEGIN
		SELECT user ,pass,nombre,r.id AS rol FROM Usuario  
		INNER JOIN Rol r on rol=r.id
        WHERE user = _usuario;
	END $$
DELIMITER ;

-- Agregar
DROP PROCEDURE IF EXISTS sp_AgregarUsuario;
DELIMITER $$
	CREATE PROCEDURE sp_AgregarUsuario(IN _usuario VARCHAR(100),
    IN _contrasena VARCHAR(100), IN _nombre VARCHAR(50),IN _codigoRol INT)
    BEGIN
		INSERT INTO Usuario(user,pass,nombre,rol) 
		VALUES(_usuario,_contrasena,_nombre,_codigoRol);	
    END $$
DELIMITER ;

-- -----------------------------------------------------
-- Datos de prueba
-- -----------------------------------------------------
INSERT INTO Rol(descripcion) VALUES("Administrador");
INSERT INTO Rol(descripcion) VALUES("Vendedor");

call sp_AgregarUsuario("root", "YWRtaW4=", "Jorge Pérez", 1);-- admin
call sp_AgregarUsuario("kinal", "MTIzNDU=", "Luis Canto", 2);-- 12345
call sp_AgregarUsuario("mRosales","YWRtaW4=","Maria Rosales",1); -- admin
call sp_AgregarUsuario("aMontenegro","MTIzNDU=","Abigail Montenegro",2); -- 12345
call sp_AgregarUsuario("sRoca","OTg4OQ==","Susana Roca",2); -- 9889

call sp_AgregarAdministracion("7ma calle 12-33 residencial San Martín zona 1, Guatemala","41248036");
call sp_AgregarAdministracion("6A Avenida 13-54,Edificio Kinal","22306602");
call sp_AgregarAdministracion("5A Calle 4-33,Edificio Rabí","22446609");
call sp_AgregarAdministracion("1a. calle 2-63 y 2-47 Zona 10 Guatemala,DollarCity","98658745");
call sp_AgregarAdministracion("5ta. Calle Final 18-00 zona 1 Guatemala,Guardia General","33208590");
call sp_AgregarAdministracion("Avenida Reforma, 0-63 Zona 10, Ciudad de Guatemala","12548795");
call sp_AgregarAdministracion("6a. avenida Zona 1, Ciudad de Guatemala","22359841");
call sp_AgregarAdministracion("24 calle 3-81 de la Zona 1, Ciudad de Guatemala","21357541");
call sp_AgregarAdministracion("11 calle 25 - 50 Kaminal Juyú II, Zona 7,Guatemala","11967541");
call sp_AgregarAdministracion("9a. avenida entre 6a. y 8a. calle Zona 1,Ciudad Guatemala","11967541");

call sp_AgregarCargos("Director Ejecutivo");
call sp_AgregarCargos("Director de Operaciones");
call sp_AgregarCargos("Director Comercial");
call sp_AgregarCargos("Director de Marketing");
call sp_AgregarCargos("Director de Recursos Humanos");
call sp_AgregarCargos("Customer Success");
call sp_AgregarCargos("Director Financiero");
call sp_AgregarCargos("Director General");
call sp_AgregarCargos("Director de bondega");
call sp_AgregarCargos("Director de limpieza");

CALL sp_AgregarTipoCliente("Bronce");
CALL sp_AgregarTipoCliente("Plata");
CALL sp_AgregarTipoCliente("Oro");
CALL sp_AgregarTipoCliente("Diamante");
CALL sp_AgregarTipoCliente("Platinium");
CALL sp_AgregarTipoCliente("Plus");
CALL sp_AgregarTipoCliente("Premium");

CALL sp_AgregarClientes("Carlos","Aceituno","21249860","Zona 1,Guatemala","carlos@gmail.com",1);
CALL sp_AgregarClientes("Fatima","Aguilar","31247860","Zona 2,Guatemala","Fatima@gmail.com",1);
CALL sp_AgregarClientes("Carlos","Santos","41747800","Zona 3,Guatemala","Santos@gmail.com",1);
CALL sp_AgregarClientes("Nicole","Aguilar","41947810","Zona 3,Guatemala","Nicole@gmail.com",1);
CALL sp_AgregarClientes("Rosa","Ramos","51947900","Zona 7,Guatemala","Rosa@gmail.com",2);
CALL sp_AgregarClientes("Mariana","Perez","91748803","Zona 5,Guatemala","Mariana@gmail.com",3);
CALL sp_AgregarClientes("Kimberly","Loaiza","51849811","Zona 6,Guatemala","Kimberly@gmail.com",5);
CALL sp_AgregarClientes("Renato","Salguero","81447830","Zona 9,Guatemala","Renato@gmail.com",2);
CALL sp_AgregarClientes("Alex","Ramos","71849810","Zona 10,Guatemala","Alex@gmail.com",4);
CALL sp_AgregarClientes("Salma","Hayek","81229800","Zona 12,Guatemala","Salma@gmail.com",3);

CALL sp_AgregarLocales(5000.00, 7000.00, 1, false, 20000.00, 1000.00);
CALL sp_AgregarLocales(1000.00, 1000.00, 0, false, 50000.00, 1000.00);
CALL sp_AgregarLocales(1001.00, 1200.00, 0, true, 50500.00, 1000.00);
CALL sp_AgregarLocales(2000.00, 2000.00, 0, true, 2030.00 ,3000.00);
CALL sp_AgregarLocales(3000.00, 500.00, 2, false, 3000.00, 5000.00);
CALL sp_AgregarLocales(500.00, 3000.00, 3 , true, 600.00, 900.00);
CALL sp_AgregarLocales(4000.00, 7000.00, 1 , false, 3000.00,100.00);
CALL sp_AgregarLocales(5000.00, 300.00,0, false, 6000.00,1000.00);
CALL sp_AgregarLocales(9000.00,8000.00,0,true,8000.00,5000.00);
CALL sp_AgregarLocales(7000.00,500.00,0, false, 9000.00,8000.00);

CALL  sp_AgregarCuentasPorCobrar(1,2020,06,1050,"cancelado",1,1,1);
CALL  sp_AgregarCuentasPorCobrar("A-200",2021,07,2000,"pendiente",4,3,1);
CALL  sp_AgregarCuentasPorCobrar("A-230",2021,08,3000,"cancelado",5,2,3);
CALL  sp_AgregarCuentasPorCobrar("A-222",2021,06,1000,"pendiente",7,6,1);
CALL  sp_AgregarCuentasPorCobrar("A-250",2021,04,3500,"pendiente",2,5,1);
CALL  sp_AgregarCuentasPorCobrar("A-260",2021,05,4500,"cancelado",1,3,5);
CALL  sp_AgregarCuentasPorCobrar("A-299",2021,03,1050,"pendiente",3,2,1);
CALL  sp_AgregarCuentasPorCobrar("A-300",2021,06,1300,"cancelado",5,4,9);
CALL  sp_AgregarCuentasPorCobrar("A-390",2021,05,2300,"pendiente",9,10,2);
CALL  sp_AgregarCuentasPorCobrar("A-400",2021,01,3050,"cancelado",10,9,8);

CALL sp_AgregarProveedores("123987-2","Destruibudor de carros","12659874","6ta ave 3-24 zona 1 Ciudad de Guatemala",1000,500);
CALL sp_AgregarProveedores("3265987-2","Destruibudor General","22659074","8a. Avenida 14-12 Zona 1 Ciudad de Guatemala",1000,230);
CALL sp_AgregarProveedores("33065987-2","Servicio tecnico","98659274","4ta calle 7-46 zona 1 Ciudad de Guatemala",2300,350);
CALL sp_AgregarProveedores("06525987-2","Mecanico","21659874","4ta calle 7-46 zona 1 Ciudad de Guatemala",4000,3500);
CALL sp_AgregarProveedores("96525987-2","Exportador","36985487","6a. Avenida 1-88 Zona 1 Ciudad de Guatemala",5000,3580);
CALL sp_AgregarProveedores("025895987-2","Distribuidor de ropa","32651487","9A calle y 9A avenida, zona 1 Ciudad de Guatemala",2000,1500);
CALL sp_AgregarProveedores("36695987-2","Servicio de internet","87546291","6A Calle zona 1 Ciudad de Guatemala",3000,500);
CALL sp_AgregarProveedores("125485987-2","Servicio de limpieza","98715462","10.ª calle 9-42 zona 1 Ciudad de Guatemala",3000,0);
CALL sp_AgregarProveedores("36987987-2","Distribuidor de llantas","25369841"," A Calle & Avenida Juan Chapin Ciudad de Guatemala",1000,500);
CALL sp_AgregarProveedores("965841987-2","Distruibuidor de fruta","21540236","12 calle zona 1 Ciudad de Guatemala",2030,520);

CALL sp_AgregarCuentasPorPagar("B-300", "2021-05-16", "Candelado", 1500, 2, 1);
CALL sp_AgregarCuentasPorPagar("B-322", "2021-06-22", "pendiente", 1230, 4, 2);
CALL sp_AgregarCuentasPorPagar("B-311", "2021-04-18", "pendiente", 2950, 9, 3);
CALL sp_AgregarCuentasPorPagar("B-344", "2021-07-11", "pendiente", 7500, 10, 4);
CALL sp_AgregarCuentasPorPagar("B-355", "2021-08-12", "Candelado", 8580, 3, 5);
CALL sp_AgregarCuentasPorPagar("B-377", "2021-06-30", "pendiente", 3500, 6, 6);
CALL sp_AgregarCuentasPorPagar("B-398", "2021-04-29", "Candelado", 3500, 8, 7);
CALL sp_AgregarCuentasPorPagar("B-375", "2021-02-26", "pendiente", 3000, 4, 8);
CALL sp_AgregarCuentasPorPagar("B-320", "2021-07-27", "Candelado", 6000, 9, 9);
CALL sp_AgregarCuentasPorPagar("B-312", "2021-09-28", "Candelado", 2550, 10, 10);

CALL sp_AgregarDepartamentos("Gerencia");
CALL sp_AgregarDepartamentos("Financiero");
CALL sp_AgregarDepartamentos("Recursos Humanos");
CALL sp_AgregarDepartamentos("Marketing");
CALL sp_AgregarDepartamentos("Comercial");
CALL sp_AgregarDepartamentos("Compras");
CALL sp_AgregarDepartamentos("Logística y Operaciones");
CALL sp_AgregarDepartamentos("Control de Gestión");
CALL sp_AgregarDepartamentos("Comité de Dirección");
CALL sp_AgregarDepartamentos("Dirección General");

CALL sp_AgregarHorarios("12:00:00","13:00:00",false,true,false,true,false);
CALL sp_AgregarHorarios("1:00:00","14:20:00",true,true,false,true,true);
CALL sp_AgregarHorarios("6:00:00","13:00:00",false,true,true,false,false);
CALL sp_AgregarHorarios("7:30:00","15:20:00",true,true,false,true,false);
CALL sp_AgregarHorarios("5:30:00","13:00:00",false,true,true,true,false);
CALL sp_AgregarHorarios("11:00:00","18:30:00",false,true,false,true,false);
CALL sp_AgregarHorarios("9:00:00","12:00",true,true,false,true,false);
CALL sp_AgregarHorarios("10:00:00","1:00:00",true,true,false,true,false);
CALL sp_AgregarHorarios("7:00:00","17:00:00",false,false,false,true,false);
CALL sp_AgregarHorarios("5:00:00","16:00:00",true,false,true,true,false);

CALL sp_AgregarEmpleados("Maria","Rosales","Maria@gmail.com","21549870","2021/02/18",3500,2,2,10,2);
CALL sp_AgregarEmpleados("Abigail","Montenegro","Abigail@gmail.com","21659874","2021/07/05",5000,6,8,6,3);
CALL sp_AgregarEmpleados("Susana","Roca","Susana@gmail.com","36251498","2021/08/09",7000,5,6,9,8);
CALL sp_AgregarEmpleados("Talia","Perez","Talia@gmail.com","98875421","2021/07/10",8000,10,8,3,7);
CALL sp_AgregarEmpleados("Jasmin","Barrera","Jasmin@gmail.com","36985421","2021/07/26",3520,8,9,1,6);
CALL sp_AgregarEmpleados("Rodrigo","Salvatierra","Rodrigo@gmail.com","30215487","2021/09/05",6300,7,10,2,7);
CALL sp_AgregarEmpleados("Renato","Cervantes","Renato@gmail.com","65489754","2021/07/11",4300,2,5,7,2);
CALL sp_AgregarEmpleados("Cesar","Galvez","Cesar@gmail.com","30215487","2021/07/25",5600,1,6,9,1);
CALL sp_AgregarEmpleados("Fernanda","Sanchez","Fernanda@gmail.com","32659847","2021/10/09",5420,3,7,3,7);
CALL sp_AgregarEmpleados("Elizabeth","Jaime","Elizabeth@gmail.com","20548710","2021/07/06",7200,4,3,1,6);