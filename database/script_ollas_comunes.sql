-- ========================================================
-- SCRIPT DE BASE DE DATOS: RED COMUNITARIA DE OLLAS
-- Ejecutar todo este script en MySQL Workbench
-- ========================================================

-- 1. Creamos la base de datos y la ponemos en uso
CREATE DATABASE IF NOT EXISTS sistema_ollas_comunes;
USE sistema_ollas_comunes;

-- 2. Tabla central de Usuarios (Admin, Lideresa, Donador, Beneficiario)
CREATE TABLE IF NOT EXISTS Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    rol ENUM('ADMIN', 'LIDERESA', 'DONADOR') NOT NULL,
    telefono VARCHAR(20),
    dni VARCHAR(15) UNIQUE,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Ollas Comunes (Perfil de la organización)
CREATE TABLE IF NOT EXISTS Olla_Comun (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL, -- La lideresa a cargo
    nombre_olla VARCHAR(150) NOT NULL,
    descripcion TEXT,
    direccion VARCHAR(255) NOT NULL,
    beneficiarios_atendidos INT DEFAULT 0,
    estado ENUM('ACTIVA', 'PAUSADA', 'INACTIVA') DEFAULT 'ACTIVA',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- 4. TABLA SOLICITUD (Lo que la lideresa pide cuando hay escasez)
CREATE TABLE Solicitud (
    id INT AUTO_INCREMENT PRIMARY KEY,
    olla_id INT NOT NULL,
    recurso_necesitado VARCHAR(100) NOT NULL,
    cantidad_necesitada DECIMAL(10,2) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    nivel_urgencia VARCHAR(20) DEFAULT 'Normal', -- Valores: Normal, Alta, Crítica
    estado VARCHAR(20) DEFAULT 'Pendiente',      -- Valores: Pendiente, Completada
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (olla_id) REFERENCES Olla_Comun(id) ON DELETE CASCADE
);

-- 5. TABLA DONACION (El aporte que registra el donador)
CREATE TABLE Donacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donador_id INT NOT NULL,
    olla_id INT NOT NULL,
    mensaje VARCHAR(255),                  -- Ej: "Llevo 2 sacos de arroz el viernes"
    estado VARCHAR(20) DEFAULT 'Pendiente',-- Valores: Pendiente, Aceptada, Entregada
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donador_id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (olla_id) REFERENCES Olla_Comun(id) ON DELETE CASCADE
);

CREATE TABLE recurso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    olla_id INT NULL,
    nombre_recurso VARCHAR(100) NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (olla_id) REFERENCES Olla_Comun(id) ON DELETE CASCADE
);



-- ========================================================
-- SCRIPT DE BASE DE DATOS: RED COMUNITARIA DE OLLAS (DATOS RANDOM)
-- Ejecutar todo este script en MySQL Workbench
-- ========================================================


USE sistema_ollas_comunes;

-- ========================================================
-- 0. LIMPIEZA TOTAL: Borramos datos y reiniciamos IDs a 1
-- ========================================================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Donacion;
TRUNCATE TABLE Solicitud;
TRUNCATE TABLE Olla_Comun;
TRUNCATE TABLE Usuario;
SET FOREIGN_KEY_CHECKS = 1;

-- ========================================================
-- 1. INSERTAR ADMIN (Se le asignará el ID 1)
-- ========================================================
INSERT INTO Usuario (email, password_hash, nombres, apellidos, rol, telefono, dni) VALUES
('admin@redcomunitaria.com', '123456', 'Fabrizzio', 'Admin', 'ADMIN', '999999999', '00000000');

