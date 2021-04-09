
1. Mostrar el nombre del hospital, su dirección y el número de fallecidos por
cada hospital registrado


select a.HospitalId as IdHospital,h.NombreH as Hospital ,h.Ubicacion,count(a.VictimaId) as Pacientes_Fallecidos
from AsignaHospital as a  inner join Victima as v
on a.VictimaId=v.idVictima
inner join Hospital as h
on a.HospitalId=h.idHospital
where v.FechaMuerte!=''
group by a.HospitalId;


2. Mostrar el nombre, apellido de todas las víctimas en cuarentena que
presentaron una efectividad mayor a 5 en el tratamiento “Transfusiones de
sangre”.

SELECT v.NombreV,v.ApellidoV,v.EstadoVictima,a.EfectividadVictima,t.NombreT
	FROM AsignaTratamiento a
	INNER JOIN Victima v
	ON a.idVictima=v.idVictima
	INNER JOIN Tratamiento t
	ON t.idTratamiento= a.idTratamiento
    where v.EstadoVictima LIKE '%cuarentena%' and a.EfectividadVictima>5 and 
    t.NombreT='Transfusiones de sangre';


3. Mostrar el nombre, apellido y dirección de las víctimas fallecidas con más de
tres personas asociadas.

select distinct count(ac.PersonasConocidasId) as conocidos ,ac.VictimaId
from AsignaConocidos ac
inner join Victima v on v.idVictima=ac.VictimaId
where v.FechaMuerte!=''
group by ac.VictimaId
having conocidos>3


SELECT  v.NombreV,v.ApellidoV,v.DireccionV,count(a.VictimaId) as Asociados
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
    where v.FechaMuerte!=''
    group by (a.VictimaId)
    having Asociados>3 



   
SELECT distinct v.idVictima,v.NombreV,v.ApellidoV,v.DireccionV,count(a.ConocidoId) as asociados
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
    where v.FechaMuerte!=''
    group by (a.ConocidoId)
    having asociados>3



4. Mostrar el nombre y apellido de todas las víctimas en estado “Sospecha”
que tuvieron contacto físico de tipo “Beso” con más de 2 de sus asociados.

SELECT c.Tipo_Contacto, v.NombreV,v.ApellidoV,v.EstadoVictima,count(a.VictimaId) as Asociados
	FROM AsignaConocidos a
	INNER JOIN  Victima  v
	ON a.VictimaId=v.idVictima 
    INNER JOIN ContactoVictima  c
	ON c.VictimaId=v.idVictima and c.ConocidoId=a.PersonasConocidasId  
    where v.EstadoVictima='Sospecha' and c.Tipo_Contacto='Beso'
    group by (a.VictimaId)
    having Asociados>2 ;
    
select distinct count(ac.PersonasConocidasId) as conocidos ,ac.VictimaId ,v.NombreV,v.ApellidoV from AsignaConocidos ac
inner join Victima v on v.idVictima= ac.VictimaId
inner join ContactoVictima cv on cv.VictimaId= ac.VictimaId
where cv.Tipo_Contacto='Beso' and v.EstadoVictima='Sospecha'
group by ac.VictimaId,v.NombreV,v.ApellidoV
having conocidos>2
    

    



5. Top 5 de víctimas que más tratamientos se han aplicado del tratamiento
“Oxígeno”.

    
select v.NombreV,v.ApellidoV,T.NombreT,COUNT(T.NombreT) as NUMERO
FROM Victima v
INNER JOIN AsignaTratamiento a on a.idVictima=v.idVictima
INNER JOIN Tratamiento T on T.idTratamiento=a.idTratamiento
where T.NombreT='Oxígeno'
GROUP BY v.NombreV,v.ApellidoV,T.NombreT
LIMIT 5;
    
6. Mostrar el nombre, el apellido y la fecha de fallecimiento de todas las
víctimas que se movieron por la dirección “1987 Delphine Well” a los cuales
se les aplicó "Manejo de la presión arterial" como tratamiento.

SELECT distinct v.NombreV,v.ApellidoV,v.FechaMuerte,u.Direccion,t.NombreT
	FROM  (select idVictima,DireccionV,NombreV,ApellidoV,FechaMuerte
    from Victima where FechaMuerte!='')  v
	INNER JOIN Ubicacion u
	ON u.idVictima=v.idVictima
    INNER JOIN AsignaTratamiento a
	ON a.idVictima=v.idVictima
    INNER JOIN (select * from Tratamiento where NombreT='Manejo de la presión arterial') t
	ON t.idTratamiento=a.idTratamiento
    where u.Direccion='1987 Delphine Well' ;




7. Mostrar nombre, apellido y dirección de las víctimas que tienen menos de 2
allegados los cuales hayan estado en un hospital y que se le hayan aplicado
únicamente dos tratamientos.



