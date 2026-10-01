-- =====================================================================
-- Proyecto : empresa-retail-admin
-- Archivo  : 04_verificacion.sql
-- Objetivo : Revisar usuarios, roles y permisos efectivos.
-- =====================================================================

-- Usuarios y su rol por defecto
SELECT u.user AS usuario, u.host, d.default_role_user AS rol_por_defecto
FROM mysql.user u
LEFT JOIN mysql.default_roles d ON d.user = u.user AND d.host = u.host
WHERE u.user IN ('ana_crm', 'pedro_mkt', 'marta_auditoria');

-- Permisos efectivos de cada usuario (incluye los heredados del rol)
SHOW GRANTS FOR 'ana_crm'@'localhost'         USING 'rol_cajas';
SHOW GRANTS FOR 'pedro_mkt'@'localhost'       USING 'rol_inventario';
SHOW GRANTS FOR 'marta_auditoria'@'localhost' USING 'rol_gerencia';