-- ========================================================
-- 2. INSERTAR 15 LIDERESAS (Se les asignarán los IDs del 2 al 16)
-- ========================================================
INSERT INTO Usuario (email, password_hash, nombres, apellidos, rol, telefono, dni) VALUES
('maria.g@email.com', '123456', 'María', 'García', 'LIDERESA', '987654321', '11111111'),
('carmen.l@email.com', '123456', 'Carmen', 'López', 'LIDERESA', '987654322', '22222222'),
('rosa.m@email.com', '123456', 'Rosa', 'Martínez', 'LIDERESA', '987654323', '33333333'),
('ana.p@email.com', '123456', 'Ana', 'Pérez', 'LIDERESA', '987654324', '44444444'),
('luz.r@email.com', '123456', 'Luz', 'Rodríguez', 'LIDERESA', '987654325', '55555555'),
('julia.s@email.com', '123456', 'Julia', 'Sánchez', 'LIDERESA', '987654326', '66666666'),
('marta.r@email.com', '123456', 'Marta', 'Ramírez', 'LIDERESA', '987654327', '77777777'),
('elena.c@email.com', '123456', 'Elena', 'Cruz', 'LIDERESA', '987654328', '88888888'),
('juana.g@email.com', '123456', 'Juana', 'Gómez', 'LIDERESA', '987654329', '99999999'),
('teresa.f@email.com', '123456', 'Teresa', 'Flores', 'LIDERESA', '987654310', '10101010'),
('silvia.d@email.com', '123456', 'Silvia', 'Díaz', 'LIDERESA', '987654311', '11011011'),
('gladys.t@email.com', '123456', 'Gladys', 'Torres', 'LIDERESA', '987654312', '12121212'),
('norma.r@email.com', '123456', 'Norma', 'Ríos', 'LIDERESA', '987654313', '13131313'),
('doris.r@email.com', '123456', 'Doris', 'Reyes', 'LIDERESA', '987654314', '14141414'),
('blanca.m@email.com', '123456', 'Blanca', 'Morales', 'LIDERESA', '987654315', '15151515');

-- ========================================================
-- 3. INSERTAR 5 DONADORES (Se les asignarán los IDs del 17 al 21)
-- ========================================================
INSERT INTO Usuario (email, password_hash, nombres, apellidos, rol, telefono, dni) VALUES
('carlos.donador@email.com', '123456', 'Carlos', 'Mendoza', 'DONADOR', '911111111', '16161616'),
('juan.donador@email.com', '123456', 'Juan', 'Castillo', 'DONADOR', '922222222', '17171717'),
('luis.donador@email.com', '123456', 'Luis', 'Vargas', 'DONADOR', '933333333', '18181818'),
('jorge.donador@email.com', '123456', 'Jorge', 'Castro', 'DONADOR', '944444444', '19191919'),
('pedro.donador@email.com', '123456', 'Pedro', 'Gutiérrez', 'DONADOR', '955555555', '20202020');

-- ========================================================
-- 4. INSERTAR 15 OLLAS COMUNES
-- Usamos los IDs del 2 al 16 (las Lideresas) para la llave foránea
-- ========================================================
INSERT INTO Olla_Comun (usuario_id, nombre_olla, descripcion, direccion, beneficiarios_atendidos, estado) VALUES
(2, 'Olla Esperanza de Canto Grande', 'Brindamos menú diario a niños y adultos mayores.', 'Av. Canto Grande Paradero 10, SJL', 120, 'ACTIVA'),
(3, 'Olla Solidaria Zárate', 'Olla vecinal apoyando a familias vulnerables.', 'Jr. Chimu Mz. A Lt. 5, Zárate, SJL', 80, 'ACTIVA'),
(4, 'Olla San Juan Bautista', 'Apoyamos con almuerzos nutritivos de lunes a viernes.', 'Asentamiento Humano Huáscar, SJL', 150, 'ACTIVA'),
(5, 'Olla Corazón de Jesús', 'Comedor solidario autogestionado por madres de familia.', 'Mariscal Cáceres Sector 2, SJL', 95, 'ACTIVA'),
(6, 'Olla Las Madres de Campoy', 'Apoyo alimentario con cariño para nuestra zona.', 'Av. Principal de Campoy 123, SJL', 60, 'ACTIVA'),
(7, 'Olla Virgen del Carmen', 'Alimentando esperanzas y nutriendo futuros.', 'Bayóvar Paradero 5, SJL', 110, 'ACTIVA'),
(8, 'Olla Renacer', 'Luchando activamente contra la anemia infantil.', 'Caja de Agua Alta, SJL', 75, 'ACTIVA'),
(9, 'Olla La Fe de Jicamarca', 'Organización vecinal unidos por la olla.', 'Anexo 22 Jicamarca, SJL', 200, 'ACTIVA'),
(10, 'Olla Nueva Vida', 'Comida caliente y nutritiva para los vecinos.', 'Mangomarca Baja, SJL', 85, 'ACTIVA'),
(11, 'Olla El Buen Samaritano', 'Apoyo exclusivo a personas de la tercera edad.', 'Montenegro Paradero 3, SJL', 50, 'PAUSADA'),
(12, 'Olla Paz y Bien', 'Comunidad unida por la alimentación digna.', 'Av. Próceres de la Independencia cdra. 20, SJL', 130, 'ACTIVA'),
(13, 'Olla Señor de los Milagros', 'Trabajando juntas por la salud de nuestros hijos.', 'A.H. 10 de Octubre, SJL', 160, 'ACTIVA'),
(14, 'Olla Luz de Esperanza', 'Nadie se queda sin comer en nuestra zona.', 'Canto Rey Paradero 4, SJL', 90, 'ACTIVA'),
(15, 'Olla Santa Rosa', 'Menús solidarios preparados a leña.', 'Urb. Los Pinos, SJL', 70, 'ACTIVA'),
(16, 'Olla Unidos por el Pueblo', 'Fuerza vecinal contra el hambre.', 'Av. Wiesse Paradero 8, SJL', 140, 'ACTIVA');

