#!/usr/bin/env bash
# =====================================================================
# Proyecto : empresa-retail-admin
# Archivo  : scripts/probar_permisos.sh
# Objetivo : Conectarse como cada usuario a `empresa-retail-db` y
#            comprobar que puede hacer lo permitido y que MySQL le
#            niega lo no permitido. Los registros de prueba se borran
#            al final con el mismo usuario que los creó.
# Uso      : bash scripts/probar_permisos.sh
# =====================================================================

DB="empresa-retail-db"
OK=0; FALLAS=0

probar () {
  local usuario="$1" clave="$2" descripcion="$3" sql="$4" esperado="$5"
  local salida resultado
  salida=$(MYSQL_PWD="$clave" mysql -u "$usuario" -D "$DB" -e "$sql" 2>&1)
  if echo "$salida" | grep -q "ERROR"; then resultado="DENEGADO"; else resultado="PERMITIDO"; fi
  if [ "$resultado" = "$esperado" ]; then marca="OK"; OK=$((OK+1)); else marca="FALLA"; FALLAS=$((FALLAS+1)); fi
  printf "  [%-5s] %-50s -> %s\n" "$marca" "$descripcion" "$resultado"
}

A='Retail2026!Caja'; P='Retail2026!Stock'; M='Retail2026!Admin'

echo "== ana_crm (Cajas) =="
probar ana_crm "$A" "Ver clientes"               "SELECT COUNT(*) FROM cliente" PERMITIDO
probar ana_crm "$A" "Registrar cliente"          "INSERT INTO cliente (cli_nombre,cli_apellido,cli_correo,cli_telefono,cli_ciudad,cli_fecha_registro) VALUES ('Prueba','Cajas','prueba.cajas@test.com','3000000000','Bogota',CURDATE())" PERMITIDO
probar ana_crm "$A" "Editar cliente"             "UPDATE cliente SET cli_ciudad='Cali' WHERE cli_correo='prueba.cajas@test.com'" PERMITIDO
probar ana_crm "$A" "Registrar interaccion"      "INSERT INTO interaccion (int_tipo,int_fecha,campania_cam_id_campania,cliente_cli_id_cliente) VALUES ('visita',CURDATE(),1,1)" PERMITIDO
probar ana_crm "$A" "Ver interacciones"          "SELECT COUNT(*) FROM interaccion" PERMITIDO
probar ana_crm "$A" "Ejecutar sp_select_cliente" "CALL sp_select_cliente()" PERMITIDO
probar ana_crm "$A" "Ver campanias"              "SELECT * FROM campania" DENEGADO
probar ana_crm "$A" "Ver conversiones"           "SELECT * FROM conversion" DENEGADO

echo "== pedro_mkt (Inventario) =="
probar pedro_mkt "$P" "Ver canales"              "SELECT COUNT(*) FROM canal" PERMITIDO
probar pedro_mkt "$P" "Crear canal"              "INSERT INTO canal (can_nombre,can_tipo) VALUES ('Canal de prueba','Email')" PERMITIDO
probar pedro_mkt "$P" "Crear campania"           "INSERT INTO campania (cam_nombre,cam_presupuesto,cam_fecha_inicio,cam_fecha_final,canal_can_id_canal) VALUES ('Campania de prueba',1000000,CURDATE(),CURDATE(),1)" PERMITIDO
probar pedro_mkt "$P" "Editar campania"          "UPDATE campania SET cam_presupuesto=2000000 WHERE cam_nombre='Campania de prueba'" PERMITIDO
probar pedro_mkt "$P" "Ejecutar sp_count_canal"  "CALL sp_count_canal(@n); SELECT @n" PERMITIDO
probar pedro_mkt "$P" "Ver clientes"             "SELECT COUNT(*) FROM cliente" PERMITIDO
probar pedro_mkt "$P" "Editar cliente"           "UPDATE cliente SET cli_ciudad='Cali' WHERE cli_id_cliente=1" DENEGADO
probar pedro_mkt "$P" "Borrar cliente"           "DELETE FROM cliente WHERE cli_id_cliente=1" DENEGADO
probar pedro_mkt "$P" "Ver conversiones"         "SELECT * FROM conversion" DENEGADO

echo "== marta_auditoria (Gerencia) =="
probar marta_auditoria "$M" "Ver conversiones"                    "SELECT COUNT(*) FROM conversion" PERMITIDO
probar marta_auditoria "$M" "Ejecutar sp_select_conversion"       "CALL sp_select_conversion()" PERMITIDO
probar marta_auditoria "$M" "Ejecutar sp_resumen_conversiones"    "CALL sp_resumen_conversiones()" PERMITIDO
probar marta_auditoria "$M" "Ejecutar sp_conversiones_por_tipo"   "CALL sp_conversiones_por_tipo('compra')" PERMITIDO
probar marta_auditoria "$M" "Ejecutar sp_conversiones_por_periodo" "CALL sp_conversiones_por_periodo('2026-01-01','2026-12-31')" PERMITIDO
probar marta_auditoria "$M" "Modificar conversion"                "UPDATE conversion SET con_valor=0 WHERE con_id_conversion=1" DENEGADO
probar marta_auditoria "$M" "Ejecutar sp_delete_conversion"       "CALL sp_delete_conversion(1)" DENEGADO
probar marta_auditoria "$M" "Ver clientes"                        "SELECT * FROM cliente" DENEGADO
probar marta_auditoria "$M" "Ejecutar sp_select_cliente"          "CALL sp_select_cliente()" DENEGADO

# Limpieza de los registros de prueba (cada usuario borra lo suyo)
MYSQL_PWD="$A" mysql -u ana_crm -D "$DB" -e "
  DELETE FROM interaccion WHERE int_id_interaccion = (SELECT m FROM (SELECT MAX(int_id_interaccion) m FROM interaccion WHERE int_tipo='visita' AND int_fecha=CURDATE() AND cliente_cli_id_cliente=1) x);
  DELETE FROM cliente WHERE cli_correo='prueba.cajas@test.com';" 2>/dev/null
MYSQL_PWD="$P" mysql -u pedro_mkt -D "$DB" -e "
  DELETE FROM campania WHERE cam_nombre='Campania de prueba';
  DELETE FROM canal WHERE can_nombre='Canal de prueba';" 2>/dev/null

echo
echo "Resultado: $OK pruebas correctas, $FALLAS fallas."
