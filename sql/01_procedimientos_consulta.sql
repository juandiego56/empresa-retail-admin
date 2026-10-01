-- =====================================================================
-- Proyecto : empresa-retail-admin
-- Archivo  : 01_procedimientos_consulta.sql
-- Base     : `empresa-retail-db` (MySQL 8.0, Linux Mint)
-- Objetivo : Procedimientos almacenados de CONSULTA sobre conversiones
--            para Gerencia (marta_auditoria). Se suman al procedimiento
--            existente sp_select_conversion.
--            SQL SECURITY DEFINER: se ejecutan con los permisos de quien
--            los creó, así marta solo necesita EXECUTE sobre cada uno.
-- Ejecutar : en MySQL Workbench como root (Ctrl+Shift+Enter)
-- =====================================================================

USE `empresa-retail-db`;

DROP PROCEDURE IF EXISTS sp_resumen_conversiones;
DROP PROCEDURE IF EXISTS sp_conversiones_por_tipo;
DROP PROCEDURE IF EXISTS sp_conversiones_por_periodo;

DELIMITER //

-- 1. Totales por tipo de conversión (compra, registro, suscripcion)
CREATE PROCEDURE sp_resumen_conversiones()
    READS SQL DATA
    SQL SECURITY DEFINER
    COMMENT 'Consulta: cantidad y valor total de conversiones por tipo'
BEGIN
    SELECT con_tipo        AS tipo,
           COUNT(*)        AS cantidad,
           SUM(con_valor)  AS valor_total
    FROM conversion
    GROUP BY con_tipo
    ORDER BY con_tipo;
END //

-- 2. Conversiones de un tipo específico
CREATE PROCEDURE sp_conversiones_por_tipo(IN p_tipo VARCHAR(20))
    READS SQL DATA
    SQL SECURITY DEFINER
    COMMENT 'Consulta: conversiones filtradas por tipo'
BEGIN
    IF LOWER(p_tipo) NOT IN ('compra', 'registro', 'suscripcion') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tipo no valido. Use compra, registro o suscripcion';
    END IF;

    SELECT con_id_conversion, con_tipo, con_valor, con_fecha
    FROM conversion
    WHERE con_tipo = LOWER(p_tipo)
    ORDER BY con_fecha;
END //

-- 3. Conversiones entre dos fechas
CREATE PROCEDURE sp_conversiones_por_periodo(IN p_desde DATE, IN p_hasta DATE)
    READS SQL DATA
    SQL SECURITY DEFINER
    COMMENT 'Consulta: conversiones en un rango de fechas'
BEGIN
    SELECT con_id_conversion, con_tipo, con_valor, con_fecha
    FROM conversion
    WHERE con_fecha BETWEEN p_desde AND p_hasta
    ORDER BY con_fecha;
END //

DELIMITER ;
