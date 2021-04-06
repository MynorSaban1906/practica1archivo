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