select distinct count(ac.PersonasConocidasId) as conocidos ,ac.VictimaId, ah.HospitalId from AsignaConocidos ac
inner join AsignaHospital ah on ah.VictimaId=ac.VictimaId
group by ac.VictimaId, ah.HospitalId
having conocidos<3


select  count(idTratamiento) as Tratamientos from AsignaTratamiento
group by idVictima
having Tratamientos=2
    
SELECT  v.NombreV,v.ApellidoV,v.DireccionV,count(a.VictimaId) as Asociados
	FROM ContactoVictima a
	INNER JOIN  Victima v
	ON a.VictimaId=v.idVictima
	INNER JOIN  (SELECT  v.idVictima as VictimaId,count(a.idVictima) as numero
	FROM AsignaTratamiento a INNER JOIN  Victima v ON a.idVictima=v.idVictima
	INNER JOIN  AsignaHospital h ON h.VictimaId=v.idVictima
    group by a.idVictima having numero=2 ) h
	ON h.VictimaId=v.idVictima
	group by a.VictimaId
	having Asociados<2;
 
select v.NombreV,v.ApellidoV,v.DireccionV from ContactoVictima as cv
inner join Victima as v on cv.VictimaId=v.idVictima
inner join AsignaHospital as ah on ah.VictimaId=v.idVictima
where ( select count(*)
from AsignaConocidos ac
group by VictimaId
having ac.VictimaId=v.idVictima )=1
and (
	select count(*)
    from AsignaTratamiento t
    group by t.idVictima
    having t.idVictima=v.idVictima)=2
    group by v.NombreV,v.ApellidoV,v.DireccionV ;




8. Mostrar el número de mes ,de la fecha de la primera sospecha, nombre y
apellido de las víctimas que más tratamientos se han aplicado y las que
menos. (Todo en una sola consulta).


SELECT substring(v.FechaSospecha,6,2) as Mes_Primera_Sospecha,v.NombreV,v.ApellidoV,count(a.idTratamiento) as cantidad,min.CANT
	FROM Victima v
	INNER JOIN  AsignaTratamiento a
	ON  v.idVictima =a.idVictima
    INNER JOIN (select max(d.cantidad),d.tratamiento AS CANT from (
	SELECT count(a.idTratamiento),a.idTratamiento as tratamiento as cantidad
	FROM Victima v
	INNER JOIN  AsignaTratamiento a
	ON  v.idVictima =a.idVictima
    group by a.idVictima) as d) AS MIN
    min.CANT
    group by a.idVictima;


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
)b;
    
9. Mostrar el porcentaje de víctimas que le corresponden a cada hospital.



select a.HospitalId,h.NombreH,count(a.VictimaId)/(select sum(p.pacientes) from (select count(a.VictimaId) as pacientes
	from AsignaHospital as a 
	inner join Hospital as h
	on a.HospitalId=h.idHospital
	group by a.HospitalId) as p) as pacientes
	from AsignaHospital as a 
	inner join Hospital as h
	on a.HospitalId=h.idHospital
	group by a.HospitalId ;




10. Mostrar el porcentaje del contacto físico más común de cada hospital de la
siguiente manera: nombre de hospital, nombre del contacto físico, porcentaje
de víctimas.


select y.hospital,y.contacto ,MAX(y.cantidad) y.cantidad from (
select ah.HospitalId as hospital ,cv.Tipo_Contacto as contacto, count(cv.Tipo_Contacto) as cantidad
from ContactoVictima cv
inner join AsignaHospital ah on cv.VictimaId=ah.VictimaId
group by ah.HospitalId,cv.Tipo_Contacto 
) as y
group by  y.hospital,y.contacto 





select a.HospitalId,h.NombreH,count(a.VictimaId)/(
select sum(p.pacientes) from (select count(a.VictimaId) as pacientes
	from AsignaHospital as a 
	inner join Hospital as h
	on a.HospitalId=h.idHospital
	group by a.HospitalId) as p) as pacientes
	from AsignaHospital as a 
	inner join Hospital as h
	on a.HospitalId=h.idHospital
	group by a.HospitalId ;


Select Nombre, Contacto,Cantidad, Porcentaje from(
	select h.NombreH As Nombre,cv.Tipo_Contacto as Contacto, Count(*) as Cantidad,
		concat(
			round(
			(count(*)/(select count(*)from AsignaHospital
				inner join Victima v on AsignaHospital.VictimaId=v.idVictima
                inner join Hospital h on h.idHospital=AsignaHospital.HospitalId
                inner join ContactoVictima cv on cv.VictimaId=v.idVictima)*100),2),"%"
                ) as Porcentaje
                from AsignaHospital ah
                inner join Victima v on ah.VictimaId=v.idVictima
                inner join Hospital h on h.idHospital= ah.HospitalId
                inner join ContactoVictima cv on cv.VictimaId= ah.VictimaId
                group by h.idHospital,cv.Tipo_contacto
                order by Cantidad desc
                ) as Victimas
                group by (Nombre);

