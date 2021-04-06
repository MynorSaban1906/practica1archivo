create database HospitalGVE;
USE HospitalGVE;

DROP DATABASE HospitalGVE;
CREATE TABLE Temporal (
  Id_Temporal INT not null auto_increment,  	
  NOMBRE_VICTIMA VARCHAR(45) NULL,
  APELLIDO_VICTIMA VARCHAR(45) NULL,
  DIRECCION_VICTIMA VARCHAR(45) NULL,
  FECHA_PRIMERA_SOSPECHA varchar(45) NULL,
  FECHA_CONFIRMACION varchar(45) NULL,
  FECHA_MUERTE varchar(45) NULL,
  ESTADO_VICTIMA VARCHAR(45) NULL,
  NOMBRE_ASOCIADO VARCHAR(45) NULL,
  APELLIDO_ASOCIADO VARCHAR(45) NULL,
  FECHA_CONOCIO varchar(45) NULL,
  CONTACTO_FISICO VARCHAR(45) NULL,
  FECHA_INICIO_CONTACTO varchar(45) NULL,
  FECHA_FIN_CONTACTO varchar(45) NULL,
  NOMBRE_HOSPITAL VARCHAR(45) NULL,
  DIRECCION_HOSPITAL VARCHAR(45) NULL,
  UBICACION_VICTIMA VARCHAR(45) NULL,
  FECHA_LLEGADA varchar(45) NULL,
  FECHA_RETIRO VARCHAR(45) NULL,
  TRATAMIENTO VARCHAR(45) NULL,
  EFECTIVIDAD varchar(5) null,
  FECHA_INICIO_TRATAMIENTO VARCHAR(45) NULL,
  FECHA_FIN_TRATAMIENTO VARCHAR(45) NULL,
  EFECTIVIDAD_EN_VICTIMA varchar(5) null,  
  PRIMARY KEY (Id_Temporal));

CREATE TABLE Hospital (
  idHospital INT not null auto_increment,
  NombreH VARCHAR(45) NULL,
  Ubicacion VARCHAR(45) NULL,
  PRIMARY KEY (idHospital));
          
CREATE TABLE Tratamiento (
  idTratamiento INT not null auto_increment,
  NombreT VARCHAR(45) NULL,
  Efectividad varchar(45) null,
  PRIMARY KEY (idTratamiento));
  
CREATE TABLE Victima (
  idVictima int not null AUTO_INCREMENT,
  NombreV VARCHAR(45) NOT NULL,
  ApellidoV VARCHAR(45) NOT NULL,
  DireccionV VARCHAR(45) NOT NULL,
  FechaSospecha Varchar(45)  NULL,
  FechaRegistro Varchar(45)  NULL,
  FechaMuerte varchar(45) NULL,
  EstadoVictima VARCHAR(45) null,
   PRIMARY KEY (idVictima));

CREATE TABLE Ubicacion (
  IdUbicacion INT not null auto_increment,  
  Direccion varchar(45) NOT null,
  FechaLlegadaV varchar(45) NULL,
  FechaSalidaV varchar(45) NULL,
  idVictima int not null,
    PRIMARY KEY (IdUbicacion),
	INDEX fk_ubicacion (idVictima ASC),
	CONSTRAINT fk_ubicacion
	FOREIGN KEY (idVictima)
    REFERENCES HospitalGVE.Victima (idVictima));

CREATE TABLE PersonasConocida (
  IdConocido INT not null auto_increment,
  NombreC VARCHAR(45) NULL,
  ApellidoC VARCHAR(45) NULL,
  FechaConocio varchar(45) NULL,
  PRIMARY KEY (IdConocido));
  
CREATE TABLE ContactoVictima (
  idContactoVictima INT not null auto_increment,
  ConocidoId int not NULL,
  VictimaId int not NULL,
  Tipo_Contacto VARCHAR(45) NULL,
  FechaHoraContactoI varchar(45) NULL,
  FechaHoraContactoF varchar(45) NULL,
  PRIMARY KEY (idContactoVictima),
  INDEX fk_ContactoVictima_PersonasConocidad1 (ConocidoId ASC),
  INDEX fk_ContactoVictima_Victima1 (VictimaId ASC),
  CONSTRAINT fk_ContactoVictima_PersonasConocidad1
    FOREIGN KEY (ConocidoId)
    REFERENCES HospitalGVE.PersonasConocida (idConocido),
    CONSTRAINT fk_ContactoVictima_Victima1
    FOREIGN KEY (VictimaId)
    REFERENCES HospitalGVE.Victima (idVictima));

CREATE TABLE AsignaTratamiento (
  idAsignaTratamiento int not null auto_increment,
  idTratamiento INT not null,
  idVictima INT NOT NULL,
  FechaInicioT varchar(45) NULL,
  FechaFinT varchar(45) NULL,  
  EfectividadVictima varchar(45) null,
  PRIMARY KEY (idAsignaTratamiento),
  INDEX fk_Victima_has_Tratamiento_Tratamiento1 (idVictima ASC),
  INDEX fk_Victima_has_Tratamiento_Victima1 (idTratamiento ASC),
  CONSTRAINT fk_Victima_has_Tratamiento_Victima1
    FOREIGN KEY (idTratamiento)
    REFERENCES HospitalGVE.Tratamiento (idTratamiento),
    CONSTRAINT fk_Victima_has_Tratamiento_Tratamiento1
    FOREIGN KEY (idVictima)
    REFERENCES HospitalGVE.Victima (idVictima));
    
CREATE TABLE AsignaHospital (
  VictimaId INT not null,
  HospitalId INT NOT NULL,
  FechaIngreso varchar(45) NULL,
  FechaRetiro varchar(45) NULL,
  PRIMARY KEY (VictimaId, HospitalId),
  INDEX fk_Victima_has_Hospital_Hospital1_idx (HospitalId ASC),
  INDEX fk_Victima_has_Hospital_Victima1_idx (VictimaId ASC),
  CONSTRAINT fk_Victima_has_Hospital_Victima1
    FOREIGN KEY (VictimaId)
    REFERENCES HospitalGVE.Victima (idVictima),
    CONSTRAINT fk_Victima_has_Hospital_Hospital1
    FOREIGN KEY (HospitalId)
    REFERENCES HospitalGVE.Hospital (idHospital));
    
CREATE TABLE AsignaConocidos (
  VictimaId INT not null,
  PersonasConocidasId INT NOT NULL,
  PRIMARY KEY (VictimaId, PersonasConocidasId),
  INDEX fk_Victima_has_PersonasConocidad_PersonasConocidad1_idx (PersonasConocidasId ),
  INDEX fk_Victima_has_PersonasConocidad_Victima1_idx (VictimaId ),
  CONSTRAINT fk_Victima_has_PersonasConocidad_Victima1
    FOREIGN KEY (VictimaId)
    REFERENCES HospitalGVE.Victima (idVictima),
  CONSTRAINT fk_Victima_has_PersonasConocidad_PersonasConocidad1
    FOREIGN KEY (PersonasConocidasId)
    REFERENCES HospitalGVE.PersonasConocida (IdConocido));