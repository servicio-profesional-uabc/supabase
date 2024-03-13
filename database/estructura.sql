CREATE TYPE "riesgo" AS ENUM (
  'nulo',
  'leve',
  'moderado',
  'alto',
  'inminente'
);

CREATE TYPE "rol" AS ENUM (
  'admin',
  'psico'
);

CREATE TYPE "estado_solicitud" AS ENUM (
  'pendiente',
  'aceptada',
  'rechazada'
);

CREATE TABLE "pacientes" (
  "matricula" varchar(12) PRIMARY KEY,
  "nombres" varchar(30),
  "apellido" varchar(30),
  "edad" integer,
  "ocupacion" varchar,
  "carrera" integer,
  "telefono" varchar(12),
  "telefono_emergencia" varchar(12),
  "ciclo_ingreso" varchar,
  "nss" varchar(11),
  "created_at" timestamp DEFAULT 'now()'
);

CREATE TABLE "usuarios" (
  "id_empleado" uuid PRIMARY KEY,
  "matricula_empleado" varchar(12) UNIQUE,
  "rol" rol,
  "nombres" varchar(30),
  "apellido_paterno" varchar(30),
  "apellido_materno" varchar(30),
  "correo" varchar(50),
  "password" varchar(60),
  "telefono" varchar(12),
  "unidad_academica" integer
);

CREATE TABLE "expedientes" (
  "matricula" varchar(12) PRIMARY KEY,
  "nivel_riesgo" riesgo,
  "update_at" timestamp DEFAULT 'now()'
);

CREATE TABLE "accesosUnidades" (
  "expediente" varchar(12),
  "unidad_academica" integer,
  PRIMARY KEY ("expediente", "unidad_academica")
);

CREATE TABLE "ficha_sesion" (
  "id_ficha" INTEGER GENERATED BY DEFAULT AS IDENTITY,
  "matricula" varchar(12),
  "id_responsable" varchar(12),
  "situacion_actual" text,
  "acciones_sesion" text,
  "id_problematica" integer,
  "nivel_riesgo" riesgo,
  "documento" integer DEFAULT null,
  "created_at" timestamp DEFAULT 'now()',
  PRIMARY KEY ("id_ficha", "matricula")
);

CREATE TABLE "ficha_canalizacion" (
  "id_ficha" INTEGER GENERATED BY DEFAULT AS IDENTITY,
  "matricula" varchar(12),
  "id_responsable" varchar(12),
  "motivo_canalizacoin" text,
  "documento" integer DEFAULT null,
  "created_at" timestamp DEFAULT 'now()',
  PRIMARY KEY ("id_ficha", "matricula")
);

CREATE TABLE "documentos" (
  "id_documento" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "ruta_documento" varchar(30)
);

CREATE TABLE "problematicas" (
  "id_problematica" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "nombre_problematica" varchar(90)
);

CREATE TABLE "unidad_academica" (
  "id_unidad" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "nombre_unidad" varchar(60)
);

CREATE TABLE "carreras" (
  "id_carrera" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "id_unidad" integer,
  "nombre_carrera" varchar(50)
);

CREATE TABLE "solicitudes" (
  "expediente" varchar(12),
  "unidad_solicitante" integer,
  "estado" estado_solicitud,
  PRIMARY KEY ("expediente", "unidad_solicitante")
);

COMMENT ON COLUMN "usuarios"."id_empleado" IS 'Campo empleado para los usuarios con supabase';

ALTER TABLE "pacientes" ADD FOREIGN KEY ("carrera") REFERENCES "carreras" ("id_carrera");

ALTER TABLE "usuarios" ADD FOREIGN KEY ("unidad_academica") REFERENCES "unidad_academica" ("id_unidad");

ALTER TABLE "accesosUnidades" ADD FOREIGN KEY ("expediente") REFERENCES "expedientes" ("matricula");

ALTER TABLE "pacientes" ADD FOREIGN KEY ("matricula") REFERENCES "expedientes" ("matricula");

ALTER TABLE "ficha_sesion" ADD FOREIGN KEY ("matricula") REFERENCES "expedientes" ("matricula");

ALTER TABLE "ficha_sesion" ADD FOREIGN KEY ("id_problematica") REFERENCES "problematicas" ("id_problematica");

ALTER TABLE "ficha_sesion" ADD FOREIGN KEY ("id_responsable") REFERENCES "usuarios" ("matricula_empleado");

ALTER TABLE "ficha_sesion" ADD FOREIGN KEY ("documento") REFERENCES "documentos" ("id_documento");

ALTER TABLE "ficha_canalizacion" ADD FOREIGN KEY ("matricula") REFERENCES "expedientes" ("matricula");

ALTER TABLE "ficha_canalizacion" ADD FOREIGN KEY ("documento") REFERENCES "documentos" ("id_documento");

ALTER TABLE "carreras" ADD FOREIGN KEY ("id_unidad") REFERENCES "unidad_academica" ("id_unidad");

ALTER TABLE "solicitudes" ADD FOREIGN KEY ("expediente") REFERENCES "expedientes" ("matricula");

ALTER TABLE "solicitudes" ADD FOREIGN KEY ("unidad_solicitante") REFERENCES "unidad_academica" ("id_unidad");
