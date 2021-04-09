const express = require('express')
const app = express()

//CONEXION A MYSQL 
const  mysql = require('mysql');
let connection = mysql.createConnection({
   multipleStatements:true,
   host: 'localhost',
   user: 'root',
   password: '1234',
   database: 'HospitalGVE',
   port: 3306
});
//SENTENCIA PARA EL MODELO
const modelsql=`CREATE TABLE Hospital (
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

    insert into Victima (NombreV,ApellidoV,DireccionV,FechaSospecha,FechaRegistro,FechaMuerte,EstadoVictima)
    select distinct NOMBRE_VICTIMA,APELLIDO_VICTIMA,DIRECCION_VICTIMA,FECHA_PRIMERA_SOSPECHA,
    FECHA_CONFIRMACION,FECHA_MUERTE,ESTADO_VICTIMA from Temporal;


  insert into Ubicacion (Direccion,FechaLlegadaV,FechaSalidaV,idVictima)
    select distinct UBICACION_VICTIMA,FECHA_LLEGADA,FECHA_RETIRO,v.idVictima from Temporal 
      INNER JOIN Victima v
          ON concat(v.NombreV,v.ApellidoV) =concat(NOMBRE_VICTIMA,APELLIDO_VICTIMA);
          
          
  insert into Hospital (NombreH,Ubicacion)
	select distinct NOMBRE_HOSPITAL,DIRECCION_HOSPITAL from Temporal;
    
  insert into Tratamiento (NombreT,Efectividad)
    select distinct TRATAMIENTO,EFECTIVIDAD from Temporal;
    

  insert into PersonasConocida (NombreC,ApellidoC,FechaConocio)
	select distinct NOMBRE_ASOCIADO,APELLIDO_ASOCIADO,FECHA_CONOCIO  from Temporal;

  insert into AsignaTratamiento (idTratamiento,idVictima,FechaInicioT,FechaFinT,EfectividadVictima)
    SELECT distinct m.idTratamiento,v.idVictima,t.FECHA_INICIO_TRATAMIENTO,t.FECHA_FIN_TRATAMIENTO,
      EFECTIVIDAD_EN_VICTIMA
      FROM Temporal t
      INNER JOIN Victima v
          ON concat(v.NombreV,v.ApellidoV) =concat(t.NOMBRE_VICTIMA,t.APELLIDO_VICTIMA)
      INNER JOIN Tratamiento m
      ON m.NombreT = t.TRATAMIENTO;
		

  insert into AsignaConocidos
    SELECT distinct v.idVictima ,p.IdConocido
      FROM Victima v
      INNER JOIN Temporal t
      ON concat(v.NombreV,v.ApellidoV) = concat(t.NOMBRE_VICTIMA,t.APELLIDO_VICTIMA)
      INNER JOIN PersonasConocida p
      ON concat(p.NombreC,p.ApellidoC) =concat(t.NOMBRE_ASOCIADO,t.APELLIDO_ASOCIADO);


  insert into AsignaHospital(VictimaId,HospitalId,FechaIngreso)
	SELECT distinct v.idVictima,h.idHospital,t.FECHA_CONFIRMACION
      FROM Temporal t
      INNER JOIN Victima v
          ON concat(v.NombreV,v.ApellidoV) =concat(t.NOMBRE_VICTIMA,t.APELLIDO_VICTIMA)
      INNER JOIN Hospital h
      ON h.NombreH = t.NOMBRE_HOSPITAL;  


  insert into ContactoVictima(ConocidoId,VictimaId,Tipo_Contacto,FechaHoraContactoI,FechaHoraContactoF)
    SELECT distinct p.IdConocido,v.idVictima ,t.CONTACTO_FISICO,
            t.FECHA_INICIO_CONTACTO,t.FECHA_FIN_CONTACTO
      FROM Victima v
      INNER JOIN Temporal t
      ON concat(v.NombreV,v.ApellidoV) = concat(t.NOMBRE_VICTIMA,t.APELLIDO_VICTIMA)
      INNER JOIN PersonasConocida p
      ON concat(p.NombreC,p.ApellidoC) =concat(t.NOMBRE_ASOCIADO,t.APELLIDO_ASOCIADO);

`;
// CREA EL MODELO EN MYSQL
app.get('/crearModelo', function (req, res) {
  
    
    var consulta =connection.query(modelsql, function (err, result) {
      if (err) throw err;
      console.log("Table created");
    });


  })
  
  


