-- =====================================================================
-- Proyecto : empresa-retail-admin
-- Archivo  : 02_roles_y_permisos.sql
-- Base     : `empresa-retail-db`
-- Objetivo : Crear un rol por área y asignarle permisos con el
--            principio de mínimo privilegio.
--
--   Rol             Área        Usuario          Permisos
--   --------------  ----------  ---------------  ------------------------------------------
--   rol_cajas       Cajas       ana_crm          cliente e interaccion: lectura y escritura
--   rol_inventario  Inventario  pedro_mkt        canal y campania: lectura y escritura
--                                                cliente: solo lectura
--   rol_gerencia    Gerencia    marta_auditoria  conversion: solo lectura
--                                                EXECUTE en procedimientos de consulta
-- =====================================================================

DROP ROLE IF EXISTS 'rol_cajas', 'rol_inventario', 'rol_gerencia';
CREATE ROLE 'rol_cajas', 'rol_inventario', 'rol_gerencia';

-- ---------------------------------------------------------------------
-- Rol de ana (Cajas): gestiona Clientes e Interacciones
-- Lectura = SELECT | Escritura = INSERT, UPDATE, DELETE
-- ---------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON `empresa-retail-db`.cliente     TO 'rol_cajas';
GRANT SELECT, INSERT, UPDATE, DELETE ON `empresa-retail-db`.interaccion TO 'rol_cajas';
-- Procedimientos CRUD existentes de sus tablas
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_select_cliente     TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_insert_cliente     TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_update_cliente     TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_delete_cliente     TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_select_interaccion TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_insert_interaccion TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_update_interaccion TO 'rol_cajas';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_delete_interaccion TO 'rol_cajas';

-- ---------------------------------------------------------------------
-- Rol de pedro (Inventario): gestiona Canales y Campañas,
-- y solo puede VER clientes (sin INSERT, UPDATE ni DELETE)
-- ---------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON `empresa-retail-db`.canal    TO 'rol_inventario';
GRANT SELECT, INSERT, UPDATE, DELETE ON `empresa-retail-db`.campania TO 'rol_inventario';
GRANT SELECT                         ON `empresa-retail-db`.cliente  TO 'rol_inventario';
-- Procedimientos CRUD de canal y campania, y solo la consulta de clientes
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_select_canal    TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_insert_canal    TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_update_canal    TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_delete_canal    TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_count_canal     TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_select_campania TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_insert_campania TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_update_campania TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_delete_campania TO 'rol_inventario';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_select_cliente  TO 'rol_inventario';

-- ---------------------------------------------------------------------
-- Rol de marta (Gerencia): solo ve Conversiones (compra, registro,
-- suscripcion) y usa procedimientos almacenados de consulta
-- ---------------------------------------------------------------------
GRANT SELECT ON `empresa-retail-db`.conversion TO 'rol_gerencia';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_select_conversion        TO 'rol_gerencia';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_resumen_conversiones     TO 'rol_gerencia';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_conversiones_por_tipo    TO 'rol_gerencia';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_conversiones_por_periodo TO 'rol_gerencia';