-- ========================================================
-- 5. INSERTAR SOLICITUDES DE AYUDA (14 Ejemplos)
-- ========================================================
INSERT INTO Solicitud (olla_id, recurso_necesitado, cantidad_necesitada, unidad_medida, nivel_urgencia, estado) VALUES
(1, 'Arroz', 50.00, 'kg', 'Alta', 'Pendiente'),
(1, 'Aceite vegetal', 10.00, 'litros', 'Crítica', 'Pendiente'),
(2, 'Fideos', 20.00, 'kg', 'Normal', 'Pendiente'),
(3, 'Lentejas', 30.00, 'kg', 'Alta', 'Aceptada'),
(4, 'Verduras variadas', 15.00, 'kg', 'Normal', 'Pendiente'),
(5, 'Azúcar rubia', 25.00, 'kg', 'Alta', 'Pendiente'),
(6, 'Pollo entero', 20.00, 'kg', 'Crítica', 'Pendiente'),
(8, 'Avena', 15.00, 'kg', 'Normal', 'Aceptada'),
(9, 'Papas', 100.00, 'kg', 'Alta', 'Pendiente'),
(11, 'Atún en lata', 50.00, 'unidades', 'Crítica', 'Pendiente'),
(12, 'Frijol canario', 40.00, 'kg', 'Normal', 'Rechazada'),
(13, 'Cebolla y Ajo', 10.00, 'kg', 'Normal', 'Pendiente'),
(14, 'Leche evaporada', 48.00, 'unidades', 'Alta', 'Aceptada'),
(15, 'Sal de cocina', 5.00, 'kg', 'Normal', 'Pendiente');

-- ========================================================
-- 6. INSERTAR DONACIONES (10 Ejemplos)
-- Usamos los IDs del 17 al 21 (Donadores)
-- ========================================================
INSERT INTO Donacion (donador_id, olla_id, mensaje, estado) VALUES
(17, 1, 'ALIMENTOS: 50.0 kg. Nota: Llevo un saco de arroz costeño para mañana.', 'Aceptada'),
(17, 2, 'ALIMENTOS: 20.0 kg. Nota: 2 paquetes grandes de fideos don vitorio.', 'Pendiente'),
(17, 3, 'ALIMENTOS: 15.0 litros. Nota: Aceite primor en botellas de litro.', 'Aceptada'),
(18, 6, 'ALIMENTOS: 20.0 kg. Nota: Coordiné con la avícola para dejarles los pollos limpios.', 'Pendiente'),
(18, 8, 'ALIMENTOS: 15.0 kg. Nota: Avena quaker tradicional para los desayunos.', 'Aceptada'),
(19, 9, 'ALIMENTOS: 100.0 kg. Nota: 2 costales de papa canchán recién cosechada.', 'Rechazada'),
(19, 11, 'ALIMENTOS: 48.0 unidades. Nota: Conservas de atún florida en trozos.', 'Aceptada'),
(19, 4, 'UTENSILIOS: 5.0 unidades. Nota: Llevo 5 ollones de aluminio grandes N° 50.', 'Pendiente'),
(21, 14, 'ALIMENTOS: 48.0 unidades. Nota: Una caja de leche gloria en tarro.', 'Aceptada'),
(21, 1, 'HIGIENE: 10.0 litros. Nota: Lejía y jabón líquido sapolio para limpieza.', 'Pendiente');