// carga masiva
app.get('/cargaTemporal', function (req, res) {
    const sentencia =`
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
    
      LOAD  DATA  INFILE '/var/lib/mysql-files/GRAND_VIRUS_EPICENTER.csv' 
    into table  Temporal
	  fields terminated by ';'
    lines terminated by '\n'
    ignore 1 lines
    (NOMBRE_VICTIMA,APELLIDO_VICTIMA,DIRECCION_VICTIMA,FECHA_PRIMERA_SOSPECHA,
      FECHA_CONFIRMACION,FECHA_MUERTE,ESTADO_VICTIMA,NOMBRE_ASOCIADO,APELLIDO_ASOCIADO,	
      FECHA_CONOCIO,CONTACTO_FISICO,FECHA_INICIO_CONTACTO,FECHA_FIN_CONTACTO,	
      NOMBRE_HOSPITAL,DIRECCION_HOSPITAL,UBICACION_VICTIMA,FECHA_LLEGADA,FECHA_RETIRO,
      TRATAMIENTO,EFECTIVIDAD,FECHA_INICIO_TRATAMIENTO,FECHA_FIN_TRATAMIENTO,EFECTIVIDAD_EN_VICTIMA);
`;
  
connection.query(sentencia, function (err, data) {
  res.json({
    err,
    result:data
  })
  console.log("se cargo EL ARCHIVO");
})
   
 })

//local host inicio
app.get('/', function (req, res) {   
  res.send('Mynor Alison Isai saban CHe     201800516')
})


//borrar el modelo 
app.get('/eliminarModelo', async function (req, res) {
  var sql =`DROP TABLE Hospital;
            DROP TABLE Ubicacion;
            DROP TABLE Tratamiento;
            DROP TABLE Victima;
            DROP TABLE PersonasConocida;
            DROP TABLE ContactoVictima;
            DROP TABLE AsignaTratamiento;
            DROP TABLE AsignaHospital;
            DROP TABLE AsignaConocidos;`;
  connection.query(sql,async function(error, result){
      if(error){  
          console.log("Error al conectar");
      
      }else{    
          res.send("elminada");
      }
  }
  );
 
})

//borrar el modelo 
app.get('/eliminarTemporal', async function (req, res) {
  var sql =`DROP TABLE Temporal`;
  connection.query(sql,async function(error, result){
      if(error){  
          console.log("Error al conectar");
      
      }else{    
          res.send("elminada");
      }
  }
  );
 
})
 

// CONSULTA 1
app.get('/consulta1', async function (req, res) {
  var sql =`select a.HospitalId as IdHospital,h.NombreH as Hospital ,h.Ubicacion,count(a.VictimaId) as Pacientes_Fallecidos
    from AsignaHospital as a  inner join Victima as v
    on a.VictimaId=v.idVictima
    inner join Hospital as h
    on a.HospitalId=h.idHospital
    where v.FechaMuerte!=''
    group by a.HospitalId;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 1 ejecutada");
    })
       
 
})
 
// CONSULTA 2
app.get('/consulta2', async function (req, res) {
  var sql =`SELECT v.NombreV,v.ApellidoV,v.EstadoVictima,a.EfectividadVictima,t.NombreT
	FROM AsignaTratamiento a
	INNER JOIN Victima v
	ON a.idVictima=v.idVictima
	INNER JOIN Tratamiento t
	ON t.idTratamiento= a.idTratamiento
    where v.EstadoVictima LIKE '%cuarentena%' and a.EfectividadVictima>5 and 
    t.NombreT='Transfusiones de sangre';
`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("Consulta 2 ejecutada");
    })
       
 
})

// CONSULTA 3
app.get('/consulta3', async function (req, res) {
  var sql =`SELECT  v.NombreV,v.ApellidoV,v.DireccionV,count(a.VictimaId) as Asociados
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
    where v.FechaMuerte!=''
    group by (a.VictimaId)
    having Asociados>3 ;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 3 ejecutada duda salen 493");
    })
       
 
})

// CONSULTA 4
app.get('/consulta4', async function (req, res) {
  var sql =`SELECT c.Tipo_Contacto, v.NombreV,v.ApellidoV,v.EstadoVictima,count(a.VictimaId) as Asociados
	FROM AsignaConocidos a
	INNER JOIN  Victima  v
	ON a.VictimaId=v.idVictima 
    INNER JOIN ContactoVictima  c
	ON c.VictimaId=v.idVictima and c.ConocidoId=a.PersonasConocidasId  
    where v.EstadoVictima='Sospecha' and c.Tipo_Contacto='Beso'
    group by (a.VictimaId)
    having Asociados>2 ;
    ;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("Consulta 4 ejecutada duda");
    })
       
 
})

// CONSULTA 5
app.get('/consulta5', async function (req, res) {
  var sql =`select v.NombreV,v.ApellidoV,T.NombreT,COUNT(T.NombreT) as NUMERO
  FROM Victima v
  INNER JOIN AsignaTratamiento a on a.idVictima=v.idVictima
  INNER JOIN Tratamiento T on T.idTratamiento=a.idTratamiento
  where T.NombreT='Oxígeno'
  GROUP BY v.NombreV,v.ApellidoV,T.NombreT
  LIMIT 5;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 5 ejecutada");
    })
       
 
})

