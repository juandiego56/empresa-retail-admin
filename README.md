# empresa-retail-admin

Proyecto final de **seguridad de bases de datos**: configuración de usuarios, roles y permisos para la base de datos **`empresa-retail-db`** (empresa retail) en **MySQL 8.0 sobre Linux Mint**, dividiendo las responsabilidades entre el personal de **Cajas**, **Inventario** y **Gerencia** bajo el principio de **mínimo privilegio**.

## Objetivo

Que cada área de la empresa acceda únicamente a la información que necesita:

| Área       | Usuario           | Rol              | Permisos |
|------------|-------------------|------------------|----------|
| Cajas      | `ana_crm`         | `rol_cajas`      | Lectura y escritura en **cliente** e **interaccion** |
| Inventario | `pedro_mkt`       | `rol_inventario` | Lectura y escritura en **canal** y **campania**; **solo lectura** en cliente |
| Gerencia   | `marta_auditoria` | `rol_gerencia`   | **Solo lectura** en **conversion** (compra, registro, suscripción) y ejecución de procedimientos almacenados de consulta |

## Base de datos `empresa-retail-db`

| Tabla         | Contenido |
|---------------|-----------|
| `cliente`     | Datos de los clientes (nombre, apellido, correo, teléfono, ciudad, fecha de registro) |
| `interaccion` | Interacciones del cliente con las campañas: clic, visita, comentario, descarga |
| `canal`       | Canales de marketing: Red Social, Buscador, Email |
| `campania`    | Campañas con presupuesto, fechas y canal |
| `conversion`  | Resultados de las campañas: compra, registro o suscripción |

La base incluye procedimientos CRUD (`sp_select_*`, `sp_insert_*`, `sp_update_*`, `sp_delete_*`, `sp_count_canal`). Este proyecto agrega tres procedimientos de consulta para Gerencia: `sp_resumen_conversiones`, `sp_conversiones_por_tipo` y `sp_conversiones_por_periodo`.

## Estructura del repositorio

```
empresa-retail-admin/
├── README.md
├── .gitignore
├── sql/
│   ├── 01_procedimientos_consulta.sql  # Procedimientos de consulta para Gerencia
│   ├── 02_roles_y_permisos.sql         # Roles y GRANT por área
│   ├── 03_usuarios.sql                 # Usuarios, asignación de rol y rol por defecto
│   └── 04_verificacion.sql             # Revisión de permisos efectivos
├── scripts/
│   └── probar_permisos.sh              # Prueba lo permitido y lo denegado por usuario
└── docs/
    └── Documento_tecnico_empresa_retail.docx
```

## Requisitos

- Linux Mint con MySQL Server 8.0 y MySQL Workbench
- La base `empresa-retail-db` creada con sus tablas y procedimientos
- Git

## Ejecución

1. Abrir MySQL Workbench con el usuario `root`.
2. Abrir y ejecutar en orden (`Ctrl + Shift + Enter`): `01`, `02`, `03` y `04` de la carpeta `sql/`.
3. Probar los permisos desde la terminal:

```bash
cd ~/empresa-retail-admin
bash scripts/probar_permisos.sh
```

Conexión manual con cada usuario:

```bash
mysql -u ana_crm -p empresa-retail-db           # Retail2026!Caja
mysql -u pedro_mkt -p empresa-retail-db         # Retail2026!Stock
mysql -u marta_auditoria -p empresa-retail-db   # Retail2026!Admin
```

> Las contraseñas aparecen porque son parte del enunciado académico. En un entorno real nunca deben guardarse en un repositorio.

## Ramas

- `main`: versión estable con README.md y .gitignore.
- `develop`: rama de trabajo con la solución de la actividad.

## Autor

Proyecto académico — Administración y seguridad de bases de datos, 2026.
