-- =====================================================================
-- Proyecto : empresa-retail-admin
-- Archivo  : 03_usuarios.sql
-- Objetivo : Crear los usuarios por rol, asignarles su rol y dejarlo
--            activo por defecto al iniciar sesión.
--            Se eliminan primero para quitar cualquier permiso directo
--            que tuvieran de pruebas anteriores: así cada usuario queda
--            SOLO con los permisos de su rol.
-- =====================================================================

DROP USER IF EXISTS 'ana_crm'@'localhost',
                    'pedro_mkt'@'localhost',
                    'marta_auditoria'@'localhost';

-- 1. Creación de usuarios
CREATE USER 'ana_crm'@'localhost'         IDENTIFIED BY 'Retail2026!Caja';
CREATE USER 'pedro_mkt'@'localhost'       IDENTIFIED BY 'Retail2026!Stock';
CREATE USER 'marta_auditoria'@'localhost' IDENTIFIED BY 'Retail2026!Admin';

-- 2. Asignación del rol a cada usuario
GRANT 'rol_cajas'      TO 'ana_crm'@'localhost';
GRANT 'rol_inventario' TO 'pedro_mkt'@'localhost';
GRANT 'rol_gerencia'   TO 'marta_auditoria'@'localhost';

-- 3. Rol activo automáticamente al conectarse
SET DEFAULT ROLE 'rol_cajas'      TO 'ana_crm'@'localhost';
SET DEFAULT ROLE 'rol_inventario' TO 'pedro_mkt'@'localhost';
SET DEFAULT ROLE 'rol_gerencia'   TO 'marta_auditoria'@'localhost';

FLUSH PRIVILEGES;