// CONSULTA 6
app.get('/consulta6', async function (req, res) {
  var sql =`SELECT distinct v.NombreV,v.ApellidoV,v.FechaMuerte,u.Direccion,t.NombreT
	FROM  (select idVictima,DireccionV,NombreV,ApellidoV,FechaMuerte
    from Victima where FechaMuerte!='')  v
	INNER JOIN Ubicacion u
	ON u.idVictima=v.idVictima
    INNER JOIN AsignaTratamiento a
	ON a.idVictima=v.idVictima
    INNER JOIN (select * from Tratamiento where NombreT='Manejo de la presión arterial') t
	ON t.idTratamiento=a.idTratamiento
    where u.Direccion='1987 Delphine Well' ;
`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 6 ejecutada");
    })
       
 
})

// CONSULTA 7
app.get('/consulta7', async function (req, res) {
  var sql =`select v.NombreV,v.ApellidoV,v.DireccionV,count(distinct a.IdConocido) as asociados
  from Victima as v
  inner join ContactoVictima as cv on cv.VictimaId=v.idVictima
  inner join PersonasConocida as a on a.IdConocido=cv.ConocidoId
  inner join AsignaTratamiento as att on att.idVictima=v.idVictima
  inner join Tratamiento as t on t.idTratamiento=att.idTratamiento
  inner join AsignaHospital as ah on ah.VictimaId=v.idVictima
  inner join Hospital as h on h.idHospital=ah.HospitalId 
  WHERE h.NombreH!=''
  group by v.NombreV,v.ApellidoV,v.DireccionV
  having count(distinct cv.ConocidoId)<2 and count(distinct t.idTratamiento)=2
  order by v.NombreV;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 7 ejecutada no muestra resultado");
    })
       
 
})

// CONSULTA 8
app.get('/consulta8', async function (req, res) {
  var sql =`
  SELECT * FROM(
  select v.NombreV,v.ApellidoV,v.FechaSospecha,substring(v.FechaSospecha,6,2) as mes_primera_sospecha,count(att.idTratamiento)as nTRatamiento 
  from Tratamiento as t
  inner join AsignaTratamiento att on att.idTratamiento=t.idTratamiento
  inner join Victima v on v.idVictima=att.idVictima
  group by v.NombreV,v.ApellidoV,v.FechaSospecha
  order by nTRatamiento DESC
  LIMIT 5
  )a
  union all 
  select * from (
  select v.NombreV,v.ApellidoV,v.FechaSospecha,substring(v.FechaSospecha,6,2) as mes_primera_sospecha,count(att.idTratamiento)as nTRatamiento 
  from Tratamiento as t
  inner join AsignaTratamiento att on att.idTratamiento=t.idTratamiento
  inner join Victima v on v.idVictima=att.idVictima
  group by v.NombreV,v.ApellidoV,v.FechaSospecha
  order by nTRatamiento asc
  LIMIT 5
  )b;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 8 ejecutada");
    })
       
 
})

// CONSULTA 9
app.get('/consulta9', async function (req, res) {
  var sql =`select a.HospitalId,h.NombreH,count(a.VictimaId)/(select sum(p.pacientes) from (select count(a.VictimaId) as pacientes
  from AsignaHospital as a 
  inner join Hospital as h
  on a.HospitalId=h.idHospital
  group by a.HospitalId) as p) as pacientes
  from AsignaHospital as a 
  inner join Hospital as h
  on a.HospitalId=h.idHospital
  group by a.HospitalId ;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 9 ejecutada");
    })
       
 
})

// CONSULTA 10
app.get('/consulta10', async function (req, res) {
  var sql =`select a.HospitalId as IdHospital,h.NombreH as Hospital,count(a.VictimaId) as Pacientes_En_Hospital
  from AsignaHospital as a  inner join Victima as v
  on a.VictimaId=v.idVictima
  inner join Hospital as h
  on a.HospitalId=h.idHospital
  where v.FechaMuerte=''
  group by a.HospitalId;`;

    connection.query(sql, function (err, data) {
      res.json({
        err,
        result:data
      })
      console.log("COnsulta 10 ejecutada incompleta" );
    })
       
 
})

app.listen( 3000, (err) => {
    console.log('Server running on port ' + (3000))
});
